### Transforming the Shopify Order JSON Using Apache NiFi and Jolt
After fetching the order JSON from Shopify, we need to transform the structure into the format expected by Hotwax. This transformation is accomplished using Apache NiFi with the Jolt processor, which allows us to specify transformation logic using a Jolt specification (Jolt spec).

The input for this Jolt spec is the Shopify order JSON retrieved from the GraphQL query.
<details>
<summary>Jolt spec</summary>
<br>

```json
[
  {
    "operation": "shift",
    "spec": {
      "data": {
        "orders": {
          "edges": {
            "*": {
              "node": {
                "*": "[&2].&",
                "id": "[&2].id",
                "name": "[&2].orderName",
                "displayFinancialStatus": "[&2].financialStatus",
                "displayFulfillmentStatus": "[&2].fulfillmentStatus",
                "totalPriceSet": {
                  "shopMoney": {
                    "amount": "[&4].grandTotal"
                  }
                },
                "customAttributes": {
                  "*": {
                    "key": "[&4].orderAttributes[&1].attrName",
                    "value": "[&4].orderAttributes[&1].attrValue"
                  }
                },
                "email": "[&2].orderContacts.&",
                "phone": "[&2].orderContacts.&",
                "channelInformation": {
                  "channelId": "[&3].channel.&",
                  "channelDefinition": {
                    "channelName": "[&4].channel.&"
                  }
                },
                "shippingLine": {
                  "code": "[&3].shippingLine_code",
                  "#SHIPPING_CHARGES": "[&3].orderAdjustmentList[0].&1.type",
                  "title": "[&3].orderAdjustmentList[0].&1.comments",
                  "originalPriceSet": {
                    "shopMoney": {
                      "amount": "[&5].orderAdjustmentList[0].&3.amount"
                    }
                  },
                  "taxLines": {
                    "*": {
                      "#SHIPPING_SALES_TAX": "[&5].orderAdjustmentList[&1].&2.type",
                      "title": "[&5].orderAdjustmentList[&1].&2.comments",
                      "rate": "[&5].orderAdjustmentList[&1].&2.sourcePercentage",
                      "priceSet": {
                        "shopMoney": {
                          "amount": "[&7].orderAdjustmentList[&3].&4.amount"
                        }
                      }
                    }
                  }
                },
                "totalTipReceivedSet": {
                  "shopMoney": {
                    "amount": {
                      "0.0": null,
                      "*": {
                        "#DONATION_ADJUSTMENT": "[&6].orderAdjustmentList[0].&4.type",
                        "#tip": "[&6].orderAdjustmentList[0].&4.comments",
                        "@(2,amount)": "[&6].orderAdjustmentList[0].&4.amount"
                      }
                    }
                  }
                },
                "lineItems": {
                  "edges": {
                    "*": {
                      "node": {
                        "id": "[&6].items[&2].id",
                        "sku": "[&6].items[&2].sku",
                        "name": "[&6].items[&2].description",
                        "product": {
                          "id": "[&7].items[&3].product_Id"
                        },
                        "variant": {
                          "id": "[&7].items[&3].variant_Id"
                        },
                        "originalUnitPriceSet": {
                          "shopMoney": {
                            "amount": "[&8].items[&4].unitPrice"
                          }
                        },
                        "originalTotalSet": {
                          "shopMoney": {
                            "amount": "[&8].items[&4].unitListPrice"
                          }
                        },
                        "customAttributes": {
                          "*": {
                            "key": "[&8].items[&4].orderItemAttributes[&1].attrName",
                            "value": "[&8].items[&4].orderItemAttributes[&1].attrValue"
                          }
                        },
                        "taxLines": {
                          "*": {
                            "#SALES_TAX": "[&8].items[&4].orderItemAdjustmentsList[&1].&2.type",
                            "title": "[&8].items[&4].orderItemAdjustmentsList[&1].&2.comments",
                            "rate": "[&8].items[&4].orderItemAdjustmentsList[&1].&2.sourcePercentage",
                            "priceSet": {
                              "shopMoney": {
                                "amount": "[&10].items[&6].orderItemAdjustmentsList[&3].&4.amount"
                              }
                            }
                          }
                        },
                        "discountAllocations": {
                          "*": {
                            "#EXT_PROMO_ADJUSTMENT": "[&8].items[&4].orderItemAdjustmentsList[&1].&2.type",
                            "#External Discount: ": "[&8].items[&4].orderItemAdjustmentsList[&1].&2.comments",
                            "allocatedAmountSet": {
                              "shopMoney": {
                                "amount": "&[10].items[&6].orderItemAdjustmentsList[&3].&4.amount"
                              }
                            },
                            "discountApplication": {
                              "*": "[&9].items[&5].orderItemAdjustmentsList[&2].&3.&1.&",
                              "value": {
                                "__typename": "[&10].items[&6].orderItemAdjustmentsList[&3].&4.&2.type"
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  },
  {
    "operation": "modify-overwrite-beta",
    "spec": {
      "*": {
        "id": "=split('[/]',@(1,&))",
        "externalId": "=lastElement(@(1,id))",
        "channel": {
          "channelId": "=split('[/]',@(1,&))",
          "id": "=lastElement(@(1,channelId))"
        },
        "items": {
          "*": {
            "id": "=split('[/]',@(1,&))",
            "itemExternalId": "=lastElement(@(1,id))",
            "product_Id": "=split('[/]',@(1,&))",
            "productId": "=lastElement(@(1,product_Id))",
            "variant_Id": "=split('[/]',@(1,&))",
            "variantId": "=lastElement(@(1,variant_Id))"
          }
        }
      }
    }
  },
  {
    "operation": "shift",
    "spec": {
      "*": {
        "@": "[&1]",
        "#SHOPIFY_ORD_ID": "[&1].orderIdentifications[0].idType",
        "externalId": "[&1].orderIdentifications[0].idvalue",
        "#SHOPIFY_ORD_NAME": "[&1].orderIdentifications[1].idType",
        "orderName": "[&1].orderIdentifications[1].idvalue",
        "orderAdjustmentList": {
          "*": {
            "*": "[&3].orderAdjustments[]"
          }
        },
        "items": {
          "*": {
            "orderItemAdjustmentsList": {
              "*": {
                "*": "[&5].&4.[&3].orderItemAdjustments[]"
              }
            }
          }
        }
      }
    }
  },
  {
    "operation": "remove",
    "spec": {
      "*": {
        "id": "",
        "orderAdjustmentList": "",
        "channel": {
          "channelId": ""
        },
        "items": {
          "*": {
            "id": "",
            "product_Id": "",
            "variant_Id": "",
            "orderItemAdjustmentsList": ""
          }
        }
      }
    }
  }
]
```
</details>
<details>
<summary>Output order json:</summary>
<br>

```json
[
  {
    "orderName": "#1010101170",
    "tags": [
      "signifyd approved"
    ],
    "createdAt": "2024-01-09T14:54:29Z",
    "cancelledAt": null,
    "cancelReason": null,
    "closedAt": null,
    "currencyCode": "CAD",
    "presentmentCurrencyCode": "CAD",
    "financialStatus": "PARTIALLY_REFUNDED",
    "fulfillmentStatus": "FULFILLED",
    "returnStatus": "IN_PROGRESS",
    "note": null,
    "sourceIdentifier": "d5a830a2a8d1f7e8838c138f68bac502",
    "customerLocale": "en-CA",
    "orderAttributes": [
      {
        "attrName": "language",
        "attrValue": "en"
      }
    ],
    "customer": {
      "id": "gid://shopify/Customer/7648318325020",
      "firstName": "Ricky",
      "lastName": "Yu",
      "state": "ENABLED",
      "email": "ricky.yu@frankandoak.com",
      "phone": "+14378480602",
      "tags": [
        "swell_vip_premium"
      ]
    },
    "grandTotal": "59.89",
    "channel": {
      "channelName": "Online Store",
      "id": "212650524956"
    },
    "orderContacts": {
      "email": "ricky.yu@frankandoak.com",
      "phone": null
    },
    "billingAddress": {
      "name": "Ricky Yu",
      "address1": "48 Chipwood Crescent",
      "address2": null,
      "city": "Toronto",
      "country": "Canada",
      "countryCodeV2": "CA",
      "province": "Ontario",
      "provinceCode": "ON",
      "zip": "M2J 3X7",
      "latitude": null,
      "longitude": null,
      "phone": null
    },
    "billingAddressMatchesShippingAddress": true,
    "shippingAddress": {
      "name": "Ricky Yu",
      "address1": "48 Chipwood Crescent",
      "address2": null,
      "city": "Toronto",
      "country": "Canada",
      "countryCodeV2": "CA",
      "province": "Ontario",
      "provinceCode": "ON",
      "zip": "M2J 3X7",
      "latitude": 43.7932936,
      "longitude": -79.34151709999999,
      "phone": null
    },
    "discountCode": null,
    "discountCodes": [],
    "shippingLine_code": "Standard",
    "additionalFees": [],
    "items": [
      {
        "sku": "1110352-010-M",
        "description": "The Jasper Oxford Shirt in White - M",
        "unitPrice": "43.0",
        "orderItemAttributes": [
          {
            "attrName": "_tags",
            "attrValue": "color_hex:fafafa"
          },
          {
            "attrName": "_compare_at_price",
            "attrValue": "8950"
          }
        ],
        "itemExternalId": "14507358519580",
        "productId": "8854944579868",
        "variantId": "47226692763932",
        "orderItemAdjustments": [
          {
            "type": "SALES_TAX",
            "comments": "CANADA GST/TPS",
            "sourcePercentage": 0.05,
            "amount": "2.15"
          },
          {
            "type": "SALES_TAX",
            "comments": "ONTARIO HST",
            "sourcePercentage": 0.08,
            "amount": "3.44"
          }
        ]
      }
    ],
    "externalId": "5663957713180",
    "orderIdentifications": [
      {
        "idType": "SHOPIFY_ORD_ID",
        "idvalue": "5663957713180"
      },
      {
        "idType": "SHOPIFY_ORD_NAME",
        "idvalue": "#1010101170"
      }
    ],
    "orderAdjustments": [
      {
        "type": "SHIPPING_CHARGES",
        "comments": "Standard",
        "amount": "10.0"
      },
      {
        "type": "SHIPPING_SALES_TAX",
        "comments": "CANADA GST/TPS",
        "sourcePercentage": 0.05,
        "amount": "0.5"
      },
      {
        "type": "SHIPPING_SALES_TAX",
        "comments": "ONTARIO HST",
        "sourcePercentage": 0.08,
        "amount": "0.8"
      }
    ]
  }
]
```
</details>