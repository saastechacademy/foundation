# Step 5: Diff Computation (Change Detection)

Once the nested JSON is received by the Data Manager, the core logic in `syncShopifyProduct.groovy` begins the process of identifying changes. Instead of blindly overwriting the database, it uses a **Baseline Comparison** strategy to perform selective updates.

## 1. History Lookup (The Baseline)
For every Product or Variant in the incoming JSON, the service fetches the last synchronized state from the history table.

- **Entity**: `co.hotwax.product.ProductUpdateHistory`
- **Lookup Key**: `productId` (Shopify GID) and `shopId`.
- **Purpose**: This record stores hashes and data snapshots from the *previous* sync, serving as the benchmark for change detection.

## 2. Hashing Logic
To detect changes efficiently, the service groups product data into "buckets" and computes a **SHA-256 Hash** for each.

| Data Bucket | Fields Included in Hash |
| :--- | :--- |
| **Core Details** | Title, Handle, Vendor, Featured Image URL, shipping/giftCard flags. |
| **Tags** | A sorted list of Shopify tags. |
| **Features** | A sorted list of product options (Position, Name, Value). |
| **Metafields** | A list of normalized metafields (Namespace, Key, Value). |
| **Assocs** | A sorted list of variant IDs associated with the product. |

**Why Hashing?** Comparing a single 64-character hash is significantly faster than comparing dozens of individual fields or large JSON blobs.

## 3. Delta Identification
If an incoming hash does not match the stored hash, the service performs a deep comparison to identify the exact delta.

### List Comparison (Tags, Features, Metafields)
For lists, it identifies exactly which items are new and which have been removed:
- **`added`**: Items present in incoming data but missing in history.
- **`removed`**: Items present in history but missing in incoming data.

### Field Comparison (Price, Title, etc.)
For simple fields like Price or weight, it performs a standard value comparison (e.g., using `BigDecimal` for price accuracy).

## 4. Output: The `differenceMap`
The result of this step is a specialized JSON object called the **`differenceMap`**. This map is the "instruction set" for the next step (Ingestion).

**Example `differenceMap`:**
```json
{
  "title": "Doria Denim - Updated",
  "tags": {
    "added": ["New Arrival", "Summer 2024"],
    "removed": ["Sale"]
  },
  "features": {
    "added": [{"name": "Width", "value": "Wide"}],
    "removed": []
  }
}
```

## Service Call Chain
1. `co.hotwax.sob.product.ProductServices.sync#ShopifyProduct` (Main Entry)
2. `compareVirtualProduct` / `compareVariantProduct` (Inner Logic)
3. `DigestUtils.sha256Hex` (Hashing Utility)

## Traceability
The `systemMessageId` is carried forward and associated with the logic to ensure that every diff can be traced back to the specific Shopify sync request.
