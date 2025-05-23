# Close Transfer Order Item Fulfillment	

## **Purpose:**

The POST transferOrders/{orderId}/closeFulfillment API is used to close the fulfillment for the transfer order items.

1. For the API and service, this means 
   1. update the cancelQuantity (remaining quantity of item not shipped if any) in OrderItem - computed in the service 
   2. cancel the remaining order reservation records 
   3. the item status will be updated to the next eligible OrderItem Status based on the statusFlowId
      associated with the Transfer Order i.e. either ITEM_COMPLETED or ITEM_PENDING_RECEIPT for TO_Fulfill_Only
      and TO_Fulfill_And_Receive orders respectively
   4. Check for cancelCompleteOrder
2. Here, the API will expect the items list to close the fulfillment for. If whole order needs to be closed for fulfillment, all items should be sent in the items list.

## **API Spec:**

### API parameters

**Input**
1. orderId* - The ID of the Transfer Order Shipment in OMS.
2. items* - The list of order items to be fulfilled.
   1. orderItemSeqId - The Seq ID of the Transfer Order Item in OMS.

### Sample Payload

* Method: POST
* API: {baseUrl}/rest/s1/poorti/transferOrders/M101735/closeFulfillment

* Input:
```json
{
  "items": [
    {
      "orderItemSeqId": "01"
    },
    {
      "orderItemSeqId": "02"
    }
  ]
}
```


