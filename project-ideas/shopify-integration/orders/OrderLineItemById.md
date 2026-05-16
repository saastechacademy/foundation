## Order Line Item by Id
It fetches the line item of each order. It also handels pagination logic on line items
```gql
   query {
    node(id: "${shopifyOrderId}") {
        id
        ... on Order {
            id
            name
            lineItems(first: 10) {
                edges {
                    node {
                        id
                        title
                        name
                        quantity
                        variant {
                            legacyResourceId
                            title
                        }
                        originalUnitPriceSet {
                            shopMoney {
                                amount
                            }
                        }
                        requiresShipping
                        nonFulfillableQuantity
                        unfulfilledQuantity
                        isGiftCard
                        customAttributes {
                            key
                            value
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
                pageInfo {
                    hasNextPage
                    endCursor
                }
            }
        }
    }
}    
