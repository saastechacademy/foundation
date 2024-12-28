## **rejectOrderItems**

### **Overview**
The `rejectorderitems` REST API endpoint is used to reject one or more `OrderItems`. Internally, it builds a list of items to reject and calls `rejectOrderItem()` for each item. The actual rejection logic (including the cancellation of shipments, if needed) is handled by `rejectOrderItem()`. There is no separate `rejectShipmentItem` service.

Typical reasons for rejection include defective products, unavailable stock, or other conditions that require removing items from pending fulfillments.

---

### **Parameters**

- **orderId**  
- **orderItemSeqId**  
- **productId**  
- **facilityId**  
- **rejectToFacilityId**  
  - Facility to which rejected items are transferred.
- **updateQOH**  
  - Flag indicating whether to update quantity on hand.
- **rejectionReasonId**  
  - Reason for the rejection (e.g., damage, mismatch).
- **maySplit**  
  - Defaults to **N**. When set to **Y**, only the specified order item is rejected (rather than the entire ship group).
- **cascadeRejectByProduct**  
  - Defaults to **N**. When set to **Y**, rejects all items in the specified facility that have the same `productId`.
- **rejectionReasonId**  
  - Reason for the rejection (e.g., `NOT_IN_STOCK`, `MISMATCH`, `REJ_RSN_DAMAGED`). Maps to a corresponding **`varianceReasonId`** in the inventory system.
- **comments**  
  - Free-text comments explaining the reason for rejection.

---

### **Output (OUT)**

- **List of Canceled Inventory Reservations**  
  Identifiers and details of any inventory reservations that were canceled due to this rejection.

---
### **Key Workflow**

1. The **`rejectorderitems`** REST endpoint is called with a list of items to reject from a facility.  
2. **`rejectorderitems`** applies the **`cascadeRejectByProduct`** and **`maySplit`** logic to determine which items actually need to be rejected:
   - If **`cascadeRejectByProduct = Y`**, additional order containing the rejected product at that faciloity sharing are included in the rejection list.  
   - If **`maySplit = N`**, entire ship groups are rejected instead of individual items. Otherwise, only the specific items passed in the payload are rejected.  
3. For each resolved item in the final rejection list:
   - The endpoint invokes **`rejectOrderItem()`** with the appropriate parameters.
---

### **SQL Logic**

Use one of the following SQL statements based on whether you need to:
1. Reject only the specific items that match the product ID (**item-level**).
2. Reject all items in orders that contain a specific product (**cascade**).

#### **Common Joins**
- `order_item_ship_group (oisg)`  
  - Join on `ORDER_ID` and `SHIP_GROUP_SEQ_ID` to link `OrderItem` to its shipment group.
- `order_shipment (os)` (LEFT JOIN)  
  - Join on `ORDER_ID`. Some items might not have a shipment yet.
- `shipment (sh)` (LEFT JOIN)  
  - Join on `SHIPMENT_ID`. Some shipments might not exist or be fully linked yet.

#### **Common Filter Conditions**
- `oisg.facility_id = '102'`  
  - Ensures we only select items from the specified facility (example uses ID `102`).
- `oi.status_id = 'ITEM_APPROVED'`  
  - Restricts to items that are approved.
- `sh.status_id IS NULL OR sh.status_id IN ('SHIPMENT_INPUT', 'SHIPMENT_APPROVED')`  
  - Ensures that items are in an in-progress shipment (not yet shipped).

---

#### **1. Item-Level Reject**
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

1. This **directly filters** the result set to only include items where the product ID is `12888`.

```sql
 AND  oi.product_id = '12888'
 ```

2. This is helpful when you only want to **reject the specific item** that has `product_id = '12888'`, rather than affecting all items in orders that contain item `12888`.

---

#### **2. Cascade Reject**
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
         JOIN   order_item_ship_group oisg_inner 
                ON  oi_inner.ORDER_ID = oisg_inner.ORDER_ID
                AND oi_inner.SHIP_GROUP_SEQ_ID = oisg_inner.SHIP_GROUP_SEQ_ID
         WHERE  oi_inner.PRODUCT_ID = '12888'
            AND oisg_inner.facility_id = '102'
            AND oi_inner.status_id = 'ITEM_APPROVED'
       );
```
#### **Explanation**

1. This query includes all order items in facility `102` with status `ITEM_APPROVED` and no shipment or an early-stage shipment (`SHIPMENT_INPUT` or `SHIPMENT_APPROVED`).

The **key condition** is:  
``` sql 
 oi.order\_ID IN   
    (SELECT DISTINCT oi_inner.order_id
         FROM   order_item oi_inner
         JOIN   order_item_ship_group oisg_inner 
                ON  oi_inner.ORDER_ID = oisg_inner.ORDER_ID
                AND oi_inner.SHIP_GROUP_SEQ_ID = oisg_inner.SHIP_GROUP_SEQ_ID
         WHERE  oi_inner.PRODUCT_ID = '12888'
            AND oisg_inner.facility_id = '102'
            AND oi_inner.status_id = 'ITEM_APPROVED')
```
2.  This means we want **all orders** (and their items) **that contain a product with ID `12888`**. This is useful for a **cascade reject** because it affects all items within orders containing the specified product—**not just the single item** tied directly to that product.

---

### **Example Input Parameters**

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

**Implementation Detail**:  
- The `rejectorderitems` endpoint receives the array above.  
- For each object in the array, it calls `rejectOrderItem()` with the relevant parameters (`orderId`, `orderItemSeqId`, etc.).  
- The `rejectOrderItem()` function then executes the appropriate logic (cascade or item-level), updates statuses, and cancels inventory reservations.  
