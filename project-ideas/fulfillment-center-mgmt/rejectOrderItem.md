## rejectOrderItem

The "Process Non-Kit Item Rejection" of the `rejectOrderItem`.

### Purpose

This section of the code handles the rejection of individual order items that are not part of a kit (i.e., standalone products). The goal is to update the order item's association with the shipment group, adjust inventory levels, and log the rejection.

### Workflow

1.  **Fetch Ship Groups:** The code retrieves all `OrderItemShipGroupAssoc` records associated with the order item (`orderId` and `orderItemSeqId`) that are in a shippable state (`quantity` greater than zero).

2.  **Iterate Through Ship Groups:** For each ship group association:
    *   **Calculate `cancelReservationQuantity`:** If a specific `quantity` to reject was provided in the input, it's used. Otherwise, the entire remaining quantity in the ship group association is set as the `cancelReservationQuantity`.
    *   **Cancel Inventory Reservation:** The `cancelOrderItemInvResQty` service is called to cancel the corresponding inventory reservation for the `cancelReservationQuantity`.
    *   **Move to Rejected Ship Group (if applicable):** If the order item was originally associated with a non-NA facility, it's moved to a ship group associated with the `naFacilityId` (a designated facility for rejected items).
    *   **Create Order Facility Change:** An `OrderFacilityChange` record is created to log the change in facility for the rejected item.
    *   **Log External Fulfillment:** The `createUpdateExternalFulfillmentOrderItem` service is called to create or update an external fulfillment log entry, marking the item as rejected.
    *   **Create Order History:** An `OrderHistory` record is created with the event type `ITEM_REJECTED` to track the rejection in the order's history.

3.  **Record Inventory Variance:** If the `recordVariance` flag is set to "Y," and the rejection reason requires it, an inventory variance is recorded for the rejected quantity. This helps track inventory adjustments due to the rejection.

4.  **Set Auto Cancel Date:** If the `setAutoCancelDate` flag is set to "Y," the service calculates and sets an auto-cancel date for the order item based on the product store's configuration. This is typically used to automatically cancel orders that haven't been paid for within a certain timeframe.

### Key Points

*   **Targeted Rejection:** The service focuses on rejecting only the specified order item within the given ship group(s).
*   **Inventory and Order Management:** It handles inventory reservation cancellations, facility changes, and order history updates.
*   **Integration with Other Services:** It relies on other services like `cancelOrderItemInvResQty` and `createUpdateExternalFulfillmentOrderItem` to perform specific actions.
*   **Flexibility:** It can handle both partial and full rejections of an order item's quantity.

Once again:

1.  **Fetch Current Ship Group:**
    *   Retrieves the current ship group associated with the order item using `OrderItemShipGroupAssoc`.
    *   If found, fetches details of the ship group from `OrderItemShipGroup`.

2.  **Handle Kit Product Rejection (If Applicable):**
    *   Checks if the rejected item is part of a kit product.
    *   If so, performs the following actions:
        *   Cancels associated picklist items by updating their status to `PICKITEM_CANCELLED`.
        *   Releases reserved inventory for the kit product.
        *   Moves the ship group to the rejected item facility (`naFacilityId`) if it's different from the current facility.
        *   Creates `OrderFacilityChange` records for both the kit product and its components.
        *   Logs the rejection in the external fulfillment system and order history.

3.  **Fetch Quantity for Variance (If Applicable):**
    *   If `recordVariance` is "Y" and a valid `rejectReason` is provided, it fetches the quantity to record the variance.
    *   The variance quantity is determined based on the `rejectReasonDetail` (enumeration type).

4.  **Process Non-Kit Item Rejection:**
    *   If the item is not part of a kit, proceeds with the following:
        *   Fetches ship groups associated with the item at the specified facility, filtering by order and item status.
        *   Iterates through each ship group:
            *   Cancels associated picklist items.
            *   Releases reserved inventory.
            *   Adds the rejected item details (order ID, item sequence ID, ship group, quantity) to a list.
            *   Updates or deletes the `OrderItemShipGroupAssoc` based on the remaining quantity.
            *   Finds or creates a ship group in the rejected item facility (`naFacilityId`).
            *   Adds the item to the rejected item ship group.
            *   Creates an `OrderFacilityChange` record.
            *   Logs the rejection in the external fulfillment system and order history.
            *   Optionally sets an auto-cancel date for the order item (commented out in the code).

5.  **Record Variance (If Applicable):**
    *   If `recordVariance` is "Y" and the `rejectReason` requires it, records the variance for all available quantities of the product.
    *   Iterates through available inventory items and creates `PhysicalInventoryAndVariance` records.

6.  **Create Excluded Order Facility (If Applicable):**
    *   If `excludeOrderFacilityDuration` is provided, creates an `ExcludedOrderFacility` record to prevent future orders from being fulfilled from the rejected facility for a specified duration.

