# Sync Shopify Product Updates – Detail Design

This document consolidates the detail design for:
- `sync#ShopifyProductUpdates`
- `poll#ShopifyBulkOperationResult` (consolidated poller)
- `consume#ShopifyProductDataFile`
- `sync#ShopifyProduct`

---

## 1) sync#ShopifyProductUpdates

### Purpose
Prepare a fully resolved bulk query and create a `BulkQueryShopifyProductUpdates` SystemMessage for the scheduler to send.

### Inputs
- `fromDate` / `thruDate` (Timestamp/String, optional)
- `namespaces` (List, optional)

### SystemMessage Created
- `systemMessageTypeId = BulkQueryShopifyProductUpdates`
- `systemMessageRemoteId = <input>`
- `messageText = <resolved query string>`
- `isOutgoing = Y`
- `statusId = SmsgProduced` (unless `sendNow = true`)

### Flow
1) Build `queryParams` map:
    - normalize `fromDate` / `thruDate` to UTC
    - include `filterQuery`, `namespaces`
2) Render query template:
    - `queryText = ec.resourceFacade.template("component://sob/template/graphQL/BulkQueryShopifyProductUpdates.ftl", "")`
    - FTL reads `queryParams` from context
3) Create SystemMessage:
    - `org.moqui.impl.SystemMessageServices.queue#SystemMessage`
    - in-map: `[systemMessageTypeId:'BulkQueryShopifyProductUpdates', systemMessageRemoteId, messageText: queryText, sendNow:false]`
4) Optional immediate send:
    - If `sendNow = true`, call `send#ShopifyBulkQueryMessage` with `systemMessageId`

### Outputs
- `systemMessageId`
- If `sendNow = true`: `shopifyBulkOperationId`, `remoteMessageId`

### Failure Handling
- Template render errors: return error; do not create SystemMessage.
- `sendNow` failures: SystemMessage marked `SmsgError`.

## Sample SystemMessageType Data

```xml
<!-- Bulk product and variants by ID query -->
<moqui.service.message.SystemMessageType systemMessageTypeId="BulkQueryShopifyProductUpdates"
                                         description="Product and Variants updates query for Shopify"
                                         parentTypeId="ShopifyBulkQuery"
                                         produceServiceName="co.hotwax.sob.product.sync#ShopifyProductUpdates"
                                         sendServiceName="co.hotwax.shopify.system.ShopifySystemMessageServices.send#ShopifyBulkQueryMessage" 
                                         consumeServiceName="co.hotwax.sob.product.consume#ShopifyProductDataFile"
                                         receiveMovePath="s3://my-bucket/shopify/bulk-updates/">
</moqui.service.message.SystemMessageType>

```

## Sample SystemMessage Data (Lifecycle)

```xml
<!-- 1) Queued (Produced) -->
<moqui.service.message.SystemMessage systemMessageId="SM_BULK_0001"
        systemMessageTypeId="BulkQueryShopifyProductUpdates"
        systemMessageRemoteId="ShopifyRemote_001"
        statusId="SmsgProduced" isOutgoing="Y"
        messageText="query { /* resolved GraphQL */ }"
        initDate="2025-02-01 10:00:00.000"/>

<!-- 2) Sent (remoteMessageId set after Shopify accepts bulk query) -->
<moqui.service.message.SystemMessage systemMessageId="SM_BULK_0001"
        statusId="SmsgSent"
        remoteMessageId="gid://shopify/BulkOperation/1234567890"
        lastAttemptDate="2025-02-01 10:01:10.000"/>

<!-- 3) Received (file downloaded to receiveMovePath) -->
<moqui.service.message.SystemMessage systemMessageId="SM_BULK_0001"
        statusId="SmsgReceived"
        processedDate="2025-02-01 10:05:00.000"/>

```



## 2) send#ShopifyBulkQueryMessage

### Purpose
Send a fully resolved Shopify GraphQL bulk query stored in `SystemMessage.messageText` and persist the Shopify bulk operation ID as `remoteMessageId` using Moqui OOTB send behavior.

### Implements
`org.moqui.impl.SystemMessageServices.send#SystemMessage`

### Inputs
- `systemMessageId` (String, required)

### Assumptions
- `SystemMessageType.parentTypeId = ShopifyBulkQuery` (subtypes allowed)
- `SystemMessage.messageText` contains the **fully resolved GraphQL query string**
- `SystemMessage.systemMessageRemoteId` identifies Shopify credentials

### Outputs
- `shopifyBulkOperationId`
- `remoteMessageId`

### Failure Handling
- Shopify userErrors: create `SystemMessageError`, mark `SmsgError`.
- Transport/system failure: throw error; Moqui send handles failure.

---

## 3) poll#ShopifyBulkOperationResult (consolidated poller)

### Purpose
Poll Shopify for completion of a sent bulk query SystemMessage and, when complete, download the result file and save it to the OMS default location in one service.

### Called By
- Scheduled job: `poll_ShopifyBulkOperationResult`
  (`runtime/component/mantle-shopify-connector/data/ShopifyServiceJobData.xml`)

### Replaces/Consolidates
- `poll#BulkOperationResult`
- `process#BulkOperationResult`
- `consume#BulkOperationResult`

### Implements
- None (standalone service)

### Input Parameters
- None. This poller **always** works on `SystemMessageType.parentTypeId = ShopifyBulkQuery`.

### Outputs
- `message` (String) – summary of poll outcome
- `systemMessageId` (String) – the message polled (if any)
- `status` (String) – Shopify bulk operation status (if found)

### Flow
1) Select a pending SystemMessage to poll
   - Query `SystemMessageAndType` (view joins SystemMessage + SystemMessageType):
     - `statusId = SmsgSent`
     - `parentTypeId = ShopifyBulkQuery` (field on SystemMessageType)
     - `limit = 1`
   - If none found → return `"No bulk operation in progress."`

2) Fetch Shopify bulk status
   - Use `systemMessage.remoteMessageId` (Shopify bulk operation ID)
   - Call `co.hotwax.shopify.graphQL.ShopifyBulkImportServices.get#BulkOperationResult`
   - Extract `status` and `url`
   - Set `systemMessage.statusId = SmsgReceived` to indicate we've received the status update

4) Download file to OMS
    - Build `fileLocation` and place it as per `receiveMovePath` (e.g., `s3://my-bucket/shopify/bulk-updates/`) and a unique filename (e.g., `bulk_update_20250201_100500.jsonl`)
    - Call `co.hotwax.shopify.graphQL.ShopifyBulkImportServices.store#BulkOperationResultFile`
    - save the path to the downloaded file in `SystemMessageType.receiveMovePath`

6) Post-Download Processing (consume step)
    - Set `systemMessage.statusId = Consuming` to indicate processsing
    - Call `consumeServiceName=consume#ShopifyProductDataFile` on `BulkQueryShopifyProductUpdates`.

3) Handle status
   - `completed` → proceed to download
   - `failed` / `expired` → create `SystemMessageError`, mark `SmsgError`
   - `running` / `created` → leave `SmsgSent`, return message
   - `completed` with no URL → mark `SmsgConfirmed`, return warning

5) Finalize
   - On success: update SystemMessage `SmsgConsuming`
   - On download error: create `SystemMessageError`, mark `SmsgError`


---

## 3) consume#ShopifyProductDataFile (consolidated poller)

### Purpose
Process the downloaded Shopify JSONL file, transform it into a normalized product JSON structure, and schedule downstream OMS/MDM sync work.

- In parameter name="systemMessageId"
- Called by: `consumeServiceName` on `BulkQueryShopifyProductUpdates` SystemMessageType

### Flow
1) Load the downloaded file from `SystemMessageType.receiveMovePath`.
2) For each line (JSON object) in the JSONL file:
   - Parse the line into a JSON object.
   - Transform the Shopify product data into a normalized JSON structure suitable for OMS/MDM processing.
   - This service runs `transform#JsonLToJsonForUpdatedProducts` 
3) create MDM import for processing the downloaded data.
4) update the `SystemMessage` status to `SmsgConfirmed` after successfully uploading the file to MDM for processing.




### 4) sync#ShopifyProduct
### Purpose
Sync individual products to OMS based on the processed bulk query results. This service is called for each product extracted from the bulk query result file.


## 5) SystemMessageType Configuration (conceptual)

- `ShopifyBulkQuery` remains the parent SystemMessageType and carries **deployment defaults** (send/receive services, base paths, etc.).
- Each query subtype (e.g., `BulkQueryShopifyProductUpdates`) **overrides only the fields it needs** (for example `receivePath`).
- Effective values are resolved using a parent-override rule: `COALESCE(subtype.field, parent.field)`.
- Each producer service is responsible for producing a resolved query in `messageText`.

