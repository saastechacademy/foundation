
# **Directed Cycle Count**

## **Business Context**

Retailers often need to perform **directed cycle counts**:

* The system or auditors identify specific SKUs that must be counted.
* A store manager receives this task as a **work effort** (e.g., “count these 50 SKUs today”).
* The manager assigns the work to one or more associates, who go onto the sales floor or stockroom and scan the requested items.

---

## **Entities & Key Fields**

We use **existing entities**, avoiding new ones.
The **`InventoryCountImportItem`** entity is extended with:

* **`isRequested` (Y/N)**: marks whether the item was pre-seeded by the manager (`Y`) or discovered during scanning (`N`).

Other existing fields are reused:

* `scannedQty` → quantity collected locally via scan events.
* `quantity` → quantity last synced with server.
* `productId` → the SKU.
* `inventoryCountImportId` → session identifier (one per associate).

---

## **Workflow**

### 1. Work Effort Assignment

* System generates a work effort for a directed count (list of SKUs).
* Store manager is responsible for executing it.

### 2. Manager Seeds the List

* Manager creates an **InventoryCountImport** for each associate.
* For each SKU in the directed list, the system pre-seeds an `InventoryCountImportItem` row with:

    * `isRequested = Y`
    * `quantity = 0`
    * `scannedQty = 0`

This creates the **expected list** in the associate’s PWA.

### 3. Associate Scans

* Associate scans items on the floor.
* Behavior:

    * If SKU matches a seeded row → increment `scannedQty` on that row.
    * If SKU not in seeded list → create new row with:

        * `isRequested = N`
        * `quantity = 0`
        * `scannedQty = 1`

This captures both **requested** and **unexpected** findings.

### 4. Background Sync

* A background process periodically pushes updates to server:

    * Select rows where `scannedQty > quantity`.
    * Post **absolute count** (`scannedQty`).
    * On success, update `quantity = scannedQty`.

This ensures local scans eventually become the **system of record**.

### 5. Completion

* Associate completes their session in the PWA.
* Final sync ensures all rows are pushed.
* System validates whether all `isRequested=Y` items were scanned.
* If any requested items remain with `scannedQty=0`, manager must either:

    * Reject completion, or
    * Approve with variance.

### 6. Reconciliation

The manager reviews results using simple filters:

* **Counted as requested**: `isRequested=Y AND scannedQty > 0`
* **Missing requested SKUs**: `isRequested=Y AND scannedQty = 0`
* **Unexpected SKUs**: `isRequested=N AND scannedQty > 0`

This reconciles what was **asked** vs what was **delivered**.

### 7. Outcomes

* Approved counts are applied to inventory via the standard “apply count” service.
* Variances are logged for audit:

    * Missing SKUs → possible shrinkage or process gaps.
    * Unexpected SKUs → misplaced stock or errors in product master.

---

## **Benefits of `isRequested` Design**

* **Simplicity**: No new entities or complex joins.
* **Transparency**: One flag distinguishes “planned vs found.”
* **Scalability**: Works for single-associate or multi-associate counts (each gets their own `InventoryCountImport`).
* **Auditability**: Easy to report on requested, missing, and unexpected items.

---

## **Example**

Directed list = SKUs \[A, B, C].

* Manager seeds items:

    * A → (`isRequested=Y`, `scannedQty=0`)
    * B → (`isRequested=Y`, `scannedQty=0`)
    * C → (`isRequested=Y`, `scannedQty=0`)

* Associate scans A, B, D, E.

    * A → (`isRequested=Y`, `scannedQty=1`)
    * B → (`isRequested=Y`, `scannedQty=1`)
    * C → (`isRequested=Y`, `scannedQty=0`)
    * D → (`isRequested=N`, `scannedQty=1`)
    * E → (`isRequested=N`, `scannedQty=1`)

* Reconciliation:

    * ✅ Counted requested: A, B
    * ❌ Missing requested: C
    * ➕ Unexpected: D, E

---
