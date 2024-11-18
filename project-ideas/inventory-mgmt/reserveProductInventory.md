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
    