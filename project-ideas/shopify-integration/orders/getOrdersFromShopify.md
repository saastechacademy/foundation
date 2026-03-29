## Fetching Orders from Shopify via GraphQL

To integrate Shopify orders with HotWax, we begin by fetching the order data from Shopify using a GraphQL query.
Shopify provides a flexible and efficient way to retrieve order data, allowing us to specify exactly what information we need. 
The GraphQL query can pull details such as order number, customer data, line items, shipping information, and payment details.

## Design

1. Scheduled Service Job - queue_GetOrdersFromShopify

- The scheduled job calls the service `co.hotwax.shopify.system.ShopifySystemMessageServices.queue#FeedSystemMessage`.
- This is a generic service in shopify-connector to queue a feed generation system message, `GetOrdersFromShopify`. 
- This can take in parameters like fromDate and thruDate to get orders from Shopify based on a time cursor.
- This can also take in additionalParameters map containing any additional filter parameters.
- This job will be configured with a cron expression to generate the feed as a bath process with systemMessageTypeId, systemMessageRemoteId and runAsBatch=true.
- Once the System Message of type **GetOrdersFromShopify** is created, the system invokes the senServiceService `get#OrdersFromShopify`.

### **Service** `get#OrdersFromShopify`

This service acts as the primary orchestration layer for the Shopify order ingestion process. 
It is responsible for coordinating paginated GraphQL execution based on parameters stored in the System Message and delegating page-level processing to a dedicated upload service.

The service itself does not perform data transformation or persistence; instead, it controls execution flow, pagination state, and transactional boundaries.

#### Responsibilities
1. Read System Message Context
   - Fetches the System Message created by the scheduled job.
   - Parses the message payload to extract GraphQL query parameters such as `fromDate`, `thruDate`, and any additional filters.
2. Initialize Pagination State
   - Initializes pagination control variables (`hasNextPage` and `cursor`). 
   - Maintains pagination state across iterations until all pages are processed.
3. Page-wise Orchestration
   - Iterates through Shopify order pages using a controlled loop.
   - For each page, invokes `upload#ShopifyOrdersResponse` as a new transaction, ensuring isolation and partial progress persistence.
4. Delegate Page Processing
   - Passes query parameters, cursor position, and page metadata to the upload service. 
   - Receives pagination metadata (hasNextPage, endCursor) from the upload service to determine continuation.
5. Fault Tolerance & Scalability
   - By delegating each page to a separate transactional service, failures in one page do not affect previously processed pages.
   - Enables scalable handling of large order volumes without long-running transactional locks.

### **Service** `upload#ShopifyOrdersResponse`

This service is responsible for page-level processing of Shopify orders. It executes a single paginated GraphQL request, 
enriches order data with additional details, and persists the resulting dataset as a raw JSON feed in Moqui Data Manager.

Each invocation of this service operates within its own transaction to ensure isolation and recoverability.

#### Responsibilities
1. Resolve System Message Context
   - Fetches the System Message associated with the current execution.
   - Uses the System Message metadata (e.g., Shopify store context) required for GraphQL requests.
2. Execute Shopify GraphQL Query
   - Loads the GraphQL query template [OrdersQuery](OrdersQuery.md). This query will get all the required order header level data.
   - Executes the query against Shopify using the provided cursor and query parameters. 
   - Retrieves a single page of order headers along with pagination metadata.
3. Order-level Enrichment
   - Iterates through each order from the GraphQL response. 
   - For every order, invokes `get#OrderLevelDetails` to fetch additional order-specific details, [ShippingLinesByOrderIdQuery](ShippingLinesByOrderIdQuery.md) and [OrderLineItemById](OrderLineItemById.md).
   - Pagination is done to include all the shippingLines and lineItems and prepare the complete order data.
4. Persist to Data Manager
   - Aggregates enriched orders into a list.
   - Serializes the list into a JSON array representing a single page of orders.
   - Creates an in-memory file representation without writing to the local filesystem.
   - Uploads the generated JSON file to Moqui Data Manager using the utility service `upload#DataManagerFile`.
   - Each file corresponds to a single page of Shopify orders, enabling replay and auditability.
5. Return Pagination State
   - Extracts and returns `hasNextPage` and `endCursor` values.
   - Enables the calling orchestration service to determine whether additional pages need to be processed.

#### Design Intent

The separation between get#OrdersFromShopify and upload#ShopifyOrdersResponse ensures:
- Clear ownership of orchestration vs. data handling
- Improved fault tolerance during large imports
- Scalable processing of high-volume Shopify order data
- Clean handoff between ingestion and downstream transformation workflows