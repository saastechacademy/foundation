# Approve Transfer Orders

The process to approve transfer order.

1. The Order Header status will be updated from ORDER_CREATED to ORDER_APPROVED.
2. For the Order Item, the OH.statusFlowId will be used to update the status of the item to the next possible status for "Approve Item" transition.
3. Reserve the item if next item status to transition is ITEM_PENDING_FULFILL.
4. The status update and reservation operations will be done in-line in the Approve service.

**NOTE** Handle the transaction timeout (increase than default, say 5 min) since TO can have bulk items to be reserved.

## Bulk Approve Transfer Orders - bulk approve service

The bulk approve TO service should process TOs in sync.

1. Input Parameters
   1. orderIds - list of orderIds 

2. Service Actions
   1. Entity Find on Order Header with below conditions and select-field="orderId"
      1. orderTypeId = "TRANSFER_ORDER"
      2. statusId = "ORDER_CREATED"
      3. orderIds ignore-if-empty="true"
   2. Iterate on eligible orders and call the service approve#TransferOrder 

## Approve Transfer Order - core service

Approve single Transfer Order

1. Input Parameters
    1. orderId

2. Service Actions
   1. Entity Find One on Order Header using orderId - orderHeader
   2. Get statusFlowId = orderHeader.statusFlowId
   3. Call oms service change#OrderStatus in-map="[orderId:orderId, statusId:'ORDER_APPROVED']" 
   4. Update the order status in Solr
   5. Entity Find on StatusFlowTransition with conditions on
      1. statusFlowId
      2. statusId = "ITEM_CREATED"  //can we skip this condition and only check transitionSequence=1 ???
      3. transitionSequence = "1"  //here first transition refers to the corresponding status for approve item 
   6. Set the toItemStatusId = statusFlowTransition.toStatusId
   7. Entity Find Related shipGroups from orderHeader - facilityId required for input of reservation service
   8. Iterate and find related items from shipGroup
      1. Call oms service change#OrderItemStatus in-map="[orderId:orderId, orderItemSeqId:orderItem.orderItemSeqId, statusId:toItemStatusId]" for each item 
      2. If toItemStatusId = "ITEM_PENDING_FULFILL", call oms service create#OrderItemInventoryReservation in-map="[orderId:orderId, orderItemSeqId:orderItem.orderItemSeqId, quantity:orderItem.quantity]"
   9. Update Order Index in Solr for change in order and item status
