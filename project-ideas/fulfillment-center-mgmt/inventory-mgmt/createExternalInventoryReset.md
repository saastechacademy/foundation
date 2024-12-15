# createExternalInventoryReset


```json
    {
      "resetDateResourceId": "RDR12345",
      "externalFacilityId": "EXTFAC4321",
      "productIdentType": "SKU",
      "productIdentValue": "SKU-001-A",
      "externalATP": 150,
      "externalQOH": 180,
      "unitCost": 12.5
    }
```

## Workflow:

* use externalFacilityId, productIdentType, productIdentValue to [findOrCreateFacilityInventoryItem](findOrCreateFacilityInventoryItem.md)
* look up InventoryItem for the product at the facility.
* Compare ATP and QOH at facility with the external inventory to compute quantityOnHandDiff, availableToPromiseDiff. 
* Prepare following data and save it in the database.
* On successful processing of input data, create InventoryItemDetail record.
* In case of any issues in ProductFacility lookup or InventoryItem lookup, Save the input data as is in the database. 

```json
    {
      "facilityId": "FAC1001",
      "productId": "PROD56789",
      "externalFacilityId": "EXTFAC4321",
      "productIdentType": "SKU",
      "productIdentValue": "SKU-001-A",
      "inventoryItemId": "INV789012",
      "externalATP": 150,
      "externalQOH": 180,
      "quantityOnHandDiff": -30,
      "availableToPromiseDiff": -20,
      "unitCost": 12.5
    }

```