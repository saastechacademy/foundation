Here's the content formatted in Markdown:

---

## Data State Changes

### Before Reservation Process:

**OrderHeader**
| orderId | orderTypeId | statusId        |
|---------|--------------|-----------------|
| 10000   | SALES_ORDER  | ORDER_APPROVED  |

**OrderItem**
| orderId | orderItemSeqId | productId | quantity |
|---------|-----------------|-----------|----------|
| 10000   | 00001           | prod-01   | 4        |
| 10000   | 00002           | prod-02   | 12       |
| 10000   | 00003           | prod-03   | 7        |
| 10000   | 00004           | prod-04   | 1        |

**OrderItemShipGroup**
| orderId | shipGroupSeqId | shipmentMethodTypeId | carrierPartyId | carrierRoleTypeId |
|---------|-----------------|----------------------|----------------|-------------------|
| 10000   | 00001           | PROIRITY             | USPS           | CARRIER           |

### After Reservation Process:

**OrderHeader**
| orderId | orderTypeId | statusId        |
|---------|--------------|-----------------|
| 10000   | SALES_ORDER  | ORDER_APPROVED  |

**OrderItem**
| orderId | orderItemSeqId | productId | quantity |
|---------|-----------------|-----------|----------|
| 10000   | 00001           | prod-01   | 4        |
| 10000   | 00002           | prod-02   | 12       |
| 10000   | 00003           | prod-03   | 7        |
| 10000   | 00004           | prod-04   | 1        |

**OrderItemShipGroup**
| orderId | shipGroupSeqId | shipmentMethodTypeId | carrierPartyId | carrierRoleTypeId |
|---------|-----------------|----------------------|----------------|-------------------|
| 10000   | 00001           | PROIRITY             | USPS           | CARRIER           |

**OrderItemShipGrpInvRes**
| orderId | shipGroupSeqId | orderItemSeqId | inventoryItemId | quantity |
|---------|-----------------|----------------|------------------|----------|
| 10000   | 00001           | 00001          | 2001             | 4        |
| 10000   | 00001           | 00002          | 2004             | 12       |
| 10000   | 00001           | 00003          | 2101             | 7        |
| 10000   | 00001           | 00004          | 2318             | 1        |

---
