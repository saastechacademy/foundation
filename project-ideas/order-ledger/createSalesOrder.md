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