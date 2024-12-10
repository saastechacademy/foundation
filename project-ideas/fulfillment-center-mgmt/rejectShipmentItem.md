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


```xml
    <!-- Rejection reason -->
    <EnumerationType enumTypeId="REPORT_AN_ISSUE" description="Report an Issue Reason"/>
    <EnumerationType enumTypeId="RPRT_NO_VAR_LOG" description="Report an issue with no variance log"/>
    <EnumerationType enumTypeId="REPORT_NO_VAR" description="Report an issue with no variance reason" parentTypeId="RPRT_NO_VAR_LOG"/>
    <EnumerationType enumTypeId="REPORT_ALL_VAR" description="Report an issue with all qty variance reason" parentTypeId="REPORT_AN_ISSUE"/>
    <EnumerationType enumTypeId="REPORT_VAR" description="Report an issue with particular qty variance reason" parentTypeId="REPORT_AN_ISSUE"/>
    <Enumeration description="Not in Stock" enumCode="NOT_IN_STOCK" enumId="NOT_IN_STOCK" sequenceId="10" enumTypeId="REPORT_ALL_VAR"/>
    <Enumeration description="Worn Display" enumCode="WORN_DISPLAY" enumId="WORN_DISPLAY" sequenceId="20" enumTypeId="REPORT_VAR"/>
    <Enumeration description="Damaged" enumCode="DAMAGED" enumId="REJ_RSN_DAMAGED" sequenceId="30" enumTypeId="REPORT_VAR"/>
    <Enumeration description="Mismatch" enumCode="MISMATCH" enumId="MISMATCH" sequenceId="40" enumTypeId="REPORT_VAR"/>
    <Enumeration description="Inactive store" enumCode="INACTIVE_STORE" enumId="INACTIVE_STORE" sequenceId="40" enumTypeId="REPORT_NO_VAR"/>
    <Enumeration description="No variance" enumCode="NO_VARIANCE_LOG" enumId="NO_VARIANCE_LOG" sequenceId="40" enumTypeId="REPORT_NO_VAR"/>
    <!--This rejection reason will be applied to all items in the order/shipment that get rejected due to the rejection of one or more items from the order, to avoid unnecessary splits when the 'Reject Entire Order' setting is enabled.-->
    <Enumeration description="Reject entire order" enumCode="REJECT_ENTIRE_ORDER" enumId="REJECT_ENTIRE_ORDER" sequenceId="41" enumTypeId="REPORT_NO_VAR"/>



```