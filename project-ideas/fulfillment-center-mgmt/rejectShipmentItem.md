### **rejectShipmentItem** 

**Purpose**
The primary goal of the `rejectShipmentItem` service is to handle the rejection of a specific item within a shipment. This involves cancelling  the shipment item, put the order items in the brokering queue and adjusting inventory levels.

**Input Parameters**

*   **`shipmentId` (String):** The ID of the shipment containing the item to be rejected.
*   **`shipmentItemSeqId` (String):** The sequence ID of the specific item within the shipment.
*   **`quantity` (BigDecimal):** The quantity of the item being rejected. If not provided, the entire quantity of the shipment item is assumed to be rejected.
*   **`recordVariance` (String):** A flag ("Y" or "N") indicating whether to record an inventory variance for the rejected item. Default to "N".
*   **`rejectionReasonId` (String):** The ID of the reason for the rejection (e.g., "DAMAGED," "INCORRECT_ITEM").
*   **`rejectionComments` (String):** Additional comments about the rejection.
*   **`setAutoCancelDate` (String):** A flag ("Y" or "N") indicating whether to automatically set a cancellation date for the associated order item. Default to "N"
*   **`excludeOrderFacilityDuration` (Integer):** An optional parameter used in calculating the cancellation date (if `setAutoCancelDate` is "Y").
*   **`userLogin` (GenericValue):** The userLogin object representing the user performing the action.

**Use Cases**

This service is typically used when an item within a shipment is found to be unsuitable for fulfillment due to reasons like:

*   **Damage:** The item is damaged and cannot be shipped.
*   **Incorrect Item:** The wrong item was picked for the shipment.
*   **Customer Cancellation:** The customer canceled the order for that specific item.
*   **Other Reasons:** Any other reason that might necessitate rejecting an item from a shipment.

**Workflow**

1.  **Input Validation:** The service first validates the input parameters, ensuring that the `shipmentId` and `shipmentItemSeqId` are valid.

2.  **Fetch Shipment and Order Details:** It retrieves the `Shipment` and `OrderHeader` records associated with the given `shipmentId`. Lookup related OrderItem via, the OrderShipment entity. It holds relationship between ShipmentItem and OrderItem entity. 

3.  **Handle Kit/Component Items:** If the rejected item is part of a kit, the service removes all associated order shipment records for the kit's components.

4.  **Reject Order Item:** The service calls the `rejectOrderItem` service to handle the actual rejection of the order item. This likely involves updating the order item status, adjusting inventory levels, enquiuing the OrderItem for rebroketing or put it in the rejected orderItem queue.

5.  **Record Inventory Variance (Optional):** If `recordVariance` is "Y," the service records an inventory variance to track the adjustment in inventory due to the rejection.

6.  **Set Cancellation Date (Optional):** If `setAutoCancelDate` is "Y," the service calculates and sets a cancellation date for the associated order item.

