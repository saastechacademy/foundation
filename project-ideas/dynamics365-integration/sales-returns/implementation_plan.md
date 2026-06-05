# OMS to D365 Returns — Implementation Plan

This document covers the technical design, integration approaches evaluated, service architecture, field mappings, and phased implementation plan for syncing returns from HotWax OMS to Dynamics 365 F&O.

For D365 standard return process, disposition codes, accounting model, and lifecycle overview see [business_processes.md](./business_processes.md).

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

### Future Phases (Not yet in scope — see Section 7)
- Arrival journal creation via OData
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

### 3.2 Data Model

#### Entity: `D365ReturnHeaderHistory`

Tracks the aggregate sync state per return. PK is `returnId` (one row per OMS return — no surrogate key needed).

| Field | Type | Notes |
| :--- | :--- | :--- |
| `returnId` | id (PK) | OMS return ID |
| `d365ReturnOrderNumber` | text-short | D365 `ReturnOrderNumber` from create response |
| `d365RmaNumber` | text-short | D365 RMA number |
| `syncStatusId` | id | `D365_RTN_PENDING` / `D365_RTN_SYNCED` / `D365_RTN_PARTIAL` / `D365_RTN_ERROR` |
| `syncedDate` | date-time | Timestamp of successful sync |
| `logText` | text-long | Error details |

#### Entity: `D365ReturnLineHistory`

Tracks per-line sync state for partial success and targeted retry.

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
| `CustomerReturnReasonCode` | `IntegrationTypeMapping(D365_RTN_REASON)` | ⚠️ **Hardcoded to `39`** — mapping TODO |
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
| `ReturnDispositionCode` | `IntegrationTypeMapping(D365_RTN_DISPOSITION)` | ⚠️ **Hardcoded to `11`** — mapping TODO |
| `ProductSizeId` | `ProductFeature(SIZE)` | ⚠️ **Not yet implemented** — variant TODO |
| `ProductColorId` | `ProductFeature(COLOR)` | ⚠️ **Not yet implemented** — variant TODO |

### 3.7 Integration Type Mappings Needed

| Mapping Type | OMS Source | D365 Target | Notes |
| :--- | :--- | :--- | :--- |
| `D365_RTN_REASON` | OMS `ReturnHeader.returnReasonEnumId` | D365 `CustomerReturnReasonCode` | Not yet defined |
| `D365_RTN_DISPOSITION` | OMS return reason or item condition | D365 `ReturnDispositionCode` | Not yet defined; hardcoded to `11` currently |

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

## 4. TODOs by Approach

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

### Future Phases — Downstream Lifecycle (see Section 6)

| # | Item | Details |
| :--- | :--- | :--- |
| 9 | Arrival journal creation | For online returns — OMS signals goods received → `POST ItemArrivalJournalHeadersV2` + `POST ItemArrivalJournalLinesV2` |
| 10 | Arrival journal posting | D365 batch class `WMSJournalCheckPostReception` — needs D365-side setup. Decide: OMS-triggered per journal or manual warehouse staff action. |
| 11 | Credit note generation | D365 batch class `SalesFormLetter_Invoice` — runs after packing slip posted (or immediately for Credit only disposition). |
| 12 | Credit note export back to OMS | Export generated credit note number back to OMS for reconciliation — similar to sales order number export. |
| 13 | Refund payment journal | New `sync#ReturnRefund` service. Triggered when OMS confirms refund issued. Must be gated on credit note existing in D365. |
| 14 | Settlement | Extend `HotWaxAutoPostSettlementService` to settle credit note + refund journal against original invoice. Handle exchange scenarios. |
| 15 | Custom composite entity (D365) | If high volume requires DMF path — D365 dev to build `ReturnOrderCompositeV1` entity duplicating the sales order composite pattern. |

---

## 5. Verification Plan

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

---

## 6. Future Phases — Downstream Lifecycle (Design Pending)

The following steps complete the full return lifecycle in D365 after the return order is created. These are **not yet in scope** but are documented here for planning purposes based on research from Microsoft Learn and the D365 community thread.

### Phase 3: Arrival Journal (Online Returns)

**When:** OMS signals goods received (`RETURN_RECEIVED` or equivalent)

| Step | Detail |
| :--- | :--- |
| OMS creates arrival journal | `POST /data/ItemArrivalJournalHeadersV2` + `POST /data/ItemArrivalJournalLinesV2` |
| D365 posts arrival journal | Batch class `WMSJournalCheckPostReception` — triggers per journal |
| Limitation | Not a query-based auto-batch; one journal at a time; bulk posting requires extending the class to multi-threaded like `LedgerJournalMultiPost` |

**Decision pending:** OMS-triggered vs. D365 warehouse staff manual for arrival registration.

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
