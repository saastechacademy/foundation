### **rejectShipmentItem** 

**Purpose**
The primary goal of the `rejectShipmentItem` service is to handle the rejection of a specific item within a shipment. This involves cancelling  the shipment item, move PickListOrderItem to rejected status, put the order items in the brokering queue and adjusting inventory levels.

**Input Parameters**

*   **`shipmentId` (String):** The ID of the shipment containing the item to be rejected.
*   **`shipmentItemSeqId` (String):** The sequence ID of the specific item within the shipment.
*   **`rejectToFacilityId` (String):**
*   **`rejectionReasonId` (String):**
*   **`comments` (String):**

### Workflow
*   If Shipment is not in SHIPMENT_INPUT status then call reinitializeShipment.
*   Delete ShipmentPackageContent
*   Delete ShipmentItem
*   With OrderId and OrderItemSeqId find PickListOrderItem and move it to rejected status
*   Delete OrderShipment
*   Call rejectOrderItem service

### Notes
