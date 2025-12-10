# reset#InventoryItem – Test Case Matrix

This document defines functional test cases for verifying the correctness of the `reset#InventoryItem` service.

Each test case specifies **inputs**, **system preconditions**, **expected outputs**, and **expected behavior** (including whether `create#ExternalInventoryReset` should be invoked).

---

## 1. Core Diff Behavior

### TC-01: No diff → No reset

| Item                | Details                                                                 |
|---------------------|-------------------------------------------------------------------------|
| Preconditions       | InventoryItem exists with `QOH = 100`, `ATP = 80`.                     |
| Input               | `externalQOH = 100`, `externalATP = 80`.                               |
| Expected Diff       | `quantityOnHandDiff = 0`, `availableToPromiseDiff = 0`.                |
| Reset?              | **No**.                                                                |
| Expected Output     | Context fields + zero diffs; **no `resetItemId`** in response.         |
| Expected Behavior   | `create#ExternalInventoryReset` is **not** called.                     |

---

### TC-02: Both diffs non-zero → Reset performed

| Item                | Details                                                                 |
|---------------------|-------------------------------------------------------------------------|
| Preconditions       | InventoryItem exists with `QOH = 200`, `ATP = 180`.                    |
| Input               | `externalQOH = 180`, `externalATP = 150`.                              |
| Expected Diff       | `quantityOnHandDiff = -20`, `availableToPromiseDiff = -30`.            |
| Reset?              | **Yes**.                                                               |
| Expected Output     | Context fields + diffs + **non-null `resetItemId`**.                   |
| Expected Behavior   | `create#ExternalInventoryReset` is called with matching values.        |

---

### TC-03: Only QOH differs → Reset performed

| Item                | Details                                                                 |
|---------------------|-------------------------------------------------------------------------|
| Preconditions       | InventoryItem exists with `QOH = 100`, `ATP = 80`.                     |
| Input               | `externalQOH = 105`, `externalATP = 80`.                               |
| Expected Diff       | `quantityOnHandDiff = 5`, `availableToPromiseDiff = 0`.                |
| Reset?              | **Yes**.                                                               |
| Expected Output     | Context fields + diffs + `resetItemId`.                                |
| Expected Behavior   | `create#ExternalInventoryReset` is called.                             |

---

### TC-04: Only ATP differs → Reset performed

| Item                | Details                                                                 |
|---------------------|-------------------------------------------------------------------------|
| Preconditions       | InventoryItem exists with `QOH = 100`, `ATP = 80`.                     |
| Input               | `externalQOH = 100`, `externalATP = 90`.                               |
| Expected Diff       | `quantityOnHandDiff = 0`, `availableToPromiseDiff = 10`.               |
| Reset?              | **Yes**.                                                               |
| Expected Output     | Context fields + diffs + `resetItemId`.                                |
| Expected Behavior   | `create#ExternalInventoryReset` is called.                             |

---

## 2. Resolution Failures

### TC-05: Unknown externalFacilityId → No reset

| Item                | Details                                                                 |
|---------------------|-------------------------------------------------------------------------|
| Preconditions       | `externalFacilityId` does **not** map to any OMS `facilityId`.         |
| Input               | Any `externalQOH` / `externalATP`.                                     |
| Expected Diff       | Not computable (no `facilityId` / `inventoryItemId`).                  |
| Reset?              | **No**.                                                                |
| Expected Output     | Partial context only; no `facilityId` / `productId` / `inventoryItemId`.|
| Expected Behavior   | `create#ExternalInventoryReset` is not called.                         |

---

### TC-06: Unknown product/SKU → No reset

| Item                | Details                                                                 |
|---------------------|-------------------------------------------------------------------------|
| Preconditions       | Facility exists; `productIdentValue` does **not** resolve to product.  |
| Input               | Any `externalQOH` / `externalATP`.                                     |
| Expected Diff       | Not computable (no `productId` / `inventoryItemId`).                   |
| Reset?              | **No**.                                                                |
| Expected Output     | `facilityId` resolved; `productId` and `inventoryItemId` are null.     |
| Expected Behavior   | No `resetItemId`; no ExternalInventoryReset row created.               |

---

### TC-07: No InventoryItem exists → No reset

| Item                | Details                                                                 |
|---------------------|-------------------------------------------------------------------------|
| Preconditions       | Facility and product exist; no InventoryItem for that facility/product.|
| Input               | Any `externalQOH` / `externalATP`.                                     |
| Expected Diff       | Not computable (no current internal QOH/ATP).                          |
| Reset?              | **No**.                                                                |
| Expected Output     | `facilityId` and `productId` returned; `inventoryItemId` null.          |
| Expected Behavior   | No ExternalInventoryReset created.                                     |

---

## 3. Edge and Stress Scenarios

### TC-08: Large positive diffs → Reset performed

| Item                | Details                                                                 |
|---------------------|-------------------------------------------------------------------------|
| Preconditions       | InventoryItem with `QOH = 0`, `ATP = 0`.                               |
| Input               | `externalQOH = 10000`, `externalATP = 9500`.                           |
| Expected Diff       | `quantityOnHandDiff = 10000`, `availableToPromiseDiff = 9500`.         |
| Reset?              | **Yes**.                                                               |
| Expected Output     | Large diff values + `resetItemId`.                                     |
| Expected Behavior   | `create#ExternalInventoryReset` called with large values accepted.     |

---

### TC-09: Large negative diffs → Reset performed

| Item                | Details                                                                 |
|---------------------|-------------------------------------------------------------------------|
| Preconditions       | InventoryItem with `QOH = 10000`, `ATP = 9000`.                        |
| Input               | `externalQOH = 0`, `externalATP = 0`.                                  |
| Expected Diff       | `quantityOnHandDiff = -10000`, `availableToPromiseDiff = -9000`.       |
| Reset?              | **Yes**.                                                               |
| Expected Output     | Large negative diffs + `resetItemId`.                                  |
| Expected Behavior   | OMS records the reset; integration layer is responsible for sanity.    |

---

### TC-10: Decimal / rounding behavior

| Item                | Details                                                                 |
|---------------------|-------------------------------------------------------------------------|
| Preconditions       | InventoryItem with `QOH = 100`, `ATP = 80`.                            |
| Input               | Values expressed as decimals, e.g. `externalQOH = 100.0`, `externalATP = 80.0`. |
| Expected Diff       | `quantityOnHandDiff = 0`, `availableToPromiseDiff = 0`.                |
| Reset?              | **No**.                                                                |
| Expected Output     | Zero diffs; no `resetItemId`.                                          |
| Expected Behavior   | No reset; confirms stable numeric handling / coercion.                 |

---

## 4. Unit Cost Variation

### TC-11: `unitCost` present and passed through

| Item                | Details                                                                 |
|---------------------|-------------------------------------------------------------------------|
| Preconditions       | Normal InventoryItem context.                                          |
| Input               | Includes `unitCost`, e.g. `unitCost = 12.50`.                          |
| Expected Diff       | Based on QOH/ATP comparison.                                           |
| Reset?              | Depends on diffs (covered in other cases).                             |
| Expected Output     | Response as per diff; `unitCost` passed into `create#ExternalInventoryReset`. |
| Expected Behavior   | Cost flows through without scaling or rounding errors.                 |

---

### TC-12: `unitCost` omitted

| Item                | Details                                                                 |
|---------------------|-------------------------------------------------------------------------|
| Preconditions       | Normal InventoryItem context.                                          |
| Input               | Does **not** include `unitCost`.                                       |
| Expected Diff       | Based on QOH/ATP comparison.                                           |
| Reset?              | Depends on diffs.                                                      |
| Expected Output     | Response as per diff; no requirement for `unitCost` in output.         |
| Expected Behavior   | Reset logic works without cost; cost is optional.                      |

---

## 5. Idempotency Behavior

### TC-13: Second call after reset → No reset on second call

| Item                | Details                                                                 |
|---------------------|-------------------------------------------------------------------------|
| Preconditions       | First call already performed a reset so that internal QOH/ATP now equal external values. |
| Input (2nd call)    | Same `externalQOH` / `externalATP` as used in the first call.          |
| Expected Diff       | `quantityOnHandDiff = 0`, `availableToPromiseDiff = 0`.                |
| Reset?              | **No** on the second call.                                             |
| Expected Output     | Zero diffs; no `resetItemId` on second call.                           |
| Expected Behavior   | Only one ExternalInventoryReset exists for those values; second call is a no-op. |
