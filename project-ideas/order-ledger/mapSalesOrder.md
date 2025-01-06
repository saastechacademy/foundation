### map#SalesOrder
1. Service Parameters
    * Input
        * shopifyOrder (Map)
        * shopId
    * Output
        * order
2. Check in ShopifyShopOrder if an OMS order already exists, if yes return.
3. Initialize order map
4. Set productStore = ProductStore for shopId
5. Prepare order map
    * order.externalId = shopifyOrder.id
    * order.orderName = shopifyOrder.name
    * order.salesChannelEnumId = get ShopifyShopTypeMapping for shopifyOrder.channelInformation.channelDefinition.handle
    * order.orderDate = shopifyOrder.createdAt
    * order.currencyUom = uomId where Uom.uomTypeId=CURRENCY_MEASURE and uom.abbreviation = shopifyOrder.currencyCode
    * order.presentmentCurrencyUom = uomId where Uom.uomTypeId=CURRENCY_MEASURE and uom.abbreviation = shopifyOrder.presentmentCurrencyCode
    * order.grandTotal = shopifyOrder.totalPriceSet.presentmentMoney.amount
    * order.remainingSubTotal = shopifyOrder.currentTotalPriceSet.presentmentMoney.amount
    * order.statusId
        * Defaults to "ORDER_CREATED"
        * If shopifyOrder.displayFulfillmentStatus="FULFILLED", set as "ORDER_COMPLETED"
        * If shopifyOrder.cancelledAt is not null, set as "ORDER_CANCELLED"
    * order.attributes = Iterate through shopifyOrder.customAttributes if not null and add to list [attrName:shopifyOrder.customAttributes.key, attrValue:shopifyOrder.customAttributes.value]
    * order.shipToAddress = [toName:shopifyOrder.shippingAddress.name, address1:shopifyOrder.shippingAddress.address1, address2:shopifyOrder.shippingAddress.address2, city:shopifyOrder.shippingAddress.city, postalCode:shopifyOrder.shippingAddress.zip, stateProvinceGeoId:geoId where shopifyOrder.shippingAddress.provinceCode=Geo.geoCode, countryGeoId:geoId where shopifyOrder.shippingAddress.countryCodeV2=Geo.geoCode, latitude:shopifyOrder.shippingAddress.latitude, longitude:shopifyOrder.shippingAddress.longitude]
    * order.shipToPhone = shopifyOrder.shippingAddress.phone
    * If "SAVE_BILL_TO_INF" setting in ProductStoreSetting is "Y"
        * order.billToAddress = [toName:shopifyOrder.billingAddress.name, address1:shopifyOrder.billingAddress.address1, address2:shopifyOrder.billingAddress.address2, city:shopifyOrder.billingAddress.city, postalCode:shopifyOrder.billingAddress.zip, stateProvinceGeoId:geoId where shopifyOrder.billingAddress.provinceCode=Geo.geoCode, countryGeoId:geoId where shopifyOrder.billingAddress.countryCodeV2=Geo.geoCode, latitude:shopifyOrder.billingAddress.latitude, longitude:shopifyOrder.billingAddress.longitude]
        * order.billToPhone = shopifyOrder.billingAddress.phone
    * order.customer = [externalId:shopifyOrder.customer.id, firstName:shopifyOrder.customer.firstName, lastName:shopifyOrder.customer.lastName, dataSourceId:"SHOPIFY", email:shopifyOrder.customer.email]
    * order.productStoreId = ProductStore.productStoreId
    * order.email = shopifyOrder.email
    * order.shopifyShopOrder = [shopId:shopId, shopifyOrderId:shopifyOrder.id]
    * order.adjustments
        * Iterate through shopifyOrder.shippingLines
            * If shopifyOrder.shippingLines.originalPriceSet.presentmentMoney.amount > 0   
               * Add to order.adjustments list [orderAdjustmentTypeId:"SHIPPING_CHARGES", amount:shopifyOrder.shippingLines.originalPriceSet.presentmentMoney.amount, comments:shopifyOrder.shippingLines.title]
            * Iterate through shopifyOrder.shippingLines.taxLines
              * If shopifyOrder.shippingLines.taxLines.priceSet.presentmentMoney.amount > 0
                  * Add to order.adjustments list [orderAdjustmentTypeId:"SHIPPING_SALES_TAX", amount:taxAmount, sourcePercentage:shopifyOrder.shippingLines.taxLines.ratePercentage, comments:shopifyOrder.shippingLines.taxLines.title]
            * Iterate through shopifyOrder.shippingLines.discountAllocations
                * Set shippingDiscountAdjustment = [orderAdjustmentTypeId:"EXT_PROMO_ADJUSTMENT", amount:(shopifyOrder.shippingLines.discountAllocations.allocatedAmountSet.presentmentMoney.amount).negate(), comments:"External Discount"]
                * If shopifyOrder.shippingLines.discountAllocations.discountCodeApplication exists
                    * Set shippingDiscountAdjustment.attributes (List) = [[attrName:"DISCOUNT_CODE", attrValue:shopifyOrder.shippingLines.discountAllocations.discountCodeApplication.discountCodeApplication.code]]
                    * If shopifyOrder.shippingLines.discountAllocations.discountCodeApplication.pricingPercentageValue exists
                       * Set shippingDiscountAdjustment.sourcePercentage = shopifyOrder.shippingLines.discountAllocations.discountCodeApplication.pricingPercentageValue.percentage
                * Add shippingDiscountAdjustment to order.adjustments list
        * If shopifyOrder.totalTipReceivedSet.presentmentMoney.amount > 0
            * Add to order.adjustments list [orderAdjustmentTypeId:"DONATION_ADJUSTMENT", amount:shopifyOrder.totalTipReceivedSet.presentmentMoney.amount, comments:"Tip"]
    * order.shipGroups
        * Iterate through each shopifyOrder.fulfillmentOrders
            * Prepare shipGroup Map
                * shipGroup.shipmentMethodTypeId
                    * Set ShopifyShopTypeMapping for shopifyOrder.fulfillmentOrders.deliveryMethod
                    * If shopifyOrder.fulfillmentOrders.deliveryMethod.methodType="SHIPPING", set from ShopifyShopCarrierShipment for shopifyOrder.fulfillmentOrders.deliveryMethod.serviceCode
                * shipGroup.carrierPartyId = defaults to _NA_, if shopifyOrder.fulfillmentOrders.deliveryMethod.methodType="SHIPPING", set from ShopifyShopCarrierShipment for shopifyOrder.fulfillmentOrders.deliveryMethod.serviceCode
                * shipGroup.facilityId = set to _NA_ if shopifyOrder.fulfillmentOrders.deliveryMethod.methodType="SHIPPING" and shopifyOrder.fulfillmentOrders.status!="CLOSED", else set from ShopifyShopLocation for shopifyOrder.fulfillmentOrders.assignedLocation.location.id
                * shipGroup.maySplit = defaults to Y, set from ProductStore.allowSplit
                * shipGroup.items = iterate through shopifyOrder.fulfillmentOrders.lineItems and perform following
                    * Get productIdentifierEnumId from ProductStore associated to shopId, based on returned value set productIdentifier = shopifyOrder.fulfillmentOrders.lineItems.lineItem.variant.id OR shopifyOrder.fulfillmentOrders.lineItems.lineItem.sku OR shopifyOrder.fulfillmentOrders.lineItems.lineItem.variant.barcode
                    * Initialize orderItemAttributes list
                        * Iterate through shopifyOrder.fulfillmentOrders.lineItems.lineItem.customAttributes
                            * Add [attrName:shopifyOrder.fulfillmentOrders.lineItems.lineItem.customAttributes.key, attrValue:shopifyOrder.fulfillmentOrders.lineItems.lineItem.customAttributes.value]
                    * Initialize orderAdjustments list
                        * Iterate through shopifyOrder.fulfillmentOrders.lineItems.lineItem.taxLines
                            * Calculate tax amount for exploded order items, taxAmount = shopifyOrder.fulfillmentOrders.lineItems.taxLines.priceSet.presentmentMoney.amount / shopifyOrder.fulfillmentOrders.lineItems.lineItem.quantity
                            * Add following map to orderAdjustments list - [orderAdjustmentTypeId:"SALES_TAX", amount:taxAmount, sourcePercentage:shopifyOrder.fulfillmentOrders.lineItems.taxLines.ratePercentage, comments:shopifyOrder.fulfillmentOrders.lineItems.taxLines.title]
                        * Iterate through shopifyOrder.fulfillmentOrders.lineItems.linetItem.discountAllocations
                            * Calculate discount amount for exploded order items, discountAmount = shopifyOrder.fulfillmentOrders.lineItems.linetItem.discountAllocations.allocatedAmountSet.presentmentMoney.amount / shopifyOrder.fulfillmentOrders.lineItems.lineItem.quantity
                            * Set discountAdjustment = [orderAdjustmentTypeId:"EXT_PROMO_ADJUSTMENT", amount:discountAmount.negate(), comments:"External Discount"]
                            * If shopifyOrder.fulfillmentOrders.lineItems.linetItem.discountAllocations.discountCodeApplication
                                * Set discountAdjustment.attributes (List) = [[attrName:"DISCOUNT_CODE", attrValue:shopifyOrder.fulfillmentOrders.lineItems.linetItem.discountAllocations.discountCodeApplication.code]]
                                * If shopifyOrder.fulfillmentOrders.lineItems.linetItem.discountAllocations.discountCodeApplication.pricingPercentageValue
                                    * Set discountAdjustment.sourcePercentage = shopifyOrder.fulfillmentOrders.lineItems.linetItem.discountAllocations.discountCodeApplication.pricingPercentageValue.percentage
                            * Add discountAdjustment to orderAdjustments
                    * If shopifyOrder.fulfillmentOrders.lineItems.remainingQuantity > 0, iterate through remainingQuantity
                        * Set orderItem = [externalId:shopifyOrder.fulfillmentOrders.lineItems.lineItem.id, orderItemTypeId:"PRODUCT_ORDER_ITEM", productSku:productIdentifier, statusId: (if shopifyOrder.fulfillmentOrders.deliveryMethod=NONE then "ITEM_COMPLETED" else "ITEM_CREATED", isPromo:"N", quantity:1, unitPrice:shopifyOrder.fulfillmentOrders.lineItems.lineItem.originalUnitPriceSet.presentmentMoney.amount, itemDescription:shopifyOrder.fulfillmentOrders.lineItems.lineItem.variant.title]
                        * orderItem.attributes = orderItemAttributes
                        * orderItem.adjustments = orderAdjustments
                        * Add orderItem to order.items
                    * Set fulfilledQuantity = (shopifyOrder.fulfillmentOrders.lineItems.totalQuantity - shopifyOrder.fulfillmentOrders.lineItems.remainingQuantity), If fulfilledQuantity > 0, iterate through fulfilledQuantity and add following map to orderItems list
                        * Set orderItem = [externalId:shopifyOrder.fulfillmentOrders.lineItems.lineItem.id, orderItemTypeId:"PRODUCT_ORDER_ITEM", productSku:productIdentifier, statusId:"ITEM_COMPLETED", isPromo:"N", quantity:1, unitPrice:shopifyOrder.fulfillmentOrders.lineItems.lineItem.originalUnitPriceSet.presentmentMoney.amount, itemDescription:shopifyOrder.fulfillmentOrders.lineItems.lineItem.variant.title]
                        * orderItem.attributes = orderItemAttributes
                        * orderItem.adjustments = orderAdjustments
                        * Add orderItem to order.items
                    * If shopifyOrder.fulfillmentOrders.lineItems.lineItem.nonFulfillableQuantity > 0, iterate through nonFulfillableQuantity and add following map (We may need to enhance this logic to add only once for a fulfillmentOrder if same shopify order line item appears in multiple shipgroups which should possibly be a rare edge case)
                        * Set orderItem = [externalId:shopifyOrder.fulfillmentOrders.lineItems.lineItem.id, orderItemTypeId:"PRODUCT_ORDER_ITEM", productSku:productIdentifier, statusId:"ITEM_CANCELLED", isPromo:"N", quantity:1, cancelQuantity:1 unitPrice:shopifyOrder.fulfillmentOrders.lineItems.lineItem.originalUnitPriceSet.presentmentMoney.amount, itemDescription:shopifyOrder.fulfillmentOrders.lineItems.lineItem.variant.title]
                        * orderItem.attributes = orderItemAttributes
                        * orderItem.adjustments = orderAdjustments
                        * Add orderItem to order.items
                * Add shipGroup map to order.shipGroups list

