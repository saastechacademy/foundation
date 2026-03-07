## Order Shipping Line Item by Id
It fetches the shipping line item of each order. It also handels pagination logic on shipping line items

```gql
query {
  node(id: "${shopifyOrderId}") {
    id
    ... on Order {
      shippingLines(first: 5) {
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
        pageInfo {
          endCursor
          hasNextPage
        }
      }
    }
  }
}
