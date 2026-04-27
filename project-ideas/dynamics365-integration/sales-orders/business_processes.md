# Dynamics 365 Business Processes

This document captures the business requirements and process flows for the D365 F&O integration.

HotWax acts as an integration adapter to ensure that D365, as the financial system of record, receives clean and sequential transactional data. This includes translating Shopify's complex, compounded exchange orders into distinct records for returns (RMA), exchange credit, and new sales orders.

## 1. Foundational Concepts & System Setup

The generic business-process foundations for D365 F&O integration are documented in [business_process_foundations.md](/Users/gurveenkaur/Documents/Work/git/oms/moqui-framework/runtime/component/foundation/project-ideas/dynamics365-integration/foundation/business_process_foundations.md).

This sales-order document focuses only on customer, sales-order, and payment process behavior that is specific to the sales-order domain.

---

## 2. Customer Sync

For successful sales order integration, it is a prerequisite that the customer record must be synchronized and exist in Dynamics 365 prior to the order sync.

### 2.1 Accounts Receivable
**Customers are a core part of the Accounts Receivable (AR) module.** All customer-related transactional data, such as sales invoices, payments, and aging reports, are handled within this module.

- **Reference**: [Accounts receivable home page](https://learn.microsoft.com/en-us/dynamics365/finance/accounts-receivable/accounts-receivable)

### 2.2 Identification (CustomerAccount)
- **Nature**: The business-facing identifier used in sales orders, invoices, and reports.
- **Master ID**: It is the unique identifier for a customer *within* a specific `dataAreaId`.
- **Key**: Part of the composite primary key: `(dataAreaId, CustomerAccount)`.
- **Integration Key (Current Implementation)**: The current connector uses the HotWax `partyId` with an `HW-` prefix as the D365 `CustomerAccount` value, i.e. `HW-<partyId>`.

### 2.3 Identification Pattern
- **Pattern**: 
    1. OMS pushes customer with `CustomerAccount = HW-<partyId>`.
    2. D365 uses the provided ID for record creation. Since HotWax provides the identifier, no sync-back of a D365-generated ID is required.

> [!NOTE]
> Using the Shopify Customer ID instead of `partyId` is still exploratory and is not part of the current implementation.


### 2.4 Minimum Required Fields for Creation
| Field | Purpose | Example (Person) |
| :--- | :--- |:-----------------|
| `dataAreaId` | Legal entity | `usmf`           |
| `CustomerAccount` | Customer number | `HW-10090`       |
| `PartyType` | Customer Type | `Person`         |
| `PersonFirstName` | First name | `Gurveen`        |
| `PersonLastName` | Last name | `Bagga`          |
| `CustomerGroupId` | Financial grouping | `30`             |
| `SalesCurrencyCode` | Default currency | `USD`            |

- **Reference**: [Import customers](https://learn.microsoft.com/en-us/dynamics365/guidance/resources/import-customers)

> [!NOTE]
> In the current implementation, `dataAreaId` is still hardcoded to `usmf`, and `CustomerGroupId` is still hardcoded to `30`.
>
> **TODO:** Replace these hardcoded values with environment-specific mappings.

### 2.5 Financial Configuration (Customer Groups)
The **Customer Group (`CustomerGroupId`)** is the primary "Financial Driver" for a customer.

#### The Role in Invoicing & Posting
D365 does not store a specific General Ledger (GL) account on the customer record. Instead, it uses the Customer Group as a bridge:
1.  **Relation**: `Customer` -> `Customer Group` -> `Posting Profile` -> `Main Account`.
2.  **Invoicing Flow**: 
    - When a Sales Invoice is posted, the system reads the `CustomerGroupId` from the customer record.
    - It then looks up the **Customer Posting Profile** (configured in AR setup).
    - The Posting Profile identifies which **Main Account** (e.g., Accounts Receivable - Domestic) to debit based on that specific Group.
3.  **Default Data**: Beyond accounting, the group also provides defaults for:
    - **Terms of Payment** (e.g., Net 30, Due upon receipt).
    - **Sales Tax Group** (if not overridden on the customer).

#### Mandatory Requirement
- **Scope**: Must exist within the same `dataAreaId`.
- **Validation**: Creation of a customer via OData **will fail** if a valid `CustomerGroupId` is not provided.

---

## 3. Sales Orders Sync

Sales orders are synchronized from HotWax OMS to D365 F&O after prerequisite customer creation. The business process is the same regardless of transport method, but the connector currently supports two separate implementation patterns:
- **OData pattern**: Direct sync using `SalesOrderHeadersV4` and `SalesOrderLinesV3`.
- **DMF / Data Package pattern**: Package-based import using the `Sales orders composite V4` composite entity.

> **Prerequisite**: A customer record must exist in D365 before a sales order can be created for that customer. Refer to the [Customer Sync](#2-customer-sync) section for more details.

### 3.1 Business Process Overview

- **Order Selection**: Eligible OMS sales orders are identified for export to D365.
- **Customer Prerequisite**: The bill-to customer is created or verified in D365 before order creation/import.
- **Order Creation**: The sales order header and lines are sent to D365 using either OData or DMF.
- **Acknowledgment**: The order is considered synced only after the selected integration path reaches its defined success checkpoint.
- **Downstream Ownership**: Fulfillment, packing slip posting, invoicing, and settlement remain D365-side operational processes.

### 3.2 Supported Integration Patterns

#### 3.2.1 OData Pattern
This pattern creates the sales order directly through standard OData entities.

- **D365 Interface**: `SalesOrderHeadersV4` and `SalesOrderLinesV3`
- **Processing Style**: Direct request-driven sync
- **Idempotency Pattern**:
    - Header lookup uses `CustomersOrderReference = orderId`
    - Line lookup uses `LineNumber = orderItemSeqId`
- **Constraint**: Header and line creation are separate operations, so partial document creation is possible on failure.
- **Current Use Case**: Simple direct sync and entity-level control.

#### 3.2.2 DMF / Data Package Pattern
This pattern creates a composite package and submits it through the Data Management Framework (DMF).

- **D365 Interface**: `Sales orders composite V4`
- **Composite Child Records**:
    - `SALESORDERHEADERV3ENTITY`
    - `SALESORDERLINEV2ENTITY`
    - `SALESORDERHEADERCHARGEV2ENTITY`
- **Processing Style**: Batch/package-based import
- **Constraint**: Import processing is asynchronous from the business point of view and requires package submission/orchestration.
- **Current Use Case**: Larger-volume order import and composite payload submission.

#### 3.2.3 Pattern Comparison

| Pattern | D365 Interface | Entity Model | Processing Style | Main Constraint |
| :--- | :--- | :--- | :--- | :--- |
| OData | `SalesOrderHeadersV4`, `SalesOrderLinesV3` | Separate header and line entities | Direct request/response | Partial order creation on failure |
| DMF | `Sales orders composite V4` | Composite import package | Batch/asynchronous | Package generation, upload, and import monitoring |

> [!NOTE]
> Detailed implementation specifics for both patterns are documented in [implementation_plan.md](/Users/gurveenkaur/Documents/Work/git/oms/moqui-framework/runtime/component/foundation/project-ideas/dynamics365-integration/sales-orders/implementation_plan.md) and the shared DMF reference at [data_import_package_api.md](/Users/gurveenkaur/Documents/Work/git/oms/moqui-framework/runtime/component/foundation/project-ideas/dynamics365-integration/data-package-api/data_import_package_api.md).

### 3.3 Shared Business Rules

The following business rules apply regardless of whether the order is synchronized through OData or DMF.

- **D365 Order Identity**: `SalesOrderNumber` is the D365-generated order identifier returned after successful creation/import.
- **External Reference**: HotWax `orderId` is carried as `CustomersOrderReference` to support lookup and reconciliation.
- **Customer Association**:
    - `OrderingCustomerAccountNumber` uses the resolved D365 customer account returned by customer sync.
    - `InvoiceCustomerAccountNumber` currently uses the same resolved D365 customer account.
- **Address Handling**: OMS shipping address details are sent on the order so D365 can use order-level delivery details.
- **Sync Completion Rule**: The order should only be treated as fully synced in OMS after the selected integration path has successfully completed.

> [!NOTE]
> The exact success checkpoint differs by pattern. OData can treat successful entity creation as the checkpoint, while DMF may require import submission plus downstream confirmation/monitoring.

> [!NOTE]
> The current connector implementations still contain TODOs for exact D365 item mapping, variant dimensions, hardcoded defaults, and some header-level field gaps. These remain implementation concerns, not business-process blockers.

### 3.4 Order-Specific Address Pattern

HotWax OMS sends the shipping address as part of the sales order data so the delivery address remains scoped to the order transaction instead of changing the customer master.

- **OData Pattern**:
    - Uses order header delivery address fields
    - Explicitly sets `IsDeliveryAddressOrderSpecific = Yes`
- **DMF Pattern**:
    - Supplies address attributes through the composite header entity
- **Key Business Fields**:
    - Recipient name
    - Street
    - City
    - State/Province
    - Postal code
    - Country/region

> [!NOTE]
> The OData implementation explicitly sets `IsDeliveryAddressOrderSpecific = Yes`. The exact read-back behavior in D365 responses should still be validated in the target environment.

---

## 4. Customer Payment Management

Customer payments from HotWax OMS are captured in D365 F&O as **Customer Payment Journals** to allow for financial recording before invoice settlement.

### 4.1 Journal-Based Approach
- **Pattern**: Payment journals are created as unposted drafts via OData.
- **Timing**: Payments are sent to D365 immediately after capture in OMS, which may occur before the Sales Invoice is generated in D365.
- **Entity**: `CustomerPaymentJournalHeaders` and `CustomerPaymentJournalLines`.
- **Current Idempotency Pattern**:
    - Header lookup uses `Description = OMS Payment Journal - SO <d365SalesOrderNumber>`.
    - Line lookup uses `PaymentId = orderPaymentPreferenceId`.

### 4.2 Prepayment vs. Standard Payment
- **Standard Payment (On-Account)**:
    - **Setup**: `IsPrepayment = No`.
    - **Behavior**: Creates an "Open Transaction" on the customer account with `PaymentReference` currently mapped to the D365 `SalesOrderNumber`.
    - **Pros**: Simpler configuration, less sensitive to tax validation errors during journal posting.
- **Prepayment**:
    - **Setup**: `IsPrepayment = Yes`.
    - **Behavior**: Triggers specific "Prepayment" posting profiles and often requires tax to be inclusive.
    - **Constraint**: More complex to post via OData due to strict tax and profile requirements.

### 4.3 Settlement Strategy
1.  **Creation**: Payment is posted to the customer account "on-account" (unapplied).
2.  **Invoice Generation**: Later, when the order is fulfilled, a Sales Invoice is created.
3.  **Settlement**: A separate process (either D365 batch settlement or custom logic) is expected to match the payment to the invoice using the shared D365 sales order reference.

> [!NOTE]
> The current connector creates unposted payment journal headers and lines. It does not yet implement journal posting or invoice settlement orchestration.

---

## 5. Fulfillment & Invoicing

This section captures the intended D365-side operational flow after order synchronization. The connector implementation reviewed here focuses on pushing customers, sales orders, and payment journals; fulfillment and invoice posting are still D365-side process decisions.

### 5.1 Fulfillment Flow
- **Picking and Packing**: These operations are handled in D365.
- **Packing Slip**: Posting a packing slip marks the order as "Delivered."

### 5.2 Invoicing Requirement
- **Custom Logic**: Orders created via OData may not automatically trigger invoicing upon packing slip posting.
- **Requirement**: Implement or trigger invoicing logic within D365 to ensure the Sales Order moves to the "Invoiced" state.

> [!TODO]
> Validate the exact invoicing behavior in the target D365 environment. This is retained as an exploration point and is not enforced by the current HotWax connector code.

### 5.3 Settlement Logic
Since one Sales Order can produce multiple invoices (due to partial shipments or split fulfillment), the settlement process must be robust.
- **Pattern**: Apply captured payments to open invoices for the same Sales Order.
- **Matching**: The current payment sync writes the D365 `SalesOrderNumber` into `PaymentReference`. Any future settlement flow should be aligned to that identifier unless the mapping is changed.
- **Rule**: Oldest invoice first or exact match based on shipment.

---

## 6. Integration Questions (Discovery)

The following questions should be clarified with the D365 Finance/Functional team:

### 6.1 Legal Entities (dataAreaId)
- Which **Legal Entities (dataAreaId)** are in scope for this integration?
- Should we map these 1-to-1 with HotWax **Product Stores**, or is there a specific organizational hierarchy to follow?

### 6.2 Customer Groups (CustomerGroupId)
- Which **Customer Groups** should be assigned to customers synced from HotWax?
- Will all digital/B2C customers use a single group (e.g., `DEFLT`), or are there multiple groups based on customer categorization?

### 6.3 Financial Configuration
- What is the default **Sales Currency Code** (e.g., USD, EUR) to be used for these customers? Does it vary by legal entity?
- [ ] Can you confirm whether the current environment allows caller-provided `CustomerAccount` values for customer creation?
- [ ] If the target state is **Automatic** numbering with **Manual = No**, when should the connector be updated to stop sending `CustomerAccount`?

---

## 7. Outbound Notifications (D365 -> OMS)

This section is retained as a future-state exploration area. I did not find corresponding outbound event handling implementation in the current `hotwax-d365` connector code reviewed for this pass.

### 7.1 Fulfillment Updates (Packing Slip)
- **D365 Event**: `SalesOrderPackingSlipPostBusinessEvent` (or similar).
- **Trigger**: When a packing slip is posted in D365.
- **OMS Action**: Update shipment status to "Shipped" and record tracking information.

### 7.2 Financial Updates (Invoice)
- **D365 Event**: `SalesOrderInvoicedBusinessEvent`.
- **Trigger**: When a sales order is successfully invoiced.
- **OMS Action**: Capture payment (if not already captured) and mark the order as "Completed."

### 7.3 Integration Pattern
- **Method**: D365 pushes a JSON payload to a Moqui REST endpoint via an HTTPS Webhook or Azure Power Automate.
- **Payload**: Minimal event data (Event ID, Company, SalesOrderNumber) used by Moqui to then pull detailed data via OData if necessary.

> [!TODO]
> Confirm which D365 business events are actually available and intended for use in this project, then document the implementation path separately from the currently shipped connector behavior.
