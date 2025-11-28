# Shopify Order Import Flow

This document explains the flow used to import Shopify orders into OMS, this workflow fetches orders from Shopify using GraphQL, enriches each order by fetching additional order-level details, and stores the resulting payloads into the Data Manager as JSON files. The architecture uses Moqui System Messages, GraphQL templates, and paginated service calls.


A scheduled job is created to periodically queue a System Message of type:

**SystemMessageTypeId:** `GetOrdersFromShopify`
The job runs on a cron expression and creates a System Message with parameters for order import process, 
this System Message is the trigger for the entire Shopify order import pipeline.

**System Message Consumption**

Once the System Message of type **GetOrdersFromShopify** is created, the system automatically invokes:

**Service:** `get#OrdersFromShopify`

This is the **master orchestration service** for the order import process, it is the service which acts as the controller for fetching Shopify orders page-by-page.

### Responsibilities
1. Read incoming System Message parameters  
2. Prepare GraphQL query parameters  
3. **Generate the final `queryText`(shopify graphQl ftl)** 
4. For **each page**, invoke:
**`upload#ShopifyOrdersResponse`**
Thus the master service loops through all pages and delegates the processing of each page to the upload service.

## Upload Service – `upload#ShopifyOrdersResponse`

This service receives all required parameters from the master service, including:

- `systemMessageId`  
- `systemMessageRemoteId`  
- `pageNumber`  
- `cursor`  
- **`queryText`** (passed by master service)

### Responsibilities

1. Call Shopify using  
   **`ShopifyHelperServices.send#ShopifyGraphqlRequest`**  
   with the provided `queryText`(graphQl)
2. Receive Shopify order JSON for **one page(limiting to orders mentioned in graphQl req)**
3. For fetching the order data we did two poc's-
        #### **poc1** - Fetch all Order data in one graphQl call
                advantage - Less shopify hits
                          - Less code complexity
                disadvantage - More Query cost
                             - Pagination is not possible for line items
        #### **poc2** - Fetch order connections in seperate graphQl calls-
                advantage - Pagniation for connections can be acheived.
                          - Less query cost
                          For each order:
                           Call `get#OrderLevelDetails` to fetch:
                           - line items  
                           - shipping lines  
                           - transactions
5. Build the final Shopify order JSON for that page  
6. **Upload the created JSON file to Data Manager** using:

   **`upload#DatamanagerFeed`**

7. Return:
   - `hasNextPage`  
   - `endCursor`

The master service uses these values to decide whether to fetch the next page.

## Data Manager Upload

For **each page** of Shopify orders:

- One JSON file is generated  
- The file is uploaded to MDM under the given **configId**  
Thus, each page results in a separate Data Manager upload.

### Final Processing – Service Associated With Config ID

The `configId` used during the Data Manager upload has an associated processing service.

That service is responsible for:

- Reading the uploaded JSON  
- Transforming Shopify orders into OMS-friendly format  
- Creating orders inside OMS  
- Logging/handling exceptions  
- Optionally writing error files back to MDM  

Processor service transforms and ingests orders into OMS  
