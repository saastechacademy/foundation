# ExternalInventoryReset"

Fields:
* resetItemId PK (sequence)
* resetDateResourceId
* faclityId
* productId
* externalFacilityId
* productIdentType
* productIdentValue
* inventoryItemId
* inventoryItemATP
* inventoryItemQOH
* externalATP
* externalQOH
* unitCost

Foreign key:
* add resetItemId attribute to InventoryItemDetail entity.

We want to be able to trace back the business event that caused Inventory movement.

Following entities do good job of tracking incoming and outgoing shipment
1) ShipmentReceipt
2) ItemIssuance
3) PhysicalInventory + InventoryItemVariance capture the Physical cycle count.


4) ExternalInventoryReset is to track the process of OMS sync with the Inventory Master (ERP).
