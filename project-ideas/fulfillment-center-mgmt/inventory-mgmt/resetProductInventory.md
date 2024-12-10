# resetProductInventory

```json
{
  "externalFacilityId": "Facility123",
  "idType": "SKU",
  "idValue": "UKS00001",
  "quantity": 10,
  "varianceReasonId": "VAR_EXT_RESET",
  "partyId": "JOHNDOE", 
  "comments": "Manhattan updating you"
}

```

Use this to reset  inventory levels of Product at given facility based on feed from external systems. Any other case, we should consider using service designed for the purpose.
The feed coming from external systems will generally have SKU and externalFacilityId, These feeds sometimes happen to have inventory of Products not yet configured at the Facility.
Use [findOrCreateFacilityInventoryItem](findOrCreateFacilityInventoryItem.md) utility service to get `facilityId`, `productId`, `inventoryItemId`

## Workflow

1) inventoryItemId= findOrCreateFacilityInventoryItem().inventoryItemId
2) getInventoryItem(`inventoryItemId`).availableToPromiseTotal
3) atpDiff = quantity - getInventoryItem(`inventoryItemId`).availableToPromiseTotal
4) [createPhysicalInventory](createPhysicalInventory.md)

### Example call to createPhysicalInventory

```json
{
  "physicalInventoryDate": "2024-11-20T10:00:00",
  "partyId": "JOHNDOE",
  "generalComments": "Manhattan updating you",
  "inventoryItemVariances": [
    {
      "inventoryItemId": "Inventory456",
      "quantityOnHandVar": 5,
      "varianceReasonId": "VAR_EXT_RESET",
      "inventoryItemDetail": {
        "quantityOnHandDiff": 5,
        "availableToPromiseDiff": 5,
        "reasonEnumId": "VAR_EXT_RESET"
      }
    }
  ]
}
```




### NOTE:
We should consider recording InventoryItemVariance for both, +ve and -ve


```xml
    <VarianceReason varianceReasonId="VAR_EXT_RESET" description="Reset by External System"/>
```