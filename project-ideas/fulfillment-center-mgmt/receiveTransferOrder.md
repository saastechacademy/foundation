# Receive Transfer Order Items	

## **Purpose:**

The POST transferOrders/{orderId}/receipts API is used to receive the items in the transfer order.

1. The API receives the quantity for the TO items.
2. The API service internally prepares the itemReceipts list to split the incoming items to be received as per Order Shipments available. 
3. The quantity to be received for an item will be split across one or more shipments as per the required quantity available to receive in each Shipment.
4. If over-receiving the quantity for an item, a receipt with excess quantity will be created against the item only without any shipment references.
5. Eg. If a TO item is included in 2 Shipments S1 and S2 with quantities 5 and 10 respectively. If the quantity
  being received is item wise i.e. 15, this will break down the one incoming receipt into 2 receipts with
  5 quantity for S1 Shipment and 10 quantity for S2 Shipment respectively.
6. The service will create the records in ShipmentReceipt entity.
7. The corresponding InventoryItemDetail records will get created with the reference of ShipmentReceipt in the receiptId field. 
8. The Order Items will be updated to 'ITEM_COMPLETED' status if all quantity is received for the item, else it will remain 
   in ITEM_PENDING_RECEIPT status if being partially received and the item can still be received in the future.
9. If all items will be completed, the service will check the order and mark as ORDER_COMPLETED status. 

## **API Spec:**

### API parameters

**Input**
1. orderId* - The ID of the Transfer Order in OMS.
2. facilityId* - The ID of the facility in OMS where Transfer Order is being received.
3. items* - The list of order items to be received. 
   1. orderItemSeqId - The Seq ID of the Transfer Order Item in OMS.
   2. productId - The ID of the product in OMS for the Transfer Order Item.
   3. quantityAccepted - The quantity of the item to be received.
   4. quantityRejected - The quantity of the item to be rejected.
   5. reasonEnumId - The ID of the reason enum in OMS for receiving the order items.
   6. statusId - Send this as ITEM_COMPLETED for "Receive and Close".
  
### Sample Payloads

**Scenario 1 - Receive Items**

* Method: POST
* API: {baseUrl}/rest/s1/poorti/transferOrders/M101073/receive
  
* Input:
 ```json
 {
  "facilityId": "BROADWAY",
  "items": [
    {
      "orderItemSeqId": "01",
      "productId": "10784",
      "quantityAccepted": 5
    },
    {
      "orderItemSeqId": "02",
      "productId": "10326",
      "quantityAccepted": 10
    }
  ]
}
 ```

**Scenario 2 - Receive quantity & Close -**

Here, receive the quantity and set the statusId as ITEM_COMPLETED since item is being requested for closing its receiving.

* Method: POST
* API: {baseUrl}/rest/s1/poorti/transferOrders/M101073/receive

* Input:
 ```json

{
  "facilityId": "WEST_JORDAN",
  "items": [
    {
      "orderItemSeqId": "01",
      "productId": "10079",
      "quantityAccepted": 1,
      "statusId": "ITEM_COMPLETED"
    }
  ]
}
 ```

**Scenario 3 - Receive & Close -**

Here, no quantity is being received but only the statusId is being set as ITEM_COMPLETED, since item is being requested for closing its receiving.

* Method: POST
* API: {baseUrl}/rest/s1/poorti/transferOrders/M101073/receive

* Input:
 ```json
{
  "facilityId": "WEST_JORDAN",
  "items": [
    {
      "orderItemSeqId": "01",
      "productId": "10079",
      "statusId": "ITEM_COMPLETED"
    }
  ]
}
 ```

**Scenario 4 - Receive New Item -**

Here, no orderItemSeqId is being passed, the item will be received in the TO using productId.

* Method: POST
* API: {baseUrl}/rest/s1/poorti/transferOrders/M101073/receive

* Input:
 ```json
{
  "facilityId": "WEST_JORDAN",
  "items": [
    {
      "productId": "10079",
      "quantityAccepted": 1
    }
  ]
}
 ```


