**Inventory Cycle Count – Design and Data Model Overview**

This document outlines the end-to-end design and supporting data model for managing a system-driven physical inventory count process in a multi-store retail environment. The process enables structured capture of count data, consolidation, variance evaluation, and optional automated updates to inventory — all with traceability and explainability.

---

## Business Scenario

Retail companies periodically conduct **hard inventory counts** at each store location, typically at year-end. Each store has multiple **zones** (e.g., sales floor, backroom), and each zone is counted by a designated employee to avoid double-counting.

* Each employee's count is recorded as a **counting session**.
* A full store-level snapshot is calculated by aggregating all sessions.
* The system may auto-accept small variances and escalate others.
* Final inventory updates are tracked in OFBiz-standard entities.

---

## Actors and Responsibilities

* **Retail Director**: Schedules count runs using `WorkEffort` (type `INVENTORY_COUNT_RUN`).
* **Store Manager**: Assigns zones to employees, each represented as an `InventoryCountImport`.
* **Store Employee**: Records product counts in a zone.
* **System**: Aggregates results, applies rules, logs reasoning, and adjusts inventory if needed.

---

## Workflow Overview

1. **Scheduling**:

    * A `WorkEffort` is created to represent a store-wide count run.

2. **Session Capture**:

    * Each employee’s session is recorded as an `InventoryCountImport`.
    * Line-level counts are stored in `InventoryCountImportItem`.

3. **Consolidation**:

    * The system aggregates counts across sessions by product + store.
    * Results are stored in `FacilityProdInvCount`.
    * A mapping of which sessions contributed to each record is stored in `FacilityProdInvCountImport`.

4. **Decision Evaluation**:

    * Variance is calculated against current system inventory.
    * Rules/thresholds are applied.
    * The reasoning for the outcome is stored in `FacilityProdInvVarDcsnRsn`.

5. **Inventory Adjustment**:

    * If accepted, inventory changes are written to `InventoryItemVariance`.
    * These are batched under a `PhysicalInventory` record.
    * Decision record links back to the impacted inventory item.

---

## Core Entity Model

### `WorkEffort`

* **Purpose**: Represents an inventory count run.
* **Type**: `INVENTORY_COUNT_RUN`

### `InventoryCountImport`

* **Purpose**: Tracks each employee’s counting session.
* **Fields**: `inventoryCountImportId`, `workEffortId`, `facilityId`, `statusId`, etc.

### `InventoryCountImportItem`

* **Purpose**: Stores line-item counts per product and location.
* **Fields**: Composite PK (`inventoryCountImportId`, `importItemSeqId`), `productId`, `locationSeqId`, `quantity`

### `FacilityProdInvCount`

* **Purpose**: Stores consolidated counted quantity per product per facility.
* **Fields**: Composite PK (`workEffortId`, `facilityId`, `productId`), `quantityOnHand`, `countDate`

### `FacilityProdInvCountImport`

* **Purpose**: Maps which sessions contributed to each product-level count.
* **Fields**: Composite PK (`workEffortId`, `facilityId`, `productId`, `inventoryCountImportId`)

### `FacilityProdInvVarDcsnRsn`

* **Purpose**: Captures the reasoning for each variance-related decision.
* **Fields**:

    * `varianceReasonId` (PK)
    * `workEffortId`, `facilityId`, `productId`
    * `inventoryCountImportId` (optional)
    * `systemQuantityOnHand`, `quantityCounted`, `varianceQuantity`, `variancePercentage`
    * `varianceCauseEnumId` (e.g., `DAMAGED`, `MISSING`, `AUTO_WITHIN_TOLERANCE`)
    * `decisionOutcomeEnumId` (e.g., `ACCEPTED`, `RECOUNT`, `REJECTED`)
    * `inventoryItemId`, `physicalInventoryId` (nullable FK to applied `InventoryItemVariance`)
    * `autoAppliedIndicator`, `comments`, `createdDate`, `createdByUserLoginId`

---

## Downstream Inventory Adjustment Entities

### `PhysicalInventory`

* **Purpose**: Serves as the batch container for inventory adjustments.

### `InventoryItemVariance`

* **Purpose**: Captures final ATP/QOH changes applied to inventory.
* **Linkage**:

    * Linked back to decisions via `FacilityProdInvVarDcsnRsn`.
    * Driven by system or manual acceptance of variance.

---
