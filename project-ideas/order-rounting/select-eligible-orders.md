# 🧩 Phase 1: Select Eligible Orders (Using Order Filters)

## Overview

This document covers Phase 1 of the Order Routing process in HotWax Commerce: selecting **eligible orders** using filter conditions defined in the `OrderFilterCondition` entity. The logic is executed using the `EligibleOrdersQuery.sql.ftl` SQL template. This is the **first step** in the three-phase routing pipeline and determines which orders proceed to the next stages of routing.

---

## 📦 Sample Data for Context

We use this sample input from the routing configuration to illustrate behavior:

```xml
<orderFilters conditionSeqId="5" conditionTypeEnumId="ENTCT_FILTER"
              fieldName="facilityId" operator="equals" fieldValue="UNFILLABLE_PARKING" sequenceNum="5"/>
<orderFilters conditionSeqId="10" conditionTypeEnumId="ENTCT_SORT_BY"
              fieldName="orderDate" sequenceNum="5"/>
```

This input defines:

* A **filter** on `facilityId = UNFILLABLE_PARKING`
* A **sort-by** field on `orderDate`

---

## 🔍 What This Phase Does

This phase:

1. Loads `OrderFilterCondition` records for the given `orderRoutingGroupId`.
2. Dynamically builds SQL using Freemarker template logic (`EligibleOrdersQuery.sql.ftl`).
3. Applies filters in the WHERE clause and sort fields in ORDER BY.
4. Returns a list of Order Header and Order Item records that meet the filter criteria.

---

## 🔎 Valid Filter Fields & Their Meanings

Here are the most commonly used `fieldName` values in `OrderFilterCondition`, grouped by purpose:

### Order-Level Fields

| Field Name       | Description                           |
| ---------------- | ------------------------------------- |
| `orderTypeId`    | E.g., `SALES_ORDER` or `RETURN_ORDER` |
| `orderDate`      | Date the order was placed             |
| `statusId`       | Order approval or cancellation status |
| `productStoreId` | Store that created the order          |

### Item-Level Fields

| Field Name       | Description                                |
| ---------------- | ------------------------------------------ |
| `productId`      | Specific product                           |
| `quantity`       | Order item quantity                        |
| `itemStatusId`   | Status of the item (e.g., `ITEM_APPROVED`) |
| `shipGroupSeqId` | Identifies ship group per order            |

### Shipment Fields

| Field Name           | Description                            |
| -------------------- | -------------------------------------- |
| `destinationZipCode` | ZIP code from the ship group's address |
| `carrierPartyId`     | Preferred shipping carrier             |

### Other Filterable Fields

| Field Name             | Description                               |
| ---------------------- | ----------------------------------------- |
| `facilityId`           | Only allow orders from certain facilities |
| `shipmentMethodEnumId` | E.g., `STANDARD`, `EXPRESS`               |

These are used to build dynamic WHERE conditions in the Freemarker SQL template.

---

## 🧩 Enum Values Used in Eligible Order Filtering

### Overview

The `OrderFilterCondition` entity uses a combination of field names and enums to describe filtering logic. These filters are processed by the `EligibleOrdersQuery.sql.ftl` template to dynamically construct SQL used to select candidate orders.

---

### 🎛️ Enum: `conditionTypeEnumId`

Defines how the filter is used in the SQL logic.

| Enum ID            | Meaning                                 | Usage in SQL                    |
| ------------------ | --------------------------------------- | ------------------------------- |
| `ENTCT_FILTER`     | The field is used in the `WHERE` clause | Adds a direct filter on the SQL |
| `ENTCT_SORT_BY`    | Used for sorting in `ORDER BY` clause   | Adds field to SQL ordering      |
| `ENTCT_LIMIT`      | Restricts row count (rarely used)       | Adds `LIMIT` clause             |
| `ENTCT_EXPRESSION` | Used for special or raw SQL expressions | Injected into SQL as-is         |

---

### 🔑 Enum Fields Mapped to Columns

Each record in `OrderFilterCondition` includes a `fieldName`. The template recognizes only **certain** fields. These are:

| `fieldName`          | Mapped SQL Column / Use                            |
| -------------------- | -------------------------------------------------- |
| `facilityId`         | Filters orders routed to a specific facility       |
| `orderDate`          | Used for sorting, e.g., `ORDER BY order_date DESC` |
| `productStoreId`     | Filters orders for a specific store                |
| `priority`           | May be used for prioritization logic               |
| `salesChannelEnumId` | Filters based on channel (web, in-store, etc.)     |

If an unrecognized `fieldName` is present, the SQL will not use it, and it may cause an error if blindly injected.

---

### ⚠️ Enum Dependency and Validation

These enum values **do not enforce referential integrity** in the database but are critical for:

* Interpreting the meaning of a filter
* Correctly generating SQL logic
* Validating export/import configurations (since enums must exist in the target system)

---

### ✅ Sample Data Used in Our Discussion

```xml
<orderFilters conditionSeqId="5" conditionTypeEnumId="ENTCT_FILTER"
              fieldName="facilityId" operator="equals"
              fieldValue="UNFILLABLE_PARKING" sequenceNum="5"/>
<orderFilters conditionSeqId="10" conditionTypeEnumId="ENTCT_SORT_BY"
              fieldName="orderDate" sequenceNum="5"/>
```

This data tells the template to:

* Select orders with `facilityId = 'UNFILLABLE_PARKING'`
* Sort the result by `orderDate`

---

## 🧠 Clarification Questions Asked (and Answered)

| #  | Question                                                  | Answer                                                                                                                                                                          |
| -- | --------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 1  | How is `OrderFilterCondition` used in the SQL?            | It is loaded and injected into the context of the Freemarker template. The SQL WHERE clause is dynamically built using each filter condition (fieldName, operator, fieldValue). |
| 2  | Are filters applied at the order or item level?           | Both. Depending on `fieldName`, filters are applied to either the `order_header`, `order_item`, or related joined tables.                                                       |
| 3  | Can I use `orderDate` in filters and `statusId` together? | Yes. Multiple filters are joined using `AND` logic in the WHERE clause.                                                                                                         |
| 4  | What happens if a filter references a non-existent field? | The SQL generation may break or skip that condition depending on template error handling. Validation is expected before execution.                                              |
| 5  | What if I only define sort fields and no filters?         | The SQL will run and return all orders sorted by the fields.                                                                                                                    |
| 6  | What if a filter value doesn’t exist in the database?     | The SQL query will exclude those orders—no match, no row returned.                                                                                                              |
| 7  | Can I pass in multiple values for one filter (like IN)?   | Yes, by setting the `operator` to `in` and the `fieldValue` to a comma-separated list.                                                                                          |
| 8  | Is `ENTCT_SORT_BY` used in WHERE or ORDER BY?             | Only in `ORDER BY`. It's skipped from the WHERE clause.                                                                                                                         |
| 9  | What happens to invalid sort fields?                      | Freemarker ignores them or fails silently. It's up to validation logic to catch unsupported fields.                                                                             |
| 10 | Can filters refer to `order_item` only fields?            | Yes. Joins ensure both `order_header` and `order_item` are accessible.                                                                                                          |
| 11 | What is the default behavior if no filters are defined?   | The query selects all approved orders (based on hardcoded conditions) if `OrderFilterCondition` is empty.                                                                       |
| 12 | Where does the final list of eligible orders go?          | Into the context map (`candidateOrders`) passed to the next phase (routing rule evaluation).                                                                                    |

---

## ⚙️ Technical Flow — How the SQL Is Built

### Phase Input:

* `orderRoutingGroupId`
* List of `OrderFilterCondition` records for the group

### Phase Output:

* SQL result set of eligible orders:

  * `orderId`, `orderItemSeqId`, `productId`, `quantity`, etc.

### SQL Template: `EligibleOrdersQuery.sql.ftl`

The template uses logic like:

```ftl
<#list orderFilterList as filter>
  AND ${filter.fieldName} ${filter.operator} ${filter.fieldValue}
</#list>
```

This generates SQL WHERE conditions dynamically.

### ORDER BY logic:

```ftl
<#list orderSortList as sort>
  ORDER BY ${sort.fieldName}
</#list>
```

---

## 🧱 Sample Generated SQL Snippet

Based on this input:

```xml
<orderFilters fieldName="statusId" operator="equals" fieldValue="ORDER_APPROVED"/>
<orderFilters fieldName="orderDate" operator="greater-equals" fieldValue="2024-01-01"/>
<orderFilters conditionTypeEnumId="ENTCT_SORT_BY" fieldName="orderDate"/>
```

The SQL generated will look like:

```sql
SELECT oh.order_id, oi.order_item_seq_id, ...
FROM order_header oh
JOIN order_item oi ON oi.order_id = oh.order_id
WHERE oh.status_id = 'ORDER_APPROVED'
  AND oh.order_date >= '2024-01-01'
ORDER BY oh.order_date
```

---

## 🛠️ Best Practices and Validation Tips

* Validate that all field names are known and indexed.
* Ensure `fieldValue` types match the database column type.
* Prevent cross-field logic (e.g., filtering by `productId` and `carrierPartyId` inconsistently).
* Sort fields should be safe to ORDER BY across joined entities.
* Always test generated SQL for runtime performance.

---

## ✅ Summary

Phase 1 focuses on retrieving a filtered, sorted list of order items using dynamic SQL based on the `OrderFilterCondition` records. It's a flexible mechanism that adapts to any routing scenario defined at the `OrderRoutingGroup` level. Valid filters must align with existing entity fields and data types to work reliably.

This phase feeds clean input into the next stage: **OrderRoutingRule evaluation**, which determines facility eligibility and inventory matching.

---
