## rejectOrderItem

### Purpose
Move the OrderItem from assigned fulfillment facility to brokering queue or reject orderItem queue or similar. 

**NOTE:** As compared to legacy code:
* This service is not responsible to adjust inventory levels, and log the rejection.
* Does create or update records in OrderItemShipGroupAssoc entity.
* An orderItem is part of one and only one OrderItemShipGroup. 

**IN Parameters**
* `orderId`
* `orderItemSeqId`
* `naFacilityId`

**OUT Parameters** 
* List of cancelled Inventory reservations. This data can be used for recording inventory variance. 


### Workflow

1.  **Cancel Inventory Reservation:** Call `cancelOrderItemInvResQty(orderId, orderItemSeqId, shipGroupSeqId, cancelQantity)` service is called to cancel the corresponding inventory reservation for the orderItem quantity. The called service will canceel reservation for marketing package and all its components. 
2.  **Cancel the related PickList item:** Get `picklistItems` for `orderId` `orderItemSeqId`. 
3.  **Move to Rejected Ship Group:** Move the orderItem to a ship group associated with the `naFacilityId` (a designated facility for rejected items). Check if OrderItemShipGroup exits for the `naFacilityId` else create one and then move `orderItem` to this ship group. 
4.  **Log External Fulfillment:** The `createUpdateExternalFulfillmentOrderItem` service is called to create or update an external fulfillment log entry, marking the item as rejected.
5.  **Create Order History:** An `OrderHistory` record is created with the event type `ITEM_REJECTED` to track the rejection in the order's history.
6.  **Create Order Facility Change:** An `OrderFacilityChange` record is created to log the change in facility for the rejected item.

### Related services are responsible for the following

7.  **Record Inventory Variance:** If the `recordVariance` flag is set to "Y," and the rejection reason requires it, an inventory variance is recorded for the rejected quantity. This helps track inventory adjustments due to the rejection.
8.  **Set Auto Cancel Date:** If the `setAutoCancelDate` flag is set to "Y," the service calculates and sets an auto-cancel date for the order item based on the product store's configuration. This is typically used to automatically cancel orders that haven't been paid for within a certain timeframe.

### Bundle product OrderItem

In case the OrderItem is for budle product. During the fulfillment process, PRODUCT_COMPONENT of the budles products are reserved `OrderItemShipGrpInvRes`,  picked `PickListItem` and shipped `ShipmentItem`.






### Key Points

*   **Targeted Rejection:** The service focuses on rejecting only the specified order item within the given ship group(s).
*   **Inventory and Order Management:** It handles inventory reservation cancellations, facility changes, and order history updates.
*   **OrderFacilityChange:** Record changes between an orderItem and its fulfillment facilityit. It might trigger a need to re-evaluate the order's fulfillment at the current facility.




### **OrderHistory**
  **Enumerations**
```
| Enum Id         | Enum Type Id       | Enum Code  | Enum Name           | Description        |
|-----------------|--------------------|------------|---------------------|---------------------|
| view            | ITEM_BKD_REJECTED  | ORDER_EVENT_TYPE | Brokering Rejected  |                    |
| view            | ITEM_BROKERED      | ORDER_EVENT_TYPE | Brokered            |                    |
| view            | ITEM_CANCELLED     | ORDER_EVENT_TYPE | Cancelled           |                    |
| view            | ITEM_SHIPPED       | ORDER_EVENT_TYPE | Shipped             |                    |
```

### **OrderFacilityChange**
  **Enumerations**

```
| Enum Id | Enum Type Id         | Enum Code         | Enum Name              | Description                      |
|---------|----------------------|-------------------|------------------------|----------------------------------|
| view    | BROKERED             | BROKERING_REASN_TYPE | Brokered              |                                  |
| view    | DAMAGED              | BROKERING_REASN_TYPE | Damaged               |                                  |
| view    | INV_NOT_FOUND        | BROKERING_REASN_TYPE | Inventory not found   |                                  |
| view    | INV_STOLEN           | BROKERING_REASN_TYPE | Inventory Stolen by other order |            |
| view    | RELEASED             | BROKERING_REASN_TYPE | Released              |                                  |
| view    | UNFILLABLE           | BROKERING_REASN_TYPE | Unfillable            |                                  |
```


