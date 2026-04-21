# Whitelisted `fieldName` Values for OrderFilterCondition

This document lists all `fieldName` values that are valid for use in `OrderFilterCondition` as inputs to the `get#OrderFilterSql` service and the `EligibleOrdersQuery.sql.ftl` SQL template.

Only these fields are accepted when generating dynamic SQL conditions for selecting eligible orders.

---

## ✅ Whitelisted Field Names (Derived from SQL Aliases)

- `orderId`
- `shipGroupSeqId`
- `ORDER_ITEM_SEQ_ID` *(rare use case, validate before use)*
- `productStoreId`
- `statusId`
- `orderTypeId`
- `itemStatusId`
- `facilityParentTypeId`
- `salesChannelEnumId`
- `promisedDatetime` *(used when `promiseDaysCutoff` is configured)*
- `facilityId`
- `shipmentMethodTypeId`
- `priority`
- `shipAfterDate`
- `shipBeforeDate`
- `orderDate`
- `deliveryDays`

---

## 🚫 Rejected or Unsupported Field Names

Any field not explicitly listed above must be **rejected** during validation. This prevents:
- SQL injection risks
- Mismatches across environments
- Invalid joins or ambiguous filter behavior

---

## 🛡️ Policy

Only field names matching SQL column aliases declared in `EligibleOrdersQuery.sql.ftl` are accepted. All others will cause the import to fail with a clear validation error.


---

## 🧭 UI Filter to `fieldName` Mapping Notes

The following field names are derived from user-facing filter labels in the routing UI:

| UI Label           | Actual `fieldName` Used | Notes |
|--------------------|--------------------------|-------|
| Queue              | `facilityId`             | Maps to `OrderItemShipGroup.FACILITY_ID` |
| Promise Date       | `promisedDatetime`       | Derived from `promiseDaysCutoff` logic |
| Sales Channel      | `salesChannelEnumId`     | Matches ENUM on order header |
| Priority           | `priority`               | Directly used |
| Shipment Method    | `shipmentMethodTypeId`   | From `OrderItemShipGroup` |
| Origin Facility Group | `originFacilityGroupId` | Used in join with `FACILITY_GROUP_MEMBER` |
| Product Category   | `productCategoryId`      | Used in join with `PRODUCT_CATEGORY_MEMBER` |

This mapping helps maintain consistency between UI filters and system-level routing behavior.


---

## 🔍 Additional `fieldName` Values from Routing Rules Documentation

Based on official HotWax Commerce documentation, the following `fieldName` values are functionally supported within the Order Routing Rules UI and should be included in the validated whitelist:

| fieldName               | Usage Context                        |
|-------------------------|--------------------------------------|
| `queue`                 | UI label for `facilityId`            |
| `promisedDatetime`      | Used in delivery SLAs                |
| `salesChannelEnumId`    | Filters by sales channel             |
| `priority`              | Order urgency indicator              |
| `shipmentMethodTypeId`  | Filters by shipping method type      |
| `originFacilityGroupId` | Used for facility group-based routing|
| `productCategoryId`     | Used for category-based routing      |

These values either map directly to SQL aliases or are handled specially in the `get#OrderFilterSql` service. All are considered valid in the routing rule configuration workflow.
