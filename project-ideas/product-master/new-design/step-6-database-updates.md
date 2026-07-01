# Step 6: Database Updates (Ingestion)

In this step, the system takes the **`differenceMap`** generated in Step 5 and applies those changes to the actual Product entities in the database. This process is handled by a specialized worker logic within the same synchronization service.

## 1. Selective Modification
The core principle of this step is **Selective Update**. The system only executes service calls for the specific fields or lists that are present in the `differenceMap`. This minimizes database load and prevents unnecessary triggers or audit log entries.

## 2. Worker Logic (`consumeProductUpdateHistoryWorker`)
The logic is encapsulated in a worker closure that iterates through the changes.

- **Entity Lookup**: It first resolves the internal `productId` from the Shopify ID using the `co.hotwax.shopify.ShopifyShopProduct` cross-reference table.
- **Handling New Products**: If no internal ID is found, it performs a full creation (mapping Shopify fields to the `Product` entity).
- **Applying Deltas**: It checks each key in the `differenceMap` and calls the corresponding Moqui service.

## 3. Entity Mapping & Operations

| Data Type | Internal Entity | Moqui Service / Operation |
| :--- | :--- | :--- |
| **Core Product** | `org.apache.ofbiz.product.product.Product` | `store#Product` (Updates Name, Image, Type, Internal Name). |
| **Tags** | `org.apache.ofbiz.product.product.ProductKeyword` | `create#ProductKeyword` for added tags; `delete#ProductKeyword` for removed tags. |
| **Features** | `org.apache.ofbiz.product.feature.ProductFeatureAppl` | Dynamically resolves/creates `ProductFeature` and creates/deletes standard applications. |
| **Pricing** | `org.apache.ofbiz.product.price.ProductPrice` | Updates the `LIST_PRICE` / `PURCHASE` record if the price changed. |
| **Identifications** | `org.apache.ofbiz.product.product.GoodIdentification` | Manages `SKU` and `UPCA` (Barcode) entries, including expiration (thruDate) of old values. |
| **Attributes** | `org.apache.ofbiz.product.product.ProductAttribute` | Maps non-standard metafields to product attributes. |

## 4. Product Type Detection
The ingestion logic dynamically determines the `productTypeId` based on Shopify flags:
- `requiresShipping: false` -> **DIGITAL_GOOD**
- `hasVariantsThatRequireComponents: true` -> **MARKETING_PKG_PICK**
- Default -> **FINISHED_GOOD**

## Service Call Chain
1. `consumeProductUpdateHistoryWorker` (The worker loop)
2. `store#org.apache.ofbiz.product.product.Product`
3. `store#org.apache.ofbiz.product.product.ProductKeyword`
4. `store#org.apache.ofbiz.product.feature.ProductFeatureAppl`

## Traceability
Each database operation is performed in the context of the current sync session. Successful updates are verified before the system moves to the final state persistence step.
