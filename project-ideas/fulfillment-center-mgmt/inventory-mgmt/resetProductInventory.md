# resetProductInventory

```json
{
  "facilityId": "Facility123",
  "externalFacilityId": "Facility123",
  "productId": "Product456",
  "idType": "Order789",
  "idValue": "00001",
  "quantity": 10,
  "varianceReasonId": "VAR_EXT_RESET",
  "partyId": "JOHNDOE", 
  "comments": "ShipmentABC"
}

```

Use this to reset  inventory levels of facility based on feed from external systems. Any other case, we should consider using service designed for the purpose.
The feed coming from external systems will generally have SKU and externalFacilityId, These feeds sometimes happen to have inventory of Products not yet configured at the Facility.
Use [findOrCreateFacilityInventoryItem](findOrCreateFacilityInventoryItem.md) utility service to get `facilityId`, `productId`, `inventoryItemId`

## Workflow

1) inventoryItemId= findOrCreateFacilityInventoryItem().inventoryItemId
2) getInventoryItem(`inventoryItemId`).availableToPromiseTotal
3) atpDiff = quantity - getInventoryItem(`inventoryItemId`).availableToPromiseTotal
4) [createPhysicalInventory](createPhysicalInventory.md)


### NOTE:
We should consider recording InventoryItemVariance for both, +ve and -ve


```xml
    <VarianceReason varianceReasonId="VAR_EXT_RESET" description="Reset by External System"/>
```