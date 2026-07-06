# Step 4: Data Preparation (JSONL to Nested JSON)

This step handles the transformation of the raw Shopify bulk result (JSONL) into a hierarchical JSON format that the OMS can process.

## Control Flow (How we reach this step)
Control reaches this step immediately after the Shopify Bulk Operation is confirmed as `completed`. The sequence is as follows:

1.  **Confirmation (Step 3)**: The `process#BulkOperationResult` service identifies the operation is complete and calls `receive#IncomingSystemMessage`.
2.  **Direct Trigger**: Since the `BulkProductAndVariantsByIdQuery` message type is configured with **`consume#ProductVariantUpdates`** as its consume service, the System Message framework triggers this step directly.
3.  **Data Preparation**: This service (`consume#ProductVariantUpdates`) then reads the download URL, streams the JSONL, converts it to nested JSON, and uploads it to the MDM.

## 1. Input: Raw JSONL Data
Shopify bulk results are returned as a "flat" JSONL file where child entities (Variants, Metafields) follow their parents and reference them via a `__parentId`.

**Example (Simplified JSONL):**
```json
{"id":"gid://shopify/Product/9028462969133","handle":"doria-denim","title":"Doria - Denim"}
{"id":"gid://shopify/ProductVariant/47646836457773","sku":"5138980_denim_50","__parentId":"gid://shopify/Product/9028462969133"}
{"id":"gid://shopify/Metafield/31849382215981","key":"show_width_code","value":"G","__parentId":"gid://shopify/Product/9028462969133"}
```

## 2. Transformation Logic
The `consume#ProductVariantUpdates` service parses this file line-by-line and groups child entities under their respective parent objects based on the `__parentId`.

- **Root Object**: Any line without a `__parentId` is treated as a new Product.
- **Child Object**: Any line with a `__parentId` is added to a list inside the current Product object. The list name is derived from the object type in the Shopify GID (e.g., `ProductVariant`, `Metafield`).

## 3. Output: Nested JSON
The transformation produces a standard JSON array where each product contains its own nested variants and metadata.

**Example (Transformed JSON):**
```json
[
  {
    "virtualProduct": {
      "id": "gid://shopify/Product/9028462969133",
      "handle": "doria-denim",
      "title": "Doria - Denim",
      "ProductVariant": [
        {
          "id": "gid://shopify/ProductVariant/47646836457773",
          "sku": "5138980_denim_50"
        }
      ],
      "Metafield": [
        {
          "id": "gid://shopify/Metafield/31849382215981",
          "key": "show_width_code",
          "value": "G"
        }
      ]
    }
  }
]
```

## 4. Upload to MDM
Once the file is converted, it is uploaded to the **Data Manager (MDM)** for processing.

- **Service**: `co.hotwax.util.UtilityServices.upload#DataManagerFile`
- **Config ID**: `SYNC_SHOPIFY_PRODUCT`
- **DataManager Configuration**:
  ```json
  {
      "importServiceName": "co.hotwax.sob.product.ProductServices.sync#ShopifyProduct",
      "executionModeId": "DMC_QUEUE",
      "configId": "SYNC_SHOPIFY_PRODUCT"
  }
  ```
- **Traceability**: The `systemMessageId` is passed in the `parameters` map to maintain a link between this data batch and the original sync request.

## Service Call Chain
1. `co.hotwax.shopify.system.ShopifySystemMessageServices.process#BulkOperationResult` (Step 3: detects completion)
2. `org.moqui.impl.SystemMessageServices.receive#IncomingSystemMessage` (Creates incoming message and triggers consume)
3. `co.hotwax.shopify.system.ShopifySystemMessageServices.consume#ProductVariantUpdates` (This step: conversion & upload)
4. `co.hotwax.util.UtilityServices.upload#DataManagerFile` (Upload to MDM)

## Technical Notes
- **Streaming**: The data is processed line-by-line using a `JsonGenerator` to handle potentially large files without exhausting memory.
- **Order Dependency**: The parser expects parents to precede their children in the Shopify file.
- **Traceability**: Uses `parentMessageId` (from previous steps) and passes `systemMessageId` to the Data Manager to ensure full end-to-end logging.
