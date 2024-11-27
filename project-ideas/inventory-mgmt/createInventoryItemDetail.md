# **createInventoryItemDetail** 
The `createInventoryItemDetail` record detailed adjustments to the inventory of a specific `InventoryItem`. It captures the reasons for these changes, providing a historical record of inventory movements.


**`InventoryItemDetail` Entity**

*   `inventoryItemId`: The ID of the inventory item being adjusted.
*   `inventoryItemDetailSeqId`: A unique sequence ID for each adjustment made to the inventory item.
*   `effectiveDate`: The date and time when the adjustment takes effect.
*   `quantityOnHandDiff`: The change in the quantity on hand due to the adjustment.
*   `availableToPromiseDiff`: The change in the available-to-promise (ATP) quantity.
*   `accountingQuantityDiff`: The change in the accounting quantity.
*   `unitCost`: The unit cost associated with the adjustment.
*   `reasonEnumId`: An enumeration ID specifying the reason for the adjustment (e.g., damaged, lost, found).

**Use Cases and Scenarios**

The `createInventoryItemDetail`:

1.  **Inventory Variance Adjustments:**
    *   When there's a discrepancy between the physical inventory count and the system's recorded quantity, this service is used to log the variance. The `reasonEnumId` would indicate the nature of the variance (e.g., "VAR_LOST" for lost items, "VAR_FOUND" for found items).

2.  **Inventory Transfers:**
    *   During inventory transfers between locations, this service records the quantity changes at both the source and destination locations.


4.  **Integration with External Systems:**
    *   When integrating with external inventory management systems, this service can be used to synchronize inventory changes between OMS and the external system. The `reasonEnumId` "VAR_INTEGR" is often used in this context.

**Example**

If 5 units of a product are found to be damaged during a warehouse inspection, the following service call might be made:

```
dispatcher.runSync("createInventoryItemDetail", UtilMisc.toMap(
    "inventoryItemId": "12345",
    "quantityOnHandDiff": -5,
    "availableToPromiseDiff": -5,
    "reasonEnumId": "VAR_DAMAGED",
    "userLogin": userLogin
));
```

This would create a new `InventoryItemDetail` record, decreasing both the quantity on hand and ATP by 5, with the reason "Damaged."
