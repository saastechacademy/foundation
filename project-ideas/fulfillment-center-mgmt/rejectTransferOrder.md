# Reject Transfer Order	

## **Purpose:**

The POST transferOrders/{orderId}/reject API is used to reject the TO since it cannot be fulfilled from the source facility.

1. This API is written to be in-line with the current requirement of TO rejection. 
2. According to current behavior, the TO can only be rejected if fulfilment has not been started i.e. no shipped or packed shipments exists for the TO. 
3. The complete TO will be rejected, no partial rejection will be handled as of now.
4. The items are rejected using the reject#OrderItem oms service.
5. The Transfer Order will be moved to REJECTED_ITM_PARKING facility. 
6. The Order Item reservations will be cancelled. 
7. The Inventory Variance will be logged based on the rejectionReasonId handling in reject#OrderItem oms service.

## **API Spec:**

### API parameters

**Input**
1. orderId* - The ID of the Transfer Order Shipment in OMS.
2. rejectToFacilityId - default-value="REJECTED_ITM_PARKING"
3. items* - The list of order items to be fulfilled.
   1. orderItemSeqId - The Seq ID of the Transfer Order Item in OMS.
   2. rejectionReasonId - The rejection reason ID of the Transfer Order Item in OMS.

### Sample Payload

* Method: POST
* API: {baseUrl}/rest/s1/poorti/transferOrders/M101735/reject

* Input:
```json
{
  "items": [
    {
      "rejectionReasonId": "NO_VARIANCE_LOG",
      "orderItemSeqId": "01"
    },
    {
      "rejectReason": "NO_VARIANCE_LOG",
      "orderItemSeqId": "02"
    }
  ]
}
```


