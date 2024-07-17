**rejectShipmentItem** 

**Purpose**
The primary goal of the `rejectShipmentItem` service is to handle the rejection of a specific item within a shipment. This involves updating the shipment item's status, adjusting inventory levels, and potentially canceling associated order items.

**Input Parameters**

*   **`shipmentId` (String):** The ID of the shipment containing the item to be rejected.
*   **`shipmentItemSeqId` (String):** The sequence ID of the specific item within the shipment.
*   **`quantity` (BigDecimal):** The quantity of the item being rejected. If not provided, the entire quantity of the shipment item is assumed to be rejected.
*   **`recordVariance` (String):** A flag ("Y" or "N") indicating whether to record an inventory variance for the rejected item.
*   **`rejectionReasonId` (String):** The ID of the reason for the rejection (e.g., "DAMAGED," "INCORRECT_ITEM").
*   **`rejectionComments` (String):** Additional comments about the rejection.
*   **`setAutoCancelDate` (String):** A flag ("Y" or "N") indicating whether to automatically set a cancellation date for the associated order item.
*   **`excludeOrderFacilityDuration` (Integer):** An optional parameter used in calculating the cancellation date (if `setAutoCancelDate` is "Y").
*   **`userLogin` (GenericValue):** The userLogin object representing the user performing the action.

**Use Cases**

This service is typically used when an item within a shipment is found to be unsuitable for fulfillment due to reasons like:

*   **Damage:** The item is damaged and cannot be shipped.
*   **Incorrect Item:** The wrong item was picked for the shipment.
*   **Customer Cancellation:** The customer canceled the order for that specific item.
*   **Other Reasons:** Any other reason that might necessitate rejecting an item from a shipment.

**Workflow**

1.  **Input Validation:** The service first validates the input parameters, ensuring that the `shipmentId` and `shipmentItemSeqId` are valid, and the `recordVariance` and `setAutoCancelDate` flags are either "Y" or "N."

2.  **Fetch Shipment and Order Details:** It retrieves the `Shipment` and `OrderHeader` records associated with the given `shipmentId`.

3.  **Handle Kit/Component Items:** If the rejected item is part of a kit, the service removes all associated order shipment records for the kit's components.

4.  **Reject Order Item:** The service calls the `rejectOrderItem` service (not shown in the provided code) to handle the actual rejection of the order item. This likely involves updating the order item status, adjusting inventory levels, and potentially triggering other actions.

5.  **Record Inventory Variance (Optional):** If `recordVariance` is "Y," the service records an inventory variance to track the adjustment in inventory due to the rejection.

6.  **Set Cancellation Date (Optional):** If `setAutoCancelDate` is "Y," the service calculates and sets a cancellation date for the associated order item.

**Error Handling:** The service includes error handling to catch exceptions and return appropriate error messages.

**moveShipmentItem**.

**Purpose**

The primary goal of the `moveShipmentItem` service is to transfer a specific item from one shipment to another within the same order. This is useful in scenarios where items need to be rearranged or consolidated during the fulfillment process.

**Input Parameters**

*   **`shipmentId` (String):** The ID of the original shipment from which the item is being moved.
*   **`shipmentPackageSeqId` (String, optional):** The sequence ID of the package within the original shipment that contains the item.
*   **`toShipmentId` (String):** The ID of the destination shipment to which the item will be moved.
*   **`toShipmentPackageSeqId` (String, optional):** The sequence ID of the package within the destination shipment where the item should be placed.
*   **`shipmentItemSeqId` (String):** The sequence ID of the specific item within the shipment that is being moved.
*   **`quantity` (BigDecimal, optional):** The quantity of the item to move. If not provided, the entire quantity of the shipment item is moved.
*   **`userLogin` (GenericValue):** The userLogin object representing the user performing the action.

**Use Cases**

This service is typically used in the following scenarios:

*   **Consolidating Shipments:** If multiple shipments are going to the same address, it might be more efficient to combine items into a single shipment.
*   **Correcting Errors:** If an item was accidentally placed in the wrong shipment, this service can be used to move it to the correct one.
*   **Splitting Shipments:** If a shipment becomes too large or heavy, some items can be moved to a new shipment.

**Workflow**

1.  **Input Validation:** The service validates the input parameters to ensure they are correct and consistent. It checks for the existence of the shipments, verifies that the shipments belong to the same order, and confirms the validity of the shipment item and quantity.

2.  **Remove Item from Original Shipment:** The service calls the `deleteOrderShipmentItem` service to remove the specified quantity of the item from the original shipment.

3.  **Add Item to New Shipment:** The service calls the `createOrderShipmentItem` service to add the specified quantity of the item to the new shipment. It uses the `OrderShipment` entity to associate the item with the correct order and shipment.

**Error Handling:** The service includes error handling to catch exceptions and return appropriate error messages if any issues occur during the process.

**rejectItemFromAllOrders**
The `rejectItemFromAllOrders` service in the `StoreFulfillmentEvents.txt` file is designed to reject a specific product from all orders within a given facility where it's part of an in-progress shipment. This action is typically taken when a product is found to be defective, unavailable, or needs to be removed from pending fulfillments due to other reasons.

**Key points and logic:**

1.  **Input Parameters:**
    *   `productId` (String): The unique identifier of the product to be rejected.
    *   `facilityId` (String): The ID of the facility from which the product should be rejected.
    *   `userLogin` (GenericValue): The userLogin object representing the user initiating the rejection.
    *   `reasonId`: The ID of the reason for the rejection (e.g., "DAMAGED," "INCORRECT\_ITEM").

2.  **Identifying Shipments:**
    *   The service queries the database to find all shipments within the specified facility that meet the following criteria:
        *   The shipment is in progress (either `SHIPMENT_APPROVED` or `SHIPMENT_INPUT` status).
        *   The shipment contains the specified `productId`.

3.  **Iterating and Rejecting:**
    *   For each identified shipment:
        *   The associated order (`OrderHeader`) is retrieved.
        *   The order's status is checked to ensure it's in a cancelable state (not canceled, completed, or rejected).
        *   If the order is cancelable, the `rejectShipmentItem` service is called to reject the specific product item from that shipment. The following parameters are passed to `rejectShipmentItem`:
            *   `shipmentId`
            *   `shipmentItemSeqId`
            *   `quantity`
            *   `reasonId`
            *   `rejectionComments` (set to "Store Rejected Inventory")

**Error Handling:**

*   The service includes a `try-catch` block to handle potential exceptions during database queries and service calls. If an error occurs, it logs the error and returns an error message.

**Key Use Cases:**

*   **Product Recall:** When a product needs to be recalled due to safety or quality concerns.
*   **Product Discontinuation:** When a product is no longer available and should not be shipped.
*   **Inventory Discrepancy:** When there's a significant issue with the inventory of a product at a specific facility.

**Important Note:**

The `rejectItemFromAllOrders` service is designed to reject items from all orders within a specific facility, not across all facilities as its name might suggest. The `facilityId` parameter is crucial in determining the scope of the rejection.

**reinitializeShipment**

The `reinitializeShipment` service in the `FulfillmentServices.txt` file is designed to reset a shipment to its initial state, specifically to the `SHIPMENT_INPUT` status. This is often done when modifications need to be made to a shipment after it has been approved or partially processed.

**Input Parameters**

*   `shipmentId` (String): The ID of the shipment that needs to be reinitialized.
*   `userLogin` (GenericValue): The userLogin object representing the user performing the action.

**Use Cases**

This service is typically used in scenarios where:

*   **Item Rejection:** When an item within a shipment is rejected, the shipment might need to be reinitialized to allow for adjustments and potential reassignment of items.
*   **Shipment Modification:** If there are changes to the shipment details (e.g., shipping address, carrier), reinitializing the shipment can reset it to a state where these changes can be made.
*   **Error Correction:** If an error occurred during the initial shipment processing, reinitializing can provide a clean slate to correct the issue.
*   **Updating package box types:** In the `updateInProgressOrder` function, if the shipment label hasn't been generated or the box type has changed, the shipment is reinitialized.
*   **Processing ready-to-pack items:** In the `updateInProgressOrder` function, if an item needs to be moved to a different shipment, both the original and new shipments are reinitialized.
*   **Handling item rejections:** In the `updateInProgressOrder` function, the shipment is reinitialized for items with specific rejection reasons.

**Workflow**

1.  **Fetch Shipment Details:** The service retrieves the shipment record from the database using the provided `shipmentId`.

2.  **Fetch Order Item Ship Group:** It retrieves the associated `OrderItemShipGroup` record to determine the original `carrierPartyId` (the carrier responsible for the shipment) and `shipmentMethodTypeId` (the method of shipment).

3.  **Update Shipment:**
    *   The shipment's `statusId` is changed to `SHIPMENT_INPUT`.
    *   The original `carrierPartyId` and `shipmentMethodTypeId` are restored to the shipment record.

4.  **Update Shipment Route Segments:**
    *   If the shipment has associated route segments (`ShipmentRouteSegment`), the service updates them as well.
    *   The `shipmentMethodTypeId` and `carrierPartyId` of each route segment are set to the original values retrieved in step 2.

**Error Handling:**

*   The service includes a `try-catch` block to handle potential exceptions (e.g., `GenericServiceException`, `GenericEntityException`) that might occur during the database operations or service calls.
*   If an error occurs, it logs the error message and returns an error result from the service.

**Key Points**

*   The service focuses on resetting the shipment status and restoring original shipping details.
*   It ensures consistency by updating both the shipment and its associated route segments.
*   It provides a way to revert a shipment to an editable state for further modifications.
