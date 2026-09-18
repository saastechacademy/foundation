# Step 7: History Persistence

The final stage of the product synchronization process is to update the history record with the latest state. This "closes the loop" and ensures that the next synchronization cycle has an accurate baseline for comparison.

## 1. Updating the Baseline
After the database updates (Step 6) are successfully applied, the service persists the newly computed hashes and data blobs to the history table.

- **Entity**: `co.hotwax.product.ProductUpdateHistory`
- **Action**: `store#co.hotwax.product.ProductUpdateHistory`

### Fields Updated:
- **`productCoreDetailsHash`**: The new hash for basic product detail.
- **`tagsHash` / `featuresHash` / `metafieldsHash`**: Updated hashes based on the synchronized data.
- **`tags` / `features` / `metafields` / `identifications`**: The full JSON snapshots of the current state.
- **`differenceMap`**: The JSON delta calculated in Step 5.
- **`systemMessageId`**: The ID of the sync request that triggered this specific update.

## 2. Importance of Persistence
Without this step, the next sync would re-detect the same changes, leading to redundant database updates and potential data flapping. By saving the history, we guarantee:
- **Idempotency**: Repeated syncs with the same data result in zero database changes.
- **Efficiency**: Only future changes on the Shopify side will trigger new work.

## 3. Auditing & Troubleshooting
Storing the `differenceMap` and `systemMessageId` inside the history table turns it into a powerful audit trail.
- If a product value is unexpected in the OMS, developers can check the history table to see the exact `differenceMap` from the last sync and the corresponding `SystemMessage` that fetched the data from Shopify.

## Sequence Order
1. **Ingest to Product Tables** (Step 6)
2. **Verify Success** (Implicit in script execution)
3. **Save to History Table** (Step 7)

## Technical Note: Atomic Update
In the `syncShopifyProduct.groovy` script, the history persistence is the last operation before the service returns. This ensures that the baseline is only updated if the logic reaches the end of the script successfully.
