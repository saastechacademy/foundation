# D365 Sales Orders Integration Implementation Plan

This document outlines the technical design and implementation steps for integrating HotWax OMS with Microsoft Dynamics 365 Finance & Operations (D365 F&O).

## Technical Architecture
- Sales-order integration uses the generic D365 connector foundation documented in [connector_foundation.md](../foundation/connector_foundation.md).
- **Sales-order specific interfaces**:
    - OData v4 (REST) for direct entity-based sync
    - Data Management Framework (DMF) / Data Package API for composite package import

---

## Technical Reference: OData Metadata
| Term | Meaning |
| :--- | :--- |
| **EntitySet** | The URL collection or endpoint (e.g., `CustomersV3`). |
| **EntityType** | The schema definition and structure of the data object (e.g., `CustomerV3`). |
| **Key** | Defines the Primary Key fields (e.g., `dataAreaId`, `CustomerAccount`). |
| **Nullable="false"** | Indicates a **Required Field** that cannot be empty. |

---

## Data Model (D365 Specific)
Implementation site: `runtime/component/hotwax-d365/entity/D365OrderEntities.xml`

To track synchronization events, manage retries, and map D365 external identifiers back to Moqui entities without cluttering core tables, we use specific history entities.

### OData Sync History Entities
These entities are used exclusively by the OData near-real-time synchronization flow (`sync#SalesOrders`) to track partial progress and handle retries defensively due to the non-atomic nature of sequential OData REST calls.

#### 1. Order Header History (`D365SalesOrderHeaderHistory`)
Tracks the aggregate order-level OData status and stores the successfully resolved D365 sales order identifier.
- *Reasoning:* Prevents duplicate order header creation in D365 on retry, stores the resulting D365 Sales Order Number, and records detailed execution logs on failure.

```xml
<entity entity-name="D365SalesOrderHeaderHistory" package="co.hotwax.d365.order">
    <field name="orderId" type="id" is-pk="true"/>
    <field name="d365SalesOrderNumber" type="id"/>
    <field name="syncStatusId" type="id" default="D365_ORD_PENDING"/>
    <field name="syncedDate" type="date-time"/>
    <field name="logText" type="text-long"/>
</entity>
```

#### 2. Order Line History (`D365SalesOrderLineHistory`)
Tracks the OData synchronization outcome for individual order items.
- *Reasoning:* Enables granular, retry-safe resumption of interrupted syncs. If an order with 10 lines fails on line 5, the next attempt reads this history to skip lines 1-4 and resume directly at line 5, avoiding duplicate item charges or validation errors in D365.

```xml
<entity entity-name="D365SalesOrderLineHistory" package="co.hotwax.d365.order">
    <field name="orderId" type="id" is-pk="true"/>
    <field name="orderItemSeqId" type="id" is-pk="true"/>
    <field name="d365SalesOrderNumber" type="id"/>
    <field name="syncStatusId" type="id" default="D365_ORD_PENDING"/>
    <field name="syncedDate" type="date-time"/>
    <field name="lastAttemptDate" type="date-time"/>
    <field name="logText" type="text-long"/>
</entity>
```

### DMF / Data Package Sync History Entity
This entity is used by the batch DMF import pattern (`import#SalesOrdersDataPackage`).

#### 3. Data Package Import History (`D365SalesOrderImportHistory`)
- *Reasoning:* Records that an order has been successfully processed, mapped, and bundled into an outgoing ZIP package for D365 Data Management Framework submission. This ensures that packaged orders are immediately removed from the eligibility view (`D365EligibleSalesOrdersDMF`) so they are not bundled into subsequent outgoing packages during polling delays.

```xml
<entity entity-name="D365SalesOrderImportHistory" package="co.hotwax.d365.order">
    <field name="orderSyncHistoryId" type="id" is-pk="true"/>
    <field name="orderId" type="id"/>
    <field name="d365SalesOrderNumber" type="id"/>
    <field name="dataAreaId" type="id"/>
    <field name="createdDate" type="date-time"/>
</entity>
```

---

## Foundation

The generic connector foundation for authentication, credentials storage, legal-entity mapping, token management, and common OData request handling is documented in [connector_foundation.md](../foundation/connector_foundation.md).

This sales-order implementation plan focuses on the sales-order-specific services, entities, views, and orchestration built on top of that shared connector layer.

## Customer Synchronization
### Sync Service Logic (`sync#Customer`)
1. **Remote Lookup**: Call `GET /data/CustomersV3` with `$filter` by `CustomerAccount eq 'HW-partyId'`.
2. **Creation**: If not found, `POST /data/CustomersV3`.
    - Map `'HW-' + partyId` -> `CustomerAccount`.
    - Provide mandatory fields: `dataAreaId`, `PartyType`, `CustomerGroupId`, `SalesCurrencyCode`.
3. **Outcome**: The `HW-partyId` is used directly as the `CustomerAccount` in D365. No local identification record is required.
   - **TODO** Check to send the Shopify Customer Id here, and decide if we should have CustomerAccount field as auto created in D365 or we can continue to send unique identifier from OMS.

### Mapping (`CustomersV3`)
| D365 Field | Moqui Field               | Usage / Notes |
| :--- |:--------------------------| :--- |
| `CustomerAccount` | `'HW-' + partyId`         | Primary identifier in D365. Prefixed with `HW-`. |
| `dataAreaId` | `usmf`                    | Legal entity context. **TODO**: Currently hardcoded to `usmf` for demo; should map to `ProductStore.externalId`. |
| `PersonFirstName` | `Person.firstName`        | Only for `PartyType` = `Person`. |
| `PersonLastName` | `Person.lastName`         | Only for `PartyType` = `Person`. |
| `PrimaryContactEmail`| `ContactMech.infoString` | Joined via `PartyContactMechPurpose` (PRIMARY_EMAIL). |
| `PrimaryContactPhone`| `TelecomNumber`           | Joined via `PartyContactMechPurpose` (PRIMARY_PHONE). Formatted as: `[countryCode] [areaCode] [contactNumber]`. |
| `SalesCurrencyCode` | `ProductStore.defaultCurrencyUomId` | Abbreviation of the default currency UOM for the `ProductStore`. Defaults to `USD` if not found. |
| `CustomerGroupId` | `'30'`                    | **TODO**: Needs discussion. Currently hardcoded to `30` as it's not yet mapped in OMS. |
| `SalesTaxGroup`   | `''` (Empty String)       | **TODO**: Needs mapping. Expected to be something like `AVATAX`. |

### Related Business Risks

The following are business-process-level risks, not field-mapping gaps — full detail lives in `business_processes.md`, not duplicated here:

- **Sales tax group / destination-based tax**: see [business_processes.md §2.6](business_processes.md#26-sales-tax-group-risk-destination-based-tax).
- **Credit management / credit limit blocking**: see [business_processes.md §2.7](business_processes.md#27-credit-management-interaction).
- **Customer change-approval workflow**: see [business_processes.md §2.8](business_processes.md#28-customer-change-approval-workflow).

## Sales Order Flows

### 1. Import of Sales Orders from OMS to D365

This flow covers outbound sales order creation from HotWax OMS into D365.

#### 1.1 Eligible Orders Views

Two separate eligibility views are used so OData and DMF can evolve independently.

- **OData View**: `D365EligibleSalesOrdersOData`
  - Shopify order id exists
  - `D365SalesOrderHeaderHistory` is missing, or header status is not `D365_ORD_SYNCED`
- **DMF View**: `D365EligibleSalesOrdersDMF`
  - Shopify order id exists
  - `D365SalesOrderImportHistory` record is missing

- **Shared aliases**: `orderId`, `partyId` (BILL_TO_CUSTOMER), `productStoreId`, `dataAreaId`

#### 1.2 Supported Import Approaches

The connector currently supports three separate technical approaches for sales order synchronization:

1. **Approach 1.2.1: OData Pattern**
   - Service name: `co.hotwax.d365.D365OrderServices.sync#SalesOrders`
   - D365 model: `SalesOrderHeadersV4` + `SalesOrderLinesV3`
   - Processing style: Direct, request-driven entity sync
   - OMS tracking entity names: `D365SalesOrderHeaderHistory`, `D365SalesOrderLineHistory`

2. **Approach 1.2.2: DMF / Data Package Pattern**
   - Service name: `co.hotwax.d365.D365OrderServices.import#SalesOrdersDataPackage`
   - D365 model: `Sales orders composite V4`
   - Processing style: Package-based batch import via DMF
   - OMS tracking entity name: `D365SalesOrderImportHistory`

3. **Approach 1.2.3: DMF / Recurring Integrations Pattern (Queue-Based Enqueue)**
   - Service name: `co.hotwax.d365.D365RecurringImportServices.queue#RecurringSalesOrders`
   - D365 model: `Sales orders composite V4`
   - Processing style: Queue-based package upload and automatic background import
   - OMS tracking entity name: `D365SalesOrderImportHistory`
##### Comparison: Data Package API vs. Recurring Integrations API

Below is an analytical comparison of the two package-based import and export patterns supported by the connector:

| Feature | Data Package API (Request/Poll) | Recurring Integrations API (Queue-Based) |
| :--- | :--- | :--- |
| **Interface Complexity** | High (Requires multiple sequential API steps: request path, upload, and trigger execution) | Low (Single HTTP POST/GET request directly to/from a dedicated queue endpoint) |
| **Execution Control** | Direct (OMS controls exactly when the import/export execution starts) | Managed (D365 background batch scheduler processes the queue asynchronously) |
| **System Resource Impact** | High (Immediate trigger can lead to locking contentions during high concurrent usage) | Controlled (D365 manages queue ingestion sequentially, preventing load spikes) |
| **Resilience to Downtime** | Low (If the ERP is offline or busy during a request, the transaction fails and requires retries) | High (Queue buffers files during downtime; processing resumes automatically when active) |

*   **Data Package API Suitability:** This pattern is highly direct and provides tight execution synchronization, making it well-suited for ad-hoc, low-frequency, or admin-triggered bulk loads where immediate processing confirmation is the priority.
*   **Recurring Integrations API Suitability:** This pattern reduces connection overhead and provides automated queuing, making it well-suited for high-frequency, continuous background flows where load throttling, server resource safety, and queue resilience are preferred over immediate execution control.

---

##### 1.2.1 OData Import Implementation

##### Current Implementation Summary
This is a fully implemented direct-sync path that creates a sales order header and then creates individual order lines using standard OData entities.

##### Service Flow
1. **Fetch Eligible Orders**: Query the view-entity `D365EligibleSalesOrdersOData`.
2. **Prerequisite Customer Sync**: Call the service `sync#Customer` for the order's `partyId` (via the bill-to customer).
    - *Why:* D365 strictly requires the customer profile to exist in the database (with a valid `CustomerAccount`) before the order header can be successfully created.
    - *Blocking Failure Behavior:* If the `customerAccount` cannot be resolved or created, the sync process blocks subsequent order-creation API calls, updates the local header history to `D365_ORD_ERROR`, logs the failure, and skips the order.
3. **Read/Initialize Local OData History**:
    - **Implicit Header History Lookup:** The `D365SalesOrderHeaderHistory` record is not queried separately; instead, it is read implicitly in Step 1 via the outer-joined view-entity `D365EligibleSalesOrdersOData` (exposing fields like `order.syncStatusId` and `order.d365SalesOrderNumber` if a sync was previously attempted).
    - **Explicit Line History Lookup:** Query the entity `D365SalesOrderLineHistory` for the `orderId` to build a local tracking lookup map (`existingLineHistoryBySeqId`), allowing the service to skip or reconcile individual lines during a retry.
    - **Initialize Execution State:** Write/Update the `D365SalesOrderHeaderHistory` record, marking the current sync attempt status as `D365_ORD_PENDING`.
4. **Prepare Header Context**:
    - Load the view-entity `D365SalesOrderDetail`
    - Normalize state code
    - Build concatenated street address
5. **Idempotent Header Check**:
    - Query `SalesOrderHeadersV4`
    - Filter by `CustomersOrderReference eq '<orderId>'`
    - If found, reuse returned `SalesOrderNumber`
6. **Header Create**:
    - If not found, `POST /data/SalesOrderHeadersV4`
    - Store HotWax `orderId` in `CustomersOrderReference`
7. **Idempotent Line Check**:
    - Query `SalesOrderLinesV3`
    - Filter by `SalesOrderNumber`
    - Collect existing `ExternalItemNumber` values
8. **Line Create**:
    - Iterate eligible order items
    - Skip cancelled items
    - Skip any line already marked `D365_ORD_SYNCED` in line history
    - Reconcile any line already present in D365 into local line history
    - `POST /data/SalesOrderLinesV3` for missing lines
9. **Local Persistence**:
    - Update line history per order item as `D365_ORD_SYNCED` or `D365_ORD_ERROR`
    - Update header history as `D365_ORD_SYNCED`, `D365_ORD_PARTIAL`, or `D365_ORD_ERROR`
    - Only after header reaches `D365_ORD_SYNCED`, create `OrderIdentification` with type `D365_SLS_ORD_NUM`

##### OData Tracking Entities

- **Header history**: `D365SalesOrderHeaderHistory`
  - Tracks aggregate order-level OData status
  - Stores `d365SalesOrderNumber`, `syncStatusId`, `syncedDate`, and `logText`
- **Line history**: `D365SalesOrderLineHistory`
  - Tracks per-line OData result for retry-safe resumption
  - Stores `orderItemSeqId`, `d365SalesOrderNumber`, `syncStatusId`, `syncedDate`, `lastAttemptDate`, and `logText`

##### OData Entity Mappings

###### Header (`SalesOrderHeadersV4`)
| D365 Field | Moqui Field | Usage / Notes |
| :--- | :--- | :--- |
| `dataAreaId` | `order.dataAreaId` | Legal entity context from eligible order view. |
| `CustomersOrderReference` | `OrderHeader.orderId` | OMS order reference used for idempotent lookup. |
| `SalesOrderOriginCode` | `salesChannelEnumId` -> `IntegrationTypeMapping(D365_SALES_CHNL)` | Uses the mapped D365 Sales Origin code. Falls back to `Ecom` if no mapping row exists. |
| `DeliveryModeCode` | Selected `shipmentMethodTypeId` -> `IntegrationTypeMapping(D365_SHP_MTHD)` | Uses the mapped D365 Mode of Delivery. Falls back to `Standard` if no mapping row exists. |
| `OrderingCustomerAccountNumber` | Resolved D365 customer account | Returned by customer sync. |
| `InvoiceCustomerAccountNumber` | Resolved D365 customer account | Same as ordering customer account. |
| `CurrencyCode` | `orderDetail.currencyCode` | Defaults to `USD` if missing. |
| `IsDeliveryAddressOrderSpecific` | Hardcoded `'Yes'` | Uses order-scoped delivery address. |
| `DeliveryAddressName` | `orderDetail.toName` | Ship-to name. |
| `DeliveryAddressDescription` | Hardcoded `'OMS Ship To'` | Fixed value. **TODO**: revisit — confirm whether this should remain a fixed literal or be configurable. |
| `DeliveryAddressStreet` | `address1 + address2` | Concatenated address lines. |
| `DeliveryAddressCity` | `orderDetail.city` | |
| `DeliveryAddressStateId` | Normalized `stateProvinceGeoId` | Strips OMS prefixes when present. |
| `DeliveryAddressZipCode` | `orderDetail.postalCode` | |
| `DeliveryAddressCountryRegionId` | `orderDetail.countryGeoId` | |
| `DefaultShippingWarehouseId` | Hardcoded `'NA'` | Temporary testing value. **TODO**: revisit before production. |
| `Email` | `orderDetail.email` | Contact email on order header. |

###### Line (`SalesOrderLinesV3`)
| D365 Field | Moqui Field | Usage / Notes |
| :--- | :--- | :--- |
| `dataAreaId` | `order.dataAreaId` | Legal entity context. |
| `SalesOrderNumber` | Resolved D365 `SalesOrderNumber` | Linked to created/found header. |
| `ExternalItemNumber` | `orderItemSeqId` | OMS order item sequence id sent as a string and used for idempotency and later line-level reconciliation. |
| `ItemNumber` | Resolved parent product identifier | Current implementation derives this from the OMS parent Shopify product id. **TODO**: confirm final D365 product identifier strategy. |
| `OrderedSalesQuantity` | `item.quantity` | |
| `SalesPrice` | `item.unitPrice` | |
| `LineDiscountAmount` | `getItemDiscountAmount()` | Derived from OMS discounts. |
| `ProductSizeId` | `ProductFeature(SIZE)` | Sent when the OMS item exposes a size feature. |
| `ProductColorId` | `ProductFeature(COLOR)` | Sent when the OMS item exposes a color feature. |
| `shipmentMethodTypeId` | `OrderItemShipGroup.shipmentMethodTypeId` | Used to derive the order-level `DeliveryModeCode`. |
| `ShippingWarehouseId` | `item.shippingWarehouseId` | Populated only when `HcFulfillmentType = WMS`; empty string otherwise. |
| `HcFulfillmentType` | `D365MappingWorker.getHcFulfillmentType(facilityId)` | Set at order creation time if the fulfillment path is already known: `WMS` (facility in `WH_ONLY_FULFILLMENT`), `OMS` (facility in `OMS_FULFILLMENT`), or omitted if not yet brokered. Will be set later by the brokered/fulfilled item update feeds. **Open question**: if a facility is missing from both groups, the field is also omitted — indistinguishable from the "not yet brokered" case. Such a line would be skipped by the packing-slip batch job's `HcFulfillmentType = OMS` filter. Facility-mapping completeness needs to be confirmed, not just brokering timing. |

##### OData Idempotency and Failure Behavior
- **Header idempotency key**: `CustomersOrderReference`
- **Line idempotency key**: `ExternalItemNumber`
- **Failure behavior**: Partial orders are possible because header and lines are separate API calls.
- **Mitigation**:
    - Re-query header before create
    - Re-query existing lines before line POST
    - Persist `D365_SLS_ORD_NUM` only after all lines succeed

##### OData Shipment Method Handling
- The eligible-order view also exposes `isMixCartOrder` so order-level delivery mode can be derived consistently.
- For non-mixed-cart orders, use the first non-empty `shipmentMethodTypeId` from the order items.
- For mixed-cart orders, select the first shipment method that is not:
  - `STOREPICKUP`
  - `POS_COMPLETED`
- If every shipment method is excluded by that rule, fall back to the first non-empty shipment method on the order.
- The selected shipment method is then mapped through `IntegrationTypeMapping(D365_SHP_MTHD)` to populate `DeliveryModeCode`.

##### OData Warehouse / Site Behavior
- **Inventory Site Resolution:** D365 strictly requires the Inventory **Site** dimension for all sales order lines in the tested setup. D365 resolves this mandatory Site context by reading the line-level `ShippingWarehouseId`.
- **Header-Level Cascading Defaults:**
  - If a line is sent *without* `ShippingWarehouseId` (or if it is empty), D365 will automatically cascade the header's `DefaultShippingWarehouseId` down to the line level.
  - **The Error Threshold:** If **both** the header's `DefaultShippingWarehouseId` and the line's `ShippingWarehouseId` are left empty or omitted, F&O has no default to inherit, and it will reject the line with a target validation error similar to:
    ```json
    {
      "message": "Write failed for table row of type 'SalesOrderLineV3Entity'. Infolog: Warning: Inventory dimension Site is mandatory and must consequently be specified.; Error: Update has been canceled.."
    }
    ```
- *Mitigation:* Ensure that either a header-level fallback (e.g. `'NA'`) is passed as the `DefaultShippingWarehouseId` or each individual line carries a valid `ShippingWarehouseId`.

##### OData Inventory Behavior Observation
- Creating a sales order in the tested D365 environment:
  - creates demand
  - does **not** reserve inventory
  - does **not** reduce physical stock
- Inventory is reserved later, when reservation is explicitly performed, for example through the `Reserve Lot` action or another downstream process.
- This means order creation alone is not the commitment step for inventory.
- In the tested setup, reservation is the actual commitment point.
- The current D365 setting in `Accounts receivable > Setup > Accounts receivable parameters > General > Sales default values` is:
  - `Reservation = Manual`
- Based on this setting, OMS should send the intended warehouse/location context to D365, but OMS should not trigger reservation as part of order export.
- Reservation remains an ERP-side operational step and should be handled later in D365 according to warehouse fulfillment workflow.

##### OData TODOs / Gaps
- Confirm the final D365 `ItemNumber` strategy used for OMS parent product identifiers
- Add support for additional D365 variant dimension fields beyond the current size/color handling if required
- Revisit missing header fields such as order date and ship-to phone
- **TODO — Common Shopify Order Id across transaction types:** `CustomersOrderReference` currently carries the OMS internal `orderId`, not the Shopify Order Id (`OrderHeader.externalId`) — these are two different identifiers today. The NetSuite integration for this same OMS sends the Shopify Order Id as a dedicated field (`custbody_hc_shopify_order_id`) on every related transaction — Sales Order, Customer Deposit, RMA, Credit Memo, Exchange Order — giving a single common id to cross-reference all of them. D365 has no equivalent field populated yet. Needs a field decision (new header field on `SalesOrderHeadersV4`, or reuse of an existing free field, TBD) and must be propagated to the corresponding fields on Customer Payment Journal (see `invoice_settlement.md` §9), Return Order/Credit Note/Exchange Order (see `sales-returns/implementation_plan.md` §6, item #20).

##### OData Limitations
- **Lack of Transactional Atomicity (Partial Orders):** Because OData requires separate HTTP requests to sync headers and lines (`1 + N` requests), network drops or validation failures midway can result in incomplete "partial orders" in D365 that require manual cleanup or reconciliation.
- **Header-Level Charge Support:** Standard OData mapping in the current sync path does not support a dedicated header-level charge entity. Consequently, flat checkout shipping fees (such as Freight) cannot be synchronized at the header level via OData, unlike the DMF pattern which utilizes `SALESORDERHEADERCHARGEV2ENTITY`.
- **Performance Overhead:** Sequential OData REST calls for every individual order line create significant network roundtrip latency and API limit consumption. This makes OData less suitable for high-volume sales order exports compared to composite data packages or custom bulk services.

##### OData Sample Requests

###### Customer Creation (`CustomersV3`)
```json
{
  "dataAreaId": "usmf",
  "CustomerAccount": "HW-02",
  "PartyType": "Person",
  "PersonFirstName": "Steve",
  "PersonLastName": "Rogers",
  "CustomerGroupId": "30",
  "SalesCurrencyCode": "USD"
}
```

###### Sales Order Header (`SalesOrderHeadersV4`)
```json
 {
  "dataAreaId": "usmf",
  "CustomersOrderReference": "OMS-12345",
  "OrderingCustomerAccountNumber": "HW-02",
  "InvoiceCustomerAccountNumber": "HW-02",
  "CurrencyCode": "USD",
  "IsDeliveryAddressOrderSpecific": "Yes",
  "DeliveryAddressName": "Steve Rogers",
  "DeliveryAddressDescription": "OMS Ship To",
  "DeliveryAddressStreet": "221B Olive Street",
  "DeliveryAddressCity": "Mountain View",
  "DeliveryAddressStateId": "CA",
  "DeliveryAddressZipCode": "94086",
  "DeliveryAddressCountryRegionId": "USA"
 }
```

###### Sales Order Line (`SalesOrderLinesV3`)
```json
 {
  "dataAreaId": "usmf",
  "SalesOrderNumber": "000891",
  "ExternalItemNumber": "00101",
  "ItemNumber": "SHOPIFY_PARENT_PRODUCT_ID",
  "OrderedSalesQuantity": 1,
  "SalesPrice": 100,
  "LineDiscountAmount": 20,
  "ProductSizeId": "M",
  "ProductColorId": "Blue",
  "ShippingWarehouseId": "13"
 }
```

##### 1.2.2 DMF / Data Package Import Implementation

This section documents two approaches for the DMF / Data Package path:

- **Approach 1**: execution tracking using `SystemMessage` records after the remote D365 trigger call
- **Approach 2**: a Moqui-native `SystemMessage` send lifecycle using `SmsgProduced` -> `SmsgSending` -> `SmsgSent` -> `SmsgConfirmed`

See the shared Data Package API reference: [data_import_package_api.md](../data-package-api/data_import_package_api.md). That document describes only the generic D365 package API services; the sales-order-specific job, packaging, and submission details remain in this implementation plan.

##### Approach 1 - Execution Tracking Using `SystemMessage` Records

###### Summary
This approach builds a `Sales orders composite V4` XML file in memory, wraps it in a DMF package, uploads it to Azure Blob storage, and triggers D365 import automation.

This approach uses `SystemMessage` primarily as an execution-tracking record after the remote D365 API call has already happened. In other words, the `SystemMessage` row is used to persist the returned execution identifier and provide a poll target, but the standard Moqui `SystemMessageType.sendServiceName` flow is not the primary orchestration mechanism for the initial trigger.

This means the pattern is operationally useful, but it behaves more like a lightweight async tracker than a fully native Moqui outgoing message flow.

###### Service Flow
1. **Fetch Eligible Orders**: Query the view-entity `D365EligibleSalesOrdersDMF` with a batch limit.
2. **Create DMF submission tracking record**:
    - Persist the entity `D365SalesOrderImportHistory` during packaging so the same order is not packaged again immediately
3. **Customer Sync**: Create or verify customers synchronously via OData before packaging orders.
4. **Load Order Context**:
    - Load the view-entity `D365SalesOrderDetail`
    - Load non-cancelled records from the view-entity `D365SalesOrderItemDetail`
    - Compute shipping charge amount
5. **Build Composite Payload**:
    - Create header map for `SALESORDERHEADERV3ENTITY`
    - Create line maps for `SALESORDERLINEV2ENTITY`
    - Create charge map for `SALESORDERHEADERCHARGEV2ENTITY`
6. **Create XML**:
    - Generate `Sales orders composite V4.xml`
    - Nest lines and charges under each header record
7. **Create Package Metadata**:
    - Generate `Manifest.xml`
    - Generate `PackageHeader.xml`
    - These additional documents are used when importing to add the data files to the correct data entities and sequence the import process.
    - PackageHeader contains information about definition group and manifest contains information (metadata mapping,entity sequence,entity name etc.) for entities.
8. **Create ZIP Package**:
    - Bundle XML + manifests into a single ZIP in memory
9. **Obtain Upload URL**:
    - Call the `GetAzureWriteUrl` API
10. **Upload Package**:
    - PUT the ZIP file to Azure Blob storage
11. **Trigger Import**:
    - Call the `ImportFromPackage` API with `definitionGroupId` and `BlobId`
12. **Persist Execution Tracking**:
    - After D365 accepts the package and returns `executionId`, create a `SystemMessage` entity record in `SmsgSent` with `remoteMessageId = executionId`
    - Poll later using the generic import-status services
13. **Local Persistence**:
    - The entity `D365SalesOrderImportHistory` remains the DMF submission marker
    - Final mapping back to the entity `OrderIdentification` is handled asynchronously by the sales order header export flow described in section 2

###### Why this design feels transitional
- The remote D365 import trigger has already been executed before the `SystemMessage` entity record is queued.
- `queue#SystemMessage(sendNow=false)` is therefore used mainly as durable tracking state, not as a true outgoing send pipeline.
- The `SystemMessageType` exists and categorizes the flow, but its `sendServiceName` is not the primary initiator of the remote work.
- This is functionally valid, but it does not fully align with the usual Moqui pattern where a produced outgoing message is later sent by `send#ProducedSystemMessage`.

###### Programmatic Error Retrieval & Pipeline Behavior

Both the Data Package API and the Recurring Integrations API run on the exact same underlying D365 Data Management Framework (DMF) pipeline. Staging table validation errors *can* be successfully retrieved programmatically via `/data/DataManagementDefinitionGroups/Microsoft.Dynamics.DataEntities.GetExecutionErrors`, but the results depend strictly on the **point of failure** inside the F&O pipeline:

1. **Phase 1: File/Source $\rightarrow$ Staging Table Validation (Fully Queryable)**
   - *Behavior:* DMF successfully parses the zipped XML and populates the staging tables (e.g. `SalesOrderHeaderV3Staging`). If standard data constraints fail (e.g., variant color not assigned to a product store, mandatory warehouse missing but tags are present), F&O writes these errors to the staging log.
   - *Programmatic Visibility:* Calling `GetExecutionErrors` returns a detailed JSON array of line-level validation errors (e.g. item color/warehouse issues).

2. **Phase 2: Staging $\rightarrow$ Target Table Write (Conditional Visibility)**
   - *Behavior:* DMF tries to write validated staging rows to the ledger tables. F&O executes business logic checking (e.g., customer credit limits).
   - *Programmatic Visibility:* If the ledger validation propagates logs to the staging error table, they appear in the OData response. If they are stored only in F&O's global System InfoLog, `GetExecutionErrors` may return an empty list.

3. **Phase 0: Import Engine & Schema Mismatches (Returns Empty)**
   - *Behavior:* The D365 Import Engine performs strict mapping validations. If you omit a mapped XML element entirely from your payload (e.g. removing `SHIPPINGWAREHOUSEID` from the XML lines entirely when it is mapped in the data project), the Import Engine crashes immediately during file ingestion:
     `Exception from HRESULT: 0xC0010009 ... '0' records inserted in staging.`
   - *Programmatic Visibility:* Because the Import Engine crashed before inserting any data, **no staging error logs exist** in the database. Consequently, the OData `GetExecutionErrors` API returns a completely empty list.

4. **Staging Clean-up Purge Rules (Returns Empty)**
   - *Behavior:* D365 standard periodic jobs run "Staging clean-up" batches to delete staging rows and their logs to avoid database bloat.
   - *Programmatic Visibility:* Once this clean-up job purges a historical execution's staging table data, `GetExecutionErrors` will return empty.

*Integration Rule:* OMS status checkers must poll and log errors immediately upon discovering a `Failed` or `Canceled` status. If the error list is returned empty, OMS should record a fallback warning: *"D365 job failed, but no staging log errors were returned. This indicates an import engine schema mismatch, a framework-level history key collision, or that the logs were already purged."*

2. **Batch Outcome Ambiguity (Partially Succeeded Batches):**
   - *The Problem:* D365 imports are batch-oriented. If a batch of 100 orders contains 5 failures, D365 returns the execution status `PartiallySucceeded`. If the poller immediately marks that `SystemMessage` as `SmsgConfirmed`, those 5 failed orders will get lost in a "limbo" state in OMS because they are marked with `D365SalesOrderImportHistory` and cannot be re-packaged.
   - *Proposed Solution (TODO - Option B: Reconciliation via Export):* To prevent limbo states without resorting to complex line-level API log parsing, decouple the import package poller from final order sync confirmation. 
    
    This approach introduces a relational link by adding the field `systemMessageId` directly to the `D365SalesOrderImportHistory` entity to associate each order in a batch with its outgoing `SystemMessage` record.
    
    **Duplicate Order Prevention & Reconciliation Sequence Example:**
    
    1. **Packaging & Locking State:**
       - The exporter service prepares a batch of 100 orders and creates a `SystemMessage` (e.g., `systemMessageId = "10050"`) in `SmsgProduced` status.
       - It writes records to `D365SalesOrderImportHistory` for all 100 orders, linking them to `systemMessageId = "10050"`.
       - These 100 orders are immediately **excluded** from `D365EligibleSalesOrdersDMF`, locking them so they cannot be duplicate-packaged.
       - Moqui triggers the import and updates the tracking `SystemMessage("10050")` status to `SmsgSent` while D365 processes the batch.
       
    2. **The Safety Lock (While Import is In-Flight):**
       - If the D365 import takes a long time, `SystemMessage("10050")` remains in `SmsgSent` status.
       - When the **OMS Reconciliation Job** runs, it scans history records, joining `D365SalesOrderImportHistory` with `SystemMessage` on `systemMessageId`.
       - It detects that `SystemMessage("10050")` status is still **`SmsgSent`** (in-flight).
       - **Action:** The job **ignores and skips** these records. Their history markers are left intact, preserving the lock. **Result: Duplicate order creation is completely prevented while the batch is in flight.**
       
    3. **Resolving Closed Batches (Reconciliation Phase):**
       - Once the D365 batch finishes execution, the poller updates `SystemMessage("10050")` status to a finished state. The Reconciliation Job evaluates:
         - **Scenario A (Full Batch Failure - `SmsgError`):** The job sees the parent batch is closed as failed. Since there is no risk of these orders succeeding, it **deletes** the `D365SalesOrderImportHistory` records for all 100 orders, safely releasing them back to the eligibility view for retry.
         - **Scenario B (Partial Batch Success - `SmsgConfirmed`):** The job sees `statusId = "SmsgConfirmed"`. It left-joins with `OrderIdentification`:
           - For the **95 successful orders** (which received their `D365_SLS_ORD_NUM` identifier from D365's header export), the job does **nothing** (keeps them locked).
           - For the **5 failed orders** (which have no `D365_SLS_ORD_NUM` identification in OMS), the job **deletes** their `D365SalesOrderImportHistory` records, releasing only the failed items back to the eligibility view for retry.

###### Example Tracking Record Shape

In this approach, the effective tracking payload is close to:

```json
{
  "systemMessageTypeId": "D365_IMP_SLS_ORDERS",
  "systemMessageRemoteId": "D365_HotWax_Sandbox",
  "statusId": "SmsgSent",
  "isOutgoing": "Y",
  "remoteMessageId": "HotWax_Import_SalesOrders_Composite-2026-05-04T07:14:36-E7A474D0BE854F79860E65F451DC221F" //D365 executionId returned by ImportFromPackage
}
```

The key point is that `remoteMessageId` is the execution-id storage field.

##### Approach 2 - Moqui-Native `SystemMessage` Send Flow

###### Summary
This approach uses a single outgoing `SystemMessageType` and maps the D365 DMF lifecycle onto native Moqui `SystemMessage` statuses:

- `SmsgProduced`: export/import request has been queued locally
- `SmsgSending`: the configured `sendServiceName` is currently triggering the remote D365 package API
- `SmsgSent`: D365 accepted the request and returned an execution id
- `SmsgConfirmed`: OMS later confirmed that D365 finished successfully and OMS completed its follow-up processing

This design treats the `SystemMessage` entity as the canonical record of one remote D365 package execution from initial queueing through final confirmation.

###### Status Flow

The intended lifecycle is:

```json
{
  "statusFlow": [
    "SmsgProduced",
    "SmsgSending",
    "SmsgSent",
    "SmsgConfirmed"
  ]
}
```

This is valid against the Moqui `SystemMessage` status transitions:
- `SmsgProduced -> SmsgSending`
- `SmsgSending -> SmsgSent`
- `SmsgSent -> SmsgConfirmed`

###### Proposed Processing Flow
1. **Producer Job**:
    - Create one outgoing `SystemMessage` entity record in `SmsgProduced`
    - Set `sendNow = false`
    - Store all D365 trigger metadata needed by the send and poll stages
2. **Send Job**:
    - Run `org.moqui.impl.SystemMessageServices.send#AllProducedSystemMessages`
    - This invokes `SystemMessageType.sendServiceName`
3. **Configured Send Service**:
    - Load the `SystemMessage` entity record by `systemMessageId`
    - Read package metadata from `messageText`
    - Trigger the remote D365 package API
    - Return `remoteMessageId = executionId`
4. **Framework Status Update**:
    - Moqui updates the message from `SmsgSending` to `SmsgSent`
    - The returned D365 `executionId` is stored in `remoteMessageId`
5. **Poll/Confirm Job**:
    - A custom scheduled service reads messages in `SmsgSent`
    - Use `remoteMessageId` as the D365 `executionId`
    - Check completion status in D365
6. **Confirmation Processing**:
    - If still running, leave the message in `SmsgSent`
    - If successful, complete the downstream OMS follow-up work and update the message to `SmsgConfirmed`
    - If unrecoverable, update the message to `SmsgError`

###### Why this design is stronger
- It uses `sendServiceName` for the actual remote trigger, which matches the Moqui outgoing message model.
- `remoteMessageId` becomes the natural home for the D365 `executionId`.
- `SmsgSent` gets a precise meaning: D365 accepted the request, but OMS has not yet confirmed remote completion.
- `SmsgConfirmed` gets a precise meaning: remote execution completed successfully and OMS completed the follow-up processing.
- The trigger phase benefits from the standard Moqui send/retry lifecycle for messages in `SmsgProduced` / `SmsgError`.

###### Proposed `SystemMessage` Shape

The queued message should carry all metadata needed for the send and confirm phases. One reasonable shape is:

```json
{
  "systemMessageTypeId": "D365_IMP_SLS_ORDERS",
  "systemMessageRemoteId": "D365_HotWax_Sandbox",
  "statusId": "SmsgProduced",
  "isOutgoing": "Y",
  "messageText": {
    "definitionGroupId": "HotWax_Import_SalesOrders_Composite",
    "packageName": "Sales orders composite V4",
    "legalEntityId": "USMF",
    "fileName": "Sales orders composite V4.xml"
  },
  "remoteMessageId": null
}
```

After the send service succeeds, the same message would effectively look like:

```json
{
  "systemMessageTypeId": "D365_IMP_SLS_ORDERS",
  "systemMessageRemoteId": "D365_HotWax_Sandbox",
  "statusId": "SmsgSent",
  "isOutgoing": "Y",
  "messageText": {
    "definitionGroupId": "HotWax_Import_SalesOrders_Composite",
    "packageName": "Sales orders composite V4",
    "legalEntityId": "USMF",
    "fileName": "Sales orders composite V4.xml"
  },
  "remoteMessageId": "D365 executionId returned by ImportFromPackage"
}
```

After OMS confirms the remote execution and completes follow-up processing, the message would move to:

```json
{
  "systemMessageTypeId": "D365_IMP_SLS_ORDERS",
  "systemMessageRemoteId": "D365_HotWax_Sandbox",
  "statusId": "SmsgConfirmed",
  "isOutgoing": "Y",
  "remoteMessageId": "D365 executionId returned by ImportFromPackage"
}
```

###### Responsibilities by Field
- `systemMessageTypeId`: identifies the integration stream
- `systemMessageRemoteId`: identifies the D365 remote configuration
- `messageText`: stores the business metadata needed to trigger and later confirm the request
- `remoteMessageId`: stores the D365 `executionId`

###### Design Trade-offs
- This design is cleaner from a Moqui messaging perspective.
- It still needs a dedicated confirmation/poll job for messages already in `SmsgSent`, because `send#AllProducedSystemMessages` only handles `SmsgProduced`.
- The proposed pattern is therefore:
  - standard Moqui send/retry for the initial trigger
  - custom scheduled confirmation loop for the remote completion phase

###### Decision Note
- We started with **Approach 1**, which helped validate the D365 DMF packaging, upload, and execution-tracking mechanics.
- We will proceed with **Approach 2** for the next iteration so that the design aligns more closely with native Moqui `SystemMessage` semantics and gives clearer meaning to the statuses `SmsgProduced`, `SmsgSending`, `SmsgSent`, and `SmsgConfirmed`.

##### DMF Composite Entity Mappings

###### Header (`SALESORDERHEADERV3ENTITY`)
| XML Attribute | Mapping from OMS | Usage / Notes |
| :--- | :--- | :--- |
| `CUSTOMERSORDERREFERENCE` | `orderId` | OMS order reference. |
| `SALESORDERORIGINCODE` | `salesChannelEnumId` -> `IntegrationTypeMapping(D365_SALES_CHNL)` | Uses the mapped D365 Sales Origin code. Falls back to `Ecom` if no mapping row exists. |
| `DELIVERYMODECODE` | Selected `shipmentMethodTypeId` -> `IntegrationTypeMapping(D365_SHP_MTHD)` | Uses the mapped D365 Mode of Delivery. Falls back to `Standard` if no mapping row exists. |
| `ORDERINGCUSTOMERACCOUNTNUMBER` | Resolved D365 customer account | Returned by customer sync. |
| `INVOICECUSTOMERACCOUNTNUMBER` | Resolved D365 customer account | Same as ordering customer account. |
| `CURRENCYCODE` | `orderDetail.currencyCode` | Defaults to `USD`. |
| `DELIVERYADDRESSNAME` | `orderDetail.toName` | |
| `DELIVERYADDRESSDESCRIPTION` | Hardcoded `'OMS Ship To'` | Fixed value. **TODO**: revisit — confirm whether this should remain a fixed literal or be configurable. |
| `DELIVERYADDRESSSTREET` | `address1 + address2` | Concatenated address. |
| `DELIVERYADDRESSCITY` | `orderDetail.city` | |
| `DELIVERYADDRESSSTATEID` | Normalized `stateProvinceGeoId` | |
| `DELIVERYADDRESSZIPCODE` | `orderDetail.postalCode` | |
| `DELIVERYADDRESSCOUNTRYREGIONID` | `orderDetail.countryGeoId` | |
| `DEFAULTSHIPPINGWAREHOUSEID` | Hardcoded `'NA'` | Temporary testing value. **TODO**: revisit before production. |
| `EMAIL` | `orderDetail.email` | |

###### Line (`SALESORDERLINEV2ENTITY`)
| XML Attribute | Mapping from OMS | Usage / Notes |
| :--- | :--- | :--- |
| `ITEMNUMBER` | D365 item number / resolved parent product identifier | **TODO**: strict D365 product mapping needed. |
| `EXTERNALITEMNUMBER` | `orderItemSeqId` | OMS order item sequence id sent as a string, preserving values such as `00101` for later line-level reconciliation. |
| `LINEDISCOUNTAMOUNT` | Item discount amount | Computed from OMS adjustments. |
| `LINENUMBER` | Not sent by OMS in the current DMF payload | D365 exposes this as decimal and should not be used to preserve OMS order item sequence ids with leading zeros. |
| `ORDEREDSALESQUANTITY` | `quantity` | |
| `SALESPRICE` | `unitPrice` | |
| `PRODUCTSIZEID` | `ProductFeature(SIZE)` | Sent when the OMS item exposes a size feature. |
| `PRODUCTCOLORID` | `ProductFeature(COLOR)` | Sent when the OMS item exposes a color feature. |
| `shipmentMethodTypeId` | `OrderItemShipGroup.shipmentMethodTypeId` | Used to derive the order-level `DELIVERYMODECODE`. |
| `SHIPPINGWAREHOUSEID` | `shippingWarehouseId` | Populated only when `HCFULFILLMENTTYPE = WMS`; empty string otherwise. |
| `HCFULFILLMENTTYPE` | `D365MappingWorker.getHcFulfillmentType(facilityId)` | Set at order creation time if the fulfillment path is already known: `WMS` (facility in `WH_ONLY_FULFILLMENT`), `OMS` (facility in `OMS_FULFILLMENT`), or omitted if not yet brokered. Will be set later by the brokered/fulfilled item update feeds. **Open question**: if a facility is missing from both groups, the field is also omitted — indistinguishable from the "not yet brokered" case. Such a line would be skipped by the packing-slip batch job's `HcFulfillmentType = OMS` filter. Facility-mapping completeness needs to be confirmed, not just brokering timing. |

###### DMF Shipment Method Handling
- The eligible-order view also exposes `isMixCartOrder` so order-level delivery mode can be derived consistently.
- For non-mixed-cart orders, use the first non-empty `shipmentMethodTypeId` from the order items.
- For mixed-cart orders, select the first shipment method that is not:
  - `STOREPICKUP`
  - `POS_COMPLETED`
- If every shipment method is excluded by that rule, fall back to the first non-empty shipment method on the order.
- The selected shipment method is then mapped through `IntegrationTypeMapping(D365_SHP_MTHD)` to populate `DELIVERYMODECODE`.

###### DMF Warehouse / Site Behavior
- **Cascading Header Warehouse Default:** Similar to OData, F&O's DMF uses cascading defaults. If an order line `SALESORDERLINEV2ENTITY` is imported without `SHIPPINGWAREHOUSEID` (or if the attribute is empty), the DMF import engine automatically inherits the `DEFAULTSHIPPINGWAREHOUSEID` mapped on the header `SALESORDERHEADERV3ENTITY`.
- **System Failure Scenario:** If **both** the header `DEFAULTSHIPPINGWAREHOUSEID` and the line `SHIPPINGWAREHOUSEID` are empty or omitted, the DMF import will fail during the target table writing phase with the same validation crash:
  `Inventory dimension Site is mandatory and must consequently be specified.`
- *Mitigation:* Ensure that a standard warehouse default (such as `'NA'`) is mapped on the composite header to protect lines from crashing if they are sent without a specific warehouse context.

###### DMF Inventory Behavior Observation
- In the tested D365 setup, importing the sales order does not itself reserve inventory.
- Inventory remains available until reservation is performed later, for example through `Reserve Lot` or another reservation process.
- This means a warehouse placeholder strategy is operationally possible as long as final warehouse reassignment happens before reservation.
- The current D365 setting in `Accounts receivable > Setup > Accounts receivable parameters > General > Sales default values` is:
  - `Reservation = Manual`
- Based on this setting, OMS should communicate warehouse/location to D365, while reservation timing and execution remain part of ERP-side fulfillment processing.

###### Header Charge (`SALESORDERHEADERCHARGEV2ENTITY`)
| XML Attribute | Mapping from OMS | Usage / Notes |
| :--- | :--- | :--- |
| `FIXEDCHARGEAMOUNT` | Calculated shipping charge | Defaults to `0` if missing. |
| `SALESCHARGECODE` | Hardcoded `'FREIGHT'` | Fixed value in current implementation. **TODO**: revisit — confirm this should remain a fixed literal rather than be sourced from configuration; also confirm a `FREIGHT` charges code exists in the target D365 environment (`Accounts receivable > Charges setup > Charges code`). |

##### DMF Package and Import Details
- **Generated files**:
    - `Sales orders composite V4.xml`
    - `Manifest.xml`
    - `PackageHeader.xml`
- **Definition group**: Defaults to `HotWax_Import_SalesOrders_Composite`
- **D365 actions used**:
    - `GetAzureWriteUrl` API
    - `ImportFromPackage` API
- **Import behavior**:
    - Batch-oriented
    - Asynchronous from OMS perspective
    - Requires downstream monitoring / result correlation

##### Poll Sales Order Import Package Status
- **Job**: `d365_PollSalesOrderImportStatus`
- **Service**: `co.hotwax.d365.D365DataPackageServices.poll#ImportDataPackageStatus`
- **System message type**: `D365_IMP_SLS_ORDERS`
- **Purpose**: Poll D365 for the execution status of sales order import packages submitted by `d365_ImportSalesOrders`.
- **Execution id source**: The current sales-order import flow stores the D365 execution id returned by `ImportFromPackage` in `SystemMessage.remoteMessageId`.
- **Polling behavior**:
    - The import service creates a tracking `SystemMessage` in `SmsgSent` only after D365 accepts `ImportFromPackage` and returns `executionId`.
    - The poll job reads `D365_IMP_SLS_ORDERS` `SystemMessage` records in `SmsgSent`.
    - It applies `retryMinutes` / `limit` filtering through the shared poll service, using `lastAttemptDate` to space out retries.
    - For each eligible record, it calls `check#ImportDataPackageStatus` in its own transaction.
    - The checker calls D365 `GetExecutionSummaryStatus`.
    - If D365 returns `Succeeded` or `PartiallySucceeded`, the current implementation moves the `SystemMessage` to `SmsgConfirmed`.
    - If D365 returns `Failed`, `Unknown`, or `Canceled`, the checker calls `get#ExecutionErrors` and then moves the `SystemMessage` to `SmsgError`.
- **Current limitation**: For the Sales Orders Data Package import using the `Sales orders composite V4` composite entity, D365 can return `Failed` from `GetExecutionSummaryStatus`, but `GetExecutionErrors` does not return detailed execution errors through the API.
- **Operational handling for now**: If a sales order import package fails, OMS records the failed state by moving the `SystemMessage` to `SmsgError`; the detailed import errors may need to be checked manually in D365 Data Management until API-based retrieval is figured out.
- **TODO**: revisit failed sales order import error retrieval and confirm whether another D365 API, exported log, or DMF artifact can provide the detailed execution errors for composite entity imports.

For generic package upload/import mechanics and API sequencing, refer to [data_import_package_api.md](../data-package-api/data_import_package_api.md).

##### DMF TODOs / Gaps
- Resolve `ITEMNUMBER` from OMS-to-D365 product mapping
- Add support for additional D365 variant dimension fields beyond the current size/color handling if required
- Validate whether shipping charge handling through `SALESORDERHEADERCHARGEV2ENTITY` is sufficient for all order scenarios

##### 1.2.3 DMF / Recurring Integrations Pattern (Queue-Based Enqueue) [POC IMPLEMENTED]

This approach wraps the hierarchical `Sales orders composite V4` package and sends it directly via the **D365 Recurring Integrations Enqueue API**, streamlining the transmission and solving programmatic error visibility for composite entities.

###### POC Component Configuration

* **Outgoing `SystemMessageType`**: `D365_REC_IMP_SLS_ORDERS`
* **Scheduled Service Jobs**:
  * `d365_QueueRecurringSalesOrders` (schedules the queuing service with `sendNow="true"`)
  * `d365_PollRecurringSalesOrdersImportStatus` (orchestrates background polling)

###### Detailed Service Flow

1. **The Queue Job (`queue#RecurringSalesOrders`):**
   - Queries the eligible order lines using the `D365EligibleSalesOrdersDMF` view.
   - Compiles a standard hierarchical XML file containing `SALESORDERHEADERV3ENTITY`, `SALESORDERLINEV2ENTITY`, and `SALESORDERHEADERCHARGEV2ENTITY` elements.
   - Generates the matching `Manifest.xml` and `PackageHeader.xml` package schemas.
   - Compresses these items in memory into a ZIP package byte-stream.
   - **Database Size Safety Rule:** Caches the binary ZIP file directly onto the local filesystem under `runtime/tmp/d365_recurring_import/` and only saves its absolute path, definition group, and activity ID inside a lightweight JSON metadata string in the database `SystemMessage.messageText` field, preventing database record bloat.
   - Persists execution markers to `D365SalesOrderImportHistory` so packaged orders are removed from eligibility immediately.
   - Queues a `SystemMessage` record in `SmsgProduced` status.

2. **The Send Service (`send#RecurringSalesOrderImport`):**
   - Invoked dynamically by the framework because `sendNow="true"` is enabled.
   - Resolves the Azure AD OAuth access token.
   - Reads the binary cached ZIP package from the filesystem.
   - **Binary Transmission Safety:** Uses standard Java `HttpURLConnection` to execute a direct binary `POST` payload transfer to the D365 Enqueuer endpoint (`/api/connector/enqueue/<activity-id>`) with `Content-Type: application/zip`, bypassing the Moqui `RestClient` limitation (which lacks binary-stream body method helpers).
   - Receives the D365 **Queue Message ID GUID** response, parses it cleanly to standard UTF-8 string format, deletes the temporary file from the disk to free up space, persists the Queue GUID directly to the `messageId` field in the database, returns it as `remoteMessageId` for initial status tracking, and moves the status to `SmsgSent`.

3. **The Poller Orchestration (`poll#RecurringSalesOrderImport`):**
   - Regularly finds all `D365_REC_IMP_SLS_ORDERS` messages in the `SmsgSent` state.
   - Loops and triggers the custom status checker (`check#RecurringSalesOrderImport`) in individual transactions.

4. **The Custom Status Checker (`check#RecurringSalesOrderImport`):**
   - Extracts the enqueued Queue Message ID GUID from `SystemMessage.messageId`.
   - **Bypass Resolution if Already Resolved:** If `SystemMessage.remoteMessageId` is present and does not equal `messageId`, it indicates the DMF Execution ID has already been resolved. The checker bypasses the OData lookup entirely and directly delegates checking to the standard package status service.
   - **OData Execution ID Lookup:** If not yet resolved, it sends a POST request to OData action `/data/DataManagementDefinitionGroups/Microsoft.Dynamics.DataEntities.GetExecutionIdByMessageId` with payload `{"_messageId": "<messageId>"}`.
   - **Handling Queue Delays:** If D365 has not yet scheduled/processed the queue item, it returns the empty GUID `'00000000-0000-0000-0000-000000000000'`. The service logs this pending status, updates the `lastAttemptDate` to space out subsequent checks, and returns early keeping the message in `SmsgSent` status.
   - **DMF Delegation:** If a valid non-zero DMF Execution ID GUID is returned, the checker dynamically updates `SystemMessage.remoteMessageId` to this Execution ID in the database and immediately delegates downstream checking to the standard package status service:
     `co.hotwax.d365.D365DataPackageServices.check#ImportDataPackageStatus`

5. **Detailed Error Resolution:**
   - Programmatic error retrieval is fully supported across all package-based DMF integration patterns, utilizing OData action `/data/DataManagementDefinitionGroups/Microsoft.Dynamics.DataEntities.GetExecutionErrors`.
   - If the delegated checker discovers that the DMF Execution ID has failed (`GetExecutionSummaryStatus` returns `Failed`, `Unknown`, or `Canceled`), it invokes the standard execution error retriever service to pull raw staging log rows.
   - It parses the detailed JSON list of record/field validation failures (e.g. variant configuration or site/warehouse issues), prints them to Moqui logs, and transitions the tracking status to `SmsgError`.
   - **Fallback for Schema/System Crashes:** If the status is `Failed` but the staging error list is returned empty, it indicates a Phase 0 file schema mismatch (e.g., completely omitted columns) or framework crash, and Moqui logs a fallback warning pointing developers to the F&O Data Management UI.

###### D365 SCM Configuration Setup
To enable Recurring Integration on the existing Sales Orders Import project:
1. Open the **Data management** workspace in D365 SCM.
2. Select the existing data import project: **`HotWax_Import_SalesOrders_Composite`**.
3. In the top action pane, click **Create recurring data job**.
4. Configure the following parameters:
   - **Name:** `HotWax Recurring Sales Orders Import`
   - **Application ID:** Select the App Registration Application ID used by Moqui OMS to authorize incoming enqueue payloads.
   - **Supported Data Format:** Select **`Package`** (required for composite entity processing).
5. Click **Set scheduled processing** to define the background import recurrence pattern (e.g. every 5 minutes).
6. Click **Save** and copy the generated **`Activity ID`** GUID (e.g., `BC384DF1-78B3-473B-AA18-4EE5102D4717`).

For detailed architectural specifications, refer to [recurring_integrations_api.md](../recurring-integrations/recurring_integrations_api.md).

#### 1.3 Mixed Cart Order Handling

This section captures the current integration understanding for mixed-cart sales orders and should be treated as a working design until end-to-end validation is complete.

##### Overview
- A single D365 sales order can contain lines with different fulfillment ownership.
- Each line is processed independently based on whether fulfillment is owned by OMS or by D365.
- Mixed-cart handling is therefore a line-level integration concern rather than an order-level completion rule.

##### Fulfillment Ownership

###### Store-Fulfilled Lines
- Physical fulfillment is executed in OMS.
- D365 remains the inventory and financial system of record.
- After fulfillment is completed in OMS, OMS updates D365 so those lines can be completed financially in ERP.

###### Warehouse-Fulfilled Lines
- Fulfillment is executed in D365.
- D365 handles the operational lifecycle for those lines, including:
  - reservation
  - picking
  - packing slip posting
  - invoice posting

##### Working Integration Flow
1. **Order creation**
   - OMS sends the sales order to D365.
   - If final warehouse assignment is not yet known, OMS may send a placeholder warehouse/site context so the order can still be created.
   - Reservation is not triggered at order creation time.
2. **Fulfillment decision**
   - OMS determines fulfillment ownership per line:
     - store-fulfilled
     - warehouse-fulfilled
3. **Warehouse-fulfilled lines**
   - OMS sends or updates warehouse context when required by the integration design.
   - D365 then performs operational execution for those lines.
4. **Store-fulfilled lines**
   - OMS completes physical fulfillment outside D365.
   - After fulfillment, OMS updates D365 with the final fulfillment location context for those lines.
   - D365 is then used for downstream financial completion based on the approved posting sequence.

##### Inventory and Reservation
- In the tested D365 setup, reservation is configured as `Manual` under:
  - `Accounts receivable > Setup > Accounts receivable parameters > General > Sales default values`
- Order creation alone creates demand but does not reserve inventory.
- Reservation is the actual inventory commitment step.
- For warehouse-fulfilled lines, reservation timing should remain part of ERP-side fulfillment processing.
- OMS should not trigger reservation during order export.
- Warehouse/site context should be finalized before any reservation process is executed in D365.

##### Brokered Warehouse Update
- The implemented brokered order item warehouse update flow is documented separately in section 3.
- That separation is intentional because the flow depends on the sales order and sales order line export reconciliations, even though the business use case originates from mixed-cart order handling.

##### Invoicing Implication
- D365 can generate multiple invoices from a single sales order.
- Because fulfillment is line-driven, a mixed-cart order may result in separate invoices based on fulfillment and posting events.
- Example outcomes:
  - store-fulfilled lines posted in one invoice
  - warehouse-fulfilled lines posted in another invoice
  - partial shipments creating multiple invoices over time

##### Key Considerations
- Fulfillment ownership is line-driven, not order-driven.
- OMS should not model order completion as a single direct action in D365.
- In D365, completion is driven by operational posting events such as packing slip and invoice.
- Stores used for store-fulfilled completion must exist in D365 in a valid warehouse/location model.
- Warehouse-fulfilled lines should avoid early reservation if final brokering is still pending.

##### Design Principle
- OMS = fulfillment decision and store execution
- D365 = inventory control, warehouse execution, and financial posting

#### 1.4 Custom Service / SysOperation Import (Future)
**TODO:** This approach is not yet implemented.

Designed for high-volume and guaranteed document atomicity.

1. **Atomic Request**: Send a single nested JSON document (Header + Lines) to a custom X++ service.
2. **Transactional Commit**: D365 creates the entire order within a single database transaction.
3. **Efficiency**: Reduces network overhead from `1 + N` requests to `1` request per order.

#### 1.5 Import Prerequisites & TODOs
> [!IMPORTANT]
> - Customer must exist and not be on hold.
> - Products must be "Released" to the Legal Entity.
> - Warehouse/site validation must be confirmed against the target D365 setup for both OData and DMF paths.

- **Current observation from testing**:
  - D365 order creation requires valid inventory site context on the order line.
  - In the tested setup, OMS satisfies this by sending a warehouse that allows D365 to derive Site.
  - Order creation itself does not reserve inventory; reservation happens later.
  - D365 `Reservation` is currently configured as `Manual` in Accounts Receivable parameters.
- **Integration implication**:
  - OMS may need a placeholder D365 warehouse/site mapping for orders that have been placed but are not yet brokered to a final OMS fulfillment location.
  - This allows the sale to flow to D365 immediately without waiting for final brokering, while still allowing warehouse reassignment before reservation.
  - For warehouse-fulfilled orders, OMS should assign location context to D365, but reservation should remain an ERP-side activity rather than being triggered from OMS.
- **TODO**: [Mapping] Define `facilityId` to D365 warehouse/site mapping, including the strategy for unbrokered OMS orders.
- **TODO**: [Mapping] Create mapping table for `TaxCategory` -> `ItemSalesTaxGroup`.

### Integration Type Mappings
To avoid hardcoding values like `SalesOrderOriginCode` and `DeliveryModeCode` in service logic, we use the `IntegrationTypeMapping` entity to translate OMS identifiers into D365 codes.

#### Configuration Structure
Add records to the entity `co.hotwax.integration.IntegrationTypeMapping` for the target system:

| Mapping Category | OMS Internal ID (`mappingKey`) | D365 Code (`mappingValue`) | Enum Type (`integrationTypeId`) |
| :--- | :--- | :--- | :--- |
| **Sales Order Origin** | OMS Sales Channel (for example `WEB_SALES_CHANNEL`) | D365 Sales Origin (for example `Ecom`) | `D365_SALES_CHNL` |
| **Delivery Mode** | OMS Shipment Method (for example `STANDARD`) | D365 Mode of Delivery (for example `Standard`) | `D365_SHP_MTHD` |

#### Mapping Details
- **Sales Order Origin**: Maps the OMS `salesChannelEnumId` (from `OrderHeader`) to the D365 Sales Origin. In D365, this is the 'Sales Origin' field.
- **Delivery Mode**: Maps the OMS `shipmentMethodTypeId` (from `OrderItemShipGroup`) to the D365 Mode of Delivery. In D365, this is the 'Mode of delivery' field. For mixed-cart orders, first select the shipment method that is not `STOREPICKUP` or `POS_COMPLETED`, and if none exists, fall back to the first non-empty shipment method on the order.

#### Setup Steps
1. **Define Enumerations**: Add the mapping category IDs (for example `D365_SALES_CHNL`, `D365_SHP_MTHD`) to `moqui.basic.Enumeration`.
2. **Populate Mappings**: Provide the specific mapping records:
   - `integrationTypeId`: The category ID.
   - `mappingKey`: The internal Moqui ID.
   - `mappingValue`: The external D365 value.
   - `integrationRefId`: Set to the same value as `mappingKey` for referential integrity.

### 2. Export of Sales Orders from D365 to OMS

This flow returns the D365-generated `SalesOrderNumber` back into OMS after the OMS-to-D365 sales order import completes. The generic Data Package queue/send/poll services remain documented in [data_export_package_api.md](../data-package-api/data_export_package_api.md); this section covers the sales-order-header-specific D365 project, jobs, row mappings, and OMS persistence.

#### Objective
- Store the D365 `SalesOrderNumber` against the originating OMS order.
- Make the D365 sales order identifier available for downstream OMS flows, especially payment synchronization and sales order line reconciliation.

#### D365 Export Project Prerequisites
- **Sales order header export project**: `HotWax_Export_Sales_Orders`
  - Entity: `SalesOrderHeadersV4`
- In the D365 UI, `Enable Change Tracking` is enabled for the `SalesOrderHeadersV4` export entity. The current connector relies on D365 change tracking to export changed OMS-created records.
- The D365 export project should run in `Incremental Push` mode along with change tracking so changed OMS-created rows are picked up correctly.
- Change tracking only controls incremental selection. The project filters still determine which D365 records are considered eligible for the export.
- **Future option**: if change tracking proves too broad operationally, introduce an explicit D365 field such as `HcOrderExported` and use that to drive export selection instead.

#### Supported Export Approaches

The connector supports two separate technical approaches for exporting Sales Order Numbers back to OMS:

1. **Approach 1: Data Package API (Request/Poll Pattern)**
   - System message type: `D365_EXP_SALES_ORDERS`
   - Queue job: `d365_QueueSalesOrderExport`
   - Poll job: `d365_ExportSalesOrdersPoll`
   - Processing style: Request-based execution trigger, async polling, and file download.

2. **Approach 2: Recurring Integrations (Queue-Based Dequeue & Ack Pattern) [POC Ready]**
   - Service job: `d365_DequeueRecurringSalesOrderNumbers`
   - Service name: `co.hotwax.d365.D365RecurringExportServices.dequeue#RecurringSalesOrderNumbers`
   - Processing style: Active queue polling (dequeueing) of pre-scheduled exports, binary package download from Azure Blob Storage, and JSON-based request acknowledgment (Ack).

---

##### Export Approach 1: Data Package API (Request/Poll)
This export reconciles the D365-assigned `SalesOrderNumber` back to the OMS order.

###### D365 / OMS Components
- **System message type**: `D365_EXP_SALES_ORDERS`
- **Queue job**: `d365_QueueSalesOrderExport`
- **Poll job**: `d365_ExportSalesOrdersPoll`
- **Definition group**: `HotWax_Export_Sales_Orders`
- **Package name**: `SalesOrderHeadersV4`
- **CSV file**: `Sales order headers V4.csv`
- **DataManager config**: `D365_IMP_SALES_ORD`
- **Row-storage service**: `co.hotwax.d365.D365OrderServices.store#D365SalesOrderNumber`

###### Example System Message Type Configuration
Below is the corresponding `SystemMessageType` database record shape that enables this export stream:

```json
{
  "systemMessageTypeId": "D365_EXP_SALES_ORDERS",
  "description": "D365 Sales Order Number Export",
  "sendServiceName": "co.hotwax.d365.D365DataPackageServices.send#ExportDataPackage",
  "_entity": "moqui.service.message.SystemMessageType",
  "lastUpdatedStamp": "2026-04-30T09:18:18+0000"
}
```

###### Example Export Tracking Record Shape
Below is an example of a processed export `SystemMessage` record:

```json
{
  "systemMessageTypeId": "D365_EXP_SALES_ORDERS",
  "systemMessageId": "M102755",
  "_entity": "systemMessages",
  "processedDate": "2026-05-05T09:21:15+0000",
  "isOutgoing": "Y",
  "messageText": "{\"definitionGroupId\":\"HotWax_Export_Sales_Orders\",\"packageName\":\"SalesOrderHeadersV4\",\"legalEntityId\":\"usmf\",\"fileName\":\"Sales order headers V4.csv\",\"dataManagerConfigId\":\"D365_IMP_SALES_ORD\",\"targetDirectory\":null,\"systemMessageRemoteId\":\"D365_HotWax_Dev\"}",
  "lastUpdatedStamp": "2026-05-05T09:21:15+0000",
  "remoteMessageId": "ExportPackage-5/5/2026 09:19:44 am",
  "initDate": "2026-05-05T09:19:42+0000",
  "systemMessageRemoteId": "D365_HotWax_Dev",
  "lastAttemptDate": "2026-05-05T09:21:15+0000",
  "statusId": "SmsgConfirmed"
}
```

###### Implemented Processing Sequence
1. **The Queue Job (`d365_QueueSalesOrderExport`):**
   - Initiates the export by calling `D365DataPackageServices.queue#ExportDataPackage`.
   - The service queues an outgoing `SystemMessage` in the `SmsgProduced` status carrying the D365 project configuration metadata.
   - The message is sent immediately, invoking `D365DataPackageServices.send#ExportDataPackage` which makes an OData POST call to D365 `ExportToPackage` for the project `HotWax_Export_Sales_Orders`.
   - D365 registers the export job and returns an `executionId`. OMS stores this in `SystemMessage.remoteMessageId` and moves the message status to `SmsgSent`.
   
2. **The Poll Job (`d365_ExportSalesOrdersPoll`):**
   - Regularly queries active messages via `D365DataPackageServices.poll#ExportDataPackageStatus`.
   - For each message, it calls D365 `GetExecutionSummaryStatus` using the stored `executionId`.
   - Upon successful completion (`Succeeded` or `PartiallySucceeded`), the poller calls `GetExportedPackageUrl` to obtain the secure D365 package location, downloads the ZIP, and extracts `Sales order headers V4.csv`.
   - Hands off the CSV payload directly to MaargDataManager config **`D365_IMP_SALES_ORD`**, which invokes `store#D365SalesOrderNumber` for each row to create or update the `OrderIdentification` (`D365_SLS_ORD_NUM`) record in OMS.
   - **Status Update:** Upon successful download, parsing, and data loading into the DataManager, the poller updates the tracking `SystemMessage` status from `SmsgSent` to **`SmsgConfirmed`** to mark the entire export transaction as fully complete.

###### Exported Fields Used by OMS
| D365 CSV field | OMS usage |
| :--- | :--- |
| `CUSTOMERSORDERREFERENCE` | OMS `orderId` |
| `SALESORDERNUMBER` | Stored as `OrderIdentification.idValue` for type `D365_SLS_ORD_NUM` |

##### Export Approach 2: Recurring Integrations (Dequeue & Ack Flow) [POC Ready]
To bypass request-driven generation and polling overhead, this flow active-polls a pre-scheduled recurring export job queue in D365 to pull sales order numbers, downloads the package via Blob Storage redirect, and completes queue clearance via POST acknowledgments.

###### D365 / OMS Components
- **Service Job**: `d365_DequeueRecurringSalesOrderNumbers`
- **Service Name**: `co.hotwax.d365.D365RecurringExportServices.dequeue#RecurringSalesOrderNumbers`
- **Ack Service Name**: `co.hotwax.d365.D365RecurringExportServices.ack#RecurringSalesOrderNumbers`
- **Activity ID (GUID)**: `A82CB85F-3E4E-4215-8796-F954028FE331` (D365 SCM export scheduler)
- **Target CSV File**: `Sales order headers V4.csv`
- **DataManager config**: `D365_IMP_SALES_ORD`
- **Row-storage service**: `co.hotwax.d365.D365OrderServices.store#D365SalesOrderNumber`

###### Processing Sequence
1. **The Dequeue Service (`dequeue#RecurringSalesOrderNumbers`):**
   - Triggered on a cron schedule via the Service Job `d365_DequeueRecurringSalesOrderNumbers`.
   - Sends an authenticated `GET` call to `/api/connector/dequeue/{activityId}`.
   - **Targeted dequeue (optional):** When the `messageId` parameter is set on the service or job, the URL becomes `/api/connector/dequeue/{activityId}?messageId={messageId}`, targeting that specific queue message instead of the head of the queue. See [Targeted Dequeue by Message ID](../recurring-integrations/recurring_integrations_api.md#25-targeted-dequeue-by-message-id) for details.
   - If empty, D365 returns `204 No Content` and the service terminates gracefully.
   - If a package is ready, D365 returns `200 OK` with a JSON payload containing the `CorrelationId`, `PopReceipt`, and `DownloadLocation`.
   - The service makes a secondary `GET` call to the `DownloadLocation` URL (passing the OAuth Bearer token) to download the ZIP package, unzips it in-memory, extracts the target CSV file, and registers it with the Maarg DataManager (`D365_IMP_SALES_ORD`).
   
2. **The Acknowledge Service (`ack#RecurringSalesOrderNumbers`):**
   - Invoked immediately upon successful DataManager file registration.
   - Sends a `POST` request to `/api/connector/ack/{activityId}`.
   - Passes the **exact JSON payload** received from the dequeue request in the POST body.
   - D365 resolves the `CorrelationId` and lease lock, permanently deletes the message from the queue, and marks the corresponding message status in the D365 UI as **Acknowledged**.

###### Targeted Re-run / Debugging
To re-process a specific export message without consuming the queue head:
1. Look up the **Message ID** GUID from the D365 UI: **System administration > Data management IT > Manage scheduled data jobs > View messages**.
2. Set the `messageId` parameter on the `d365_DequeueRecurringSalesOrderNumbers` ServiceJob to that GUID.
3. Run the job once manually.
4. Clear the `messageId` parameter back to empty so subsequent scheduled runs return to normal queue polling.

> [!NOTE]
> This only works for messages that are still **in the queue** (status `In queue` or within the 30-minute lease window). Messages that have already been **Acknowledged** are permanently removed from the queue and cannot be re-dequeued.

---

###### OMS Persistence
- **Entity**: `co.hotwax.order.OrderIdentification`
- **Type**: `D365_SLS_ORD_NUM`
- **Purpose**: downstream D365 cross-reference for payments, line export reconciliation, and later brokered / fulfilled order item warehouse updates

###### Export Limitations & Partially Succeeded Edge Case
During the polling of D365 exports, the status `PartiallySucceeded` is treated as a success state by Moqui. This is necessary because Moqui must download the CSV file to reconcile the successful records within the batch. However, this introduces a critical integration edge case:

1. **What PartiallySucceeded Means for Exports:**
   D365 successfully serialized and exported some records, but skipped others due to row-level serialization errors, invalid character sets, or X++ virtual field calculation exceptions. For example, in a batch of 1,000 orders, 998 successfully export while 2 rows fail.
2. **The "Limbo & Duplicate" Trap:**
   - The 998 successful orders are reconciled in OMS (receiving their `D365_SLS_ORD_NUM`).
   - The 2 failed rows are omitted from the downloaded CSV. Therefore, these 2 orders will have `D365SalesOrderImportHistory` but **no** `D365_SLS_ORD_NUM` in OMS, despite actually being successfully created in D365 during the import stage.
   - When the scheduled **OMS Reconciliation Job** runs, it will find these 2 orders, see their parent import batch is completed, and **delete their import history markers**, assuming they failed to import.
   - During the next import cycle, OMS will re-package and re-submit these 2 orders, **creating duplicate orders in D365**.
3. **Mitigation Strategy:**
   - **D365-Side Alerts:** Any `PartiallySucceeded` export job in D365 must trigger an immediate IT alert. The D365 administrator must manually inspect the staging logs, fix the data/validation error, and re-run the export project so the skipped records are sent in a subsequent CSV.
   - **Conservative Reconciliation Window:** The OMS Reconciliation Job's timeout threshold should be sufficiently long (e.g., 24 hours) to allow D365 administrators time to fix and re-export failed records before OMS prunes history and retries.

### 2.1 Export of Sales Order Lines from D365 to OMS

This flow returns the D365-generated `InventoryLotId` back into OMS after the OMS-to-D365 sales order import completes.

#### Objective
- Store the D365 `InventoryLotId` against the originating OMS order item.
- Make the D365 sales order line identifier available for brokered and fulfilled order item warehouse updates back to D365.

#### D365 Export Project Prerequisites
- **Sales order line export project**: `HotWax_Export_Sales_Order_Lines`
  - Entity: `SalesOrderLinesV3`
  - Current filter: `ExternalItemNumber != ""`
- In the D365 UI, `Enable Change Tracking` is enabled for the `SalesOrderLinesV3` export entity. The current connector relies on D365 change tracking to export changed OMS-created records.
- The D365 export project should run in `Incremental Push` mode along with change tracking so changed OMS-created rows are picked up correctly.
- Change tracking only controls incremental selection. The project filters still determine which D365 records are considered eligible for the export.
- **Future option**: if change tracking proves too broad operationally, introduce an explicit D365 field such as `HcOrderLineExported` and use that to drive export selection instead.

#### Implemented Flow

This export reconciles the D365-assigned `InventoryLotId` back to the OMS order item.

###### D365 / OMS Components
- **System message type**: `D365_EXP_SLS_ORD_LN`
- **Queue job**: `d365_QueueSalesOrderLinesExport`
- **Poll job**: `d365_ExportSalesOrderLinesPoll`
- **Definition group**: `HotWax_Export_Sales_Order_Lines`
- **Package name**: `SalesOrderLinesV3`
- **CSV file**: `Sales order lines V3.csv`
- **DataManager config**: `D365_IMP_SLS_ORD_LN`
- **Row-storage service**: `co.hotwax.d365.D365OrderServices.store#D365SalesOrderLineInventoryLotId`

###### Implemented Processing Sequence
1. **The Queue Job (`d365_QueueSalesOrderLinesExport`):**
   - Initiates the export by calling `D365DataPackageServices.queue#ExportDataPackage`.
   - The service queues an outgoing `SystemMessage` in the `SmsgProduced` status carrying the D365 project configuration metadata.
   - The message is sent immediately, invoking `D365DataPackageServices.send#ExportDataPackage` which makes an OData POST call to D365 `ExportToPackage` for the project `HotWax_Export_Sales_Order_Lines`.
   - D365 registers the export job and returns an `executionId`. OMS stores this in `SystemMessage.remoteMessageId` and moves the message status to `SmsgSent`.
   
2. **The Poll Job (`d365_ExportSalesOrderLinesPoll`):**
   - Regularly queries active messages via `D365DataPackageServices.poll#ExportDataPackageStatus`.
   - For each message, it calls D365 `GetExecutionSummaryStatus` using the stored `executionId`.
   - Upon successful completion (`Succeeded` or `PartiallySucceeded`), the poller calls `GetExportedPackageUrl` to obtain the secure D365 package location, downloads the ZIP, and extracts `Sales order lines V3.csv`.
   - Hand off the CSV payload directly to MaargDataManager config **`D365_IMP_SLS_ORD_LN`**, which invokes `store#D365SalesOrderLineInventoryLotId` for each row to update the `D365SalesOrderItemInventoryLotId` attribute on the corresponding OMS order items.
   - **Status Update:** Upon successful download, parsing, and data loading into the DataManager, the poller updates the tracking `SystemMessage` status from `SmsgSent` to **`SmsgConfirmed`** to mark the entire export transaction as fully complete.

###### Exported Fields Used by OMS
| D365 CSV field | OMS usage |
| :--- | :--- |
| `SALESORDERNUMBER` | Used to resolve the OMS order through `OrderIdentification` type `D365_SLS_ORD_NUM` |
| `EXTERNALITEMNUMBER` | Used to resolve the OMS `orderItemSeqId` exactly as sent from OMS |
| `INVENTORYLOTID` | Stored on the OMS order item as the D365 sales-order-line identifier |

###### OMS Matching and Persistence Rules
- OMS must run the sales order header export before the sales order line export, because the line-storage service first resolves the OMS order through `D365_SLS_ORD_NUM`.
- OMS sends `orderItemSeqId` to D365 in `EXTERNALITEMNUMBER` during the sales order import.
- Values such as `00101` must be sent to D365 as-is and matched back as-is in OMS.
- `LineNumber` is not used for reconciliation because D365 exposes it as a decimal field and it is not the right place to preserve OMS item sequence ids with leading zeros.
- The line-storage service creates or updates `OrderItemAttribute` with:
  - `attrName = D365SalesOrderItemInventoryLotId`
  - `attrValue = INVENTORYLOTID`
- Re-exported values can overwrite the previously stored OMS `InventoryLotId`. That is acceptable in the current design because the line identifier is expected to remain stable after order creation.

#### End-to-End Dependency Chain
1. OMS imports the sales order to D365.
2. D365 sales order header export stores `D365_SLS_ORD_NUM` in OMS.
3. D365 sales order line export stores `D365SalesOrderItemInventoryLotId` in OMS.
4. OMS uses those stored identifiers to drive later brokered and fulfilled warehouse updates back into D365.

#### Current Design Notes
- The connector now uses the generic `queue#ExportDataPackage` -> `send#ExportDataPackage` -> `poll#ExportDataPackageStatus` pattern for both header and line exports.
- The D365 execution id is stored in `SystemMessage.remoteMessageId`.
- The export jobs are currently polling based.
- Duplicate or ambiguous exported rows should be treated as operational issues:
  - sales order header export expects one OMS order per `CUSTOMERSORDERREFERENCE`
  - sales order line export expects one OMS item per `SalesOrderNumber + ExternalItemNumber`

#### Export TODOs / Future Refinements
- tune retry/backoff behavior for delayed D365 export completion
- tighten D365 export project filters further if change tracking alone proves noisy
- evaluate whether explicit D365 flags such as `HcOrderExported` and `HcOrderLineExported` should replace or supplement change tracking
- revisit whether polling should remain the only reconciliation mechanism or whether D365 events can assist later

### 2.2 Export of Packing Slips (Outbound Shipments) from D365 to OMS

*For complete implementation specifications, architectural decisions, and step-by-step development instructions for synchronizing outbound shipments/packing slips from D365 SCM to OMS, see the [Shipment Export Exploration Notes](./shipment_export_exploration.md).*

### 3. Brokered Order Items Update from OMS to D365


Once OMS has final brokered fulfillment location information, it can update the D365 sales order line warehouse before reservation or downstream posting.

- The connector implements this as a DMF / Data Package import using the D365 project `HotWax_Import_Brokered_Order_Items`.
- The earlier OData `PATCH SalesOrderLinesV3(dataAreaId, InventoryLotId)` shape was verified manually and remains a useful reference for troubleshooting, but the implemented connector path is the Data Package import.
- This flow depends on the two prior export reconciliations:
  - section 2 must already have stored `D365_SLS_ORD_NUM`
  - section 2.1 must already have stored `D365SalesOrderItemInventoryLotId`

#### Implemented OMS Components
- **Eligible view**: `D365EligibleBrokeredOrderItems`
- **Import service**: `co.hotwax.d365.D365OrderServices.import#BrokeredOrderItemsDataPackage`
- **System message type**: `D365_IMP_BRKRD_ITEMS`
- **Queue job**: `d365_ImportBrokeredOrderItems`
- **Poll job**: `d365_PollBrokeredOrderItemsImportStatus`

#### D365 Import Project
- **Project name**: `HotWax_Import_Brokered_Order_Items`
- **Entity**: `Sales order lines V3`
- **Package settings**:
  - `SourceFormat = CSV`
  - `DefaultRefreshType = IncrementalPush`
- The generated package currently uses UTF-8 encoded files (`PackageHeader.xml`, `Manifest.xml`, and `Sales order lines V3.csv`).
- **Validated file shape**:

```csv
INVENTORYLOTID,SHIPPINGWAREHOUSEID,HCFULFILLMENTTYPE
479494,100,WMS
479495,13,WMS
```

- `DATAAREAID` is intentionally not included in the file. The OMS service requires `dataAreaId` as an input parameter and passes it to D365 as `legalEntityId` in the `ImportFromPackage` request.

#### Eligibility Rules in OMS
- OMS includes an item in the brokered-items feed only when:
  - the order already has `OrderIdentification` type `D365_SLS_ORD_NUM`
  - the order item already has `OrderItemAttribute` `D365SalesOrderItemInventoryLotId`
  - the item is in `ITEM_APPROVED`
  - the selected facility has a D365 warehouse id in `Facility.externalId`
  - the facility is not virtual
  - the facility currently belongs to `WH_ONLY_FULFILLMENT`
  - there is no prior `ExternalFulfillmentOrderItem` row, or the existing row is in `REJECT`
- **TODO**: replace the temporary `WH_ONLY_FULFILLMENT` facility-group rule with a dedicated D365 brokered fulfillment grouping later.

#### OMS Tracking Behavior
- After D365 accepts the import package and returns an execution id, OMS creates a `SystemMessage` record in `SmsgSent` for `D365_IMP_BRKRD_ITEMS`.
- OMS also creates or updates `ExternalFulfillmentOrderItem` with `fulfillmentStatus = Sent` for each packaged order item.
- `Sent` on `ExternalFulfillmentOrderItem` means OMS has successfully submitted the brokered location update package to D365. Final D365 completion is confirmed separately through the import `SystemMessage`, which later moves to `SmsgConfirmed` or `SmsgError`.
- Because reservation is currently manual in the tested D365 setup, this location update is expected to be safe before reservation. If D365 reservation behavior changes to automatic, this assumption must be retested.

### 3.1 Fulfilled Order Items Update from OMS to D365

Once OMS has physically fulfilled a store-owned line, it can update the D365 sales order line with the final shipping warehouse used for that fulfilled line.

- The connector implements this as a DMF / Data Package import using the D365 project `HotWax_Import_Fulfilled_Order_Items`.
- The feed shape is intentionally the same as the brokered warehouse update flow and updates the same D365 target entity, `Sales order lines V3`.
- This flow also depends on the two prior export reconciliations:
  - section 2 must already have stored `D365_SLS_ORD_NUM`
  - section 2.1 must already have stored `D365SalesOrderItemInventoryLotId`
- OMS uses `OrderFulfillmentHistory` as the local sent marker for this fulfilled-item update flow.

#### Implemented OMS Components
- **Eligible view**: `D365EligibleFulfilledOrderItems`
- **Tracking entity**: `OrderFulfillmentHistory`
- **Import service**: `co.hotwax.d365.D365OrderServices.import#FulfilledOrderItemsDataPackage`
- **System message type**: `D365_IMP_FLFLD_ITEMS`
- **Queue job**: `d365_ImportFulfilledOrderItems`
- **Poll job**: `d365_PollFulfilledOrderItemsImportStatus`

#### D365 Import Project
- **Project name**: `HotWax_Import_Fulfilled_Order_Items`
- **Entity**: `Sales order lines V3`
- **Package settings**:
  - `SourceFormat = CSV`
  - `DefaultRefreshType = IncrementalPush`
- The generated package currently uses UTF-8 encoded files (`PackageHeader.xml`, `Manifest.xml`, and `Sales order lines V3.csv`).
- **Validated file shape**:

```csv
INVENTORYLOTID,SHIPPINGWAREHOUSEID,HCFULFILLMENTTYPE
479494,100,OMS
479495,13,OMS
```

- `DATAAREAID` is intentionally not included in the file. The OMS service requires `dataAreaId` as an input parameter and passes it to D365 as `legalEntityId` in the `ImportFromPackage` request.

#### Eligibility Rules in OMS
- OMS includes an item in the fulfilled-items feed only when:
  - the order already has `OrderIdentification` type `D365_SLS_ORD_NUM`
  - the order item already has `OrderItemAttribute` `D365SalesOrderItemInventoryLotId`
  - the item is in `ITEM_COMPLETED`
  - the facility currently belongs to `OMS_FULFILLMENT`
  - the ship group shipment method is not `POS_COMPLETED`
  - there is no prior `OrderFulfillmentHistory` row for the same `orderId + orderItemSeqId`

#### OMS Tracking Behavior
- After D365 accepts the import package and returns an execution id, OMS creates a `SystemMessage` record in `SmsgSent` for `D365_IMP_FLFLD_ITEMS`.
- OMS also creates one `OrderFulfillmentHistory` row per packaged `orderId + orderItemSeqId` with:
  - `createdDate`
  - `externalConfigId = systemMessageRemoteId`
  - `externalFulfillmentId = '_NA_'`
  - `comments` noting the D365 fulfilled-item import execution
- The D365 execution id is stored in `SystemMessage.remoteMessageId`.
- Final D365 completion is tracked through the import `SystemMessage`; on successful polling it remains `SmsgSent`, and on failure it moves to `SmsgError`.
- `OrderFulfillmentHistory` is used only as a sent marker here; the full D365 execution id is not stored on that entity because the value can exceed the local field length.
- If a fulfilled-item package fails in D365 and the same item needs to be re-sent, the corresponding `OrderFulfillmentHistory` row must be removed or otherwise cleared for retry.
- Because reservation is currently manual in the tested D365 setup, this fulfilled-location update is expected to be safe before downstream D365 posting. If D365 reservation or posting behavior changes, this assumption must be retested.

> [!TODO]
> **Revisit: single vs. separate D365 data projects for brokered and fulfilled item updates.**
> Both feeds now send identical fields to D365 (`INVENTORYLOTID`, `SHIPPINGWAREHOUSEID`, `HCFULFILLMENTTYPE`) against the same entity (`Sales order lines V3`). A single D365 data project (`HotWax_Import_Order_Item_Updates`) could technically serve both, since D365 does not distinguish between brokered and fulfilled items — it just updates the sales order line.
>
> **Reasons to consolidate:** fewer D365 data projects to maintain and configure.
>
> **Reasons to keep separate:** independent scheduling frequency (brokered items should be sent as soon as brokering is confirmed; fulfilled items are sent after physical shipment), independent monitoring and failure isolation, and the ability for each flow to evolve its field set independently if future requirements differ (e.g., adding a tracking number or fulfillment timestamp to the fulfilled items feed).
>
> If the two feeds remain field-identical over time and operational simplicity is preferred, consolidation into a single D365 data project is a valid option.

## Customer Payment Integration

> For the invoice settlement service — why OOTB settlement fails, the custom `HotWaxAutoPostSettlementService` design, the multi-payment fix, contract parameters, and test scenarios — see **[invoice_settlement.md](./invoice_settlement.md)**.

OMS syncs settled payments to D365 as Customer Payment Journals. Two approaches are implemented. Both create unposted journal drafts; posting is handled by a D365-side batch job.

**Shared design across both approaches:**
- Journal name: `OMSPAY`
- Pattern: one journal header per sales order, one line per `OrderPaymentPreference`
- `IsPrepayment = No` (on-account — simpler than prepayment, no tax profile validation required)
- `PaymentReference = d365SalesOrderNumber` on every line — this is the field the settlement service matches on

### Eligibility View (`D365EligibleSalesOrderPayments`)

Entity: `co.hotwax.d365.payment.D365EligibleSalesOrderPayments`

**Eligibility rules:**
- `OrderHeader.orderTypeId = SALES_ORDER`
- `OrderIdentification` type `D365_SLS_ORD_NUM` exists (D365 Sales Order Number must be resolved first)
- `OrderPaymentPreference.statusId != PAYMENT_REFUNDED` (all non-refunded preferences are eligible)

**Aliases**: `orderId`, `partyId`, `d365SalesOrderNumber`, `orderPaymentPreferenceId`, `amount`, `paymentMethodTypeId`, `dataAreaId`

> [!NOTE]
> There is no `D365PaymentSyncHistory` entity yet. Both approaches rely on D365-side idempotency (OData lookup / DMF re-import behavior) rather than an OMS-side sent marker. Adding a local sync history entity is a tracked TODO.

---

### Approach 1: OData (`sync#CustomerPaymentJournals`)

Creates journal headers and lines via direct OData REST calls. Supports an optional `orderId` parameter to sync a single order.

#### Header (`CustomerPaymentJournalHeaders`)

| D365 Field | OMS / Moqui Source | Notes |
| :--- | :--- | :--- |
| `dataAreaId` | `ProductStore.externalId` | Legal entity context. |
| `JournalName` | `"OMSPAY"` | Fixed. **TODO**: revisit — confirm this should remain a fixed literal rather than be sourced from configuration. |
| `Description` | `"OMS Payment Journal - SO <d365SalesOrderNumber>"` | Idempotency lookup key. |

#### Line (`CustomerPaymentJournalLines`)

| D365 Field | OMS / Moqui Source | Notes |
| :--- | :--- | :--- |
| `dataAreaId` | `ProductStore.externalId` | Legal entity context. |
| `JournalBatchNumber` | Returned from header POST | Links line to header. |
| `AccountType` | `"Cust"` | Fixed. |
| `AccountDisplayValue` | `"HW\\-" + partyId` | Backslash-escaped to avoid OData filter issues. |
| `CurrencyCode` | `"USD"` | Currently defaulted. **TODO**: revisit alongside the open Sales Currency Code question in `business_processes.md` §8.3 — this hardcode affects payments, not just customer creation. |
| `CreditAmount` | `OrderPaymentPreference.maxAmount` | Payment amount. |
| `IsPrepayment` | `"No"` | On-account flow. |
| `PaymentReference` | `d365SalesOrderNumber` | Settlement anchor. |
| `OffsetAccountType` | `"Bank"` | Fixed. |
| `OffsetAccountDisplayValue` | `"USMF OPER"` | Hardcoded. **TODO**: map via `IntegrationTypeMapping`. |
| `PaymentId` | `orderPaymentPreferenceId` | Idempotency line lookup key. |

#### Idempotency

- **Header**: `GET /data/CustomerPaymentJournalHeaders` filtered by `Description eq '...' and IsPosted eq 'No'`. Reuses existing unposted journal if found.
- **Line**: `GET /data/CustomerPaymentJournalLines` filtered by `JournalBatchNumber` and `PaymentId`. Skips if already exists.

#### Sample Payload

```json
// POST /data/CustomerPaymentJournalHeaders
{
  "dataAreaId": "usmf",
  "JournalName": "OMSPAY",
  "Description": "OMS Payment Journal - SO 000887"
}

// POST /data/CustomerPaymentJournalLines
{
  "dataAreaId": "usmf",
  "JournalBatchNumber": "25135",
  "LineNumber": 1,
  "AccountType": "Cust",
  "AccountDisplayValue": "HW\\-02",
  "CurrencyCode": "USD",
  "CreditAmount": 80.00,
  "IsPrepayment": "No",
  "PaymentReference": "000887",
  "PaymentId": "10050",
  "OffsetAccountType": "Bank",
  "OffsetAccountDisplayValue": "USMF OPER"
}
```

#### Limitations
- No batch size limit — large volumes generate `1 + N` API calls per order.
- `OffsetAccountDisplayValue` hardcoded; no `IntegrationTypeMapping(D365_PMT_MTHD)` lookup applied.
- No execution tracking (`SystemMessage`).

---

### Approach 2: Data Package API (`import#CustomerPaymentJournalsDataPackage`)

Builds a composite XML package and submits it through DMF. Follows the same pattern as the sales order Data Package import.

- **D365 entity**: `Customer payment journal` (composite)
- **XML entities**: `CUSTOMERPAYMENTJOURNALHEADERENTITY` + nested `CUSTOMERPAYMENTJOURNALLINEENTITY`
- **Definition group**: `HotWax_Import_CustomerPayments_Composite`
- **System message type**: `D365_IMP_ORDER_PMTS`
- **Batch limit**: 1000 payments per run
- **Incremental support**: optional `fromDate` parameter; supports `lastRunTime` job parameter

#### Processing Flow

1. Query `D365EligibleSalesOrderPayments`, apply optional `fromDate` filter, limit 1000, group by `orderId`.
2. For each order group, build a header map + line maps. Resolve `PAYMENTMETHODNAME` via `IntegrationTypeMapping(D365_PMT_MTHD)` (falls back to `CASH`).
3. Generate composite XML (`CUSTOMERPAYMENTJOURNALHEADERENTITY` with nested lines), `PackageHeader.xml`, and `Manifest.xml`.
4. Compress to ZIP in memory.
5. `POST GetAzureWriteUrl` → obtain blob URL and `BlobId`.
6. `PUT <blobUrl>` (`Content-Type: application/zip`) → upload ZIP.
7. `POST ImportFromPackage` with `definitionGroupId` and `BlobId` → receive `executionId`.
8. Create `SystemMessage` (`D365_IMP_ORDER_PMTS`) in `SmsgSent` with `remoteMessageId = executionId`.
9. Poll job uses generic `poll#ImportDataPackageStatus` to track completion.

#### XML Structure

```xml
<Document>
  <CUSTOMERPAYMENTJOURNALHEADERENTITY JOURNALNAME="OMSPAY"
      DESCRIPTION="OMS Payment Journal - SO 000887">
    <CUSTOMERPAYMENTJOURNALLINEENTITY
      ACCOUNTTYPE="Cust" ACCOUNTDISPLAYVALUE="HW\-02"
      CURRENCYCODE="USD" CREDITAMOUNT="80.00"
      ISPREPAYMENT="No" PAYMENTREFERENCE="000887"
      PAYMENTMETHODNAME="CASH" PAYMENTID="10050"
      OFFSETACCOUNTTYPE="Bank" OFFSETACCOUNTDISPLAYVALUE="USMF OPER"/>
  </CUSTOMERPAYMENTJOURNALHEADERENTITY>
</Document>
```

---

### Approach Comparison

| Feature | OData | Data Package |
| :--- | :--- | :--- |
| Service | `sync#CustomerPaymentJournals` | `import#CustomerPaymentJournalsDataPackage` |
| Transport | Direct OData REST (1+N calls per order) | DMF composite XML via Azure Blob |
| Idempotency | Pre-import OData lookup per header and line | No pre-import lookup |
| Payment method mapping | Not applied | `IntegrationTypeMapping(D365_PMT_MTHD)` |
| Incremental support | `orderId` filter only | `fromDate` + `lastRunTime` |
| Batch limit | None | 1000 payments per run |
| Execution tracking | None | `SystemMessage` (`D365_IMP_ORDER_PMTS`) in `SmsgSent` |

---

## Outbound Integration (Business Events) TODO 
- [ ] **Endpoint Setup**: Create a REST service in Moqui to receive and validate Business Event notifications.
- [ ] **D365 Configuration**:
    - Register the Moqui endpoint in D365 (`System administration > Setup > Business events > Endpoints`).
    - Activate required events (e.g., `SalesOrderInvoicedBusinessEvent`).
- [ ] **Event Handling**: Implement logic in Moqui to process incoming events and trigger corresponding status updates or data pulls.

- [ ] Test connectivity with D365 Sandbox.
- [ ] Validate data integrity in D365.
- [ ] Verify outbound notification flow (D365 -> OMS).

---

## POS Completed Orders Sync

The order will be sent to D365 as part of the [Sales Order Sync](#sales-order-sync). Once the order is created, the following steps are performed to complete the lifecycle of a POS carry-out order:

1.  **Automated Packing Slip Posting**: Posts the packing slip to deduct inventory.
2.  **Automated Invoice Posting**: Programmatically posts the invoice to finalize the financial record for the sale.
3.  **Customer Payments Sync**: Synchronizes the payment details and creates payment journals (see [Customer Payment Integration](#customer-payment-integration)).
4.  **Automated Payment Posting & Settlement**: Posts the payment journal and settles it against the invoice.

### Implementation Strategy: OOTB vs. Custom Code

- **Automated Packing Slip Posting**: Handled by OOTB D365 batch job (`Sales and marketing > Sales Orders > Order shipping > Post Packing Slip`, filtered by `SalesOrigin = POS`). Validated — see issue [#13](https://github.com/hotwax/dynamics365-integration/issues/13).
- **Automated Invoice Posting**: Handled by OOTB D365 batch job (`AR > Invoices > Batch invoicing > Invoice`). For now, a single unfiltered job posts invoices for all Delivered orders regardless of sales origin or fulfillment type. Filtering by `SalesOrigin = POS` (issue [#16](https://github.com/hotwax/dynamics365-integration/issues/16)) or `HcFulfillmentType = OMS` (issue [#17](https://github.com/hotwax/dynamics365-integration/issues/17)) is possible if separate jobs are configured later, but that's not the current setup — see [business_processes.md §6.1](./business_processes.md#61-invoice-batch-job).
- **Payment Journal Posting**: Under evaluation — OOTB AR auto-post may be sufficient; to be confirmed in target environment.
- **Settlement**: Custom `HotWaxAutoPostSettlementService` implemented in the `dynamics365-integration` repository. OOTB settlement was rejected because it uses customer-level FIFO matching, which cannot honor `PaymentReference = SalesOrderNumber`. See [invoice_settlement.md](./invoice_settlement.md) for full design and test results.

Custom D365 code lives in the `dynamics365-integration` repository.
