# D365 Data Import Package API

This document outlines the architecture and implementation strategy for importing bulk data into Dynamics 365 (D365) using the **Data Package API**.

## 1. Objective
To efficiently synchronize large batches of records from Moqui/HotWax OMS to D365. This approach avoids the overhead of individual OData calls and overcomes limitations associated with composite entities (where only one file is allowed per package).

## 2. High-Level Flow (Import)

The Data Import Package API follows these core steps:

1.  **Generate Data**: Create the data files (CSV or XML) containing the records to import.
2.  **Generate Manifest**: Create a `Manifest.xml` and `PackageHeader.xml` that define the entities and their processing order.
3.  **Create ZIP**: Bundle the data files and manifests into a single ZIP package.
4.  **Get Upload URL**: Call the OData Action `GetAzureWriteUrl` to obtain a temporary Azure Blob storage `BlobUrl` (the PUT target) and a `BlobId` (a separate identifier not used in the import call).
5.  **Upload**: Execute an HTTP PUT to upload the ZIP file to the `BlobUrl`.
6.  **Trigger Import**: Call the OData Action `ImportFromPackage`, passing `packageUrl` (the `BlobUrl` from Step 4) and a `DefinitionGroupId` (the DMF project name in D365).
7.  **Monitor (Optional)**: Use `GetExecutionSummaryStatus` to poll for completion.

---

## 3. Implemented Services Over D365 Data Package Import APIs

The connector currently has the following generic implemented services over the D365 Data Package import APIs:

- **Generic poll service for import execution**
  - Service: `D365DataPackageServices.poll#ImportDataPackageStatus`
  - Used by import polling service jobs to monitor D365 import execution ids stored as `SystemMessage` entity records
- **Generic single-execution checker**
  - Service: `D365DataPackageServices.check#ImportDataPackageStatus`
  - Checks one import execution id and updates the related `SystemMessage` entity record
- **Generic execution error reader**
  - Service: `D365DataPackageServices.get#ExecutionErrors`
  - Retrieves D365 DMF execution errors for a given import execution id
  - Called by `check#ImportDataPackageStatus` when D365 reports a terminal failure status

### 3.1 Import APIs Used

- `GetAzureWriteUrl` API
- `ImportFromPackage` API
- `GetExecutionSummaryStatus` API
- `GetExecutionErrors` API

### 3.2 Import Tracking and Failure Handling

- After D365 accepts an import package and returns an execution id, the producer flow creates a `SystemMessage` tracking row in `SmsgSent` and stores the D365 execution id in `SystemMessage.remoteMessageId`.
- Import status jobs should call `D365DataPackageServices.poll#ImportDataPackageStatus` with the stream-specific `systemMessageTypeId`, and may override `retryMinutes` and `limit` from the service job.
- The poller selects matching `SystemMessage` records in `SmsgSent` whose `lastAttemptDate` is older than the retry cutoff, then calls `D365DataPackageServices.check#ImportDataPackageStatus`.
- Each execution is checked in its own transaction using `transaction="force-new" ignore-error="true"` so one failed D365 status check does not block the rest of the batch.
- The checker updates `lastAttemptDate`, calls D365 `GetExecutionSummaryStatus` using the execution id stored in `SystemMessage.remoteMessageId`, and:
  - moves the message to `SmsgConfirmed` when D365 returns `Succeeded` or `PartiallySucceeded`
  - calls `D365DataPackageServices.get#ExecutionErrors` and moves the message to `SmsgError` when D365 returns `Failed`, `Unknown`, or `Canceled`. Note: `Unknown` is not explicitly defined as a terminal state in Microsoft's documentation — it is treated as terminal here to avoid indefinite retries, but this could theoretically fail a message that would eventually resolve.
- **Composite entity requirement**: When the package contains a composite entity, the `overwrite` parameter in the `ImportFromPackage` call **must be set to `false`**. Microsoft explicitly documents this constraint — setting `overwrite=true` with a composite entity causes import failures.

  > [!WARNING]
  > The current `hotwax-d365` implementation sets `overwrite: true` in all `ImportFromPackage` calls, including the `Sales orders composite V4` import in `D365OrderServices.xml` (line ~585). This is inconsistent with Microsoft's documented requirement for composite entities and may be contributing to the silent `Failed` status observed on composite imports. **TODO:** Investigate and change `overwrite: true` → `overwrite: false` for all composite entity imports and verify whether this resolves the failure.
- Known D365 limitation observed with composite entity imports: for the Sales Orders Data Package import using `Sales orders composite V4`, D365 returns `Failed` from `GetExecutionSummaryStatus`, but `GetExecutionErrors` does not return the detailed execution errors through the API.
- Until this is resolved, failed composite imports may need to be reviewed manually in D365 Data Management.
- **TODO**: revisit error retrieval for failed composite imports and identify an API or exportable log source that returns detailed D365 execution errors.

### 3.3 Boundary of the Generic Layer

- The generic services in `D365DataPackageServices.xml` cover import-status polling and error retrieval after an import execution id already exists.
- Package construction, ZIP upload, `ImportFromPackage` submission, tracking-entity updates, and any follow-up reconciliation remain consumer-flow responsibilities.
- For the sales-order-specific implementation that uses these generic APIs, refer to [implementation_plan.md](../sales-orders/implementation_plan.md).


---

## 5. Prerequisites
*   **Permissions**: The App Registration requires Data Management privileges in D365 (**System administration > Setup > Microsoft Entra ID applications**).
*   **Roles**: Assign a role with DMF access to the integration user (e.g. **Data management administrator**, or a custom role granting Data Management privileges). Microsoft's official docs do not prescribe a specific role name — validate the required role against your D365 environment's security configuration.
