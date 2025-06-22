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
| `routingBatchId`         | FK        | Foreign key to `OrderRoutingBatch`, grouping related routing runs |
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
- **Source**: `OrderRoutingRun` and `OrderRoutingBatch`
- These are recorded during execution and referenced in both entities

### 2. `brokeredRate`
```
brokeredRate = brokeredItemCount / attemptedItemCount
```

### 3. `splitRate`
- Count of orders with multiple `facilityId`s assigned in `OrderFacilityChange`

### 4. `actualShippingCost`
- Average of `ShipmentRouteSegment.actualCost` per `orderId`

### 5. `chargedShippingAmount`
- Average of `OrderAdjustment.amount` with `orderAdjustmentTypeId = SHIPPING_CHARGES`

### 6. `netShippingMargin`
```
netShippingMargin = chargedShippingAmount - actualShippingCost
```

### 7. `slaMissRate`
- Ratio of orders where `actualShipDate > estimatedShipDate`

### 8. `ruleConfigHash`
- SHA-256 hash of sorted, normalized JSON config of routing rules

---

## 🔁 Example Use Cases Enabled

| Question | Answered By |
|----------|-------------|
| “Did this routing config improve brokered rate?” | Compare snapshots by `ruleConfigHash` |
| “How much did free shipping cost us last week?” | Compare `actualShippingCost` vs. `chargedShippingAmount` |
| “Is SLA performance worse under fallback-to-store rules?” | Track `slaMissRate` for store-prioritized configs |
| “Are we oversplitting orders after rule changes?” | Watch `splitRate` across runs |

---

## 🔗 Relationship to Existing Model: `OrderRoutingBatch`

`OrderRoutingBatch` already tracks:
- `routingGroupId`
- `attemptedItemCount` and `brokeredItemCount`
- `startDate` and `endDate`
- `createdByUserId`

To avoid duplicating this, `RuleEffectivenessSnapshot` should link to `routingBatchId` and supplement it with:
- `ruleConfigHash`
- Additional KPIs like shipping cost, margin, and SLA
- Diagnostic and comparative insight not tracked by the batch

---

## 🧠 Next Step

Once this structure is finalized, the next design milestone will be:

✅ **Designing the snapshot generation service**  
→ Input: `routingRunId`  
→ Output: Fully populated `RuleEffectivenessSnapshot` record
