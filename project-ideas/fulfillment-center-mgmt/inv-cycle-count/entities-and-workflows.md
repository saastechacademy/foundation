# Entities, Suggested Changes, and Enabled Workflows

---

## 1) Entities in Scope

### A. WorkEffort (context container)
- **Role**: Represents a store-wide count run (e.g., Annual Hard Count).
- **WorkEffortPurposeType**: HARD_COUNT, DIRECTED_COUNT
- **Why it matters**: Gives every session a shared context for planning, reporting, and audit.
- **Status Lifecycle** (for type `INVENTORY_COUNT_RUN`):
  - `PLANNED → IN_PROGRESS → COMPLETED → CLOSED` (with `CANCELLED` as an exit path).
  - This lifecycle controls when sessions can be created, submitted, and included in reporting.
- **Allowed Transitions**:
  - `PLANNED → IN_PROGRESS`
  - `IN_PROGRESS → COMPLETED`
  - `COMPLETED → CLOSED`
  - `PLANNED/IN_PROGRESS/COMPLETED → CANCELLED`
  - **Not allowed**: moving backward (e.g., `COMPLETED → IN_PROGRESS`).

### B. InventoryCountImport (counting session)
- **Role**: One record per staff session (one person counting a portion of the store during the run).
- **Key ideas**: Basic lifecycle, session approval controls inclusion.
- **Status Lifecycle**:
  - `ASSIGNED → IN_PROGRESS → SUBMITTED → APPROVED` (with `VOID` as an exit path).
- **Allowed Transitions**:
  - `ASSIGNED → IN_PROGRESS`
  - `IN_PROGRESS → SUBMITTED`
  - `SUBMITTED → APPROVED` or `SUBMITTED → VOID`
  - `APPROVED → VOID` (only by store manager for corrections)
  - **Not allowed**: moving from `APPROVED` back to `SUBMITTED`.

### C. InventoryCountImportItem (count lines)
- **Role**: One line per product counted in a session; optional association to a store location.
- **Key ideas**: Raw evidence of what was physically counted; no workflow/status at item level.

### D. StatusItem / Enumeration (supporting)
- **Role**: Provides controlled status codes and count type enums.
- **Key ideas**: Enables a clean, lightweight session workflow and optional count-type tagging.

### E. [FacilityProdInvVarDcsnRsn]([facility-prod-inv-var-dcsn-rsn.md])
- **Role**: Captures structured reasons for variance decisions when applying counts to inventory.
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
- **Keep**: dual identity (`productId` and/or a scannable identifier field) to support flexible capture.
- **Clarify**: `quantity` semantics—non-negative integers; allow zero to indicate “counted none”.

### WorkEffort
- **Use**: an existing type to represent a count run (e.g., `INVENTORY_COUNT_RUN`).
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
2. This is a **computed view** (no persistent roll-up in Phase 1).
3. Reports can highlight potential overlaps (informational only) without blocking approval.

**Value**: Fast visibility into counted quantities without extra storage or complexity.

---

### Workflow 5: Corrective Actions (Operational)
1. If a session was approved by mistake, manager can **VOID** it.
2. If an area needs recounting, create a **new session** to capture the fresh count.
3. Run-level dashboards reflect only approved sessions, so corrections are immediate.

**Value**: Simple, forgiving process—stores can fix mistakes quickly.

---

