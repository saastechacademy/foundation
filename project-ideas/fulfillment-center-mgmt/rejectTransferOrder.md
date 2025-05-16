# Reject Transfer Order	

## **Purpose:**

* The POST transferOrders/{orderId}/reject API is used to reject the TO since it cannot be fulfilled from the source facility.

## **API Spec:**

* This API is written to be in-line with the current requirement of TO rejection. 
* According to current behavior, the TO can only be rejected if fulfilment has not been started i.e. no shipped shipments for the TO exists. 
* The complete TO will be rejected, no partial rejection handled as of now.

#### API parameters

**Input**
1. orderId* - The ID of the Transfer Order Shipment in OMS.
2. items* - The list of order items to be fulfilled.
   1. orderItemSeqId - The Seq ID of the Transfer Order Item in OMS.
   2. shipGroupSeqId - The Ship Group Seq ID of the Transfer Order Item in OMS.
   3. productId - The ID of the product in OMS for the Transfer Order Item.

### Sample Payload

* Method: POST
* API: {baseUrl}/rest/s1/poorti/transferOrders/M101735/reject

* Input:
```json
{
  "orderId": "12163",
  "items": [
    {
      "rejectionReasonId": "NO_VARIANCE_LOG",
      "facilityId": "BROOKLYN",
      "orderItemSeqId": "00101",
      "naFacilityId": "REJECTED_ITM_PARKING"
    },
    {
      "rejectReason": "NO_VARIANCE_LOG",
      "facilityId": "BROOKLYN",
      "orderItemSeqId": "00102",
      "naFacilityId": "REJECTED_ITM_PARKING"
    }
  ]
}
```


