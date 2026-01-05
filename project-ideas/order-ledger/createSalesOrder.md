### co.hotwax.orderledger.order.OrderServices.create#SalesOrder (Application Layer - OMS)

This is the application layer service which will be responsible for
1. handling multiple business rules like existence checks, validating customer, facility, products, etc.
2. coordinating calls to multiple lower level services in the right sequence to achieve the order creation. This includes create Customer, Contact Mechs etc.

This service will take in the order JSON transformed from the response received from an external API request (REST/GraphQL) and create the payload for the core create#org.apache.ofbiz.order.order.OrderHeader service by performing any surrounding validations and crud operations as needed.

1. Parameters
    * Input Parameters
        * payload (Map)
2. Validate order by checking OrderHeader.externalId to avoid duplication of order
3. Initialize payload.roles list
    * Call findOrCreate#Person for payload.customer
    * Add [partyId:findOrCreatePersonOutput.partyId, roleTypeId:"SHIP_TO_CUSTOMER"] to payload.roles
    * Get ProductStore for orderJson.productStoreId
    * Add [partyId:ProductStore.payToPartyId, roleTypeId:"SHIP_FROM_VENDOR"] to payload.roles
4. Initialize payload.contactMechs list
    * If orderJson.shipping_address map
      * call co.hotwax.oms.contact.ContactMechServices.create#PostalAddress with input as orderJson.shipping_address
      * Add [contactMechId:shipToAddressOut.contactMechId, contactMechPurposeTypeId:"SHIPPING_LOCATION"] to payload.contactMechs
    * If orderJson.shipping_address.phone
      * call co.hotwax.oms.contact.ContactMechServices.create#TelecomNumber with input as orderJson.shipping_address.phone
      * Add [contactMechId:shipToPhoneOut.contactMechId, contactMechPurposeTypeId:"PHONE_SHIPPING"] to payload.contactMechs
    * If orderJson.shipping_address.email
      * Call create#org.apache.ofbiz.party.contact.ContactMech for [contactMechTypeId:"EMAIL_ADDRESS", infoString:orderJson.shipping_address.email]
      * Add [contactMechId:shipToEmailOut.contactMechId, contactMechPurposeTypeId:"SHIPPING_EMAIL"] to payload.contactMechs
    * If orderJson.billing_address map 
      * call co.hotwax.oms.contact.ContactMechServices.create#PostalAddress with input as orderJson.billing_address
      * Add [contactMechId:billToAddressOut.contactMechId, contactMechPurposeTypeId:"BILLING_LOCATION"] to payload.contactMechs
    * If orderJson.billing_address.phone
      * Call co.hotwax.oms.contact.ContactMechServices.create#ContactMech for orderJson.shipping_address.phone
      * Add [contatctMechId:billToPhoneOut.contactMechId, contactMechPurposeTypeId:"PHONE_BILLING"] to payload.contactMechs
    * If orderJson.billing_address.email
       * Call create#org.apache.ofbiz.party.contact.ContactMech for [contactMechTypeId:"EMAIL_ADDRESS", infoString:orderJson.billing_address.email]
       * Add [contactMechId:billToEmailOut.contactMechId, contactMechPurposeTypeId:"BILLING_EMAIL"] to payload.contactMechs
5. Check if payload.email exists
   * If yes, then call create#org.apache.ofbiz.party.contact.ContactMech for [contactMechTypeId:"EMAIL_ADDRESS", infoString:orderJson.email]
   * Add Add [contactMechId:orderEmailOut.contactMechId, contactMechPurposeTypeId:"ORDER_EMAIL"] to payload.contactMechs
6. Iterate through orderJson.shipGroups as shipGroup
   * Iterate through shipGroup.items as item
     * Set productSku = remove item.productSku
     * Call findOrCreate#Product for [internalName:productSku] map
     * Set item.productId = findOrCreateProductOutput.productId
7. Set payload.shipGroups = orderJson.shipGroups
8. Call create#org.apache.ofbiz.order.order.OrderHeader for payload

```json
{
    "currencyUom": "USD",
    "customerClassificationId": null,
    "entryDate": "2024-07-30T15:23:47+0000",
    "externalId": "444455555",
    "orderDate": "2024-07-25T04:07:49.956",
    "orderName": "#499999",
    "orderTypeId": "SALES_ORDER",
    "statusId": "ORDER_CREATED",
    "originFacilityId": "",
    "presentmentCurrencyCode": "USD",
    "priority": "2",
    "productStoreId": "STORE",
    "salesChannelEnumId": "UNKNWN_SALES_CHANNEL",
    "webSiteId": "WEBSTORE",
    "adjustments": [
        {
            "orderAdjustmentTypeId": "SHIPPING_CHARGES",
            "amount": "500",
            "exemptAmount": "2.5",
            "comments": "",
            "sourcePercentage": "5",
            "adjustmentAttributes": [
                {
                    "attrName": "taxAuthority",
                    "attrValue": "State of California",
                    "attrDescription": "state tax"
                }
            ]
        }
    ],
    "attributes": [
        {
            "attrName": "item",
            "attrValue": "testing attribute",
            "attrDescription": ""
        }
    ],
    "email": "abc@gmail.com",
    "customer": {
        "partyId": "Doe",
        "externalId": 22889483207024,
        "first_name": "John",
        "last_name": "Doe"
    },
    "billing_address": {
        "email": "abc@gmail.com",
        "first_name": "John",
        "address1": "1020 Thalia Street",
        "phone": "+17869573716",
        "city": "New Orleans",
        "zip": "70130",
        "province": "Louisiana",
        "country": "United States",
        "last_name": "Doe",
        "address2": null,
        "company": null,
        "latitude": 29.9377606,
        "longitude": -90.07084449999999,
        "name": "John Doe",
        "country_code": "US",
        "province_code": "LA"
    },
    "shipping_address": {
        "email": "abc@gmail.com",
        "first_name": "John",
        "address1": "1020 Thalia Street",
        "phone": "+17869573716",
        "city": "New Orleans",
        "zip": "70130",
        "province": "Louisiana",
        "country": "United States",
        "last_name": "Doe",
        "address2": null,
        "company": null,
        "latitude": 29.9377606,
        "longitude": -90.07084449999999,
        "name": "John Doe",
        "country_code": "US",
        "province_code": "LA"
    },
    "identifications": [
        {
            "idType": "SHOPIFY_ORD_NAME",
            "idValue": "2345678876545"
        },
        {
            "idType": "SHOPIFY_ORD_ID",
            "idValue": "4444992255"
        }
    ],
    "paymentPreferences": [
        {
            "paymentMethodTypeId": "EXT_SHOP_OTHR_GTWAY",
            "maxAmount": "25000",
            "statusId": "PAYMENT_AUTHORIZED",
            "paymentMode": "",
            "cardName": "",
            "manualAuthCode": null,
            "manualRefNum": "45545454545454",
            "createdByUserLogin": "nishtha.jain",
            "orderId": "100783"
        }
    ],
    "shipGroups": [
        {
            "facilityId": "NEW_ERA_HARAJUKU",
            "maySplit": "Y",
            "shipmentMethodTypeId": "STOREPICKUP",
            "carrierPartyId": "_NA_",
            "shipAfterDate": "",
            "shipByDate": "",
            "trackingNumber": "8888888888",
            "contactMechId": "100489",
            "telecomContactMechId": "100490",
            "items": [
                {
                    "externalId": "100097001712202",
                    "productId": "10022",
                    "sku": "BLACK_BELL_BOTTOM_S",
                    "quantity": 1,
                    "statusId": "ITEM_CREATED",
                    "itemDescription": "",
                    "unitPrice": 500,
                    "unitListPrice": 1370,
                    "status": {
                        "statusId": "ITEM_CREATED",
                        "statusDatetime": "2024-07-30T15:23:47+0000",
                        "statusUserLogin": "nishtha.jain"
                    },
                    "adjustments": [
                        {
                            "orderAdjustmentTypeId": "EXT_PROMO_ADJUSTMENT",
                            "amount": "200",
                            "exemptAmount": "2.5",
                            "comments": "IDK",
                            "sourcePercentage": "5",
                            "adjustmentAttributes": [
                                {
                                    "attrName": "description",
                                    "attrValue": "Early bird discount"
                                }
                            ]
                        }
                    ],
                    "itemAttributes": [
                        {
                            "attrName": "_pickupstore",
                            "attrValue": "NEW_ERA_HARAJUKU",
                            "attrDescription": ""
                        }
                    ]
                }
            ]
        }
    ],
    "status": {
        "statusId": "ORDER_CREATED",
        "statusUserLogin": "nishtha.jain",
        "statusDatetime": "2024-07-30T15:23:47+0000"
    }
}