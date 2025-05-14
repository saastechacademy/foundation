# Approve Transfer Orders

The process to approve transfer orders.

For Transfer Order approval, 2 types of approval flows could be set up in OMS.

## 1. Bulk Approve Store Fulfilled Transfer Orders
Approve Transfer Orders to be fulfilled from Warehouse/third party eg. Warehouse to Store TOs

### bulkApprove#StoreFulfillTransferOrders service
1. Input Parameters
   1. orderIds - List of order Ids to be approved, optional parameter
   2. bufferTime - Time to consider as buffer time from order entry date time (in minutes), optional parameter, default-value="1"
2. Service Actions
   1. Entity Find on Order Header with below conditions and select-field="orderId"
      1. orderTypeId = "TRANSFER_ORDER"
      2. statusId = "ORDER_CREATED"
      3. statusFlowIds = "TO_Fulfill_Only,TO_Fulfill_And_Receive"
      4. entryDate using bufferTime
   2. Iterate on eligible orders and call the service approve#StoreFulfillTransferOrder

### approve#StoreFulfillTransferOrder service
1. Input Parameters
   1. orderId

2. Service Actions
   1. The Order will be updated to ORDER_APPROVED status.
   2. The Items will be updated to the next eligible Item Status based on the statusFlowId associated with the Transfer Order i.e. ITEM_PENDING_RECEIPT.
   3. NOTE Here the reservations are not required in OMS since transfer order fulfillment is done by third party.

## 2. Bulk Approve Warehouse Fulfilled Transfer Orders
Approve Transfer Orders to be fulfilled from stores in OMS eg. Store to Warehouse/Store TOs
 
### bulkApprove#WhFulfillTransferOrders service
1. Input Parameters
   1. orderIds - List of order Ids to be approved, optional parameter
   2. bufferTime - Time to consider as buffer time from order entry date time (in minutes), optional parameter, default-value="1"
2. Service Actions
   1. Entity Find on Order Header with below conditions and select-field="orderId"
      1. orderTypeId = "TRANSFER_ORDER"
      2. statusId = "ORDER_CREATED"
      3. statusFlowIds = "TO_Receive_Only"
      4. entryDate using bufferTime
   2. Iterate on eligible orders and call the service approve#WhFulfillTransferOrder

### approve#WhFulfillTransferOrder service
1. Input Parameters
   1. orderId
   
2. Service Actions
   1. The Order will be updated to ORDER_APPROVED status.
   2. The Items will be updated to the next eligible Item Status based on the statusFlowId associated with the Transfer Order i.e. ITEM_PENDING_FULFILL.
   3. NOTE Here the reservations will be done in OMS for all the order items in the order since transfer order fulfillment is to be done in OMS.

**NOTE for dev** Handle the transaction timeout (increase than default, say 5 min) since TO can have bulk items to be reserved.

