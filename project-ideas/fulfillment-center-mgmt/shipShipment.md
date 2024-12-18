# shipShipment

For each shipmentItem in shipment

- update#OrderItem status to ITEM_COMPLETED
- update OrderItem fulfillment status in SOLR document.
- [createItemIssuance](inventory-mgmt/ItemIssuance.md)
- [delete#OrderItemInvRes](inventory-mgmt/Inventory.md)
- [create#InventoryItemDetail](inventory-mgmt/Inventory.md) record for released inventory qty.

then, 
Update shipment status to SHIPMENT_SHIPPED.

