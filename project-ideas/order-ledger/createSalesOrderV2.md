# Shopify/OMS Order Sync Design

Newly created orders and specific order updates in Shopify needs to be synced timely to OMS. This design document is specific to syncing newly created Shopify orders.   
Following would be the flow to sync products,
1. **mantle-shopify-connector** would produce a periodic json feed of newly created orders.
2. **shopify-oms-bridge** would consume this feed and transform it to produce OMS orders json feed.
3. **oms** would consume the transformed product json feed and establish orders in OMS database via order API.

> Notes
> - Not setting origin facility contact mechs as it doesn't make sense for already completed or cancelled orders or until the order is brokered.
> - Designs reflect the assumption that order items will always be exploded.

> TODO
> - Support to create product if it doesn't exist
> - Support related to tips/donations

## Shopify Connector
Shopify connector would produce a periodic created orders feed since last run time with following fields,

## Shopify OMS Bridge

Periodically receive and consume ShopifyNewOrdersFeed and transform to generated OMSNewOrdersFeed.
Following are the implementation details,
1. Define and configure *ShopifyNewOrdersFeed* SystemMessageType to import Shopify new orders feed, define *consumeSmrId* SystemMessageType parameter to be used in the next system message produced in consume service. Refer *ShopifyOrderCancelUpdatesFeed* SystemMessageType.
2. Generic service *consume#ShopifyFeed* to be used as consume service for this flow.
3. Define and configure *GenerateOMSNewOrdersFeed* SystemMessageType, refer *GenerateOMSOrderCancelUpdatesFeed* SystemMessageType. Configure *sendSmrId* SystemMessageTypeParameter to send the feed to SFTP.
4. Implement sendService *generate#OMSNewOrdersFeed*, refer implementation details below.
5. Define and configure *SendOMSNewOrdersFeed* SystemMessageType to send the feed to SFTP.

### generate#OMSNewOrdersFeed
1. Fetch SystemMessage record
2. Fetch related SystemMessageRemote
3. Fetch shopId from SystemMessageRemote.remoteId
4. Get orders list from the file location in SystemMessage.messageText.
5. Initiate a local file for the json feed.
6. Iterate through orders list and for each shopifyOrder map call map#Order, refer implementation details below.
7. Write the order map if returned in service output to the file.
8. Close the file once the iteration is complete.
9. If *sendSmrId* SystemMessageTypeParameter is defined, queue *SendOMSNewOrdersFeed* SystemMessage.

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
4. Prepare order map
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
   * order.orderAttributes = Iterate through shopifyOrder.customAttributes if not null and add to list [attrName:shopifyOrder.customAttributes.key, attrValue:shopifyOrder.customAttributes.value]
   * order.shipToAddress = [toName:shopifyOrder.shippingAddress.name, address1:shopifyOrder.shippingAddress.address1, address2:shopifyOrder.shippingAddress.address2, city:shopifyOrder.shippingAddress.city, postalCode:shopifyOrder.shippingAddress.zip, stateProvineGeoId:geoId where shopifyOrder.shippingAddress.provinceCode=Geo.geoCode, countryGeoId:geoId where shopifyOrder.shippingAddress.countryCodeV2=Geo.geoCode, geoPoint:[dataSourceId:"GEOPT_GOOGLE", latitude:shopifyOrder.shippingAddress.latitude, longitude:shopifyOrder.shippingAddress.longitude]]
   * order.shipToPhone = shopifyOrder.shippingAddress.phone
   * If "SAVE_BILL_TO_INF" setting in ProductStoreSetting is "Y"
     * order.billToAddress = [toName:shopifyOrder.billingAddress.name, address1:shopifyOrder.billingAddress.address1, address2:shopifyOrder.billingAddress.address2, city:shopifyOrder.billingAddress.city, postalCode:shopifyOrder.billingAddress.zip, stateProvineGeoId:geoId where shopifyOrder.billingAddress.provinceCode=Geo.geoCode, countryGeoId:geoId where shopifyOrder.billingAddress.countryCodeV2=Geo.geoCode, geoPoint:[[dataSourceId:"GEOPT_GOOGLE", latitude:shopifyOrder.billingAddress.latitude, longitude:shopifyOrder.billingAddress.longitude]]]
     * order.billToPhone = shopifyOrder.billingAddress.phone
   * order.customer = [externalId:shopifyOrder.customer.id, firstName:shopifyOrder.customer.firstName, lastName:shopifyOrder.customer.lastName, email:shopifyOrder.customer.email]
   * order.productStoreId = ProductStore.productStoreId
   * order.email = shopifyOrder.email
   * order.shopifyShopOrder = [shopId:shopId, shopifyOrderId:shopifyOrder.id]
   * order.orderAdjustments
     * Iterate through shopifyOrder.shippingLines and shopifyOrder.shippingLines.originalPriceSet.presentmentMoney.amount > 0
       * Add to orderAdjustments list [orderAdjustmentTypeId:"SHIPPING_CHARGES", amount:shopifyOrder.shippingLines.originalPriceSet.presentmentMoney.amount, comments:shopifyOrder.shippingLines.title]
       * If shopifyOrder.shippingLines.taxLines and taxLines.priceSet.presentmentMoney.amount > 0
         * Add to order adjustments list [orderAdjustmentTypeId:"SHIPPING_SALES_TAX", amount:taxAmount, sourcePercentage:shopifyOrder.shippingLines.taxLines.ratePercentage, comments:shopifyOrder.shippingLines.taxLines.title]
       * If shopifyOrder.shippingLines.discountAllocations
         * Set shippingDiscountAdjustment = [orderAdjustmentTypeId:"EXT_PROMO_ADJUSTMENT", amount:(shopifyOrder.shippingLines.discountAllocations.allocatedAmountSet.presentmentMoney.amount).negate(), comments:"ExternalDiscount"]
         * If shopifyOrder.shippingLines.discountAllocations.discountCodeApplication
           * Set shippingDiscountAdjustment.orderAdjustmentAttributes (List) = [[attrName:"DISCOUNT_CODE", attrValue:shopifyOrder.shippingLines.discountAllocations.discountCodeApplication.discountCodeApplication.code]]
           * If shopifyOrder.shippingLines.discountAllocations.discountCodeApplication.pricingPercentageValue
           * Set shippingDiscountAdjustment.sourcePercentage = shopifyOrder.shippingLines.discountAllocations.discountCodeApplication.pricingPercentageValue.percentage
       * If shopifyOrder.totalTipReceivedSet.presentmentMoney.amount > 0
         * Add to orderAdjustments list [orderAdjustmentTypeId:"DONATION_ADJUSTMENT", amount:shopifyOrder.totalTipReceivedSet.presentmentMoney.amount, comments:"Tip"]
   * order.orderItemShipGroups
     * Iterate through each shopifyOrder.fulfillmentOrders
       * Prepare shipGroup Map
         * shipGroup.shipmentMethodTypeId
           * Set ShopifyShopTypeMapping for shopifyOrder.fulfillmentOrders.deliveryMethod
           * If shopifyOrder.fulfillmentOrders.deliveryMethod.methodType="SHIPPING", set from ShopifyShopCarrierShipment for shopifyOrder.fulfillmentOrders.deliveryMethod.serviceCode
         * shipGroup.carrierPartyId = defaults to _NA_, if shopifyOrder.fulfillmentOrders.deliveryMethod.methodType="SHIPPING", set from ShopifyShopCarrierShipment for shopifyOrder.fulfillmentOrders.deliveryMethod.serviceCode
         * shipGroup.facilityId = set to _NA_ if shopifyOrder.fulfillmentOrders.deliveryMethod.methodType="SHIPPING" and shopifyOrder.fulfillmentOrders.status!="CLOSED", else set from ShopifyShopLocation for shopifyOrder.fulfillmentOrders.assignedLocation.location.id
         * shipGroup.maySplit = defaults to Y, set from ProductStore.allowSplit
         * shipGroup.orderItems = iterate through shopifyOrder.fulfillmentOrders.lineItems and perform following
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
               * Set discountAdjustment = [orderAdjustmentTypeId:"EXT_PROMO_ADJUSTMENT", amount:discountAmount.negate(), comments:"ExternalDiscount"]
               * If shopifyOrder.fulfillmentOrders.lineItems.linetItem.discountAllocations.discountCodeApplication
                 * Set discountAdjustment.orderAdjustmentAttributes (List) = [[attrName:"DISCOUNT_CODE", attrValue:shopifyOrder.fulfillmentOrders.lineItems.linetItem.discountAllocations.discountCodeApplication.code]]
                 * If shopifyOrder.fulfillmentOrders.lineItems.linetItem.discountAllocations.discountCodeApplication.pricingPercentageValue
                   * Set discountAdjustment.sourcePercentage = shopifyOrder.fulfillmentOrders.lineItems.linetItem.discountAllocations.discountCodeApplication.pricingPercentageValue.percentage
               * Add discountAdjustment to orderAdjustments
           * If shopifyOrder.fulfillmentOrders.lineItems.remainingQuantity > 0, iterate through remainingQuantity
             * Set orderItem = [externalId:shopifyOrder.fulfillmentOrders.lineItems.lineItem.id, orderItemTypeId:"PRODUCT_ORDER_ITEM", productSku:productIdentifier, statusId: (if shopifyOrder.fulfillmentOrders.deliveryMethod=NONE then "ITEM_COMPLETED" else "ITEM_CREATED", isPromo:"N", quantity:1, unitPrice:shopifyOrder.fulfillmentOrders.lineItems.lineItem.originalUnitPriceSet.presentmentMoney.amount, itemDescription:shopifyOrder.fulfillmentOrders.lineItems.lineItem.variant.title]
             * orderItem.orderItemAttributes = orderItemAttributes
             * orderItem.orderAdjustments = orderAdjustments
             * Add orderItem to orderItems
           * Set fulfilledQuantity = (shopifyOrder.fulfillmentOrders.lineItems.totalQuantity - shopifyOrder.fulfillmentOrders.lineItems.remainingQuantity), If fulfilledQuantity > 0, iterate through fulfilledQuantity and add following map to orderItems list
             * Set orderItem = [externalId:shopifyOrder.fulfillmentOrders.lineItems.lineItem.id, orderItemTypeId:"PRODUCT_ORDER_ITEM", productSku:productIdentifier, statusId:"ITEM_COMPLETED", isPromo:"N", quantity:1, unitPrice:shopifyOrder.fulfillmentOrders.lineItems.lineItem.originalUnitPriceSet.presentmentMoney.amount, itemDescription:shopifyOrder.fulfillmentOrders.lineItems.lineItem.variant.title]
             * orderItem.orderItemAttributes = orderItemAttributes
             * orderItem.orderAdjustments = orderAdjustments
             * Add orderItem to orderItems
           * If shopifyOrder.fulfillmentOrders.lineItems.lineItem.nonFulfillableQuantity > 0, iterate through nonFulfillableQuantity and add following map (We may need to enhance this logic to add only once for a fulfillmentOrder if same shopify order line item appears in multiple shipgroups which should possibly be a rare edge case)
             * Set orderItem = [externalId:shopifyOrder.fulfillmentOrders.lineItems.lineItem.id, orderItemTypeId:"PRODUCT_ORDER_ITEM", productSku:productIdentifier, statusId:"ITEM_CANCELLED", isPromo:"N", quantity:1, cancelQuantity:1 unitPrice:shopifyOrder.fulfillmentOrders.lineItems.lineItem.originalUnitPriceSet.presentmentMoney.amount, itemDescription:shopifyOrder.fulfillmentOrders.lineItems.lineItem.variant.title]
             * orderItem.orderItemAttributes = orderItemAttributes
             * orderItem.orderAdjustments = orderAdjustments
             * Add orderItem to orderItems
         * Add shipGroup map to orderItemShipGroups

## OMS API

### create#SalesOrder
This would be the base api the uses entity rest method to create order and related base data in the database.
1. Parameters
    * Input Parameters
        * orderJson (type=Map)
    * Output Parameters
        * orderOutput

### create#PostalAddress
This would be the base api the uses entity rest method to create ContactMech and PostalAddress records in the database.
1. Parameters
    * Input Parameters
        * postalAddressJson (type=Map)
    * Output Parameters
        * contactMechId

### create#Customer
This would be the base api the uses entity rest method to create Party, Person, PartyRole and ContactMech (email) records in the database.
1. Parameters
   * Input Parameters
     * customerJson (type=Map) (expect JSON block below)
   * Output Parameters
     * partyId

### create#SalesOrder (Application Layer)
This service will take in the order JSON in OMSNewOrdersFeed and set up a complete order by performing any surrounding crud operations as needed.
1. Parameters
   * Input Parameters
     * orderJson (Map)
2. Initialize orderContext
3. Set following to orderContext
   * orderContext.externalId = orderJson.externalId
   * orderContext.orderTypeId = "SALES_ORDER"
   * orderContext.orderName = orderJson.name
   * orderContext.salesChannelEnumId = orderJson.salesChannelEnumId
   * orderContext.orderDate = orderJson.createdAt
   * orderContext.currencyUom = orderJson.currencyUom
   * orderContext.presentmentCurrencyUom = orderJson.presentmentCurrencyUom
   * orderContext.grandTotal = orderJson.grandTotal
   * orderContext.remainingSubTotal = orderJson.remainingSubTotal
   * orderContext.statusId = orderJson.statusId
   * orderContext.productStoreId = orderJson.productStoreId
   * orderContext.OrderAttribute = orderJson.orderAttributes
4. Initialize orderRoles list
   * If party exists for orderJson.customer.externalId
     * Set customerPartyId = Party.partyId
     * Else call create#CustomerService for orderJson.customerMap
       * Set customerPartyId = createCustomerOutput.partyId
   * Add [partyId:customerPartyId, roleTypeId:"SHIP_TO_CUSTOMER", formDate:nowTimestamp] to orderRoles
   * Get ProductStore for orderJson.productStoreId
   * Add [partyId:ProductStore.payToPartyId, roleTypeId:"SHIP_TO_CUSTOMER", formDate:nowTimestamp] to orderRoles
   * Set orderContext.OrderRole = orderRoles
5. Initialize orderContactMechs list
   * For orderJson.shipToAddress map call create#PostalAddress
   * Set shipToAddressContactMechId = createPostalAddressOutput.contactMechId
   * Add [contatctMechId:shipToAddressContactMechId, contactMechPurposeTypeId:"SHIPPING_LOCATION"]
   * Call create#ContactMech for [contactMechTypeId:"TELECOM_NUMBER", infoString:orderJson.shipToPhone]
   * Set shipToPhoneContactMechId = createContactMechOutput.contactMechId
   * Add [contatctMechId:shipToPhoneContactMechId, contactMechPurposeTypeId:"PHONE_SHIPPING"]
   * Call create#ContactMech for [contactMechTypeId:"EMAIL_ADDRESS", infoString:orderJson.email]
   * Add [contatctMechId:createContactMechOutput.contactMechId, contactMechPurposeTypeId:"ORDER_EMAIL"]
   * If orderJson.billToAddress
     * For orderJson.billToAddress map call create#PostalAddress
     * Add [contatctMechId:createPostalAddressOutput.contactMechId, contactMechPurposeTypeId:"BILLING_LOCATION"]
   * If orderJson.billToPhone
     * Call create#ContactMech for [contactMechTypeId:"TELECOM_NUMBER", infoString:orderJson.billToPhone]
     * Add [contatctMechId:createContactMechOutput.contactMechId, contactMechPurposeTypeId:"PHONE_BILLING"]
   * Set orderContext.OrderContactMech = orderContactMechs
6. If orderJson.orderAdjustments initialize orderContext.OrderAdjustment list
   * Iterate through orderJson.orderAdjustments
     * Set adjustmentAttributes = remove orderAdjustmentAttributes from the entry
     * If adjustmentAttributes set entry.OrderAdjustmentAttribute = adjustmentAttributes
     * Add entry to orderContext.OrderAdjustment list
7. Initialize orderContext.OrderItemShipGroup list
   * Iterate through orderJson.orderItemShipGroups as orderItemShipGroup
   * Initialize shipGroup map
     * shipGroup.shipmentMethodTypeId = orderItemShipGroup.shipmentMethodTypeId
     * shipGroup.carrierPartyId = orderItemShipGroup.carrierPartyId
     * shipGroup.facilityId = orderItemShipGroup.facilityId
     * shipGroup.maySplit = orderItemShipGroup.maySplit
     * shipGroup.contactMechId = shipToAddressContactMechId
     * shipGroup.telecomContactMechId = shipToPhoneContactMechId
     * Initialize shipGroup.OrderItem list
     * Iterate orderItemShipGroup.orderItems as orderItem
       * Initialize item map
         * item.externalId = orderItem.externalId
         * item.orderItemTypeId = orderItem.orderItemTypeId
         * item.statusId = orderItem.statusId
         * item.isPromo = orderItem.isPromo
         * item.quantity = orderItem.quantity
         * item.unitPrice = orderItem.unitPrice
         * item.itemDescription = orderItem.itemDescription
         * productId = productId where Product.internalName = orderItem.productSku
         * If productId, set item.productId = productId
           * Else call create#Product with [internalName:productSku] (New Transaction)
           * set item.productId = createProductOutput.productId
         * If orderItem.orderItemAttributes set item.OrderItemAttribute = orderItem.orderItemAttributes
         * If orderItem.orderAdjustments initialize item.OrderAdjustment list
           * Iterate through orderItem.orderAdjustments
             * Set adjustmentAttributes = remove orderAdjustmentAttributes from the entry
             * If adjustmentAttributes set entry.OrderAdjustmentAttribute = adjustmentAttributes
             * Add entry to item.OrderAdjustment list
       * Add item map to shipGroup.OrderItem list
     * Add shipGroup map to orderContext.OrderItemShipGroup list