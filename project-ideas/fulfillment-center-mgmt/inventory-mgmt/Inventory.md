# Design notes Inventory Management Application

### Scope: Manage finished goods and non-serialized inventory items.
* Finished Goods
* Non serialized Inventory
* One InventoryItem per Facility per Product
* statusId is not used
* Do negative reservation if not enough in stock.


  
## The Core Entities Used for Modeling Inventory

* `InventoryItem`

* `InventoryItemType`

* `InventoryItemDetail`

* `ItemIssuance`

* `PhysicalInventory`

* `InventoryItemVariance`

* `VarianceReason`

## InventoryItem and InventoryItemDetail Sample Data

```json
[
  {
    "inventoryItemId": "FG001-INV-001",
    "inventoryItemTypeId": "NON_SERIAL_INV_ITEM",
    "productId": "FG001",
    "statusId": "INV_AVAILABLE",
    "datetimeReceived": "2024-07-10 14:35:00.000",
    "facilityId": "FACILITY_1",
    "locationSeqId": "0001",
    "quantityOnHandTotal": 12,
    "availableToPromiseTotal": 12,
    "unitCost": 10.50,
    "currencyUomId": "USD",
    "inventoryItemDetails": [
      {
        "inventoryItemDetailSeqId": "0001",
        "effectiveDate": "2024-07-10 14:35:00.000",
        "quantityOnHandDiff": 12,
        "availableToPromiseDiff": 12,
        "reasonEnumId": "INV_RECEIPT"
      }
    ]
  },
  {
    "inventoryItemId": "FG001-INV-002",
    "inventoryItemTypeId": "NON_SERIAL_INV_ITEM",
    "productId": "FG001",
    "statusId": "INV_AVAILABLE",
    "datetimeReceived": "2024-07-12 11:10:00.000",
    "facilityId": "FACILITY_1",
    "locationSeqId": "0005",
    "quantityOnHandTotal": 18,
    "availableToPromiseTotal": 18,
    "unitCost": 10.50,
    "currencyUomId": "USD",
    "inventoryItemDetails": [
      {
        "inventoryItemDetailSeqId": "0001",
        "effectiveDate": "2024-07-12 11:10:00.000",
        "quantityOnHandDiff": 18,
        "availableToPromiseDiff": 18,
        "reasonEnumId": "INV_RECEIPT"
      }
    ]
  },
  {
    "inventoryItemId": "FG002-INV-001",
    "inventoryItemTypeId": "NON_SERIAL_INV_ITEM",
    "productId": "FG002",
    "statusId": "INV_AVAILABLE",
    "datetimeReceived": "2024-07-08 09:22:00.000",
    "facilityId": "FACILITY_1",
    "locationSeqId": "0003",
    "quantityOnHandTotal": 22,
    "availableToPromiseTotal": 22,
    "unitCost": 12.00,
    "currencyUomId": "USD",
    "inventoryItemDetails": [
      {
        "inventoryItemDetailSeqId": "0001",
        "effectiveDate": "2024-07-08 09:22:00.000",
        "quantityOnHandDiff": 22,
        "availableToPromiseDiff": 22,
        "reasonEnumId": "INV_RECEIPT"
      }
    ]
  },
  {
    "inventoryItemId": "FG002-INV-002",
    "inventoryItemTypeId": "NON_SERIAL_INV_ITEM",
    "productId": "FG002",
    "statusId": "INV_AVAILABLE",
    "datetimeReceived": "2024-07-11 15:55:00.000",
    "facilityId": "FACILITY_1",
    "locationSeqId": "0007",
    "quantityOnHandTotal": 11,
    "availableToPromiseTotal": 11,
    "unitCost": 12.00,
    "currencyUomId": "USD",
    "inventoryItemDetails": [
      {
        "inventoryItemDetailSeqId": "0001",
        "effectiveDate": "2024-07-11 15:55:00.000",
        "quantityOnHandDiff": 11,
        "availableToPromiseDiff": 11,
        "reasonEnumId": "INV_RECEIPT"
      }
    ]
  },
  {
    "inventoryItemId": "FG003-INV-001",
    "inventoryItemTypeId": "NON_SERIAL_INV_ITEM",
    "productId": "FG003",
    "statusId": "INV_AVAILABLE",
    "datetimeReceived": "2024-07-09 12:45:00.000",
    "facilityId": "FACILITY_1",
    "locationSeqId": "0002",
    "quantityOnHandTotal": 35,
    "availableToPromiseTotal": 35,
    "unitCost": 8.75,
    "currencyUomId": "USD",
    "inventoryItemDetails": [
      {
        "inventoryItemDetailSeqId": "0001",
        "effectiveDate": "2024-07-09 12:45:00.000",
        "quantityOnHandDiff": 35,
        "availableToPromiseDiff": 35,
        "reasonEnumId": "INV_RECEIPT"
      }
    ]
  },
  {
    "inventoryItemId": "FG003-INV-002",
    "inventoryItemTypeId": "NON_SERIAL_INV_ITEM",
    "productId": "FG003",
    "statusId": "INV_AVAILABLE",
    "datetimeReceived": "2024-07-13 16:20:00.000",
    "facilityId": "FACILITY_1",
    "locationSeqId": "0006",
    "quantityOnHandTotal": 27,
    "availableToPromiseTotal": 27,
    "unitCost": 8.75,
    "currencyUomId": "USD",
    "inventoryItemDetails": [
      {
        "inventoryItemDetailSeqId": "0001",
        "effectiveDate": "2024-07-13 16:20:00.000",
        "quantityOnHandDiff": 27,
        "availableToPromiseDiff": 27,
        "reasonEnumId": "INV_RECEIPT"
      }
    ]
  }
]
```

## Explanation

*   This JSON data provides sample records for the `InventoryItem` and `InventoryItemDetail` entities, building upon the previously established product and facility data.
*   Each `InventoryItem` represents a specific instance of a product ("FG001", "FG002", "FG003") at a particular location within the facility ("FACILITY\_1").
*   The `inventoryItemTypeId` is set to "NON\_SERIAL\_INV\_ITEM," indicating that these items are not tracked individually by serial numbers.
*   The `statusId` "INV\_AVAILABLE" means the items are currently available in inventory.
*   The `quantityOnHandTotal` and `availableToPromiseTotal` fields reflect the initial quantities received.
*   The `unitCost` and `currencyUomId` specify the cost per unit and the currency.
*   Each `inventoryItem` has an `inventoryItemDetails` array, which in this case contains a single record representing the initial receipt of the inventory.
    *   The `quantityOnHandDiff` and `availableToPromiseDiff` fields in the detail record match the total quantities, indicating the entire amount was received at once.
    *   The `reasonEnumId` "INV\_RECEIPT" signifies that this detail is related to receiving inventory.
    *   The `effectiveDate` is the timestamp when the inventory was received.

The `PhysicalInventory` and `InventoryItemVariance` entities work together to manage and track discrepancies in inventory levels during physical inventory counts, with the `VarianceReason` entity providing context for those discrepancies.

### PhysicalInventory

*   Represents a specific physical inventory count event.
*   Key attributes:
    *   `physicalInventoryId` (Primary Key): Unique identifier for the inventory count.
    *   `physicalInventoryDate`: Date and time of the count.
    *   `partyId`: The person responsible for conducting the count.
    *   `generalComments`: General notes or observations about the count.

### InventoryItemVariance

*   Represents a discrepancy found for a specific inventory item during a physical inventory count.
*   Key attributes:
    *   `inventoryItemId` (Primary Key): The ID of the inventory item with the variance.
    *   `physicalInventoryId` (Primary Key): The ID of the associated physical inventory count.
    *   `varianceReasonId`: The reason for the variance, referencing the `VarianceReason` entity.
    *   `availableToPromiseVar`: The difference between the expected and actual available-to-promise (ATP) quantity.
    *   `quantityOnHandVar`: The difference between the expected and actual quantity on hand (QOH).
    *   `comments`: Additional notes about the variance.

### VarianceReason

*   Provides predefined reasons for inventory variances.
*   Key attributes:
    *   `varianceReasonId` (Primary Key): Unique identifier for the variance reason.
    *   `description`: Description of the reason.

*   **Sample Data:**
    *   "VAR\_LOST": Lost
    *   "VAR\_STOLEN": Stolen
    *   "VAR\_FOUND": Found
    *   "VAR\_DAMAGED": Damaged
    *   "VAR\_INTEGR": Integration (e.g., discrepancies due to system integration issues)
    *   "VAR\_SAMPLE": Sample (Giveaway)
    *   "VAR\_MISSHIP\_ORDERED": Mis-shipped Item Ordered (+)
    *   "VAR\_MISSHIP\_SHIPPED": Mis-shipped Item Shipped (-)

## How They Work Together

1.  **Physical Inventory Count:** A `PhysicalInventory` record is created to document the count.
2.  **Variance Discovery:** If a discrepancy is found for an item, an `InventoryItemVariance` record is created, linked to the `PhysicalInventory` and the specific `InventoryItem`.
3.  **Reason Assignment:** The `varianceReasonId` in the `InventoryItemVariance` record is set to the appropriate reason from the `VarianceReason` entity.
4.  **Variance Recording:** The `availableToPromiseVar` and `quantityOnHandVar` fields are populated with the differences in ATP and QOH quantities, respectively.
5.  **Analysis and Action:** The variances are analyzed to identify patterns and trends. Corrective actions are taken based on the variance reasons (e.g., security measures for theft, improved handling for damage).

## Sample data

```json
{
  "physicalInventoryId": "PI_20240715",
  "physicalInventoryDate": "2024-07-15 10:00:00",
  "partyId": "PARTY_EMPLOYEE_JOHN_DOE",
  "generalComments": "Routine inventory count at Main Street Store",
  "inventoryItemVariances": [
    {
      "inventoryItemId": "FG001-INV-001",
      "physicalInventoryId": "PI_20240715",
      "varianceReasonId": "VAR_FOUND",
      "availableToPromiseVar": 1,
      "quantityOnHandVar": 1,
      "comments": "Found one extra unit on shelf"
    },
    {
      "inventoryItemId": "FG002-INV-002",
      "physicalInventoryId": "PI_20240715",
      "varianceReasonId": "VAR_DAMAGED",
      "availableToPromiseVar": -2,
      "quantityOnHandVar": -2,
      "comments": "Two units damaged during shipping"
    }
  ]
}
```
## Business can create InventoryItem for a Product and create placeholder record in ProductFacility

[findOrCreateFacilityInventoryItem](findOrCreateFacilityInventoryItem.md)

* Facility
* FacilityLocation
* ProductFacility
* ProductFacilityLocation
* InventoryItem
* InventoryItemDetail
* PhysicalInventory
* InventoryItemVariance
* PhysicalInventoryAndVariance
* InventoryTransfer

```xml
    <EnumerationType description="Inventory Item Detail Reason" enumTypeId="IID_REASON" hasTable="N" />
    <Enumeration enumId='CYCLE_COUNT' enumName='Cycle count' description='Cycle count' enumCode='CYCLE_COUNT' sequenceId='09' enumTypeId='IID_REASON'/>
    <Enumeration enumId='POS_SALE' enumName='POS Sale' description='POS Sale' enumCode='POS_SALE' sequenceId='20' enumTypeId='IID_REASON'/>
    <Enumeration enumId='VAR_DAMAGED' enumName='Damaged' description='Damaged' enumCode='VAR_DAMAGED' sequenceId='04' enumTypeId='IID_REASON'/>
    <Enumeration enumId='VAR_FOUND' enumName='Found' description='Found' enumCode='VAR_FOUND' sequenceId='03' enumTypeId='IID_REASON'/>
    <Enumeration enumId='VAR_INTEGR' enumName='Integration' description='Integration' enumCode='VAR_INTEGR' sequenceId='06' enumTypeId='IID_REASON'/>
    <Enumeration enumId='VAR_LOST' enumName='Adjustment' description='Adjustment' enumCode='VAR_LOST' sequenceId='01' enumTypeId='IID_REASON'/>
    <Enumeration enumId='VAR_MANUAL' enumName='Variance recorded manually' description='Variance recorded manually' enumCode='VAR_MANUAL' sequenceId='21' enumTypeId='IID_REASON'/>
    <Enumeration enumId='VAR_MISSHIP_ORDERED' enumName='Mis-shipped Item Ordered' description='Mis-shipped Item Ordered (+)' enumCode='VAR_MISSHIP_ORDERED' sequenceId='07' enumTypeId='IID_REASON'/>
    <Enumeration enumId='VAR_MISSHIP_SHIPPED' enumName='Mis-shipped Item Shipped' description='Mis-shipped Item Shipped (-)' enumCode='VAR_MISSHIP_SHIPPED' sequenceId='08' enumTypeId='IID_REASON'/>
    <Enumeration enumId='VAR_SAMPLE' enumName='Sample (Giveaway)' description='Sample (Giveaway)' enumCode='VAR_SAMPLE' sequenceId='05' enumTypeId='IID_REASON'/>
    <Enumeration enumId='VAR_STOLEN' enumName='Stolen' description='Stolen' enumCode='VAR_STOLEN' sequenceId='02' enumTypeId='IID_REASON'/>
    <Enumeration description="Scheduled Incoming Shipment Received" enumCode="VAR_SCH_SHIP_RECV" enumId="VAR_SCH_SHIP_RECV" enumTypeId="IID_REASON" enumName="Scheduled Shipment Received"/>
    <Enumeration description="Incoming Shipment Received" enumCode="VAR_SHIP_RECV" enumId="VAR_SHIP_RECV" enumTypeId="IID_REASON" enumName="Shipment Received"/>
    <Enumeration description="Reset by External System" enumCode="VAR_EXT_RESET" enumId="VAR_EXT_RESET" enumTypeId="IID_REASON" enumName="Reset By External System"/>
    <Enumeration description="Transfer Order Shipped" enumCode="VAR_TRFR_ORD_SHIPPED" enumId="VAR_TRFR_ORD_SHIPPED" enumTypeId="IID_REASON" enumName="TO Shipment Shipped"/>

```