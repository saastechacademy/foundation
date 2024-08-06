## Record Variance Service Notes

### Purpose

*   Accurately record inventory variances (discrepancies) when order items are rejected.
*   Provide a detailed history of adjustments for auditing and analysis.

### Inputs

*   `orderId` (String): The ID of the order containing the rejected item.
*   `orderItemSeqId` (String): The sequence ID of the rejected order item.
*   `facilityId` (String): The ID of the facility where the rejection occurred.
*   `rejectReason` (String): The reason for the rejection (enum ID).
*   `rejectComments` (String, optional): Additional comments about the rejection.

### Outputs

*   `success` (Boolean): Indicates whether the variance recording was successful.
*   `errorMessage` (String, optional): Provides details about any errors encountered.

### Core Logic

1.  **Determine Variance Quantity:**
    *   Fetch the `Enumeration` record for `rejectReason`.
    *   **Switch (rejectReason.enumTypeId):**
        *   **`REPORT_ALL_VAR`:**
            *   Fetch `lastInventoryCount` from `ProductFacility` for the product and facility.
            *   Use this as the total variance quantity.
        *   **`REPORT_VAR`:**
            *   Use the rejected `quantity` from the input as the variance quantity.
        *   **`REPORT_NO_VAR`:**
            *   No variance needs to be recorded, return success.

2.  **Fetch Available Inventory:**
    *   Query `InventoryItemAndLocation` for available inventory:
        *   Filter by `productId`, `facilityId`, `statusId` (available, returned).
        *   Ensure `availableToPromiseTotal` is greater than zero.
        *   Order by `datetimeReceived` (oldest first).

3.  **Create Variance Records:**
    *   **For each inventory item:**
        *   Calculate the variance quantity to apply (consider remaining variance for `REPORT_ALL_VAR`).
        *   Create a `PhysicalInventoryAndVariance` record:
            *   Set `inventoryItemId`, `reasonEnumId`, `comments`.
            *   Set `availableToPromiseVar` to the negative of the variance quantity.
            *   **If applicable (damaged items):**
                *   Set `quantityOnHandVar` according to business rules.
                *   Update `quantityOnHand` in `InventoryItem`.
            *   Set `orderId` and `orderItemSeqId`.
        *   If the total variance is accounted for, break the loop.

### Additional Considerations

*   **Transaction Management:** Wrap the entire operation in a transaction to ensure data consistency.
*   **Concurrency:** Consider potential concurrency issues if multiple users reject items simultaneously.
*   **Performance:** For large inventories, optimize the fetching of available inventory.
*   **Customization:** Allow for configuration of:
    *   Which `rejectReason` types trigger variance recording.
    *   Specific logic for handling damaged items and updating `quantityOnHand`.
*   **Logging:** Implement detailed logging for debugging and auditing.

## Code Structure (Enhancements)

```java
Map<String, Object> recordVariance(DispatchContext dctx, Map<String, Object> context) {
    // ... (Input parameter handling)

    // 1. Determine Variance Quantity (as described above)

    // 2. Fetch Available Inventory (as described above)

    // 3. Create Variance Records (with enhanced logic as described above)

    // 4. Error Handling (with robust logging)

    return ServiceUtil.returnSuccess(); // or ServiceUtil.returnError() with message
}
```
