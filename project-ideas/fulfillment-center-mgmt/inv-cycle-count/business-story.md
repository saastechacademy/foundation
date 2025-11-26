# Business Stories Leading to Cycle Counts

This document captures the **two primary business stories** that motivate and shape the cycle count process in retail operations. These scenarios form the foundation for our cycle count project.

---

## **Story 1: Annual Hard Count**

### Context
- At the end of the fiscal year, retailers must conduct a **full physical inventory count** to close their books accurately.
- This process is typically mandated by finance and audit requirements.

### Workflow
1. The **Head of Retail** schedules a count run for each store (`WorkEffort` of type `INVENTORY_COUNT_RUN`).
2. The **Store Manager** organizes the team to perform the count within a limited time window (e.g., Dec 31–Jan 2).
3. Each staff member is assigned a physical area (sales floor, backroom, etc.) to ensure coverage and avoid double counting.
4. Staff perform a full count of their assigned area, logging counts in `InventoryCountImport` and `InventoryCountImportItem`.
5. “Not-Found With On-Hand” during a Hard Count: the system shows QOH > 0 for a SKU at the store, but during the hard count nothing is physically found (counted = 0). This can be caused by mis-slots, shrinkage, damaged/held items, in-flight/unposted moves, or simple data drift.
6. The Store Manager reviews all sessions, confirms accuracy, and submits results to HQ.

### Outcome
- Provides a complete snapshot of physical inventory across all stores at year-end.
- Enables reconciliation with book inventory for financial reporting.
- Establishes a baseline for future cycle counts and variances.

---

## **Story 2: Directed Cycle Count**

### Context
- Outside of year-end, **directed cycle counts** are performed to validate inventory accuracy in targeted situations.
- These are often triggered by operational signals such as:
  - Frequent rejections during order fulfillment.
  - High variance in stock movements (transfers, returns).
  - Products flagged as high-value or high-risk (e.g., shrinkage-prone).

### Workflow
1. HQ or the system schedules a **Directed Count** as a `WorkEffort`.
2. The **Store Manager** assigns staff to recount specific products or areas identified as problematic.
3. Staff perform a focused count of only those items/areas, recording counts in `InventoryCountImport` and `InventoryCountImportItem`.
4. Results are reviewed by the Store Manager and submitted to HQ.

### Outcome
- Improves inventory accuracy by addressing specific problem areas.
- Provides explainability for operational issues (e.g., why orders were rejected).
- Reduces shrinkage and improves trust in inventory data without requiring a full hard count.

---

## **Summary**
- **Annual Hard Counts**: Broad, mandatory, finance-driven events ensuring end-of-year accuracy.
- **Directed Cycle Counts**: Targeted, operationally driven checks that improve accuracy continuously.

Both stories complement each other: the hard count establishes a baseline, while directed counts maintain accuracy throughout the year.

---

## 3. **Executing Cycle Count**

### A. Single session, single device (happy path)

1. User starts a counting **import session** on Device A.
2. Scans items; app records scan events.
3. Background process periodically pushes updates to server.
4. User completes the count; final push succeeds.
   **Expectations:** Instant scans, no duplicates, server matches local totals.

### B. Session paused, then resumed on the **same device**

1. User pauses (closes app/locks device) mid-session.
2. Later resumes on same Device.
3. App does a quick **inbound refresh** from the server and reconciles local data.
4. Background push resumes; user continues counting.
   **Expectations:** Local and server re-align before pushing.

### C. Session paused, resumed on a **different device**

1. User starts on Device A, pauses.
2. Later resumes on Device B.
3. On Device B: app performs **inbound refresh first**, rebuilding local state avoid collisions.
4. Counting continues; background push handles updates.
   **Expectations:** No duplicate creates; updates on Device B use the correct server PKs created earlier on Device A.

### D. Single Active Counting Session per User

For cycle counts, each **InventoryCountImportId** (counting session) is assigned to exactly **one user at a time**, and each user may have **only one active session** at any moment—regardless of which device they use. Starting another session requires the current one to be finished, paused, or explicitly closed. While a session is active, **all scanning, aggregation, and sync** must target **only that session**, and batch uploads must contain items for **one session only**. This constraint prevents duplicate or conflicting work, preserves PK/idempotency guarantees, and simplifies reconciliation and audit/auditability.

---

## Explainability and Auditability for Inventory Adjustments

To ensure compliance, transparency, and operational trust, every inventory adjustment resulting from a cycle count is accompanied by a structured explanation. For each variance between counted and system inventory, the system requires a documented reason and outcome (e.g., adjustment applied, skipped, or overridden). This creates a complete audit trail, allowing management and auditors to trace every inventory change back to its business context, decision rationale, and responsible user.

This approach supports:
- Regulatory and financial audit requirements
- Operational transparency and accountability
- Easier investigation and correction of discrepancies

---

### E. **Inventory Adjustment Explanation**

A cycle-count/hard-count WorkEffort has approved sessions and a computed variance preview (counted vs. system). Manager has the decision UI with for-each-SKU options: Apply, Skip + Reason (required). The Store Manager reviews cycle-count discrepancies and decides per SKU and posts approved adjustments into inventory.

Post Batch (one click)
When the manager clicks Post Variances for the selected set, System creates a PhysicalInventory header (posting batch for facility/date). For each APPLIED SKU, the system creates one InventoryItemVariance line and references to PhysicalInventory and the InventoryVarDcsnRsn record.

Entities in play: InventoryVarDcsnRsn (decision), PhysicalInventory (posting header), InventoryItemVariance (line delta), InventoryItemDetail (ledger diff), InventoryItem (book balance).

### F. **Reporting**

WorkEffort scoped:

**WorkEffort → InventoryVarDcsnRsn → InventoryItemVariance → PhysicalInventory**
Since PhysicalInventory has no workEffortId, all WorkEffort-scoped reporting must drive off InventoryVarDcsnRsn and (when applied) join to InventoryItemVariance via (inventoryItemId, physicalInventoryId), then to PhysicalInventory.

Decision Report (complete story): drive off InventoryVarDcsnRsn filtered by workEffortId → join to InventoryItemVariance to PhysicalInventory where present.

Posted Variance Report (what hit the books): drive off InventoryVarDcsnRsn with outcome='APPLIED' → join to InventoryItemVariance to PhysicalInventory where present.

### G. **Export Applied Variances to ERP (WorkEffort Scope)**
Selection Logic
**WorkEffort → InventoryVarDcsnRsn (outcome = APPLIED) → InventoryItemVariance → PhysicalInventory**
- Start from `InventoryVarDcsnRsn.workEffortId`.
- Join to the variance line by **composite key** (`inventoryItemId`,`physicalInventoryId`).
- Join to `PhysicalInventory` for header fields (date, party, comments).

# Non-Functional Requirements for Cycle Count PWA (Store Associate Scanning)

### 1. **Offline-First**

* The application must function reliably without network connectivity.
* All scans must be captured and stored locally on the device until connectivity is available.
* Data persistence must guarantee zero data loss across app crashes, reloads, or device restarts.

### 2. **Scan Reliability**

* Every barcode scan must be recorded immediately and without delay.
* The system must guarantee **no missed scans**, even when scanning at maximum practical speed with a wireless barcode scanner.
* Each scan event should be atomic: once captured, it is safely persisted before any other processing occurs.

### 3. **Performance Priority**

* The highest priority is **capturing scan events**.
* Secondary operations (e.g., aggregating scans by SKU, background synchronization with server) must never degrade scanning performance.
* The scan input must always remain in focus to minimize associate interruptions.

### 4. **Background Processing**

* Tasks such as aggregating counts and syncing data to the backend (Moqui services) are **low-priority**.
* These tasks must execute in the background and defer automatically if they risk impacting scan capture.
* Background retries must ensure eventual consistency with the server once connectivity is available.

### 5. **Data Integrity**

* Scans must be persisted with timestamp, product identifier, and device/session metadata.
* Counts are based on raw scan events; aggregations are computed later for display or reporting.

### 6. **Usability**

* The scan field should always be ready to accept input (no manual refocus required).
* The interface must be optimized for **fast repetitive scanning** with minimal interaction from the associate.

---
