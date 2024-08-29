# **OrderItemShipGrpInvRes**
Reserve inventory for the OrderItem from the fulfillment location. 

## Workflow
- Create OrderItemShipGrpInvRes
- Create InventoryItemDetail
- Compute ATP and update ProductFacility table. 

## Data State Changes

### Before Reservation Process

**OrderHeader**
| orderId | orderTypeId | statusId        |
|---------|--------------|-----------------|
| 10000   | SALES_ORDER  | ORDER_APPROVED  |

**OrderItem**
| orderId | orderItemSeqId | productId | quantity |
|---------|-----------------|-----------|----------|
| 10000   | 00001           | prod-01   | 1        |
| 10000   | 00002           | prod-02   | 1        |
| 10000   | 00003           | prod-03   | 1        |
| 10000   | 00004           | prod-04   | 1        |

**OrderItemShipGroup**
| orderId | shipGroupSeqId | shipmentMethodTypeId | carrierPartyId | carrierRoleTypeId |
|---------|-----------------|----------------------|----------------|-------------------|
| 10000   | 00001           | PRIORITY             | USPS           | CARRIER           |

### After Reservation Process

**OrderHeader**
| orderId | orderTypeId | statusId        |
|---------|--------------|-----------------|
| 10000   | SALES_ORDER  | ORDER_APPROVED  |

**OrderItem**
| orderId | orderItemSeqId | productId | quantity |
|---------|-----------------|-----------|----------|
| 10000   | 00001           | prod-01   | 1        |
| 10000   | 00002           | prod-02   | 1        |
| 10000   | 00003           | prod-03   | 1        |
| 10000   | 00004           | prod-04   | 1        |

**OrderItemShipGroup**
| orderId | shipGroupSeqId | shipmentMethodTypeId | carrierPartyId | carrierRoleTypeId |
|---------|-----------------|----------------------|----------------|-------------------|
| 10000   | 00001           | PRIORITY             | USPS           | CARRIER           |

**OrderItemShipGrpInvRes**
| orderId | shipGroupSeqId | orderItemSeqId | inventoryItemId | quantity |
|---------|-----------------|----------------|------------------|----------|
| 10000   | 00001           | 00001          | 2001             | 1        |
| 10000   | 00001           | 00002          | 2004             | 1        |
| 10000   | 00001           | 00003          | 2101             | 1        |
| 10000   | 00001           | 00004          | 2318             | 1        |

**InventoryItemDetail**
| inventoryItemDetailSeqId | orderId | shipGroupSeqId  | orderItemSeqId | inventoryItemId | availableToPromiseDiff |
|--------------------------|---------|-----------------|----------------|---------------- |------------------------|
| 36075                    | 10000   | 00001           | 00001          | 2001            | -1                     |
| 36076                    | 10000   | 00001           | 00002          | 2004            | -1                     |
| 36077                    | 10000   | 00001           | 00003          | 2101            | -1                     |
| 36078                    | 10000   | 00001           | 00004          | 2318            | -1                     |
