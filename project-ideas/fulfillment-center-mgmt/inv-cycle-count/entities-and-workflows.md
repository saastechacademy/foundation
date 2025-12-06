# **Entities Owned by the Inventory Cycle Count Microservice**

This document describes the **core entities owned and managed** by the **Inventory Cycle Count microservice**. These entities represent runs, sessions, count lines, status history, variance decisions, and locking. The microservice creates/updates/deletes these and treats them as the source of truth; system-of-record data (Product, InventoryItem, Facility, etc.) is referenced, not owned.

The application framework enforces multi‑tenancy and ownership. Within that, **`WorkEffort` rows for cycle counts use `workEffortTypeId = CYCLE_COUNT_RUN` and are owned by this microservice.** For entities the microservice only references (Product, Facility, etc.), see `cycle_count_integration_entities.md`.

---

## 1) Entities in Scope

### A. WorkEffort (context container)
- **Role**: Represents a store-wide count run (e.g., annual hard count).
- **Type/Purpose**: `workEffortTypeId = CYCLE_COUNT_RUN`; `workEffortPurposeTypeId` = `HARD_COUNT` or `DIRECTED_COUNT`.
- **Status Lifecycle** (IDs): `CYCLE_CNT_CREATED → CYCLE_CNT_IN_PRGS → CYCLE_CNT_CMPLTD → CYCLE_CNT_CLOSED`, with `CYCLE_CNT_CNCL` as an exit from each stage.
- **Why it matters**: Provides shared context for planning, reporting, and audit; sessions link here and inherit facility context.

### B. InventoryCountImport (session)
- **Role**: One record per staff counting session within a run.
- **Fields present**: `inventoryCountImportId`, `countImportName`, `uploadedByUserLogin`, `parentCountId`, `statusId`, `createdDate`, `dueDate`, **`workEffortId`** (run link), **`facilityAreaId`**, **`approvedDate`**.
- **Status Lifecycle** (IDs): `SESSION_CREATED → SESSION_ASSIGNED → SESSION_SUBMITTED → SESSION_APPROVED`, with `SESSION_VOIDED` as an exit.
- **Notes**: Facility is carried on `WorkEffort`, not on this entity.

### C. InventoryCountImportItem (count line)
- **Role**: One line per product counted in a session; optional association to a store location.
- **Fields present**: (`inventoryCountImportId`, `importItemSeqId`), `locationSeqId`, `productId`, `productIdentifier`, `quantity` (decimal), `countedByUserLoginId`, `createdDate`, `createdByUserLoginId`, **`uuid`**, **`isRequested`**.
- **Indexes**: on `uuid` and `productId`.
- **Notes**: No item-level `statusId`.

### D. StatusItem / Enumeration (supporting)
- **Run statuses**: `CYCLE_CNT_CREATED`, `CYCLE_CNT_IN_PRGS`, `CYCLE_CNT_CMPLTD`, `CYCLE_CNT_CNCL`, `CYCLE_CNT_CLOSED`.
- **Session statuses**: `SESSION_CREATED`, `SESSION_ASSIGNED`, `SESSION_SUBMITTED`, `SESSION_APPROVED`, `SESSION_VOIDED`.
- **Count purpose**: `DIRECTED_COUNT`, `HARD_COUNT` (applies to `WorkEffort.workEffortPurposeTypeId`).
- **Variance enums**: reasons (`ANNUAL_COUNT_ADJUSTMENT`, `MANAGER_OVERRIDE`, `PARTIAL_SCOPE_POST`, `CORRECTION_AFTER_REVIEW`); outcomes (`APPLIED`, `SKIPPED`).

### E. InventoryVarDcsnRsn (variance decision)
- **Role**: Stores per-run, per-facility, per-product variance decisions and outcomes; links to PhysicalInventory/InventoryItemVariance when applied.

### F. InventoryCountImportLock (session locking per device)
- **Role**: Stores active device lock for a session with lease/heartbeat/override.
- **PK**: (`inventoryCountImportId`, `fromDate`).

---

## 2) Workflows Enabled (conceptual)

1) **Plan & launch a run**: Create `WorkEffort` (`CYCLE_COUNT_RUN`, purpose `HARD_COUNT`/`DIRECTED_COUNT`) and move through run statuses as work progresses.  
2) **Capture counts**: Create `InventoryCountImport` sessions under the run; record `InventoryCountImportItem` lines per product with optional location/area.  
3) **Submit & approve sessions**: Progress session status from `SESSION_CREATED` to `SESSION_APPROVED` (void as needed); reporting includes approved sessions.  
4) **Variance decision**: Store decisions per (`workEffortId`, `facilityId`, `productId`) in `InventoryVarDcsnRsn` using the reason/outcome enums.  
5) **Session locking**: Use `InventoryCountImportLock` to ensure one active device per session with lease/override controls.  
