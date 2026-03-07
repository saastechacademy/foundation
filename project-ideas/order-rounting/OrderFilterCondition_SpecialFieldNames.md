# Field Names with Special Behavior in `get#OrderFilterSql` Service

This document lists all `fieldName` values from `OrderFilterCondition` that receive **special handling** in the `get#OrderFilterSql` service and affect how SQL is generated or interpreted during the order routing process.

---

## ✅ 1. `promiseDaysCutoff`
- **Behavior**:
  - Sets `selectOrderItemSeqId = true`
  - Computes `promisedDatetime = now() + N days (end of day)`
  - Rewrites condition as:

    ```json
    {
      "fieldName": "promisedDatetime",
      "operator": "<copied>",
      "fieldValue": "<computed datetime>"
    }
    ```

- **Purpose**: Converts SLA-based cutoff into a datetime constraint to influence item-level brokering.

---

## ✅ 2. `originFacilityGroupId`
- **Behavior**:
  - Sets `facilityGroupCondition = filterCondition`
  - Used to generate an `INNER JOIN` with `FACILITY_GROUP_MEMBER` in the SQL template

- **Note**: This condition is not added to `orderFilterConditions`.

---

## ✅ 3. `productCategoryId`
- **Behavior**:
  - Sets `productCategoryCondition = filterCondition`
  - Triggers `INNER JOIN` with `PRODUCT_CATEGORY_MEMBER` in the SQL template

- **Note**: Also excluded from the main filter list.

---

## ✅ 4. All Other Fields
- **Behavior**:
  - Passed through to `orderFilterConditions` list without modification
  - Used directly in SQL `WHERE` clause via:

    ```ftl
    <@buildSqlCondition fieldName filterCondition/>
    ```

- **Examples**: `orderTypeId`, `salesChannelEnumId`, `priority`, etc.

---

## 🧠 Summary
Only three `fieldName` values trigger logic outside of direct SQL condition generation:
- `promiseDaysCutoff`
- `originFacilityGroupId`
- `productCategoryId`

All other fields are treated as-is.
