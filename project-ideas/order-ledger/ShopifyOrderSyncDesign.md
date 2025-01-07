# Shopify/OMS Order Sync Design

Newly created orders and specific order updates in Shopify needs to be synced timely to OMS. This design document is specific to syncing newly created Shopify orders.   
Following would be the flow to sync products,
1. **mantle-shopify-connector** would produce a periodic json feed of newly created orders.
2. **shopify-oms-bridge** would consume this feed and transform it to produce OMS orders json feed.
3. **oms** would consume the transformed product json feed and establish orders in OMS database via order API.

> Notes
> - Not setting origin facility contact mechs as it doesn't make sense for already completed or cancelled orders or until the order is brokered.
> - Designs reflect the assumption that order items will always be exploded.
> - Not adding bill from ContactMech details as they are just copied from payToPartyId

> TODO
> - Check and add support for OrderNote(s)
> - Support to create a dummy product for non-existing Shopify product
> - Support to create OrderPaymentPreference(s) for Shopify order transactions
> - Support to create OrderPaymentPreference for Shopify order payment term
> - Support for preorder and backorder
> - Support to create OrderItemAssociation(s) for exchange orders
> - Support to create OrderNote for shopifyOrder.note
> - Handle shopifyOrder.tags (Free Text or Keywords?)
> - What is the purpose of storing shopifyOrder.statusPageUrl (order_status_url in rest)
> - Analyze all the communication events created in legacy flow

## Shopify Connector
Shopify connector would produce a periodic created orders feed since last run time with following fields,

```
Order {
    id
    name
    displayFulfillmentStatus
    createdAt
    cancelledAt
    channelInformation {
        channelDefinition {
            handle
        }
    }
    customAttributes {
        key
        value
    }
    customer {
        id
        firstName
        lastName
    }
    phone
    email
    tags
    note
    currencyCode
    presentmentCurrencyCode
    totalPriceSet {
        presentmentMoney {
            amount
            currencyCode
        }
    }
    currentTotalPriceSet {
        presentmentMoney {
            amount
            currencyCode
        }
    }
    shippingAddress {
        name
        address1
        address2
        city
        zip
        provinceCode
        countryCodeV2
        latitude
        longitude
        phone
    }
    billingAddress {
        name
        address1
        address2
        city
        zip
        provinceCode
        countryCodeV2
        latitude
        longitude
        phone
    }
    shippingLines (first: 5) {
        edges {
            node {
                title
                originalPriceSet {
                    presentmentMoney {
                        amount
                        currencyCode
                    }
                }
                discountAllocations {
                    allocatedAmountSet {
                        presentmentMoney {
                            amount
                            currencyCode
                        }
                    }
                    discountApplication {
                         ... on DiscountCodeApplication {
                            code
                            targetType
                            value {
                                ... on PricingPercentageValue {
                                    percentage
                                }
                            }
                        }
                    }
                }
                taxLines {
                    title
                    priceSet {
                        presentmentMoney {
                            amount
                            currencyCode
                        }
                    }
                }
            }
        }
    }
    totalTipReceivedSet {
        presentmentMoney {
            amount
            currencyCode
        }
    }
    fulfillmentOrders (first: 5) {
        edges {
            node {
                id
                status
                assignedLocation {
                    location {
                        id
                    }
                }
                deliveryMethod {
                    methodType
                    serviceCode
                }
                lineItems (first: 5) {
                    edges {
                        node {
                            id
                            lineItem {
                                id
                                sku
                                variant {
                                    id
                                    barcode
                                    title
                                }
                                originalUnitPriceSet {
                                    presentmentMoney {
                                        amount
                                    }
                                }
                                quantity
                                nonFulfillableQuantity
                                customAttributes {
                                    key
                                    value
                                }
                                taxLines {
                                    title
                                    ratePercentage
                                    priceSet {
                                        presentmentMoney {
                                            amount
                                            currencyCode
                                        }
                                    }
                                }
                                discountAllocations {
                                    allocatedAmountSet {
                                        presentmentMoney {
                                            amount
                                            currencyCode
                                        }
                                    }
                                    discountApplication {
                                        ... on DiscountCodeApplication {
                                            code
                                            value {
                                                ... on PricingPercentageValue {
                                                    percentage
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            totalQuantity
                            remainingQuantity
                        }
                    }
                }
            }
        }
    }
}
```

## Shopify OMS Bridge

Periodically receive and consume ShopifyNewOrdersFeed and transform to generated OMSNewOrdersFeed.
Following are the implementation details,
1. Define and configure *ShopifyNewOrdersFeed* SystemMessageType to import Shopify new orders feed, define *consumeSmrId* SystemMessageType parameter to be used in the next system message produced in consume service. Refer *ShopifyOrderCancelUpdatesFeed* SystemMessageType.
2. Generic service *consume#ShopifyFeed* to be used as consume service for this flow.
3. Define and configure *GenerateOMSNewOrdersFeed* SystemMessageType, refer *GenerateOMSOrderCancelUpdatesFeed* SystemMessageType. Configure *sendSmrId* SystemMessageTypeParameter to send the feed to SFTP.
4. Implement sendService *generate#OMSNewOrdersFeed*, refer implementation details below.
5. Define and configure *SendOMSNewOrdersFeed* SystemMessageType to send the feed to SFTP.

### [generate#OMSNewOrdersFeed](generateOMSNewOrdersFeed.md)

### [map#SalesOrder](mapSalesOrder.md)

## OMS API

### Seed Data
```xml
<org.apache.ofbiz.common.datasource.DataSourceType dataSourceTypeId="EXTERNAL_SYSTEM" description="External System"/>
<org.apache.ofbiz.common.datasource.DataSource dataSourceId="SHOPIFY" dataSourceTypeId="EXTERNAL_SYSTEM" description="Shopify"/>
```
### [create#PostalAddress](../oms/createPostalAddress.md)

### [findOrCreate#Person](../oms/findOrCreatePerson.md)

### [create#SalesOrder](createSalesOrder.md)

### [findOrCreate#Product](../oms/findOrCreateProduct.md)
