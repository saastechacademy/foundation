# Shopify Admin GraphQL: Beginner Tutorial for Querying Orders with Cursor-Based Pagination

This is a hands-on, beginner-friendly mini-workshop to help you learn how to query Shopify’s Admin GraphQL API for order data, with a focus on cursor-based pagination.

You will:
- Start from one simple order query
- Move to multiple orders
- Learn cursors, edges, and pageInfo step by step
- End with a practical pattern for polling new orders in production

---

## Prerequisites

Before you start, you’ll need:
1. A Shopify store where you have Admin access
2. An app or access token with at least the `read_orders` scope
3. A way to run GraphQL queries, such as:
   - The Shopify GraphiQL app (recommended), available in the Shopify Admin
   - The GraphiQL explorer in your Partner Dashboard

Useful docs:
- Admin GraphQL API overview: `/docs/api/admin-graphql`
- Pagination in Shopify GraphQL: `/docs/api/usage/pagination-graphql`

In GraphiQL:
- Choose a recent API version (e.g., `2025-10`)
- Make sure your app is connected to your development/test store

---

## Step 1 – Query a single order by ID

Goal: Get comfortable with the shape of an `Order` using a very small field set.

### 1.1 Get an order ID

First, list one order to grab its ID:

```graphql
query {
  orders(first: 1) {
    edges {
      node {
        id
        name
      }
    }
  }
}
```

What’s happening:
- `orders(first: 1)` asks for the first 1 order
- `edges` is a list wrapper; each edge holds:
  - a `cursor` (used later)
  - a `node` (the actual order)
- `node { id name }` requests the order’s `id` and `name`

From the JSON response:
- Copy the `id` value, which looks like `gid://shopify/Order/1234567890`

### 1.2 Query that specific order

Now query that one order by ID:

```graphql
query SingleOrder {
  order(id: "gid://shopify/Order/1234567890") {
    id
    name
    createdAt
    currencyCode
    totalPriceSet {
      shopMoney {
        amount
        currencyCode
      }
    }
  }
}
```

Explanation:
- `order(id: "...")` fetches exactly one order
- `createdAt` is when the order was placed
- `currencyCode` is the base currency
- `totalPriceSet.shopMoney.amount` is the total amount in shop currency

Try this in GraphiQL and inspect the response.

---

## Step 2 – List multiple orders (basic list, no pagination yet)

Goal: Learn the basic `orders` query and understand `edges` and `node`.

```graphql
query FirstFiveOrders {
  orders(first: 5) {
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

What this does:
- `orders(first: 5)` requests 5 orders
- `edges` is a list wrapper
- `node` is the actual order

At this point, we’re ignoring pagination.

---

## Step 3 – Concept: cursors and pageInfo (the “bookmarks”)

Shopify uses cursor-based pagination.

Think of a long bookshelf of orders:
- Each order has a hidden bookmark before it — that’s the cursor
- When you say “give me 5 orders after this bookmark,” Shopify resumes from there

Two key elements:
1. Cursor (`cursor` on each edge)
   - A bookmark for the position before that node
   - You don’t interpret it; you just pass it back later
2. pageInfo
   - `hasNextPage` tells you if more data exists
   - `endCursor` is the bookmark at the end of the current page

Analogy:
- `edges[i].cursor`: bookmark before order i
- `pageInfo.endCursor`: bookmark at the end of the current page

---

## Step 4 – Add `cursor` and `pageInfo` (see the structure)

Goal: See where cursors and pageInfo show up in the response.

```graphql
query FirstFiveOrdersWithCursors {
  orders(first: 5) {
    edges {
      cursor
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

In the JSON response:
- `edges[i].cursor` is an opaque string
- `pageInfo.hasNextPage` is true or false
- `pageInfo.endCursor` usually equals the cursor of the last edge

You do not need to decode the cursor.

---

## Step 5 – Fetch the next page with `after`

Goal: Use `endCursor` to get the second page of results.

1. Run the query from Step 4
2. Copy `pageInfo.endCursor`
3. Use it in a query like this:

```graphql
query NextFiveOrders($after: String!) {
  orders(first: 5, after: $after) {
    edges {
      cursor
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

Variables:

```json
{
  "after": "PASTE_END_CURSOR_HERE"
}
```

Result:
- You get the next 5 orders after the cursor
- Repeat `first: N, after: endCursor` until `hasNextPage` is false

---

## Step 6 – Sort by creation time for new orders

If you only care about newly created orders (for syncing to an OMS):
- Sort by creation time
- Filter by `created_at` using Shopify’s search syntax

### 6.1 Newest orders (latest first)

```graphql
query NewestOrders {
  orders(first: 5, sortKey: CREATED_AT, reverse: true) {
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

- `sortKey: CREATED_AT` sorts by createdAt
- `reverse: true` shows newest first

### 6.2 Orders created since a time

```graphql
query OrdersCreatedSince($query: String!) {
  orders(first: 5, sortKey: CREATED_AT, reverse: false, query: $query) {
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

Variables:

```json
{
  "query": "created_at:>=2025-01-01T10:00:00Z"
}
```

This returns orders oldest-to-newest created on or after that time.

---

## Step 7 – Polling for new orders with pagination

A simple polling pattern for syncing new orders to an OMS:

1. Keep a checkpoint: `lastSyncedCreatedAt` (DateTime)
2. On each run:
   - Build a query string like `created_at:>={lastSyncedCreatedAtISO}`
   - Use `sortKey: CREATED_AT`, `reverse: false`
   - Fetch pages using `first: N`, `after: endCursor`
   - Track the highest `createdAt` seen
3. After the run:
   - Update `lastSyncedCreatedAt` to the max `createdAt`

### 7.1 Minimal OMS-focused query with pagination

```graphql
query NewOrdersSimple($createdSince: String!, $first: Int = 5, $after: String) {
  orders(
    first: $first
    after: $after
    sortKey: CREATED_AT
    reverse: false
    query: $createdSince
  ) {
    edges {
      cursor
      node {
        id
        name
        createdAt
        email
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

How to use it:
- First run: set `createdSince` to your initial timestamp and `after` to null
- Process first page
- If `hasNextPage` is true, call again with `after: endCursor`
- When done, update `lastSyncedCreatedAt` to the max `createdAt`

---

## Step 8 – Add more OMS-relevant fields gradually

Once you’re comfortable, add more fields in small steps.

Example including shipping addresses:

```graphql
query NewOrdersWithAddresses($createdSince: String!, $first: Int = 5, $after: String) {
  orders(
    first: $first
    after: $after
    sortKey: CREATED_AT
    reverse: false
    query: $createdSince
  ) {
    edges {
      cursor
      node {
        id
        name
        createdAt
        email
        phone
        tags
        shippingAddress {
          firstName
          lastName
          address1
          address2
          city
          province
          country
          zip
          countryCode
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

As you gain confidence, you can add:
- `billingAddress`
- `customer { ... }`
- `lineItems { ... }`
- `shippingLines { ... }`
- `discountApplications { ... }`

Test each extension step in GraphiQL to keep it manageable.

---

## Step 9 – How to test in GraphiQL (practical tips)

1. Start with very small `first` values (2 or 5)
2. Use the variables panel for parameters (`createdSince`, `first`, `after`)
3. After each query:
   - Inspect `edges`, `node`, `pageInfo`
   - Copy `endCursor`, paste into `after`, rerun
4. If you’re curious about cost and throttling, look at `extensions.cost`

---

## Step 10 – Best practices for production

### 10.1 Use explicit sorting and filters

- For new orders:
  - Always use `sortKey: CREATED_AT`, `reverse: false`
  - Use a `query` filter on `created_at` (e.g., `created_at:>={lastSyncedCreatedAtISO}`)

### 10.2 Use cursors within a run, timestamps across runs

- Within a run: use `after: endCursor` until `hasNextPage` is false
- Between runs: use `created_at` and `lastSyncedCreatedAt` as your checkpoint

### 10.3 Keep queries focused

- Don’t fetch every possible field at once
- Start from the minimum your OMS needs
- Add more fields gradually and test each change

### 10.4 Respect throttle limits

- Keep `first` small while testing
- Avoid unnecessary fields
- Monitor `extensions.cost` and back off if you approach rate limits
