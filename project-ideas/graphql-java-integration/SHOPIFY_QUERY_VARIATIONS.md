## Shopify Order Query Variations

Below are the core query shapes we want to support and validate. These will guide our AST builders and test coverage.

### 1) Orders limited fields with pagination
Purpose: validate minimal selections, variable args, pageInfo, and stable “core fields”.

```graphql
query OrdersMinimal($first: Int!, $after: String) {
  orders(first: $first, after: $after) {
    edges { 
      node { 
        id 
        name 
        createdAt 
      } 
    }
    pageInfo { 
      hasNextPage 
      hasPreviousPage
      endCursor 
      startCursor
    }
  }
}
```

### 2) Orders wide field set with pagination
Reality check: In GraphQL you can’t literally ask for “all fields” without listing them. So in practice, this becomes:
“all fields we care about”
or “a large superset for replication/debug/export”
Purpose: validate your schema subset completeness (you’ll discover missing types/fields fast).

```graphql
query OrdersWide($first: Int!, $after: String) {
  orders(first: $first, after: $after) {
    edges {
      node {
        id 
        name 
        createdAt 
        updatedAt
        email
        currencyCode
        displayFinancialStatus
        displayFulfillmentStatus
        tags
        customer { 
          id 
          email 
        }
        billingAddress { 
          address1 
          city 
          country 
          zip 
        }
        shippingAddress { 
          address1 
          city 
          country 
          zip 
        }
        totalPriceSet { 
          shopMoney { 
            amount 
            currencyCode 
          } 
        }        
      }
    }
    pageInfo { 
      hasNextPage 
      hasPreviousPage
      endCursor 
      startCursor
    }
  }
}
```

### 3) Orders with lineItems and nested pagination
Purpose: validate the “connection-in-connection” pattern:

```graphql
query OrdersWithLineItems($first: Int!, $after: String, $lineItemsFirst: Int!) {
  orders(first: $first, after: $after) {
    edges {
      node {
        id 
        name
        lineItems(first: $lineItemsFirst) {
          edges { 
            node { 
              title 
              quantity 
              sku 
              originalUnitPriceSet { 
                shopMoney { 
                  amount 
                  currencyCode 
                } 
              }
            } 
          }
          pageInfo { 
            hasNextPage 
            hasPreviousPage
            endCursor 
            startCursor
          }
        }
      }
    }
    pageInfo { 
      hasNextPage 
      hasPreviousPage
      endCursor 
      startCursor
    }
  }
}
```

### 4) Orders with inline fragment in shippingLines
Polymorphism: InlineFragment

Two important Shopify concepts here:
1. DiscountApplication captures “intent/rules”; DiscountAllocation captures the actual applied amounts on line items/shipping lines. 
2. DiscountCodeApplication is a concrete type implementing that interface (so inline fragment is valid).

```graphql
query OrdersWithShippingDiscounts($first: Int!, $after: String) {
  orders(first: $first, after: $after) {
    edges {
      node {
        id 
        name
        shippingLines(first: 5) {
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
                rate
                priceSet { 
                  shopMoney { 
                    amount 
                    currencyCode 
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
        }
      }
    }
    pageInfo { 
      hasNextPage
      hasPreviousPage
      endCursor 
      startCursor
    }
  }
}
```

### 5) Orders with filter query argument
eg. Date-window or incremental sync

Purpose: validate your use of query: filter strings + possibly sortKey.
Shopify explicitly documents that orders supports filtering, and their pagination guide shows using query with created_at + sortKey. 

Example runtime variable for $query you’d pass:
created_at:>='2026-01-01'

(Exact filter syntax is Shopify-search-string style; we’ll treat it as an opaque string for AST + validation purposes.)

```graphql
query OrdersByCreatedAt($first: Int!, $after: String, $query: String!) {
  orders(first: $first, after: $after, query: $query, sortKey: CREATED_AT) {
    edges { 
      node { 
        id 
        createdAt 
        name 
      } 
    }
    pageInfo { 
      hasNextPage 
      hasPreviousPage
      endCursor 
      startCursor
    }
  }
}

```

### 6) Orders sorted with enums and reverse
```graphql
query OrdersSorted($first: Int!, $sortKey: OrderSortKeys!, $reverse: Boolean) {
  orders(first: $first, sortKey: $sortKey, reverse: $reverse) {
    edges { 
      node { 
        id 
        name 
        createdAt 
      } 
    }
    pageInfo { 
      hasNextPage 
      hasPreviousPage
      endCursor 
      startCursor
    }
  }
}
```

### 7) Orders with multiple nested connections
```graphql
query OrdersMultiNested($first: Int!, $after: String, $liFirst: Int!, $refundFirst: Int!) {
  orders(first: $first, after: $after) {
    edges {
      node {
        id name
        lineItems(first: $liFirst) { 
          edges { 
            node { 
              title 
              quantity 
            } 
          } 
        }
        refunds(first: $refundFirst) { 
          edges { 
            node { 
              id 
              createdAt 
            } 
          } 
        }
      }
    }
    pageInfo { 
      hasNextPage 
      hasPreviousPage
      endCursor 
      startCursor
    }
  }
}
```

### 8) Fragment-based reuse (money, addresses, core order fields)
Purpose: validate fragments in your schema subset + ensure your builder can compose them.

```graphql
fragment Money on MoneyV2 {
  amount
  currencyCode
}

fragment OrderCore on Order {
  id
  name
  createdAt
  totalPriceSet { 
    shopMoney { 
      ...Money 
    } 
  }
}

query OrdersUsingFragments($first: Int!, $after: String) {
  orders(first: $first, after: $after) {
    edges { 
      node { 
        ...OrderCore 
      } 
    }
    pageInfo { 
      hasNextPage
      hasPreviousPage
      endCursor 
      startCursor
    }
  }
}

```

### 9) Orders with multiple inline fragments on discountApplications

```graphql
query OrdersDiscountApplications($first: Int!, $after: String) {
  orders(first: $first, after: $after) {
    edges {
      node {
        id 
        name
        discountApplications(first: 5) {
          edges {
            node {
              __typename
              ... on DiscountCodeApplication { 
                code 
              }
              ... on ManualDiscountApplication { 
                title 
                description 
              }
            }
          }
        }
      }
    }
  }
}
```

### 10) Orders with input object argument

```graphql
query OrdersComplexFilter($first: Int!, $query: String) {
  orders(first: $first, query: $query) {
    edges { 
      node { 
        id 
        name 
        createdAt 
      } 
    }
  }
}
```
