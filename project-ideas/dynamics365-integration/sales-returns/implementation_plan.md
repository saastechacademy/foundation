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

### Future Phases (Not yet in scope — see Section 7)
- Arrival journal posting (D365 batch)
- Packing slip posting (D365 batch)
- Credit note generation
- Refund payment journal
- Settlement

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

---

## 5. TODOs by Approach

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

### Future Phases — Downstream Lifecycle (see Section 7)

| # | Item | Details |
| :--- | :--- | :--- |
| 9 | Arrival journal creation via DMF | ✅ Implemented — `queue#ArrivalJournals` sweeps `D365EligibleArrivalJournals` and packages returns into a DMF ZIP using the "Item arrival journals V2" composite entity. See Section 4 for full details. |
| 10 | Arrival journal posting | D365 batch class `WMSJournalCheckPostReception` — needs D365-side setup. Decide: OMS-triggered per journal or manual warehouse staff action. |
| 11 | Credit note generation | D365 batch class `SalesFormLetter_Invoice` — runs after packing slip posted (or immediately for Credit only disposition). |
| 12 | Credit note export back to OMS | Export generated credit note number back to OMS for reconciliation — similar to sales order number export. |
| 13 | Refund payment journal | New `sync#ReturnRefund` service. Triggered when OMS confirms refund issued. Must be gated on credit note existing in D365. |
| 14 | Settlement | Extend `HotWaxAutoPostSettlementService` to settle credit note + refund journal against original invoice. Handle exchange scenarios. |
| 15 | Custom composite entity (D365) | If high volume requires DMF path — D365 dev to build `ReturnOrderCompositeV1` entity duplicating the sales order composite pattern. |

---

## 6. Verification Plan

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

---

## 7. Future Phases — Downstream Lifecycle

The following steps complete the full return lifecycle in D365 after the return order is created. These are **not yet in scope** but are documented here for planning purposes based on research from Microsoft Learn and the D365 community thread.

### Phase 3: Arrival Journal DMF Sync ✅ Implemented

**When:** `queue_D365ArrivalJournals` ServiceJob sweeps eligible returns after their return order is `D365_RTN_SYNCED`.

OMS packages returns into a DMF ZIP using the "Item arrival journals V2" composite entity and submits via Queue Connector. See Section 4 for the full implementation details.

**Remaining for Phase 3:**

| Step | Detail |
| :--- | :--- |
| D365 posts arrival journal | Batch class `WMSJournalCheckPostReception` — triggers per journal |
| Limitation | Not a query-based auto-batch; one journal at a time; bulk posting requires extending the class to multi-threaded like `LedgerJournalMultiPost` |

**Decision pending:** OMS-triggered vs. D365 warehouse staff manual for arrival journal posting.

### Phase 4: Credit Note Generation

| Step | Detail |
| :--- | :--- |
| Who triggers | D365 batch class `SalesFormLetter_Invoice` |
| Prerequisite | Return line must be in `Received` status (arrival registered + packing slip posted, OR `Credit only` disposition) |
| Output | Credit note with negative amount |
| OMS sync-back | Credit note number should be exported back to OMS for reconciliation (similar to sales order number export) |

### Phase 5: Refund Payment Journal

| Step | Detail |
| :--- | :--- |
| Trigger | OMS confirms refund was issued via payment gateway |
| Gate | Only create after credit note exists in D365 |
| OMS service | New `sync#ReturnRefund` service, reuses `CustomerPaymentJournalHeaders` + `CustomerPaymentJournalLines` pattern |
| Amount sign | Positive (company pays customer) — opposite of payment journals for sales orders |
| `PaymentReference` | Original D365 Sales Order Number (for settlement matching) |

### Phase 6: Settlement

| Scenario | Settlement |
| :--- | :--- |
| Simple return + refund | Credit note (`-`) + Refund journal (`+`) ↔ Original invoice (`+`) |
| Exchange same value | Credit note (`-`) ↔ New invoice (`+`) — no journal needed |
| Exchange higher value | Credit note + payment journal ↔ New invoice |
| Exchange lower value (store credit) | Credit note ↔ New invoice; remaining open credit stays on account |
| Exchange lower value (refund) | Credit note ↔ New invoice + refund journal |

**Implementation:** Extend existing `HotWaxAutoPostSettlementService` to handle credit note settlement using `SalesId == PaymReference` matching.
