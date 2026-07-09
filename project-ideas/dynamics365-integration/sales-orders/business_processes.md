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

> [!NOTE]
> **Scope: this only resolves the receivable side of the invoice.** A posted sales invoice is a single voucher with multiple debit/credit lines, and each line's Main Account is chosen by an independent posting-setup rule — Customer Group only controls the first one:
>
> | Line | Main Account | What decides it |
> | :--- | :--- | :--- |
> | Debit (Customer balance) | AR trade account | Customer → Customer Group → **Customer Posting Profile** |
> | Credit (Revenue) | Sales Revenue | Item → Item Group → item posting setup |
> | Credit (Tax) | Sales Tax Payable | Sales Tax Group setup |
> | Debit/Credit (COGS) | COGS / Inventory | Item Group → inventory posting setup |
>
> Revenue, tax, and COGS accounts are **not** affected by which Customer Group a customer belongs to — they're driven entirely by the item and tax configuration. See [Customer posting profiles](https://learn.microsoft.com/dynamics365/finance/accounts-receivable/customer-posting-profiles#posting-examples) (Customer balance posting type), [Posting profiles overview](https://learn.microsoft.com/dynamics365/finance/general-ledger/pstg-prfles-ovrvw#detail-settings-for-a-posting-profile), and [Accounts receivable posting](https://learn.microsoft.com/dynamics365/finance/general-ledger/accts-recvble-posting).

3.  **Default Data**: Beyond accounting, the group also provides defaults for:
    - **Terms of Payment** (e.g., Net 30, Due upon receipt).
    - **Sales Tax Group** (if not overridden on the customer).

#### Mandatory Requirement
- **Scope**: Must exist within the same `dataAreaId`.
- **Validation**: Creation of a customer via OData **will fail** if a valid `CustomerGroupId` is not provided.

### 2.6 Sales Tax Group Risk (Destination-Based Tax)

A **Sales tax group** can be set on the customer group or on the individual customer's **Invoice and delivery** FastTab. If it is set, it takes priority over the shipping/destination address for tax calculation.

- **Risk**: HotWax orders ship to varying addresses nationwide. If `CustomerGroupId 30` (or the customer record itself) carries a default sales tax group, every order could be taxed based on that fixed group instead of the actual delivery address — a silent tax-miscalculation, not a sync failure.
- **Recommendation**: For a B2C/ship-to-many-addresses model, leave **Sales tax group** blank on both the customer group and the customer record so destination-based tax resolves correctly from the order's shipping address.
- **Action**: Verify whether `CustomerGroupId 30` has a default tax group configured in the target environment.

> [!NOTE]
> This is an environment configuration item, not a connector code change — the connector does not currently set `Sales tax group` on customer creation.

- **Reference**: [Configure sales tax for online orders](https://learn.microsoft.com/en-us/dynamics365/commerce/sales-tax-config#customer-account-based-taxes-for-online-orders)

### 2.7 Credit Management Interaction

D365 can block sales order creation, packing slip updates, or invoice posting if a customer's balance and open transactions exceed a configured credit limit. This check can happen at the point the connector creates a sales order via OData or DMF/Recurring Integrations.

- **Risk**: If credit limit checking is enabled for the target environment (via `Credit limit type` in Credit and collections parameters) and `CustomerGroupId 30` does not have **Unlimited credit limit** or **Exclude from credit management** set, `sync#SalesOrders` could fail intermittently for customers near/over their limit — a scenario that looks like a connector defect but is actually a credit hold.
- **Typical B2C pattern**: Since HotWax captures payment at order time rather than extending open terms, the customer group is typically configured with **Unlimited credit limit = Yes** or **Exclude from credit management = Yes**, removing this as a blocking concern.
- **Action**: Confirm with the D365 Finance/Functional team whether credit limit checking is enabled for group `30`, and if so, whether B2C orders should be excluded.

- **References**:
    - [Credit and collections overview](https://learn.microsoft.com/en-us/dynamics365/finance/accounts-receivable/cm-credit-and-collections-overview)
    - [Credit limits for customers](https://learn.microsoft.com/en-us/dynamics365/supply-chain/sales-marketing/credit-limits-customers)

### 2.8 Customer Change Approval Workflow

D365 supports an optional approval workflow for changes to specific customer fields (`Accounts receivable parameters > Customer approval`). If enabled, updates to enabled fields (potentially including `CustomerGroupId` or credit-related fields) via an entity import behave according to one of three configured modes:

- **Allow changes without approval** — the connector's `sync#Customer` updates apply immediately (no impact).
- **Reject changes** — the import fails for workflow-enabled fields.
- **Create change proposals** — the change is staged as a pending proposal and does not take effect until manually approved.

> [!NOTE]
> If this workflow is enabled in the target environment and configured to `Create change proposals`, a `sync#Customer` update could appear to succeed while the actual field change remains pending — not a connector bug. Confirm whether this workflow is enabled before relying on synchronous customer updates.

- **Reference**: [Customer workflow](https://learn.microsoft.com/en-us/dynamics365/finance/accounts-receivable/customer-workflow)

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
- **Navigation (View Synced Order)**: `Accounts receivable > Orders > All sales orders` — search by `CustomersOrderReference` (HotWax `orderId`) or the D365-generated `SalesOrderNumber`.

- **Reference**: [Create sales order invoices](https://learn.microsoft.com/en-us/dynamics365/finance/accounts-receivable/tasks/create-sales-order-invoices) (confirms the `Accounts receivable > Orders > All sales orders` path).

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

> [!NOTE]
> The "V4" in `Sales orders composite V4` is the composite entity's own version number, not the version of its child sub-entities. The composite uses header **V3** and line **V2** child entities — which are distinct from the standalone OData entities used in the OData pattern (`SalesOrderHeadersV4` / `SalesOrderLinesV3`). These child entity versions are defined by the composite entity schema in D365 and cannot be changed independently.

#### Shipping Charge (`SALESORDERHEADERCHARGEV2ENTITY`)

The order's shipping charge is sent as a single header-level charge line, using a hardcoded charges code:

- `FIXEDCHARGEAMOUNT` — the calculated shipping charge amount (defaults to `0` if missing).
- `SALESCHARGECODE` — hardcoded to `'FREIGHT'` in the current implementation. No dynamic lookup/mapping exists.

> [!NOTE]
> Shipping charge sync is currently only possible via the **DMF pattern**. The OData pattern (`SalesOrderHeadersV4` / `SalesOrderLinesV3`) has no header-level charge entity, so shipping charges cannot be synced through that path.

- **Prerequisite**: A `FREIGHT` charges code must already exist in the target D365 environment (`dataAreaId`-scoped) before this pattern can post successfully.
- **Navigation (Setup)**: `Accounts receivable > Charges setup > Charges code`
- **Reference**: [Create charges codes](https://learn.microsoft.com/en-us/dynamics365/finance/accounts-receivable/create-charges-codes)
- **Processing Style**: Batch/package-based import
- **Constraint**: Import processing is asynchronous from the business point of view and requires package submission/orchestration.
- **Current Use Case**: Larger-volume order import and composite payload submission.

#### 3.2.3 Recurring Integrations Pattern
This pattern uses the D365 Recurring Integrations Scheduler to enqueue the composite package via a queue endpoint, bypassing the explicit upload step required by the Data Package API.

- **D365 Interface**: D365 Recurring Integrations Scheduler (Queue Connector — `/api/connector/enqueue/{activityId}`)
- **Composite Entity**: Same `Sales orders composite V4` as the DMF pattern
- **Processing Style**: Queue-based enqueue — fire-and-forget; D365 processes the package from an internal queue
- **Status Resolution**: Two-step — Queue Message ID → DMF Execution ID (via `GetExecutionIdByMessageId`) → status (via `GetExecutionSummaryStatus`)
- **Navigation (Queue/Message Monitoring)**: `System administration` workspace (not the System administration *module*) → **Data Management IT** workspace → **Recurring data job** tab → select the job to open **Manage scheduled data jobs**, which lists queued/processed messages and their status. Useful for support/ops staff checking queue health without calling `GetExecutionIdByMessageId` / `GetExecutionSummaryStatus` directly.
- **Key Advantage over DMF**: Eliminates the Azure Blob upload step; reduces connection overhead; better suited for high-frequency continuous background flows with built-in queue resilience and load throttling
- **Constraint**: No direct execution ID on submission; status resolution requires an extra API hop compared to the DMF pattern.
- **Current Use Case**: High-frequency or continuous background order sync where queue resilience and reduced overhead are preferred.

> [!NOTE]
> **Reference**: [Recurring integrations — Manage recurring data jobs](https://learn.microsoft.com/en-us/dynamics365/fin-ops-core/dev-itpro/data-entities/recurring-integrations#manage-recurring-data-jobs)

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
    - Supplies the same address attributes through the composite header entity (uppercase field names, e.g. `DELIVERYADDRESSNAME`)
- **Key Business Fields** (D365 header field names):
    - `DeliveryAddressName` — recipient name
    - `DeliveryAddressDescription` — hardcoded to `'OMS Ship To'` in the current implementation
    - `DeliveryAddressStreet`
    - `DeliveryAddressCity`
    - `DeliveryAddressStateId`
    - `DeliveryAddressZipCode`
    - `DeliveryAddressCountryRegionId`

> [!NOTE]
> The OData implementation explicitly sets `IsDeliveryAddressOrderSpecific = Yes`. The exact read-back behavior in D365 responses should still be validated in the target environment.

> [!NOTE]
> No `SalesTaxGroup` is set anywhere in this address-building logic, on either the OData or DMF path. This is consistent with (and does not undermine) the destination-based tax recommendation in [2.6 Sales Tax Group Risk](#26-sales-tax-group-risk-destination-based-tax) — as long as the customer/customer-group-level tax group stays blank, this delivery address data has a clear, uncontested path to drive destination-based tax calculation.

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
- **Navigation (View/Manually Post Journal)**: `Accounts receivable > Payments > Customer payment journal`
- **Reference**: [Customer payment overview](https://learn.microsoft.com/en-us/dynamics365/finance/cash-bank-management/tasks/customer-payment-overview)

#### Header/Line Field Defaults

| Field | Value | Note |
| :--- | :--- | :--- |
| `JournalName` | Hardcoded `'OMSPAY'` | **TODO**: Revisit — confirm this should remain a fixed literal rather than be sourced from configuration. |
| `AccountType` | `'Cust'` | Standard/structural value for this journal type — not environment-specific, no revisit needed. |
| `CurrencyCode` | Hardcoded `'USD'` | **TODO**: Revisit alongside the open Sales Currency Code question in [8.3](#83-financial-configuration) — this hardcode affects payments, not just customer creation. |
| `OffsetAccountType` / `OffsetAccountDisplayValue` | Hardcoded `'Bank'` / `'USMF OPER'` | **TODO**: Revisit — the connector code itself flags this gap (`Proper mapping for OffsetAccountDisplayValue based on paymentMethodTypeId`). Every payment currently posts through one fixed bank/clearing account regardless of the customer's actual payment method. |
| Payment Method | OData path sets no payment-method field at all. DMF/Data Package path resolves `PAYMENTMETHODNAME` via `IntegrationTypeMapping`, falling back to hardcoded `'CASH'` if unmapped. | **TODO**: Revisit — align OData and DMF behavior, and confirm the `'CASH'` fallback is acceptable for unmapped payment methods. |

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

- **Navigation (Journal Posting Batch — OOTB)**: `General Ledger > Journal entries > Post journals`, filtered by `Journal type = Customer payment`, `Journal name = OMSPAY`, `Posted = No`, with `Late selection = Yes` and running in the background. Verified working in a dev D365 environment — see [hotwax/hotwax-d365#26](https://github.com/hotwax/hotwax-d365/issues/26).
- **Navigation (Settlement Trigger)**: The custom `HotWaxAutoPostSettlementService` runs as a recurring D365 batch job, accessed from the HotWax custom menu extension → **Auto Post Settlement**. See [invoice_settlement.md](./invoice_settlement.md) for full trigger and configuration details.

> [!NOTE]
> The connector creates unposted payment journal headers and lines. Journal **posting** is handled by a D365 batch job. **Settlement** is handled by the custom `HotWaxAutoPostSettlementService`. For full design, implementation details, and test scenarios see [invoice_settlement.md](./invoice_settlement.md).

---

## 5. Fulfillment

Fulfillment ownership is determined at the order item (line) level. A single sales order can contain lines fulfilled by OMS (stores) and lines fulfilled by D365 (warehouses). Each path sends a different data feed to D365 and triggers packing slip posting through a different mechanism.

> [!NOTE]
> `ShippingWarehouseId` (`SHIPPINGWAREHOUSEID` in DMF) is set to a hardcoded placeholder `'NA'` at initial order creation time, before brokering is known. **TODO**: revisit before production — see [implementation_plan.md](./implementation_plan.md) field mapping tables. The brokered/fulfilled-items feeds documented below (5.1, 5.2) supply the real warehouse once brokering completes.

> [!NOTE]
> **Open verification item**: if an order item's facility isn't mapped into either the WMS-only or OMS fulfillment facility groups, `HcFulfillmentType` is omitted entirely (neither `OMS` nor `WMS`) rather than defaulting to one or erroring. Since the OMS packing-slip batch job (5.1) filters specifically on `HcFulfillmentType = OMS`, such a line would not be picked up by that batch — and it's unconfirmed what happens to it on the D365/WMS side either. Worth confirming facility-mapping completeness before go-live.

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
   - Navigation: `Sales and marketing > Sales Orders > Order shipping > Post Packing Slip`
   - Query filters: `Sales Order Line HC Fulfillment Type = OMS`, Sales Order status = `Open order, Delivered`
   - Navigation (Monitoring/Troubleshooting): `System Administration > Inquiries > Batch Jobs` — find the job, then **Batch Job History** for prior runs, then **Logs > Message Details** for success/failure reasons.
   - Validated — see issue [#15](https://github.com/hotwax/dynamics365-integration/issues/15) and configuration steps in [#14](https://github.com/hotwax/dynamics365-integration/issues/14).
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
> - **Navigation (Reserve Lot)**: On the sales order, `Sales order lines` FastTab → **Inventory** menu → **Reservation** → **Reserve lot**.

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
- **Navigation (Monitoring/Troubleshooting)**: `System Administration > Inquiries > Batch Jobs` — find the job, then **Batch Job History** for prior runs, then **Logs > Message Details** for success/failure reasons.
- OOTB batch capability was validated in issues [#16](https://github.com/hotwax/dynamics365-integration/issues/16) (POS) and [#17](https://github.com/hotwax/dynamics365-integration/issues/17) (HC fulfilled), which originally configured two separately-filtered jobs (`SalesOrigin = POS` and `HcFulfillmentType = OMS`). Per a later decision (see comments on both issues), a **single unfiltered job** is used for now since invoicing should run uniformly for all orders regardless of fulfillment origin. The filtered two-job configuration remains available if distinct invoicing cadences are needed later.

> [!NOTE]
> The current invoice batch job has no filter on `HcFulfillmentType` — it picks up all `Delivered` lines regardless of fulfillment origin, by design. If separate invoicing cadences for store-fulfilled vs. warehouse-fulfilled lines are needed in future, the previously-configured filtered jobs from issues #16/#17 can be reinstated.

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
- **Framing note**: Customer groups are typically segmented by *channel* (e.g., Wholesale, Retail, Internet, Employees), not by individual customer or customer type. For a pure B2C/digital business, this usually collapses to a single group covering all HotWax-synced customers, unless the client's finance team needs distinct GL/tax treatment per channel (e.g., ecommerce vs. marketplace). See [Create a default customer](https://learn.microsoft.com/en-us/dynamics365/commerce/default-customer) for Microsoft's reference customer-group examples.
- Does `CustomerGroupId 30` have a default **Sales tax group** or **credit limit type** configured? (See [2.6](#26-sales-tax-group-risk-destination-based-tax) and [2.7](#27-credit-management-interaction) above.)

### 8.3 Financial Configuration
- What is the default **Sales Currency Code** (e.g., USD, EUR) to be used for these customers? Does it vary by legal entity?
- **Note**: `CurrencyCode` is currently hardcoded to `'USD'` in both customer creation (§2) and payment journal creation (§4.1) — this question applies to both, not just customer sync.
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

### 9.2 Invoice Posting Notification (Future)

Not yet implemented. Preliminary technical exploration exists — see [implementation_plan.md — Outbound Integration (Business Events) TODO](./implementation_plan.md) for the current plan: registering a Moqui REST endpoint, configuring D365 Business Event endpoints, and activating the relevant event (e.g. `SalesOrderInvoicedBusinessEvent`).
