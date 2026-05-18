# OMS to D365 Return Sync — Implementation Plan

## Overview

This document outlines the technical implementation plan for syncing completed return orders from OMS to Dynamics 365 (D365) using the D365 OData REST APIs. The sync is **event-driven**, triggered when a `ReturnHeader` reaches `RETURN_COMPLETED` status, and covers both **online (Shopify)** and **POS** returns.

The implementation follows a modular architecture to ensure maintainability, testability, and reuse between real-time and batch processes.

---

## Design Philosophy

- **Modularity**: Separation of mapping logic, API communication, and workflow orchestration.
- **Idempotency**: Use of the entity `D365ReturnHeaderHistory` to guarantee "at-most-once" synchronization.
- **Stateless Mapping**: Transformation services should be pure logic, making them easy to unit test.
- **Robust Error Handling**: Explicit tracking of transient vs. permanent failures to support auto-retries in sweep jobs.

## Scope

### Phase 1 — Event-Driven Return Sync (Current)
- Create a **Return Order Header** in D365 via `POST /data/ReturnOrderHeadersV2`
- Create **Return Order Lines** in D365 via `POST /data/ReturnOrderLinesV2`
- Track sync status per return to ensure idempotency
- Handle failures gracefully with logging
- Create Arrival Journal for each Return Order Receiving
- Post Arrival Journals - Batch Job in D365
- Post Packing Slip of Return Orders - Batch Job in D365
- Create Invoice for Return Orders - this generates Credit Note Invoice
- Create Payment Journals for Refunds
- Settlement
- Return reason code mapping (`CustomerReturnReasonCode`)
- Return Disposition code mapping (`ReturnDispositionCode`)

### Phase 2
- Sweep/fallback batch job — to be added after event-driven flow is stable

---

## Implementation Details

### Layer 1 — New Entity

#### Entity `D365ReturnHeaderHistory`

Tracks the sync state for each return so the process is idempotent and auditable.

| Field | Type | Notes |
|---|---|---|
| `returnId` | id (PK) | OMS return ID |
| `d365ReturnOrderNumber` | text-short | D365 `ReturnOrderNumber` from create response |
| `d365RmaNumber` | text-short | D365 RMA number associated with the return order |
| `syncStatusId` | text-short | e.g., `D365_RTN_PENDING`, `D365_RTN_SYNCED`, `D365_RTN_ERROR` |
| `syncedDate` | date-time | Timestamp of successful sync |
| `lastUpdatedStamp` | date-time | Auto-managed |

> **Architecture Note**
> The entity `D365ReturnHeaderHistory` should remain a header-level history entity, not an item-level one.
> If the implementation needs robust handling for partial line sync scenarios, add a separate child entity such as `D365ReturnLineHistory` keyed by `returnId + returnItemSeqId`.
> This keeps the header history focused on the overall return state, while line history tracks which specific return items were synced, failed, or remain pending.
>
> This is preferable to using D365 read calls as part of normal retry logic because:
> - the integration should maintain its own authoritative sync state
> - retries can target only failed or pending lines
> - support teams can see exactly what did and did not sync
> - unnecessary D365 lookup calls are avoided during normal processing
>
> **Implementation decision**
> For this return sync flow, `returnId` is kept as the PK of the entity `D365ReturnHeaderHistory` instead of using a separate surrogate PK field.
> This is an intentional exception to the more generic pattern used by some other history entities because the header-history record is expected to be exactly one row per OMS return, and using `returnId` as the PK makes that constraint explicit in the data model.

Recommended header-level statuses:
- `D365_RTN_PENDING` - header created locally, sync not completed yet
- `D365_RTN_SYNCED` - all eligible return lines synced successfully
- `D365_RTN_PARTIAL` - header exists in D365 but one or more lines failed or remain pending
- `D365_RTN_ERROR` - header-level failure or no line synced successfully

#### Entity `D365ReturnLineHistory`

Tracks sync state for each OMS return item so partial success can be retried safely without re-sending already synced lines.

| Field | Type | Notes |
|---|---|---|
| `returnId` | id (PK) | OMS return ID |
| `returnItemSeqId` | id (PK) | OMS return item sequence |
| `d365ReturnOrderNumber` | text-short | D365 return order number for the parent return |
| `syncStatusId` | text-short | e.g., `D365_RTN_PENDING`, `D365_RTN_SYNCED`, `D365_RTN_ERROR` |
| `syncedDate` | date-time | Timestamp of successful line sync |
| `lastAttemptDate` | date-time | Timestamp of most recent attempt |
| `logText` | text-long | Error/response details for support and retry analysis |
| `lastUpdatedStamp` | date-time | Auto-managed |

Recommended usage:
- create or update one line-history row per `ReturnItem`
- mark line `SYNCED` immediately after a successful D365 line create
- mark line `ERROR` immediately when that specific line fails
- do not re-send lines already marked `SYNCED`
- use line-history rows as the primary source of truth for retries instead of querying D365 for normal control flow

#### View-entity `D365EligibleReturnView` — *Phase 2 / Sweep Job*

> **Note:** This view-entity is **not required for the event-driven implementation**. In the event-driven flow, the `returnId` is delivered directly by the DataFeed, and the orchestration service checks the entity `D365ReturnHeaderHistory` by that specific `returnId`. This view-entity is only needed for the **sweep job** (Phase 2), where the service job independently discovers all eligible returns that haven't been synced.

Joins the entity `ReturnHeader` with the entity `D365ReturnHeaderHistory` to identify returns that are completed but not yet synced to D365.

Key conditions:
- `ReturnHeader.statusId != 'RETURN_CANCELLED'` — uses `not-equals` rather than `= RETURN_COMPLETED` to also capture online returns that are still in intermediate states (e.g. `RETURN_REQUESTED`) but have not been cancelled
- No corresponding `D365ReturnHeaderHistory` entity record (LEFT JOIN, null check) — return was never synced
- OR `D365ReturnHeaderHistory.syncStatusId != 'D365_RTN_SYNCED'` — return was attempted but not successfully synced (retry eligible)

---

### Layer 2 — Seed Data

#### Seed file `D365ReturnSyncFeedData.xml`

#### DataDocuments (Event Triggers)

| DataDocument ID | Root Entity | Condition | Purpose |
|---|---|---|---|
| `D365OnlineReturnHeaderDoc` | `ReturnHeader` | `statusId = RETURN_REQUESTED` AND `returnChannelEnumId != POS_RTN_CHANNEL` | Triggers sync for online returns when initiated |
| `D365PosReturnHeaderDoc` | `ReturnHeader` | `statusId = RETURN_COMPLETED` AND `returnChannelEnumId = POS_RTN_CHANNEL` | Triggers sync for POS returns when completed |

> **Why two DataDocuments?**
> - **Online returns** (`returnChannelEnumId != POS_RTN_CHANNEL`) are created at `RETURN_REQUESTED`. D365 must have the Return Order before warehouse receiving (Arrival Journal) can happen, so we sync early.
> - **POS returns** (`returnChannelEnumId = POS_RTN_CHANNEL`) skip `RETURN_REQUESTED` and are directly created at `RETURN_COMPLETED` in OMS, so we trigger on `RETURN_COMPLETED` for those.
> - Both documents feed into the single service `sync#D365ReturnOrder`

Internal orchestration service that fetches OMS return data and calls the D365 wrappers. Uses the `SystemMessageRemote` entity pattern for authentication with D365 APIs.

#### DataFeed

- **Feed ID:** `D365ReturnsFeed`
- **Feed Type:** `DataFeedService`
- **Service name:** `co.hotwax.d365.D365ReturnServices.sync#ReturnOrder`
- **Documents:** `D365OnlineReturnHeaderDoc`, `D365PosReturnHeaderDoc`

#### ServiceJob (Sweep — Phase 2)
- **Service job id:** `sync_D365ReturnOrders`
- **Service:** Calls the orchestration service directly using the view-entity `D365EligibleReturnView`
- Added later as a fallback for missed/disabled feed events

---

### Layer 3 — Service Architecture

To keep the implementation simple and cohesive, all return-related logic is consolidated into a single service file.

#### Consolidated Service File: `D365ReturnServices.xml`

**Package:** `co.hotwax.d365`

##### 1. Transformation Logic (Mappers)
- **Service `get#ReturnOrderHeaderData`**:
    - **Input**: `returnId`
    - **Output**: `Map headerData` (JSON-ready)
    - **Logic**: Implements field mappings; includes branching logic to handle different `returnHeaderTypeId` values (e.g., `CUSTOMER_RETURN`, `APPEASEMENT`, `REFUND_ONLY`).
- **Service `get#ReturnOrderLineData`**:
    - **Input**: `returnItem` (Map or List of `ReturnItem`)
    - **Output**: `List<Map> linesData`

##### 2. Adapter Logic (IO)
- **Service `send#ReturnOrderHeader`**: Executes `POST /data/ReturnOrderHeadersV2`. Returns `ReturnOrderNumber`.
- **Service `send#ReturnOrderLines`**: Executes `POST /data/ReturnOrderLinesV2` for each line.

##### 3. Orchestration Logic
- **Service `sync#ReturnOrder`**:
    - **Input**: `returnId`
    - **Flow**:
        1. Check the entity `D365ReturnHeaderHistory`. Skip if `D365_RTN_SYNCED`.
        2. Call the service `get#ReturnOrderHeaderData`.
        3. Call the service `send#ReturnOrderHeader`.
        4. Call the service `get#ReturnOrderLineData`.
        5. Call the service `send#ReturnOrderLines`.
        6. Update the entity `D365ReturnHeaderHistory` with `syncStatusId` and `ReturnOrderNumber`.
        7. On any failure, catch exception and mark status as `D365_RTN_ERROR`.

#### Recommended Runtime Behavior for Partial Line Sync

To support safe retries and better observability, the orchestration should process returns using both header and line history.

Recommended flow:
1. Load the entity `D365ReturnHeaderHistory` for the `returnId`; create one in `D365_RTN_PENDING` if missing.
2. Resolve or create the D365 return header and store `d365ReturnOrderNumber` in header history.
3. Load all `ReturnItem` records for the return.
4. For each return item, load or create the entity `D365ReturnLineHistory` keyed by `returnId + returnItemSeqId`.
5. Skip any line already marked `D365_RTN_SYNCED`.
6. Attempt to create the D365 return line for each remaining item.
7. Update the line-history row immediately after each line attempt:
   - `D365_RTN_SYNCED` on success
   - `D365_RTN_ERROR` on item-specific failure
8. Continue processing remaining lines even if one line fails, unless the failure is header-level or systemic and would cause all remaining lines to fail.
9. After all lines are attempted, derive the header status from line statuses:
   - `D365_RTN_SYNCED` if all lines are synced
   - `D365_RTN_PARTIAL` if some lines are synced and some are not
   - `D365_RTN_ERROR` if the header failed or no line synced successfully

Examples of failures where the service should stop remaining lines:
- D365 return header could not be created or resolved
- authentication/token failure
- D365 service unavailable for the entire request set
- missing shared mapping required by all lines

Examples of failures where the service should continue remaining lines:
- one item missing product mapping
- one item rejected due to item-specific validation
- one line request times out while header and other lines are still valid

---

### Layer 4 — Operational Support

#### Event Triggers (DataDocuments)
- **Structured Filtering**: Uses `<conditions>` elements in `DataDocument.xml` to filter events at the database level rather than in service logic.
    - `D365OnlineReturnHeaderDoc`: Filters for `RETURN_REQUESTED` AND `returnChannelEnumId != POS_RTN_CHANNEL`.
    - `D365PosReturnHeaderDoc`: Filters for `RETURN_COMPLETED` AND `returnChannelEnumId == POS_RTN_CHANNEL`.

#### Error Handling & Retries
- **Transient Failures** (e.g., Timeout, 503): The orchestration service catches these and marks the history entity record for retry. The Phase 2 sweep job will pick up `D365_RTN_ERROR` records and attempt a re-sync.
- **Permanent Failures** (e.g., 400 Bad Request, Missing Mapping): Logged specifically to the field `D365ReturnHeaderHistory.logText` for manual intervention.

---

#### Key Field Mappings (OMS → D365)

| D365 Field | OMS Source |
|---|---|
| `dataAreaId` | `ProductStoreSetting` (settingTypeEnumId=D365_DATA_AREA_ID) |
| `CustomerAccountNumber` | `PartyIdentification.idValue` (type=`D365_CUSTOMER_ID`) on `fromPartyId` |
| `InvoiceCustomerAccountNumber` | Same as `CustomerAccountNumber` |
| `CustomersOrderReference` | `ReturnHeader.returnId` |
| `CustomerRequisitionNumber` | `OrderIdentification` (Shopify order name) on linked `orderId` |
| `CustomerReturnReasonCode` | Deferred — hardcode or omit for now |
| `CurrencyCode` | `ReturnHeader.currencyUomId` |
| `DefaultReturnSiteId` | `FacilityIdentification` (type=`D365_SITE_ID`) |
| `DefaultReturnWarehouseId` | `FacilityIdentification` (type=`D365_WAREHOUSE_ID`) |
| `ReturnAddress*` | `FacilityContactDetailByPurpose` on `destinationFacilityId` |
| `LanguageId` | Hardcoded `en-us` or ProductStore config |
| `ReturnOrderNumber` (line) | From header create response |
| `ItemNumber` | `GoodIdentification` (type=`D365_PRODUCT_ID`) on `productId` |
| `ReturnSalesQuantity` | `-1 * ReturnItem.returnQuantity` |
| `ReturnSiteId` | Same as `DefaultReturnSiteId` |
| `ReturnWarehouseId` | Same as `DefaultReturnWarehouseId` |
| `SalesPrice` | `ReturnItem.returnPrice` |
| `ReturnDispositionCode` | Deferred — omit for now |

---

## D365 OData API Reference

### Create Return Order Header
```
POST {{d365_url}}/data/ReturnOrderHeadersV2
Content-Type: application/json

{
  "dataAreaId": "usmf",
  "CustomerAccountNumber": "<from PartyIdentification>",
  "InvoiceCustomerAccountNumber": "<same>",
  "CustomersOrderReference": "<returnId>",
  "CustomerRequisitionNumber": "<shopify order name>",
  "CustomerReturnReasonCode": "<deferred>",
  "CurrencyCode": "<currencyUomId>",
  "DefaultReturnSiteId": "<FacilityIdentification D365_SITE_ID>",
  "DefaultReturnWarehouseId": "<FacilityIdentification D365_WAREHOUSE_ID>",
  "Email": "",
  "LanguageId": "en-us",
  "ReturnAddressDescription": "<facilityName>",
  "ReturnAddressStreet": "<address1>\n<address2>",
  "ReturnAddressCity": "<city>",
  "ReturnAddressStateId": "<stateGeoCodeAlt>",
  "ReturnAddressZipCode": "<postalCode>",
  "ReturnAddressCountryRegionId": "<countryGeoCodeAlt>"
}
```

### Create Return Order Line
```
POST {{d365_url}}/data/ReturnOrderLinesV2
Content-Type: application/json

{
  "dataAreaId": "usmf",
  "ReturnOrderNumber": "<from header response>",
  "ItemNumber": "<GoodIdentification D365_PRODUCT_ID>",
  "ReturnSalesQuantity": <-1 * returnQuantity>,
  "ReturnSiteId": "<D365_SITE_ID>",
  "ReturnWarehouseId": "<D365_WAREHOUSE_ID>",
  "SalesPrice": <returnPrice>,
  "ReturnDispositionCode": "<deferred>"
}
```

---

## Open Questions / Decisions
1. **Parameterizing `systemMessageRemoteId` for DataFeeds**: The standard Moqui DataFeed mechanism does not support passing custom parameters to the receiver service. Currently, `sync#ReturnOrder` uses a hardcoded default (`D365_HotWax_Sandbox`). We need a standard solution to resolve the correct remote instance ID dynamically (e.g., via ProductStore mapping or global configuration) to avoid hardcoding.

2. **Need for line-level history**: Since a return header may sync successfully while only some return lines are created in D365, should we introduce a separate `D365ReturnLineHistory` entity keyed by `returnId + returnItemSeqId` to track partial success and support targeted retries without querying D365 as part of normal integration processing?

---

## Verification Plan

1. Trigger a `RETURN_COMPLETED` status change on a test return in OMS
2. Confirm the DataFeed fires and calls the orchestration script
3. Verify `ReturnOrderHeadersV2` is called with correct payload
4. Verify `ReturnOrderLinesV2` is called for each return item
5. Confirm `D365ReturnHeaderHistory` is created with `D365_RTN_SYNCED`
6. Test idempotency — re-trigger the same return and confirm it is skipped
7. Test error scenario — invalid customer ID and confirm `D365_RTN_ERROR` is logged
