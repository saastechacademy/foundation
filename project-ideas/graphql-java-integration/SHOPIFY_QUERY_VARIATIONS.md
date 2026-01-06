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
      endCursor 
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
      endCursor 
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
            endCursor 
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
      endCursor 
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
      endCursor 
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
      endCursor 
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
      endCursor 
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
      endCursor 
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

### 10) Update order note (Mutation)
Purpose: validate mutation syntax, input objects, and userErrors pattern.

✅ Valid Shopify mutation
```graphql
mutation OrderUpdateNote($input: OrderInput!) {
  orderUpdate(input: $input) {
    order {
      id
      name
      note
      updatedAt
    }
    userErrors {
      field
      message
    }
  }
}
```

Example variables (runtime, not part of GraphQL validation):
```json
{
  "input": {
    "id": "gid://shopify/Order/1234567890",
    "note": "Reviewed by fraud team"
  }
}
```

### 11) Add tags to an order (Mutation)
Why this one is interesting:
- Uses a union/interface return (node)
- Requires an inline fragment (`... on Order`)
- Still follows payload + userErrors pattern

This mutation helps you validate:
- inline fragments in mutations
- polymorphic payloads

```graphql
mutation OrderAddTags($id: ID!, $tags: [String!]!) {
  tagsAdd(id: $id, tags: $tags) {
    node {
      ... on Order {
        id
        tags
      }
    }
    userErrors {
      field
      message
    }
  }
}
```
