# Receive Transfer Order Items	

1. Receive TO

## **Purpose:**
The POST transferOrders/{orderId}/receive API is used to receive the items in the transfer order.

1. The API receives the quantity for the TO items.
2. The quantity to be received for an item will be split across one or more shipments as per the required quantity available to receive in each Shipment.
3. If over-receiving the quantity for an item, a receipt with excess quantity will be created against the item only without any shipment references.
4. The service will create the records in ShipmentReceipt entity.
5. The corresponding InventoryItemDetail records will get created with the reference of ShipmentReceipt in the receiptId field. 

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

**Scenario 2 - Receive New Item -**

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

2. Receive And Close TO

## **Purpose:**
The POST transferOrders/{orderId}/receive API is used to receive the items in the transfer order.

1. The API receives the quantity for the TO items if quantity is also sent, else only updates the TO Item status to ITEM_COMPLETED.
2. The quantity to be received for an item will be split across one or more shipments as per the required quantity available to receive in each Shipment.
3. If over-receiving the quantity for an item, a receipt with excess quantity will be created against the item only without any shipment references.
4. The service will create the records in ShipmentReceipt entity.
5. The corresponding InventoryItemDetail records will get created with the reference of ShipmentReceipt in the receiptId field.

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

### Sample Payloads

**Scenario 1 - Receive quantity & Close**

Here, receive the quantity and set the statusId as ITEM_COMPLETED since item is being requested for closing its receiving.

* Method: POST
* API: {baseUrl}/rest/s1/poorti/transferOrders/M101073/receiveAndClose

* Input:
 ```json

{
  "facilityId": "WEST_JORDAN",
  "items": [
    {
      "orderItemSeqId": "01",
      "productId": "10079",
      "quantityAccepted": 1
    }
  ]
}
 ```

**Scenario 2 - Close TO Item for Receipt**

Here, no quantity is being received but only the statusId will be set as ITEM_COMPLETED, since item is being requested for closing its receiving.

* Method: POST
* API: {baseUrl}/rest/s1/poorti/transferOrders/M101073/receiveAndClose

* Input:
 ```json
{
  "facilityId": "WEST_JORDAN",
  "items": [
    {
      "orderItemSeqId": "01",
      "productId": "10079"
    }
  ]
}
 ```


