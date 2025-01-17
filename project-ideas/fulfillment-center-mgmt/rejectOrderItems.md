# **rejectOrderItems**
> NOTE: This REST API is used exclusively for rejecting OrderItems during the fulfillment process—from an outstanding order up until just before the shipment is packed. Once the shipment is packed, items can no longer be rejected through this endpoint.

## **Overview**
The `rejectorderitems` REST API endpoint is used to reject one or more `OrderItems`. Internally, it builds a list of items to reject and calls `rejectOrderItem()` for each item. The actual rejection logic (including the cancellation of shipments, if needed) is handled by `rejectOrderItem()`. There is no separate `rejectShipmentItem` service.

Typical reasons for rejection include defective products, unavailable stock, or other conditions that require removing items from pending fulfillments.

## **Example Input Parameters**

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




## **Parameters for each OrderItem**

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

## **Output (OUT)**

- **List of Canceled Inventory Reservations**  
  Identifiers and details of any inventory reservations that were canceled due to this rejection.

## **Key Workflow**

1. **`rejectorderitems`** is called with a list of items to reject.  
2. It applies **`cascadeRejectByProduct`** and **`maySplit`** to determine which items to reject:  
   * **`cascadeRejectByProduct = Y`**: Include other items with the same product in that facility.  
   * **`maySplit = N`**: Reject entire ship groups rather than specific items.  
3. Based on **`maySplit`** and **`cascadeRejectByProduct`** values, the system queries order/shipment data:  
   * **`maySplit = N`, `cascadeRejectByProduct = N`**: Reject only the single item.  
   * **`maySplit = Y`, `cascadeRejectByProduct = N`**: Reject all items in the specified ship group.  
   * **`maySplit = Y`, `cascadeRejectByProduct = Y`**: Reject items with the same product ID, but only those specifically targeted or matching criteria.  
   * **`maySplit = N`, `cascadeRejectByProduct = Y`**: Reject entire ship groups for all orders containing the specified product.  
4. For each item to reject, **`rejectOrderItem()`** is called with the appropriate parameters.

## cascadeRejectByProduct = N

### 1. **maySplit = N and cascadeRejectByProduct = N**

```sql
SELECT oi.ORDER_ID,
       oi.ORDER_ITEM_SEQ_ID,
       oisg.SHIP_GROUP_SEQ_ID,
       oi.PRODUCT_ID,
       oisg.FACILITY_ID,
       oi.STATUS_ID AS item_status,
       sh.STATUS_ID AS shipment_status,
       oi.CREATED_STAMP
FROM order_item oi
JOIN order_item_ship_group oisg 
     ON  oi.ORDER_ID = oisg.ORDER_ID
     AND oi.SHIP_GROUP_SEQ_ID = oisg.SHIP_GROUP_SEQ_ID
LEFT JOIN order_shipment os 
     ON  oi.order_id = os.order_id
LEFT JOIN shipment sh 
     ON  os.SHIPMENT_ID = sh.SHIPMENT_ID
WHERE oi.order_id = '4567'
  AND oisg.ship_group_seq_id = '0001';
```

#### **Explanation**

1. **No Cascading**  
   Does not look for items sharing the same `productId` (i.e., `cascadeRejectByProduct = N`).

2. **Reject Entire Ship Group**  
   Since `maySplit = N`, this query covers all items under the specified `orderId` and `ship_group_seq_id`.  
   - No `order_item_seq_id` filter is included.  
   - All items in `SHIP_GROUP_SEQ_ID = '0001'` will be targeted.

3. **Optional Shipment Joins**  
   Left joins to `order_shipment` and `shipment` retrieve any in-progress shipment status but do not affect filtering when `maySplit = N`.

---

### 2. **maySplit = Y and cascadeRejectByProduct = N**

```sql
SELECT oi.ORDER_ID,
       oi.ORDER_ITEM_SEQ_ID,
       oisg.SHIP_GROUP_SEQ_ID,
       oi.PRODUCT_ID,
       oisg.FACILITY_ID,
       oi.STATUS_ID AS item_status,
       sh.STATUS_ID AS shipment_status,
       oi.CREATED_STAMP
FROM order_item oi
JOIN order_item_ship_group oisg 
     ON  oi.ORDER_ID = oisg.ORDER_ID
     AND oi.SHIP_GROUP_SEQ_ID = oisg.SHIP_GROUP_SEQ_ID
LEFT JOIN order_shipment os 
     ON  oi.order_id = os.order_id
LEFT JOIN shipment sh 
     ON  os.SHIPMENT_ID = sh.SHIPMENT_ID
WHERE oi.order_id = '4567'
  AND oisg.ship_group_seq_id = '0001'
  AND order_item_seq_id = '0001';
```

#### **Explanation**

1. **Reject Single Item**  
   With `maySplit = Y`, the query targets only the specified `order_item_seq_id = '0001'`.

2. **No Cascading**  
   `cascadeRejectByProduct = N` means only this exact item is considered, regardless of shared `productId` elsewhere.

3. **Ship Group-Specific**  
   `ship_group_seq_id = '0001'` restricts selection to items in that group. In combination with the single `order_item_seq_id`, it precisely identifies the specific item to reject.

## cascadeRejectByProduct = Y

#### **Common Joins**
- `order_item_ship_group (oisg)`  
  - Join on `ORDER_ID` and `SHIP_GROUP_SEQ_ID` to link `OrderItem` to its shipment group.
- `order_shipment (os)` (LEFT JOIN)  
  - Join on `ORDER_ID`. Some items might not have a shipment yet.
- `shipment (sh)` (LEFT JOIN)  
  - Join on `SHIPMENT_ID`. Some shipments might not exist or be fully linked yet.

### **Common Filter Conditions**
- `oisg.facility_id = '102'`  
  - Ensures we only select items from the specified facility (example uses ID `102`).
- `oi.status_id = 'ITEM_APPROVED'`  
  - Restricts to items that are approved.
- `sh.status_id IS NULL OR sh.status_id IN ('SHIPMENT_INPUT', 'SHIPMENT_APPROVED')`  
  - Ensures that items are in an in-progress shipment (not yet shipped).

### 3. maySplit = Y and cascadeRejectByProduct = Y
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

### 4. maySplit = N and cascadeRejectByProduct = Y
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

**Implementation Detail**:  
- The `rejectorderitems` endpoint receives the array above.  
- For each object in the array, it calls `rejectOrderItem()` with the relevant parameters (`orderId`, `orderItemSeqId`, etc.).  
- The `rejectOrderItem()` function then executes the appropriate logic (cascade or item-level), updates statuses, and cancels inventory reservations.  
