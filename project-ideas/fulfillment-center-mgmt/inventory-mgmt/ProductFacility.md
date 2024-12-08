# ProductFacility

One InventoryItem per Product per Facility.

### As Is,
OMS is programmed such that we should have One InventoryItem per Product per Facility. This also means, ATP on ProductFacility should be same as ATP on the one and only InventoryItem per product per facility.

Before we moved to one InventoryItem per Facility per Product, To avoid computation of ATP/QOH on Inventory availability lookup calls, We added lastInventoryCount and computedInventoryCount fields to ProductFacility entity. Having ATP on ProductFacility made it faster and easier to get Product ATP at given Facility.

### What is the problem with creating new InventoryItem on Inventory receipt, like in OFBiz?
*   On inventory receiving we create new inventory item. To get product inventory atop/qoh system will have to sum up all the inventory items for product.
*   Use single inventory item per product, facility, and facility location to avoid atp/qoh calculation



### Refactoring proposal
* Extend ProductFacility entity, add field, InventoryItemId to ProductFacility entity, 
* Stop maintaining LastInventoryCount on ProductFacility. 
* Create a view entity "ProductFacilityInventoryItem" on InventoryItem and ProductFacility. On the view add two fields
* InventoryItem.ATP AS ProductFacilityInventoryItem.lastInventoryCount
* (InventoryItem.ATP - ProductFacility.MinimumStock) AS ProductFacilityInventoryItem.computedInventoryCount
