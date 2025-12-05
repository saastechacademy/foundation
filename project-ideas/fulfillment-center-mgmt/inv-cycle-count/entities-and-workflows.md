# **Entities Owned by the Inventory Cycle Count Microservice**

This document defines the **core entities fully owned and managed** by the **Inventory Cycle Count microservice**. These entities constitute the microservice’s private domain model and represent the state related to cycle count runs, sessions, count lines, status history, decisions, and locking.

The microservice:
- **Creates, updates, and deletes** these entities.
- Treats them as its **source of truth** for cycle count operations.
- References (but does not own) system-of-record data such as Product, InventoryItem, Facility, etc.

The application framework is responsible for enforcing multi‑tenancy and cross‑service ownership policies at the data‑record level. Within that framework, **`WorkEffort` rows representing cycle count runs (e.g., `workEffortTypeId = CYCLE_COUNT_RUN`) are owned by this microservice.**


---

## 1) Entities in Scope

### A. WorkEffort (context container)
- **Role**: Represents a store-wide count run (e.g., Annual Hard Count).
- **workEffortTypeId**: CYCLE_COUNT_RUN 
- **WorkEffortPurposeType**: HARD_COUNT, DIRECTED_COUNT
- **Why it matters**: Gives every session a shared context for planning, reporting, and audit.
- **Status Lifecycle** (for type `CYCLE_CNT_STATUS`):
  - `CREATED → IN_PROGRESS → COMPLETED → CLOSED` (with `CANCELLED` as an exit path).
  - This lifecycle controls when sessions can be created, submitted, and included in reporting.
- **Allowed Transitions**:
  - `CREATED → IN_PROGRESS`
  - `IN_PROGRESS → COMPLETED`
  - `COMPLETED → CLOSED`
  - `CREATED/IN_PROGRESS/COMPLETED → CANCELLED`
  - **Not allowed**: moving backward (e.g., `COMPLETED → IN_PROGRESS`).

### B. InventoryCountImport (counting session)
- **Role**: One record per staff session (one person counting a portion of the store during the run).
- **Key ideas**: Basic lifecycle, session approval controls inclusion.
- **Status Lifecycle**:
  - `CREATED' → ASSIGNED → SUBMITTED → APPROVED` (with `VOID` as an exit path).
- **Allowed Transitions**:
  - `CREATED → ASSIGNED`
  - `ASSIGNED → SUBMITTED`
  - `ASSIGNED → VOIDED` 
  - `SUBMITTED → APPROVED` or `SUBMITTED → VOIDED`
  - `APPROVED → VOIDED` (only by store manager for corrections)
  - **Not allowed**: moving from `APPROVED` back to `SUBMITTED`.

### C. InventoryCountImportItem (count lines)
- **Role**: One line per product counted in a session; optional association to a store location.
- **Key ideas**: Raw evidence of what was physically counted; no workflow/status at item level.

### D. StatusItem / Enumeration (supporting)
- **Role**: Provides controlled status codes and count type enums.
- **Key ideas**: Enables a clean, lightweight session workflow and optional count-type tagging.

### E. [InventoryVarDcsnRsn](./apply-count-to-inventory.md) 
- **Role**: Captures structured reasons for variance decisions when applying counts to inventory.
- Variance decisions are stored per-run, per-facility, per-product, not per session.

### F. InventoryCountImportLock (session locking per device)
- **Session Locking**: Stores active device lock for a session using InventoryCountImportLock with:
    - leaseSeconds auto-expiration
    - lastHeartbeatAt heartbeats
    - optional override (overrideByUserId, overrideReason)
- **PK: (inventoryCountImportId, fromDate)**
---

## 2) Suggested Changes

### InventoryCountImport (Session)
- **Add**: `workEffortId` (link each session to the count run).
- **Add**: `facilityAreaId` (**optional, nullable, no FK**) – loose area tag for human comprehension and filtering.
- **Add**: `approvedDate` (**optional**) – timestamp when the session was approved (useful for audit and reporting).
- **Keep**: `statusId` with lifecycle and transitions noted above.

### InventoryCountImportItem (Line)
- **Remove**: item-level `statusId` (no item workflow in Phase 1).
- **Keep**: `locationSeqId` as **optional** (stores may not have formal locations).
- **Keep**: dual identity (`productId` and/or a scannable identifier field) to support flexible capture. `uuid` for offline-first identity.
- **Clarify**: `quantity` semantics—non-negative integers; allow zero to indicate “counted none”.
- **Add**: `isRequested` (Y/N) marks whether the item was pre-seeded by the manager (`Y`) or discovered during scanning (`N`).

### WorkEffort
- **Use**: an existing type to represent a count run (e.g., `CYCLE_COUNT_RUN`).
- **Add clarity**: WorkEffort status lifecycle and allowed transitions.
- **Link**: Sessions tied to a WorkEffort ensure traceability and consolidated reporting.

### StatusItem / Enumeration
- **Use**: existing mechanisms to support the session lifecycle and optional `countTypeEnumId` tagging (e.g., HARD_COUNT).

---

## 3) Workflows Enabled

### Workflow 1: Plan & Launch an Annual Hard Count
1. HQ creates a **WorkEffort** representing the annual store count (status = `PLANNED`).
2. When status moves to **IN_PROGRESS**, store manager creates **InventoryCountImport** sessions (one per staff member).
3. Optional: tag sessions with a loose **facilityAreaId** for readability (Front, Backroom, Jewelry Case, etc.).

**Value**: Clear container for the run; everyone works in the same context.

---

### Workflow 2: Capture Counts (Staff Sessions)
1. Staff member opens their **InventoryCountImport** session and counts.
2. Each product counted is recorded as an **InventoryCountImportItem** line with a **quantity**.
3. Optional: add **location** if the store uses locations; otherwise leave blank.

**Value**: Simple, low-friction capture that works in stores without formal location systems.

---

### Workflow 3: Submit & Approve Sessions
1. Staff marks session **SUBMITTED** when done.
2. Store manager reviews and sets session to **APPROVED** (or **VOID** if incorrect).
3. Inclusion for reporting is **only** sessions with status **APPROVED**.

**Value**: Operational control rests with store manager; easy to explain and enforce.

---

### Workflow 4: Consolidated Count View (for HQ & Store)
1. The system aggregates **approved** sessions within a **WorkEffort** to show counted quantity **per product per facility**.
2. **Not-Found With On-Hand** Aggregate to a per-product counted QOH and compare to system QOH; anything with system > 0 & counted = 0 should be highlighted in the variance preview.
3. This is a **computed view** (no persistent roll-up in Phase 1).
4. Reports can highlight potential overlaps (informational only) without blocking approval.

**Value**: Fast visibility into counted quantities without extra storage or complexity.

---

### Workflow 5: Corrective Actions (Operational)
1. If a session was approved by mistake, manager can **VOID** it.
2. If an area needs recounting, create a **new session** to capture the fresh count.
3. Run-level dashboards reflect only approved sessions, so corrections are immediate.

**Value**: Simple, forgiving process—stores can fix mistakes quickly.

---

# **Summary Diagram (Conceptual)**

```
WorkEffort (Run)  -- referenced -->  InventoryVarDcsnRsn (Variance Decision)
        │                                       ▲
        │                                       │
        └───< owns multiple >── InventoryCountImport (Session)
                                   │      ▲
                                   │      │
                < owns multiple >──┘      └──< tracks history >── InvCountImportStatus
                                   │
                                   └──< owns multiple >── InventoryCountImportItem (Count Line)

InventoryCountImportLock applies to InventoryCountImport sessions.
```

