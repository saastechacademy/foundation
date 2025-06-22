# Design Notes: `RuleEffectivenessSnapshot`

## 🎯 Purpose

The `RuleEffectivenessSnapshot` is a key telemetry record for the Fulfillment Advisor Agent. It captures a time-stamped summary of how an `OrderRoutingGroup` performed in a given `BrokeringRun`, enabling the agent to:

- Evaluate routing strategy effectiveness
- Monitor KPIs like brokered rate, split rate, shipping cost
- Detect regressions or improvements across rule versions
- Optimize rule configurations over time based on historical performance

This snapshot is purely observational and is never used to route orders directly. It supports both **automated intelligence** and **human decision-making**.

---

## 📦 Entity Structure

| Field Name               | Type      | Description |
|--------------------------|-----------|-------------|
| `snapshotId`             | ID (PK)   | Unique identifier for the snapshot |
| `routingRunId`           | FK        | Foreign key to `OrderRoutingRun` that triggered this snapshot |
| `routingGroupId`         | FK        | Foreign key to `OrderRoutingGroup` |
| `ruleConfigHash`         | String    | Deterministic hash of the routing rule + inventory configuration |
| `attemptedItemCount`     | Integer   | Total number of order items evaluated during the routing run |
| `brokeredItemCount`      | Integer   | Number of order items that were successfully routed |
| `brokeredRate`           | Decimal % | Ratio of brokered items to attempted items |
| `splitRate`              | Decimal % | % of routed orders that were split across multiple facilities |
| `actualShippingCost`     | Decimal   | Average fulfillment cost per order (`ShipmentRouteSegment.actualCost`) |
| `chargedShippingAmount`  | Decimal   | Average shipping charge per order (`OrderAdjustment.amount`) |
| `netShippingMargin`      | Decimal   | `chargedShippingAmount - actualShippingCost` (optional derived field) |
| `slaMissRate`            | Decimal % | % of routed orders where SLA was missed |
| `snapshotTimestamp`      | DateTime  | Timestamp of when the snapshot was generated |
| `createdByAgent`         | Boolean   | Whether the snapshot was created by the Fulfillment Advisor |
| `notes`                  | Text      | Optional human-readable comments or diagnostics |

---

## 🧮 Field Computation Logic

### 1. `attemptedItemCount` & `brokeredItemCount`
- **Source**: `OrderRoutingRun`
- These are already recorded by the routing engine during the run.
- Can be optionally recomputed from `OrderFacilityChange` + `OrderItem`

### 2. `brokeredRate`
```
brokeredRate = brokeredItemCount / attemptedItemCount
```
- Measures overall success rate of the routing logic
- If rules are too strict, brokered rate will drop even if inventory exists

### 3. `splitRate`
- **Source**: `OrderFacilityChange`
- Detect if `COUNT(DISTINCT facilityId)` > 1 per `orderId`
```
splitRate = orders_with_splits / total_routed_orders
```

### 4. `actualShippingCost`
- **Source**: `ShipmentRouteSegment.actualCost`
- Join by `orderId`, `shipmentId`, and/or `orderItemShipGroup`

### 5. `chargedShippingAmount`
- **Source**: `OrderAdjustment.amount` where `orderAdjustmentTypeId = SHIPPING_CHARGES`
- Aggregate by `orderId`, then compute average

### 6. `netShippingMargin`
```
netShippingMargin = chargedShippingAmount - actualShippingCost
```
- Reveals financial effectiveness of routing decisions
- Enables comparison between free and paid shipping strategies

### 7. `slaMissRate`
- **Source**:
  - Target SLA: `OrderItemShipGroup.estimatedShipDate` or derived from configuration
  - Actual ship date: `Shipment.actualShipDate` or `ShipmentRouteSegment.actualShipDate`
```
slaMissRate = lateShipments / totalRoutedOrders
```

### 8. `ruleConfigHash`
- Deterministic hash of the full routing + inventory rule setup
- Input JSON includes:
  - All `OrderRoutingRule`s and `OrderFilterCondition`s
  - `OrderRoutingRuleInvCond`s
  - `OrderRoutingRuleAction`s
- Normalize, sort, and serialize this config → apply SHA-256 hash

---

## 🔁 Example Use Cases Enabled

| Question | Answered By |
|----------|-------------|
| “Did this routing config improve brokered rate?” | Compare snapshots by `ruleConfigHash` |
| “How much did free shipping cost us last week?” | Compare `actualShippingCost` vs. `chargedShippingAmount` |
| “Is SLA performance worse under fallback-to-store rules?” | Track `slaMissRate` for store-prioritized configs |
| “Are we oversplitting orders after rule changes?” | Watch `splitRate` across runs |

---

## 🧠 Next Step

Once this structure is finalized, the next design milestone will be:

✅ **Designing the snapshot generation service**  
→ Input: `routingRunId`  
→ Output: Fully populated `RuleEffectivenessSnapshot` record
