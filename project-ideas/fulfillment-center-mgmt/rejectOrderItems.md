### **rejectOrderItems**

The `rejectOrderItems` 

list of the OrderItems to this service to reject.
reject orders items within a given facility for a specific product where it's part of an in-progress shipment. 
This action is typically taken when a product is found to be defective, unavailable, or needs to be removed from pending fulfillments due to other reasons.

Using input parameters, a DynamicView is prepared. 

For each OrderItem in rejectOrderItem list, 

1. Join OrderItem and OrderItemShipGroup entity and OrderShipment and Shipment
   - add filter for orderItemShipGroup.facilityId AND orderItem.statusId = `APPROVED` AND shipment.status is IN (INPUT, APPROVED)
   - If `cascadeRejectByProduct` is `Y`, 
     - add filter for orderItem.productId 
   - Else add filter for orderId
   - if maySplit=`N` 
     - group by orderId, shipGroupSeqId 
   - else if (parameters.orderItemSeqId NOT ISNULL) AND (`cascadeRejectByProduct` is `N`)
     - add filter for orderItem.orderItemSeqId = parameters.orderItemSeqId



**Parameters**
* "orderId":
* "orderItemSeqId":
* "productId": 
* "facilityId":
* "rejectToFacilityId":
* "updateQOH":
* "rejectionReasonId":
* "maySplit": Defaults to `N`. Reject all items in the ship group. 
* "cascadeRejectByProduct": Defaults to `N`. Find other order items in at the facility and reject them as well.
* "comments": 

**Workflow:**
* For each OrderItem in the IN parameters
  1. If `cascadeRejectByProduct` is `Y`, 
     -Lookup in OrderItemAndShipGroup view WHERE facilityId	= OrderItemShipGroup.facilityId AND statusIs = `APPROVED` and productId = OrderItem.productId.
  2. for each OrderItemAndShipGroup, If maySplit is `Y`, Look OrderShipment by orderId and shipGroupSeqId else, orderId and orderItemSeqId.
  3. For each OrderShipment. 
     - If shipmentId and shipmentItemSeqId is NOT NULL call rejectShipmentItem()
     - else call rejectOrderItem

**Key points and logic:**

1.  **Input Parameters:**
```json
[
  {
    "orderId": "ORD001",
    "orderItemSeqId": "0001",
    "rejectToFacilityId": "FAC001",
    "updateQOH": "",
    "rejectionReasonId": "NOT_IN_STOCK",
    "maySplit": "N",
    "cascadeRejectByProduct": "N",
    "comments": "The item is currently out of stock."
  },
  {
    "orderId": "ORD001",
    "orderItemSeqId": "0002",
    "rejectToFacilityId": "FAC002",
    "updateQOH": "",
    "rejectionReasonId": "MISMATCH",
    "maySplit": "N",
    "cascadeRejectByProduct": "N",
    "comments": "The item received does not match the order description."
  },
  {
    "orderId": "ORD002",
    "orderItemSeqId": "0001",
    "rejectToFacilityId": "FAC003",
    "updateQOH": "",
    "rejectionReasonId": "DAMAGE",
    "maySplit": "N",
    "cascadeRejectByProduct": "N",
    "comments": "The item was found damaged during inspection."
  },
  {
    "orderId": "ORD002",
    "orderItemSeqId": "0002",
    "rejectToFacilityId": "FAC004",
    "updateQOH": "",
    "rejectionReasonId": "WORNDISPLAY",
    "comments": "The item is worn or was part of a display."
  },
  {
    "orderId": "ORD003",
    "orderItemSeqId": "0001",
    "rejectToFacilityId": "FAC005",
    "updateQOH": "",
    "rejectionReasonId": "NOT_IN_STOCK",
    "comments": "The item is unavailable due to low stock levels."
  }
]
```
For each OrderItem in the list, call rejectOrderItem

