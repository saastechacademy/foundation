
## `create#org.apache.ofbiz.order.order.OrderHeader` Service

The `create#Order` The service is responsible for saving the prepared data to the database.

This service creates data in following entities:

| Entity Name           | Alias                | Description                                              |
|-----------------------|----------------------|----------------------------------------------------------|
| OrderHeader | order             | Root entity representing the order details.              |
| OrderRole | roles          | Associates roles (e.g., customer, salesperson) to the order. |
| OrderItem | items          | Line items in the order, representing purchased products. |
| OrderItemAttribute | itemAttributes | Dynamic attributes associated with order items.          |
| OrderAdjustment | adjustments    | Adjustments applied to the order, such as discounts or taxes. |
| OrderPaymentPreference | paymentPreferences | Payment preferences associated with the order.            |
| OrderItemShipGroup | itemShipGroups | Defines shipping details for order items.               |
| OrderItemGroup | itemGroups     | Groups order items for brokering purposes.              |
| OrderItemGroupAssoc | itemGroupAssoc | Associates order items with specific groups.             |
| ContactMech | mech         | Represents a contact mechanism, such as a postal address.|
| PostalAddress | address       | Details of the postal address for the contact mechanism. |




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
    "contactMechs": [
        {
            "contactMechId": "100489",
            "contactMechPurposeTypeId": "SHIPPING_LOCATION"
        },
        {
            "contactMechId": "100490",
            "contactMechPurposeTypeId": "PHONE_SHIPPING"
        },
        {
            "contactMechId": "100491",
            "contactMechPurposeTypeId": "SHIPPING_EMAIL"
        },
        {
            "contactMechId": "100495",
            "contactMechPurposeTypeId": "ORDER_EMAIL"
        }
    ],
    "identifications": [
        {
            "orderIdentificationTypeId": "SHOPIFY_ORD_NAME",
            "idValue": "2345678876545"
        },
        {
            "orderIdentificationTypeId": "SHOPIFY_ORD_ID",
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
    "roles": [
        {
            "partyId": "100395",
            "roleTypeId": "PLACING_CUSTOMER"   
        },
        {
            "partyId": "100395",
            "roleTypeId": "END_USER_CUSTOMER"
        },
        {
            "partyId": "100395",
            "roleTypeId": "SHIP_TO_CUSTOMER"
        },
        {
            "partyId": "100395",
            "roleTypeId": "BILL_TO_CUSTOMER"
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
                    "statuses": {
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
            ],
            "orderFacilityId": ""
        }
    ],
    "statuses": {
        "statusId": "ORDER_CREATED",
        "statusUserLogin": "nishtha.jain",
        "statusDatetime": "2024-07-30T15:23:47+0000"
    }    
}
```

You can adjust this JSON to meet your specific requirements by adding or removing entities and fields as needed.
