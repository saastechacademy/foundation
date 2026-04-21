# FieldName Handling in Order Routing Filters

This document outlines how each fieldName involved in the order routing process is handled — either in the service logic (`get#OrderFilterSql`) or in the SQL template (`EligibleOrdersQuery.sql.ftl`). 

Only valid, configurable fieldNames are included. Fields that are hardcoded in service logic (e.g. `orderTypeId`, `itemStatusId`) are **excluded** from this list.

---

## 🧪 Category A: Preprocessed in Service (`get#OrderFilterSql`)

### 🧩 `promiseDaysCutoff` → `promisedDatetime`
| Aspect | Detail |
|--------|--------|
| **Behavior in Service** | Detected using: `"promiseDaysCutoff".equals(filterCondition.fieldName)` |
| **Transformation** | `ZonedDateTime.now() + N days`, time set to 23:59:59, formatted as timestamp |
| **SQL Output** | A new filter with `fieldName: 'promisedDatetime'` is added to `orderFilterConditions` |
| **SQL Handling** | `<@buildSqlCondition 'promisedDatetime' filterCondition/>` |
| **Validation** | Requires numeric input (`Long`) |
| **Environment Risk** | None (runtime-based) |

---

### 🧩 `originFacilityGroupId`
| Aspect | Detail |
|--------|--------|
| **Behavior in Service** | Captured as `facilityGroupCondition` |
| **SQL Handling** | Adds a JOIN with `FACILITY_GROUP_MEMBER` + condition: `FGM.FACILITY_GROUP_ID = ...` |
| **Validation** | Must match existing `facilityGroupId` |
| **Environment Risk** | Medium |

---

### 🧩 `productCategoryId`
| Aspect | Detail |
|--------|--------|
| **Behavior in Service** | Captured as `productCategoryCondition` |
| **SQL Handling** | Adds a JOIN with `PRODUCT_CATEGORY_MEMBER` + condition: `PCM.PRODUCT_CATEGORY_ID = ...` |
| **Validation** | Must match valid product category |
| **Environment Risk** | High

---

## 🧾 Category B: Passed to SQL via `orderFilterConditions`

### 🧩 `priority`
| Aspect | Detail |
|--------|--------|
| **SQL Alias** | `OH.PRIORITY AS priority` |
| **SQL Handling** | `<@buildSqlCondition 'priority' filterCondition/>` |
| **Validation** | Numeric |
| **Environment Risk** | Low |

---

### 🧩 `facilityId`
| Aspect | Detail |
|--------|--------|
| **Meaning** | The facility (queue) where the order is currently parked before routing |
| **SQL Alias** | `OISG.FACILITY_ID AS facilityId` |
| **SQL Handling** | `<@buildSqlCondition 'facilityId' filterCondition/>` |
| **Validation** | Must match a virtual facility configured as a routing queue |
| **Environment Risk** | 🔴 High — depends on per-env facility IDs and names |
| **Source of Values** | Facilities with type `NA`, `PRE_ORDER`, `BACKORDER`, etc., used as queues |

---

### 🧩 `salesChannelEnumId`
| Aspect | Detail |
|--------|--------|
| **SQL Alias** | `OH.SALES_CHANNEL_ENUM_ID AS salesChannelEnumId` |
| **SQL Handling** | `<@buildSqlCondition 'salesChannelEnumId' filterCondition/>` |
| **Validation** | Must match enum ID |
| **Environment Risk** | Medium |

---

### 🧩 `shipmentMethodTypeId`
| Aspect | Detail |
|--------|--------|
| **SQL Alias** | `OISG.SHIPMENT_METHOD_TYPE_ID AS shipmentMethodTypeId` |
| **SQL Handling** | `<@buildSqlCondition 'shipmentMethodTypeId' filterCondition/>` |
| **Validation** | Must match known shipment method |
| **Environment Risk** | High |

---

### 🧩 `orderDate`
| Aspect | Detail |
|--------|--------|
| **SQL Alias** | `OH.ORDER_DATE AS orderDate` |
| **SQL Handling** | `<@buildSqlCondition 'orderDate' filterCondition/>` |
| **Validation** | Valid ISO date string |
| **Environment Risk** | Low |

---

## 🚫 Excluded Hardcoded Fields

The following fields are used in the SQL query but are **not configurable** via `OrderFilterCondition`. They are hardcoded in `get#OrderFilterSql` and included in every routing run by default:

- `orderTypeId = 'SALES_ORDER'`
- `itemStatusId = 'ITEM_APPROVED'`

These do **not** appear in the whitelist and should never be part of import/export for routing rules.



## 🛡️ Validation Requirement for Critical Field References (During Porting)

### 🧩 `facilityId`

* **Purpose**: Refers to the **virtual facility** (queue) assigned to the `OrderItemShipGroup` for routing eligibility.
* **Validation Rule**: The value of `facilityId` used in any routing filter must correspond to an existing `Facility.facilityId` in the **target environment**.
* **Special Handling**:

  * These are typically **virtual facilities** (e.g., `UNFILLABLE_PARKING`, `PRE_ORDER_PARKING`).
  * A missing or mismatched facility will cause routing rules to silently fail.
* **Recommendation**: Maintain a **map of facilityId aliases** across environments if exact IDs differ, or validate facility presence via `Facility` lookup before importing.

---

### 🧩 `productCategoryId`

* **Purpose**: Defines a category filter for eligible order items.
* **Validation Rule**: Each `productCategoryId` used in a routing rule must exist in the `ProductCategory` entity on the **target system**.
* **Risk**: Inconsistent category hierarchies between environments (e.g., UAT vs Prod) can lead to incorrect routing results.
* **Recommendation**: Validate each category against `ProductCategory.productCategoryId` before porting.
