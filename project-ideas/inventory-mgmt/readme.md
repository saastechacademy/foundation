# Inventory Management systems 

[Inventory data model](Inventory.md)

InventoryItem
InventoryItemStatus
InventoryItemDetail
InventoryItemVariance
PhysicalInventory
PhysicalInventoryAndVariance
InventoryTransfer

**Important Notes:**

## Rejection:
1. Single ATP reduced by rejection
2. Single ATP and QoH reduced by rejection
3. Both of the above but for all qty
4. Release reservation and increase ATP
Link Order and Item to event

## Cycle Count:
1. Variance QoH to match counted Qty
2. Variance ATP to match counted Qty - Reservations
Link count and count item to event

## Log variance:
1. Log variance on ATP and QoH by given amount with given reason
Link userLogin to event

## Item shipped:
1. Reduce ATP for reservation
2. Reduce QoH for item shipped
Link order,, order item, shipment and shipment item to both events

## POS Sale:
1. Reduce ATP and QoH for item sold in store
Link order and item to event

##  Increase ATP and QoH
Link order, order item, shipment and shipment item to event

