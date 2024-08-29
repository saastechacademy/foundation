## createPhysicalInventoryAndVariance

The `createPhysicalInventoryAndVariance` service in the Apache OFBiz framework is designed to record discrepancies between the expected and actual inventory levels of a product at a particular facility. This discrepancy is known as an inventory variance.

### Purpose

The primary goal of this service is to create a physical inventory count record and, if necessary, an associated variance record to track adjustments to inventory levels. This is crucial for maintaining accurate inventory records and identifying potential issues like theft, damage, or errors in previous counts.

### Workflow

1.  **Input Validation:** The service validates the input parameters, including:
    *   `inventoryItemId`: The ID of the inventory item being adjusted.
    *   `physicalInventoryDate`: The date of the physical inventory count.
    *   `quantityOnHandVar`: The variance in the quantity on hand (can be positive or negative).
    *   `availableToPromiseVar`: The variance in the available-to-promise quantity (can be positive or negative).
    *   `reasonEnumId`: The reason for the variance (e.g., damaged, found, lost).
    *   `comments`: Additional comments about the variance.

2.  **Create Physical Inventory:**
    *   If a physical inventory record for the given `inventoryItemId` and `physicalInventoryDate` doesn't exist, the service creates one.
    *   The physical inventory record stores the current `quantityOnHand` and `availableToPromise` values from the `InventoryItem` entity.

3.  **Create Variance (If Applicable):**
    *   If either `quantityOnHandVar` or `availableToPromiseVar` is not zero, it indicates a variance.
    *   The service creates an `InventoryItemVariance` record to track the variance details, including the reason and comments.

4.  **Update Inventory Item:**
    *   The service updates the `InventoryItem` entity with the new `quantityOnHand` and `availableToPromise` values, reflecting the adjustments made due to the variance.

5.  **Success or Error:**
    *   If all operations are successful, the service returns a success message.
    *   If any errors occur during the process (e.g., invalid input, database issues), the service returns an error message.

### Key Points

*   **Inventory Accuracy:** This service is essential for maintaining accurate inventory records by documenting and correcting discrepancies.
*   **Traceability:** The variance records provide a history of adjustments, helping to identify trends or patterns in inventory discrepancies.
*   **Integration:** The service is often called from other services (like `rejectOrderItem`) when inventory adjustments are needed due to specific events.

```
    <!-- Overrided service createPhysicalInventoryAndVariance to set default physicalInventoryDate & partyId. This is done to avoid passing these fields from all the occurrences of createPhysicalInventoryAndVariance service. Adding this implementaion as can not assign nowtimestamp in default-value in definition -->
    <simple-method method-name="createPhysicalInventoryAndVariance" short-description="Create a PhysicalInventory and an InventoryItemVariance">
        <set-service-fields service-name="createPhysicalInventory" map="parameters" to-map="createPhysicalInventoryMap"/>
        <if-empty field="createPhysicalInventoryMap.physicalInventoryDate">
            <now-timestamp field="nowtimestamp"/>
            <set field="createPhysicalInventoryMap.physicalInventoryDate" from="nowtimestamp" />
        </if-empty>
        <if-empty field="createPhysicalInventoryMap.partyId">
            <set field="createPhysicalInventoryMap.partyId" from="userLogin.partyId" />
        </if-empty>
        <call-service service-name="createPhysicalInventory" in-map-name="createPhysicalInventoryMap">
            <result-to-field result-name="physicalInventoryId" field="parameters.physicalInventoryId"/>
            <result-to-result result-name="physicalInventoryId" service-result-name="physicalInventoryId"/>
        </call-service>
        <set-service-fields service-name="createInventoryItemVariance" map="parameters" to-map="createInventoryItemVarianceMap"/>
        <call-service service-name="createInventoryItemVariance" in-map-name="createInventoryItemVarianceMap"/>
    </simple-method>
```
