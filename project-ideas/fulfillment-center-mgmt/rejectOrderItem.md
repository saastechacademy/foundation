## **rejectOrderItem**

### **Purpose**

The `rejectOrderItem` service is used to move an `OrderItem` from its assigned fulfillment facility back to a brokering queue (or a reject queue) in cases where **no valid `ShipmentItem`** for the `OrderItem` exists. (If a valid `ShipmentItem` does exist and needs to be rejected, use the appropriate API for rejecting shipment items.)

> **Note**: In contrast to legacy code, this operation **does create or update records** in the `OrderItemShipGroupAssoc` entity. Remember that each `OrderItem` is associated with exactly one `OrderItemShipGroup`.

---

### **Input Parameters**

1. **orderId**  
2. **orderItemSeqId**  
3. **rejectToFacilityId**  
4. **updateQOH**  
5. **rejectionReasonId**  
6. **comments** (optional)

---

### **Output Parameters**

- **List of Inventory Reservations** that need to be canceled.

---

### **Primary SQL Retrieval Logic**

The SQL below is used to find all items that match certain criteria (e.g., `ITEM_APPROVED`, matching facility, etc.). Depending on the requirement—whether it’s a *cascade delete* scenario or a simple *item delete* scenario—you can use one of the following two statements.
> - Use the **Cascade Delete** statement if you need to capture all orders containing the product, and delete all relevant items across those orders.  
> - Use the **Item Delete** statement if you only need to delete items specifically tied to a single product within an order.
### **Common Joins**

* **JOIN `order_item_ship_group` (`oisg`)**  
   Joins the `order_item_ship_group` table on matching `ORDER_ID` and `SHIP_GROUP_SEQ_ID`. This establishes which ship group the `OrderItem` is associated with.

* **LEFT JOIN `order_shipment` (`os`)**  
   Joins the `order_shipment` table on matching `order_id`. We use a left join because not all `OrderItem`s will have an associated shipment yet.

* **LEFT JOIN `shipment` (`sh`)**  
   Joins the `shipment` table on `SHIPMENT_ID`. Also a left join for the same reason as above.

### **Common Filter Conditions**

* **`oisg.facility_id = '102'`**  
   Filters for items in a specific facility (e.g., facility `102`).

* **`oi.status_id = 'ITEM_APPROVED'`**  
   Only selects `OrderItem`s that have reached the status `ITEM_APPROVED`.

* **`sh.status_id IS NULL OR sh.status_id IN ('SHIPMENT_INPUT','SHIPMENT_APPROVED')`**  
   Ensures we only look at items either not linked to a shipment or linked to shipments that are still in an early or approved stage.  

#### **1. Cascade Delete Code**

```sql
SELECT oi.ORDER_ID,
       oi.ORDER_ITEM_SEQ_ID,
       oisg.SHIP_GROUP_SEQ_ID,
       oi.PRODUCT_ID,
       oisg.FACILITY_ID,
       oi.STATUS_ID AS item_status,
       sh.STATUS_ID AS shipment_status,
       oi.CREATED_STAMP
FROM   order_item oi
       JOIN order_item_ship_group oisg 
            ON  oi.ORDER_ID = oisg.ORDER_ID
            AND oi.SHIP_GROUP_SEQ_ID = oisg.SHIP_GROUP_SEQ_ID
       LEFT JOIN order_shipment os 
            ON  oi.order_id = os.order_id
       LEFT JOIN shipment sh 
            ON  os.SHIPMENT_ID = sh.SHIPMENT_ID
WHERE  oisg.facility_id = '102'
  AND  oi.status_id = 'ITEM_APPROVED'
  AND (sh.status_id IS NULL
       OR sh.status_id IN ('SHIPMENT_INPUT','SHIPMENT_APPROVED'))
  AND  oi.order_ID IN 
       (SELECT DISTINCT oi_inner.order_id
        FROM   order_item oi_inner
        WHERE  oi_inner.PRODUCT_ID = '12888');
```
#### **Explanation**

1. This query includes all order items in facility `102` with status `ITEM_APPROVED` and no shipment or an early-stage shipment (`SHIPMENT_INPUT` or `SHIPMENT_APPROVED`).

The **key condition** is:  
``` sql 
 oi.order\_ID IN   
    (SELECT DISTINCT oi\_inner.order\_id  
     FROM order\_item oi\_inner  
     WHERE oi\_inner.PRODUCT\_ID \= '12888')
```
2.  This means we want **all orders** (and their items) **that contain a product with ID `12888`**. This is useful for a **cascade delete** because it affects all items within orders containing the specified product—**not just the single item** tied directly to that product.

Use this statement if you need to **delete multiple items** that may be affected when a product is removed (or similar scenario).

#### **2. Item Delete Code**

```sql
SELECT oi.ORDER_ID,
       oi.ORDER_ITEM_SEQ_ID,
       oisg.SHIP_GROUP_SEQ_ID,
       oi.PRODUCT_ID,
       oisg.FACILITY_ID,
       oi.STATUS_ID AS item_status,
       sh.STATUS_ID AS shipment_status,
       oi.CREATED_STAMP
FROM   order_item oi
       JOIN order_item_ship_group oisg 
            ON  oi.ORDER_ID = oisg.ORDER_ID
            AND oi.SHIP_GROUP_SEQ_ID = oisg.SHIP_GROUP_SEQ_ID
       LEFT JOIN order_shipment os 
            ON  oi.order_id = os.order_id
       LEFT JOIN shipment sh 
            ON  os.SHIPMENT_ID = sh.SHIPMENT_ID
WHERE  oisg.facility_id = '102'
  AND  oi.status_id = 'ITEM_APPROVED'
  AND (sh.status_id IS NULL
       OR sh.status_id IN ('SHIPMENT_INPUT','SHIPMENT_APPROVED'))
  AND  oi.product_id = '12888';
```
#### **Explanation**

Similar to the cascade query above, except:  
```sql
 AND  oi.product\_id \= '12888'
 ```

1.  This **directly filters** the result set to only include items where the product ID is `12888`.  
2. This is helpful when you only want to **delete or reject the specific item** that has `product_id = '12888'`, rather than affecting all items in orders that contain `12888`.

Use this statement if you need to **target a specific item or set of items** by product ID without impacting other items in the same order.


---

### **Process Flow Summary**

1. **Check Shipment**: Ensure that there are no valid `ShipmentItem` records for the given `OrderItem`.  
2. **Prepare Data**: Identify which items (using one of the two SQL statements above) are eligible for rejection.  
3. **Update Associations**: Create or update the relevant `OrderItemShipGroupAssoc` records to move the items to a reject or brokering queue.  
4. **Inventory Reservation Cancellation**: Collect and return a list of any inventory reservations that must be canceled.  
5. **Rejection Reason and Comments**: Store any optional comments and the `rejectionReasonId` for future reference or auditing.


### Workflow

1. **Cancel Inventory Reservation:** Call [cancelOrderItemInvResQty](inventory-mgmt/cancelOrderItemInvRes.md) service to cancel the corresponding inventory reservation for the orderItem quantity. The called service will cancel reservation for marketing package and all its components. 
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
9. **Log External Fulfillment:** Create SystemMessage to Notify externals systems. The `createUpdateExternalFulfillmentOrderItem` service is called to create or update an external fulfillment log entry, marking the item as rejected.

### Bundle product OrderItem

In case the OrderItem is for bundle product. During the fulfillment process, PRODUCT_COMPONENT of the bundles products are reserved `OrderItemShipGrpInvRes`,  picked `PickListItem` and shipped `ShipmentItem`.


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