# reset#InventoryItem Service Specification

This service computes external vs internal inventory differences and decides whether an inventory reset is required. It is the **primary entry point** for external systems (WMS, ERP, NetSuite, etc.) that want to reconcile inventory with OMS.

`reset#InventoryItem` performs **no ledger updates directly**. It computes diffs and, only when necessary, calls `create#ExternalInventoryReset`.

If no diff is found, it simply returns the computed values. Zero diffs communicate that **no reset action was taken**.

---

## Input

The service accepts raw external inventory data and the identifiers needed to resolve the internal InventoryItem:

```json
{
  "resetDateResourceId": "RDR12345",
  "externalFacilityId": "EXTFAC4321",
  "productIdentType": "SKU",
  "productIdentValue": "SKU-001-A",
  "externalQOH": 180,
  "externalATP": 150,
  "unitCost": 12.5
}
```

---

## Workflow

### 1. Resolve internal product and inventory context

Using `(externalFacilityId, productIdentType, productIdentValue)`, the service must:

* Resolve `facilityId`
* Resolve `productId`
* Resolve `inventoryItemId` (or create one if the system permits)
* Retrieve:

  * `inventoryItemQOH`
  * `inventoryItemATP`

If any of these cannot be resolved, the service should:

* Return the context and values it was able to determine
* Add a plain-text message (in a `messages` list) describing the issue using Moqui log style:

  `Inventory [Context] - [Outcome]`
* **Not** call `create#ExternalInventoryReset`

### Resolution Failure Response Format

Example patterns:

* **Unknown externalFacilityId**

  ```json
  "messages": [
    "Inventory externalFacilityId=EXTFAC-UNKNOWN SKU=SKU-001-A - Facility resolution failed, no reset performed"
  ]
  ```

* **Unknown SKU/Product**

  ```json
  "messages": [
    "Inventory FacilityId=FAC1001 SKU=SKU-DOES-NOT-EXIST - Product resolution failed, no reset performed"
  ]
  ```

* **No InventoryItem exists**

  ```json
  "messages": [
    "Inventory FacilityId=FAC1001 ProductId=PROD56789 - InventoryItem not found, no reset performed"
  ]
  ```

### 2. Compute diffs. Compute diffs

```text
quantityOnHandDiff = externalQOH - inventoryItemQOH
availableToPromiseDiff = externalATP - inventoryItemATP
```

### 3. Decide whether a reset is required

* If **both diffs = 0** → **No reset required**
* If either diff ≠ 0 → **Reset required**

### 4. When a reset is required

Call `create#ExternalInventoryReset` with all contextual fields and the computed diffs.

Call `create#ExternalInventoryReset` with all contextual fields and the computed diffs.

Capture the returned:

* `resetItemId`

### 5. Ledger posting

`create#ExternalInventoryReset` will:

* Create an `ExternalInventoryReset` record
* Create an `InventoryItemDetail` entry
* Trigger EECA to update `InventoryItem`

`reset#InventoryItem` does **not** interact with the ledger directly.

---

## Output

### Case 1 — Diff found, reset performed

```json
{
  "facilityId": "FAC1001",
  "productId": "PROD56789",
  "inventoryItemId": "INV789012",
  "inventoryItemQOH": 200,
  "inventoryItemATP": 180,
  "externalQOH": 180,
  "externalATP": 150,
  "quantityOnHandDiff": -20,
  "availableToPromiseDiff": -30,
  "resetItemId": "EIR123456"
}
```

### Case 2 — No diff found, no reset performed

```json
{
  "facilityId": "FAC1001",
  "productId": "PROD56789",
  "inventoryItemId": "INV789012",
  "inventoryItemQOH": 180,
  "inventoryItemATP": 150,
  "externalQOH": 180,
  "externalATP": 150,
  "quantityOnHandDiff": 0,
  "availableToPromiseDiff": 0
}
```

The absence of `resetItemId`, combined with zero diffs, implicitly communicates: **no reset performed**.

---

## Design Notes

* This service represents the **decision-making layer** in the inventory reconciliation process.
* It shields external systems from OMS ledger complexity.
* It ensures that resets are only applied when meaningful differences exist.
* Zero diff = no-op = clean, minimal API semantics.
