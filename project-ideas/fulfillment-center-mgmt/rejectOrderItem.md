## rejectOrderItem

The "Process Non-Kit Item Rejection" of the `rejectOrderItem`.

### Purpose

This section of the code handles the rejection of individual order items that are not part of a kit (i.e., standalone products). The goal is to update the order item's association with the shipment group, adjust inventory levels, and log the rejection.

### Workflow

1.   **Cancel Inventory Reservation:** The `cancelOrderItemInvResQty` service is called to cancel the corresponding inventory reservation for the orderItem quantity.
2.   **Move to Rejected Ship Group (if applicable):** If the order item was originally associated with a non-NA facility, it's moved to a ship group associated with the `naFacilityId` (a designated facility for rejected items).
3.   **Create Order Facility Change:** An `OrderFacilityChange` record is created to log the change in facility for the rejected item.
4.   **Log External Fulfillment:** The `createUpdateExternalFulfillmentOrderItem` service is called to create or update an external fulfillment log entry, marking the item as rejected.
5.   **Create Order History:** An `OrderHistory` record is created with the event type `ITEM_REJECTED` to track the rejection in the order's history.
6.  **Record Inventory Variance:** If the `recordVariance` flag is set to "Y," and the rejection reason requires it, an inventory variance is recorded for the rejected quantity. This helps track inventory adjustments due to the rejection.
7.  **Set Auto Cancel Date:** If the `setAutoCancelDate` flag is set to "Y," the service calculates and sets an auto-cancel date for the order item based on the product store's configuration. This is typically used to automatically cancel orders that haven't been paid for within a certain timeframe.

### Key Points

*   **Targeted Rejection:** The service focuses on rejecting only the specified order item within the given ship group(s).
*   **Inventory and Order Management:** It handles inventory reservation cancellations, facility changes, and order history updates.
*   **Integration with Other Services:** It relies on other services like `cancelOrderItemInvResQty` and `createUpdateExternalFulfillmentOrderItem` to perform specific actions.
