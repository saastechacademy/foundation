# Dynamics 365 Business Processes

This document captures the business requirements and process flows for the D365 F&O integration.

HotWax acts as an integration adapter to ensure that D365, as the financial system of record, receives clean and sequential transactional data. This includes translating Shopify's complex, compounded exchange orders into distinct records for returns (RMA), exchange credit, and new sales orders.

## 1. Foundational Concepts & System Setup

Before records can be synchronized, the foundational structural context must be established in Dynamics 365.

### 1.1 Multi-Company Structure (dataAreaId) & Legal Entities
- **dataAreaId**: Represents the Legal Entity (Company). 
- **System Bucket**: Every table in D365 is partitioned by this "Company Code." It defines the context for all validation and financial posting.
- **Organization Administration**: Legal entities are managed under the Organization Administration module.
- **Validation**: Fields like Customer group, currency, and posting profiles are validated within the specific company context.

- **Reference**: [Organization administration home page](https://learn.microsoft.com/en-us/dynamics365/fin-ops-core/fin-ops/organization-administration/organization-administration-home-page?context=%2Fdynamics365%2Fcontext%2Ffinance)


### 1.2 Architectural Concept: The Party Model
- **Concept**: A Customer is built on top of a **Party** record in the Global Address Book.
- **Types**: Person and Organization are types of Party.
- **Global Scope**: Parties are global across all legal entities, whereas Customers are specific to a `dataAreaId`.

### 1.3 Number Sequences & Identification (Customer Account)
Number sequences are used in D365 to generate unique identifiers for entities like Customers and Sales Orders. The generation of the `CustomerAccount` is company-specific and controlled entirely by the Number Sequence configuration.

- **Reference**: [Number sequences overview](https://learn.microsoft.com/en-us/dynamics365/fin-ops-core/fin-ops/organization-administration/number-sequence-overview?toc=%2Fdynamics365%2Fretail%2Ftoc.json)

#### 1.3.1 Verifying Configuration
To check the sequence in a specific legal entity (e.g., USMF):
1.  **Navigate to**: `Accounts receivable > Setup > Accounts receivable parameters > Number sequences tab`.
2.  **Locate Reference**: Find the `Customer account` reference to identify the assigned **Number sequence code** (e.g., `Acco_294`).
3.  **Inspect Setup**: Click the code to review key settings:
    - **Scope**: Typically set to **Company** (partitioned by legal entity).
    - **Manual**: 
        - **Yes**: The API/caller must provide the `CustomerAccount`.
        - **No**: D365 auto-generates the ID.
    - **Format**: Defines the structure (e.g., `CUST-######`).

#### 1.3.2 Impact on Integration
The **Manual** flag directly dictates API behavior during a `POST` request:
| Manual Setting | API Behavior |
| :--- | :--- |
| **Yes** | `CustomerAccount` **must** be provided in the payload. |
| **No** | `CustomerAccount` is **auto-generated**; provided IDs are ignored/error. |

> [!IMPORTANT]
> If `Manual = Yes` and the ID is missing, the API returns: *"Field 'Customer account' must be filled in."*

#### 1.3.3 Recommended Strategy
For a clean "System of Record" integration, the recommended configuration is:
- **Scope**: Company
- **Manual**: No (Auto-generate)
- **Continuous**: No (unless legally required)

#### 1.3.4 Sandbox Environment & Initial Phase
> [!NOTE]
> In our **Sandbox environment**, the `Customer account` sequence is currently set to **Manual**. Keeping in mind the initial one-way synchronization strategy, HotWax OMS will provide the `CustomerAccount` (mapped to HotWax `partyId`) in the integration payload.

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
- **Integration Key (Decision)**: For the current one-way sync, it is decided to use the internal HotWax **partyId** as the `CustomerAccount` in D365. This approach will be re-evaluated if requirements change in the future.

### 2.3 Identification Pattern
- **Pattern**: 
    1. OMS pushes customer with the **HotWax Party ID** or **Shopify Customer ID** mapped to the D365 `CustomerAccount` field.
    2. D365 uses the provided ID for record creation. Since HotWax provides the identifier, no sync-back of a D365-generated ID is required.


### 2.4 Minimum Required Fields for Creation
| Field | Purpose | Example (Person) |
| :--- | :--- |:-----------------|
| `dataAreaId` | Legal entity | `dat`            |
| `CustomerAccount` | Customer number | `HW-10090`       |
| `PartyType` | Customer Type | `Person`         |
| `PersonFirstName` | First name | `Gurveen`        |
| `PersonLastName` | Last name | `Bagga`          |
| `CustomerGroupId` | Financial grouping | `30`             |
| `SalesCurrencyCode` | Default currency | `USD`            |

- **Reference**: [Import customers](https://learn.microsoft.com/en-us/dynamics365/guidance/resources/import-customers)

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

Sales orders are created in D365 F&O using the `SalesOrderHeadersV4` and `SalesOrderLinesV3` data entities. 

> **Prerequisite**: A customer record must exist in D365 before a sales order can be created for that customer. Refer to the [Customer Sync](#2-customer-sync) section for more details.

### 3.1 Sales Order Header (`SalesOrderHeadersV4`)

The header captures the primary customer relationship and high-level delivery requirements.

- **Identification**: `SalesOrderNumber` is the unique identifier. Similar to customers, this can be manual or automatic.
- **Customer Association**: 
    - `OrderingCustomerAccountNumber`: The customer who placed the order (OMS `partyId`).
    - `InvoiceCustomerAccountNumber`: The customer who will be billed.
- **Dates**: `RequestedShippingDate` defines the fulfillment deadline.

- **Reference**: [Import sales orders](https://learn.microsoft.com/en-us/dynamics365/guidance/resources/import-sales-orders)

- **Reference**: [Sales order types overview](https://learn.microsoft.com/en-us/dynamics365/supply-chain/sales-marketing/overview-sales-marketing#sales-orders)

### 3.2 Idempotency & Conflict Prevention
To ensure that orders are not duplicated in D365 during retries or partial failures, the integration follows a **Find-or-Create** pattern at both Header and Line levels.

- **Header Level**:
  - **Field**: `CustomersOrderReference`.
  - **Mapping**: Store the HotWax `orderId`.
  - **Process**: Search by `CustomersOrderReference`. If found, use `SalesOrderNumber`.
- **Line Level**:
  - **Process**: Before syncing lines, the service fetches existing lines for the `SalesOrderNumber` via OData.
  - **Logic**: Any line where `LineNumber` (mapped from `orderItemSeqId`) already exists in D365 is skipped.

### 3.3 Transactional Atomicity (OData Limitations)
Standard D365 OData entities (`SalesOrderHeadersV4` and `SalesOrderLinesV3`) **do not support atomic transactions** for combined header/line creation.

> [!WARNING]
> **Risk of Partial Orders**: Each API call (1 Header + N Lines) is committed as a separate transaction in D365. If a line sync fails, the header and previous lines remain in D365.
> **Mitigation**: 
> 1. **Idempotency**: Prevents duplicate headers on retry.
> 2. **Delayed Persistence**: Moqui only marks the order as "Synced" after the final line is successfully acknowledged.

### 3.4 Shipping & Delivery Addresses (Order-Specific)

HotWax OMS sends the shipping address as part of the Sales Order header payload. This allows for transaction-scoped addresses without polluting the Customer Master.

- **Entity**: `SalesOrderHeadersV4`
- **Pattern**: **Order-Specific Addresses**.
    - **Trigger**: Set `IsDeliveryAddressOrderSpecific` to `Yes`.
    - **Effect**: The address is stored in `SalesTable` and linked via `LogisticsLocation` and `LogisticsPostalAddress`, but is **transaction-scoped**. It is not attached to the Customer master party record.
- **Key Fields**:
    - `DeliveryAddressName` (e.g., Customer Name)
    - `DeliveryAddressStreet`, `City`, `StateId`, `ZipCode`, `CountryRegionId`
    - `DeliveryAddressDescription` (e.g., "OMS Ship To")

> [!NOTE]
> In GET responses, `IsDeliveryAddressOrderSpecific` might return "No", but the link to the order-specific address remains correct for fulfillment.

### 3.3 Sales Order Lines (`SalesOrderLinesV3`)

Each line item represents a specific product being sold.

- **Fulfillment Attributes**:
    - `ShippingSiteId` and `ShippingWarehouseId`: Mandatory fields defining the physical source of inventory.
- **Quantities**: `OrderedSalesQuantity` reflects the quantity to fulfill.
- **Pricing**:
    - `SalesPrice`: The unit price before discounts.
    - `LineDiscountAmount`: Any flat discount applied to the line.

---

## 4. Customer Payment Management

Customer payments from HotWax OMS are captured in D365 F&O as **Customer Payment Journals** to allow for financial recording before invoice settlement.

### 4.1 Journal-Based Approach
- **Pattern**: Payment journals are created as unposted drafts via OData.
- **Timing**: Payments are sent to D365 immediately after capture in OMS, which may occur before the Sales Invoice is generated in D365.
- **Entity**: `CustomerPaymentJournalHeaders` and `CustomerPaymentJournalLines`.

### 4.2 Prepayment vs. Standard Payment
- **Standard Payment (On-Account)**:
    - **Setup**: `IsPrepayment = No`.
    - **Behavior**: Creates an "Open Transaction" on the customer account with a `PaymentReference` (mapped to OMS `orderId`).
    - **Pros**: Simpler configuration, less sensitive to tax validation errors during journal posting.
- **Prepayment**:
    - **Setup**: `IsPrepayment = Yes`.
    - **Behavior**: Triggers specific "Prepayment" posting profiles and often requires tax to be inclusive.
    - **Constraint**: More complex to post via OData due to strict tax and profile requirements.

### 4.3 Settlement Strategy
1.  **Creation**: Payment is posted to the customer account "on-account" (unapplied).
2.  **Invoice Generation**: Later, when the order is fulfilled, a Sales Invoice is created.
3.  **Settlement**: A separate process (either D365 batch settlement or custom logic) matches the payment to the invoice using the shared `PaymentReference` or Order ID.

---

## 5. Fulfillment & Invoicing

Fulfillment actions (Picking and Packing) are performed directly within D365 F&O.

### 5.1 Fulfillment Flow
- **Picking and Packing**: These operations are handled in D365.
- **Packing Slip**: Posting a packing slip marks the order as "Delivered."

### 5.2 Invoicing Requirement
- **Custom Logic**: Orders created via OData may not automatically trigger invoicing upon packing slip posting.
- **Requirement**: Implement or trigger invoicing logic within D365 to ensure the Sales Order moves to the "Invoiced" state.

### 5.3 Settlement Logic
Since one Sales Order can produce multiple invoices (due to partial shipments or split fulfillment), the settlement process must be robust.
- **Pattern**: Apply captured payments to open invoices for the same Sales Order.
- **Matching**: Use the shared `orderId` (stored in `PaymentReference` on the payment and as the `SalesOrder` number on the invoice).
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
- [ ] Can you confirm that the **Number Sequence** for "Customer account" is set to **Automatic** with **Manual = No** in the Accounts Receivable parameters?

---

## 7. Outbound Notifications (D365 -> OMS)

To keep HotWax OMS in sync with fulfillment and financial actions performed in D365, the system will use **Business Events** to push updates.

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
