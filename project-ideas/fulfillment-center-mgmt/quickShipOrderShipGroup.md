# quickShipOrderShipGroup

API to fulfill orders. 
Shortcut method, if fulfillment center is not executing full pick/pack/ship steps on the floor.
This service will be most useful to complete the POS sales. 

### Parameters
```json
{
   "orderId": "10000",
  "orderItems": [
    {
      "orderId": "10000",
      "orderItemSeqId": "00101",
      "shipGroupSeqId": "00002",
      "productId": "10001",
      "inventoryItemId": "10000",
      "quantity": 1
    },
    {
      "orderId": "10000",
      "orderItemSeqId": "00102",
      "shipGroupSeqId": "00002",
      "productId": "10017",
      "inventoryItemId": "10000",
      "quantity": 1
    }
  ]
}
```

### Workflow
1. Service Call: `co.hotwax.poorti.FulfillmentServices.create#SalesOrderShipment`.
   -  Using the incoming parameters, prepare data to create SalesOrderShipment in `SHIPMENT_SHIPPED` status.
   -  The Picking and Packaging process is not required, the input shipment map will have `shipment` `shipmentItems`,`orderShipments`.
3. create#ItemIssuance
   - create itemIssuance record for each ShipmentItem. 
4. Service Call (Iteration): `co.hotwax.poorti.SearchServices.update#OrderFulfillmentStatus`
   - update orderItem fulfillment status on Order document in SOLR. 
