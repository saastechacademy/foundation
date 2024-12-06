# createOrderShipmentInventoryIssuance
On Shipment shipped, issue inventory and complete order item. 
### Scope
*   OMS has one InventoryItem per facility per product 
*   If shipment is shipped, create ItemIssuance even if QOH is 0. Systemic inventory accuracy is about 60%.
*   Partial OrderItem fulfillment is not supported. For each ShipmentItem, we have one OrderItem.

For ShipmentItem, Lookup OrderShipment and then lookup OrderItemShipGrpInvRes. 

For each OrderItemShipGrpInvRes, 
create ItemIssuance, knowing we have one inventoryItem per product and that if shipment is shipped, create ItemIssuance even if QOH is 0. 
create InventoryItemDetail
remove OrderItemShipGrpInvRes
update OrderItem status to Completed.



https://git.hotwax.co/commerce/oms/blob/371fe6c4251c11438e590bf21e98290f8e64a235/applications/product/minilang/shipment/issuance/IssuanceServices.xml#L134
https://git.hotwax.co/commerce/oms/blob/371fe6c4251c11438e590bf21e98290f8e64a235/applications/product/minilang/shipment/issuance/IssuanceServices.xml#L420


https://git.hotwax.co/commerce/oms/blob/4fd86d2834ea7965542d38d11e88b8dd2dfaad3b/applications/hwmapps/minilang/warehouse/WarehouseServices.xml#L897
https://git.hotwax.co/commerce/oms/blob/4fd86d2834ea7965542d38d11e88b8dd2dfaad3b/applications/hwmapps/minilang/warehouse/WarehouseServices.xml#L1114
