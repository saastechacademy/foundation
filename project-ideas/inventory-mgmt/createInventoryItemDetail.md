# **createInventoryItemDetail** 
The `createInventoryItemDetail` record detailed adjustments to the inventory of a specific `InventoryItem`. It captures the reasons for these changes, providing a historical record of inventory movements.


**`InventoryItemDetail` Entity**

**Use Cases and Scenarios**

The `createInventoryItemDetail`:


**Example use case**

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

We don't have use case for PUT, DELETE on this Entity