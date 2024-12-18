# createOrderShipmentInventoryIssuance
On Shipment shipped, issue inventory and complete order item. 
### Scope
*   OMS has one InventoryItem per facility per product 
*   If shipment is shipped, create ItemIssuance even if QOH is 0. Systemic inventory accuracy is about 60%.
*   Partial OrderItem fulfillment is not supported. For each ShipmentItem, we have one OrderItem.

For ShipmentItem, Lookup OrderShipment and OrderItemShipGrpInvRes. 

For each OrderItemShipGrpInvRes, 
create ItemIssuance, knowing we have one inventoryItem per product and that if shipment is shipped, create ItemIssuance even if QOH is 0. 
create InventoryItemDetail
delete OrderItemShipGrpInvRes
update OrderItem status to Completed.
