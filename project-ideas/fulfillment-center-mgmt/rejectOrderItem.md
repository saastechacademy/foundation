## rejectOrderItem

### Purpose
Move the OrderItem from assigned fulfillment facility to brokering queue or reject orderItem queue or similar. 

**NOTE:** As compared to legacy code:
* Does create or update records in OrderItemShipGroupAssoc entity.
* An orderItem is part of one and only one OrderItemShipGroup. 

**IN Parameters**
* `orderId`
* `orderItemSeqId`
* `rejectToFacilityId`
* `rejectionReasonId`
* `comments` optional

**OUT Parameters** 
* List of cancelled Inventory reservations.


### Workflow

1. **Cancel Inventory Reservation:** Call [cancelOrderItemInvResQty](../inventory-mgmt/cancelOrderItemInvRes.md) service to cancel the corresponding inventory reservation for the orderItem quantity. The called service will cancel reservation for marketing package and all its components. 
2. **Cancel the related PickListOrderItem item:** Get `picklistOrderItems` for `orderId` `orderItemSeqId` and `update#PicklistOrderItem` status to `PICKITEM_CANCELLED`
3. **Move to Rejected Ship Group:** Move the orderItem to a ship group associated with the `naFacilityId` (a designated facility for rejected items). [Check if OrderItemShipGroup exits](findOrCreateOrderItemShipGroup.md) for the `naFacilityId` else create one and then move `orderItem` to this ship group. 
4. **Create Order History:** An `OrderHistory` record is created with the event type `ITEM_REJECTED` to track the rejection in the order's history.
5. **Create Order Facility Change:** An `OrderFacilityChange` record is created to log the change in facility for the rejected item.
6. **Record Inventory Variance:** 
   *    Analyze the rejection reason to compute the variance quantity, record inventory variance for the rejected quantity from the facility rejecting the orderItem.
   *    [createPhysicalInventory](../inventory-mgmt/createPhysicalInventory.md). 
7. **Set Auto Cancel Date:** If the productStore setting `setAutoCancelDate` flag is set to "Y," the service calculates and sets an auto-cancel date for the order item based on the product store's configuration. This is typically used to automatically cancel orders that haven't been paid for within a certain timeframe.
8. **Log External Fulfillment:** Create SystemMessage to Notify externals systems. The `createUpdateExternalFulfillmentOrderItem` service is called to create or update an external fulfillment log entry, marking the item as rejected.

### Bundle product OrderItem

In case the OrderItem is for bundle product. During the fulfillment process, PRODUCT_COMPONENT of the budles products are reserved `OrderItemShipGrpInvRes`,  picked `PickListItem` and shipped `ShipmentItem`.






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


