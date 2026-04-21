# 🧩 OrderFilterCondition in OrderRoutingGroup — Entity Model and SQL Context

## Overview
This document provides a detailed breakdown of the `OrderFilterCondition` entity and its role within the `OrderRoutingGroup` configuration in the HotWax Commerce OMS. It also explains how these filter conditions depend on enum-driven field references and master data entities. This is critical for ensuring safe promotion of routing configurations across environments.

---

## 📦 Core Entity Hierarchy

### 1. `OrderRoutingGroup`
- Represents the top-level group used to organize routing logic
- Linked to a `ProductStore`
- Associated with a scheduled `ServiceJob` for brokering runs

### 2. `OrderRouting`
- A routing configuration under a group
- Can have multiple order filters and rules
- Defines scope (e.g., same-day orders, rejected orders, etc.)

### 3. `OrderFilterCondition`
- Used to define filter logic on orders
- Example filters: `promiseDaysCutoff`, `shipmentMethodTypeId`, `priority`
- Uses `fieldName`, `operator`, `fieldValue`
- Driven by enumeration `ORD_FILTER_PRM_TYPE`

### 4. `OrderRoutingRule`
- Represents one fulfillment strategy attempt
- Defines assignment logic (single facility, multi, etc.)
- Executes in sequence until a rule succeeds or all fail

### 5. `OrderRoutingRuleInvCond`
- Inventory filters applied inside a rule
- Example: filter by `facilityGroupId`, `distance`, `inventoryForAllocation`

### 6. `OrderRoutingRuleAction`
- What to do after a rule runs: reserve, fallback, next rule
- Driven by enumeration type `ORD_ROUTING_ACTION`

---

## 🔗 Enum-Driven Dependencies on Master Data

Even though routing entities themselves don’t have FK relationships to master data, many of their configured filters and actions **depend on valid external references**.

### Examples:

| `fieldName` in Filter or Rule | Requires Entity | Notes |
|------------------------------|------------------|-------|
| `facilityId`                 | `Facility`       | Used for queues or routing locations |
| `originFacilityGroupId`     | `FacilityGroup`  | Used in geo-based rules |
| `productCategoryId`         | `ProductCategory`| For category-based routing |
| `shipmentMethodTypeId`      | `ShipmentMethodType` | Filters on shipping methods |
| `priority`                  | `Enumeration` (ORDER_PRIORITY) | Business priority labels |
| `salesChannelEnumId`        | `Enumeration` (SALES_CHANNEL) | e.g., WEB, STORE |

---

## 🧠 SQL Template: `EligibleOrdersQuery.sql.ftl` Reference

The filtering logic defined in `OrderFilterCondition` is dynamically injected into SQL using the `EligibleOrdersQuery.sql.ftl` template. This template translates each filter into a `WHERE` clause using a FreeMarker macro:

```ftl
<@buildSqlCondition fieldName filterCondition>
  ${fieldName} ${Static["co.hotwax.order.routing.OrderRoutingHelper"].makeSqlWhere(filterCondition)!}
</@buildSqlCondition>
```

Within the template:
- Filters from the database are looped over with:
```ftl
<#list orderFilterConditions as filterCondition>
  AND <@buildSqlCondition filterCondition.fieldName filterCondition/>
</#list>
```
- This dynamically appends SQL conditions for each configured filter.

This confirms that values in `OrderFilterCondition.fieldName` and `fieldValue` **must be valid and meaningful at runtime**, or they will result in broken or ineffective filtering logic.

### 📋 Enum List Used in Filters
Each filter fieldName is defined by an enum from `ORD_FILTER_PRM_TYPE`. Below are the currently supported enums and their meanings, all of which drive SQL logic in `EligibleOrdersQuery.sql.ftl`:

| Enum ID | fieldName Used in SQL | Description | Expected Reference |
|---------|------------------------|-------------|---------------------|
| `OIP_QUEUE` | `facilityId` | Queued facility for routing | `Facility.facilityId` |
| `OIP_SHIP_METH_TYPE` | `shipmentMethodTypeId` | Shipment method used | `ShipmentMethodType.shipmentMethodTypeId` |
| `OIP_PRIORITY` | `priority` | Order priority code | `Enumeration.enumId` (type `ORDER_PRIORITY`) |
| `OIP_PROMISE_DATE` | `promiseDaysCutoff` | SLA cutoff in days | Calculated value, no FK |
| `OIP_SALES_CHANNEL` | `salesChannelEnumId` | Sales channel identifier | `Enumeration.enumId` (type `SALES_CHANNEL`) |
| `OIP_ORIGIN_FAC_GRP` | `originFacilityGroupId` | Origin facility group | `FacilityGroup.facilityGroupId` |
| `OIP_PROD_CATEGORY` | `productCategoryId` | Product category | `ProductCategory.productCategoryId` |

These enum-defined filter fields form the core of the dynamic SQL generated for filtering eligible orders.

---

## ✅ Why This Matters

- These references are **not visible** in the entity model but are **critical to runtime behavior**.
- When promoting an `OrderRoutingGroup` to Production, validation scripts **must check** that all referenced IDs exist.
- Without validation, routing may silently fail or misroute orders.
- The logic implemented in `EligibleOrdersQuery.sql.ftl` shows how these filters directly influence order selection SQL.

This model serves as a foundation for safe export, version control, and promotion of routing configurations in production-grade OMS systems.
