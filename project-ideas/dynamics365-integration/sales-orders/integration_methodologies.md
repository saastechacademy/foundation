d# Technical Integration Methodologies

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

### 2.1 The Authentication Flow
1. **Identity Provider**: Azure Active Directory (Microsoft Entra ID) validates the **App Registration** (Client ID/Secret).
2. **User Mapping**: The App Registration is mapped to a specific **D365 Finance User** within the ERP.
3. **Effective Permissions**: All OData calls execute using the mapped user's:
    - Security Roles
    - Data Permissions
    - Legal Entity (Company) Access

### 2.2 Configuration in D365
The mapping is configured at: `System administration > Setup > Microsoft Entra applications`.
- **Client ID**: The Application ID from Azure.
- **User ID**: The dedicated service user in D365.

### 2.3 Company (Legal Entity) Access
D365 is a multi-company system. OData visibility is strictly partitioned by `dataAreaId`.
- **Constraint**: If the service user lacks access to a specific company (Legal Entity), queries will return **empty results** rather than an authorization error.
- **Requirement**: Assign all required legal entities to the service user at: `System administration > Users > Users > [User] > Companies`.

### 2.4 Best Practices
> [!IMPORTANT]
> - **Dedicated Service User**: Always use a non-human service user (e.g., `svc_hotwax_integration`) for production.
> - **Explicit Context**: Always include `dataAreaId` in POST payloads and `$filter` by it in GET requests.
> - **Principle of Least Privilege**: Assign only the minimum required security roles to the integration user.

---

## 3. Data Management Framework (DMF)
- **Use Case**: High-volume asynchronous batch processing. Useful for bulk customer imports or large order migrations.
- **Official Documentation**: [Data management overview](https://learn.microsoft.com/en-us/dynamics365/fin-ops-core/dev-itpro/data-entities/data-entities-data-packages)

## 4. Business Events (Near Real-time Outbound)
- **Use Case**: Triggering external actions based on D365 internal events (e.g., notifying OMS of a posted invoice).
- **Official Documentation**: [Business events overview](https://learn.microsoft.com/en-us/dynamics365/fin-ops-core/dev-itpro/data-entities/business-events/home-page)

### 4.1 Key Concepts
Business Events provide a mechanism that lets external systems receive notifications from Finance and Operations. This is the **recommended methodology** for "D365 -> OMS" push notifications.

| Feature | Description |
| :--- | :--- |
| **Push-based** | D365 activeley sends a notification when a business process completes. |
| **Event-driven** | Reduces load by eliminating the need for external systems to poll OData. |
| **Standard Events** | Includes `SalesOrderInvoicedBusinessEvent`, `SalesOrderConfirmedBusinessEvent`, etc. |

### 4.2 Integration Patterns
Business events can be consumed through various endpoints:

1.  **Azure Power Automate**: The most common "low-code" approach using the D365 F&O connector.
2.  **HTTPS Webhooks**: Direct POST requests to a specified URL (e.g., a Moqui REST service).
3.  **Azure Service Bus**: For reliable, asynchronous messaging and queuing.
4.  **Azure Event Grid**: For high-scale event routing.

### 4.3 Comparison: OData vs. Business Events
- **OData (Pull)**: Best for synchronous CRUD or batch data retrieval where the OMS initiates the request.
- **Business Events (Push)**: Best for reactive workflows where D365 must notify the OMS of a state change (e.g., fulfillment complete).
