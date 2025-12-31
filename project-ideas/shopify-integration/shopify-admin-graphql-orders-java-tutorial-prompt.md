I’m a Java developer building an integration with the Shopify Admin GraphQL API, focused on Order data. I have basic GraphQL knowledge, but I’m new to:

- Shopify’s Admin GraphQL specifics (orders, filters, pagination).
- The idea of splitting a GraphQL query and variables into "query" and "variables" in the JSON request.
- Writing Java code that builds the GraphQL request body cleanly (without ugly string concatenation), sends it to Shopify, and handles pagination.
- Please teach me all of this in a step-by-step, beginner-friendly tutorial, using simple examples and minimal fields so it’s not overwhelming. Structure it like a workshop:

## Basics of Shopify Admin GraphQL for Orders

- How to write a minimal GraphQL query to fetch a single order (show the GraphQL only).
- How to write a simple orders(first: N) query to get multiple orders.
- Explain briefly what the Order object is and link to the official docs.
- Splitting query and variables

## Explain clearly what "query" and "variables" mean in the HTTP JSON body sent to Shopify.
- Show a small example GraphQL query that uses variables (e.g., query OrdersSearch($search: String!, $first: Int!, $after: String)).
- Show the corresponding JSON body with "query": "..." and "variables": { ... }.
- Use plain, non-Shopify example first, then a simple Shopify orders example.
- Applying variables to Shopify order filters

## Use a query that filters orders by created_at and financial_status, via the query argument (Shopify search syntax).
- Show how to declare variables for:
- the search string ($search: String!),
- page size ($first: Int!),
- pagination cursor ($after: String).
- Show the GraphQL string once, then several different variables JSON objects to illustrate how we can reuse the same query with different filters and cursors.
- Cursor-based pagination walkthrough

## Explain edges, node, cursor, and pageInfo in simple, intuitive terms (use analogies).

### Show a minimal orders query using:
- first, after,
- sortKey: CREATED_AT,
- pageInfo { hasNextPage endCursor }.
- Explain clearly how to:
- Run the first page (with after: null).
- Read pageInfo.endCursor.
- Use that cursor as after to request the next page.
- Show how to use created_at filter (via query argument) to fetch only newly created orders since a timestamp.
- Java integration (focus on clarity, not frameworks)

### Assume I use Java 11+ with:
- java.net.http.HttpClient for HTTP,
- Jackson (ObjectMapper) for JSON.
- Show a small Java class that:
- Holds the GraphQL query as a multi-line String.
- Builds a Map<String, Object> for variables.
- Builds { "query": ..., "variables": ... }.
- Serializes that to JSON.
- Sends it to https://{shop}.myshopify.com/admin/api/{version}/graphql.json with proper headers (Content-Type, X-Shopify-Access-Token).
- Prints the status code and body.
- Provide a full, compilable Java example (or close to it) that:
- Runs a simple orders query with filters and pagination.
- Shows how to replace the cursor between calls (either manually or in a loop).
- OMS-oriented example

### Extend the example query slightly to include OMS-relevant fields:
- id, name, createdAt, email, phone,
- shippingAddress { ... } (simple subset),
- totalPriceSet.shopMoney { amount currencyCode }.

### Show how to:
- Poll for new orders (created since lastSyncedCreatedAt),
- Loop through pages until hasNextPage is false,
- For each order, upsert into an RDBMS (conceptual description; simple pseudo-code is fine).
- Best practices

Summarize best practices for:
- Keeping the GraphQL query text static and using variables for all dynamic values.
- Handling pagination safely with created_at and after cursors.
- Avoiding brittle string concatenation in Java (use multi-line strings and a variables map).
- Respecting Shopify’s API throttling (briefly mention extensions.cost.throttleStatus but don’t go too deep).

Tone/formatting:
- Keep explanations simple, patient, and encouraging.
- Use small GraphQL snippets first, then gradually add fields as we go.
- Use clear headings and code blocks.
- Assume I’m comfortable with Java syntax but new to the Shopify-specific patterns.

At the end, include:

- A “cheat sheet” section that shows:
- A template GraphQL query with variables for orders + filters + pagination.
- A template Java method that takes searchString, first, and after, and returns the raw JSON response string.