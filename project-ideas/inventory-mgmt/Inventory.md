# API Design for Inventory Management Application in Apache OFBiz
  
## The Core Entities Used for Modeling Inventory

### InventoryItem
Represents a specific item in inventory, tracking its quantity, location, status, and other details.
- **inventoryItemId** (Primary Key): Unique identifier for the inventory item.
- **inventoryItemTypeId:** Type of inventory item (e.g., raw material, finished good).
- **productId:** The product associated with the inventory item.
- **statusId:** Current status of the inventory item (e.g., available, on hold).
- **facilityId:** The facility where the item is located.
- **locationSeqId:** The specific location within the facility.
- **lotId:** The lot or batch the item belongs to.
- **quantityOnHandTotal:** Total quantity of the item on hand.
- **availableToPromiseTotal:** Quantity available for reservation or sale.
- **accountingQuantityTotal:** Quantity used for accounting purposes.
- **unitCost:** Cost per unit of the item.
- **currencyUomId:** Currency of the unit cost.

### InventoryItemType
Defines different types of inventory items.
- **inventoryItemTypeId** (Primary Key): Unique identifier for the inventory item type.
- **parentTypeId:** Allows for hierarchical categorization of item types.
- **description:** Description of the item type.

### InventoryItemDetail
Records changes in inventory item quantities and other details over time.
- **inventoryItemId** (Primary Key): References the associated inventory item.
- **inventoryItemDetailSeqId** (Primary Key): Unique sequence ID for each detail record.
- **effectiveDate:** Date and time when the change occurred.
- **quantityOnHandDiff, availableToPromiseDiff, accountingQuantityDiff:** Changes in quantities.
- **reasonEnumId:** Reason for the change (e.g., sale, adjustment).

### ItemIssuance
Represents the issuance of inventory items for various purposes (e.g., production, shipment).
- **itemIssuanceId** (Primary Key): Unique identifier for the issuance.
- **inventoryItemId:** The inventory item being issued.
- **quantity:** Quantity issued.

### InventoryItemVariance
Tracks discrepancies between expected and actual inventory quantities during physical inventory counts.
- **inventoryItemId** (Primary Key): References the associated inventory item.
- **physicalInventoryId** (Primary Key): References the physical inventory count.
- **varianceReasonId:** Reason for the variance.
- **availableToPromiseVar, quantityOnHandVar:** Variance amounts.

### PhysicalInventory
Represents a physical inventory count event.
- **physicalInventoryId** (Primary Key): Unique identifier for the count.
- **physicalInventoryDate:** Date of the count.

### VarianceReason
Provides reasons for inventory variances.
- **varianceReasonId** (Primary Key): Unique identifier for the reason.
- **description:** Description of the reason.

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

## Business Requirement Fulfillment

*   **Accurate Inventory Records:** Identifying and correcting variances ensures accurate inventory data.
*   **Loss Prevention and Root Cause Analysis:** Variance reasons help pinpoint the causes of discrepancies, enabling targeted loss prevention measures.
*   **Operational Efficiency:** Accurate inventory data supports efficient operations like order fulfillment and production planning.
*   **Financial Reporting:** Reliable inventory data is essential for accurate financial reports.

By leveraging these entities and their relationships, businesses can effectively manage inventory discrepancies, improve accuracy, and optimize inventory processes. The `VarianceReason` entity adds valuable context to variances, facilitating informed decision-making and targeted actions to address inventory issues.

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

## Explanation

*   **`physicalInventoryId`:** A unique identifier for this specific inventory count event (PI\_20240715).
*   **`physicalInventoryDate`:** The date and time the inventory count was conducted (2024-07-15 10:00:00).
*   **`partyId`:** The ID of the employee who performed the count ("PARTY\_EMPLOYEE\_JOHN\_DOE").
*   **`generalComments`:** A brief note about the inventory count ("Routine inventory count at Main Street Store").
*   **`inventoryItemVariances`:** An array containing the variances found during the count.
    *   **First Variance:**
        *   **`inventoryItemId`:** "FG001-INV-001" (one of the inventory items for Product 1).
        *   **`varianceReasonId`:** "VAR\_FOUND" (the reason for the variance).
        *   **`availableToPromiseVar`:** 1 (one extra unit was found).
        *   **`quantityOnHandVar`:** 1 (the on-hand quantity also increased by one).
        *   **`comments`:** "Found one extra unit on shelf" (additional details about the variance).
    *   **Second Variance:**
        *   **`inventoryItemId`:** "FG002-INV-002" (one of the inventory items for Product 2).
        *   **`varianceReasonId`:** "VAR\_DAMAGED" (two units were damaged).
        *   **`availableToPromiseVar`:** -2 (two units are no longer available).
        *   **`quantityOnHandVar`:** -2 (the on-hand quantity decreased by two).
        *   **`comments`:** "Two units damaged during shipping" (additional details about the variance).


### Workflow

1.  **Fetch Shipment Details:** The service retrieves the shipment record from the database using the provided `shipmentId`.

2.  **Fetch Order Item Ship Group:** It retrieves the associated `OrderItemShipGroup` record to determine the original `carrierPartyId` (the carrier responsible for the shipment) and `shipmentMethodTypeId` (the method of shipment).

3.  **Update Shipment:**
    *   The shipment's `statusId` is changed to `SHIPMENT_INPUT`.
    *   The original `carrierPartyId` and `shipmentMethodTypeId` are restored to the shipment record.

4.  **Update Shipment Route Segments:**
    *   If the shipment has associated route segments (`ShipmentRouteSegment`), the service updates them as well.
    *   The `shipmentMethodTypeId` and `carrierPartyId` of each route segment are set to the original values retrieved in step 2.

### Key Points

*   The service focuses on resetting the shipment status and restoring original shipping details.
*   It ensures consistency by updating both the shipment and its associated route segments.
*   It provides a way to revert a shipment to an editable state for further modifications.


