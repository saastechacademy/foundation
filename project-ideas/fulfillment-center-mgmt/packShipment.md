## packShipment

1.  **Input:**

The shipmentPackageContents and rejectedShipmentItems are optional parameters. Their values will be null, If shipment is not modified since last approved.



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
2.  **[reinitiazeShipment](reinitializeShipment.md):**
    *   if rejectedShipmentItems has one or more items, before we reject items, shipment should be in input status. 
    *   if shipmentPackageContents has one or more items, compare with shipment package contents data in database. if diff is found, ensure shipment is in input status before data is saved to database.
    
3.  **Process Shipment Items:**
    *   Reject shipmentItems 
    *   Compute diff between ShipmentPackageContent and the packed items list. Update ShipmentPackageContent state in the database if necessary.

4.  **Update Shipment Status:**
    *   if the shipment status is input, then 
      -   call [approveShipment](approveShipment.md).
      -   if facility is not part of the auto shipping label group, then [getShippingLabel](getShippingLabel.md)
    *   Update the `statusId` of the `Shipment` entity to `SHIPMENT_PACKED` (postcondition), indicating it's been packed and is ready for shipment.
    *   Update OrderItem fulfillmentStatus to Packed on SOLR document