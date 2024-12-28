# **rejectOrderItem**

## **Overview**  
`rejectOrderItem` is an internal service that rejects a single `OrderItem`. This service applies whether or not a valid `ShipmentItem` exists:

1. If **no `ShipmentItem`** exists, it simply rejects the `OrderItem` and updates the relevant records.  
2. If a **`ShipmentItem`** does exist, the logic for `rejectShipmentItem` is used as part of rejecting the `OrderItem`, ensuring both the shipment data and order data remain consistent.

## **Parameters**

- **orderId**  

- **orderItemSeqId**  

- **shipmentId (optional)**  

- **shipmentItemSeqId (optional)**  

- **rejectToFacilityId**  

- **updateQOH**  
  Determines if the quantity-on-hand (QOH) should be affected by this rejection:
  - **`Y`** – Update the QOH in the rejecting facility.
  - **`N`** – Do not update the QOH; typically affects only the “available to promise” (ATP).

- **rejectionReasonId**  
  Reason for the rejection (e.g., `NOT_IN_STOCK`, `MISMATCH`, `REJ_RSN_DAMAGED`). Maps to a corresponding **`varianceReasonId`** in the inventory system.

- **comments** *(optional)*  
  Free-text comments detailing why the item is rejected.


## **Output**

- **List of Canceled Inventory Reservations**  
  Identifiers and details of any inventory reservations that were canceled due to this rejection.


### **Workflow**

1. **Check for ShipmentItem**  
   - If a `shipmentId` and `shipmentItemSeqId` are provided, check if they are valid and associated with this `OrderItem`.  
   - If a valid `ShipmentItem` is found, apply the `rejectShipmentItem` logic:
     1. If the shipment is **not** in `SHIPMENT_INPUT` status, call `reinitializeShipment`.  
     2. Delete any associated `ShipmentPackageContent` records.  
     3. Delete the `ShipmentItem` record.  
     4. Delete the `OrderShipment` record linking the order to the shipment, if that link is now invalid.  
     5. Clear the `fulfillmentStatus` on the Solr `ORDER` document (or any relevant search index document).  

   - Once the shipment records are handled (or if no shipment item existed), continue to the following steps to complete the `OrderItem` rejection.

2. **Cancel Inventory Reservation**  
   - Call the [cancelOrderItemInvResQty](inventory-mgmt/cancelOrderItemInvRes.md) service to cancel any existing inventory reservations for the rejected `OrderItem`.  
   - This cancellation applies to both the main item and any package components if the item is part of a marketing package.

3. **Move to Rejected Ship Group**  
   - Identify (or create) the `OrderItemShipGroup` associated with the `naFacilityId` (or the designated facility for rejected items).  
   - Move the `OrderItem` from its current ship group or shipment to this newly determined “rejected” group.  
   - Update or create `OrderItemShipGroupAssoc` records to ensure the item is now assigned to the correct facility/ship group.

4. **Create Order History**  
   - Insert an `OrderHistory` record with the event type `ITEM_REJECTED` (or the relevant enumeration).  
   - This tracks and audits the item’s rejection in the order history for future reference.

5. **Create Order Facility Change**  
   - Record the change of facility in an `OrderFacilityChange` record.  
   - For instance, if the item is being transferred from a fulfillment center to a “not available” or “rejected” facility, this step documents that transition.

6. **Record Inventory Variance**  
   - Determine how the rejection reason affects inventory. For example:  
     - If `updateQOH = Y`, the item’s quantity-on-hand may decrease in the rejecting facility.  
     - If the `rejectionReasonId` maps to an enumeration type that requires a variance (e.g., `REPORT_VAR`, `REPORT_ALL_VAR`), create the appropriate variance through [createPhysicalInventory](inventory-mgmt/createPhysicalInventory.md).  
       - `REPORT_VAR` typically reduces `availableToPromise` by the order quantity.  
       - `REPORT_ALL_VAR` may reduce the entire `InventoryItem.availableToPromiseTotal`.  
       - `REPORT_NO_VAR` indicates no variance record is created.  
     - The `rejectionReasonId` is used as the `varianceReasonId` when calling the inventory APIs.

7. **Set Auto Cancel Date (Optional)**  
   - If the store configuration has `setAutoCancelDate = "Y"`, compute and assign an automatic cancel date for the rejected item.  
   - This is often used to automatically cancel or close out an order if certain criteria (e.g., payment) are not met in time.

8. **Log External Fulfillment**  
   - Create a system message or call the `createUpdateExternalFulfillmentOrderItem` service to notify external systems of the rejected item.  
   - This ensures all external fulfillment or third-party logistics providers are updated accordingly.


### **Handling Bundle Product OrderItems**
If the `OrderItem` refers to a *bundle product*, its component items (linked via `OrderItemShipGrpInvRes`, `PickListItem`, and `ShipmentItem`) are also typically reserved, picked, and shipped together. When rejecting the *parent* `OrderItem`, be sure to evaluate if any underlying component items also need to be adjusted or rejected, particularly during the inventory reservation and/or shipment cancellation steps.


## **Relevant Enumerations**

### **OrderHistory**  
| Enum Id           | Enum Type Id       | Enum Code          | Enum Name            | Description  |
|-------------------|--------------------|--------------------|----------------------|--------------|
| ITEM_BKD_REJECTED | ORDER_EVENT_TYPE   | BROKERING_REJECTED | Brokering Rejected   |              |
| ITEM_BROKERED     | ORDER_EVENT_TYPE   | BROKERED           | Brokered             |              |
| ITEM_CANCELLED    | ORDER_EVENT_TYPE   | CANCELLED          | Cancelled            |              |
| ITEM_SHIPPED      | ORDER_EVENT_TYPE   | SHIPPED            | Shipped              |              |

### **OrderFacilityChange**  
| Enum Id       | Enum Type Id          | Enum Code           | Enum Name             | Description                          |
|---------------|-----------------------|---------------------|-----------------------|--------------------------------------|
| BROKERED      | BROKERING_REASN_TYPE  | BROKERING_REASN_TYPE| Brokered             |                                      |
| DAMAGED       | BROKERING_REASN_TYPE  | DAMAGED            | Damaged              |                                      |
| INV_NOT_FOUND | BROKERING_REASN_TYPE  | INV_NOT_FOUND      | Inventory not found  |                                      |
| INV_STOLEN    | BROKERING_REASN_TYPE  | INV_STOLEN         | Inventory stolen      |                                      |
| RELEASED      | BROKERING_REASN_TYPE  | RELEASED           | Released             |                                      |
| UNFILLABLE    | BROKERING_REASN_TYPE  | UNFILLABLE         | Unfillable           |                                      |

### **Rejection Reason & Variance Mapping**  
Each `rejectionReasonId` is associated with a `varianceReasonId` in the inventory system to indicate how quantity or availability should be adjusted:

| Enumeration        | enumTypeId       | Description                                | VarianceReason                          |
|--------------------|------------------|--------------------------------------------|-----------------------------------------|
| NOT_IN_STOCK       | REPORT_ALL_VAR   | Not in Stock                               | NOT_IN_STOCK                            |
| WORN_DISPLAY       | REPORT_VAR       | Worn Display                               | WORN_DISPLAY                            |
| REJ_RSN_DAMAGED    | REPORT_VAR       | Damaged                                    | REJ_RSN_DAMAGED                         |
| MISMATCH           | REPORT_VAR       | Mismatch                                   | MISMATCH                                |
| INACTIVE_STORE     | REPORT_NO_VAR    | Inactive store; no variance logged         | INACTIVE_STORE                          |
| NO_VARIANCE_LOG    | REPORT_NO_VAR    | No variance                                | NO_VARIANCE_LOG                         |
| REJECT_ENTIRE_ORDER| REPORT_NO_VAR    | Reject entire order; no variance tracking  | (maps to NO_VARIANCE or custom logic)   |

---

## **Usage Notes**

1. **Shipment Item or No Shipment Item**  
   - If `shipmentId` and `shipmentItemSeqId` are not provided (or no valid shipment exists), rejection proceeds directly with the inventory and facility changes.  
   - If these values are provided and a valid `ShipmentItem` **does** exist, the steps in **Check for ShipmentItem** remove the item from the shipment before continuing the rest of the rejection process.

2. **Auditing & Tracking**  
   - All relevant changes (shipment handling, inventory, facility assignment, order history, etc.) are logged, ensuring complete traceability.

3. **Integration with `rejectorderitems`**  
   - While `rejectOrderItem()` is designed to handle individual item rejections, the higher-level `rejectorderitems` service can batch-process multiple items. It applies `maySplit` and `cascadeRejectByProduct` logic to create a final list of items, then calls `rejectOrderItem()` for each item in that list.

By following these guidelines, you ensure that an `OrderItem`—whether it has an associated `ShipmentItem` or not—is correctly moved to the rejection workflow, its inventory reservations are canceled, and all relevant records (shipment, history, facility changes, variances) are properly updated.

<details>
  <summary>XML Data</summary>
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

    <VarianceReason varianceReasonId="NOT_IN_STOCK" description="Not in Stock"/>
    <VarianceReason varianceReasonId="WORN_DISPLAY" description="Worn Display"/>
    <VarianceReason varianceReasonId="REJ_RSN_DAMAGED" description="Damaged"/>
    <VarianceReason varianceReasonId="MISMATCH" description="Mismatch"/>
    <VarianceReason varianceReasonId="INACTIVE_STORE" description="Inactive store"/>
    <VarianceReason varianceReasonId="NO_VARIANCE_LOG" description="No variance"/>
</details>