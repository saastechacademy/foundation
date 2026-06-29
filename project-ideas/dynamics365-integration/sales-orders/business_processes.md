# Dynamics 365 Business Processes

This document captures the business requirements and process flows for the D365 F&O integration.

HotWax acts as an integration adapter to ensure that D365, as the financial system of record, receives clean and sequential transactional data. This includes translating Shopify's complex, compounded exchange orders into distinct records for returns (RMA), exchange credit, and new sales orders.

## 1. Foundational Concepts & System Setup

The generic business-process foundations for D365 F&O integration are documented in [business_process_foundations.md](../foundation/business_process_foundations.md).

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

Sales orders are synchronized from HotWax OMS to D365 F&O after prerequisite customer creation. The business process is the same regardless of transport method, but the connector currently supports three separate implementation patterns:
- **OData pattern**: Direct sync using `SalesOrderHeadersV4` and `SalesOrderLinesV3`.
- **DMF / Data Package pattern**: Package-based import using the `Sales orders composite V4` composite entity.
- **Recurring Integrations pattern**: Queue-based enqueue using the same `Sales orders composite V4` composite entity submitted via the D365 Recurring Integrations Scheduler.

> **Prerequisite**: A customer record must exist in D365 before a sales order can be created for that customer. Refer to the [Customer Sync](#2-customer-sync) section for more details.

### 3.1 Business Process Overview

- **Order Selection**: Eligible OMS sales orders are identified for export to D365.
- **Customer Prerequisite**: The bill-to customer is created or verified in D365 before order creation/import.
- **Order Creation**: The sales order header and lines are sent to D365 using OData, DMF, or Recurring Integrations.
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

#### 3.2.3 Recurring Integrations Pattern
This pattern uses the D365 Recurring Integrations Scheduler to enqueue the composite package via a queue endpoint, bypassing the explicit upload step required by the Data Package API.

- **D365 Interface**: D365 Recurring Integrations Scheduler (Queue Connector — `/api/connector/enqueue/{activityId}`)
- **Composite Entity**: Same `Sales orders composite V4` as the DMF pattern
- **Processing Style**: Queue-based enqueue — fire-and-forget; D365 processes the package from an internal queue
- **Status Resolution**: Two-step — Queue Message ID → DMF Execution ID (via `GetExecutionIdByMessageId`) → status (via `GetExecutionSummaryStatus`)
- **Key Advantage over DMF**: Eliminates the Azure Blob upload step; reduces connection overhead; better suited for high-frequency continuous background flows with built-in queue resilience and load throttling
- **Constraint**: No direct execution ID on submission; status resolution requires an extra API hop compared to the DMF pattern.
- **Current Use Case**: High-frequency or continuous background order sync where queue resilience and reduced overhead are preferred.

#### 3.2.4 Pattern Comparison

| Pattern | D365 Interface | Entity Model | Processing Style | Main Constraint |
| :--- | :--- | :--- | :--- | :--- |
| OData | `SalesOrderHeadersV4`, `SalesOrderLinesV3` | Separate header and line entities | Direct request/response | Partial order creation on failure |
| DMF | `Sales orders composite V4` | Composite import package | Batch/asynchronous via Azure Blob upload | Package generation, upload, and import monitoring |
| Recurring Integrations | `Sales orders composite V4` (via Queue Connector) | Composite import package | Queue-based enqueue/asynchronous | Two-step status resolution (Queue MessageId → ExecutionId) |

> [!NOTE]
> Detailed implementation specifics for all three patterns are documented in [implementation_plan.md](implementation_plan.md) and the shared DMF reference at [data_import_package_api.md](../data-package-api/data_import_package_api.md).

### 3.3 Shared Business Rules

The following business rules apply regardless of whether the order is synchronized through OData, DMF, or Recurring Integrations.

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
3.  **Settlement**: The custom `HotWaxAutoPostSettlementService` batch job (D365-side) matches the posted payment to its invoice using `PaymReference = SalesOrderNumber`. OOTB D365 automatic settlement was evaluated and rejected — it settles at customer account level (FIFO by due date) and cannot honor the order-specific payment reference.

> [!NOTE]
> The connector creates unposted payment journal headers and lines. Journal **posting** is handled by a D365 batch job. **Settlement** is handled by the custom `HotWaxAutoPostSettlementService`. For full design, implementation details, and test scenarios see [invoice_settlement.md](./invoice_settlement.md).

---

## 5. Fulfillment

Fulfillment ownership is determined at the order item (line) level. A single sales order can contain lines fulfilled by OMS (stores) and lines fulfilled by D365 (warehouses). Each path sends a different data feed to D365 and triggers packing slip posting through a different mechanism.

```
OMS Brokers Order Items
        │
        ├── Store facility  ──► OMS fulfills ──► OMS sends fulfilled location ──► D365 packing slip batch (HcFulfillmentType = OMS)
        │
        └── Warehouse facility ──► OMS sends brokered location ──► D365 WMS fulfills ──► D365 packing slip (WMS ops)
```

### 5.1 Store Fulfillment (OMS-Side)

Store-fulfilled order items are physically picked, packed, and shipped within OMS. D365 receives the fulfillment result after the fact and posts the packing slip using a batch job.

1. **OMS brokers the order item** to a store facility.
2. **OMS fulfills the order** — pick, pack, ship.
3. **OMS sends the fulfilled location update to D365** via the `HotWax_Import_Fulfilled_Order_Items` data package.
   - Entity: `Sales order lines V3`
   - Fields updated: `SHIPPINGWAREHOUSEID` (the store's D365 warehouse ID from `Facility.externalId`) and `HCFULFILLMENTTYPE = OMS`
   - Prerequisite: `D365_SLS_ORD_NUM` and `D365SalesOrderItemInventoryLotId` must already be resolved in OMS.

> [!NOTE]
> If the order was already brokered to a store when it was first synced to D365, `HcFulfillmentType = OMS` is set on the line at initial order creation time. The fulfilled items feed reinforces this value and adds the final `SHIPPINGWAREHOUSEID`.

4. **D365 posts the packing slip** via an OOTB batch job filtered on the custom field `HcFulfillmentType = OMS`:
   - Navigation: `Sales and marketing > Order shipping > Post packing slip`
   - Query filters: `Sales Order Line HC Fulfillment Type = OMS`, Sales Order status = `Open order, Delivered`
   - Validated — see issue [#15](https://github.com/hotwax/dynamics365-integration/issues/15).
5. The packing slip marks these lines as **Delivered** in D365, making them eligible for the invoice batch.

### 5.2 Warehouse Fulfillment (D365/WMS-Side)

Warehouse-fulfilled order items are handed off to D365 after brokering. D365 owns all physical fulfillment and posts the packing slip as part of its own WMS operations.

1. **OMS brokers the order item** to a warehouse facility that has a D365 warehouse mapping (`Facility.externalId`).
2. **OMS sends the brokered warehouse location to D365** via the `HotWax_Import_Brokered_Order_Items` data package.
   - Entity: `Sales order lines V3`
   - Fields updated: `SHIPPINGWAREHOUSEID` (the final warehouse) and `HCFULFILLMENTTYPE = WMS`
   - Prerequisite: `D365_SLS_ORD_NUM` and `D365SalesOrderItemInventoryLotId` must already be resolved in OMS.

> [!NOTE]
> If the order was already brokered to a warehouse when it was first synced to D365, `HcFulfillmentType = WMS` is set on the line at initial order creation time. The brokered items feed reinforces this value and updates `SHIPPINGWAREHOUSEID` with the final warehouse once brokering is confirmed.
3. **D365 owns all fulfillment from this point** — warehouse staff pick and pack using D365 WMS flows, and D365 posts the packing slip as part of its shipping confirmation process.
4. **D365 pushes shipment data back to OMS** after packing slip posting so OMS can mark the warehouse-fulfilled order items as shipped/completed. See [Section 9 — Outbound Notifications](#9-outbound-notifications-d365---oms) and [shipment_export_exploration.md](./shipment_export_exploration.md).

> [!NOTE]
> Reservation is currently configured as `Manual` in the tested D365 setup (`AR > Parameters > General > Sales default values > Reservation`). Sending the brokered warehouse location does not automatically trigger reservation. Reservation remains an ERP-side operational step performed before warehouse picking begins.

### 5.3 Mixed Cart Handling

A single sales order can contain both store-fulfilled and warehouse-fulfilled lines. Each line is processed independently through its own path.

- OMS sends **two separate data packages**:
  - `HotWax_Import_Brokered_Order_Items` for warehouse-destined lines (after brokering)
  - `HotWax_Import_Fulfilled_Order_Items` for store-fulfilled lines (after OMS fulfillment completes)
- D365 produces **separate packing slips** — one triggered by the HC-fulfillment batch job, one by WMS warehouse operations.
- A single sales order therefore generates **multiple packing slips and multiple invoices**.

For detailed line-level routing and brokering mechanics, see [implementation_plan.md — Section 1.3: Mixed Cart Order Handling](./implementation_plan.md).

---

## 6. Invoicing

### 6.1 Invoice Batch Job

A single OOTB D365 batch job handles invoice posting for all order lines regardless of fulfillment type. It picks up any lines that have reached the **Delivered** state (packing slip posted).

- **Navigation**: `Accounts receivable > Invoices > Batch invoicing > Invoice`
- **Quantity**: `Packing slip` — invoices only the quantities confirmed by packing slip.
- **Late selection**: `Yes` — query re-evaluates at each run, not only at job creation time.
- **Scope**: Covers both OMS-fulfilled lines (packing slip posted by HC batch) and WMS-fulfilled lines (packing slip posted by D365 warehouse operations).
- Validated in issues [#16](https://github.com/hotwax/dynamics365-integration/issues/16) (POS) and [#17](https://github.com/hotwax/dynamics365-integration/issues/17) (HC fulfilled).

> [!NOTE]
> The current invoice batch job has no filter on `HcFulfillmentType` — it picks up all `Delivered` lines. If separate invoicing cadences for store-fulfilled vs. warehouse-fulfilled lines are needed in future, separate batch jobs with distinct query filters can be configured.

### 6.2 Multi-Invoice Scenario

Because packing slips are posted per fulfillment event, a single sales order can produce multiple invoices:

| Scenario | Packing slips | Invoices |
| :--- | :---: | :---: |
| Single shipment, single fulfillment type | 1 | 1 |
| Mixed cart (store + warehouse lines) | 2 | 2 |
| Partial WMS shipments from same warehouse | N (one per shipment) | N |

The settlement service handles all of these cases. See [invoice_settlement.md — Section 5](./invoice_settlement.md) for the multi-invoice settlement design.

---

## 7. Settlement

Since one Sales Order can produce multiple invoices (due to partial shipments or split fulfillment), the settlement process must be robust.

- **Pattern**: Apply captured payments to open invoices for the same Sales Order.
- **Matching**: OMS writes the D365 `SalesOrderNumber` into `PaymentReference` on every payment journal line. The custom settlement service matches on `invoice.SalesId == payment.PaymReference` — explicitly order-scoped, not customer-level FIFO.
- **Rule**: Payment is applied to all open invoices for the matched Sales Order until either the payment is exhausted or all invoices are closed. Partial settlement is supported natively.

> [!NOTE]
> For the complete settlement design — including why OOTB settlement fails, the X++ API used, the multi-payment capping fix, and test scenarios — see [invoice_settlement.md](./invoice_settlement.md).

---

## 8. Integration Questions (Discovery)

The following questions should be clarified with the D365 Finance/Functional team:

### 8.1 Legal Entities (dataAreaId)
- Which **Legal Entities (dataAreaId)** are in scope for this integration?
- Should we map these 1-to-1 with HotWax **Product Stores**, or is there a specific organizational hierarchy to follow?

### 8.2 Customer Groups (CustomerGroupId)
- Which **Customer Groups** should be assigned to customers synced from HotWax?
- Will all digital/B2C customers use a single group (e.g., `DEFLT`), or are there multiple groups based on customer categorization?

### 8.3 Financial Configuration
- What is the default **Sales Currency Code** (e.g., USD, EUR) to be used for these customers? Does it vary by legal entity?
- [ ] Can you confirm whether the current environment allows caller-provided `CustomerAccount` values for customer creation?
- [ ] If the target state is **Automatic** numbering with **Manual = No**, when should the connector be updated to stop sending `CustomerAccount`?

---

## 9. Outbound Notifications (D365 -> OMS)

D365 pushes data back to OMS at two points in the order lifecycle: after warehouse fulfillment completes (mandatory) and after invoice posting (future).

### 9.1 Shipment Sync — WMS-Fulfilled Orders (Mandatory)

After D365 posts the packing slip for warehouse-fulfilled order lines, OMS must receive the shipment data to mark those items as shipped and trigger order completion.

- **Trigger**: Packing slip posted in D365 for lines where `HcFulfillmentType = WMS`.
- **OMS Action**: Create an OMS shipment record with tracking information; mark warehouse-fulfilled order items as shipped/completed.
- **Selected approach**: Custom flat export entity (`OmsPackingSlipExportEntity`) via DMF recurring integration (dequeue/ack).
  - The entity filters on `HcFulfillmentType = WMS` so only warehouse-fulfilled lines are exported, keeping store-fulfilled lines out of this feed.
  - A single flat row includes packing slip header, order line, and tracking data combined — no middleware assembly required.
  - OMS polls the D365 recurring export queue (`dequeue`), groups flat rows by `PackingSlipId + SalesId` to reconstruct the shipment structure, creates OMS shipments, then acknowledges (`ack`) to clear the message from the queue.
- **OMS integration components**: `D365_EXP_PACKING_SLIPS` system message type, `d365_QueuePackingSlipsExport` queue job, `d365_ExportPackingSlipsPoll` poll job, `storeAndCreate#D365OutboundShipments` processing service.

**Approaches Explored**

| Approach | POC Status | Outcome |
| :--- | :--- | :--- |
| Business Event → Logic App | Validated as technically feasible | Not selected |
| Business Event → Azure Service Bus → Azure Function | Validated as technically feasible | Not selected |
| Custom flat entity → DMF recurring export → OMS | **Selected** | Chosen for line-level `HcFulfillmentType` filtering and single-export payload completeness (header + lines + tracking) |

For full D365 entity design, field mappings, and OMS processing logic, see [shipment_export_exploration.md](./shipment_export_exploration.md).
