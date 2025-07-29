**Inventory Cycle Count Feature - Entity Overview**

This document outlines the core entities involved in the Inventory Cycle Count feature of the warehouse system. These entities support the import, tracking, counting, and variance analysis of inventory across locations.

---

## Business Requirement Overview: Hard Inventory Count Across Stores

**Context**:
A retail business operates across multiple store locations. Each store has multiple inventory zones — for example, a customer-facing front floor and a back room. Once a year, typically at the end of the financial period, the business conducts a comprehensive (hard) inventory count at every location.

**Business Goal**:
To obtain an accurate physical inventory snapshot at each store by counting every item in all store areas, and to reconcile that against system inventory records.

**Actors**:

* **Retail Head**: Initiates the year-end count across stores.
* **Store Manager**: Oversees the execution of the count within their location.
* **Store Employees**: Perform the actual physical counts, each in a designated area.

**Counting Strategy**:

* Each employee is assigned **a specific inventory area** (e.g. backroom or storefront).
* **No two employees are assigned to the same area**, to avoid double counting.
* A single **counting session** is defined as one employee counting stock in one area.

**Entity Mapping**:

* Each counting session is represented by one `InventoryCountImport` record.
* Each item counted by the employee during that session is stored in a corresponding `InventoryCountImportItem` record.

**Store-Level Aggregation**:

* A store may have **multiple `InventoryCountImport` records**, depending on how many employees were counting.
* The **summation of all `InventoryCountImportItem.quantity` values across all sessions** at a store gives the total **physical stock** at that store on the day of count.

This counting strategy ensures:

* Accurate and non-overlapping item counts.
* Auditability per employee per area.
* Reliable data for reconciliation against system inventory.

---

**Store-Level Aggregation**:

* A store may have **multiple `InventoryCountImport` records**, depending on how many employees were counting.
* The **summation of all `InventoryCountImportItem.quantity` values across all sessions** at a store gives the total **physical stock** at that store on the day of count.

**Processing Inventory Count Data**:
After the counting is complete and data is recorded in `InventoryCountImport` and `InventoryCountImportItem`, the next step is to **process and consolidate** the data at the facility (store) level.

* A **single SKU may appear in multiple counting sessions** if it is stored in multiple locations (e.g., both front floor and back room).
* To obtain a **consolidated view of inventory** at the store level, we must **aggregate quantities** of the same `productId` across all `InventoryCountImportItem` records linked to the same `facilityId`.
* The result is a **summary table** with one line per SKU per facility, showing the total physical quantity on hand as counted across all areas of that facility.

This aggregated view allows:

* Reconciliation with system inventory.
* Reporting of actual stock by SKU at each store.
* Decision-making for shrinkage tracking, and variance analysis.

---

### 1. `InventoryCountImport`

* **Purpose**: Represents a top-level import session or batch of inventory count entries.
* **Key Fields**:

    * `inventoryCountImportId`: Primary key.
    * `countImportName`: Name of the import.
    * `countTypeEnumId`: Type of count (e.g., Directed, Blind).
    * `uploadedByUserLogin`: User who created/imported the count.
    * `facilityId`: Associated warehouse/facility.
    * `parentCountId`: Optional reference to a parent import.
    * `statusId`: Current status of the count session.
    * `createdDate`, `dueDate`: Timestamps for creation and completion planning.
* **Relations**:

    * To `Enumeration` via `countTypeEnumId`
    * To `StatusItem` via `statusId`
    * To `Facility` via `facilityId`
    * To parent `InventoryCountImport` via `parentCountId`

---

### 2. `InvCountImportStatus`

* **Purpose**: Tracks the status history of individual count items.
* **Key Fields**:

    * `invCountImpStatusId`: Primary key.
    * `statusId`: Current or historical status.
    * `inventoryCountImportId`, `importItemSeqId`: References the specific count item.
    * `statusDate`: When the status was set.
    * `changeByUserLoginId`: Who changed the status.
* **Relations**:

    * To `StatusItem` via `statusId`
    * To `InventoryCountImport` via `inventoryCountImportId`
    * To `InventoryCountImportItem` via compound key
    * To `UserLogin` via `changeByUserLoginId`

---

### 3. `InventoryCountImportItem`

* **Purpose**: Represents an individual count line item (a product at a location).
* **Key Fields**:

    * `inventoryCountImportId`, `importItemSeqId`: Composite primary key.
    * `locationSeqId`: Physical location where the count was made.
    * `statusId`: Status of this item’s count.
    * `productId`, `productIdentifier`: Identifies the product.
    * `quantity`: Quantity counted.
    * `countedByUserLoginId`: Who performed the count.
    * `createdDate`, `createdByUserLoginId`: Audit fields.
* **Relations**:

    * To `InventoryCountImport` via `inventoryCountImportId`
    * To `StatusItem` via `statusId`
    * To `FacilityLocation` via `locationSeqId`

---

### 4. `InvCountImportVariance`

* **Purpose**: Represents the difference between system and actual counted inventory.
* **Key Fields**:

    * `inventoryCountImportId`, `invCountImportItemSeqId`: Composite primary key.
    * `productId`, `productIdentifier`: Product info.
    * `locationSeqId`: Counted location.
    * `systemQuantityOnHand`: Inventory recorded in the system.
    * `actualQuantityOnHand`: Counted inventory.
    * `varianceQuantityOnHand`: Difference in quantity.
    * `unitCost`, `totalCost`, `actualCost`, `costVariance`: Cost metrics.
    * `actualValue`, `totalValue`, `valueVariance`: Value metrics.
* **Relations**:

    * To `InventoryCountImport`
    * To `InventoryCountImportItem` via composite key
    * To `FacilityLocation` via `locationSeqId`

---
