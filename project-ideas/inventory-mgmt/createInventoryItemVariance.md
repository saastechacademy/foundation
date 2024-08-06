
# **createInventoryItemVariance**

### Purpose

The `createInventoryItemVariance` service is designed to create a record of a discrepancy between the expected and actual quantity of an inventory item. This discrepancy is known as an inventory variance. It's a crucial part of inventory management, helping businesses track losses, damages, or other unexpected changes in inventory levels.

### Workflow

1.  **Input Validation:** The service begins by validating the input parameters, ensuring they are not empty or null and contain valid data types.  The key input parameters include:
    *   `inventoryItemId`: The ID of the inventory item with the variance.
    *   `varianceReasonId`: The reason for the variance (e.g., DAMAGED, STOLEN).
    *   `varianceDate`: The date when the variance was noticed.
    *   `quantityOnHandVar`: The variance in quantity on hand.
    *   `availableToPromiseVar`: The variance in available-to-promise quantity.

2.  **Check Existing Variance:**
    *   The service checks if a variance record already exists for the given `inventoryItemId`, `varianceReasonId`, and `varianceDate`. If a record exists, it updates the existing record with the new variance quantities.

3.  **Create New Variance:**
    *   If no existing variance record is found, a new `InventoryItemVariance` entity is created with the provided input parameters.

4.  **Update Inventory Item:**
    *   The service updates the corresponding `InventoryItem` record. It adjusts the `quantityOnHand` and `availableToPromise` fields based on the `quantityOnHandVar` and `availableToPromiseVar` values from the input.

5.  **Create Inventory Item Details:**
    *   The service creates `InventoryItemDetail` records to log the changes made to the `quantityOnHand` and `availableToPromise` fields. These records help in tracking the history of inventory adjustments.

6.  **Return Result:**
    *   The service returns a `Map` indicating the success or failure of the operation. If successful, it will include the ID of the created or updated `InventoryItemVariance` record.

### Key Points

*   **Inventory Accuracy:** This service is vital for maintaining accurate inventory records, which is essential for efficient business operations.
*   **Traceability:** The creation of variance and detail records provides a clear audit trail of inventory adjustments, helping to identify patterns or issues.
*   **Integration with Other Services:** This service is often called by other services, such as those related to order fulfillment or inventory adjustments, whenever a variance in inventory is detected.

```
    <simple-method method-name="createInventoryItemVariance" short-description="Create an InventoryItemVariance">

        <!-- add changes to availableToPromise and quantityOnHand -->
        <make-value entity-name="InventoryItem" value-field="inventoryItemLookup"/>
        <set-pk-fields map="parameters" value-field="inventoryItemLookup"/>
        <find-by-primary-key map="inventoryItemLookup" value-field="inventoryItem"/>

        <if-compare field="inventoryItem.inventoryItemTypeId" operator="not-equals" value="NON_SERIAL_INV_ITEM">
            <string-to-list string="Can only create an InventoryItemVariance for a Non-Serialized Inventory Item" list="error_list"/>
        </if-compare>
        <check-errors/>

        <!-- instead of updating InventoryItem, add an InventoryItemDetail -->
        <set from-field="parameters.inventoryItemId" field="createDetailMap.inventoryItemId"/>
        <set from-field="parameters.physicalInventoryId" field="createDetailMap.physicalInventoryId"/>
        <set from-field="parameters.availableToPromiseVar" field="createDetailMap.availableToPromiseDiff"/>
        <set from-field="parameters.quantityOnHandVar" field="createDetailMap.quantityOnHandDiff"/>
        <set from-field="parameters.quantityOnHandVar" field="createDetailMap.accountingQuantityDiff"/>
        <set from-field="parameters.reasonEnumId" field="createDetailMap.reasonEnumId"/>
        <set from-field="parameters.comments" field="createDetailMap.description"/>
        <!-- Added orderId and orderItemSeqId to track from InventoryItemDetail which order item is rejected as this service is called from createPhysicalInventoryAndVariance -->
        <set from-field="parameters.orderId" field="createDetailMap.orderId"/>
        <set from-field="parameters.orderItemSeqId" field="createDetailMap.orderItemSeqId"/>
        <call-service service-name="createInventoryItemDetail" in-map-name="createDetailMap"/>

        <make-value entity-name="InventoryItemVariance" value-field="newEntity"/>
        <set-pk-fields map="parameters" value-field="newEntity"/>
        <set-nonpk-fields map="parameters" value-field="newEntity"/>
        <set field="newEntity.changeByUserLoginId" from="userLogin.userLoginId"/>
        <create-value value-field="newEntity"/>

        <!-- TODO: (possibly a big deal?) check to see if any reserved inventory needs to be changed because of a change in availableToPromise -->
        <!-- TODO: make sure availableToPromise is never greater than the quantityOnHand? -->
    </simple-method>

```

Balance Reservation Order Creation
When this flag is set to "Y", system calls "reassignInventoryReservation" service. This service picks all orders which are not in picklist and cancel their reservations and do new reservations again so that if new order is with priority and desired delivery date is first of all the orders, then current order get highest priority and reservations are made for this orders, releasing reservations of other low priority orders or orders with late delivery date.

Recommendations: In the case of web store this should always set to "Y".
