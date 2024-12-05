## packShipment

1.  **Input:**

```json

{
  "shipmentId": "10025",
  "shipmentPackageContents":[
    {
      "shipmentItemSeqId": "001",
      "shipmentPackageSeqId": "00001",
      "quantity": 1
    },
    {
      "shipmentPackageSeqId": "00002",
      "shipmentItemSeqId": "00002",
      "quantity": 1
    }
    ],
  "rejectedShipmentItems": [
    {
      "shipmentItemSeqId": "00001",
      "rejectToFacilityId": "FAC003",
      "rejectionReasonId" : "REJ_RSN_DAMAGED",
      "comments": "The item was part of a display and is not in acceptable condition."
    },
    {
      "shipmentItemSeqId": "00003",
      "rejectToFacilityId": "FAC003",
      "rejectionReasonId" : "REJ_RSN_DAMAGED",
      "comments": "The item was part of a display and is not in acceptable condition."
    }
  ]
}
```
2.  **Fetch Shipment:**
    *   Validate that the shipment exists and is in the `SHIPMENT_APPROVED` status (precondition).

3.  **Process Shipment Items:**
    *   Reject shipmentItems 
    *   Compute diff between ShipmentPackageContent and the packed items list. Update ShipmentPackageContent state in the database if necessary.

4.  **Update Shipment Status:**
    *   Update the `statusId` of the `Shipment` entity to `SHIPMENT_PACKED` (postcondition), indicating it's been packed and is ready for shipment.

5.  **Fetch Order and Order Item Details:**
    *   For each `ShipmentItem`, use the `OrderShipment` entity to find the corresponding `orderId` and `orderItemSeqId`.

6.  **Update PicklistOrderItem Items:**
    *   For each `orderId` and `orderItemSeqId` pair, query the `PicklistOrderItem` entity to find associated items.
    *   Update the `itemStatusId` of these `PicklistItem` entities to `PICKITEM_PICKED`, indicating they have been picked for the packed shipment.


## Java Code Skeleton


### Key Corrections

*   **Shipment Status:** The precondition is now correctly checked for `SHIPMENT_APPROVED`, and the postcondition updates the status to `SHIPMENT_PACKED`.

