# create#ExternalInventoryReset


```json
{
  "resetDateResourceId": "RDR12345",
  "facilityId": "FAC1001",
  "productId": "PROD56789",
  "externalFacilityId": "EXTFAC4321",
  "productIdentType": "SKU",
  "productIdentValue": "SKU-001-A",

  "inventoryItemId": "INV789012",
  "inventoryItemQOH": 200,
  "inventoryItemATP": 180,

  "externalQOH": 180,
  "externalATP": 150,

  "quantityOnHandDiff": -20,
  "availableToPromiseDiff": -30,
  "unitCost": 12.5
}
```

## Workflow:

* On successful processing of input data, create InventoryItemDetail record.
