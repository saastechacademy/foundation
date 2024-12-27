## **rejectOrderItems**

### **Purpose**

Identifies and rejects OrderItems within a specific facility for a given product that are part of an in-progress shipment. This action is typically taken when a product is found to be defective, unavailable, or must otherwise be removed from pending fulfillments.

---

### **Parameters**
 
- **orderId**  
- **orderItemSeqId**  
- **productId**  
- **facilityId**  
- **rejectToFacilityId**  
- **updateQOH**  
- **rejectionReasonId**  
- **maySplit** _(defaults to **N**; if **Y**, only rejects the specified item instead of all in the ship group)_  
- **cascadeRejectByProduct** _(defaults to **N**; if **Y**, rejects all items with the same product in the specified facility)_  
- **comments**  

---

### **Output**

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


**Workflow:**
* For each OrderItem in the IN parameters
  1. If `cascadeRejectByProduct` is `Y`, 
     -Lookup in OrderItemAndShipGroup view WHERE facilityId	= OrderItemShipGroup.facilityId AND statusIs = `APPROVED` and productId = OrderItem.productId.
  2. for each OrderItemAndShipGroup, If maySplit is `Y`, Look OrderShipment by orderId and shipGroupSeqId else, orderId and orderItemSeqId.
  3. For each OrderShipment. 
     - If shipmentId and shipmentItemSeqId is NOT NULL call rejectShipmentItem()
     - else call rejectOrderItem

**Key points and logic:**

1.  **Input Parameters:**
```json
[
  {
    "orderId": "ORD001",
    "orderItemSeqId": "0001",
    "rejectToFacilityId": "FAC001",
    "updateQOH": "",
    "rejectionReasonId": "NOT_IN_STOCK",
    "maySplit": "N",
    "cascadeRejectByProduct": "N",
    "comments": "The item is currently out of stock."
  },
  {
    "orderId": "ORD001",
    "orderItemSeqId": "0002",
    "rejectToFacilityId": "FAC002",
    "updateQOH": "",
    "rejectionReasonId": "MISMATCH",
    "maySplit": "N",
    "cascadeRejectByProduct": "N",
    "comments": "The item received does not match the order description."
  },
  {
    "orderId": "ORD002",
    "orderItemSeqId": "0001",
    "rejectToFacilityId": "FAC003",
    "updateQOH": "",
    "rejectionReasonId": "DAMAGE",
    "maySplit": "N",
    "cascadeRejectByProduct": "N",
    "comments": "The item was found damaged during inspection."
  },
  {
    "orderId": "ORD002",
    "orderItemSeqId": "0002",
    "rejectToFacilityId": "FAC004",
    "updateQOH": "",
    "rejectionReasonId": "WORNDISPLAY",
    "comments": "The item is worn or was part of a display."
  },
  {
    "orderId": "ORD003",
    "orderItemSeqId": "0001",
    "rejectToFacilityId": "FAC005",
    "updateQOH": "",
    "rejectionReasonId": "NOT_IN_STOCK",
    "comments": "The item is unavailable due to low stock levels."
  }
]
```
For each OrderItem in the list, call rejectOrderItem

