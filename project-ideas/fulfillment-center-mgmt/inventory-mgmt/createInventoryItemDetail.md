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

## `InventoryItem` Update ATP and QOH on InventoryItemDetail lifecycle events.

* quantityOnHandTotal
* availableToPromiseTotal

```xml
<!-- The InventoryItemDetail entity should never be updated/stored or deleted/removed, but we'll catch those too anyway... -->
<eca entity="InventoryItemDetail" operation="create-store-remove" event="return">
    <action service="updateInventoryItemFromDetail" mode="sync"/>
</eca>
<eca entity="InventoryItemDetail" operation="create-store-remove" event="return">
    <condition field-name="availableToPromiseDiff" operator="not-equals" value="0" type="BigDecimal"/>
    <action service="setLastInventoryCount" mode="sync"/>
</eca>
```

* Similar example from Moqui framework 

```xml
    <!-- AssetDetail should never be updated or deleted, but handle those just in case -->
    <eeca id="AssetDetailUpdateAsset" entity="mantle.product.asset.AssetDetail" on-create="true">
        <!-- NOTE: only runs on-create, AssetDetail records should not be updated or deleted, if they are needs to be supported somehow -->
        <actions><service-call name="mantle.product.AssetServices.update#AssetFromDetail" in-map="context"/></actions>
    </eeca>

```