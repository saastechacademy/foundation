# D365 to OMS Product Sync Implementation Plan

This document captures the current design and implementation status for synchronizing product data from Dynamics 365 (D365) to OMS.

The current connector work on products is an **export from D365 to OMS** using the D365 Data Package Export APIs for the `Released product variants V2` export.

## 1. Objective
- Export released product variant data from D365
- Download the exported package from D365
- Extract the file `Released product variants V2.csv`
- Make the file available for downstream OMS-side product synchronization

## 2. Current Scope

### 2.1 What is implemented
- A D365 export `SystemMessage` flow using the generic export services in [D365DataPackageServices.xml](/Users/gurveenkaur/Documents/Work/git/oms/moqui-framework/runtime/component/hotwax-d365/service/co/hotwax/d365/D365DataPackageServices.xml)
- Product export job seeds in [D365ServiceJobData.xml](/Users/gurveenkaur/Documents/Work/git/oms/moqui-framework/runtime/component/hotwax-d365/data/D365ServiceJobData.xml)
- Download and extraction of `Released product variants V2.csv` into:
  - `runtime://datamanager/d365/export/products`

### 2.2 What is not implemented yet
- No product-specific DataManager config is seeded yet
- No product-specific OMS import service is implemented yet
- No product creation/update service currently consumes the exported product file
- No completed OMS-side mapping exists yet for product identifiers and variant dimensions like:
  - `ItemNumber`
  - `styleId`
  - `colorId`
  - other variant attributes such as size or configuration if required

So the current product flow is best understood as:
- **implemented D365 export and file retrieval**
- **OMS-side product ingestion still pending**

## 3. Current Implemented Export Flow

For the generic export framework, see [data_export_package_api.md](/Users/gurveenkaur/Documents/Work/git/oms/moqui-framework/runtime/component/foundation/project-ideas/dynamics365-integration/data-package-api/data_export_package_api.md).

The current product flow uses the generic export queue/send/poll services with product-specific job parameters.

### 3.1 `SystemMessageType`
- `systemMessageTypeId = D365_EXPORT_PRODUCTS`
- configured `sendServiceName = D365DataPackageServices.send#ExportDataPackage`

### 3.2 Product Export Jobs

#### Queue Job
- service job `d365_QueueProductVariantsExport`
- defined in [D365ServiceJobData.xml](/Users/gurveenkaur/Documents/Work/git/oms/moqui-framework/runtime/component/hotwax-d365/data/D365ServiceJobData.xml)
- calls the generic service [D365DataPackageServices.queue#ExportDataPackage](/Users/gurveenkaur/Documents/Work/git/oms/moqui-framework/runtime/component/hotwax-d365/service/co/hotwax/d365/D365DataPackageServices.xml:4)

Parameters:
- `systemMessageTypeId = D365_EXPORT_PRODUCTS`
- `definitionGroupId = HotWax_Export_Product_Variants`
- `packageName = ReleasedProductVariants`
- `fileName = Released product variants V2.csv`
- `targetDirectory = runtime://datamanager/d365/export/products`

#### Poll Job
- service job `d365_ExportProductVariantsPoll`
- defined in [D365ServiceJobData.xml](/Users/gurveenkaur/Documents/Work/git/oms/moqui-framework/runtime/component/hotwax-d365/data/D365ServiceJobData.xml)
- calls the generic service [D365DataPackageServices.poll#ExportDataPackageStatus](/Users/gurveenkaur/Documents/Work/git/oms/moqui-framework/runtime/component/hotwax-d365/service/co/hotwax/d365/D365DataPackageServices.xml:86)

Parameter:
- `systemMessageTypeId = D365_EXPORT_PRODUCTS`

### 3.3 Generic Service Sequence
1. `queue#ExportDataPackage`
   - creates a `SystemMessage` entity record
   - stores the product export metadata in `messageText`
   - queues the message with `sendNow=true`
2. `send#ExportDataPackage`
   - reads the product export metadata from `messageText`
   - calls D365 `ExportToPackage`
   - returns `remoteMessageId = executionId`
3. `poll#ExportDataPackageStatus`
   - finds sent product export messages
4. `check#ExportDataPackageStatus`
   - calls `GetExecutionSummaryStatus`
   - when successful, calls `GetExportedPackageUrl`
   - downloads the ZIP package
   - extracts `Released product variants V2.csv`
   - saves it into `runtime://datamanager/d365/export/products`

## 4. Current Data Boundary

At present, the connector boundary for products is:
- D365 export trigger
- D365 export status polling
- ZIP download
- local extraction of the released product variants file

The OMS-side product ingestion boundary is still open.

This means the connector currently guarantees:
- retrieval of the D365 product export file

It does **not** yet guarantee:
- creation or update of OMS product master data
- creation or update of OMS variant records
- stable mapping of D365 product/variant attributes into OMS structures

## 5. Key Product Data Questions Still Open

The main unresolved modeling questions are around how the D365 product export maps into OMS product and variant structures.

### 5.1 Item identity
- How should D365 `ItemNumber` map into OMS?
- Should `ItemNumber` be stored as:
  - the primary `productId`
  - a `GoodIdentification` value such as `D365_PRODUCT_ID`
  - or both

### 5.2 Style and variant dimensions
- How should OMS represent D365 variant dimensions such as:
  - `styleId`
  - `colorId`
  - `sizeId`
  - `configId`
- Are these all variant-defining dimensions in OMS, or are some of them informational only
- How should missing or blank dimensions be handled

### 5.3 Parent/variant structure
- Does the export contain enough information to reliably derive:
  - virtual product / parent style
  - sellable variant / child SKU
- If not, what additional D365 exports or joins are required

### 5.4 Product type and lifecycle
- What OMS product states should be derived from D365 export data
- How should released/unreleased/blocked/discontinued D365 items map into OMS product status handling

## 6. TODOs

### 6.1 OMS-side ingestion
- Add a product-specific DataManager config if DataManager will be used for OMS ingestion
- Or add a product-specific OMS import service if product CSV processing will bypass DataManager
- Define the service that will read `Released product variants V2.csv` and create/update OMS products

### 6.2 Identifier mapping
- Decide how `ItemNumber` maps into OMS product identity
- Add the required `GoodIdentification` strategy for D365 product references
- Define whether OMS should preserve both:
  - OMS-native product id
  - D365 product id / item number

### 6.3 Variant mapping
- Define handling for:
  - `styleId`
  - `colorId`
  - `sizeId`
  - `configId`
- Decide which of these fields define OMS variants
- Decide whether any dimension combinations should collapse into one OMS product record or remain distinct variants

### 6.4 Data quality and edge cases
- Define handling for products with missing `ItemNumber`
- Define handling for duplicate `ItemNumber` rows across legal entities or variant combinations
- Define handling for blank `styleId` / `colorId` values
- Define whether legal entity should be part of product matching logic

### 6.5 Documentation follow-up
- Once OMS-side ingestion is implemented, update this document with:
  - the product import service name
  - the final field mapping table
  - any DataManager config id used
  - the final OMS entity write path

## 7. Current Status
- **Implemented today**:
  - queue service job `d365_QueueProductVariantsExport`
  - poll service job `d365_ExportProductVariantsPoll`
  - generic export services:
    - `queue#ExportDataPackage`
    - `send#ExportDataPackage`
    - `poll#ExportDataPackageStatus`
    - `check#ExportDataPackageStatus`
  - extraction of `Released product variants V2.csv` to `runtime://datamanager/d365/export/products`
- **Still open**:
  - OMS product ingestion
  - `ItemNumber` identity strategy
  - variant dimension mapping for `styleId`, `colorId`, and related fields
