# Approve Transfer Orders

1. The process to approve transfer order and correctly update the Order Item Status to either ITEM_PENDING_FULFILLMENT or ITEM_PENDING_RECEIPT on the basis of OH.statusFlowId.
2. In the core Approve TO service, for each TO, header status update will happen and if the next valid item status transition for its statusFLowId is ITEM_PENDING_FULFILLMENT, the items should be iterated and reservations should happen.
3. The status update and reservation operations will be done in-line in the Approve service. 

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
   2. Set statusFlowId = orderHeader.statusFlowId
   3. Call update#org.apache.ofbiz.order.order.OrderHeader in-map="[orderId:orderId, statusId:'ORDER_APPROVED']"
   4. Update the Order Status in Solr? **TODO** check existing update#OrderFulfillmentStatus service used in fulfillment app
   5. Call create#org.apache.ofbiz.order.order.OrderStatus
      1. statusDatetime = ec.user.nowTimestamp
      2. orderId
      3. statusId = ORDER_APPROVED
   6. NOTE Points 3, 4 & 5 can be wrapped in a generic OMS service to update Order Status
   7. Entity Find on StatusFlowTransition with conditions on
      1. statusFlowId
      2. statusId = "ITEM_CREATED"  //can we skip this condition and only check transitionSequence=1 ???
      3. transitionSequence = "1"  //here first transition refers to the corresponding status for approve item 
   8. Set the toItemStatusId = statusFlowTransition.toStatusId
   9. Entity Find on Order Item using orderId - orderItems list
   10. Iterate on orderItems list
       1. Call update#org.apache.ofbiz.order.order.OrderItem in-map="[orderId:orderId, orderItemSeqId:orderItem.orderItemSeqId, statusId:toItemStatusId]"
       2. Update the Order Item Status in Solr? **TODO** check existing update#OrdeItemFulfillmentStatus service used in fulfillment app
       3. Call create#org.apache.ofbiz.order.order.OrderStatus
           1. statusDatetime - ec.user.nowTimestamp
           2. orderId
           3. orderItemSeqId
           4. statusId = toItemStatusId
       4. If toItemStatusId = "ITEM_PENDING_FULFILLMENT", then call reserve item inventory **TODO** check reserve inventory service impl

    
### update#OrderStatus service
   - Call update#org.apache.ofbiz.order.order.OrderHeader
   - Call create#org.apache.ofbiz.order.order.OrderStatus
   - Call update#OrderFulfillmentStatus for update in Solr?


### update#OrderItemStatus service
   - Call update#org.apache.ofbiz.order.order.OrderItem
   - Call create#org.apache.ofbiz.order.order.OrderStatus
   - Call update#OrderItemFulfillmentStatus for update in Solr?
