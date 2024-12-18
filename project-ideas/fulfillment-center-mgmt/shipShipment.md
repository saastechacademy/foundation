# shipShipment

For each shipmentItem in shipment

- update#OrderItem status to ITEM_COMPLETED
- update OrderItem fulfillment status in SOLR document.
- [createItemIssuance](inventory-mgmt/ItemIssuance.md)
- [cancelOrderItemInvRes](inventory-mgmt/cancelOrderItemInvRes.md)

then, 
Update shipment status to SHIPMENT_SHIPPED.

