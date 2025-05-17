# Ship Outbound Transfer Shipment	

## **Purpose:**

* The POST transferShipments/{shipmentId}/ship API is used to ship the OUT_TRANSFER type shipment for the transfer order.   

## **API Spec:**

- The API marks the Transfer Shipment for the TO as Shipped.
- The service will update the trackingIdNumber, create Item Issuance, Inventory Item Detail and update the Shipment as SHIPMENT_SHIPPED.
- The Order Items will be updated to the next eligible Item Status based on the statusFlowId associated with the Transfer Order. 
  - If the TO is of type 'TO_Fulfill_Only', the items will be updated to 'ITEM_COMPLETED' status if all quantity is shipped for the item.
    - If all items will be completed, the service will check the order and mark as ORDER_COMPLETED status. 
  - If the TO is of type 'TO_Fulfill_And_Receive', the items will be updated to 'ITEM_PENDING_RECEIPT' status if all quantity is shipped for the item.

#### API parameters

**Input**
1. shipmentId* - The ID of the Transfer Order Shipment in OMS.
2. trackingIdNumber - The tracking number for the Shipment.
3. shipmentRouteSegmentId* - The ID of the Shipment Route Segment in OMS.

### Sample Payload

* Method: POST
* API: {baseUrl}/rest/s1/poorti/transferShipments/M101735/ship

* Input:
   ```json
   {
      "trackingIdNumber": "111111",
      "shipmentRouteSegmentId": "01"
   }
   ```


