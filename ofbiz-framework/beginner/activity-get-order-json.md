Create a sample JSON for an order using the methods in the OrderReadHelper class. Use the following JSON sample as a guide

```json
{
    "orderId": "DT00002288",
    "orderSource": "IN_STORE",
    "email": "nidhi.chaoji@hotwax.co",
    "orderSubTotal": 269.89,
    "lastDateToReturnTimeStamp": 1719760580000,
    "orderDate": 1717168580000,
    "orderStatus": "COMPLETED",
    "orderStatusText": "COMPLETED",
    "currency": "USD",
    "installationId": "2968ec79-4e1e-4617-8d75-6e8bd7449325",
    "canReturn": "TRUE",
    "displayOrderId": "DT00002288",
    "discount": 24.5,
    "storeId": "256",
    "shippingAddress": {
        "addressLine1": "830 Bay Boulevard",
        "addressLine2": null,
        "city": "Chula Vista",
        "country": "US",
        "state": "CA",
        "postalCode": "91911",
        "firstName": "Nidhi",
        "lastName": "Chaoji"
    },
    "taxSubTotal": 21.12,
    "tenders": [
        {
            "requestId": "test",
            "transactionId": "256-ANY-20240531204615-16-6",
            "paymentId": "944e1398-b56f-4c0a-9f4b-7632ef607773",
            "paymentMethod": "Miscellaneous",
            "amountAuthorized": 266.51,
            "paymentSequenceNumber": "2",
            "paymentDevice": "NoReader",
            "paymentStatus": "APPROVED",
            "totalAmountCarriedOverForExchange": 0
        }
    ],
    "customerProfile": {
        "customerId": "nidhi.chaoji@hotwax.co",
        "address": {
            "addressLine1": "830 Bay Boulevard"
        },
        "email": "nidhi.chaoji@hotwax.co",
        "firstName": "Nidhi",
        "lastName": "Chaoji",
        "phoneMobile": "+1-615-4440004"
    },
    "orderProductList": [
        {
            "orderStatus": "COMPLETED",
            "orderStatusText": "COMPLETED",
            "priceCorrection": {
                "orderId": "DT00002288",
                "approvingManagerId": "Nidhi",
                "orderItemId": "1",
                "originalPrice": null
            },
            "priceAdjustments": [
                {
                    "auto": "false",
                    "id": "PRICE_OVERRIDE_VKELSIE0104070",
                    "price": 4.5,
                    "description": "Discretionary",
                    "priceAdjustmentType": "PRICE_OVERRIDE",
                    "fulfillmentType": "ONLINE",
                    "reasons": [
                        {
                            "reasonCodeType": "PRICE_OVERRIDE"
                        }
                    ]
                }
            ],
            "color": "IVORY CROCO PRINT LEATHER",
            "fulfillmentType": "ONLINE",
            "fulfillmentSubType": "DEFAULT",
            "omniFulfillmentType": "SHIP_TO_HOME",
            "returnsEligibility": "ELIGIBLE_FOR_RETURNS",
            "gtin": "194975413016",
            "imageURL": "https://cdn.shopify.com/s/files/1/0699/4159/2374/products/DOLCEVITA-BOOTIES_KELSIE_IVORY_SIDE.jpg?v=1676089303",
            "itemStatus": "COMPLETED",
            "externalId": "DT00002288-1",
            "name": "KELSIE BOOTIES IVORY CROCO PRINT LEATHER",
            "orderItemId": "1",
            "price": 89.99,
            "productClass": "Merchandise",
            "productId": "VKELSIE0104070",
            "productTaxCode": "PC040144",
            "quantity": 1,
            "size": "7",
            "subTotal": 89.99,
            "tax": 7.47,
            "discount": 4.5,
            "total": 92.96,
            "taxExemption": null,
            "variantGroupId": "V-KELSIE",
            "salesAssociateAttribution": [
                {
                    "storeId": "256",
                    "storeAssociateId": "2542"
                }
            ]
        },
        {
            "orderStatus": "COMPLETED",
            "orderStatusText": "COMPLETED",
            "priceCorrection": {
                "orderId": "DT00002288",
                "approvingManagerId": "Nidhi",
                "orderItemId": "2",
                "originalPrice": "99.9"
            },
            "priceAdjustments": null,
            "color": "VANILLA PEARLS",
            "fulfillmentType": "ONLINE",
            "fulfillmentSubType": "DEFAULT",
            "omniFulfillmentType": "SHIP_TO_HOME",
            "returnsEligibility": "ELIGIBLE_FOR_RETURNS",
            "gtin": "197076008341",
            "imageURL": "https://cdn.shopify.com/s/files/1/0699/4159/2374/products/DOLCEVITA-HEELS_ARIELE_VANILLAPEARLS-02_7958d4a1-41e8-4bb4-81ba-a35fa33f8337.jpg?v=1676055152",
            "itemStatus": "COMPLETED",
            "externalId": "DT00002288-2",
            "name": "ARIELE HEELS VANILLA PEARLS",
            "orderItemId": "2",
            "price": 90.0,
            "productClass": "Merchandise",
            "productId": "VARIELE0127060",
            "productTaxCode": "PC040144",
            "quantity": 1,
            "size": "6",
            "subTotal": 90.0,
            "tax": 7.88,
            "discount": null,
            "total": 97.88,
            "taxExemption": null,
            "variantGroupId": "V-ARIELE",
            "salesAssociateAttribution": [
                {
                    "storeId": "256",
                    "storeAssociateId": "2542"
                }
            ]
        },
        {
            "orderStatus": "COMPLETED",
            "orderStatusText": "COMPLETED",
            "priceCorrection": {
                "orderId": "DT00002288",
                "approvingManagerId": "Nidhi",
                "orderItemId": "3",
                "originalPrice": null
            },
            "priceAdjustments": [
                {
                    "auto": "false",
                    "id": "PRICE_OVERRIDE_VRAMSON0548060",
                    "price": 20.0,
                    "description": "Discretionary",
                    "priceAdjustmentType": "PRICE_OVERRIDE",
                    "fulfillmentType": "IN_STORE",
                    "reasons": [
                        {
                            "reasonCodeType": "PRICE_OVERRIDE"
                        }
                    ]
                }
            ],
            "color": "DUNE MULTI",
            "fulfillmentType": "IN_STORE",
            "fulfillmentSubType": "DEFAULT",
            "omniFulfillmentType": "IN_STORE",
            "returnsEligibility": "ELIGIBLE_FOR_RETURNS",
            "gtin": "197076072663",
            "imageURL": null,
            "itemStatus": "COMPLETED",
            "externalId": "DT00002288-3",
            "name": "RAMSON DUNE MULTI",
            "orderItemId": "3",
            "price": 89.9,
            "productClass": "Merchandise",
            "productId": "VRAMSON0548060",
            "productTaxCode": "PC040144",
            "quantity": 1,
            "size": "6",
            "subTotal": 89.9,
            "tax": 5.77,
            "discount": 20.0,
            "total": 75.67,
            "taxExemption": null,
            "variantGroupId": "RAMSON",
            "salesAssociateAttribution": [
                {
                    "storeId": "256",
                    "storeAssociateId": "2542"
                }
            ]
        }
    ],
    "productList": [
        {
            "orderStatus": "COMPLETED",
            "orderStatusText": "COMPLETED",
            "color": "IVORY CROCO PRINT LEATHER",
            "fulfillmentType": "ONLINE",
            "fulfillmentSubType": "DEFAULT",
            "gtin": "194975413016",
            "imageURL": "https://cdn.shopify.com/s/files/1/0699/4159/2374/products/DOLCEVITA-BOOTIES_KELSIE_IVORY_SIDE.jpg?v=1676089303",
            "itemStatus": "COMPLETED",
            "name": "KELSIE BOOTIES IVORY CROCO PRINT LEATHER",
            "orderItemId": "3",
            "price": 89.99,
            "productClass": "Merchandise",
            "productId": "VKELSIE0104070",
            "productTaxCode": "PC040144",
            "quantity": 1,
            "size": "7",
            "subTotal": 89.99,
            "tax": 7.47,
            "discount": 4.5,
            "total": 92.96,
            "variantGroupId": "V-KELSIE",
            "salesAssociateAttribution": [
                {
                    "storeId": "256",
                    "storeAssociateId": "2542"
                }
            ]
        },
        {
            "orderStatus": "COMPLETED",
            "orderStatusText": "COMPLETED",
            "color": "VANILLA PEARLS",
            "fulfillmentType": "ONLINE",
            "fulfillmentSubType": "DEFAULT",
            "gtin": "197076008341",
            "imageURL": "https://cdn.shopify.com/s/files/1/0699/4159/2374/products/DOLCEVITA-HEELS_ARIELE_VANILLAPEARLS-02_7958d4a1-41e8-4bb4-81ba-a35fa33f8337.jpg?v=1676055152",
            "itemStatus": "COMPLETED",
            "name": "ARIELE HEELS VANILLA PEARLS",
            "orderItemId": "3",
            "price": 90.0,
            "productClass": "Merchandise",
            "productId": "VARIELE0127060",
            "productTaxCode": "PC040144",
            "quantity": 1,
            "size": "6",
            "subTotal": 90.0,
            "tax": 7.88,
            "discount": null,
            "total": 97.88,
            "variantGroupId": "V-ARIELE",
            "salesAssociateAttribution": [
                {
                    "storeId": "256",
                    "storeAssociateId": "2542"
                }
            ]
        },
        {
            "orderStatus": "COMPLETED",
            "orderStatusText": "COMPLETED",
            "color": "DUNE MULTI",
            "fulfillmentType": "IN_STORE",
            "fulfillmentSubType": "DEFAULT",
            "gtin": "197076072663",
            "imageURL": null,
            "itemStatus": "COMPLETED",
            "name": "RAMSON DUNE MULTI",
            "orderItemId": "3",
            "price": 89.9,
            "productClass": "Merchandise",
            "productId": "VRAMSON0548060",
            "productTaxCode": "PC040144",
            "quantity": 1,
            "size": "6",
            "subTotal": 89.9,
            "tax": 5.77,
            "discount": 20.0,
            "total": 75.67,
            "variantGroupId": "RAMSON",
            "salesAssociateAttribution": [
                {
                    "storeId": "256",
                    "storeAssociateId": "2542"
                }
            ]
        }
    ],
    "totalAmount": 266.51,
    "taxableAmount": 245.39
}
```
