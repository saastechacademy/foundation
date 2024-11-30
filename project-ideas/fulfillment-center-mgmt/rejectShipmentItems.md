# rejectShipmentItems(shipmentItems)

May be we have easier way to do pass list of ShipmentItems to reject. 

**IN Parameters:**
```json
[
  {
    "shipmentId": "SHIP001",
    "shipmentItemSeqId": "0001"
  },
  {
    "shipmentId": "SHIP001",
    "shipmentItemSeqId": "0002"
  },
  {
    "shipmentId": "SHIP002",
    "shipmentItemSeqId": "0001"
  },
  {
    "shipmentId": "SHIP002",
    "shipmentItemSeqId": "0002"
  }
]

```

### Workflow
*   For each ShipmentItem
    *   Call rejectShipmentItem service

If you want to reject all shipments that have items for shipping certain product, 
First lookup all the Shipments in process at current facility and then issue reject ShipmentItems request for them.

