# Design: RuleEffectivenessSnapshot Generation Service

## 🎯 Purpose

This service computes and stores a `RuleEffectivenessSnapshot` for a given `routingRunId`, using data from routing logs, shipment, inventory, and financials. It will run as a scheduled job once daily after business hours.

The snapshot captures both fulfillment performance and rule prioritization behavior, helping the Fulfillment Advisor Agent evaluate and optimize routing strategies.

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

## 📦 Entity Structure

| Field Name                    | Type      | Description |
|-------------------------------|-----------|-------------|
| `snapshotId`                  | ID (PK)   | Unique identifier for the snapshot |
| `routingRunId`                | FK        | Foreign key to `OrderRoutingRun` that triggered this snapshot |
| `routingBatchId`              | FK        | Foreign key to `OrderRoutingBatch`, grouping related routing runs |
| `routingGroupId`              | FK        | Foreign key to `OrderRoutingGroup` |
| `ruleConfigHash`              | String    | Deterministic hash of the routing rule + inventory configuration |
| `attemptedItemCount`          | Integer   | Total number of order items evaluated during the routing run |
| `brokeredItemCount`           | Integer   | Number of order items that were successfully routed |
| `brokeredRate`                | Decimal % | Ratio of brokered items to attempted items |
| `splitRate`                   | Decimal % | % of routed orders that were split across multiple facilities |
| `actualShippingCost`          | Decimal   | Average fulfillment cost per order (`ShipmentRouteSegment.actualCost`) |
| `chargedShippingAmount`       | Decimal   | Average shipping charge per order (`OrderAdjustment.amount`) |
| `netShippingMargin`           | Decimal   | `chargedShippingAmount - actualShippingCost` |
| `slaMissRate`                 | Decimal % | % of routed orders where SLA was missed |
| `firstRuleSuccessRate`        | Decimal % | % of brokered items fulfilled by the first-sequence rule |
| `rulesSkippedBeforeSuccessAvg`| Decimal   | Average number of rules skipped before success |
| `rulesSkippedBeforeSuccessMax`| Integer   | Maximum number of rules skipped in any single order item |
| `snapshotTimestamp`           | DateTime  | Timestamp of when the snapshot was generated |
| `createdByAgent`              | Boolean   | Whether the snapshot was created by the Fulfillment Advisor |
| `notes`                       | Text      | Optional human-readable comments or diagnostics |

---

## 🧮 Computation Logic

### Fulfillment Metrics

- **`brokeredRate`** = `brokeredItemCount / attemptedItemCount`
- **`splitRate`** = % of orders with more than one `facilityId` in `OrderFacilityChange`
- **`actualShippingCost`** = Avg of `ShipmentRouteSegment.actualCost` per order
- **`chargedShippingAmount`** = Avg of `OrderAdjustment.amount` with `orderAdjustmentTypeId = SHIPPING_CHARGES`
- **`netShippingMargin`** = `chargedShippingAmount - actualShippingCost`
- **`slaMissRate`** = % of orders where `actualShipDate > estimatedShipDate`

### Fallback Behavior Metrics
### Determining Rules Skipped Before Success

For each order item routed:

1. **Retrieve the ordered list of rule IDs** from `OrderRoutingRule` using `routingGroupId`, sorted by `sequenceNum`.
2. **Find the index** of the `routingRuleId` used (from `OrderFacilityChange`) in that list.
3. **Compute `rulesSkipped`** as the index value:
   - Index `0` means success by first rule → `rulesSkipped = 0`
   - Index `n` means the first `n` rules were skipped
4. Repeat for all successfully routed order items.

### Example

Given routing group rules:

```
orderedRuleIds = [R1, R2, R3, R4]
```

And actual routing results:

| OrderItem | routingRuleId | rulesSkipped |
|-----------|----------------|--------------|
| OI-001    | R1             | 0            |
| OI-002    | R3             | 2            |
| OI-003    | R4             | 3            |

Aggregate:

- `firstRuleSuccessRate = 1 / 3`
- `rulesSkippedBeforeSuccessAvg = (0+2+3)/3 = 1.67`
- `rulesSkippedBeforeSuccessMax = 3`


1. Load all `OrderRoutingRule`s for the routing group, sorted by `sequenceNum`
2. For each `OrderFacilityChange`:
   - Identify the `routingRuleId` used
   - Determine how many rules were skipped before it (based on sequence)
3. Aggregate across all items to compute:

| Metric | Formula |
|--------|---------|
| `firstRuleSuccessRate` | `fulfilledByFirst / totalBrokered` |
| `rulesSkippedBeforeSuccessAvg` | `SUM(rulesSkipped) / totalBrokered` |
| `rulesSkippedBeforeSuccessMax` | `MAX(rulesSkipped)` |

---

## 🛠 Moqui Service Template

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
    <!-- Load RoutingRun, OrderRoutingBatch, and RoutingGroup -->
    <!-- Load RoutingRules by sequenceNum into orderedRuleIds -->
    <!-- Load OrderFacilityChange by routingRunId -->

    <!-- Iterate: compute skipped rules per item -->
    <!-- Aggregate: count, sum, max for fallback metrics -->

    <!-- Compute other KPIs (shipping, SLA, etc.) -->

    <!-- Create RuleEffectivenessSnapshot record -->
  </actions>
</service>
```

---
