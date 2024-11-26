## cancelOrderItemInvRes
The `cancelOrderItemInvRes` service to handle the cancellation of inventory reservations associated with a specific order item. 

### Purpose
Adjust inventory reservations and release reserved inventory back into the available pool. Used in scenarios where an order item is canceled, modified, or rejected, and the reserved inventory needs to be updated accordingly.

### Workflow

5.  **Release Inventory (If Applicable):**
       * create InventoryItemDetail record for cancel qty.  
       * The `deleteOrderItemShipGrpInvRes` service to remove the inventory reservation record (`OrderItemShipGrpInvRes`) associated with the order item. This effectively releases the reserved inventory back into the available pool.


### Key Points

*   **Service Chaining:**

```
<set from-field="inventoryItem.inventoryItemId" field="createDetailMap.inventoryItemId"/>
<set from-field="parameters.orderId" field="createDetailMap.orderId"/>
<set from-field="parameters.orderItemSeqId" field="createDetailMap.orderItemSeqId"/>
<set from-field="parameters.shipGroupSeqId" field="createDetailMap.shipGroupSeqId"/>
<set from-field="cancelQuantity" field="createDetailMap.availableToPromiseDiff"/>
<call-service service-name="createInventoryItemDetail" in-map-name="createDetailMap"/>
<clear-field field="createDetailMap"/>

<remove-value value-field="orderItemShipGrpInvRes"/>

```

