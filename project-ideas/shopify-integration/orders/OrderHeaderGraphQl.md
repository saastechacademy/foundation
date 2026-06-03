## Order header graphQl  
This GraphQL query fetches the basic order details from Shopify. It retrieves only the top-level fields of the order without expanding or including any related connection data such as line items and shipping lines.  
```gql
query {
        orders(first: 50) {
        pageInfo{
            hasNextPage
            endCursor
        }    
        edges{
            node{
                legacyResourceId
                id
                name
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
                phone
                email
                displayFulfillmentStatus
                statusPageUrl
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
                transactions {
                    id
                    kind
                    status
                    gateway
                    paymentDetails {
                        ... on CardPaymentDetails {
                            company
                        }
                    }
                    amountSet {
                        presentmentMoney {
                            amount
                        }
                    }
                    receiptJson
                    settlementCurrency
                    parentTransaction {
                        id
                        paymentDetails {
                            ... on CardPaymentDetails {
                                company
                            }
                        }
                    }
                }
            }
        }
    }
}
