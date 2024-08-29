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

**1. `REPORT_AN_ISSUE` Enumeration Type**

This type encompasses reasons for reporting inventory issues, which may or may not involve actual inventory adjustments. It has two subtypes:

*   **`REPORT_ALL_VAR`**: Reasons under this type trigger a variance log for the **entire available quantity** of the product at the specified facility. The `NOT_IN_STOCK` reason falls under this category.
*   **`REPORT_VAR`**: Reasons in this type lead to a variance log for a **specific quantity** mentioned in the adjustment request. This includes reasons like `WORN_DISPLAY`, `DAMAGED`, and `MISMATCH`.

**2. `RPRT_NO_VAR_LOG` Enumeration Type**

This type includes reasons for reporting issues that **do not require any variance logging**, even if there's a discrepancy in inventory levels. It has one subtype:

*   **`REPORT_NO_VAR`**: Reasons under this type explicitly indicate that no variance reason should be recorded. This covers `INACTIVE_STORE` and `NO_VARIANCE_LOG`.

**How `recordVariance` and `reasonEnumId` Work Together**

*   When `recordVariance` is set to "Y" (Yes) and the `reasonEnumId` belongs to `REPORT_ALL_VAR`, the system calculates the variance quantity based on the **entire available quantity** of the product at the facility.
*   If `recordVariance` is "Y" and the `reasonEnumId` is under `REPORT_VAR`, the variance quantity is determined by the **specific quantity** mentioned in the adjustment request.
*   If `recordVariance` is "Y" but the `reasonEnumId` falls under `REPORT_NO_VAR`, **no variance is recorded**, regardless of any quantity discrepancies.
*   If `recordVariance` is "N" (No), **no variance is logged** at all, irrespective of the `reasonEnumId`.

**Example Scenarios**

*   **Scenario 1: `recordVariance = "Y"`, `reasonEnumId = "NOT_IN_STOCK"`**
    *   The entire available quantity of the product at the facility will be adjusted, and a variance record will be created with the reason "Not in Stock."

*   **Scenario 2: `recordVariance = "Y"`, `reasonEnumId = "DAMAGED"`, `quantity = 5`**
    *   The inventory will be adjusted by 5 units, and a variance record will be created with the reason "Damaged."

*   **Scenario 3: `recordVariance = "Y"`, `reasonEnumId = "INACTIVE_STORE"`**
    *   Even if there's an inventory discrepancy, no variance will be recorded because the reason is "Inactive store."

*   **Scenario 4: `recordVariance = "N"`, `reasonEnumId = "MISMATCH"`**
    *   No variance will be logged, even though the reason suggests a potential discrepancy, because `recordVariance` is set to "N."

```
    <!-- Rejection reason -->
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
