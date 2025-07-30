**Inventory Cycle Count – Design and Data Model Overview**

This document defines the business story and supporting entity model for implementing year-end hard inventory counts in a retail environment.

---

## Business Process Overview

**Scenario:**
A retail organization with multiple stores conducts an **annual hard inventory count** across all store locations. Each store is divided into physical zones (e.g., back room, sales floor). The process ensures total physical stock is recorded and reconciled against the system inventory.

---

## Actors and Roles

* **Retail Director** schedules an **Inventory Count Run** (modeled as a `WorkEffort` with type `INVENTORY_COUNT_RUN`).
* **Store Manager** organizes the counting effort locally by assigning employees to specific store areas.
* **Store Employees** each perform a count in one zone. No two employees count the same zone to avoid double-counting.

---

## Workflow Summary

1. **Scheduling:**

  * The Retail Director creates a `WorkEffort` of type `INVENTORY_COUNT_RUN`.

2. **Counting Sessions:**

  * Each employee is assigned a zone to count.
  * The Store Manager creates a corresponding `InventoryCountImport` record for each employee’s session.
  * Products and their counted quantities are recorded in `InventoryCountImportItem`.

3. **Processing and Consolidation:**

  * Once all counts are complete, the system aggregates product quantities at the store level.
  * The aggregated result is recorded in `FacilityProductCountVariance`.
  * All entities are linked via `workEffortId` to the parent `WorkEffort`.

4. **Traceability:**

  * The system tracks which sessions contributed to each variance via `FacilityProductCountVarianceImport`.

---

## Data Model

### `WorkEffort`

* **Purpose**: Represents the scheduled count event.
* **Type**: `INVENTORY_COUNT_RUN`

---

### `InventoryCountImport`

* **Purpose**: Represents a single employee’s counting session.
* **Key Fields**:

  * `inventoryCountImportId` (PK)
  * `workEffortId` (FK → `WorkEffort`)
  * `facilityId`, `countImportName`, `countTypeEnumId`, `statusId`, `dueDate`, etc.

---

### `InventoryCountImportItem`

* **Purpose**: Records the quantity counted per product-location per session.
* **Key Fields**:

  * Composite PK: (`inventoryCountImportId`, `importItemSeqId`)
  * `productId`, `locationSeqId`, `quantity`, `statusId`, etc.

---

### `FacilityProductCountVariance`

* **Purpose**: Records consolidated variance per product per facility.
* **Key Fields**:

  * Composite PK: (`workEffortId`, `facilityId`, `productId`)
  * `consolidatedQuantity`: Total counted quantity
  * `systemQuantityOnHand`: Expected from system
  * `varianceQuantityOnHand`: Difference
  * `countDate`, `totalValue`, `valueVariance`
* **Relation**:

  * `workEffortId` (FK → `WorkEffort`)

---

### `FacilityProductCountVarianceImport`

* **Purpose**: Tracks which count sessions contributed to each variance.
* **Key Fields**:

  * Composite PK: (`workEffortId`, `facilityId`, `productId`, `inventoryCountImportId`)
* **Relation**:

  * FK to `InventoryCountImport`
  * FK to `FacilityProductCountVariance`

---

