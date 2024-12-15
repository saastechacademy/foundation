## rejectOrderItem

### Purpose
* Move the OrderItem from assigned fulfillment facility to brokering queue or reject orderItem queue or similar.
* This service should be used only if NO valid ShipmentItem for the OrderItem exits.
* To [rejectShipmentItem](rejectShipmentItem.md) use API designed for the purpose.

**NOTE:** As compared to legacy code:
* Does create or update records in OrderItemShipGroupAssoc entity.
* An orderItem is part of one and only one OrderItemShipGroup. 

**IN Parameters**
* `orderId`
* `orderItemSeqId`
* `rejectToFacilityId`
* `updateQOH`
* `rejectionReasonId`
* `comments` optional

**OUT Parameters** 
* List of cancelled Inventory reservations.


### Workflow

1. **Cancel Inventory Reservation:** Call [cancelOrderItemInvResQty](inventory-mgmt/cancelOrderItemInvRes.md) service to cancel the corresponding inventory reservation for the orderItem quantity. The called service will cancel reservation for marketing package and all its components. 
2. **Cancel the related PickListOrderItem item:** Get `picklistOrderItems` for `orderId` `orderItemSeqId` and `update#PicklistOrderItem` status to `PICKITEM_CANCELLED`
3. **Move to Rejected Ship Group:** Move the orderItem to a ship group associated with the `naFacilityId` (a designated facility for rejected items). [Check if OrderItemShipGroup exits](findOrCreateOrderItemShipGroup.md) for the `naFacilityId` else create one and then move `orderItem` to this ship group. 
4. **Create Order History:** An `OrderHistory` record is created with the event type `ITEM_REJECTED` to track the rejection in the order's history.
5. **Create Order Facility Change:** An `OrderFacilityChange` record is created to log the change in facility for the rejected item.
6. **Record Inventory Variance:** 
   *    Analyze the rejection reason to compute the var quantity, record inventory variance for the rejected quantity from the facility rejecting the orderItem.
     *  if `updateQOH=Y` then QOH else ATP variance quantity 
     *  If `enumTypeId` of `rejectionReasonId` Enumeration  is `REPORT_VAR`, availableToPromiseVar is (-ve) of OrderItem.Qty 
     *  If `enumTypeId` of `rejectionReasonId` Enumeration  is `REPORT_ALL_VAR`, availableToPromiseVar is (-ve) of InventoryItem.availableToPromiseTotal
     *  if `enumTypeId` of `rejectionReasonId` Enumeration  is `REPORT_NO_VAR`, No Variance is recorded.
   *    The input parameter `rejectionReasonId` maps to `varianceReasonId` parameter in createPhysicalInventory API.
   *    [createPhysicalInventory](inventory-mgmt/createPhysicalInventory.md). 
7. **Set Auto Cancel Date:** If the productStore setting `setAutoCancelDate` flag is set to "Y," the service calculates and sets an auto-cancel date for the order item based on the product store's configuration. This is typically used to automatically cancel orders that haven't been paid for within a certain timeframe.
8. **Log External Fulfillment:** Create SystemMessage to Notify externals systems. The `createUpdateExternalFulfillmentOrderItem` service is called to create or update an external fulfillment log entry, marking the item as rejected.

### Bundle product OrderItem

In case the OrderItem is for bundle product. During the fulfillment process, PRODUCT_COMPONENT of the budles products are reserved `OrderItemShipGrpInvRes`,  picked `PickListItem` and shipped `ShipmentItem`.


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


```xml
    <!-- Rejection reason -->
    <!-- 
        The OrderItem rejected by the fulfillment center, could be for few rejectionReason, The rejectionReasonType is used to deduce if rejection impacts inventory ATP or NOT.   
        The rejectionReason are categorised by rejectionReasonType. 
        The rejectionReasonId have logical value, (Convention / Configuration)
        
        For each rejectionReasonId we have mapping varianceReasonId.        
        For each OrderItem rejection we record PhysicalInventory and InventoryItemVariance.  
        The rejectionReasonId maps to the varianceReasonId input parameter to the createPhysicalInventory service.        
    -->

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

```