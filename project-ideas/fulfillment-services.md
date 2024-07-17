**rejectShipmentItem Purpose**

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

**moveShipmentItem service in the FulfillmentServices**.

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

