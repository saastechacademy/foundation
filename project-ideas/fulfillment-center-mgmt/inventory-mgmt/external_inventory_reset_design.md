# ExternalInventoryReset — Design Summary

This document summarizes the full conceptual and architectural understanding of **ExternalInventoryReset** in the context of Poorti (HotWax Commerce OMS module for Fulfillment Center & Inventory Management).

---

## 1. Ownership & Placement

**ExternalInventoryReset is owned by the OMS / Inventory Management System.**

It must reside alongside core inventory entities:

- InventoryItem
- InventoryItemDetail
- ShipmentReceipt
- InventoryItemIssuance
- InventoryItemVariance

It is **not** owned by an integration package (e.g., NetSuite, WMS). Integrations only *produce* data for this entity.

The entity should live in the inventory package (e.g., `org.apache.ofbiz.product.inventory`).

---

## 2. Purpose of ExternalInventoryReset

ExternalInventoryReset captures the **context** justifying an externally driven inventory correction.

It is *not* the adjustment itself.

Workflow:

1. A new ExternalInventoryReset record is created.
2. OMS creates a corresponding **InventoryItemDetail** entry.
3. OMS updates InventoryItem QOH/ATP using standard rules.

This mirrors how OMS processes receipts, issues, and variances.

---

## 3. Responsibility Divide

### OMS Responsibilities

- Own the entity and ledger logic.
- Expose `create#ExternalInventoryReset` service.
- Validate referential integrity only (facility, product, inventoryItem).
- Persist context exactly as sent.
- Create InventoryItemDetail transactions.
- Update QOH/ATP based on diffs.

OMS does **not** validate business logic correctness.

### Integration / Application Layer Responsibilities

- Communicate with external systems (NetSuite/WMS/etc.).
- Compute:
  - externalQOH / externalATP
  - internalQOH / internalATP
  - quantityOnHandDiff
  - availableToPromiseDiff
- Decide when a reset should be created.
- Ensure correctness, thresholding, batching, review.

---

## 4. Field Naming Standardization

For diff fields, OMS should use the same naming as **InventoryItemDetail**, ensuring semantic consistency:

- `quantityOnHandDiff`
- `availableToPromiseDiff`

This reduces concept drift, simplifies reporting, and aligns with OFBiz standards.

---

## 5. Conceptual Flow of External Inventory Reset

1. Integration compares external vs internal values.
2. Integration calls OMS `create#ExternalInventoryReset`.
3. OMS stores all contextual data.
4. OMS posts the inventory delta into InventoryItemDetail.
5. OMS updates quantityOnHand and availableToPromise.
6. Standard inventory processes continue.

ExternalInventoryReset is therefore both:

- A **context record** for auditability.
- A **driver** for standard inventory ledger postings.

---

## 6. Design Principles

### **1. Ledger Ownership Belongs to OMS**

All adjustments, regardless of origin, flow through the same InventoryItemDetail mechanism.

### **2. Integration Owns Correctness**

OMS does not judge the business correctness of the supplied quantities.

### **3. Consistency With Existing Entities**

ExternalInventoryReset adopts the same naming, semantics, and behavior patterns as existing inventory entities.

---

## 7. create#ExternalInventoryReset Service Specification

This section defines the OMS-side ledger service that creates an `ExternalInventoryReset` record and the corresponding `InventoryItemDetail` entry.

---

# create#[ExternalInventoryReset]

This service belongs to the OMS/Inventory Management component. It is a **simple ledger service** that assumes all context and diff values have already been computed by an upstream service (such as `reset#InventoryItem`).

Most callers will use `reset#InventoryItem`, not this service.

---

## Input

Example payload:

```json
{
  "resetDateResourceId": "RDR12345",
  "facilityId": "FAC1001",
  "productId": "PROD56789",
  "externalFacilityId": "EXTFAC4321",
  "productIdentType": "SKU",
  "productIdentValue": "SKU-001-A",

  "inventoryItemId": "INV789012",
  "inventoryItemQOH": 200,
  "inventoryItemATP": 180,

  "externalQOH": 180,
  "externalATP": 150,

  "quantityOnHandDiff": -20,
  "availableToPromiseDiff": -30,

  "unitCost": 12.5
}
```

Notes:

- `facilityId`, `productId`, and `inventoryItemId` are already resolved.
- OMS does **not** compute diffs — they must be provided.
- OMS does **not** validate business correctness.

---

## Workflow

### 1. Create ExternalInventoryReset record

OMS inserts a new row with all contextual fields and diffs:

- resetDateResourceId
- facilityId
- productId
- externalFacilityId
- productIdentType
- productIdentValue
- inventoryItemId
- inventoryItemQOH
- inventoryItemATP
- externalQOH
- externalATP
- quantityOnHandDiff
- availableToPromiseDiff
- unitCost

OMS generates `resetItemId`.

### 2. Create InventoryItemDetail record

OMS inserts a corresponding ledger entry using:

- quantityOnHandDiff
- availableToPromiseDiff
- inventoryItemId, facilityId

This makes the reset flow through the **standard OMS inventory ledger**, same as receipts, issues, and variances.

### 3. EECA updates InventoryItem

An EECA reacts to the new `InventoryItemDetail` and updates the `InventoryItem` QOH/ATP accordingly. OMS does **not** update InventoryItem directly.

---

## Output

```json
{
  "resetItemId": "EIR123456"
}
```

Errors related to invalid facility/product/inventoryItem follow standard OMS service error conventions.

