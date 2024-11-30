# rejectShipmentItems(shipmentItems)

May be we have easier way to do pass list of ShipmentItems to reject. 

**IN Parameters:**
```json
[
  {
    "shipmentId": "SHIP001",
    "shipmentItemSeqId": "0001",
    "rejectToFacilityId": "FAC001",
    "rejectionReasonId": "DAMAGE",
    "comments": "The item was damaged during transit."
  },
  {
    "shipmentId": "SHIP001",
    "shipmentItemSeqId": "0002",
    "rejectToFacilityId": "FAC002",
    "rejectionReasonId": "MISMATCH",
    "comments": "The item details did not match the packing slip."
  },
  {
    "shipmentId": "SHIP002",
    "shipmentItemSeqId": "0001",
    "rejectToFacilityId": "FAC003",
    "rejectionReasonId": "NOT_IN_STOCK",
    "comments": "The item was out of stock upon shipment preparation."
  },
  {
    "shipmentId": "SHIP002",
    "shipmentItemSeqId": "0002",
    "rejectToFacilityId": "FAC004",
    "rejectionReasonId": "WORNDISPLAY",
    "comments": "The item was part of a display and is not in acceptable condition."
  },
  {
    "shipmentId": "SHIP003",
    "shipmentItemSeqId": "0001",
    "rejectToFacilityId": "FAC005",
    "rejectionReasonId": "NOT_IN_STOCK",
    "comments": "Insufficient stock for shipment completion."
  }
]

```

### Workflow
*   For each ShipmentItem
    *   Call rejectShipmentItem service

If you want to reject all shipments that have items for shipping certain product, 
First lookup all the Shipments in process at current facility and then issue reject ShipmentItems request for them.

