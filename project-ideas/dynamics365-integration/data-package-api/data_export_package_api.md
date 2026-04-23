# D365 Data Export Package API

This document outlines the architecture and implementation strategy for exporting bulk data from Dynamics 365 (D365) using the **Data Export Package API**.

## 1. Objective
To pull large volumes of data from D365 in a structured package format (ZIP containing CSV/XML). This is more efficient for full synchronization or large incremental updates than individual OData queries.

## 2. High-Level Flow (Export)

The Data Export Package API follows these core steps:

1.  **Trigger Export**: Call the OData Action `ExportToPackage`. This initiates an asynchronous DMF job in D365.
2.  **Monitor Status**: Periodically call the OData Action `GetExecutionSummaryStatus` using the `executionId` returned by the trigger.
3.  **Retrieve URL**: Once the status is `Succeeded`, call the OData Action `GetExportedPackageUrl` to get a signed Azure Blob Storage download URL.
4.  **Download**: Perform an HTTP GET on the URL to download the ZIP package.
5.  **Extract & Process**: Unzip the package, extract the target data files, and process them locally.

---

## 3. Example Implementation: Product Variant Export

Synchronizing Released Product Variants from D365 to Moqui/HotWax OMS.

### Phase 1: Triggering the Export (service `export#ReleasedProductVariants`)

1.  **Initiate Job**: Call `ExportToPackage` with a `DefinitionGroupId` (e.g., `HotWax_Export_Product_Variants`) and a unique `packageName`.
2.  **Obtain Execution ID**: D365 responds with a unique `executionId` (string).

### Phase 2: Status Polling (service `poll#ExportStatus`)

1.  **Check Progress**: Call `GetExecutionSummaryStatus(executionId)`.
2.  **Poll for "Succeeded"**: Loop or schedule periodic checks until the status transitions to `Succeeded`.

### Phase 3: Final Retrieval (service `download#ExportedPackage`)

1.  **Get Package URL**: Call `GetExportedPackageUrl(executionId)`.
2.  **Download and Extract**:
    *   Download the binary ZIP stream.
    *   Find the data file matching a prefix (e.g., `Released product variants V2`).
    *   Save the extracted CSV/XML to the local filesystem for processing.

---

## 4. Implemented Services Over D365 Data Package Export APIs

The connector currently uses the following implemented generic and consumer services over the D365 Data Package export APIs:

- **Generic trigger service**
  - Service: [D365DataPackageServices.trigger#DataPackageExport](/Users/gurveenkaur/Documents/Work/git/oms/moqui-framework/runtime/component/hotwax-d365/service/co/hotwax/d365/D365DataPackageServices.xml:4)
  - Creates a `SystemMessage` entity record after triggering an export
- **Generic low-level export service**
  - Service: [D365DataPackageServices.export#DataPackage](/Users/gurveenkaur/Documents/Work/git/oms/moqui-framework/runtime/component/hotwax-d365/service/co/hotwax/d365/D365DataPackageServices.xml:47)
  - Calls D365 `ExportToPackage`
- **Generic poll service**
  - Service: [D365DataPackageServices.poll#DataPackageStatus](/Users/gurveenkaur/Documents/Work/git/oms/moqui-framework/runtime/component/hotwax-d365/service/co/hotwax/d365/D365DataPackageServices.xml:85)
  - Finds pending `SystemMessage` entity executions and checks them
- **Generic single-execution checker**
  - Service: [D365DataPackageServices.check#DataPackageStatus](/Users/gurveenkaur/Documents/Work/git/oms/moqui-framework/runtime/component/hotwax-d365/service/co/hotwax/d365/D365DataPackageServices.xml:109)
  - Calls `GetExecutionSummaryStatus` and `GetExportedPackageUrl`

### 4.1 Implemented Export APIs Used

- `ExportToPackage` API
- `GetExecutionSummaryStatus` API
- `GetExportedPackageUrl` API

### 4.2 Boundary of the Generic Layer

- The generic services in [D365DataPackageServices.xml](/Users/gurveenkaur/Documents/Work/git/oms/moqui-framework/runtime/component/hotwax-d365/service/co/hotwax/d365/D365DataPackageServices.xml) cover export triggering, export-status polling, signed URL retrieval, and ZIP download/extraction.
- Consumer flows provide the concrete `systemMessageTypeId`, `definitionGroupId`, `packageName`, `fileNamePrefix`, and downstream handling choice:
  - pass a DataManager config id to upload the extracted file into DataManager, or
  - pass a target directory to save the extracted file to disk.
- For the sales-order-specific export reconciliation flow that uses these generic services, refer to [implementation_plan.md](/Users/gurveenkaur/Documents/Work/git/oms/moqui-framework/runtime/component/foundation/project-ideas/dynamics365-integration/sales-orders/implementation_plan.md).

---

## 5. Key Considerations
*   **Asynchronous Nature**: Exports are batch jobs in D365 and may take several minutes depending on the volume of data.
*   **Unique Package Names**: Always generate a unique `packageName` for each export to avoid collisions.
*   **File Encoding**: D365 typically exports CSVs in `UTF-16LE` encoding. Local processing logic must be aware of this.
*   **Security**: The download URL is a pre-signed SAS token and typically expires within 90 minutes.
