# Close Transfer Order Item Fulfillment	

## **Purpose:**

* The POST transferOrders/{orderId}/closeFulfillment API is used to close the fulfillment for the transfer order items.

## **API Spec:**

* For the API and service, this means
  * record the cancelQty (remaining quantity of item not shipped if any) in OrderItem - compute in the service
  * the item status should be moved to the next possible status transition
  * Check for cancelCompleteOrder
* Here, the API will expect the items list to complete the fulfillment for. If whole order needs to be completed, all items should be sent in the items list.

#### API parameters

**Input**
1. orderId* - The ID of the Transfer Order Shipment in OMS.
2. items* - The list of order items to be fulfilled.
   1. orderItemSeqId - The Seq ID of the Transfer Order Item in OMS.
   2. shipGroupSeqId - The Ship Group Seq ID of the Transfer Order Item in OMS.
   3. productId - The ID of the product in OMS for the Transfer Order Item.

### Sample Payload

* Method: POST
* API: {baseUrl}/rest/s1/poorti/transferOrders/M101735/closeFulfillment

* Input:
```json
{
  "items": [
    {
      "orderItemSeqId": "01",
      "shipGroupSeqId": "00001",
      "productId": "10079"
    },
    {
      "orderItemSeqId": "02",
      "shipGroupSeqId": "00001",
      "productId": "10326"
    }
  ]
}
```


