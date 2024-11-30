### **rejectOrderItems**

The `rejectOrderItems` 

In following case, first run query to find all ordersItems and then pass list of the OrderItems to this service.
to reject orders items within a given facility for a specific product where it's part of an in-progress shipment. 
This action is typically taken when a product is found to be defective, unavailable, or needs to be removed from pending fulfillments due to other reasons.

**Key points and logic:**

1.  **Input Parameters:**
```json
[
  {
    "orderId": "ORD001",
    "orderItemSeqId": "0001",
    "rejectToFacilityId": "FAC001",
    "rejectionReasonId": "NOT_IN_STOCK",
    "comments": "The item is currently out of stock."
  },
  {
    "orderId": "ORD001",
    "orderItemSeqId": "0002",
    "rejectToFacilityId": "FAC002",
    "rejectionReasonId": "MISMATCH",
    "comments": "The item received does not match the order description."
  },
  {
    "orderId": "ORD002",
    "orderItemSeqId": "0001",
    "rejectToFacilityId": "FAC003",
    "rejectionReasonId": "DAMAGE",
    "comments": "The item was found damaged during inspection."
  },
  {
    "orderId": "ORD002",
    "orderItemSeqId": "0002",
    "rejectToFacilityId": "FAC004",
    "rejectionReasonId": "WORNDISPLAY",
    "comments": "The item is worn or was part of a display."
  },
  {
    "orderId": "ORD003",
    "orderItemSeqId": "0001",
    "rejectToFacilityId": "FAC005",
    "rejectionReasonId": "NOT_IN_STOCK",
    "comments": "The item is unavailable due to low stock levels."
  }
]
```
For each OrderItem in the list, call rejectOrderItem

