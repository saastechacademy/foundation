# useInventoryCountRun — Design Document

* **Domain:** Inventory Count **Run** modeled as a `WorkEffort`
    * `workEffortTypeId = INVENTORY_COUNT_RUN`
    * `workEffortPurposeTypeId ∈ {HARD_COUNT, DIRECTED_COUNT}`
* **Relationship:** One **Run** contains one or more **InventoryCountImport** sessions.

---

## 1) Lifecycles & Transitions

### Run (WorkEffort) lifecycle

* **States:** `PLANNED → IN_PROGRESS → COMPLETED → CLOSED` (exit: `CANCELLED`)
* **Allowed transitions:**
  `PLANNED → IN_PROGRESS`, `IN_PROGRESS → COMPLETED`, `COMPLETED → CLOSED`,
  `PLANNED/IN_PROGRESS/COMPLETED → CANCELLED`
* **Not allowed:** backward moves (e.g., `COMPLETED → IN_PROGRESS`).

---
##2)
---
## 3) Data Model (local mirrors; no code)

### New local table: `inventoryCountRuns` (Run Header Mirror)

* **Identity:** `workEffortId` (PK)
* **Fields:** `purposeTypeId`, `facilityId`, `plannedStartDate`, `estimatedCompletionDate`, `statusId`, `createdBy`, `meta` (JSON for UI hints), `lastSyncedAt`

---

## 4) Responsibilities & Outcomes (what must exist after implementation)

### 4.1 Planner actions (run-level)

* **Create run:** create local header (`PLANNED`), then push to server; persist authoritative `workEffortId` and `lastSyncedAt`.
* **Edit header:** update local header fields; push patch; reconcile on success.
* **Start run:** move to `IN_PROGRESS` **only if** ≥1 session exists in `ASSIGNED` or `IN_PROGRESS`. If not, block with actionable error.
* **Complete run:** allowed when all sessions are in a terminal state (`APPROVED` or `VOID`); otherwise show “needs attention” list with force-complete option (requires reason).
* **Cancel run:** allowed per transitions; set `CANCELLED` and exclude from forward reporting.

### 4.2 Session orchestration (within run)

* **Add session:** validate concurrency (no user/device with two active sessions); create `InventoryCountImport` linked to `workEffortId`.
* **Remove session:** 
* **Reassign sessions:** rebind associate/device for selected sessions; re-evaluate concurrency rule.

---

## 5) Run-Level Rollups (derived, never stored)

All rollups are **computed** from session items.

* **Data sources:**

    * `InventoryCountImport` (session status gates inclusion)
    * `InventoryCountImportItem` (quantities, lastScanAt per SKU)&#x20;
* **Inclusion rule:** **Only `APPROVED` sessions** contribute to consolidated totals and completion metrics.&#x20;
* **Metrics to expose:**

    * `totalSkusAssigned` (Directed: unique SKUs across all sessions within run)
    * `totalCounted` (Σ quantities across **approved** sessions)

---

## 6) Sync Strategy (clean boundary)

* **Run header sync (this composable):** independent, small payload; maintain a simple push lock (`syncStatus`) to prevent overlapping header pushes.

---

## 7) Guards, Immutability & Conflict Policy

* **Concurrency:** an associate/device cannot hold two active sessions concurrently; block creation/assignment if violated.
---

