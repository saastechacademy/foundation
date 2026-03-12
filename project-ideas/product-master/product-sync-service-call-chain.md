# Product Sync Service Call Chain (BulkProductAndVariantsByIdQuery)

## Scope
This document traces the actual product update sync chain implemented in the current codebase for:
- `BulkProductAndVariantsByIdQuery`
- `GenerateOMSUpdateProductsFeedNew`
- `ProductUpdatesFeedNew`

It includes missing framework wrapper calls (`queue/receive/send/consume`) that are not always shown in high-level diagrams.

## Chronological Chain (Actual Runtime Order)
1. `queue_BulkQuerySystemMessage_BulkProductAndVariantsById` (JOB)
2. `co.hotwax.shopify.system.ShopifySystemMessageServices.queue#BulkQuerySystemMessage`
3. `org.moqui.impl.SystemMessageServices.queue#SystemMessage` (`sendNow:false`, creates `SmsgProduced` outgoing SystemMessage)
4. `send_BulkProductAndVariantsByIdQueryProducedSystemMessages` (JOB)
5. `org.moqui.impl.SystemMessageServices.send#AllProducedSystemMessages`
6. `org.moqui.impl.SystemMessageServices.send#ProducedSystemMessage`
7. `co.hotwax.shopify.system.ShopifySystemMessageServices.send#BulkQuerySystemMessage`
8. `co.hotwax.shopify.graphQL.ShopifyBulkImportServices.run#BulkOperationQuery`
9. Shopify bulk operation starts externally (returns bulk operation id)
10. `poll_BulkOperationResult_ShopifyBulkQuery` (JOB)
11. `co.hotwax.shopify.system.ShopifySystemMessageServices.poll#BulkOperationResult`
12. `co.hotwax.shopify.system.ShopifySystemMessageServices.process#BulkOperationResult`
13. `co.hotwax.shopify.graphQL.ShopifyBulkImportServices.get#BulkOperationResult`
14. `org.moqui.impl.SystemMessageServices.receive#IncomingSystemMessage` (missing in many diagrams)
15. `org.moqui.impl.SystemMessageServices.consume#ReceivedSystemMessage` (missing in many diagrams)
16. `co.hotwax.shopify.system.ShopifySystemMessageServices.consume#BulkOperationResult`
17. `co.hotwax.shopify.graphQL.ShopifyBulkImportServices.store#BulkOperationResultFile`
18. `org.moqui.impl.SystemMessageServices.queue#SystemMessage` for related type `GenerateOMSUpdateProductsFeedNew` (`sendNow:true`)
19. `org.moqui.impl.SystemMessageServices.send#ProducedSystemMessage`
20. `co.hotwax.sob.system.FeedServices.generate#OMSFeedNew`
21. `co.hotwax.orderledger.system.FeedServices.transform#JsonLToJsonForUpdatedProducts`
22. `co.hotwax.orderledger.product.ProductServices.compare#VirtualProduct` / `compare#VariantProduct` (inside transform)
23. ProductUpdateHistory create/update (`co.hotwax.product.ProductUpdateHistory`)
24. `org.moqui.impl.SystemMessageServices.receive#IncomingSystemMessage` for related type `ProductUpdatesFeedNew`
25. `org.moqui.impl.SystemMessageServices.consume#ReceivedSystemMessage`
26. `co.hotwax.orderledger.system.FeedServices.consume#UpdatedProductHistories`
27. `co.hotwax.orderledger.system.FeedServices.consume#ProductUpdateWorker` (loop, force-new tx)
28. `co.hotwax.oms.search.SearchServices.call#CreateProductIndex`

## Detailed Service Behavior (What Each Step Does)
- `queue_BulkQuerySystemMessage_BulkProductAndVariantsById` (job):
  - Scheduled trigger that starts this flow for `BulkProductAndVariantsByIdQuery`.
- `co.hotwax.shopify.system.ShopifySystemMessageServices.queue#BulkQuerySystemMessage`:
  - Reads type/remote parameters (`SystemMessageTypeParameter`).
  - Builds `queryParams` with filter/date range and applies date buffers if configured.
  - If `fromDate` is not passed, derives it from last `SmsgConfirmed` message of same type.
  - Serializes params to `messageText` JSON and queues an outgoing SystemMessage (`sendNow:false`).
- `org.moqui.impl.SystemMessageServices.queue#SystemMessage`:
  - Creates outgoing SystemMessage (`SmsgProduced`, `isOutgoing=Y`) in a new transaction.
  - If `sendNow=true`, dispatches `send#ProducedSystemMessage` (async by default; sync option in override).
- `send_BulkProductAndVariantsByIdQueryProducedSystemMessages` (job):
  - Calls `send#AllProducedSystemMessages` with `systemMessageTypeIds=BulkProductAndVariantsByIdQuery` to send only this message type.
- `org.moqui.impl.SystemMessageServices.send#AllProducedSystemMessages`:
  - Pulls retry-eligible produced messages (`SmsgProduced`, `isOutgoing=Y`, retry window check).
  - Sends each message via `send#ProducedSystemMessage`; moves to `SmsgError` after retry limit.
- `org.moqui.impl.SystemMessageServices.send#ProducedSystemMessage`:
  - Resolves actual sender from `SystemMessageType.sendServiceName` (or remote override).
  - Sets status to `SmsgSending`, executes concrete send service, captures `remoteMessageId`.
  - On success marks `SmsgSent`; on failure restores initial status, increments `failCount`, writes `SystemMessageError`.
- `co.hotwax.shopify.system.ShopifySystemMessageServices.send#BulkQuerySystemMessage`:
  - Loads SystemMessage, parses `messageText` into `queryParams`, sets template location from `sendPath`.
  - Calls `run#BulkOperationQuery`.
  - Returns Shopify bulk operation id as `remoteMessageId`.
- `co.hotwax.shopify.graphQL.ShopifyBulkImportServices.run#BulkOperationQuery`:
  - Renders GraphQL template (`BulkProductAndVariantsByIdQuery.ftl`) and submits `bulkOperationRunQuery`.
  - If Shopify returns `userErrors`, service fails; else returns `shopifyBulkOperationId`.
- `poll_BulkOperationResult_ShopifyBulkQuery` (job):
  - Polling entrypoint for all system message types under parent `ShopifyBulkQuery`.
- `co.hotwax.shopify.system.ShopifySystemMessageServices.poll#BulkOperationResult`:
  - Finds one `SmsgSent` message where `parentTypeId=ShopifyBulkQuery`.
  - Calls `process#BulkOperationResult` for that message.
- `co.hotwax.shopify.system.ShopifySystemMessageServices.process#BulkOperationResult`:
  - Calls `get#BulkOperationResult` with Shopify bulk id.
  - Maps Shopify status to SystemMessage status (`completed/canceled/failed/expired`).
  - Writes `SystemMessageError` for failed/expired cases.
  - On completed with URL, creates an incoming message via `receive#IncomingSystemMessage` (messageText = download URL), passing `consumeSmrId` when configured.
- `co.hotwax.shopify.graphQL.ShopifyBulkImportServices.get#BulkOperationResult`:
  - Queries Shopify bulk operation node and returns `status`, `url`, `errorCode`.
- `org.moqui.impl.SystemMessageServices.receive#IncomingSystemMessage`:
  - Creates incoming SystemMessage (`SmsgReceived`, `isOutgoing=N`) unless a custom receive service overrides it.
  - Triggers `consume#ReceivedSystemMessage` asynchronously.
- `org.moqui.impl.SystemMessageServices.consume#ReceivedSystemMessage`:
  - Sets message to `SmsgConsuming`, calls the type’s `consumeServiceName`.
  - On success sets `SmsgConsumed`; on failure reverts status/fail count and writes `SystemMessageError`.
- `co.hotwax.shopify.system.ShopifySystemMessageServices.consume#BulkOperationResult`:
  - Expands `receivePath` using ids/timestamp and stores Shopify JSONL file locally.
  - Uses enum relation from current type to find the next type (`GenerateOMSUpdateProductsFeedNew`).
  - Queues produced message for related type with `messageText=fileLocation`, `sendNow=true`, routed to `consumeSmrId`.
- `co.hotwax.shopify.graphQL.ShopifyBulkImportServices.store#BulkOperationResultFile`:
  - Downloads Shopify result from signed URL and writes bytes to local file location.
- `co.hotwax.sob.system.FeedServices.generate#OMSFeedNew`:
  - Loads current SystemMessage + remote, derives `shopId` from remote internal id.
  - Collects additional type parameters and calls transform service (`systemMessage.consumeServiceName`).
  - Resolves related enum/type and creates next incoming message of type `ProductUpdatesFeedNew`.
- `co.hotwax.orderledger.system.FeedServices.transform#JsonLToJsonForUpdatedProducts`:
  - Streams JSONL line-by-line; groups virtual products with child variants/metafields.
  - Optionally skips products based on configured `additionalParameters`.
  - Calls `compare#VirtualProduct` and `compare#VariantProduct` to compute changes.
  - Persists/updates `ProductUpdateHistory` with `differenceMap`, hashes, and assoc deltas.
- `co.hotwax.orderledger.product.ProductServices.compare#VirtualProduct`:
  - Computes virtual-product diffs (core fields, tags, features, identifications, metafields).
  - Creates/updates `ProductUpdateHistory` keyed by virtual product id + shop.
- `co.hotwax.orderledger.product.ProductServices.compare#VariantProduct`:
  - Computes variant diffs (identifier/price/assoc/features/tags/core fields).
  - Creates/updates variant `ProductUpdateHistory`; also handles changed primary identifier remaps.
- `co.hotwax.orderledger.system.FeedServices.consume#UpdatedProductHistories`:
  - Fetches histories for `parentMessageId` and `shopId`.
  - Iterates and calls `consume#ProductUpdateWorker` in `force-new` transactions.
  - Calls `SearchServices.call#CreateProductIndex` per processed product.
- `co.hotwax.orderledger.system.FeedServices.consume#ProductUpdateWorker`:
  - Reads `differenceMap`, resolves target OMS product, and applies create/update for virtual/variant data.
  - Updates associations, features, identifiers, type/category fields, and related Shopify mapping records.
  - Returns `productId`, `isVirtual`, `hasUpdate` for caller decisions.
- `co.hotwax.oms.search.SearchServices.call#CreateProductIndex`:
  - REST bridge to OMS indexing endpoint (`service/createProductIndex`) with `productId` and optional `indexVariants`.

## SystemMessageTypes Involved
### 1) `BulkProductAndVariantsByIdQuery`
- Purpose: Outgoing Shopify bulk query type for products + variants (+ optional metafields namespace).
- Config highlights:
  - `parentTypeId = ShopifyBulkQuery`
  - `sendServiceName = co.hotwax.shopify.system.ShopifySystemMessageServices.send#BulkQuerySystemMessage`
  - `consumeServiceName = co.hotwax.shopify.system.ShopifySystemMessageServices.consume#BulkOperationResult`
  - `sendPath = component://shopify-connector/template/graphQL/BulkProductAndVariantsByIdQuery.ftl`
  - `receivePath = ${contentRoot}/shopify/BulkProductAndVariantsByIdQuery/...jsonl`
- Enum linkage: `BulkProductAndVariantsByIdQuery` -> related enum `GenerateOMSUpdateProductsFeedNew`.

### 2) `GenerateOMSUpdateProductsFeedNew`
- Purpose: Bridge/orchestrator type that triggers transform and forwards to OMS consumer type.
- Config highlights:
  - `sendServiceName = co.hotwax.sob.system.FeedServices.generate#OMSFeedNew`
  - `consumeServiceName = co.hotwax.orderledger.system.FeedServices.transform#JsonLToJsonForUpdatedProducts`
- Enum linkage: `GenerateOMSUpdateProductsFeedNew` -> related enum `ProductUpdatesFeedNew`.

### 3) `ProductUpdatesFeedNew`
- Purpose: OMS-side consumer type that applies product updates and re-indexes products.
- Config highlights:
  - `consumeServiceName = co.hotwax.orderledger.system.FeedServices.consume#UpdatedProductHistories`

## Missing/Critical Info (Operational Notes)
1. The correct execution order is `queue -> send -> poll -> process -> consume -> generate -> transform -> consume updates`; the send job does **not** run after transform.
2. `consumeSmrId` must be populated for `BulkProductAndVariantsByIdQuery` (type parameter for the remote). If missing/blank, `consume#BulkOperationResult` will not queue `GenerateOMSUpdateProductsFeedNew`.
3. `receive#IncomingSystemMessage` and `consume#ReceivedSystemMessage` are mandatory framework wrapper steps between produced and consume services.
4. `send_BulkProductAndVariantsByIdQueryProducedSystemMessages` relies on `systemMessageTypeIds` filtering in `org.moqui.impl.SystemMessageServices.send#AllProducedSystemMessages`. In this runtime, that support comes from the `ofbiz-oms-usl` override.
5. `poll_BulkOperationResult_ShopifyBulkQuery` polls by `parentTypeId=ShopifyBulkQuery`, so it serializes processing across all query subtypes under that parent.
6. Jobs in upgrade data are created with `paused="Y"`; they must be enabled in job manager for automation.
7. Job naming changed across upgrades:
   - v1.7.0: `queue_BulkQuerySystemMessage_BulkProductAndVariantsByIdQuery`
   - v1.7.1: `queue_BulkQuerySystemMessage_BulkProductAndVariantsById`
8. `BulkProductAndVariantsByIdQuery` definition appears in OMS upgrade data (v1.7.x), not current non-upgrade seed files, so a fresh environment requires upgrade execution (or equivalent seed load) for this flow to exist.

## Source References (Code)
- `runtime/component/oms/upgrade/v1.7.1/UpgradeData.xml`
- `runtime/component/mantle-shopify-connector/data/ShopifyServiceJobData.xml`
- `runtime/component/mantle-shopify-connector/service/co/hotwax/shopify/system/ShopifySystemMessageServices.xml`
- `runtime/component/mantle-shopify-connector/service/co/hotwax/shopify/graphQL/ShopifyBulkImportServices.xml`
- `runtime/component/shopify-oms-bridge/service/co/hotwax/sob/system/FeedServices.xml`
- `runtime/component/shopify-oms-bridge/data/SOBSystemMessageTypeData.xml`
- `runtime/component/oms/service/co/hotwax/orderledger/system/FeedServices.xml`
- `runtime/component/oms/service/co/hotwax/orderledger/product/ProductServices.xml`
- `runtime/component/oms/service/co/hotwax/oms/search/SearchServices.xml`
- `runtime/component/oms/data/SeedData.xml`
- `runtime/component/ofbiz-oms-usl/service/org/moqui/impl/SystemMessageServices.xml`
- `framework/service/org/moqui/impl/SystemMessageServices.xml`
