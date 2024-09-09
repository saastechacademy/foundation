### Fetching Order JSON via GraphQL
To integrate Shopify orders with Hotwax, we begin by fetching the order data from Shopify using a GraphQL query. Shopify provides a flexible and efficient way to retrieve order data, allowing us to specify exactly what information we need. The GraphQL query can pull details such as order number, customer data, line items, shipping information, and payment details.

### Sample GrapfQL Query for fetching order data from Shopify

Here we are only fetching the fields which are required by Hotwax to create order in Hotwax data model.

<details>
<summary>GrphQL Query</summary>
<br>

```gql
{
  orders(query: "updated_at:>'2024-04-18T00:00:00Z'", first: 50) {
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
        channelInformation {
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
        shippingLine {
          id
          code
          title
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
              variantTitle
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
</details>

<details>
<summary>Output JSON</summary>
<br>

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
                        "totalPriceSet": {
                            "shopMoney": {
                                "amount": "59.89"
                            }
                        },
                        "channelInformation": {
                            "channelId": "gid://shopify/ChannelInformation/212650524956",
                            "channelDefinition": {
                                "channelName": "Online Store"
                            }
                        },
                        "email": "ricky.yu@frankandoak.com",
                        "phone": null,
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
                        "shippingLine": {
                            "id": "gid://shopify/ShippingLine/4584829747484",
                            "code": "Standard",
                            "title": "Standard",
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
                                    "priceSet": {
                                        "shopMoney": {
                                            "amount": "0.5"
                                        }
                                    }
                                },
                                {
                                    "title": "ONTARIO HST",
                                    "rate": 0.08,
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
                                        "variantTitle": "M",
                                        "quantity": 1,
                                        "currentQuantity": 0,
                                        "refundableQuantity": 0,
                                        "unfulfilledQuantity": 0,
                                        "nonFulfillableQuantity": 0,
                                        "customAttributes": [
                                            {
                                                "key": "_tags",
                                                "value": "color_hex:fafafa,custitem_fao_body:Button-down Shirt,custitem_fao_body_length:Regular,custitem_fao_brand:Frank And Oak,custitem_fao_closure:Button,custitem_fao_collar:Button-Down,custitem_fao_color_code:010,custitem_fao_color_family:White,custitem_fao_fabric_type:Woven,custitem_fao_feature:Organic Cotton,custitem_fao_FinalSale:No,custitem_fao_fit:Regular,custitem_fao_hemline:Shirttail Hem,custitem_fao_lapel:No Lapel,custitem_fao_launch_month:August,custitem_fao_launch_year:2023,custitem_fao_lifecycle:Fashion,custitem_fao_merch_category:Wovens,custitem_fao_merch_department:Tops,custitem_fao_merch_group:Apparel,custitem_fao_merch_season:Winter 2023,custitem_fao_neckline:Round,custitem_fao_nodiscount:No,custitem_fao_pattern_detail:Solid,custitem_fao_pocket:Patch,custitem_fao_sleeve_length:Long Sleeve,custitem_fao_sleeve_type:Set-In,custitem_fao_solid_pattern:Solid,custitem_fao_style_code:1110352,custitem_fao_style_color:1110352-010,division:Men,hierarchy:Men-Casual Wovens,markdown:No,product_type:Tops,size_category:shirts,size_range:XS to XXL"
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
                                        "discountAllocations": [],
                                        "taxLines": [
                                            {
                                                "rate": 0.05,
                                                "title": "CANADA GST/TPS",
                                                "priceSet": {
                                                    "shopMoney": {
                                                        "amount": "2.15"
                                                    }
                                                }
                                            },
                                            {
                                                "rate": 0.08,
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
            "requestedQueryCost": 38,
            "actualQueryCost": 21,
            "throttleStatus": {
                "maximumAvailable": 20000.0,
                "currentlyAvailable": 19979,
                "restoreRate": 1000.0
            }
        }
    }
}
```
</details>