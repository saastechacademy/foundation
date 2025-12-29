# Shopify Bulk Query – Runbook

This runbook assumes the new design is implemented:
- `send#ShopifyBulkQueryMessage`
- `poll#ShopifyBulkOperationResult`
- Subtypes under `ShopifyBulkQuery` override only the fields they need (notably `receiveMovePath`).

## 1) Configuration checklist

- **SystemMessageType parent**
  - `ShopifyBulkQuery` exists and has default values (send/receive services, base paths).

- **SystemMessageType subtypes**
  - Each query subtype exists (e.g., `BulkVariantsMetafieldQuery`).
  - `parentTypeId = ShopifyBulkQuery`.
  - Subtype overrides `receiveMovePath` as needed.
  - Subtype `sendServiceName = co.hotwax.shopify.system.ShopifySystemMessageServices.send#ShopifyBulkQueryMessage`.
  - Each subtype has a **GraphQL query template file** (FTL) stored in the **SOB component templates folder**.
  - The subtype-specific queue service **hardcodes the template path** (do not use `sendPath` for this).
  - A **queue job is scheduled per subtype** to produce messages for that query.

- **SystemMessageRemote**
  - Shopify credentials are valid (`sendUrl`, auth header/token, app code).

## 2) Scheduled jobs

- **Send job** (single-threaded semaphore)
  - Job: `send_ProducedBulkOperationSystemMessage_ShopifyBulkQuery`
  - Service: `co.hotwax.shopify.system.ShopifySystemMessageServices.send#ProducedBulkOperationSystemMessage`
  - Parent type: `ShopifyBulkQuery`

- **Poll job** (download and finalize)
  - Job: `poll_BulkOperationResult_ShopifyBulkQuery`
  - Service: `co.hotwax.shopify.system.ShopifySystemMessageServices.poll#ShopifyBulkOperationResult`

- **Queue jobs** (create produced messages)
  - Example: `queue_BulkQuerySystemMessage_BulkVariantsMetafieldQuery`
  - Service: `co.hotwax.shopify.system.ShopifySystemMessageServices.queue#BulkQuerySystemMessage`

## 3) Happy-path flow

1) Queue job creates a `ShopifyBulkQuery` SystemMessage (status `SmsgProduced`).
2) Send job picks the oldest produced message:
   - Sends GraphQL query to Shopify.
   - Writes `remoteMessageId` = Shopify bulk op ID.
   - Status becomes `SmsgSent`.
3) Poll job checks Shopify bulk status:
   - If running, leaves status `SmsgSent`.
   - If completed, downloads file to `SystemMessageType.receiveMovePath`.
   - Marks `SmsgConfirmed`.

## 4) Validation steps

- **After queue run**: confirm SystemMessage exists with `SmsgProduced`.
- **After send run**: confirm `SmsgSent` and `remoteMessageId` populated.
- **After poll run**: confirm file saved to `receiveMovePath` and status `SmsgConfirmed`.

## 5) Troubleshooting

- **No messages sent**:
  - Check if a `SmsgSent` already exists for `ShopifyBulkQuery` (single-threaded lock).
- **Poller never completes**:
  - Inspect Shopify bulk operation status using `remoteMessageId`.
- **File not saved**:
  - Verify `receiveMovePath` on the subtype and filesystem permissions.
- **Errors**:
  - Review `SystemMessageError` entries for the SystemMessage ID.
