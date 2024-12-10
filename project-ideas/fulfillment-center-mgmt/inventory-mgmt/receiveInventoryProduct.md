# `receiveInventoryProduct`

```json
{
  "facilityId": "Facility123",
  "productId": "Product456",
  "orderId": "Order789",
  "orderItemSeqId": "00001", 
  "quantityAccepted": 10,
  "quantityRejected": 2,  
  "shipmentId": "ShipmentABC",
  "shipmentItemSeqId": "00001" 
}
```

3. Inventory Item Handling:
    * It checks if `inventoryItemId` is provided.
    * If not, call helper service to get [inventoryItemId](findOrCreateFacilityInventoryItem.md)

5. Inventory Item Detail and Shipment Receipt:
    * call the `createInventoryItemDetail` service to record the change in inventory.
    * call the `createShipmentReceipt` service to create a record of the shipment receipt.

   

OOTB OFBiz has, The call to `updateInventoryItem` service in the `receiveInventoryProduct` service.
In OMS, we don't need to call `updateInventoryItem` from `receiveInventoryProduct` service because, 
the `updateInventoryItem` updates attributes other than `availableToPromiseTotal` and `quantityOnHandTotal`. None of those attributes of used in OMS. 
