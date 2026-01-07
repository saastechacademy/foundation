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

Example variables (runtime, not part of GraphQL validation):
```json
{
  "first": 50,
  "after": "eyJ2IjoxLCJ0IjoiMjAyNi0wMS0wMVQwMDowMDowMFoifQ=="
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

Example variables (runtime, not part of GraphQL validation):
```json
{
  "first": 50,
  "after": "eyJ2IjoxLCJ0IjoiMjAyNi0wMS0wMVQwMDowMDowMFoifQ==",
  "query": "created_at:>='2026-01-01'",
  "discountApplicationsFirst": 5,
  "lineItemsFirst": 10,
  "returnsFirst": 5,
  "shippingLinesFirst": 5
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

Example variables (runtime, not part of GraphQL validation):
```json
{
  "first": 50,
  "after": "eyJ2IjoxLCJ0IjoiMjAyNi0wMS0wMVQwMDowMDowMFoifQ==",
  "lineItemsFirst": 10
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

Example variables (runtime, not part of GraphQL validation):
```json
{
  "first": 50,
  "after": "eyJ2IjoxLCJ0IjoiMjAyNi0wMS0wMVQwMDowMDowMFoifQ=="
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

Example variables (runtime, not part of GraphQL validation):
```json
{
  "first": 50,
  "after": "eyJ2IjoxLCJ0IjoiMjAyNi0wMS0wMVQwMDowMDowMFoifQ==",
  "query": "created_at:>='2026-01-01'"
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

Example variables (runtime, not part of GraphQL validation):
```json
{
  "first": 50,
  "sortKey": "CREATED_AT",
  "reverse": false
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

Example variables (runtime, not part of GraphQL validation):
```json
{
  "first": 50,
  "after": "eyJ2IjoxLCJ0IjoiMjAyNi0wMS0wMVQwMDowMDowMFoifQ==",
  "liFirst": 10,
  "refundFirst": 5
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

Example variables (runtime, not part of GraphQL validation):
```json
{
  "first": 50,
  "after": "eyJ2IjoxLCJ0IjoiMjAyNi0wMS0wMVQwMDowMDowMFoifQ=="
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

Example variables (runtime, not part of GraphQL validation):
```json
{
  "first": 50,
  "after": "eyJ2IjoxLCJ0IjoiMjAyNi0wMS0wMVQwMDowMDowMFoifQ=="
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

Example variables (runtime, not part of GraphQL validation):
```json
{
  "id": "gid://shopify/Order/1234567890",
  "tags": ["VIP", "priority"]
}
```

### 12) Bulk operation run query (Mutation with query string)
Purpose: validate `bulkOperationRunQuery` which embeds a full GraphQL query as a string.

```graphql
mutation {
  bulkOperationRunQuery(query: """ {
    orders {
      edges { 
        node { 
            id 
            name 
            createdAt 
        } 
      } 
    }
  } """ ) {
    bulkOperation { 
        id 
        status 
    }
    userErrors { 
        field 
        message 
    }
  }
}
```

### 13) Bulk operation run mutation (Mutation with mutation string + staged upload)
Purpose: validate `bulkOperationRunMutation` with `stagedUploadPath`.

```graphql
mutation {
  bulkOperationRunMutation(
    mutation: """
      mutation ($input: OrderInput!) {
        orderUpdate(input: $input) {
          order {
            id
            tags
          }
          userErrors {
            message
            field
          }
        }
      }
    """
    stagedUploadPath: "tmp/bulk/order_update.jsonl"
  ) {
    bulkOperation {
      id
      url
      status
    }
    userErrors {
      message
      field
    }
  }
}
```

### 14) Staged upload create (List input object mutation)
Purpose: validate list input objects and nested response shapes.

```graphql
mutation stagedUploadsCreate($input: [StagedUploadInput!]!) {
  stagedUploadsCreate(input: $input) {
    stagedTargets {
      url
      resourceUrl
      parameters { 
        name 
        value 
      }
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
  "input": [
    {
      "resource": "BULK_MUTATION_VARIABLES",
      "filename": "order_update.jsonl",
      "mimeType": "text/jsonl",
      "httpMethod": "POST",
      "fileSize": "1024"
    }
  ]
}
```

### 15) Polymorphic node fetch (node(id:))
Purpose: validate `node(id:)` with inline fragments for specific types.

```graphql
query BulkOperationById($id: ID!) {
  node(id: $id) {
    ... on BulkOperation {
      id
      status
      errorCode
      createdAt
      completedAt
      objectCount
      fileSize
      url
      partialDataUrl
    }
  }
}
```

Example variables (runtime, not part of GraphQL validation):
```json
{
  "id": "gid://shopify/BulkOperation/1234567890"
}
```

### 16) Metafields by namespace with aliasing
Purpose: validate metafields queries with namespace args and field aliasing.

```graphql
query OrderMetafields($id: ID!, $namespace: String) {
  node(id: $id) {
    ... on Order {
      metafields(first: 10, namespace: $namespace) {
        edges {
          node { 
            id 
            key 
            namespace 
            value 
            type 
          }
        }
      }
    }
  }
}
```

Example variables (runtime, not part of GraphQL validation):
```json
{
  "id": "gid://shopify/Order/1234567890",
  "namespace": "custom"
}
```

```graphql
query VariantMetafields($query: String!) {
  productVariants(query: $query) {
    edges {
        node {
            id
            mf1: metafields(namespace: "ns1") { 
                edges { 
                    node { 
                        id 
                        key 
                        value 
                    } 
                } 
            }
            mf2: metafields(namespace: "ns2") { 
                edges { 
                    node { 
                        id 
                        key 
                        value 
                    } 
                } 
            }
        }
    }
  }
}
```

Example variables (runtime, not part of GraphQL validation):
```json
{
  "query": "sku:ABC-123"
}
```

### 17) Webhook subscription create (variable args)
Purpose: validate input variables for enum and input object fields.

```graphql
mutation WebhookSubscriptionCreate($topic: WebhookSubscriptionTopic!, $callbackUrl: String!) {
  webhookSubscriptionCreate(
    topic: $topic
    webhookSubscription: { 
      uri: $callbackUrl,
      format: JSON
    }
  ) {
    webhookSubscription { 
      id 
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
  "topic": "ORDERS_CREATE",
  "callbackUrl": "https://example.com/hook"
}
```

### 18) Webhook subscription query (union endpoint)
Purpose: validate inline fragments on union/interface fields in query results.

```graphql
query {
  webhookSubscriptions(first: 1) {
    edges {
      node {
        id
        topic
        endpoint {
          __typename
          ... on WebhookHttpEndpoint { 
            callbackUrl 
          }
        }
      }
    }
  }
}
```
