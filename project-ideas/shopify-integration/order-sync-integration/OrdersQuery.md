## Orders query graphQl
It fetches all details of order in one graphQl call.  
Disadvantage-
- Pagination can not be performed on connection objects.
- Query cost is very high
```gql
query {
              orders(first: 50<#if cursor?has_content>, after: "${cursor}"</#if><#if filterQuery?has_content>, query: "${filterQuery}"</#if>) {
                edges {
                  node {
                    id
                    legacyResourceId
                    tags
                    totalPriceSet {
                      shopMoney {
                        amount
                        currencyCode
                      }
                    }
                    sourceName
                    shippingAddress {
                        name
                        address1
                        address2
                        city
                        country
                        zip
                        provinceCode
                        countryCodeV2
                        latitude
                        longitude
                        phone
                    }
                    billingAddress {
                      firstName
                      lastName
                      phone
                      address1
                      address2
                      longitude
                      latitude
                      city
                      province
                      country
                      zip
                      countryCode
                    }
                    phone
                    email
                    displayFulfillmentStatus
                    retailLocation {
                      id
                      legacyResourceId
                    }
                    customer {
                      legacyResourceId
                      id
                      firstName
                      lastName
                    }
                    customAttributes {
                        key
                        value
                    }
                    note
                    createdAt
                    cancelledAt
                    closedAt
                    currencyCode
                    presentmentCurrencyCode
                    name
                    shippingLines (first: 5) {
                        edges {
                            node {
                                title
                                originalPriceSet {
                                    shopMoney {
                                        amount
                                        currencyCode
                                    }
                                }
                                taxLines {
                                    title
                                    priceSet {
                                        shopMoney {
                                            amount
                                            currencyCode
                                        }
                                    }
                                    rate
                                }
                                discountAllocations {
                                    allocatedAmountSet {
                                        shopMoney {
                                            amount
                                        }
                                    }
                                    discountApplication {
                                        __typename
                                        ... on DiscountCodeApplication {
                                            code
                                        }
                                    }
                                }
                            }
                        }
                    }
                    lineItems(first: 50) {
                        pageInfo {
                            hasNextPage
                        }
                      edges {
                        node {
                          id
                          title
                          name
                          quantity
                          variant {
                            legacyResourceId
                            title
                            inventoryItem {
                                id
                                tracked
                            }
                          }
                          customAttributes {
                            key
                            value
                          }
                          originalUnitPriceSet {
                            shopMoney {
                              amount
                            }
                          }
                          requiresShipping
                          isGiftCard
                          discountAllocations {
                            allocatedAmountSet {
                              shopMoney {
                                amount
                              }
                            }
                            discountApplication {
                                __typename
                                ... on DiscountCodeApplication {
                                    code
                                }
                            }
                          }
                          nonFulfillableQuantity
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
                      }
                    }
                    customerLocale
                    totalTipReceivedSet {
                        shopMoney {
                            amount
                        }
                    }
                    fulfillments{
                        status
                        location{
                            legacyResourceId
                        }
                        trackingInfo {
                            number
                            company
                        }
                        fulfillmentLineItems(first:10){
                            edges{
                                node{
                                    lineItem{
                                        id
                                        quantity
                                        customAttributes{
                                            key
                                            value
                                        }
                                    }
                                }
                            }
                        }
                    }
                  }
                }
                pageInfo {
                  hasNextPage
                  endCursor
                  startCursor
                }
              }
            }
