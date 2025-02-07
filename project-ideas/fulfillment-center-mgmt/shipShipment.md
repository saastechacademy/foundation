# shipShipment

For each shipmentItem in shipment

- update#OrderItem status to ITEM_COMPLETED
- update OrderItem fulfillment status in SOLR document.
- [createItemIssuance](../oms/createItemIssuance)
- [delete#OrderItemInvRes](../oms/Inventory.md)
- [create#InventoryItemDetail](../oms/Inventory.md) record for released inventory qty.

then, 
Update shipment status to SHIPMENT_SHIPPED.

