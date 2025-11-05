### Requirements

* [Business story](./business-story.md)
* [Manager Needs for Directed Cycle Count](./manager-needs-directed-cycle-count.md)
* [Entities and Workflows](./entities-and-workflows.md)
* [Apply count to Inventory](./apply-count-to-inventory.md)
* [Directed Cycle Count](./directed-cycle-count-story.md)
* [Session Locking](inventory_count_locking_design.md)

### PWA Design notes

* [Product Master](./product-master.md)
* [InventoryCountRun](useInventoryCountRun-composable.md)
* [InventoryCountImport composable](./inventory-count-composable.md)
* [Sync count items](./sync-inventory-count-import-item.md)
* [PK Generation for — Strategy for InventoryCountImportItem](./pk-generation-strategy.md)
* [Web Workers, Comlink, Vite](https://johnnyreilly.com/web-workers-comlink-vite-tanstack-query)

### Additional References
* [Inventory Data Model ](../../oms/Inventory.md)
* [Inventory Management proess](../inventory-mgmt/inventoryManagementProcess.md)
* [Physical Inventory](../../oms/createPhysicalInventory.md)


### Workflows

#### Cycle Count Workflow
Cycle count session is assigned to a user. User scans items, app records scan events. Background process periodically pushes updates to server. User completes the count; final push succeeds.


#### Create InventoryCountImport
The planned cycle count task is assigned to Store Manager user. The store manager creates an `InventoryCountImport` record to start a new inventory count session. This record includes metadata such as the store location, assigned user, and start time.
The manager may create one or more `InventoryCountImport` records for the same `WorkEffort` if multiple users will be performing the count in parallel.

