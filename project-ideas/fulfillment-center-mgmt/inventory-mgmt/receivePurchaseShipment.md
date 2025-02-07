# receivePurchaseShipment

```json
{
  "shipmentId": "PS12345",
  "statusId": "PURCH_SHIP_RECEIVED",
  "destinationFacilityId": "Facility123",
  "shipmentItems": [
    {
      "shipmentItemSeqId": "00001",
      "productId": "P1001",
      "orderId": "Order789",
      "orderItemSeqId": "00001",
      "quantity": 10,
      "quantityAccepted": 10,
      "quantityRejected": 0,
      "rejectionId": null
    },
    {
      "shipmentItemSeqId": "00002",
      "productId": "P1002",
      "orderId": "Order789",
      "orderItemSeqId": "00002",
      "quantity": 8,
      "quantityAccepted": 7,
      "quantityRejected": 1,
      "rejectionId": "DAMAGED"
    }
  ]
}
```

### Workflow

* Ensure statusId is "PURCH_SHIP_RECEIVED", 
* For each ShipmentItem, call [receiveProductInventory](../../oms/receiveProductInventory.md)