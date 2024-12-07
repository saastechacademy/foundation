**1. Introduction**

*   **Purpose:** This service reserves inventory for a specific order item within a shipment group at a designated facility in HotWax Commerce (HC).
*   **Scope:** The service handles finished goods and non-serialized inventory items.
  * Finished Goods
  * Non serialized Inventory
  * One InventoryItem per Facility per Product
  * statusId is not used
  * Do negative reservation if not enough in stock.

**2. Service Definition**

*   **Service Name:** `createOrderItemInventoryReservation`
*   **Input Parameters:**
    *   `orderId` (required): The ID of the order.
    *   `orderItemSeqId` (required): The sequence ID of the order item.
    *   `productId` (required): The ID of the product to reserve.
    *   `quantity` (required): The quantity to reserve.
    *   `facilityId` (required): The ID of the facility where the inventory is located.
    *   `locationSeqId` (optional): The sequence ID of the specific location within the facility.

**3. Data Model**

*   **Entity Relationships:**
    *   `OrderItem` has a one-to-one relationship with `OrderItemShipGroup` in HC.
    *   `OrderItem` has a one-to-many relationship with `OrderItemShipGrpInvRes`.
    *   `OrderItemShipGroup` has a one-to-many relationship with `OrderItemShipGrpInvRes`.
    *   `InventoryItem` has a one-to-many relationship with `InventoryItemDetail`.
    *   `OrderItemShipGrpInvRes` has a many-to-one relationship with `InventoryItem`.

**4. Service Logic**

*   **Detailed Steps:**
    1. **Input Validation:**
    2. **Inventory Item Retrieval:**
        *   Query the `InventoryItem` entity to find all items matching the `productId` and `facilityId`.
        *   If `locationSeqId` is provided, filter the results further to include only items at that location.
        *   Sort the results descending by `availableToPromiseTotal`, get first InventoryItem record.
    3. **:**
    4. **Reservation Creation:**
        *   Iterate through the sorted list of `InventoryItem` records.
        *   For each item, attempt to reserve the requested `quantity` by:
            *   Creating or updating an `OrderItemShipGrpInvRes` record to link the reservation to the order item, shipment group, and inventory item.
            *   Create an `InventoryItemDetail` record for each reservation to track the change in inventory.
            *   Updating the `availableToPromiseTotal` of the `InventoryItem`.
    5. **Handling Insufficient Inventory:**
        *   After attempting to reserve inventory from all suitable `InventoryItem` records, check if the `quantityNotReserved` is greater than zero.
        *   If `quantityNotReserved` is greater than zero, it indicates that the facility has insufficient ATP inventory to fulfill the entire requested quantity.
        *   In this case :
            1.  Check if there is a `lastNonSerInventoryItem` available (this would be the last `InventoryItem` processed in the FIFO iteration).
            2.  If a `lastNonSerInventoryItem` exists:
                *   Subtract the remaining `quantityNotReserved` from the `availableToPromise` of that `InventoryItem`, effectively creating a negative ATP.
                *   Create an `InventoryItemDetail` record to reflect this change in ATP.
                *   Create an `OrderItemShipGrpInvRes` record with `quantityNotAvailable` set to the `quantityNotReserved` value. This indicates that a portion of the reservation is not currently available.
            3.  If no `lastNonSerInventoryItem` exists:
                *   Create a new non-serialized `InventoryItem` with `availableToPromise` set to the negative value of `quantityNotReserved`.
                *   Create an `InventoryItemDetail` record to reflect this initial negative ATP.
                *   Create an `OrderItemShipGrpInvRes` record with `quantityNotAvailable` set to the `quantityNotReserved` value.

**5. Implementation Notes**
  
**HC-Specific Considerations:**
    *   The `OrderItem` entity in HC includes the `shipGroupSeqId` field, resulting in a one-to-one relationship between `OrderItem` and `OrderItemShipGroup`.
    *   In HC we have one InventoryItem per facility per product. I think we can skip the logic to loop thru InventoryItems to try to reserve the requested quantity.

**Scenario:**

A customer places an order for 1 unit of product "P001" to be shipped from facility "F001".

**Initial State:**

| Entity             | Field               | Value        |
|----------------------|----------------------|--------------|
| **OrderItem**       | `orderId`           | "O001"       |
|                    | `orderItemSeqId`    | "00001"      |
|                    | `productId`         | "P001"       |
|                    | `quantity`          | 1            |
|                    | `shipGroupSeqId`   | "00001"      |
| **OrderItemShipGroup** | `orderId`           | "O001"       |
|                    | `shipGroupSeqId`   | "00001"      |
|                    | `facilityId`        | "F001"       |
| **InventoryItem**    | `inventoryItemId`   | "I001"       |
|                    | `productId`         | "P001"       |
|                    | `facilityId`        | "F001"       |
|                    | `availableToPromiseTotal` | 10           |
|                    | `datetimeReceived`  | 2024-11-10   |


**Service Execution:**

The `createOrderItemInventoryReservation` service is called with the following input parameters:

| Parameter         | Value        |
|------------------|--------------|
| `orderId`        | "O001"       |
| `orderItemSeqId` | "00001"      |
| `productId`      | "P001"       |
| `quantity`       | 1            |
| `facilityId`     | "F001"       |


**Final State:**

| Entity                 | Field               | Value        |
|--------------------------|----------------------|--------------|
| **OrderItemShipGrpInvRes** | `orderId`           | "O001"       |
|                          | `orderItemSeqId`    | "00001"      |
|                          | `shipGroupSeqId`   | "00001"      |
|                          | `inventoryItemId`   | "I001"       |
|                          | `quantity`          | 1            |
|                          | `quantityNotAvailable` | 0            |
| **InventoryItem**        | `inventoryItemId`   | "I001"       |
|                          | `productId`         | "P001"       |
|                          | `facilityId`        | "F001"       |
|                          | `availableToPromiseTotal` | 9            |
|                          | `datetimeReceived`  | 2024-11-10   |
| **InventoryItemDetail**  | `inventoryItemId`   | "I001"       |
|                          | `orderId`           | "O001"       |
|                          | `orderItemSeqId`    | "00001"      |
|                          | `shipGroupSeqId`   | "00001"      |
|                          | `availableToPromiseDiff` | -1           |



### `reserveForInventoryItemInline` Function

**Why not implement this in reserveProductInventory?**

**1. Introduction**

**2. Function Definition**

*   **Function Name:** `reserveForInventoryItemInline`
*   **Input Parameters:**
    *   `inventoryItem`: A `GenericValue` representing the `InventoryItem` from which to reserve inventory.
    *   `quantityNotReserved`: A `BigDecimal` representing the remaining quantity to be reserved.
    *   `orderId`: A `String` representing the ID of the order.
    *   `orderItemSeqId`: A `String` representing the sequence ID of the order item.
    *   `shipGroupSeqId`: A `String` representing the sequence ID of the shipment group.
*   **Output Parameters:**
    *   `inventoryItem`: The updated `GenericValue` representing the `InventoryItem`.
    *   `quantityNotReserved`: The updated `BigDecimal` representing the remaining quantity to be reserved.
    *   `lastNonSerInventoryItem`: A `GenericValue` representing the last non-serialized `InventoryItem` processed.

**3. Logic**

*   **Check for Non-Serialized Inventory:**
    *   Verify that the `inventoryItemTypeId` of the input `inventoryItem` is `NON_SERIAL_INV_ITEM`. 
    *   If not, the function should exit or throw an error, as HC only supports non-serialized inventory.
    *   I think we can skip this in HC OMS implementation.

*   **Check Inventory Availability:**
    *   Ensure that the `InventoryItem` is not on hold or defective (`statusId` is not `INV_ON_HOLD` or `INV_NS_DEFECTIVE` or `INV_DEFECTIVE`).
    *   Verify that the `availableToPromiseTotal` of the `InventoryItem` is greater than 0.
    *   HC does not have the idea of InventoryItem.status. I think we can skip this part. 
    *   Create negative reservation, if we don't have enough, This means we don't have to check if `availableToPromiseTotal` is greater than `0`.

*   **Calculate `deductAmount`:**
    *   Determine the amount to deduct from the `availableToPromiseTotal`, which is the lesser value between `quantityNotReserved` and `availableToPromiseTotal`.

*   **Create `OrderItemShipGrpInvRes`:**

*   **Update `InventoryItem`:**
    *   Reduce the `availableToPromiseTotal` of the `InventoryItem` by the `deductAmount`.
    *   Update the `lastUpdatedStamp` field of the `InventoryItem` to reflect the modification.

*   **Create `InventoryItemDetail`:**
    *   Create a new `InventoryItemDetail` record to log the reservation transaction.
    *   Populate the relevant fields in the `InventoryItemDetail` record, such as:
        *   `inventoryItemId`
        *   `orderId`
        *   `orderItemSeqId`
        *   `shipGroupSeqId`
        *   `availableToPromiseDiff` (set to the negative of the `deductAmount`)


**5. HotWax Commerce Considerations**

*   This implementation focuses solely on non-serialized inventory, as that's the only type supported in HC.
*   Ensure that the function integrates seamlessly with the HC data model and any related services or workflows.

**Key Considerations**

*   **Simplified Logic in HotWax Commerce:** In HotWax Commerce, due to the one-to-one relationship between `OrderItem` and `OrderItemShipGroup`, the logic for retrieving or creating `OrderItemShipGroup` records might be simplified.
