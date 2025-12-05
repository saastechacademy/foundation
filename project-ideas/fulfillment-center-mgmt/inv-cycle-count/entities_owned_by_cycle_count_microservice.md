# **Entities Owned by the Inventory Cycle Count Microservice**

This document defines the **core entities fully owned and managed** by the **Inventory Cycle Count microservice**. These entities constitute the microservice’s private domain model and represent the state related to cycle count runs, sessions, count lines, status history, decisions, and locking.

The microservice:
- **Creates, updates, and deletes** these entities.
- Treats them as its **source of truth** for cycle count operations.
- References (but does not own) system-of-record data such as Product, InventoryItem, Facility, etc.

The application framework is responsible for enforcing multi‑tenancy and cross‑service ownership policies at the data‑record level. Within that framework, **`WorkEffort` rows representing cycle count runs (e.g., `workEffortTypeId = CYCLE_COUNT_RUN`) are owned by this microservice.**

---

# **1. WorkEffort (Cycle Count Run)**
**Conceptual name:** `CountRun`

A **Cycle Count Run** is the store‑wide context for a set of one or more sessions. It is represented by a `WorkEffort` record with `workEffortTypeId = CYCLE_COUNT_RUN`.

### **Key Responsibilities**
- Define the high‑level scope and purpose of a cycle count (e.g., directed, hard count).
- Tie the run to a facility or group of facilities.
- Track run‑level status and timing.

### **Key Fields**
- `workEffortId` — primary key
- `workEffortTypeId = CYCLE_COUNT_RUN`
- `statusId` — run status (CYCLE_CNT_CREATED, CYCLE_CNT_IN_PRGS, CYCLE_CNT_CMPLTD, CYCLE_CNT_CLOSED, CYCLE_CNT_CNCL)
- `facilityId`
- `cycleCntPurposeEnumId` (e.g., DIRECTED_COUNT, HARD_COUNT)
- `createdDate`, `estimatedStartDate`, `estimatedCompletionDate`

---

# **2. InventoryCountImport (Cycle Count Session)****
**Conceptual name:** `CountSession`

A Cycle Count Run (store-wide count event) is represented in `WorkEffort` and owned by the microservice. Each run contains one or more **sessions**, which are represented by this entity.

A **session** is the unit of work for a user or device. It contains count lines and moves through its own workflow lifecycle.

### **Key Responsibilities**
- Holds metadata about a counting session.
- Tracks session-level status (created, assigned, submitted, approved, voided).
- Groups all count lines produced by a user/device.

### **Key Fields**
- `inventoryCountImportId` — primary key
- `countImportName`
- `facilityId`
- `statusId` — session status (SESSION_CREATED, SESSION_ASSIGNED, etc.)
- `parentCountId`
- `uploadedByUserLogin`
- `createdDate`, `dueDate`
- Optional relationship to `WorkEffort` (run)

### **Lifecycle**
`SESSION_CREATED → SESSION_ASSIGNED → SESSION_SUBMITTED → SESSION_APPROVED`
(with `SESSION_VOIDED` as an exit state)

---

# **2. InventoryCountImportItem (Count Line)**
**Conceptual name:** `CountLine`

Represents a **single counted product** in a specific location, recorded by a worker during a session.

### **Key Responsibilities**
- Store the raw evidence of physical counting.
- Capture location, product, identification, and quantity.
- Associate with the session that generated it.

### **Key Fields**
- Composite PK: `inventoryCountImportId`, `importItemSeqId`
- `locationSeqId` (FK → FacilityLocation)
- `productId`
- `productIdentifier` (barcode/alternate ID)
- `quantity`
- `countedByUserLoginId`
- `createdDate`, `createdByUserLoginId`

---

# **3. InvCountImportStatus (Session & Line Status History)**
**Conceptual name:** `CountSessionStatusHistory`

Tracks changes to a session’s status (and optionally individual items' status).

### **Key Responsibilities**
- Preserve a complete audit trail of status transitions.
- Track who performed the transition and when.

### **Key Fields**
- `invCountImpStatusId` — primary key
- `inventoryCountImportId`
- `importItemSeqId` (optional – when tied to a specific line)
- `statusId` — references `StatusItem`
- `statusDate`
- `changeByUserLoginId`

---

# **4. InventoryVarDcsnRsn (Variance Decision Record)**
**Conceptual name:** `VarianceDecision`

This is the microservice’s **reconciliation output record**. It stores counted vs system quantities, computed variance, and the decision taken (apply or skip). When applied, it may link to ERP/OMS records.

### **Key Responsibilities**
- Represent the result of reconciling counted quantities with system quantities.
- Record the decision reason (manager override, partial scope post, etc.).
- Record the decision outcome (APPLIED or SKIPPED).
- Drive further integration (InventoryItemVariance, PhysicalInventory).

### **Key Fields**
- Composite PK: `workEffortId`, `facilityId`, `productId`
- `countedQuantity`
- `systemQuantity`
- `varianceQuantity`
- `decisionReasonEnumId` (FK → INV_VAR_DECISION_RSN)
- `decisionOutcomeEnumId` (APPLIED/SKIPPED)
- `decidedByUserLoginId`, `decidedDateTime`
- Optional integration fields:
  - `inventoryItemId` (only when APPLIED)
  - `physicalInventoryId` (only when APPLIED)

---

# **5. InventoryCountImportLock (Session Lock)**
**Conceptual name:** `CountSessionLock`

Provides concurrency control so that only one device/user can actively work on a session at a time.

### **Key Responsibilities**
- Track who currently holds the lock.
- Track heartbeat and duration for lock expiry.
- Support override and forced release.

### **Key Fields**
- Composite PK: `inventoryCountImportId`, `fromDate`
- `userId`
- `deviceId`
- `leaseSeconds`
- `lastHeartbeatAt`
- `overrideByUserId`, `overrideReason`
- `createdByUserLoginId`

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

---

# **What This Microservice Owns**
The microservice fully owns and manages:
- `WorkEffort` rows with workEffortTypeId = CYCLE_COUNT_RUN (Cycle Count Runs)
- `InventoryCountImport` (sessions)
- `InventoryCountImportItem` (count lines)
- `InvCountImportStatus` (status history)
- `InventoryVarDcsnRsn` (variance decisions)
- `InventoryCountImportLock` (locking)

These entities form the **internal state machine** of the cycle count microservice.
