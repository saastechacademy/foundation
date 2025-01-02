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
    * orderContext.attributes = orderJson.attributes
    * orderContext.adjustments = orderJson.adjustments
4. Initialize orderContext.roles list
    * Call findOrCreate#Customer for orderJson.customer
    * Add [partyId:findOrCreateCustomerOutput.partyId, roleTypeId:"SHIP_TO_CUSTOMER"] to orderContext.roles
    * Get ProductStore for orderJson.productStoreId
    * Add [partyId:ProductStore.payToPartyId, roleTypeId:"SHIP_TO_CUSTOMER"] to orderContext.roles
5. Initialize orderContext.contactMechs list
    * For orderJson.shipToAddress map call create#PostalAddress
    * Set shipToAddressContactMechId = createPostalAddressOutput.contactMechId
    * Add [contatctMechId:shipToAddressContactMechId, contactMechPurposeTypeId:"SHIPPING_LOCATION"] to orderContext.contactMechs
    * Call create#ContactMech for [contactMechTypeId:"TELECOM_NUMBER", infoString:orderJson.shipToPhone]
    * Set shipToPhoneContactMechId = createContactMechOutput.contactMechId
    * Add [contatctMechId:shipToPhoneContactMechId, contactMechPurposeTypeId:"PHONE_SHIPPING"] to orderContext.contactMechs
    * Call create#ContactMech for [contactMechTypeId:"EMAIL_ADDRESS", infoString:orderJson.email]
    * Add [contatctMechId:createContactMechOutput.contactMechId, contactMechPurposeTypeId:"ORDER_EMAIL"] to orderContext.contactMechs
    * If orderJson.billToAddress
        * For orderJson.billToAddress map call create#PostalAddress
        * Add [contatctMechId:createPostalAddressOutput.contactMechId, contactMechPurposeTypeId:"BILLING_LOCATION"] to orderContext.contactMechs
    * If orderJson.billToPhone
        * Call create#ContactMech for [contactMechTypeId:"TELECOM_NUMBER", infoString:orderJson.billToPhone]
        * Add [contatctMechId:createContactMechOutput.contactMechId, contactMechPurposeTypeId:"PHONE_BILLING"] to orderContext.contactMechs
6. Iterate through orderJson.shipGroups as shipGroup
   * Iterate through shipGroup.items as item
     * Set productSku = remove item.productSku
     * Call findOrCreate#Product for [internalName:productSku] map
     * Set item.productId = findOrCreateProductOutput.productId
7. Set orderContext.shipGroups = orderJson.shipGroups
8. Call create#org.apache.ofbiz.order.order.OrderHeader for orderContext