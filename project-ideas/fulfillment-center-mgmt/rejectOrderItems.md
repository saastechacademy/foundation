## **rejectOrderItems**

### **Purpose**
Identifies and rejects `OrderItems` within a specified facility for a given product that are part of an in-progress shipment. This action is taken when a product is defective, unavailable, or must otherwise be removed from pending fulfillments.

---

### **Parameters**
- **orderId**  
- **orderItemSeqId**  
- **productId**  
- **facilityId**  
- **rejectToFacilityId**  
- **updateQOH**  
- **rejectionReasonId**  
- **maySplit**  
  - Defaults to **N**.  
  - If **Y**, only rejects the specified item instead of all items in the ship group.
- **cascadeRejectByProduct**  
  - Defaults to **N**.  
  - If **Y**, rejects all items with the same product in the specified facility.
- **comments**  

---

### **Output**
- **List of Inventory Reservations** that need to be canceled.

---

### **Primary SQL Retrieval Logic**

Depending on whether you need to reject all items in orders containing a certain product (**cascade reject**) or only specific items with that product (**item reject**), use one of the two statements below.

#### **Common Joins**
- **`order_item_ship_group` (oisg)** on `ORDER_ID` and `SHIP_GROUP_SEQ_ID` to establish the link between `OrderItem` and its ship group.  
- **`order_shipment` (os)** (LEFT JOIN) on `order_id`; not all items have a shipment.  
- **`shipment` (sh)** (LEFT JOIN) on `SHIPMENT_ID`; some shipments may not exist or be linked yet.

#### **Common Filter Conditions**
- `oisg.facility_id = '102'` – restricts to a specific facility (e.g., 102).  
- `oi.status_id = 'ITEM_APPROVED'` – selects only approved items.  
- `sh.status_id IS NULL OR sh.status_id IN ('SHIPMENT_INPUT','SHIPMENT_APPROVED')` – in-progress or not yet shipped.

---

#### **1. Cascade Reject Code**
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
        JOIN order_item_ship_group oisg_inner 
            ON  oi_inner.ORDER_ID = oisg_inner.ORDER_ID
            AND oi_inner.SHIP_GROUP_SEQ_ID = oisg_inner.SHIP_GROUP_SEQ_ID
        WHERE  oi_inner.PRODUCT_ID = '12888'
            AND oisg_inner.facility_id = '102'
            AND oi_inner.status_id = 'ITEM_APPROVED');
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
2.  This means we want **all orders** (and their items) **that contain a product with ID `12888`**. This is useful for a **cascade reject** because it affects all items within orders containing the specified product—**not just the single item** tied directly to that product.

Use this statement if you need to **reject multiple items** that may be affected when a product is removed (or similar scenario).
---

#### **2. Item Reject Code**
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
2. This is helpful when you only want to **reject the specific item** that has `product_id = '12888'`, rather than affecting all items in orders that contain `12888`.

Use this statement if you need to **target a specific item or set of items** by product ID without impacting other items in the same order.

---

### **Process Flow Summary**
1. **Check Shipment**: Ensure there are no valid `ShipmentItem` records for the `OrderItem` (or handle them via a separate API if they do exist).  
2. **Prepare Data**: Identify items eligible for rejection using the appropriate SQL query (cascade or item-specific).  
3. **Update Associations**: Create or update `OrderItemShipGroupAssoc` to move items into a reject or brokering queue.  
4. **Cancel Inventory Reservations**: Return a list of any reservations that must be canceled.  
5. **Rejection Details**: Store `rejectionReasonId`, `comments`, and handle quantity updates (`updateQOH`) as needed.

---

### **Workflow**

For each `OrderItem` in the input:
1. If `cascadeRejectByProduct = 'Y'`,  
   - Look up all matching `OrderItem`s in the given facility with `statusId = APPROVED` for the same product.  
2. For each matched `OrderItemAndShipGroup` record:  
   - If `maySplit = 'Y'`, look up `OrderShipment` by `(orderId, shipGroupSeqId)` only.  
   - Else, look up `OrderShipment` by `(orderId, orderItemSeqId)`.  
3. For each `OrderShipment`:  
   - If there is a `shipmentId` and `shipmentItemSeqId`, call `rejectShipmentItem()`.  
   - Otherwise, call `rejectOrderItem()`.

---

### **Key Points and Logic**

1. **Input Parameters (Example)**

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

2. **Call `rejectOrderItem()`** for each entry in the list, applying the rules above.
