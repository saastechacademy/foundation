**1. Introduction**

*   **Purpose:** This service reserves inventory for a specific order item within a shipment group at a designated facility in HotWax Commerce (HC).
*   **Scope:** The service handles finished goods and non-serialized inventory items. It enforces a First-In, First-Out (FIFO) strategy for inventory allocation.
*   **Reference Implementation:** This design is based on the Apache OFBiz `reserveProductInventory` service but tailored to HC's specific requirements and customizations.

**2. Service Definition**

*   **Service Name:** `reserveProductInventory`
*   **Input Parameters:**
    *   `orderId` (required): The ID of the order.
    *   `orderItemSeqId` (required): The sequence ID of the order item.
    *   `productId` (required): The ID of the product to reserve.
    *   `quantity` (required): The quantity to reserve.
    *   `facilityId` (required): The ID of the facility where the inventory is located.
    *   `locationSeqId` (optional): The sequence ID of the specific location within the facility.
    *   `requireInventory` (required): A flag (Y/N) indicating whether inventory is required for the reservation.
*   **Output Parameters:**
    *   `quantityNotReserved` (optional): The quantity that could not be reserved.

**3. Data Model**

*   **Entities:**
    *   `OrderItem`: Stores order item details, including the `shipGroupSeqId` in HC.
    *   `OrderItemShipGroup`: Tracks shipment group information, including the `facilityId`. In HC, there's a one-to-one relationship between `OrderItem` and `OrderItemShipGroup`.
    *   `OrderItemShipGrpInvRes`: Represents an inventory reservation for an order item within a shipment group.
    *   `InventoryItem`: Manages inventory levels and availability.
    *   `InventoryItemDetail`: Logs inventory transactions, including reservations.
*   **Entity Relationships:**
    *   `OrderItem` has a one-to-one relationship with `OrderItemShipGroup` in HC.
    *   `OrderItem` has a one-to-many relationship with `OrderItemShipGrpInvRes`.
    *   `OrderItemShipGroup` has a one-to-many relationship with `OrderItemShipGrpInvRes`.
    *   `InventoryItem` has a one-to-many relationship with `InventoryItemDetail`.
    *   `OrderItemShipGrpInvRes` has a many-to-one relationship with `InventoryItem`.

**4. Service Logic**

*   **Detailed Steps:**
    1.  **Input Validation:**
        *   Validate that all required input parameters are present and have valid values.
        *   Verify that the corresponding `OrderHeader`, `OrderItem`, `Product`, and `Facility` records exist in the database.
    2.  **Inventory Item Retrieval:**
        *   Query the `InventoryItem` entity to find all items matching the `productId` and `facilityId`.
        *   If `locationSeqId` is provided, filter the results further to include only items at that location.
        *   Filter the results to include only items with `availableToPromiseTotal` greater than or equal to the requested `quantity`.
    3.  **Dynamic Selection (FIFO):**
        *   Sort the filtered list of `InventoryItem` records in ascending order of their `datetimeReceived` values. This prioritizes items received earlier, adhering to the FIFO strategy.
    4.  **Reservation Creation:**
        *   Iterate through the sorted list of `InventoryItem` records.
        *   For each item, attempt to reserve the requested `quantity` by:
            *   Creating or updating an `OrderItemShipGrpInvRes` record to link the reservation to the order item, shipment group, and inventory item.
            *   Updating the `availableToPromiseTotal` of the `InventoryItem`.
    5.  **Inventory Transaction Logging:**
        *   Create an `InventoryItemDetail` record for each successful reservation to track the change in inventory.
    6.  **Handling Insufficient Inventory:**
        *   After attempting to reserve inventory from all suitable `InventoryItem` records, check if the `quantityNotReserved` output parameter is greater than zero.
        *   If `quantityNotReserved` is greater than zero, it indicates that the facility has insufficient ATP inventory to fulfill the entire requested quantity.
        *   In this case, if requireInventory is 'N' follow these steps:
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

*   **Programming Language:** Minilang
*   **HC-Specific Considerations:**
    *   The service will always use FIFO for inventory reservation.
    *   The `OrderItem` entity in HC includes the `shipGroupSeqId` field, resulting in a one-to-one relationship between `OrderItem` and `OrderItemShipGroup`.


**Scenario:**

A customer places an order for 1 unit of product "P001" to be shipped from facility "F001". The `requireInventory` flag is set to "Y".

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

The `reserveProductInventory` service is called with the following input parameters:

| Parameter         | Value        |
|------------------|--------------|
| `orderId`        | "O001"       |
| `orderItemSeqId` | "00001"      |
| `productId`      | "P001"       |
| `quantity`       | 1            |
| `facilityId`     | "F001"       |
| `requireInventory` | "Y"          |


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



### Detailed Design: HotWax Commerce `reserveForInventoryItemInline` Function

**Why not implement this in reserveProductInventory?**

*   **Modularity and Reusability:** Separating the logic into a distinct function improves modularity and makes the code more reusable. If there are other services or processes that need to reserve inventory from a specific InventoryItem, they can potentially reuse this function.


**1. Introduction**

*   **Purpose:** This function handles the core logic of reserving non-serialized inventory from a specific `InventoryItem` in HotWax Commerce. It updates the `InventoryItem` record, creates an `InventoryItemDetail` record to log the reservation, and manages scenarios with insufficient inventory.
*   **Scope:** This function is designed for use within the `reserveProductInventory` service in HC, which always uses the FIFO (First-In, First-Out) strategy for inventory allocation.
*   **Reference Implementation:** This design is inspired by the `reserveForInventoryItemInline` function in the OFBiz codebase, but adapted to HC's specific requirements and constraints.

**2. Function Definition**

*   **Function Name:** `reserveForInventoryItemInline`
*   **Input Parameters:**
    *   `inventoryItem`: A `GenericValue` representing the `InventoryItem` from which to reserve inventory.
    *   `quantityNotReserved`: A `BigDecimal` representing the remaining quantity to be reserved.
    *   `requireInventory`: A `String` (Y/N) indicating whether inventory is required for the reservation.
    *   `orderId`: A `String` representing the ID of the order.
    *   `orderItemSeqId`: A `String` representing the sequence ID of the order item.
    *   `shipGroupSeqId`: A `String` representing the sequence ID of the shipment group.
*   **Output Parameters:**
    *   `inventoryItem`: The updated `GenericValue` representing the `InventoryItem`.
    *   `quantityNotReserved`: The updated `BigDecimal` representing the remaining quantity to be reserved.
    *   `lastNonSerInventoryItem`: A `GenericValue` representing the last non-serialized `InventoryItem` processed.

**3. Logic**

*   **Check for Non-Serialized Inventory:**
    *   Verify that the `inventoryItemTypeId` of the input `inventoryItem` is `NON_SERIAL_INV_ITEM`. If not, the function should exit or throw an error, as HC only supports non-serialized inventory.

*   **Check Inventory Availability:**
    *   Ensure that the `InventoryItem` is not on hold or defective (`statusId` is not `INV_ON_HOLD` or `INV_NS_DEFECTIVE` or `INV_DEFECTIVE`).
    *   Verify that the `availableToPromiseTotal` of the `InventoryItem` is greater than 0.

*   **Calculate `deductAmount`:**
    *   Determine the amount to deduct from the `availableToPromiseTotal`, which is the lesser value between `quantityNotReserved` and `availableToPromiseTotal`.

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

*   **Create `OrderItemShipGrpInvRes`:**
    *   Call the `reserveOrderItemInventory` service to create or update an `OrderItemShipGrpInvRes` record. This step might need to be adapted based on how HC handles reservations and the one-to-one relationship between `OrderItem` and `OrderItemShipGroup`.

*   **Update `quantityNotReserved`:**
    *   Reduce the `quantityNotReserved` by the `deductAmount`.

*   **Update `lastNonSerInventoryItem`:**
    *   Store the current `InventoryItem` as the `lastNonSerInventoryItem`. This will be used later in the `reserveProductInventory` service to handle scenarios with insufficient inventory.


**5. HotWax Commerce Considerations**

*   This implementation focuses solely on non-serialized inventory, as that's the only type supported in HC.
*   Ensure that the function integrates seamlessly with the HC data model and any related services or workflows.

