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

## 4. Export Integration Approaches

The connector has explored two integration approaches over the D365 Data Package Export APIs.

### Approach 1 - Execution Tracking Using `SystemMessage` Records

This was the earlier implementation approach.

#### Summary
- The export was triggered first.
- After D365 returned the `executionId`, OMS created a `SystemMessage` entity record only to track that execution.
- The `SystemMessage` record was not the outbound unit of work; it was used as an execution tracker.

#### Services in this approach
- **Generic trigger service**
  - Service: `D365DataPackageServices.trigger#DataPackageExport`
  - Responsibility:
    - call D365 `ExportToPackage`
    - then create a `SystemMessage` entity record with `statusId = SmsgProduced`
- **Generic single-execution checker**
  - Service: `D365DataPackageServices.check#DataPackageStatus`
  - Responsibility:
    - read `executionId` from `SystemMessage.messageText`
    - call `GetExecutionSummaryStatus`
    - on success call `GetExportedPackageUrl`
    - download and process the exported file
- **Generic poll service**
  - Service: `D365DataPackageServices.poll#DataPackageStatus`
  - Responsibility:
    - find `SystemMessage` entity records in `SmsgProduced`
    - call `check#DataPackageStatus`

#### How the `SystemMessage` record was used
- `systemMessageTypeId`: integration stream identifier
- `systemMessageRemoteId`: D365 remote configuration identifier
- `messageText`: stored the D365 `executionId`
- `statusId = SmsgProduced`: used as a tracking state, not as a true Moqui send state

#### Why this approach was useful
- It validated the D365 export mechanics:
  - `ExportToPackage`
  - `GetExecutionSummaryStatus`
  - `GetExportedPackageUrl`
  - ZIP download and extraction
- It made the D365 execution visible in `SystemMessage`
- It gave a straightforward reconciliation path for early connector development

#### Limitation of this approach
- It used `SystemMessage` mainly as a persistence/tracking record
- It did not follow the native Moqui `sendServiceName` flow for outgoing messages
- `sendNow=false` meant the created `SystemMessage` entity record was not intended to be sent through `send#ProducedSystemMessage`
- `SmsgProduced` therefore represented a tracker row, not a true produced outbound message

### Approach 2 - Moqui-Native `SystemMessage` Send Flow

This is the current export model and the implemented generic framework.

#### Summary
- OMS first queues a `SystemMessage` entity record in `SmsgProduced`
- the configured `sendServiceName` performs the D365 `ExportToPackage` call
- D365 returns `executionId`
- Moqui stores the returned `executionId` in `SystemMessage.remoteMessageId`
- OMS later polls `SmsgSent` messages and moves them to `SmsgConfirmed` after successful package processing

#### Generic services in this approach
- **Generic queue service**
  - Service: [D365DataPackageServices.queue#ExportDataPackage](/Users/gurveenkaur/Documents/Work/git/oms/moqui-framework/runtime/component/hotwax-d365/service/co/hotwax/d365/D365DataPackageServices.xml:4)
  - Responsibility:
    - validate export-specific inputs
    - build the export payload JSON
    - call `org.moqui.impl.SystemMessageServices.queue#SystemMessage`
    - queue the message with `sendNow=true`
- **Generic send service**
  - Service: [D365DataPackageServices.send#ExportDataPackage](/Users/gurveenkaur/Documents/Work/git/oms/moqui-framework/runtime/component/hotwax-d365/service/co/hotwax/d365/D365DataPackageServices.xml:40)
  - Responsibility:
    - implement `org.moqui.impl.SystemMessageServices.send#SystemMessage`
    - parse `SystemMessage.messageText`
    - call D365 `ExportToPackage`
    - return `remoteMessageId = executionId`
- **Generic poll service**
  - Service: [D365DataPackageServices.poll#ExportDataPackageStatus](/Users/gurveenkaur/Documents/Work/git/oms/moqui-framework/runtime/component/hotwax-d365/service/co/hotwax/d365/D365DataPackageServices.xml:86)
  - Responsibility:
    - find sent export messages by `systemMessageTypeId` and `statusId = SmsgSent`
    - call the single-message checker
- **Generic single-message poll/check service**
  - Service: [D365DataPackageServices.check#ExportDataPackageStatus](/Users/gurveenkaur/Documents/Work/git/oms/moqui-framework/runtime/component/hotwax-d365/service/co/hotwax/d365/D365DataPackageServices.xml:110)
  - Responsibility:
    - read `executionId` from `SystemMessage.remoteMessageId`
    - call `GetExecutionSummaryStatus`
    - when complete, call `GetExportedPackageUrl`
    - download the ZIP package
    - extract the configured file
    - either:
      - upload the extracted file to DataManager, or
      - save the extracted file to the configured target directory
    - move the `SystemMessage` entity record to `SmsgConfirmed` on success
    - move it to `SmsgError` on terminal failure
- **Generic download service**
  - Service: [D365DataPackageServices.download#DataPackage](/Users/gurveenkaur/Documents/Work/git/oms/moqui-framework/runtime/component/hotwax-d365/service/co/hotwax/d365/D365DataPackageServices.xml:276)
  - Responsibility:
    - download the D365 ZIP
    - extract the configured file to a local directory
- **Generic execution error reader**
  - Service: [D365DataPackageServices.get#ExecutionErrors](/Users/gurveenkaur/Documents/Work/git/oms/moqui-framework/runtime/component/hotwax-d365/service/co/hotwax/d365/D365DataPackageServices.xml:385)
  - Responsibility:
    - call D365 `GetExecutionErrors`

#### `SystemMessage` field usage in this approach
- `systemMessageTypeId`: identifies the export stream, for example:
  - `D365_EXPORT_PRODUCTS`
  - `D365_EXPORT_WAREHOUSES`
  - `D365_EXP_SALES_ORDERS`
- `systemMessageRemoteId`: identifies the D365 remote configuration
- `messageText`: stores JSON metadata needed for send and poll, for example:

```json
{
  "definitionGroupId": "HotWax_Export_Sales_Orders",
  "packageName": "SalesOrderHeadersV4",
  "legalEntityId": "USMF",
  "fileName": "Sales order headers V4.csv",
  "dataManagerConfigId": "D365_IMP_SALES_ORD",
  "targetDirectory": null,
  "systemMessageRemoteId": "D365_HotWax_Sandbox"
}
```

- `remoteMessageId`: stores the D365 `executionId`

#### Status lifecycle in this approach
- `SmsgProduced`
  - OMS has queued the outbound export message
- `SmsgSending`
  - Moqui is invoking the configured `sendServiceName`
- `SmsgSent`
  - D365 accepted the export request and returned `executionId`
- `SmsgConfirmed`
  - OMS polled the execution, downloaded the exported package, and processed the file successfully
- `SmsgError`
  - D365 export failed, or OMS failed to process the returned file

#### Boundary of the generic layer
- The generic export services in [D365DataPackageServices.xml](/Users/gurveenkaur/Documents/Work/git/oms/moqui-framework/runtime/component/hotwax-d365/service/co/hotwax/d365/D365DataPackageServices.xml) now cover:
  - queuing export `SystemMessage` entity records
  - triggering D365 `ExportToPackage`
  - polling export status
  - signed URL retrieval
  - ZIP download and extraction
  - DataManager upload or local directory extraction
- Consumer flows provide the concrete values:
  - `systemMessageTypeId`
  - `definitionGroupId`
  - `packageName`
  - `fileName`
  - `dataManagerConfigId` or `targetDirectory`
- Consumer flows also provide the downstream row-processing logic through the configured DataManager import service.

### 4.1 Implemented Export APIs Used

- `ExportToPackage` API
- `GetExecutionSummaryStatus` API
- `GetExportedPackageUrl` API
- `GetExecutionErrors` API

### 4.2 Guidance for Consumer Flows

- Use **Approach 2** for current and future export integrations.
- Keep **Approach 1** documented only as the earlier design that validated the D365 export mechanics.
- For the sales-order-specific export reconciliation flow that uses the current generic export services, refer to [implementation_plan.md](/Users/gurveenkaur/Documents/Work/git/oms/moqui-framework/runtime/component/foundation/project-ideas/dynamics365-integration/sales-orders/implementation_plan.md).

---

## 5. Key Considerations
*   **Asynchronous Nature**: Exports are batch jobs in D365 and may take several minutes depending on the volume of data.
*   **Unique Package Names**: Always generate a unique `packageName` for each export to avoid collisions.
*   **File Encoding**: D365 typically exports CSVs in `UTF-16LE` encoding. Local processing logic must be aware of this.
*   **Security**: The download URL is a pre-signed SAS token and typically expires within 90 minutes.
