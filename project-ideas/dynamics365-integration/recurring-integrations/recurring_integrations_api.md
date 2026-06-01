# D365 Recurring Integrations API Reference

This document outlines the architecture, integration patterns, and programmatic API endpoints for utilizing **Dynamics 365 Recurring Integrations (Queue-Based)** inside the `hotwax-d365` connector.

Official Reference: [Microsoft Dynamics 365 Recurring Integrations](https://learn.microsoft.com/en-us/dynamics365/fin-ops-core/dev-itpro/data-entities/recurring-integrations)

---

## 1. Inbound Integration (Import / Enqueue Flow)

The Inbound Integration allows external systems to push bulk data files or composite Data Packages into scheduled data jobs. The D365 background batch engine automatically picks up these files, staging and ledger-posting them asynchronously.

### 1.1 Core Enqueue API
External systems push payloads directly into a scheduled data job queue:
* **Endpoint:** `POST https://<d365-instance-url>/api/connector/enqueue/<activity-id>`
* **Content-Type:** `application/zip` (for Data Packages) or `application/octet-stream` (for flat files like CSV).
* **Response (HTTP 200):** Returns a unique **Queue Message ID** GUID in the JSON body:
  ```json
  {
    "value": "queue-message-guid"
  }
  ```

### 1.2 Programmatic Error Retrieval Strategy
Both standard Data Package (`ImportFromPackage`) and queue-based Recurring Integrations use the same underlying D365 Data Management Framework (DMF) engine. When an import fails, F&O exposes detailed record-level errors through the following two-step sequencing:

#### Step 1: Resolve the Execution ID from the Message ID
Because enqueuing returns a *Queue Message ID* (rather than a DMF *Execution ID*), we first call the OData action:
* **Endpoint:** `POST /data/DataManagementDefinitionGroups/Microsoft.Dynamics.DataEntities.GetExecutionIdByMessageId`
* **Request Body:**
  ```json
  {
    "_messageId": "enqueued-queue-message-guid"
  }
  ```
* **Response:** Returns the underlying DMF `executionId` GUID.
  * > [!IMPORTANT]
  * > **Handling Pending Queue Messages (Empty GUID):** If the Dynamics 365 background batch engine has not yet scheduled the enqueued file, the API returns the empty GUID `00000000-0000-0000-0000-000000000000`.
  * >
  * > In our poller poller (`check#RecurringSalesOrderImport`), this fallback GUID is intercepted, logging that the message is still pending in the queue, updating `lastAttemptDate` to throttle OData rate consumption, and keeping the message in the `SmsgSent` state for retry in the next scheduled loop.
  * >
  * > Once a valid non-zero DMF `executionId` is returned, the poller dynamically writes the `executionId` into `remoteMessageId` while keeping the original Queue Message ID safely preserved in the `messageId` field. This enables Moqui to maintain full auditability of both the Queue Message ID and the underlying DMF Execution ID concurrently.

#### Step 2: Retrieve the Staging Execution Errors
Once the `executionId` is resolved, we call the standard error reader endpoint:
* **Endpoint:** `POST /data/DataManagementDefinitionGroups/Microsoft.Dynamics.DataEntities.GetExecutionErrors`
* **Request Body:**
  ```json
  {
    "executionId": "resolved-dmf-execution-guid"
  }
  ```
* **Response:** Returns a rich, detailed JSON list containing the exact line-level validation failures:
  ```json
  {
      "value": "[{\"RecordId\":\"479625\",\"Field\":\"\",\"ErrorMessage\":\"\\n The Color Blue has not been assigned to the product Abominable Hoodie\\r\\n Validations failed while writing entity record\\r\\n\"}]"
  }
  ```
  
This allows Moqui to capture, decode, and log the F&O validation failures directly back to our local outbox tracking history!

### 1.3 DMF Staging Error Pipeline Scenarios & Visibility
While programmatic retrieval is highly robust, calling `GetExecutionErrors` will return different results depending strictly on the **point of failure** inside the F&O execution pipeline:

* **Phase 1: File/Source $\rightarrow$ Staging Table (Fully Exposed)**
  - *Scenario:* The package is correctly formed, but the data fails staging validations (e.g. `PRODUCTCOLORID` value is invalid, or the customer profile does not exist in F&O).
  - *Result:* SSIS successfully writes rows to the staging tables and records the validation constraints in the staging logs. `GetExecutionErrors` **successfully returns** the complete JSON list of failures.
* **Phase 2: Staging $\rightarrow$ Target Ledger Tables (Conditional Exposure)**
  - *Scenario:* The records pass staging checks but crash on ledger-specific target business logic (e.g., credit limit exceeded or posting period closed).
  - *Result:* If the target writing logic propagates errors back to the staging tables, they are visible. If they reside exclusively in F&O's global System InfoLogs, `GetExecutionErrors` might return an empty list.
* **Phase 0: SSIS Package & Schema Mismatches (Returns Empty)**
  - *Scenario:* The XML payload is malformed or completely omits a mapped element (e.g. commenting out the `SHIPPINGWAREHOUSEID` element when it has a defined column mapping in the data project).
  - *Result:* The SSIS pipeline throws a mapping collection crash (`HRESULT: 0xC0010009`) and aborts immediately before writing *any* rows to the staging tables. Since F&O never created staging records, **no staging error logs exist**, and `GetExecutionErrors` **returns an empty list**.
* **Staging Data Clean-up Purge Rules (Returns Empty)**
  - *Scenario:* D365 standard periodic jobs run "Staging clean-up" batches to physically purge staging rows and their logs to avoid database bloat.
  - *Result:* Once old staging logs are cleaned up, calling `GetExecutionErrors` for historical executions **returns an empty list**.

---

## 2. Outbound Integration (Export / Dequeue & Ack Flow)

The Outbound Integration allows external systems to pull bulk data files generated by D365 export jobs. 

### 2.1 Core Dequeue API
To retrieve the next exported package from the queue, make an HTTP call:
* **Endpoint:** `GET https://<d365-instance-url>/api/connector/dequeue/<activity-id>`
* **Response (HTTP 204):** Returned if the export queue is empty.
* **Response (HTTP 200):** Returns a JSON metadata redirect containing the download path and lease lock details:
  ```json
  {
    "CorrelationId": "temporary-session-guid",
    "PopReceipt": "pop-receipt-string-token",
    "DownloadLocation": "https://<d365-instance-url>/api/connector/download/...",
    "IsDownLoadFileExist": true,
    "FileDownLoadErrorMessage": null,
    "LastDequeueDateTime": null
  }
  ```

### 2.2 Package Download Process
The connector makes a secondary `GET` call to the `DownloadLocation` URL provided in the dequeue response (passing the OAuth Bearer token in the `Authorization` header) to download the binary ZIP package containing the exported CSV files.

### 2.3 Acknowledge (Ack) API
After successfully downloading and processing the export package, you must send an acknowledgment back to D365. **Until a message is acknowledged, D365 will release the lease lock after 30 minutes, making the message available to dequeue again.**
* **Endpoint:** `POST https://<d365-instance-url>/api/connector/ack/<activity-id>`
* **Request Body:** Must contain the **exact JSON response body** received from the `/dequeue` API call:
  ```json
  {
    "CorrelationId": "temporary-session-guid",
    "PopReceipt": "pop-receipt-string-token",
    "DownloadLocation": "https://<d365-instance-url>/api/connector/download/...",
    "IsDownLoadFileExist": true,
    "FileDownLoadErrorMessage": null,
    "LastDequeueDateTime": null
  }
  ```

### 2.4 GUID Mapping Distinction (UI Message ID vs. API CorrelationId)
* **D365 UI Message ID:** In the D365 SCM UI (**Manage scheduled data jobs > Manage messages**), the GUID displayed under the **"Message ID"** column is the *persistent database record ID* (e.g. `{1EB6FF02-...}`).
* **API Correlation ID:** The `CorrelationId` in the `/dequeue` JSON response is a *temporary lease lock token* used to link the dequeue session to the acknowledgment POST payload.
* **Mapping:** D365 resolves the `CorrelationId` internally on `/ack` POST ingestion, updates the corresponding database message record (e.g. `{1EB6FF02-...}`), and updates its status to **Acknowledged** in the UI.

---

## 3. D365 UI Monitoring & Administration

To monitor enqueued messages, check job runs, and download active payloads directly inside the Dynamics 365 Finance & Operations user interface:

### 3.1 Navigating to Scheduled Data Jobs
1. Go to the **System administration workspace** in D365 (accessible from the Workspaces menu or dashboard).
2. Click on the **Data management IT** workspace tile.
3. Under the Data Management dashboard, locate and click the **Manage scheduled data jobs** tile.
4. Locate your recurring import/export job in the list (e.g., `HotWax Recurring Sales Orders Import`).

### 3.2 Checking Job Execution History
* Select your scheduled job from the list.
* In the top action pane, click **Execution history**.
* This displays the standard DMF execution log showing each time the background batch processor ran to consume the enqueued files and its run outcome (`Succeeded`, `Failed`, or `PartiallySucceeded`).

### 3.3 Inspecting and Downloading Queue Payloads
* Select your scheduled job from the list.
* In the top action pane, click **View messages** or **Queue status**.
* This screen shows each enqueued/dequeued package with its:
  * **Message ID:** Database record GUID.
  * **Message status:** (e.g., `In queue`, `Processed`, `Acknowledged`, `Failed`).
  * **Download package:** Enables administrators to download the exact enqueued/dequeued ZIP package or data file posted by Moqui for manual inspection and troubleshooting.
