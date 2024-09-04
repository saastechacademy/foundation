Scheduled data suncronization with Shopify is best performed with [BulkOperation](https://shopify.dev/docs/api/admin-graphql/2024-07/objects/BulkOperation).  

*   [Export Bulk operations guide](https://shopify.dev/docs/api/usage/bulk-operations/queries)

    The GraphQL Admin API supports querying a single top-level field, and then selecting the fields that you want returned. You can also nest connections, such as variants on products.

*   [Import Bulk operations guide](https://shopify.dev/docs/api/usage/bulk-operations/imports)
*   [Bulk Query Workflow](https://shopify.dev/docs/api/usage/bulk-operations/queries#bulk-query-workflow)
*   [JSONL](https://jsonlines.org/)

### Sample GrapQL Query for order data
```gql
{
  orders(first: 50) {
    edges {
      node {
        id
        name
        tags
        createdAt
        cancelledAt
        cancelReason
        closedAt
        currencyCode
        presentmentCurrencyCode
        displayFinancialStatus
        displayFulfillmentStatus
        returnStatus
        note
        sourceIdentifier
        customerLocale
        customAttributes {
          key
          value
        }
        customer {
          id
          firstName
          lastName
          state
          email
          phone
          tags
        }
        totalPriceSet {
          shopMoney {
            amount
          }
        }
        originalTotalPriceSet {
          shopMoney {
            amount
          }
        }
        channelInformation {
          app {
            id
            title
          }
          channelId
          channelDefinition {
            channelName
          }
        }
        email
        phone
        billingAddress {
          name
          address1
          address2
          city
          country
          countryCodeV2
          province
          provinceCode
          zip
          latitude
          longitude
          phone
        }
        billingAddressMatchesShippingAddress
        shippingAddress {
          name
          address1
          address2
          city
          country
          countryCodeV2
          province
          provinceCode
          zip
          latitude
          longitude
          phone
        }
        discountCode
        discountCodes
        taxLines {
          rate
          ratePercentage
          title
          priceSet {
            shopMoney {
              amount
            }
          }
        }
        shippingLine {
          id
          code
          title
          source
          originalPriceSet {
            shopMoney {
              amount
            }
          }
          discountAllocations {
            allocatedAmountSet {
              shopMoney {
                amount
              }
            }
            discountApplication {
              index
              targetType
              value {
                __typename
              }
            }
          }
          taxLines {
            title
            rate
            ratePercentage
            priceSet {
              shopMoney {
                amount
              }
            }
          }
        }
        totalTipReceivedSet {
          shopMoney {
            amount
          }
        }
        additionalFees {
          id
          name
          price {
            shopMoney {
              amount
            }
          }
          taxLines {
            rate
            ratePercentage
            title
            priceSet {
              shopMoney {
                amount
              }
            }
          }
        }
        lineItems(first: 5) {
          edges {
            node {
              id
              name
              title
              sku
              product {
                id
              }
              variant {
                id
              }
              quantity
              currentQuantity
              refundableQuantity
              unfulfilledQuantity
              nonFulfillableQuantity
              customAttributes {
                key
                value
              }
              originalUnitPriceSet {
                shopMoney {
                  amount
                }
              }
              originalTotalSet {
                shopMoney {
                  amount
                }
              }
              discountAllocations {
                allocatedAmountSet {
                  shopMoney {
                    amount
                  }
                }
                discountApplication {
                  index
                  targetType
                  value {
                    __typename
                  }
                }
              }
              taxLines {
                rate
                ratePercentage
                title
                priceSet {
                  shopMoney {
                    amount
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

```

### Smaple order json from Shopify
```json
{
    "data": {
        "orders": {
            "edges": [
                {
                    "node": {
                        "id": "gid://shopify/Order/5663957713180",
                        "name": "#1010101170",
                        "tags": [
                            "signifyd approved"
                        ],
                        "createdAt": "2024-01-09T14:54:29Z",
                        "cancelledAt": null,
                        "cancelReason": null,
                        "closedAt": null,
                        "currencyCode": "CAD",
                        "presentmentCurrencyCode": "CAD",
                        "displayFinancialStatus": "PARTIALLY_REFUNDED",
                        "displayFulfillmentStatus": "FULFILLED",
                        "returnStatus": "IN_PROGRESS",
                        "note": null,
                        "sourceIdentifier": "d5a830a2a8d1f7e8838c138f68bac502",
                        "customerLocale": "en-CA",
                        "customAttributes": [
                            {
                                "key": "language",
                                "value": "en"
                            }
                        ],
                        "customer": {
                            "id": "gid://shopify/Customer/7454545455",
                            "firstName": "Vicky",
                            "lastName": "Kapoor",
                            "state": "ENABLED",
                            "email": "vicky.ku@frankandoak.com",
                            "phone": "+14378480602",
                            "tags": [
                                "swell_vip_premium"
                            ]
                        },
                        "totalPriceSet": {
                            "shopMoney": {
                                "amount": "59.89"
                            }
                        },
                        "originalTotalPriceSet": {
                            "shopMoney": {
                                "amount": "59.89"
                            }
                        },
                        "channelInformation": {
                            "app": {
                                "id": "gid://shopify/App/580111",
                                "title": "Online Store"
                            },
                            "channelId": "gid://shopify/ChannelInformation/212650524956",
                            "channelDefinition": {
                                "channelName": "Online Store"
                            }
                        },
                        "email": "ricky.yu@frankandoak.com",
                        "phone": null,
                        "billingAddress": {
                            "name": "Vicky Kapoor",
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
                            "name": "Vicky Kapoor",
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
                        "taxLines": [
                            {
                                "rate": 0.05,
                                "ratePercentage": 5.0,
                                "title": "CANADA GST/TPS",
                                "priceSet": {
                                    "shopMoney": {
                                        "amount": "2.65"
                                    }
                                }
                            },
                            {
                                "rate": 0.08,
                                "ratePercentage": 8.0,
                                "title": "ONTARIO HST",
                                "priceSet": {
                                    "shopMoney": {
                                        "amount": "4.24"
                                    }
                                }
                            }
                        ],
                        "shippingLine": {
                            "id": "gid://shopify/ShippingLine/4584829747484",
                            "code": "Standard",
                            "title": "Standard",
                            "source": "shopify",
                            "originalPriceSet": {
                                "shopMoney": {
                                    "amount": "10.0"
                                }
                            },
                            "discountAllocations": [],
                            "taxLines": [
                                {
                                    "title": "CANADA GST/TPS",
                                    "rate": 0.05,
                                    "ratePercentage": 5.0,
                                    "priceSet": {
                                        "shopMoney": {
                                            "amount": "0.5"
                                        }
                                    }
                                },
                                {
                                    "title": "ONTARIO HST",
                                    "rate": 0.08,
                                    "ratePercentage": 8.0,
                                    "priceSet": {
                                        "shopMoney": {
                                            "amount": "0.8"
                                        }
                                    }
                                }
                            ]
                        },
                        "totalTipReceivedSet": {
                            "shopMoney": {
                                "amount": "0.0"
                            }
                        },
                        "additionalFees": [],
                        "lineItems": {
                            "edges": [
                                {
                                    "node": {
                                        "id": "gid://shopify/LineItem/14507358519580",
                                        "name": "The Jasper Oxford Shirt in White - M",
                                        "title": "The Jasper Oxford Shirt in White",
                                        "sku": "1110352-010-M",
                                        "product": {
                                            "id": "gid://shopify/Product/8854944579868"
                                        },
                                        "variant": {
                                            "id": "gid://shopify/ProductVariant/47226692763932"
                                        },
                                        "quantity": 1,
                                        "currentQuantity": 0,
                                        "refundableQuantity": 0,
                                        "unfulfilledQuantity": 0,
                                        "nonFulfillableQuantity": 0,
                                        "customAttributes": [
                                            {
                                                "key": "_tags",
                                                "value": "color_hex:fafafa"
                                            },
                                            {
                                                "key": "_compare_at_price",
                                                "value": "8950"
                                            }
                                        ],
                                        "originalUnitPriceSet": {
                                            "shopMoney": {
                                                "amount": "43.0"
                                            }
                                        },
                                        "originalTotalSet": {
                                            "shopMoney": {
                                                "amount": "43.0"
                                            }
                                        },
                                        "discountAllocations": [],
                                        "taxLines": [
                                            {
                                                "rate": 0.05,
                                                "ratePercentage": 5.0,
                                                "title": "CANADA GST/TPS",
                                                "priceSet": {
                                                    "shopMoney": {
                                                        "amount": "2.15"
                                                    }
                                                }
                                            },
                                            {
                                                "rate": 0.08,
                                                "ratePercentage": 8.0,
                                                "title": "ONTARIO HST",
                                                "priceSet": {
                                                    "shopMoney": {
                                                        "amount": "3.44"
                                                    }
                                                }
                                            }
                                        ]
                                    }
                                }
                            ]
                        }
                    }
                }
            ]
        }
    },
    "extensions": {
        "cost": {
            "requestedQueryCost": 40,
            "actualQueryCost": 23,
            "throttleStatus": {
                "maximumAvailable": 20000.0,
                "currentlyAvailable": 19977,
                "restoreRate": 1000.0
            }
        }
    }
}
```