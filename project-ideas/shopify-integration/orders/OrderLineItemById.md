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
        pageInfo {
          hasNextPage
          endCursor
        }
        edges {
          node {
            id
            quantity
            originalUnitPriceSet {
              shopMoney {
                amount
              }
            }
            customAttributes {
              key
              value
            }
            title
            name
            variant {
              legacyResourceId
              title
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
            taxLines {
              title
              rate
              priceSet {
                shopMoney {
                  amount
                }
              }
            }
            requiresShipping
            nonFulfillableQuantity
            unfulfilledQuantity
            isGiftCard
          }
        }
      }
    }
  }
}
