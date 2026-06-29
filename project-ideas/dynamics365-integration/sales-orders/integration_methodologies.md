# Technical Integration Methodologies

This document explores the various technical patterns available for integrating with Dynamics 365 Finance & Operations.

## 1. OData (REST)
- **Use Case**: Real-time CRUD operations.
- **Base Endpoint**: `[D365_URL]/data/`
- **Official Documentation**: [Open Data Protocol (OData) in D365](https://learn.microsoft.com/en-us/dynamics365/fin-ops-core/dev-itpro/data-entities/odata)

### 1.1 OData Metadata Concepts
To understand and integrate with D365 entities, you must be able to read the metadata provided at `[D365_URL]/data/$metadata`.

| Term | Meaning |
| :--- | :--- |
| **EntitySet** | The URL collection or endpoint (e.g., `CustomersV3`). |
| **EntityType** | The schema definition and structure of the data object. |
| **Key** | Defines the Primary Key fields (e.g., `dataAreaId`, `CustomerAccount`). |
| **Property** | Individual field definitions within the EntityType. |
| **Nullable="false"** | Indicates a **Required Field** that cannot be empty. |
| **NavigationProperty** | Defines relationships to other entities (e.g., Addresses, SalesLines). |

### 1.2 Usage Patterns
OData is used for real-time synchronization between HotWax OMS and D365. It is the primary method for transactional data where immediate response or record creation is required.

#### 1.2.1 Idempotency Pattern (Find-or-Create)
To prevent duplicate records (e.g., Sales Headers) during retries, OData calls should follow a **Search-then-Sync** pattern:
1.  **Search**: Query the entity using a unique external reference (e.g., OMS `orderId`).
2.  **Verify**: If the record exists, skip creation and use the existing ERP identifier.
3.  **Create**: Only `POST` if the search return zero results.

---

## 2. Custom Services (SysOperation)
- **Official Documentation**: [Custom service development](https://learn.microsoft.com/dynamics365/fin-ops-core/dev-itpro/data-entities/custom-services)
- **Use Case**: Atomic creation of complex documents (Header + Lines) in a single transaction.
- **Protocol**: REST (JSON/XML) or SOAP.
- **Description**: A custom X++ endpoint that accepts a full document payload. D365 processes the entire structure within one database transaction.

### 2.1 Benefits over OData
| Feature | OData (REST) | Custom Service |
| :--- | :--- | :--- |
| **Atomicity** | None (per call) | Full (Transactional) |
| **Performance** | Multi-request (1+N) | Single Request |
| **Payload** | Flat per entity | Nested/Hierarchical |
| **Logic** | Default CRUD | Custom X++ Workflow |

### 2.2 Recommendation
For Sales Order synchronization where transactional integrity is critical, OData is suitable for initial phases (Approach 1), but **Custom Services (Approach 2)** are recommended for high-volume production deployments.

---

## 3. Authentication & Security (REST)

Integrating with D365 F&O requires a multi-layered security configuration. All API calls execute in the context of a specific D365 user, not a generic application identity.

### 3.1 The Authentication Flow
1. **Identity Provider**: Azure Active Directory (Microsoft Entra ID) validates the **App Registration** (Client ID/Secret).
2. **User Mapping**: The App Registration is mapped to a specific **D365 Finance User** within the ERP.
3. **Effective Permissions**: All OData calls execute using the mapped user's:
    - Security Roles
    - Data Permissions
    - Legal Entity (Company) Access

### 3.2 Configuration in D365
The mapping is configured at: `System administration > Setup > Microsoft Entra applications`.
- **Client ID**: The Application ID from Azure.
- **User ID**: The dedicated service user in D365.

### 3.3 Company (Legal Entity) Access
D365 is a multi-company system. OData visibility is strictly partitioned by `dataAreaId`.
- **Constraint**: If the service user lacks access to a specific company (Legal Entity), queries will return **empty results** rather than an authorization error.
- **Requirement**: Assign all required legal entities to the service user at: `System administration > Users > Users > [User] > Companies`.

### 3.4 Best Practices
> [!IMPORTANT]
> - **Dedicated Service User**: Always use a non-human service user (e.g., `svc_hotwax_integration`) for production.
> - **Explicit Context**: Always include `dataAreaId` in POST payloads and `$filter` by it in GET requests.
> - **Principle of Least Privilege**: Assign only the minimum required security roles to the integration user.

---

## 4. Data Management Framework (DMF)
- **Use Case**: High-volume asynchronous batch processing. Useful for bulk customer imports or large order migrations.
- **Official Documentation**: [Data management overview](https://learn.microsoft.com/en-us/dynamics365/fin-ops-core/dev-itpro/data-entities/data-entities-data-packages)

## 5. Business Events (Near Real-time Outbound)
- **Use Case**: Triggering external actions based on D365 internal events (e.g., notifying OMS of a posted invoice).
- **Official Documentation**: [Business events overview](https://learn.microsoft.com/en-us/dynamics365/fin-ops-core/dev-itpro/data-entities/business-events/home-page)

### 5.1 Key Concepts
Business Events provide a mechanism that lets external systems receive notifications from Finance and Operations. This is the **recommended methodology** for "D365 -> OMS" push notifications.

| Feature | Description |
| :--- | :--- |
| **Push-based** | D365 actively sends a notification when a business process completes. |
| **Event-driven** | Reduces load by eliminating the need for external systems to poll OData. |
| **Standard Events** | Includes `SalesOrderInvoicedBusinessEvent`, `SalesOrderConfirmedBusinessEvent`, etc. |

### 5.2 Integration Patterns
Business events can be consumed through various endpoints:

1.  **Azure Power Automate**: The most common "low-code" approach using the D365 F&O connector.
2.  **HTTPS Webhooks**: Direct POST requests to a specified URL (e.g., a Moqui REST service).
3.  **Azure Service Bus**: For reliable, asynchronous messaging and queuing.
4.  **Azure Event Grid**: For high-scale event routing.

### 5.3 Comparison: OData vs. Business Events
- **OData (Pull)**: Best for synchronous CRUD or batch data retrieval where the OMS initiates the request.
- **Business Events (Push)**: Best for reactive workflows where D365 must notify the OMS of a state change (e.g., fulfillment complete).

---

## 6. Recurring Integrations Scheduler
- **Use Case**: Continuous, queue-based import or export of data packages without requiring the external system to manage Azure Blob upload/download URLs.
- **Official Documentation**: [Recurring integrations](https://learn.microsoft.com/en-us/dynamics365/fin-ops-core/dev-itpro/data-entities/recurring-integrations)

### 6.1 Key Concepts

The Recurring Integrations Scheduler exposes two queue-based APIs that sit on top of the same DMF pipeline: an **Enqueue API** for inbound data (OMS → D365) and a **Dequeue API** for outbound data (D365 → OMS).

| Feature | Description |
| :--- | :--- |
| **Queue-based** | External system enqueues or dequeues packages; D365 manages the internal queue |
| **Same DMF pipeline** | Uses the same composite entities and definition groups as the Data Package API |
| **No Azure Blob management** | Eliminates explicit Azure Blob upload/download URL handling required by the Data Package API |
| **Asynchronous** | Processing is non-blocking; status is resolved separately via `GetExecutionIdByMessageId` |

### 6.2 Enqueue API (Inbound: OMS → D365)

Used to submit data packages into D365 without uploading to Azure Blob Storage directly.

- **Endpoint**: `POST /api/connector/enqueue/{activityId}`
- **Returns**: A Queue Message ID (GUID)
- **Status resolution**: Two-step — `GetExecutionIdByMessageId` (Queue Message ID → DMF Execution ID) → `GetExecutionSummaryStatus` (Execution ID → status)
- **Suitable for**: High-frequency or continuous background inbound flows (e.g., sales order import, arrival journal import)

### 6.3 Dequeue API (Outbound: D365 → OMS)

Used to pull pre-scheduled D365 export packages from a recurring job queue.

- **Endpoints**: `GET /api/connector/dequeue/{activityId}` → download via Blob redirect → `POST /api/connector/ack/{activityId}` (acknowledgment)
- **Returns**: A package URL for download; acknowledgment clears the item from the queue
- **Suitable for**: Polling-based outbound flows where D365 generates export packages on a schedule (e.g., sales order number export, product variant export)

### 6.4 Comparison: Data Package API vs. Recurring Integrations API

| Feature | Data Package API | Recurring Integrations API |
| :--- | :--- | :--- |
| **Azure Blob** | External system manages upload/download URLs | Managed internally by D365 |
| **Status** | Execution ID returned directly on import | Queue Message ID → Execution ID (extra hop) |
| **Best for** | On-demand, controlled batch imports | High-frequency, continuous background flows |
| **Outbound** | `ExportToPackage` + `GetExportedPackageUrl` | Dequeue + Ack pattern |
