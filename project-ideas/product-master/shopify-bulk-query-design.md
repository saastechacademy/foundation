# Shopify Bulk Query – Detail Design




This document consolidates the detail design for:
- `send#ShopifyBulkQueryMessage`
- `queue#BulkQueryProductAndVariantsById` (sample producer)

It assumes we **keep the existing scheduler** (`send_ProducedBulkOperationSystemMessage_ShopifyBulkQuery`) and route produced messages to the new send service.

---

## 1) send#ShopifyBulkQueryMessage

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

### Flow
1) Load `SystemMessageAndType` for the given `systemMessageId`.
2) Read query string:
   - `queryText = systemMessage.messageText`
3) Send request to Shopify:
   - `co.hotwax.shopify.common.ShopifyHelperServices.send#ShopifyGraphqlRequest`
   - in-map: `[systemMessageRemoteId: systemMessage.systemMessageRemoteId, queryText: queryText]`
4) Validate response:
   - If `bulkOperationRunQuery.userErrors` exists:
     - create `SystemMessageError`
     - return error (Moqui send marks `SmsgError`)
   - Else:
     - `shopifyBulkOperationId = response.bulkOperationRunQuery.bulkOperation.id`
     - set `remoteMessageId = shopifyBulkOperationId` in context
5) Moqui OOTB send persists:
   - `remoteMessageId`
   - status transition to `SmsgSent`
   - `lastAttemptDate` / `failCount`

### Outputs
- `shopifyBulkOperationId`
- `remoteMessageId`

### Failure Handling
- Shopify userErrors: create `SystemMessageError`, mark `SmsgError`.
- Transport/system failure: throw error; Moqui send handles failure.

### Concurrency / Semaphore
- This service does not manage concurrency directly.
- Single-threaded execution is enforced by the scheduler:
  `co.hotwax.shopify.system.ShopifySystemMessageServices.send#ProducedBulkOperationSystemMessage`.
  It **blocks** if any `SmsgSent` exists for `SystemMessageType.parentTypeId = ShopifyBulkQuery`.

---

## 2) queue#BulkQueryProductAndVariantsById (sample producer)

### Purpose
Prepare a fully resolved bulk product+variants-by-id query and create a `BulkProductAndVariantsByIdQuery` SystemMessage for the scheduler to send.

### Inputs
- `systemMessageRemoteId` (String, required)
- `filterQuery` (String, optional)
- `fromDate` / `thruDate` (Timestamp/String, optional)
- `namespaces` (List, optional)
- `sendNow` (Boolean, optional; default false)

### SystemMessage Created
- `systemMessageTypeId = BulkProductAndVariantsByIdQuery`
- `systemMessageRemoteId = <input>`
- `messageText = <resolved query string>`
- `isOutgoing = Y`
- `statusId = SmsgProduced` (unless `sendNow = true`)

### Flow
1) Build `queryParams` map:
   - normalize `fromDate` / `thruDate` to UTC
   - include `filterQuery`, `namespaces`
2) Render query template:
   - `queryText = ec.resourceFacade.template("component://sob/template/graphQL/BulkProductAndVariantsByIdQuery.ftl", "")`
   - FTL reads `queryParams` from context
3) Create SystemMessage:
   - `org.moqui.impl.SystemMessageServices.queue#SystemMessage`
   - in-map: `[systemMessageTypeId:'BulkProductAndVariantsByIdQuery', systemMessageRemoteId, messageText: queryText, sendNow:false]`
4) Optional immediate send:
   - If `sendNow = true`, call `send#ShopifyBulkQueryMessage` with `systemMessageId`

### Outputs
- `systemMessageId`
- If `sendNow = true`: `shopifyBulkOperationId`, `remoteMessageId`

### Failure Handling
- Template render errors: return error; do not create SystemMessage.
- `sendNow` failures: SystemMessage marked `SmsgError`.

---

## 3) Scheduler Integration (kept as-is)

- `send_ProducedBulkOperationSystemMessage_ShopifyBulkQuery` continues to run.
- It enforces single-threaded Shopify bulk query execution:
  - If any `SmsgSent` exists for `SystemMessageType.parentTypeId = ShopifyBulkQuery`, it aborts.
  - Otherwise it picks the oldest `SmsgProduced` and calls Moqui `send#ProducedSystemMessage`.
- Moqui send dispatches to `send#ShopifyBulkQueryMessage` if the SystemMessageType is configured accordingly.

---

## 4) SystemMessageType Configuration (conceptual)

- `ShopifyBulkQuery` remains the parent SystemMessageType and carries **deployment defaults** (send/receive services, base paths, etc.).
- Each query subtype (e.g., `BulkProductAndVariantsByIdQuery`) **overrides only the fields it needs** (for example `receivePath`).
- Effective values are resolved using a parent-override rule: `COALESCE(subtype.field, parent.field)`.
- Each producer service is responsible for producing a resolved query in `messageText`.

---

## 5) Notes

- The poller job should call the new consolidated service `poll#ShopifyBulkOperationResult`, which always targets `SystemMessageType.parentTypeId = ShopifyBulkQuery`.

---

## 6) poll#ShopifyBulkOperationResult (consolidated poller)

### Purpose
Poll Shopify for completion of a sent bulk query SystemMessage and, when complete, download the result file and save it to the OMS default location in one service.

### Called By
- Scheduled job: `poll_BulkOperationResult_ShopifyBulkQuery`
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

3) Handle status
   - `completed` → proceed to download
   - `failed` / `expired` → create `SystemMessageError`, mark `SmsgError`
   - `running` / `created` → leave `SmsgSent`, return message
   - `completed` with no URL → mark `SmsgConfirmed`, return warning

4) Download file to OMS at `SystemMessageType.receiveMovePath`
   - Build `fileLocation` using `receiveMovePath` for the query subtype
   - Call `co.hotwax.shopify.graphQL.ShopifyBulkImportServices.store#BulkOperationResultFile`

5) Finalize
   - On success: update SystemMessage `SmsgConfirmed`
   - On download error: create `SystemMessageError`, mark `SmsgError`

6) Post-Download Processing (consume step)
   - The `consumeServiceName` on `BulkProductAndVariantsByIdQuery` runs `transform#JsonLToJsonForUpdatedProducts`.
   - It writes diffs to `ProductUpdateHistory`.
   - After processing, it creates a `ProductUpdatesFeed` SystemMessage to trigger OMS ingestion
     (`consume#UpdatedProductHistories`).
   - Save the `ProductUpdatesFeed` SystemMessage ID as `ackMessageId` in the `SystemMessage` record.

### Notes
- This poller enforces the single-threaded Shopify bulk query rule by only polling the oldest `SmsgSent` message for `SystemMessageType.parentTypeId = ShopifyBulkQuery`.
