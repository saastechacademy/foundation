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

## Short Description of Each Service/Job in the Chain
- `queue_BulkQuerySystemMessage_BulkProductAndVariantsById` (job): Schedules product bulk query message creation.
- `queue#BulkQuerySystemMessage`: Builds query params (`fromDate`, `thruDate`, labels, filter) and queues a message.
- `queue#SystemMessage`: Creates outgoing SystemMessage (`SmsgProduced`), optionally sends immediately.
- `send_BulkProductAndVariantsByIdQueryProducedSystemMessages` (job): Picks produced messages of this type and sends them.
- `send#AllProducedSystemMessages`: Fetches pending produced outgoing messages and dispatches each.
- `send#ProducedSystemMessage`: Resolves `sendServiceName`, updates status, executes concrete sender.
- `send#BulkQuerySystemMessage`: Renders query template context and executes Shopify bulk query run.
- `run#BulkOperationQuery`: Calls Shopify GraphQL `bulkOperationRunQuery`; returns operation id.
- `poll_BulkOperationResult_ShopifyBulkQuery` (job): Poll loop entrypoint for all `ShopifyBulkQuery` children.
- `poll#BulkOperationResult`: Finds in-progress (`SmsgSent`) bulk query message and forwards it to processor.
- `process#BulkOperationResult`: Gets Shopify status; marks message status (`SmsgConfirmed/SmsgError/...`), then creates incoming result message when completed.
- `get#BulkOperationResult`: Queries Shopify for bulk operation node (`status`, `url`, `errorCode`).
- `receive#IncomingSystemMessage`: Persists incoming message (`SmsgReceived`) and kicks async consume.
- `consume#ReceivedSystemMessage`: Resolves type’s `consumeServiceName` and executes it with status transitions.
- `consume#BulkOperationResult`: Downloads JSONL result file and creates related produced message (`GenerateOMSUpdateProductsFeedNew`).
- `store#BulkOperationResultFile`: HTTP GET download from Shopify signed URL to configured `receivePath`.
- `generate#OMSFeedNew`: Orchestrator; calls transform service and then creates next incoming message (`ProductUpdatesFeedNew`).
- `transform#JsonLToJsonForUpdatedProducts`: Parses JSONL product/variant/metafield rows, computes diffs/hashes, writes ProductUpdateHistory.
- `compare#VirtualProduct`: Computes virtual product-level diffs and persists ProductUpdateHistory.
- `compare#VariantProduct`: Computes variant-level diffs and persists ProductUpdateHistory.
- `consume#UpdatedProductHistories`: Reads ProductUpdateHistory rows for parent message/shop and processes each.
- `consume#ProductUpdateWorker`: Applies create/update logic in OMS entities for one history row.
- `call#CreateProductIndex`: Calls OMS REST index endpoint to refresh search index for product (and variants conditionally).

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

