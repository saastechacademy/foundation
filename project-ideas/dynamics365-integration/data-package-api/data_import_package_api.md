# D365 Data Import Package API

This document outlines the architecture and implementation strategy for importing bulk data into Dynamics 365 (D365) using the **Data Package API**.

## 1. Objective
To efficiently synchronize large batches of records from Moqui/HotWax OMS to D365. This approach avoids the overhead of individual OData calls and overcomes limitations associated with composite entities (where only one file is allowed per package).

## 2. High-Level Flow (Import)

The Data Import Package API follows these core steps:

1.  **Generate Data**: Create the data files (CSV or XML) containing the records to import.
2.  **Generate Manifest**: Create a `Manifest.xml` and `PackageHeader.xml` that define the entities and their processing order.
3.  **Create ZIP**: Bundle the data files and manifests into a single ZIP package.
4.  **Get Upload URL**: Call the OData Action `GetAzureWriteUrl` to obtain a temporary Azure Blob storage URL and a `BlobId`.
5.  **Upload**: Execute an HTTP PUT to upload the ZIP file to the Azure URL.
6.  **Trigger Import**: Call the OData Action `ImportFromPackage`, passing the `BlobId` and a `DefinitionGroupId` (the DMF project name in D365).
7.  **Monitor (Optional)**: Use `GetExecutionSummaryStatus` to poll for completion.

---

## 4. Implemented Services Over D365 Data Package Import APIs

The connector currently has the following generic implemented services over the D365 Data Package import APIs:

- **Generic poll service for import execution**
  - Service: [D365DataPackageServices.poll#ImportDataPackageStatus](/Users/gurveenkaur/Documents/Work/git/oms/moqui-framework/runtime/component/hotwax-d365/service/co/hotwax/d365/D365DataPackageServices.xml:216)
  - Used by import polling service jobs to monitor D365 import execution ids stored as `SystemMessage` entity records
- **Generic single-execution checker**
  - Service: [D365DataPackageServices.check#ImportDataPackageStatus](/Users/gurveenkaur/Documents/Work/git/oms/moqui-framework/runtime/component/hotwax-d365/service/co/hotwax/d365/D365DataPackageServices.xml:324)
  - Checks one import execution id and updates the related `SystemMessage` entity record
- **Generic execution error reader**
  - Service: [D365DataPackageServices.get#ExecutionErrors](/Users/gurveenkaur/Documents/Work/git/oms/moqui-framework/runtime/component/hotwax-d365/service/co/hotwax/d365/D365DataPackageServices.xml:372)
  - Retrieves D365 DMF execution errors for a given import execution id

### 4.1 Import APIs Used

- `GetAzureWriteUrl` API
- `ImportFromPackage` API
- `GetExecutionSummaryStatus` API
- `GetExecutionErrors` API

### 4.2 Boundary of the Generic Layer

- The generic services in [D365DataPackageServices.xml](/Users/gurveenkaur/Documents/Work/git/oms/moqui-framework/runtime/component/hotwax-d365/service/co/hotwax/d365/D365DataPackageServices.xml) cover import-status polling and error retrieval after an import execution id already exists.
- Package construction, ZIP upload, `ImportFromPackage` submission, tracking-entity updates, and any follow-up reconciliation remain consumer-flow responsibilities.
- For the sales-order-specific implementation that uses these generic APIs, refer to [implementation_plan.md](/Users/gurveenkaur/Documents/Work/git/oms/moqui-framework/runtime/component/foundation/project-ideas/dynamics365-integration/sales-orders/implementation_plan.md).

---

## 5. Prerequisites
*   **Permissions**: The App Registration requires Data Management privileges in D365 (**System administration > Setup > Microsoft Entra ID applications**).
*   **Roles**: Assign the **Data management administrator** role or a custom role with DMF access to the integration user.
