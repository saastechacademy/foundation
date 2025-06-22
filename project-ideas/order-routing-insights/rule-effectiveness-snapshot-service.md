# Design: RuleEffectivenessSnapshot Generation Service (Updated)

## 🎯 Purpose

This service computes and stores a `RuleEffectivenessSnapshot` for a given `routingRunId`, using data from routing logs, shipment, inventory, and financials. It will run as a scheduled job once daily after business hours.

This updated version also captures **fallback behavior**, i.e. how often the engine had to skip rules before successfully fulfilling inventory.

---

## 📛 Service Name

```
create#RuleEffectivenessSnapshot
```

---

## ⚙️ Input Parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `routingRunId` | String | ✅ | Primary key to identify which routing run to analyze |

---

## 📤 Output Parameters

| Name | Type | Description |
|------|------|-------------|
| `snapshotId` | String | The ID of the newly created RuleEffectivenessSnapshot |
| `responseMessage` | String | Success or error details |

---

## 📦 Computation Overview

- Fetch the related `OrderRoutingRun`, `OrderRoutingBatch`, and `OrderRoutingGroup`
- Pull `OrderFacilityChange` to determine what was routed
- Join with:
  - `OrderItem`, `OrderItemShipGrpInvRes` — to count reserved items
  - `ShipmentRouteSegment` — to compute `actualShippingCost`
  - `OrderAdjustment` — to compute `chargedShippingAmount`
- Calculate:
  - `brokeredRate`
  - `splitRate`
  - `slaMissRate`
  - `netShippingMargin`
  - **`rulesSkippedBeforeSuccessAvg`**
  - **`rulesSkippedBeforeSuccessMax`**
  - **`firstRuleSuccessRate`**
- Serialize rule configuration (filters + actions) and generate `ruleConfigHash`
- Store the computed values in a new `RuleEffectivenessSnapshot`

---

## 📄 Moqui Service Definition (Template)

```xml
<service verb="create" noun="RuleEffectivenessSnapshot" authenticate="true" require-new-transaction="true">
  <description>Create a snapshot of routing rule effectiveness for a given routingRunId</description>
  <in-parameters>
    <parameter name="routingRunId" required="true"/>
  </in-parameters>
  <out-parameters>
    <parameter name="snapshotId"/>
    <parameter name="responseMessage"/>
  </out-parameters>
  <actions>
    <!-- Step 1: Load RoutingRun and Related Entities -->
    <entity-find-one entity-name="co.hotwax.order.routing.OrderRoutingRun" value-field="routingRun"/>
    <if condition="!routingRun">
      <return error="true" message="No routing run found for ID ${routingRunId}"/>
    </if>

    <!-- Placeholder: Load and analyze OrderFacilityChange and Rule sequence -->
    <!-- Compute skipped rules and first rule match rate -->

    <!-- Step N: Create Snapshot Record -->
    <make-value entity-name="co.hotwax.order.analytics.RuleEffectivenessSnapshot" value-field="snapshot"/>
    <set field="snapshot.routingRunId" from="routingRunId"/>
    <set field="snapshot.routingGroupId" from="routingRun.routingGroupId"/>
    <set field="snapshot.routingBatchId" from="routingRun.routingBatchId"/>
    <set field="snapshot.snapshotTimestamp" from="ec.user.nowTimestamp"/>
    <set field="snapshot.createdByAgent" value="false"/>
    <!-- Add calculated fields: brokeredRate, splitRate, netShippingMargin, slaMissRate -->
    <!-- Add new fields: rulesSkippedBeforeSuccessAvg, rulesSkippedBeforeSuccessMax, firstRuleSuccessRate -->

    <create value-field="snapshot"/>

    <set field="snapshotId" from="snapshot.snapshotId"/>
    <set field="responseMessage" value="Snapshot created successfully"/>
  </actions>
</service>
```

---

## ➕ Additional Fields to Add in `RuleEffectivenessSnapshot` Entity

| Field | Type | Description |
|-------|------|-------------|
| `firstRuleSuccessRate` | Decimal % | % of successful routes fulfilled by the first-sequence rule |
| `rulesSkippedBeforeSuccessAvg` | Decimal | Average number of rules skipped before a successful rule |
| `rulesSkippedBeforeSuccessMax` | Integer | Max number of rules skipped for any single item |

---

## 🕐 Scheduling

This service will be invoked **once daily**, after business hours (e.g., 11:00 PM local time), using a scheduled job (ServiceJob + cron expression). It can process:
- All `OrderRoutingRun` records from the current day
- Or any `routingRunId` passed explicitly for reprocessing

---

Let me know when you're ready to implement logic for evaluating rule sequences from the demo data.
