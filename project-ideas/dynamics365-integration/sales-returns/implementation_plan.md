# OMS to D365 Returns — Implementation Plan

This document covers the technical design, integration approaches evaluated, service architecture, field mappings, and phased implementation plan for syncing returns from HotWax OMS to Dynamics 365 F&O.

For D365 standard return process, disposition codes, accounting model, and lifecycle overview see [business_processes.md](./business_processes.md).

## Technical Architecture
- Return order integration uses the generic D365 connector foundation documented in [connector_foundation.md](../foundation/connector_foundation.md).
- **Return-specific interfaces**:
    - OData v4 (REST) for return order header and line creation (`ReturnOrderHeadersV2`, `ReturnOrderLinesV2`)
    - DMF / Recurring Integrations Queue Connector for arrival journal batch import (`Item arrival journals V2` composite entity)

---

## Technical Reference: OData Metadata
| Term | Meaning |
| :--- | :--- |
| **EntitySet** | The URL collection or endpoint (e.g., `ReturnOrderHeadersV2`). |
| **EntityType** | The schema definition and structure of the data object. |
| **Key** | Defines the Primary Key fields (e.g., `dataAreaId`, `ReturnOrderNumber`). |
| **Nullable="false"** | Indicates a **Required Field** that cannot be empty. |

---

## 1. Overview and Scope

### Phase 1 — Return Order Creation (Current)
- Create Return Order Header in D365 via `POST /data/ReturnOrderHeadersV2`
- Create Return Order Lines in D365 via `POST /data/ReturnOrderLinesV2`
- Track sync status per return for idempotency and retry
- Handle POS completed returns and online in-progress returns via separate DataDocument triggers

### Phase 2 — Sweep / Fallback (Planned)
- ServiceJob-based batch sweep using `D365EligibleReturnView`
- Retry for `D365_RTN_ERROR` and `D365_RTN_PARTIAL` records missed by event-driven Phase 1

### Phase 3 — Arrival Journal DMF Sync (Implemented)
- Batch-sweep ServiceJob packages eligible returns into a DMF ZIP using the "Item arrival journals V2" composite entity
- Services: `queue#ArrivalJournals`, `send#ArrivalJournalImport`, `poll#ArrivalJournalImport`, `check#ArrivalJournalImport`
- Tracking entity: `D365ArrivalJournalHistory`; view: `D365EligibleArrivalJournals`
- `definitionGroupId`: `HotWax_Import_Item_Arrival_Journals_V2`

### Phase 4 — Refund Payment Journal DMF Sync (Implemented)
- Batch-sweep ServiceJob packages eligible cash refunds into a DMF ZIP using the Customer Payment Journal composite entity
- Service: `import#RefundPaymentJournalsDataPackage` in `D365ReturnServices.xml`, journal name `OMSRFND` (separate from `OMSPAY` used for sales order payments)
- One journal header per return, one line per original payment method (`OrderPaymentPreference`)
- Idempotency via `OrderPaymentPreference.finAccountId`; view: `D365EligibleRefundPayments`
- Verified end-to-end against the live D365 import project

### Downstream Batch Automation (D365-native, Implemented)
- Packing slip posting for POS completed returns — dedicated D365 batch job filtered on `ReturnOrderOriginCode = POS` (requires the `ReturnOrderOriginCode` entity extension — see Section 3.6)
- Invoice / credit note posting for completed returns — single converged D365 batch job, verified end-to-end
- Arrival journal auto-posting — `HotWaxAutoPostArrivalJournalService`, journal name `OMSArr` (see Section 4.8)

### Future Phases (Not yet in scope — see Section 8)
- Settlement (credit note + refund journal / exchange invoice matching)
- Exchange order handling

---

## 2. Integration Approach Selection

### 2.1 Approaches Evaluated

Three approaches were evaluated for syncing return orders from OMS to D365.

#### Approach A: OData via DataFeed (Event-Driven) ← Selected for Phase 1

OMS DataFeed fires when `ReturnHeader` reaches the configured status. The receiver service calls OData endpoints directly.

| | |
| :--- | :--- |
| **D365 Entities** | `ReturnOrderHeadersV2`, `ReturnOrderLinesV2` |
| **Trigger** | Moqui DataFeed on `ReturnHeader` status change |
| **Processing** | Synchronous per-return: 1 header POST + N line POSTs |
| **Why chosen** | Near-real-time; online returns must be in D365 before warehouse receiving begins; ~80% already implemented |
| **Limitation** | `systemMessageRemoteId` cannot be passed via DataFeed (see Section 3.1 for resolution) |

#### Approach B: OData via ServiceJob (Batch Sweep) ← Phase 2

Scheduled job iterates `D365EligibleReturnView` and processes all pending/failed returns.

| | |
| :--- | :--- |
| **Trigger** | Scheduled ServiceJob (no cron set yet — use Run Now for testing) |
| **`systemMessageRemoteId`** | Job parameter (no blocker) |
| **Why not Phase 1** | Not real-time; online returns could lag before D365 knows about them, blocking warehouse receiving |
| **Role** | Sweep/retry fallback for missed events and `D365_RTN_ERROR` records |

#### Approach C: DMF / Data Package with multiple entities ← Definitively Closed

Explored and tested. Two obstacles encountered:

1. **No standard composite entity exists** for return orders in D365 (confirmed in Data Management workspace). Unlike sales orders which have `Sales orders composite V4`, there is no equivalent for returns.

2. **Multi-entity placeholder approach tested and failed.** A ZIP containing separate `ReturnOrderHeaderEntity` and `ReturnOrderLineEntity` files linked by a placeholder value (`TEMP-001`) was submitted via DMF with execution dependency configured. The header imported successfully and D365 auto-generated a real `ReturnOrderNumber`. However, lines failed because DMF has no cross-entity substitution cache for separate entities — lines looked up `TEMP-001` which no longer existed in the database.

OData is the only viable path because `POST ReturnOrderHeadersV2` returns the generated `ReturnOrderNumber` synchronously in the response, which is immediately used for subsequent line POSTs.

##### Comparison: Approach A vs Approach B vs Approach C

| Feature | OData / DataFeed (A) | OData / ServiceJob (B) | DMF / Data Package (C) |
| :--- | :--- | :--- | :--- |
| **Latency** | Near real-time (event-driven) | Batch / scheduled | Batch / scheduled |
| **`systemMessageRemoteId` passing** | Resolved from `ProductStoreSetting` (workaround required) | Job parameter — no blocker | Job parameter — no blocker |
| **D365 entity availability** | `ReturnOrderHeadersV2`, `ReturnOrderLinesV2` — confirmed | Same | No standard composite entity — **closed** |
| **Atomicity** | Non-atomic (1 header + N line POSTs) | Same | N/A — DMF approach is not viable |
| **Selected for** | Phase 1 — event-driven creation | Phase 2 — sweep / retry fallback | Not used |

### 2.2 Alternative Approaches (Future Options from D365 Community)

These were identified via the Microsoft D365 Community forum thread and are not planned for immediate implementation but are worth tracking for production-scale decisions.

#### Custom Composite Entity (D365-Side Development)
- A D365 developer duplicates `SalesOrderV4Entity` and adapts it for returns, creating a `ReturnOrderCompositeV1` entity containing header + lines as nested children
- Solves the DMF placeholder problem since header and lines are one document — key resolution is internal
- Unlocks the full DMF batch path for returns at high volume
- **Effort:** Medium D365 X++ development effort — largely copy-and-adapt of the existing composite

#### Line-Level Entity with Auto-Header Creation (D365-Side Development)
- A custom entity whose `initValue()` / `validateWrite()` logic auto-creates the return header if one doesn't exist for the incoming `CustomersOrderReference`
- OMS sends lines only; header is derived from line data
- **Constraint:** Only works if all required header fields can be derived from line data. Our return headers require `DefaultReturnSiteId`, `DefaultReturnWarehouseId`, `ReturnAddress*`, `CurrencyCode` — these can't be derived from a line unless they are passed as redundant attributes per line row (flat entity pattern)
- **Effort:** Medium D365 X++ development

#### Custom Service Class (D365-Side Development)
- A custom X++ service (similar to `HotWaxAutoPostSettlementService`) that accepts the full return payload and executes the entire lifecycle: create header, create lines, post arrival, post packing slip, generate credit note — all in one call or a controlled sequence
- For POS completed returns, the service can set the return to **Invoiced** state directly, bypassing the arrival / packing slip ceremony
- **When to consider:** High volume (1500+ lines per run), or when the full downstream lifecycle automation is needed in one atomic operation
- **Effort:** Highest D365 X++ development effort; most powerful long-term

---

## Foundation

The generic connector foundation for authentication, credentials storage, legal-entity mapping, OAuth token management, and common OData request handling is documented in [connector_foundation.md](../foundation/connector_foundation.md).

This returns implementation plan focuses on the return-specific services, entities, views, and orchestration built on top of that shared connector layer.

---

## 3. Phase 1 Implementation Details

### 3.1 systemMessageRemoteId Resolution ✅ Implemented

**The problem:** Moqui's DataFeed framework calls the receiver service with a fixed contract (`org.moqui.EntityServices.receive#DataFeed`). Custom parameters like `systemMessageRemoteId` cannot be passed through the DataFeed mechanism.

**The fix (implemented):**

A `ProductStoreSetting` record per ProductStore maps to the correct `SystemMessageRemote`:

```
ProductStoreSetting(
  productStoreId    = <OMS product store>
  settingTypeEnumId = 'D365_SMR_ID'      ← enumTypeId = PROD_STR_STNG
  settingValue      = 'D365_HotWax_Sandbox'
)
```

Inside `sync#ReturnOrder`, after resolving `productStoreId`, the setting is looked up when `systemMessageRemoteId` is not passed in (DataFeed path). When called via ServiceJob, the value is passed directly as a job parameter and the lookup is skipped. This naturally supports multi-tenant deployments.

> [!NOTE]
> The `ProductStoreSetting` lookup is the canonical pattern for resolving per-store D365 configuration in all return services. Any new service that needs `systemMessageRemoteId` should follow the same pattern rather than accepting it as a required parameter.

### 3.2 Data Model

#### Entity: `D365ReturnHeaderHistory`

Tracks the aggregate sync state per return. PK is `returnId` (one row per OMS return — no surrogate key needed).
- *Reasoning:* Prevents duplicate return header creation in D365 on retry, stores the resulting D365 Return Order Number and RMA Number, and records detailed execution logs on failure.

```xml
<entity entity-name="D365ReturnHeaderHistory" package="co.hotwax.d365.return">
    <field name="returnId" type="id" is-pk="true"/>
    <field name="d365ReturnOrderNumber" type="text-short"/>
    <field name="d365RmaNumber" type="text-short"/>
    <field name="syncStatusId" type="id" default="D365_RTN_PENDING"/>
    <field name="syncedDate" type="date-time"/>
    <field name="logText" type="text-long"/>
</entity>
```

| Field | Type | Notes |
| :--- | :--- | :--- |
| `returnId` | id (PK) | OMS return ID |
| `d365ReturnOrderNumber` | text-short | D365 `ReturnOrderNumber` from create response |
| `d365RmaNumber` | text-short | D365 RMA number — captured from `RMANumber` in GET (`$select=ReturnOrderNumber,RMANumber`) and POST responses |
| `syncStatusId` | id | `D365_RTN_PENDING` / `D365_RTN_SYNCED` / `D365_RTN_PARTIAL` / `D365_RTN_ERROR` |
| `syncedDate` | date-time | Timestamp of successful sync |
| `logText` | text-long | Error details |

#### Entity: `D365ReturnLineHistory`

Tracks per-line sync state for partial success and targeted retry.
- *Reasoning:* Enables granular, retry-safe resumption of interrupted syncs. If a return with multiple items fails on one line, the next attempt reads this history to skip already-synced lines and resume only at the failed ones.

```xml
<entity entity-name="D365ReturnLineHistory" package="co.hotwax.d365.return">
    <field name="returnId" type="id" is-pk="true"/>
    <field name="returnItemSeqId" type="id" is-pk="true"/>
    <field name="d365ReturnOrderNumber" type="text-short"/>
    <field name="syncStatusId" type="id" default="D365_RTN_PENDING"/>
    <field name="syncedDate" type="date-time"/>
    <field name="lastAttemptDate" type="date-time"/>
    <field name="logText" type="text-long"/>
</entity>
```

| Field | Type | Notes |
| :--- | :--- | :--- |
| `returnId` | id (PK) | |
| `returnItemSeqId` | id (PK) | |
| `d365ReturnOrderNumber` | text-short | Parent D365 return order number |
| `syncStatusId` | id | Per-line status |
| `syncedDate` | date-time | |
| `lastAttemptDate` | date-time | |
| `logText` | text-long | |

#### View-Entity: `D365EligibleReturnOrders` (Phase 2)

Joins `ReturnHeader` with `D365ReturnHeaderHistory` to find returns that are completed but not yet synced, or previously attempted but failed.

Key conditions:
- `ReturnHeader.statusId != 'RETURN_CANCELLED'`
- No `D365ReturnHeaderHistory` row (never synced) OR `syncStatusId != 'D365_RTN_SYNCED'` (retry eligible)

### 3.3 Event Triggers (DataDocuments)

Two DataDocuments feed into the same DataFeed and service, covering both return channel types:

| DataDocument | Root Entity | Trigger Condition | Rationale |
| :--- | :--- | :--- | :--- |
| `D365OnlineReturnHeaderDoc` | `ReturnHeader` | `statusId = RETURN_REQUESTED` AND `returnChannelEnumId != POS_RTN_CHANNEL` | D365 must have the return order before warehouse receiving starts |
| `D365PosReturnHeaderDoc` | `ReturnHeader` | `statusId = RETURN_COMPLETED` AND `returnChannelEnumId = POS_RTN_CHANNEL` | POS returns skip RETURN_REQUESTED and go directly to COMPLETED |

**DataFeed:** `D365ReturnsFeed` → `receive#ReturnOrderEvent` → async `sync#ReturnOrder`

### 3.4 Service Architecture

**File:** `co.hotwax.d365.D365ReturnServices`

#### `receive#ReturnOrderEvent`
Implements `org.moqui.EntityServices.receive#DataFeed`. Iterates `documentList`, extracts `returnId` from `document._id`, and async-calls `sync#ReturnOrder` per return.

#### `sync#ReturnOrder` (Orchestration)

**Flow:**

1. Resolve `productStoreId` from the linked order's `orderHeader`
2. Look up `systemMessageRemoteId` from `ProductStoreSetting(settingTypeEnumId='D365_SMR_ID')` if not passed in
3. Check `D365ReturnHeaderHistory` — skip if already `D365_RTN_SYNCED`
4. Resolve `dataAreaId` from `ProductStore.externalId`
5. Resolve destination facility and postal address from `ReturnHeader.destinationFacilityId`
6. Sync customer to D365 via `sync#Customer`
7. Mark header as `D365_RTN_PENDING` in history
8. Check if return order already exists in D365 (`GET /data/ReturnOrderHeadersV2` filtered by `CustomersOrderReference = returnId`)
9. If not found: `POST /data/ReturnOrderHeadersV2` → capture `ReturnOrderNumber` from response
10. Fail fast if `ReturnOrderNumber` cannot be resolved (header failure blocks all lines)
11. For each `ReturnItem`: skip if already `D365_RTN_SYNCED` in line history; `POST /data/ReturnOrderLinesV2`; update line history
12. Update header history with aggregate status (`SYNCED` / `PARTIAL` / `ERROR`)

**Failure behavior:**
- Stop all remaining lines on: header failure, auth failure, D365 unavailable, missing shared mapping
- Continue remaining lines on: item-specific validation failure, individual line timeout, missing product mapping for one item

### 3.5 ServiceJob — Phase 2 Sweep

| Parameter | Value |
| :--- | :--- |
| Job name | `sync_D365ReturnOrders` |
| Service | `co.hotwax.d365.D365ReturnServices.sync#ReturnOrders` |
| `systemMessageRemoteId` | Job parameter (required) |
| `returnId` | Optional — set for targeted single-return sync or manual retry |
| `cronExpression` | TBD — use Run Now for testing |
| `paused` | Y |

`sync#ReturnOrders` (plural) iterates `D365EligibleReturnOrders` and calls `sync#ReturnOrder` per return with `ignore-error="true"` so a failure on one return does not abort the remaining batch.

### 3.6 Field Mappings

#### Return Order Header (`ReturnOrderHeadersV2`)

| D365 Field | OMS Source | Status |
| :--- | :--- | :--- |
| `dataAreaId` | `ProductStore.externalId` | ✅ Implemented |
| `CustomerAccountNumber` | Resolved via `sync#Customer` on `ReturnHeader.fromPartyId` | ✅ Implemented |
| `InvoiceCustomerAccountNumber` | Same as `CustomerAccountNumber` | ✅ Implemented |
| `CustomersOrderReference` | `ReturnHeader.returnId` | ✅ Implemented — idempotency key |
| `CustomerRequisitionNumber` | `OrderIdentification(D365_SLS_ORD_NUM)` on linked `orderId` | ✅ Implemented |
| `CustomerReturnReasonCode` | `IntegrationTypeMapping(D365_RTN_REASON)` | ⚠️ Hardcoded to `39` — mapping TODO |
| `ReturnOrderOriginCode` | `IntegrationTypeMapping(D365_RTN_CHNL)` on `returnChannelEnumId` | ✅ Implemented — requires the D365 entity extension mapping this field to `SalesTable.SalesOriginId` (see Section 4.9) |
| `CurrencyCode` | `ReturnHeader.currencyUomId` | ✅ Implemented — defaults to `USD` |
| `DefaultReturnWarehouseId` | `Facility.externalId` on `destinationFacilityId` | ✅ Implemented |
| `DefaultReturnSiteId` | *(not sent)* | ✅ Omitted — D365 derives from warehouse |
| `LanguageId` | Hardcoded `en-us` | ⚠️ **Hardcoded** — low priority |
| `ReturnAddressName` | `Facility.facilityName` | ✅ Implemented |
| `ReturnAddressStreet` | `FacilityContactDetailByPurpose.address1` + `address2` | ✅ Implemented |
| `ReturnAddressCity` | `FacilityContactDetailByPurpose.city` | ✅ Implemented |
| `ReturnAddressStateId` | `Geo.geoCodeAlpha2` on `stateProvinceGeoId` | ⚠️ Geo lookup returning null — needs investigation |
| `ReturnAddressZipCode` | `FacilityContactDetailByPurpose.postalCode` | ✅ Implemented |
| `ReturnAddressCountryRegionId` | `Geo.geoCodeAlpha3` on `countryGeoId` | ✅ Implemented |

#### Return Order Lines (`ReturnOrderLinesV2`)

| D365 Field | OMS Source | Status |
| :--- | :--- | :--- |
| `dataAreaId` | `ProductStore.externalId` | ✅ Implemented |
| `ReturnOrderNumber` | From header POST response | ✅ Implemented — D365-generated, not a placeholder |
| `ItemNumber` | `GoodIdentification(D365_PRODUCT_ID)` on `productId` | ⚠️ **Falls back to `1000`** if no mapping — TODO |
| `ReturnSalesQuantity` | `-1 * ReturnItem.returnQuantity` | ✅ Implemented |
| `ReturnWarehouseId` | `Facility.externalId` on `destinationFacilityId` | ✅ Implemented |
| `ReturnSiteId` | *(not sent)* | ✅ Omitted — D365 derives from warehouse |
| `SalesPrice` | `ReturnItem.returnPrice` | ✅ Implemented |
| `ReturnDispositionCode` | `IntegrationTypeMapping(D365_RTN_DISPOSITION)` | ⚠️ Hardcoded to `11` — mapping TODO |
| `ProductSizeId` | `ProductFeature(SIZE)` | ⚠️ Not yet implemented — variant TODO |
| `ProductColorId` | `ProductFeature(COLOR)` | ⚠️ Not yet implemented — variant TODO |

> [!IMPORTANT]
> `CustomerReturnReasonCode` is hardcoded to `39` and `ReturnDispositionCode` is hardcoded to `11`. Both must be replaced with `IntegrationTypeMapping` lookups before production. Define mappings for `D365_RTN_REASON` and `D365_RTN_DISPOSITION` in coordination with business input on which codes to use.

### 3.7 Integration Type Mappings

To avoid hardcoding values like `CustomerReturnReasonCode` and `ReturnDispositionCode` in service logic, we use the `IntegrationTypeMapping` entity to translate OMS identifiers into D365 codes.

#### Configuration Structure

| Mapping Category | OMS Internal ID (`mappingKey`) | D365 Code (`mappingValue`) | Enum Type (`integrationTypeId`) |
| :--- | :--- | :--- | :--- |
| **Return Reason** | OMS `returnReasonEnumId` (e.g. `RTN_DEFECTIVE`) | D365 `CustomerReturnReasonCode` (e.g. `39`) | `D365_RTN_REASON` |
| **Disposition Code** | OMS return condition or reason (e.g. `RTN_CREDIT_ONLY`) | D365 `ReturnDispositionCode` (e.g. `11`) | `D365_RTN_DISPOSITION` |

#### Setup Steps
1. **Define Enumerations**: Add the mapping category IDs (`D365_RTN_REASON`, `D365_RTN_DISPOSITION`) to `moqui.basic.Enumeration`.
2. **Populate Mappings**: Provide the specific mapping records per OMS return reason / condition:
   - `integrationTypeId`: The category ID.
   - `mappingKey`: The internal OMS enumeration ID.
   - `mappingValue`: The external D365 code value.
   - `integrationRefId`: Set to the same value as `mappingKey` for referential integrity.
3. **Remove hardcodes**: Once mappings are populated, remove the hardcoded fallbacks in `sync#ReturnOrder` (`39`) and `queue#ArrivalJournals` (`11`).

### 3.8 Seed Data Required

```xml
<!-- ProductStoreSetting type for systemMessageRemoteId resolution (enumTypeId PROD_STR_STNG is the system-wide type for all ProductStoreSetting keys) -->
<moqui.basic.Enumeration enumId="D365_SMR_ID" description="D365 System Message Remote ID" enumTypeId="PROD_STR_STNG"/>

<!-- ServiceJob for Phase 2 sweep -->
<moqui.service.job.ServiceJob jobName="sync_D365ReturnOrders"
    serviceName="co.hotwax.d365.D365ReturnServices.sync#ReturnOrder"
    cronExpression="" paused="Y">
    <parameters parameterName="systemMessageRemoteId" parameterValue=""/>
    <parameters parameterName="returnId" parameterValue=""/>
</moqui.service.job.ServiceJob>
```

### 3.9 Sample API Requests

#### Create Return Order Header
```
POST {{d365_url}}/data/ReturnOrderHeadersV2
Content-Type: application/json

{
  "dataAreaId": "usmf",
  "CustomerAccountNumber": "HW-10090",
  "InvoiceCustomerAccountNumber": "HW-10090",
  "CustomersOrderReference": "RTN-10001",
  "CustomerRequisitionNumber": "SO-00123",
  "CustomerReturnReasonCode": "39",
  "CurrencyCode": "USD",
  "DefaultReturnWarehouseId": "21",
  "LanguageId": "en-us",
  "ReturnAddressName": "Main Warehouse",
  "ReturnAddressStreet": "123 Warehouse Blvd",
  "ReturnAddressCity": "Los Angeles",
  "ReturnAddressStateId": "CA",
  "ReturnAddressZipCode": "90001",
  "ReturnAddressCountryRegionId": "USA"
}
```
> `DefaultReturnSiteId` is intentionally omitted — D365 derives the site automatically from the warehouse configuration.

#### Create Return Order Line
```
POST {{d365_url}}/data/ReturnOrderLinesV2
Content-Type: application/json

{
  "dataAreaId": "usmf",
  "ReturnOrderNumber": "RMA-00043",
  "ItemNumber": "SHOPIFY-PARENT-ID",
  "ReturnSalesQuantity": -2,
  "ReturnWarehouseId": "21",
  "SalesPrice": 99.99,
  "ReturnDispositionCode": "11"
}
```
> `ReturnSiteId` is intentionally omitted — D365 derives the site from the warehouse.

---

## 4. Phase 3 — Arrival Journal DMF Sync

### 4.1 Approach: DMF Composite Entity over OData

OData (`ItemArrivalJournalHeadersV2` + `ItemArrivalJournalLinesV2`) has a critical sequencing constraint: the arrival journal header must be POSTed first to obtain a D365-generated `JOURNALNUMBER`, which is then required for each line POST — the same N+1 problem encountered with return order lines. Except here, unlike return orders, there is no workaround via synchronous response chaining at scale.

The DMF **"Item arrival journals V2" composite entity** solves this — header and lines are submitted as a single XML document in a ZIP package, and D365 resolves the journal number internally. This is the same pattern used for sales order sync via the `Sales orders V4` composite entity.

Additionally, one ZIP can cover multiple return journals in a single import operation, making the sweep efficient.

> [!NOTE]
> The individual OData entities `ItemArrivalJournalHeadersV2` and `ItemArrivalJournalLinesV2` are available but not used in the OMS integration — the OData path has a critical sequencing constraint where the journal number is auto-generated on header creation and must be known for each subsequent line POST. The DMF composite entity avoids this entirely.

### 4.2 Data Model

#### Entity: `D365ArrivalJournalHistory`

Tracks which returns have been packaged into a DMF arrival journal import. A record means the return was included in at least one import attempt. There is no status field — presence equals queued.
- *Reasoning:* Prevents a return from being packaged into multiple arrival journal batches. Eligibility view excludes any return that has a history record.

```xml
<entity entity-name="D365ArrivalJournalHistory" package="co.hotwax.d365.return">
    <field name="returnId" type="id" is-pk="true"/>
    <field name="d365ReturnOrderNumber" type="id"/>
    <field name="systemMessageId" type="id"/>
    <field name="queuedDate" type="date-time"/>
</entity>
```

| Field | Type | Notes |
| :--- | :--- | :--- |
| `returnId` | id (PK) | OMS return ID |
| `d365ReturnOrderNumber` | id | D365 `ReturnOrderNumber` at time of packaging |
| `systemMessageId` | id | `SystemMessage` holding the DMF ZIP |
| `queuedDate` | date-time | When the return was packaged |

**Retry:** Delete the `D365ArrivalJournalHistory` record to re-queue. The `D365EligibleArrivalJournals` view excludes returns that have any history record.

#### View-Entity: `D365EligibleArrivalJournals`

Returns that are `D365_RTN_SYNCED` (return order exists in D365) and have no `D365ArrivalJournalHistory` record.

Exposes: `returnId`, `destinationFacilityId`, `d365ReturnOrderNumber`, `d365RmaNumber`, `arrivalQueuedDate`.

### 4.3 Service Architecture

**File:** `co.hotwax.d365.D365ReturnServices`

#### `queue#ArrivalJournals`

Batch sweep — called by `queue_D365ArrivalJournals` ServiceJob.

**Flow:**
1. Query `D365EligibleArrivalJournals` (filtered by `returnId` for targeted runs)
2. For each eligible return: fetch `ReturnHeader` + `ReturnItem` records
3. Resolve customer account from `PartyIdentification(D365_CUST_ACCT)` on `ReturnHeader.fromPartyId` — no D365 call
4. Resolve receiving site ID from parent facility's `externalId` (`Facility.parentFacilityId` → `siteFacility.externalId`)
5. Resolve item numbers via `GoodIdentification(D365_PRODUCT_ID)` on `productId`
6. Build `WMSITEMARRIVALJOURNALHEADERV2ENTITY` + `WMSITEMARRIVALJOURNALLINEV2ENTITY` XML per return journal
7. Group all journals into one XML document, ZIP with `PackageHeader.xml` + `Manifest.xml`
8. Create `SystemMessage(D365_ARR_JNL_IMPORT)` with the ZIP binary; create `D365ArrivalJournalHistory` per return

Supports `dryRun=true` — logs generated XML without creating SystemMessage or history records.

#### `send#ArrivalJournalImport`

Implements `send#SystemMessage` for `SystemMessageTypeId=D365_ARR_JNL_IMPORT`. POSTs the ZIP to:
```
POST /api/connector/enqueue/{activityId}
```
D365 returns a Queue Message ID stored as the SystemMessage `remoteMessageId`.

#### `poll#ArrivalJournalImport`

ServiceJob-driven. Finds all `D365_ARR_JNL_IMPORT` SystemMessages in `SmsgSent` status and delegates to `check#ArrivalJournalImport` per message.

#### `check#ArrivalJournalImport`

1. Calls `GetExecutionIdByMessageId` with the Queue Message ID → resolves the DMF Execution ID
2. Delegates to existing `check#ImportDataPackageStatus` with the Execution ID

### 4.4 Field Mappings

#### Arrival Journal Header (`WMSITEMARRIVALJOURNALHEADERV2ENTITY`)

| XML Attribute | Source | Notes |
| :--- | :--- | :--- |
| `JOURNALNAMEID` | Hardcoded `WArr` | D365 warehouse arrival journal name |
| `DEFAULTACCOUNTNUMBER` | `PartyIdentification(D365_CUST_ACCT)` on `ReturnHeader.fromPartyId` | No D365 call — resolved locally |
| `DEFAULTRETURNITEMNUMBER` | `D365ReturnHeaderHistory.d365RmaNumber` | `RMANumber` from D365 (e.g. `00412`) |
| `DEFAULTTRANSACTIONREFERENCENUMBER` | `D365ReturnHeaderHistory.d365ReturnOrderNumber` | `ReturnOrderNumber` from D365 (e.g. `001624`) |
| `DEFAULTTRANSACTIONREFERENCETYPE` | Hardcoded `0` | Numeric — `0` = Sales order type |
| `ISITEMMOVEDTODEFAULTITEMPICKINGWAREHOUSELOCATION` | Hardcoded `0` | Required on both header **and** line |

#### Arrival Journal Lines (`WMSITEMARRIVALJOURNALLINEV2ENTITY`)

| XML Attribute | Source | Notes |
| :--- | :--- | :--- |
| `LINENUMBER` | Sequential (1, 2, 3…) | Required — auto-incremented per journal |
| `ACCOUNTNUMBER` | `PartyIdentification(D365_CUST_ACCT)` | Customer account |
| `ITEMNUMBER` | `GoodIdentification(D365_PRODUCT_ID)` on `productId` | Falls back to `1000` — TODO |
| `ITEMQUANTITY` | `ReturnItem.returnQuantity` | Positive quantity |
| `ISRETURNORDER` | Hardcoded `1` | Marks as return arrival |
| `RETURNITEMNUMBER` | `d365RmaNumber` | `RMANumber` (e.g. `00412`) |
| `RETURNDISPOSITIONCODEID` | Hardcoded `11` | TODO: map from OMS return reason |
| `TRANSACTIONREFERENCENUMBER` | `d365ReturnOrderNumber` | `ReturnOrderNumber` (e.g. `001624`) |
| `TRANSACTIONREFERENCETYPE` | Hardcoded `0` | Numeric — `0` = Sales order type |
| `TRANSACTIONDATE` | `ReturnHeader.entryDate` | Return entry date (not current timestamp) |
| `ISITEMMOVEDTODEFAULTITEMPICKINGWAREHOUSELOCATION` | Hardcoded `0` | Required on both header and line |

### 4.5 D365 Return Identifier Clarification

Two distinct identifiers on a D365 return order:

| D365 Field | Example | OMS Field | Arrival Journal Usage |
| :--- | :--- | :--- | :--- |
| `ReturnOrderNumber` | `001624` | `d365ReturnOrderNumber` | `DEFAULTTRANSACTIONREFERENCENUMBER` / `TRANSACTIONREFERENCENUMBER` |
| `RMANumber` | `00412` | `d365RmaNumber` | `DEFAULTRETURNITEMNUMBER` / `RETURNITEMNUMBER` |

`sync#ReturnOrder` captures both identifiers: GET uses `$select=ReturnOrderNumber,RMANumber`; POST response body contains both. Both are persisted to `D365ReturnHeaderHistory`.

> [!NOTE]
> Do not confuse `ReturnOrderNumber` and `RMANumber` — they are two distinct D365 identifiers with different roles in arrival journal construction. `TRANSACTIONREFERENCENUMBER` uses `ReturnOrderNumber`; `RETURNITEMNUMBER` uses `RMANumber`.

### 4.6 Customer Account Resolution

`sync#Customer` now persists the resolved D365 customer account to `PartyIdentification(partyIdentificationTypeId='D365_CUST_ACCT')` after every successful sync (upsert by PK — safe on retry). The `queue#ArrivalJournals` service reads from this record locally when building the arrival journal XML — no additional D365 API call needed.

`PartyIdentificationType(D365_CUST_ACCT)` seed data is defined in `D365OrderSyncData.xml`.

### 4.7 ServiceJobs

| Job | Service | Key Parameters |
| :--- | :--- | :--- |
| `queue_D365ArrivalJournals` | `queue#ArrivalJournals` | `systemMessageRemoteId`, `activityId` (D365 Data Management activity ID for "Item arrival journals V2"), `definitionGroupId=HotWax_Import_Item_Arrival_Journals_V2`, optional `returnId` |
| `poll_D365ArrivalJournalImport` | `poll#ArrivalJournalImport` | `systemMessageRemoteId` |

Both jobs are paused by default.

For generic package upload/import mechanics and API sequencing, refer to [data_import_package_api.md](../data-package-api/data_import_package_api.md).

### 4.8 Journal Name Correction: `WArr` → `OMSArr`

`queue#ArrivalJournals` originally sent `JOURNALNAMEID: "WArr"`. This was changed to `JOURNALNAMEID: "OMSArr"` after discovering `WArr` is D365's **default** journal name for Item Arrival (Inventory management → Setup → Journal names → Warehouse management) — any native/manual arrival posting not explicitly overriding the journal name would also use `WArr`, and the auto-post batch class (`HotWaxAutoPostArrivalJournalService`, which filters strictly by `JournalNameId`) would then post those too, even though OMS never created them.

`OMSArr` is a new, dedicated journal name (description: "OMS Arrival Journal"), deliberately not set as a default anywhere. Its `Check picking location` setting is left off, matching the guidance for basic (non-license-plate-controlled) warehousing, which is what OMS-driven return arrivals target.

Both sides needed updating:
- OMS: `queue#ArrivalJournals` — `JOURNALNAMEID` literal changed to `"OMSArr"`
- D365: `HotWaxAutoPostArrivalJournalService`'s coded fallback default (used only when the batch job's `JournalNameId` parameter is left blank) was `"RTN_ARR"` — a stale value that never matched anything — corrected to `"OMSArr"`

Full D365 setup steps are in `dynamics365-integration/docs/auto-post-arrival-journal.md`.

### 4.9 `ReturnOrderOriginCode` Entity Extension

`ReturnOrderHeadersV2` has no native field identifying the sales channel (POS vs. Ecom) that created the return — unlike sales orders, which have `SalesOrderOriginCode`. This blocks any D365 batch job (e.g. the packing slip job in business_processes.md Section 2.7) that needs to filter return orders by channel.

**D365-side (implemented):** a data entity view extension on `ReturnOrderHeadersV2` adds a new mapped field:

```xml
<AxDataEntityViewField xmlns="" i:type="AxDataEntityViewMappedField">
  <Name>ReturnOrderOriginCode</Name>
  <AllowEdit>Auto</AllowEdit>
  <Label>Return order origin code</Label>
  <DataField>SalesOriginId</DataField>
  <DataSource>SalesTable</DataSource>
</AxDataEntityViewField>
```

No table extension was needed — `SalesOriginId` already exists on `SalesTable` (return orders are `OrderType = Returned order` rows in the same table sales orders live in). After deploying, **System administration → Data management → Framework parameters → Refresh entity list** must be run so the Data Management framework picks up the change.

**OMS-side (implemented):** `sync#ReturnOrder` resolves `ReturnOrderOriginCode` via a new `D365_RTN_CHNL` IntegrationTypeMapping on `returnChannelEnumId` (`POS_RTN_CHANNEL → POS`, `ECOM_RTN_CHANNEL → Ecom`) and includes it in the `ReturnOrderHeadersV2` POST payload — same pattern as `SalesOrderOriginCode` resolution for sales orders, but a separate mapping type since return-channel and order-channel enums differ.

---

## 5. Phase 4 — Refund Payment Journal DMF Sync

### 5.1 Approach: DMF Composite Entity, Mirroring Sales Order Payment Sync

Unlike returns and arrival journals (where DMF was the *only* viable path), the OData `CustomerPaymentJournalHeaders`/`Lines` entities work perfectly well for payment journals — `sync#CustomerPaymentJournals` already uses them for sales order payments. The refund journal service uses the **DMF Data Package** approach instead (`import#RefundPaymentJournalsDataPackage`), mirroring `import#CustomerPaymentJournalsDataPackage` — the existing bulk/batch-oriented sibling for sales order payments — rather than the OData path. This is a design choice for consistency with the existing bulk payment sync pattern, not a technical constraint the way it was for returns.

**Trade-off accepted:** the DMF import is asynchronous, so `JournalBatchNumber` is not available synchronously the way it is via OData (see Section 5.5).

### 5.2 Data Model

#### View-Entity: `D365EligibleRefundPayments`

Joins `ReturnHeader → D365ReturnHeaderHistory (D365_RTN_SYNCED) → ReturnItemResponse → OrderPaymentPreference (PAYMENT_REFUNDED)`. One row per `(returnId, orderPaymentPreferenceId)`.

```
ReturnHeader (RH)
  └─ D365ReturnHeaderHistory (RSH) — must be D365_RTN_SYNCED
  └─ ReturnItemResponse (RIR)
        └─ OrderPaymentPreference (OPP) — must be PAYMENT_REFUNDED
```

Confirmed 1:1 between `ReturnItemResponse` and `orderPaymentPreferenceId` by reading the only `ReturnItemResponse`-creation code in the OMS (`process#ShopifyRefund`) — it always creates exactly one `ReturnItemResponse` per OPP, with `returnItemSeqId` hardcoded to `"_NA_"`, never per return line item. A return with multiple `ReturnItemResponse` rows means multiple distinct payment transactions (e.g. a refund split across two payment methods), never the same OPP duplicated.

**Why `ReturnItem`/`OrderHeader`/`ProductStore` are not in this view:** `dataAreaId` is a per-return value, not a per-OPP value — joining those entities in would multiply rows for no benefit. It's resolved once per return inside the service instead (same `ReturnItem → OrderHeader → ProductStore` pattern `sync#ReturnOrder` already uses).

**Eligibility conditions (entity-condition on the view):**
- `ReturnHeader.statusId != RETURN_CANCELLED`
- `D365ReturnHeaderHistory.syncStatusId = D365_RTN_SYNCED`
- `OrderPaymentPreference.statusId = PAYMENT_REFUNDED`
- `OrderPaymentPreference.paymentMethodTypeId NOT IN (SHOP_STORE_CREDIT, EXCHANGE_CREDIT, EXCHANGE_PAYMENT, EXT_GIFT_CARD, EXT_SHOP_GFT_CARD)` — only cash refunds get a journal; store credit and gift card refunds stay as open credits on the D365 customer account, covered by the credit note
- `OrderPaymentPreference.finAccountId IS NULL` — idempotency guard, see Section 5.5

### 5.3 Service Architecture

**Service:** `import#RefundPaymentJournalsDataPackage` in `D365ReturnServices.xml`

**Flow:**
1. Query `D365EligibleRefundPayments` (optionally filtered by `returnId`, and by `fromDate` — see Section 5.5), group rows by `returnId`
2. For each return: resolve `customerAccount` via `PartyIdentification(D365_CUST_ACCT)`; resolve `dataAreaId` via `ReturnItem → OrderHeader → ProductStore`
3. Build **one journal header per return** — `JournalName: 'OMSRFND'`, `Description: 'OMS Refund Journal - RTN {d365ReturnOrderNumber}'`
4. Build **one journal line per OPP** (not summed) — see field mapping below. A return refunded across two payment methods produces two lines under the same header.
5. Package all headers/lines as `CUSTOMERPAYMENTJOURNALHEADERENTITY`/`CUSTOMERPAYMENTJOURNALLINEENTITY` XML, ZIP with manifest, upload to Azure Blob, trigger `ImportFromPackage` (`overwrite: false` — required for composite entities)
6. On success: stamp `finAccountId` on each submitted OPP (Section 5.5), record a `SystemMessage`, update `lastRunTime` if run via job

### 5.4 Field Mapping (Journal Line)

| D365 Field | Source | Notes |
| :--- | :--- | :--- |
| `ACCOUNTTYPE` | Hardcoded `Cust` | |
| `ACCOUNTDISPLAYVALUE` | `HW-{fromPartyId}` | Same format as sales order payment journals |
| `CURRENCYCODE` | Hardcoded `USD` | |
| `DEBITAMOUNT` | `OrderPaymentPreference.maxAmount` (abs) | Debit on customer account = company pays customer — opposite of `CREDITAMOUNT` used in OMSPAY |
| `PAYMENTREFERENCE` | `D365ReturnHeaderHistory.d365ReturnOrderNumber` | Used by `HotWaxAutoPostSettlementService` to match the refund journal to the credit note |
| `OFFSETACCOUNTTYPE` | Hardcoded `Bank` | |
| `OFFSETACCOUNTDISPLAYVALUE` | Hardcoded `USMF OPER` | Bank account — confirm per legal entity |
| `PAYMENTMETHODNAME` | `IntegrationTypeMapping(D365_PMT_MTHD)` on `paymentMethodTypeId`, default `CASH` | Same mapping already used for sales order payments |
| `PAYMENTID` | `orderPaymentPreferenceId` | Uniquely identifies the line — same OPP-per-line pattern as sales order payment sync |
| `ISPREPAYMENT` | Hardcoded `No` | |

### 5.5 Idempotency

Two mechanisms, each solving a different problem:

**`OrderPaymentPreference.finAccountId`** (guarantees correctness) — reused from an existing OFBiz field, stamped with the DMF execution ID after a successful `ImportFromPackage` trigger. `D365EligibleRefundPayments` excludes any OPP where this is already set. A failed submission leaves it unset, so the OPP stays eligible on the next run regardless of the time window below. This directly mirrors how the NetSuite integration for the same OMS reuses this exact field to store its own Credit Memo ID (confirmed by reading NetSuite's `syncNetSuiteReturnTransactions.groovy` settlement logic).

**`fromDate` / `lastRunTime` windowing** (query efficiency only) — same pattern as `import#CustomerPaymentJournalsDataPackage`: resolves `fromDate` from the ServiceJob's last successful run time if not passed explicitly, and filters the query to only rescan recent history. This bounds how much data gets queried each run; it is **not** what prevents duplicates — `finAccountId` is.

> **Known limitation:** `finAccountId` stores the DMF **execution ID**, not D365's actual `JournalBatchNumber` — `ImportFromPackage` doesn't return the batch number synchronously since the import itself is processed asynchronously. Getting the real batch number would require a poll/check step after the import completes (mirroring `poll#ArrivalJournalImport`/`check#ArrivalJournalImport`). Not built — the execution ID already satisfies idempotency, and this gap would likely disappear if refund journal creation is ever moved to OData instead (which returns the batch number synchronously).

### 5.6 ServiceJob

| Job | Service | Key Parameters |
| :--- | :--- | :--- |
| `import_D365RefundPaymentJournals` | `import#RefundPaymentJournalsDataPackage` | `systemMessageRemoteId`, `definitionGroupId=HotWax_Import_RefundPayments_Composite`, optional `returnId`, `jobName` |

Paused by default.

---

## 6. TODOs by Approach

### Phase 1 — OData Event-Driven (DataFeed) ✅ Core implemented and tested

| # | Item | Details |
| :--- | :--- | :--- |
| 1 | `CustomerReturnReasonCode` mapping | Hardcoded to `39`. Define `IntegrationTypeMapping(D365_RTN_REASON)` mapping OMS return reason codes to D365 reason codes. Needs business input on which codes to use. |
| 2 | `ReturnDispositionCode` mapping | Hardcoded to `11`. Define `IntegrationTypeMapping(D365_RTN_DISPOSITION)` mapping OMS return condition/reason to D365 disposition codes (Credit only, Credit, Scrap, etc.). Needs business input. |
| 3 | `ItemNumber` product mapping | Falls back to `1000` when no `GoodIdentification(D365_PRODUCT_ID)` exists. Same strategy as sales orders — `GoodIdentification` records must be populated per product. |
| 4 | Variant dimensions on lines | `ProductSizeId` and `ProductColorId` not yet sent. Add after product mapping is confirmed — same pattern as sales order line variant dimensions. |
| 5 | `ReturnAddressStateId` geo resolution | Currently returning null — the `Geo.geoCodeAlpha2` lookup is not resolving for the facility's `stateProvinceGeoId`. Needs investigation on the facility data setup. |
| 6 | DataFeed path end-to-end test | Test `RETURN_REQUESTED` trigger via actual Shopify return once dev store is available. `RETURN_COMPLETED` POS trigger also needs testing. |

### Phase 2 — OData ServiceJob Sweep ✅ Wired, not yet scheduled

| # | Item | Details |
| :--- | :--- | :--- |
| 7 | Cron schedule | `sync_D365ReturnOrders` job has no cron set. Schedule once Phase 1 DataFeed path is validated in production. |
| 8 | Full sweep test | Test `sync#ReturnOrders` with no `returnId` (sweep all eligible) to confirm batch isolation works — one failed return must not abort others. |

### Downstream Lifecycle (see Section 8)

| # | Item | Details |
| :--- | :--- | :--- |
| 9 | Arrival journal creation via DMF | ✅ Implemented — `queue#ArrivalJournals` sweeps `D365EligibleArrivalJournals` and packages returns into a DMF ZIP using the "Item arrival journals V2" composite entity, journal name `OMSArr`. See Section 4 for full details. |
| 10 | Arrival journal posting | ✅ Implemented — `HotWaxAutoPostArrivalJournalService`, filtered by `JournalNameId = OMSArr`. See Section 4.8. |
| 11 | Arrival journal timing gate for online returns | ⚠️ Not yet implemented — OMS currently queues an arrival journal for any synced return regardless of status. Correct for POS (receipt already happened by sync time) but not yet gated for online returns, which sync at `RETURN_REQUESTED` before physical receipt. Needs a gate on an actual receipt signal (e.g. `ShipmentReceipt`). |
| 12 | D365-managed warehouse exclusion | ⚠️ Not yet implemented — returns destined for D365-managed (non-OMS/WMS) warehouses should be excluded from the OMS arrival journal flow entirely, since D365's own native receiving process would create its own arrival journal. |
| 13 | Packing slip posting for POS returns | ✅ Implemented — D365 batch job filtered on `ReturnOrderOriginCode = POS`. See business_processes.md Section 2.7. |
| 14 | Credit note generation | ✅ Implemented — single converged D365 batch job (`SalesFormLetter_Invoice`), verified end-to-end. See Section 8, Phase 4. |
| 15 | Credit note export back to OMS | ⚠️ Not yet implemented — credit note number is not currently exported back to OMS for reconciliation. |
| 16 | Refund payment journal | ✅ Implemented — `import#RefundPaymentJournalsDataPackage`, journal name `OMSRFND`. See Section 5. |
| 17 | Refund journal batch scaling | ⚠️ Not yet implemented — every other bulk DMF service in this codebase caps batch size (`.limit(N)`); the refund journal service doesn't yet. A naive limit on the current (return × OPP) denormalized view would risk truncating a return's OPPs mid-group — the correct fix is a two-step query (limit on distinct `returnId`s first, then fetch OPPs for that bounded set). Not urgent at current volume. |
| 18 | Settlement | ⚠️ Proposed, not implemented — new `HotWaxAutoPostReturnSettlementService` (separate from the sales-order `HotWaxAutoPostSettlementService`), matching credit note/exchange invoice via `SalesId` and payment/refund journals via `PaymReference`. Requires stamping `CustomerRequisitionNumber` on exchange orders (via `sync#SalesOrders`), sourced from `ReturnItemResponse.replacementOrderId`. See Section 6 (Phase 6) below for the full design. |
| 19 | Custom composite entity (D365) | If high volume requires DMF path for return orders — D365 dev to build `ReturnOrderCompositeV1` entity duplicating the sales order composite pattern. |
| 20 | Common Shopify Order Id on Return Order / Credit Note / Exchange Order | ⚠️ Not yet implemented — none of these carry a Shopify Order Id field in D365 today. NetSuite sends the Shopify Order Id as a common cross-reference on every related transaction (Sales Order, Customer Deposit, RMA, Credit Memo, Exchange Order); D365 relies instead on OMS-side tracking and repurposed free-text fields (see business_processes.md Section 9). Would also resolve the exchange-order-linkage open question in business_processes.md Section 7.6. See `sales-orders/implementation_plan.md` §"OData TODOs / Gaps" for the Sales Order / Payment side of this same gap. |

---

## 7. Verification Plan

| # | Step | Status |
| :--- | :--- | :--- |
| 1 | Add `ProductStoreSetting(D365_SMR_ID)` record for the test ProductStore | ✅ Done |
| 2 | Call `sync#ReturnOrder` directly via ServiceJob with test `returnId` | ✅ Done — tested with `returnId=M100000` |
| 3 | Confirm `sync#ReturnOrder` resolves `systemMessageRemoteId` from `ProductStoreSetting` | ✅ Done |
| 4 | Verify `POST /data/ReturnOrderHeadersV2` called with correct payload; status 201 | ✅ Done |
| 5 | Verify `POST /data/ReturnOrderLinesV2` called for each return item; status 201 | ✅ Done |
| 6 | Confirm `D365ReturnHeaderHistory` persisted with `D365_RTN_SYNCED` and `d365ReturnOrderNumber` | ✅ Done |
| 7 | Confirm D365 return order visible in `Sales and marketing > Return orders` | ✅ Done — `RMANumber: 00412`, `ReturnOrderNumber: 001624` |
| 8 | Test idempotency — re-run same `returnId`, confirm already-synced skip | Pending |
| 9 | Trigger via DataFeed — `RETURN_REQUESTED` status change on online return | Pending — needs Shopify dev store |
| 10 | Test POS return — `RETURN_COMPLETED` on POS channel, confirm only `D365PosReturnHeaderDoc` fires | Pending — needs Shopify dev store |
| 11 | Test `sync#ReturnOrders` sweep with no `returnId` — confirm batch isolation (one failure does not abort others) | Pending |
| 12 | Test error scenario — unmapped product, confirm `D365_RTN_ERROR` on line, other lines continue | Pending |
| 13 | Run `queue#ArrivalJournals` with `dryRun=true` — confirm generated XML shows `DEFAULTRETURNITEMNUMBER=RMANumber` (e.g. `00412`) and `DEFAULTTRANSACTIONREFERENCENUMBER=ReturnOrderNumber` (e.g. `001624`) | Pending |
| 14 | Run `queue#ArrivalJournals` without `dryRun` — confirm `SystemMessage(D365_ARR_JNL_IMPORT)` created and `D365ArrivalJournalHistory` records inserted per return | Pending |
| 15 | Run `send#ArrivalJournalImport` — confirm ZIP POSTed to `/api/connector/enqueue/{activityId}`, Queue Message ID persisted as `remoteMessageId` | Pending |
| 16 | Run `poll#ArrivalJournalImport` — confirm DMF execution status resolved, SystemMessage marked confirmed | Pending |
| 17 | Verify arrival journals visible in D365 `Inventory management > Journals > Item arrival` and can be posted | Pending |
| 18 | Run `HotWaxAutoPostArrivalJournalService` — confirm it posts `OMSArr` journals and does not touch journals under other names (e.g. `WArr`) | ✅ Done |
| 19 | Post packing slip via the POS returns batch job — confirm `ReturnOrderOriginCode = POS` filter correctly selects only POS return orders | ✅ Done |
| 20 | Post invoice via the converged invoice batch job — confirm credit note generated for completed returns regardless of channel | ✅ Done — verified end-to-end |
| 21 | Run `import#RefundPaymentJournalsDataPackage` against a return with cash-refunded OPPs — confirm one journal header with one line per OPP, correct `DebitAmount`/`PaymentMethodName`/`PaymentReference` | ✅ Done — verified against the live `HotWax_Import_RefundPayments_Composite` D365 import project |
| 22 | Re-run `import#RefundPaymentJournalsDataPackage` for an already-processed return — confirm it's excluded (finAccountId already set) and no duplicate journal is created | Pending |

---

## 8. Future Phases — Downstream Lifecycle

The following steps complete the full return lifecycle in D365 after the return order is created. These are **not yet in scope** but are documented here for planning purposes based on research from Microsoft Learn and the D365 community thread.

### Phase 3: Arrival Journal DMF Sync ✅ Implemented

**When:** `queue_D365ArrivalJournals` ServiceJob sweeps eligible returns after their return order is `D365_RTN_SYNCED`.

OMS packages returns into a DMF ZIP using the "Item arrival journals V2" composite entity and submits via Queue Connector. See Section 4 for the full implementation details.

**Remaining for Phase 3:**

| Step | Detail |
| :--- | :--- |
| D365 posts arrival journal | ✅ Implemented — `HotWaxAutoPostArrivalJournalService` (custom class, journal name `OMSArr`). See Section 4.8. |
| Limitation | Underlying OOTB `WMSJournalCheckPostReception` only posts one journal at a time; the custom class wraps it to sweep all matching-`JournalNameId` journals in one run |

### Phase 4: Credit Note Generation ✅ Implemented

| Step | Detail |
| :--- | :--- |
| Who triggers | D365 batch class `SalesFormLetter_Invoice` — a single converged batch job for all completed returns regardless of channel (see business_processes.md Section 2.7). Verified end-to-end. |
| Prerequisite | Return line must be in `Received` status (arrival registered + packing slip posted, OR `Credit only` disposition) |
| Output | Credit note with negative amount |
| OMS sync-back | Not yet implemented — credit note number is not currently exported back to OMS for reconciliation |

### Phase 5: Refund Payment Journal ✅ Implemented — see Section 5

`OMSRFND` journal name, D365 setup, and OMS service (`import#RefundPaymentJournalsDataPackage`) are fully documented in Section 5. Kept the D365 setup steps below since they're one-time environment configuration, not something Section 5 repeats.

#### D365 Setup: Journal Name and Posting Batch

**Step 1 — Create the journal name.** Navigate to **General Ledger → Journal setup → Journal names**:

| Field | Value |
| :--- | :--- |
| Name | `OMSRFND` |
| Description | `OMS Return Refund Payment Journal` |
| Journal type | `Customer payment` |
| Voucher series | Reuse OMSPAY number sequence or create a dedicated one with a `RFND-` prefix — confirm with accounting |

**Step 2 — Configure the auto-posting batch job.** Navigate to **General Ledger → Journal entries → Post journals**. Create a batch job separate from the OMSPAY posting job:

| Setting | Value |
| :--- | :--- |
| Journal type | `Customer payment` |
| Journal name | `OMSRFND` |
| Posted | `No` |
| Late selection | `Yes` |
| Run in background | `Yes` |
| Recurrence | After the credit note posting batch has completed — sequencing matters for settlement |

> [!IMPORTANT]
> The OMSRFND posting batch must run **after** the credit note batch (`SalesFormLetter_Invoice`). The custom `HotWaxAutoPostSettlementService` requires both sides (credit note and refund journal) to be posted before it can settle them. See [D365 setup issue #27](https://github.com/hotwax/dynamics365-integration/issues/27).

### Phase 6: Settlement (Proposed — Not Yet Implemented)

> [!NOTE]
> This section documents a **proposed approach**, not a built/verified implementation — unlike Phases 1–5 above. It reflects design research and a matching strategy worked out ahead of implementation. Treat field names and joins here as the intended design, to be confirmed against a real D365 environment before coding (see the verification callout in Section 6.4.4).

#### 6.1 Why OOTB D365 Settlement Won't Work Here

Same fundamental limitation already documented for sales order settlement (see [`sales-orders/invoice_settlement.md`](../sales-orders/invoice_settlement.md) Section 5.1): both OOTB mechanisms — **Automatic settlement** (`AR Parameters > Settlement`) and the **Periodic settlement batch** — operate at the **customer account level using FIFO by due date**. Neither has any concept of "this credit note belongs to return X" or "this invoice is the exchange order for return X."

This is worse for returns than for plain sales orders: a single customer can easily have an open credit note, an open refund journal, and an open exchange invoice all sitting on their account at once. FIFO-by-date settlement would happily net the wrong pair together — for example, applying an unrelated customer's older refund credit against a completely different return's invoice — silently producing correct-looking dollar totals with the wrong underlying transactions closed.

- **Reference:** [Settlement overview](https://learn.microsoft.com/en-us/dynamics365/finance/cash-bank-management/settlement-overview)
- **Reference:** [Automatic settlement and prioritization](https://learn.microsoft.com/en-us/dynamics365/finance/accounts-receivable/automatic-settlement-prioritization)

#### 6.2 Confirmed: D365 Settlement Is Not Limited to Invoice-Against-Payment

Before designing around it, it's worth being explicit that D365's settlement engine is not restricted to "one invoice + one payment." Microsoft's own documentation describes settlement generically as **"the process of settling an invoice against a payment or credit note,"** and separately documents a **Replacement order / "Apply credit"** flow (Commerce call center) where an even exchange is explicitly settled by **manually settling the credit note against the replacement order's invoice** — invoice-to-invoice, no payment involved at all.

Mechanically this isn't a special case: a credit note is simply a negative-signed Invoice-type `CustTrans` record. The `CustTrans::settleTransaction` API (the same non-obsolete "mark-and-settle" API `HotWaxAutoPostSettlementService` already uses via `SpecTransExecutionContext`/`SpecTransManager`) marks arbitrary `CustTrans` records for settlement regardless of type — invoice, credit note, or payment — and nets them. So "settle a return's credit note against a brand-new exchange order's invoice" requires no new D365-side API or capability; it's the exact same primitive already in use, applied to a different pair of transactions.

- **Reference:** [Settle a partial customer payment that has discounts on credit notes](https://learn.microsoft.com/en-us/dynamics365/finance/accounts-receivable/settle-partial-payment-discounts-credit-notes) — includes a worked "Settle a credit note with an invoice" example
- **Reference:** [Refund payment processing in call centers — Replacement orders](https://learn.microsoft.com/en-us/dynamics365/commerce/call-center-refund-payments#replacement-orders)

#### 6.3 Why the Existing `HotWaxAutoPostSettlementService` Can't Be Reused As-Is

The sales-order settlement service (Section 5.2 of `sales-orders/invoice_settlement.md`) is hardcoded around assumptions that don't hold for returns:

- It only collects invoices where `custTransInvoice.AmountCur > 0` — a return's credit note is negative and would never be picked up.
- Its only matching path is `payment.PaymReference == invoice.CustInvoiceJour.SalesId` — there is no path for matching one invoice-type `CustTrans` against another invoice-type `CustTrans` (needed for the exchange scenarios), since `PaymReference` only exists on payment/refund **journal lines**, never on an invoice or credit note itself.

Per the earlier decision on this project, the right approach is a **new, separate service** for return/exchange settlement rather than bolting negative-amount and invoice-to-invoice branches onto the sales-order-specific service.

#### 6.4 Proposed Approach: New `HotWaxAutoPostReturnSettlementService`

A new X++ class, structurally modeled on `HotWaxAutoPostSettlementService` — same `SpecTransExecutionContext` / `SpecTransManager` / `CustTrans::settleTransaction` pattern, same capped-amount logic (`min(remaining, amountToSettle)`) to avoid over-marking when multiple transactions apply to one side.

##### 6.4.1 The Missing Link: How to Find an Exchange Order's Invoice

`PaymReference` (used for step 2/4 below) only exists on payment/refund journal lines — it doesn't help find the **exchange order's invoice** for the "Same Value Exchange" case, where no journal is created at all (see business_processes.md Section 7.3). Something has to carry the return↔exchange relationship onto the exchange order itself.

The proposed fix reuses a pattern **already implemented** in this same codebase for a structurally identical problem — linking a *return* order back to its *original* sales order:

```xml
<!-- D365ReturnServices.xml, sync#ReturnOrder — already implemented -->
CustomersOrderReference: returnId,
CustomerRequisitionNumber: d365SalesOrderNumber,   ← original order's D365 SalesId, stamped onto the return order
```

`CustomerRequisitionNumber` (OData) / `PurchOrderFormNum` (X++, on `SalesTable`) is a standard, freely-settable AR field — not a retail/commerce extension — so it survives through to `CustInvoiceJour`/`CustTrans` after invoicing, the same way `SalesId` does. The proposal is to set it one hop later in the same chain: when OMS syncs the **exchange order** to D365 (`sync#SalesOrders` in `D365OrderServices.xml`), stamp `CustomerRequisitionNumber = d365ReturnOrderNumber` — the linked return's D365 SalesId — mirroring the existing return-order line exactly.

**Where the return↔exchange link comes from on the OMS side:** OMS already tracks this relationship via the standard OFBiz field `ReturnItemResponse.replacementOrderId` (extended with `returnId` in `HwmappsEntitymodel.xml`), populated today by the Shopify exchange flow (`shopify-oms-bridge`). This is not a new mechanism invented for D365 — `mantle-netsuite-connector/service/co/hotwax/netsuite/OrderServices.xml` already queries this exact field (`replacementOrderId = order.orderId`) to resolve an exchange order's originating return for NetSuite export, so D365 would be reusing an established, already-proven-elsewhere linkage rather than adding a new one.

> [!NOTE]
> **Confirmed:** `ReturnItemResponse.replacementOrderId` is currently populated only by the Shopify-triggered exchange flow — but Shopify is the only exchange-creation channel in scope for this integration today, so this is not a gap. If a non-Shopify exchange-creation path is added later (e.g. a POS/in-store RMA flow), this field's population would need to be revisited at that time.

> [!CAUTION]
> **Naming caveat, accepted for now:** `CustomerRequisitionNumber` / `PurchOrderFormNum` is semantically a "customer's purchase order number" field — repurposing it to carry a D365 SalesId (return order number) is a field-reuse decision made because it's the one standard, freely-settable field proven to survive header → invoice (see verification below), not because it's the "correct" field for this purpose. This mirrors the same reuse tradeoff already accepted for `OrderPaymentPreference.finAccountId` in the refund payment journal design (Section 5.5). Flagged here so this reuse is revisited if D365 ever exposes a more purpose-built cross-reference field (see also TODO #20 in Section 6, "Common Shopify Order Id" — a more semantically correct long-term alternative).

##### 6.4.2 Matching Strategy — Four Lookups Per Return

For each return with an open credit note, the service performs up to four lookups, each keyed off the previous one's D365 SalesId — no date-based or FIFO logic anywhere:

| # | Lookup | Match Key | Covers |
| :--- | :--- | :--- | :--- |
| 1 | Open credit note | `CustInvoiceJour.SalesId = <return's D365 order number>`, `AmountCur < 0` | Every scenario — this is the anchor |
| 2 | Refund payment journal(s) | `PaymReference = SalesId` from step 1 | Pure cash refund **and** the lower-value exchange's leftover cash-back remainder |
| 3 | Exchange order invoice | `PurchOrderFormNum = SalesId` from step 1, `AmountCur > 0` | Same-value, higher-value, and lower-value exchange (whenever an exchange order exists) |
| 4 | Difference payment journal | `PaymReference = SalesId` from step 3 (the exchange order's own SalesId) | Higher-value exchange only — the customer's payment for the price difference, using the **existing**, already-implemented sales-order payment journal flow (`OMSPAY`) unmodified |

Whatever isn't found at a given step is simply not marked — no special-casing needed. A pure store-credit return (no refund journal, no exchange order) marks only the credit note, finds no counterpart, and it stays open on the customer account, which is the correct outcome. A lower-value store-credit exchange (step 3 found, no refund at step 2) leaves exactly the remaining difference open, matching business_processes.md Section 7.5's "Store Credit" option.

This single method covers all six rows of the "Per-Scenario Settlement Logic" table in `business_processes.md` Section 7.6:

| Scenario | Transactions Marked | Steps Used |
| :--- | :--- | :--- |
| Pure Return — Store Credit | Credit note only (left open) | 1 |
| Pure Return — Cash Refund | Credit note + Refund journal | 1, 2 |
| Same Value Exchange | Credit note + Exchange invoice | 1, 3 |
| Higher Value Exchange | Credit note + Exchange invoice + Difference payment | 1, 3, 4 |
| Lower Value — Store Credit | Credit note + Exchange invoice (remainder left open) | 1, 3 |
| Lower Value — Cash Refund | Credit note + Exchange invoice + Refund journal | 1, 2, 3 |

##### 6.4.3 Trigger Mechanism

Proposed as a **periodic batch**, consistent with every existing D365-side job in this integration (`HotWaxAutoPostSettlementService`, `HotWaxAutoPostArrivalJournalService`) — no new D365-to-OMS or OMS-to-D365 callback path is required, and the service can run entirely self-contained inside D365 the same way settlement already does for sales orders. Event-driven triggering (e.g. firing immediately after the exchange invoice posts) would reduce settlement lag but requires a new integration point that doesn't exist today; it's an additive change that can be layered on later without reworking the matching logic above, since the logic itself doesn't depend on how it's invoked.

##### 6.4.4 Pre-Implementation Verification ✅ Completed

Two checks were identified before writing the X++, both now verified:

1. **`PurchOrderFormNum` survives header → invoice on `CustInvoiceJour`.** Verified directly against a real D365 dev-instance record rather than assumed from field documentation alone.

   **Why this needed checking:** `HotWaxAutoPostSettlementService` already proves `SalesId` survives the same header → invoice hop (it joins on `custInvoiceJour.SalesId` today), but that says nothing about whether `PurchOrderFormNum` — a different field — is carried through the same way. D365's invoice-posting pipeline could in principle copy some header fields onto `CustInvoiceJour` and not others, and the two fields in question sit on different order types in our flow (`SalesId` is read off a return order's invoice; the settlement design needs `PurchOrderFormNum` off a **regular Sales Order's** invoice, since the exchange order is `OrderType = Sales order`, not `Returned order`) — so evidence from one doesn't automatically transfer to the other.

   **How it was verified:** using D365's built-in raw table browser, reachable by appending `?cmp=usmf&mi=SysTableBrowser&tablename=CustInvoiceJour` to the environment URL. This reads the table directly, bypassing whatever limited field set a given form happens to expose (the posted-invoice UI form, by comparison, only surfaced a minimal set of fields and wasn't sufficient on its own).

   **What was found:** Sales Order `001217` (`OrderType = Sales order`) had `CustomerRequisitionNumber = RMA 00085` set on its header. Its posted invoice's `CustInvoiceJour` record, found via `SysTableBrowser`, showed the same value under the `PurchOrderFormNum` column (labeled "Purchase order" in that grid). Confirms the field is safe to join on for Step 3 of Section 6.4.2.

   > [!TIP]
   > `SysTableBrowser` is the recommended verification method for similar "does this field survive D365's posting pipeline" questions going forward — it's faster and more conclusive than working through UI form field visibility/Personalize settings.

2. **`ReturnItemResponse.replacementOrderId` population coverage** — confirmed Shopify-only, which is sufficient for current scope. See the note in Section 6.4.1.

#### 6.5 Summary Table

| Scenario | Settlement |
| :--- | :--- |
| Simple return + refund | Credit note (`-`) + Refund journal (`+`) ↔ Original invoice (`+`) |
| Exchange same value | Credit note (`-`) ↔ Exchange invoice (`+`) — no journal needed |
| Exchange higher value | Credit note + difference payment journal ↔ Exchange invoice |
| Exchange lower value (store credit) | Credit note ↔ Exchange invoice; remaining open credit stays on account |
| Exchange lower value (refund) | Credit note ↔ Exchange invoice + refund journal |

**Proposed implementation:** New `HotWaxAutoPostReturnSettlementService` (X++), matching via `SalesId` (credit note / exchange invoice) and `PaymReference` (payment/refund journals) as detailed in Section 6.4 above — not an extension of the existing sales-order `HotWaxAutoPostSettlementService`.
