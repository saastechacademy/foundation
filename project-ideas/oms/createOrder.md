
## `create#Order` Service

The `create#Order` The service is responsible for saving the prepared data to the database.

This service creates data in following entities:
- **OrderHeader**: The main order record, storing information such as order date, customer details, and total amounts.
- **OrderIdentificaion**:
- **OrderContactMech**:
- **OrderPaymentPreference**: Information about the payment method used for the order.
- **OrderItems**: Line items representing the products or services being ordered, including quantity, price, and any adjustments.
- **OrderAdjustments**: Any promotions, discounts, or taxes applied to the order.
- **OrderItemShipGroup**: Shipment details, including the shipping method, carrier, and destination.
- **OrderItemGroup**:
- **OrderItemAssoc**:


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
    "orderAttributes": [
        {
            "attrName": "item",
            "attrValue": "testing attribute",
            "attrDescription": ""
        }
    ],
    "orderContactMechs": [
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
    "orderIdentifications": [
        {
            "idType": "SHOPIFY_ORD_NAME",
            "idValue": "2345678876545"
        },
        {
            "idType": "SHOPIFY_ORD_ID",
            "idValue": "4444992255"
        }  
    ],
    "orderPaymentPref": [
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
    "orderRoles": [
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
                    "status": {
                        "statusId": "ITEM_CREATED",
                        "statusDatetime": "2024-07-30T15:23:47+0000",
                        "statusUserLogin": "nishtha.jain"
                    },
                    "adjustments": [
                        {
                            "orderAdjustmentTypeId:"EXT_PROMO_ADJUSTMENT",
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
                    "orderItemAttributes": [
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
```

You can adjust this JSON to meet your specific requirements by adding or removing entities and fields as needed.
