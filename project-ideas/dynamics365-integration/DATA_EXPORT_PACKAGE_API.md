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

### Phase 1: Triggering the Export (`export#ReleasedProductVariants`)

1.  **Initiate Job**: Call `ExportToPackage` with a `DefinitionGroupId` (e.g., `HotWax_Export_Product_Variants`) and a unique `packageName`.
2.  **Obtain Execution ID**: D365 responds with a unique `executionId` (string).

### Phase 2: Status Polling (`poll#ExportStatus`)

1.  **Check Progress**: Call `GetExecutionSummaryStatus(executionId)`.
2.  **Poll for "Succeeded"**: Loop or schedule periodic checks until the status transitions to `Succeeded`.

### Phase 3: Final Retrieval (`download#ExportedPackage`)

1.  **Get Package URL**: Call `GetExportedPackageUrl(executionId)`.
2.  **Download and Extract**:
    *   Download the binary ZIP stream.
    *   Find the data file matching a prefix (e.g., `Released product variants V2`).
    *   Save the extracted CSV/XML to the local filesystem for processing.

---

## 4. Key Considerations
*   **Asynchronous Nature**: Exports are batch jobs in D365 and may take several minutes depending on the volume of data.
*   **Unique Package Names**: Always generate a unique `packageName` for each export to avoid collisions.
*   **File Encoding**: D365 typically exports CSVs in `UTF-16LE` encoding. Local processing logic must be aware of this.
*   **Security**: The download URL is a pre-signed SAS token and typically expires within 90 minutes.
