# Applying Count Results to Inventory with Explainability

This document builds on **Foundational Cycle Count** by enabling the application of approved count results to system inventory. The focus is exclusively on explainability and traceability through the new `InventoryVarDcsnRsn` entity. This ensures every adjustment—or decision not to adjust—is structured, auditable, and tied to physical count data.

---

## 1) InventoryVarDcsnRsn (Decision/Explainability Record)

- **Role**: Captures the structured context of a decision to post or skip a variance when comparing counted inventory vs. system inventory.
- **Key Fields (conceptual)**:
  - `workEffortId`, `facilityId`, `productId`
  - `countedQuantity` (from approved sessions)
  - `systemQuantity` (snapshot at posting)
  - `varianceQuantity` (`counted - system`)
  - `decisionReasonEnumId` – why the decision was made
  - `decisionOutcomeEnumId` – APPLIED or SKIPPED
  - `inventoryItemVarianceId` (when APPLIED)
  - `decidedByUserLoginId`, `decidedDateTime`
  - Optional comments

- **Structured enums (Phase 1.1 set)**:
  - `decisionReasonEnumId` (type: `INV_VAR_DECISION_RSN`)
    - `ANNUAL_COUNT_ADJUSTMENT`
    - `MANAGER_OVERRIDE`
    - `PARTIAL_SCOPE_POST`
    - `CORRECTION_AFTER_REVIEW`
  - `decisionOutcomeEnumId` (type: `INV_VAR_DECISION_OUTCOME`)
    - `APPLIED`
    - `SKIPPED`

---

## 2) Entity & Workflow Changes

- **Introduce `InventoryVarDcsnRsn`** as the structured explainability entity.
- **Require a decision reason** for each product variance reviewed.
- Decisions are tracked in relation to the overall WorkEffort (the cycle count run). Approved sessions supply the data, and InventoryItemVariance rows (when created) are connected through this context rather than by a direct link field.
- **Capture both APPLIED and SKIPPED outcomes**, so skipped adjustments are explicitly explained.

---

## 3) Workflows Enabled

### Workflow A: Variance Computation
1. Approved count data is consolidated to calculate [Physical Inventory](../../oms/createPhysicalInventory.md) per product.
2. System compares counted QOH with system QOH → prepares Variance Preview.

### Workflow B: Variance Posting with Explainability
1. Manager reviews Variance Preview.
2. For each product, manager selects whether to [post variance or skip](../../oms/createPhysicalInventory.md).
3. System creates:
   - `InventoryItemVariance` (when applied).
   - `InventoryVarDcsnRsn` capturing decision reason, outcome, and linkage.

### Workflow C: Reversal / Correction
1. Mistakes are handled by creating reversal variances.
2. A new `InventoryVarDcsnRsn` entry records the correction reason.

### Workflow D: Audit Trail & Reporting
- For each facility/product, reports can show:
  - Counted QOH, System QOH, Variance
  - Decision Reason + Outcome
  - Who decided and when
  - Links to variance record and WorkEffort

---

## 4) Out of Scope (Phase 1)
- Automated tolerance rules.
- Directed counts as triggers.
- Decision rule engines.

---
