### **rejectShipmentItem** 

**Purpose**
The primary goal of the `rejectShipmentItem` service is to handle the rejection of a specific item within a shipment. This involves cancelling  the shipment item, put the order items in the brokering queue and adjusting inventory levels.

**Input Parameters**

*   **`shipmentId` (String):** The ID of the shipment containing the item to be rejected.
*   **`shipmentItemSeqId` (String):** The sequence ID of the specific item within the shipment.

### Workflow
*   Delete OrderShipment
*   Delete ShipmentPackageContent
*   Delete ShipmentItem
*   Call rejectOrderItem service

