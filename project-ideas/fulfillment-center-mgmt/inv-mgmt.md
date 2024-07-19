
# API Design for Inventory Management Application in Apache OFBiz

## Data Model

The core entities used for modeling facility and location information in our inventory management application are:

### Facility
Represents a physical location where inventory is stored.
- **facilityId** (Primary Key): Unique identifier for the facility.
- **facilityTypeId:** Type of facility (e.g., "RETAIL_STORE", "WAREHOUSE").
- **facilityName:** Name of the facility.

### FacilityLocation
Represents a specific location within a facility where inventory can be stored (e.g., aisles, shelves, bins).
- **locationSeqId** (Primary Key): Unique identifier for the location within the facility.
- **locationTypeEnumId:** Type of location (e.g., "FLT_PICKLOC" for picking locations, "FLT_BULK" for bulk storage locations).
- **areaId**, **aisleId**, **sectionId**: Additional identifiers for organizing locations within the facility.

## Sample JSON Data for a Retail Store Facility

```json
{
  "facilityId": "FACILITY_1",
  "facilityTypeId": "RETAIL_STORE",
  "facilityName": "Main Street Store",
  "facilityLocations": [
    {
      "locationSeqId": "0001",
      "locationTypeEnumId": "FLT_PICKLOC",
      "areaId": "A",
      "aisleId": "01",
      "sectionId": "01"
    },
    {
      "locationSeqId": "0002",
      "locationTypeEnumId": "FLT_PICKLOC",
      "areaId": "A",
      "aisleId": "01",
      "sectionId": "02"
    },
    {
      "locationSeqId": "0003",
      "locationTypeEnumId": "FLT_PICKLOC",
      "areaId": "A",
      "aisleId": "02",
      "sectionId": "01"
    },
    {
      "locationSeqId": "0004",
      "locationTypeEnumId": "FLT_PICKLOC",
      "areaId": "A",
      "aisleId": "02",
      "sectionId": "02"
    },
    {
      "locationSeqId": "0005",
      "locationTypeEnumId": "FLT_PICKLOC",
      "areaId": "B",
      "aisleId": "01",
      "sectionId": "01"
    },
    {
      "locationSeqId": "0006",
      "locationTypeEnumId": "FLT_PICKLOC",
      "areaId": "B",
      "aisleId": "01",
      "sectionId": "02"
    },
    {
      "locationSeqId": "0007",
      "locationTypeEnumId": "FLT_PICKLOC",
      "areaId": "B",
      "aisleId": "02",
      "sectionId": "01"
    },
    {
      "locationSeqId": "0008",
      "locationTypeEnumId": "FLT_PICKLOC",
      "areaId": "B",
      "aisleId": "02",
      "sectionId": "02"
    },
    {
      "locationSeqId": "0009",
      "locationTypeEnumId": "FLT_PICKLOC",
      "areaId": "C",
      "aisleId": "01",
      "sectionId": "01"
    },
    {
      "locationSeqId": "0010",
      "locationTypeEnumId": "FLT_PICKLOC",
      "areaId": "C",
      "aisleId": "01",
      "sectionId": "02"
    }
  ]
}
```

## Explanation

- **facilityId:** A unique identifier for the facility.
- **facilityTypeId:** Indicates the type of facility, in this case, "RETAIL_STORE".
- **facilityName:** A descriptive name for the facility.
- **facilityLocations:** An array containing details of each `FacilityLocation` within the facility.
  - **locationSeqId:** A unique sequence ID for the location within the facility.
  - **locationTypeEnumId:** The type of location, here it's "FLT_PICKLOC" for all locations, indicating they are primary picking locations.
  - **areaId:** Identifies the area within the facility (e.g., "A", "B", "C").
  - **aisleId:** Identifies the aisle within the area (e.g., "01", "02").
  - **sectionId:** Identifies the section within the aisle (e.g., "01", "02").

## Data model Product, association with Facility and storage location in the Facility

### Product
This entity stores the main details of a product, such as its ID, type, name, description, and various attributes like weight, dimensions, and images.

### ProductFacility
This entity establishes the relationship between a product and a facility, indicating that the product is stocked or available at that facility. It also includes additional information like minimum stock levels, reorder quantities, and estimated shipping days.

### ProductFacilityLocation
This entity further refines the product-facility relationship by specifying the exact location(s) within a facility where a particular product is stored. It includes details like minimum stock levels and move quantities for each location.

## Sample JSON Data for Products in a Facility

```json
{
  "facilityId": "FACILITY_1",
  "facilityTypeId": "RETAIL_STORE",
  "facilityName": "Main Street Store",
  "products": [
    {
      "productId": "FG001",
      "productTypeId": "FINISHED_GOOD",
      "productName": "Product 1",
      "productFacility": {
        "minimumStock": 10,
        "reorderQuantity": 50,
        "daysToShip": 3
      },
      "productFacilityLocations": [
        {
          "locationSeqId": "0001",
          "minimumStock": 5,
          "moveQuantity": 10
        },
        {
          "locationSeqId": "0005",
          "minimumStock": 5,
          "moveQuantity": 10
        }
      ]
    },
    {
      "productId": "FG002",
      "productTypeId": "FINISHED_GOOD",
      "productName": "Product 2",
      "productFacility": {
        "minimumStock": 15,
        "reorderQuantity": 60,
        "daysToShip": 2
      },
      "productFacilityLocations": [
        {
          "locationSeqId": "0003",
          "minimumStock": 8,
          "moveQuantity": 15
        },
        {
          "locationSeqId": "0007",
          "minimumStock": 7,
          "moveQuantity": 15
        }
      ]
    },
    {
      "productId": "FG003",
      "productTypeId": "FINISHED_GOOD",
      "productName": "Product 3",
      "productFacility": {
        "minimumStock": 20,
        "reorderQuantity": 70,
        "daysToShip": 5
      },
      "productFacilityLocations": [
        {
          "locationSeqId": "0002",
          "minimumStock": 10,
          "moveQuantity": 20
        },
        {
          "locationSeqId": "0006",
          "minimumStock": 10,
          "moveQuantity": 20
        }
      ]
    }
  ]
}
```

## Explanation

- **facilityId, facilityTypeId, facilityName:** Same as before, representing the retail store.
- **products:** An array containing details of each product.
  - **productId, productTypeId, productName:** Basic product information.
  - **productFacility:** Details about the product's association with the facility.
    - **minimumStock:** Minimum stock level to maintain at the facility.
    - **reorderQuantity:** Quantity to reorder when stock falls below the minimum.
    - **daysToShip:** Estimated shipping time from the facility.
  - **productFacilityLocations:** An array specifying where the product is stored within the facility.
    - **locationSeqId:** The location's unique identifier.
    - **minimumStock:** Minimum stock level to maintain at this specific location.
    - **moveQuantity:** Quantity to move when stock at this location falls below the minimum.
   
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


## Record Variance Service Notes

### Purpose

*   Accurately record inventory variances (discrepancies) when order items are rejected.
*   Provide a detailed history of adjustments for auditing and analysis.

### Inputs

*   `orderId` (String): The ID of the order containing the rejected item.
*   `orderItemSeqId` (String): The sequence ID of the rejected order item.
*   `facilityId` (String): The ID of the facility where the rejection occurred.
*   `rejectReason` (String): The reason for the rejection (enum ID).
*   `rejectComments` (String, optional): Additional comments about the rejection.

### Outputs

*   `success` (Boolean): Indicates whether the variance recording was successful.
*   `errorMessage` (String, optional): Provides details about any errors encountered.

### Core Logic

1.  **Determine Variance Quantity:**
    *   Fetch the `Enumeration` record for `rejectReason`.
    *   **Switch (rejectReason.enumTypeId):**
        *   **`REPORT_ALL_VAR`:**
            *   Fetch `lastInventoryCount` from `ProductFacility` for the product and facility.
            *   Use this as the total variance quantity.
        *   **`REPORT_VAR`:**
            *   Use the rejected `quantity` from the input as the variance quantity.
        *   **`REPORT_NO_VAR`:**
            *   No variance needs to be recorded, return success.

2.  **Fetch Available Inventory:**
    *   Query `InventoryItemAndLocation` for available inventory:
        *   Filter by `productId`, `facilityId`, `statusId` (available, returned).
        *   Ensure `availableToPromiseTotal` is greater than zero.
        *   Order by `datetimeReceived` (oldest first).

3.  **Create Variance Records:**
    *   **For each inventory item:**
        *   Calculate the variance quantity to apply (consider remaining variance for `REPORT_ALL_VAR`).
        *   Create a `PhysicalInventoryAndVariance` record:
            *   Set `inventoryItemId`, `reasonEnumId`, `comments`.
            *   Set `availableToPromiseVar` to the negative of the variance quantity.
            *   **If applicable (damaged items):**
                *   Set `quantityOnHandVar` according to business rules.
                *   Update `quantityOnHand` in `InventoryItem`.
            *   Set `orderId` and `orderItemSeqId`.
        *   If the total variance is accounted for, break the loop.

### Additional Considerations

*   **Transaction Management:** Wrap the entire operation in a transaction to ensure data consistency.
*   **Concurrency:** Consider potential concurrency issues if multiple users reject items simultaneously.
*   **Performance:** For large inventories, optimize the fetching of available inventory.
*   **Customization:** Allow for configuration of:
    *   Which `rejectReason` types trigger variance recording.
    *   Specific logic for handling damaged items and updating `quantityOnHand`.
*   **Logging:** Implement detailed logging for debugging and auditing.

## Code Structure (Enhancements)

```java
Map<String, Object> recordVariance(DispatchContext dctx, Map<String, Object> context) {
    // ... (Input parameter handling)

    // 1. Determine Variance Quantity (as described above)

    // 2. Fetch Available Inventory (as described above)

    // 3. Create Variance Records (with enhanced logic as described above)

    // 4. Error Handling (with robust logging)

    return ServiceUtil.returnSuccess(); // or ServiceUtil.returnError() with message
}
```
## createPhysicalInventoryAndVariance

The `createPhysicalInventoryAndVariance` service in the Apache OFBiz framework is designed to record discrepancies between the expected and actual inventory levels of a product at a particular facility. This discrepancy is known as an inventory variance.

### Purpose

The primary goal of this service is to create a physical inventory count record and, if necessary, an associated variance record to track adjustments to inventory levels. This is crucial for maintaining accurate inventory records and identifying potential issues like theft, damage, or errors in previous counts.

### Workflow

1.  **Input Validation:** The service validates the input parameters, including:
    *   `inventoryItemId`: The ID of the inventory item being adjusted.
    *   `physicalInventoryDate`: The date of the physical inventory count.
    *   `quantityOnHandVar`: The variance in the quantity on hand (can be positive or negative).
    *   `availableToPromiseVar`: The variance in the available-to-promise quantity (can be positive or negative).
    *   `reasonEnumId`: The reason for the variance (e.g., damaged, found, lost).
    *   `comments`: Additional comments about the variance.

2.  **Create Physical Inventory:**
    *   If a physical inventory record for the given `inventoryItemId` and `physicalInventoryDate` doesn't exist, the service creates one.
    *   The physical inventory record stores the current `quantityOnHand` and `availableToPromise` values from the `InventoryItem` entity.

3.  **Create Variance (If Applicable):**
    *   If either `quantityOnHandVar` or `availableToPromiseVar` is not zero, it indicates a variance.
    *   The service creates an `InventoryItemVariance` record to track the variance details, including the reason and comments.

4.  **Update Inventory Item:**
    *   The service updates the `InventoryItem` entity with the new `quantityOnHand` and `availableToPromise` values, reflecting the adjustments made due to the variance.

5.  **Success or Error:**
    *   If all operations are successful, the service returns a success message.
    *   If any errors occur during the process (e.g., invalid input, database issues), the service returns an error message.

### Key Points

*   **Inventory Accuracy:** This service is essential for maintaining accurate inventory records by documenting and correcting discrepancies.
*   **Traceability:** The variance records provide a history of adjustments, helping to identify trends or patterns in inventory discrepancies.
*   **Integration:** The service is often called from other services (like `rejectOrderItem`) when inventory adjustments are needed due to specific events.

```
    <!-- Overrided service createPhysicalInventoryAndVariance to set default physicalInventoryDate & partyId. This is done to avoid passing these fields from all the occurrences of createPhysicalInventoryAndVariance service. Adding this implementaion as can not assign nowtimestamp in default-value in definition -->
    <simple-method method-name="createPhysicalInventoryAndVariance" short-description="Create a PhysicalInventory and an InventoryItemVariance">
        <set-service-fields service-name="createPhysicalInventory" map="parameters" to-map="createPhysicalInventoryMap"/>
        <if-empty field="createPhysicalInventoryMap.physicalInventoryDate">
            <now-timestamp field="nowtimestamp"/>
            <set field="createPhysicalInventoryMap.physicalInventoryDate" from="nowtimestamp" />
        </if-empty>
        <if-empty field="createPhysicalInventoryMap.partyId">
            <set field="createPhysicalInventoryMap.partyId" from="userLogin.partyId" />
        </if-empty>
        <call-service service-name="createPhysicalInventory" in-map-name="createPhysicalInventoryMap">
            <result-to-field result-name="physicalInventoryId" field="parameters.physicalInventoryId"/>
            <result-to-result result-name="physicalInventoryId" service-result-name="physicalInventoryId"/>
        </call-service>
        <set-service-fields service-name="createInventoryItemVariance" map="parameters" to-map="createInventoryItemVarianceMap"/>
        <call-service service-name="createInventoryItemVariance" in-map-name="createInventoryItemVarianceMap"/>
    </simple-method>
```

## createInventoryItemVariance

### Purpose

The `createInventoryItemVariance` service is designed to create a record of a discrepancy between the expected and actual quantity of an inventory item. This discrepancy is known as an inventory variance. It's a crucial part of inventory management, helping businesses track losses, damages, or other unexpected changes in inventory levels.

### Workflow

1.  **Input Validation:** The service begins by validating the input parameters, ensuring they are not empty or null and contain valid data types.  The key input parameters include:
    *   `inventoryItemId`: The ID of the inventory item with the variance.
    *   `varianceReasonId`: The reason for the variance (e.g., DAMAGED, STOLEN).
    *   `varianceDate`: The date when the variance was noticed.
    *   `quantityOnHandVar`: The variance in quantity on hand.
    *   `availableToPromiseVar`: The variance in available-to-promise quantity.

2.  **Check Existing Variance:**
    *   The service checks if a variance record already exists for the given `inventoryItemId`, `varianceReasonId`, and `varianceDate`. If a record exists, it updates the existing record with the new variance quantities.

3.  **Create New Variance:**
    *   If no existing variance record is found, a new `InventoryItemVariance` entity is created with the provided input parameters.

4.  **Update Inventory Item:**
    *   The service updates the corresponding `InventoryItem` record. It adjusts the `quantityOnHand` and `availableToPromise` fields based on the `quantityOnHandVar` and `availableToPromiseVar` values from the input.

5.  **Create Inventory Item Details:**
    *   The service creates `InventoryItemDetail` records to log the changes made to the `quantityOnHand` and `availableToPromise` fields. These records help in tracking the history of inventory adjustments.

6.  **Return Result:**
    *   The service returns a `Map` indicating the success or failure of the operation. If successful, it will include the ID of the created or updated `InventoryItemVariance` record.

### Key Points

*   **Inventory Accuracy:** This service is vital for maintaining accurate inventory records, which is essential for efficient business operations.
*   **Traceability:** The creation of variance and detail records provides a clear audit trail of inventory adjustments, helping to identify patterns or issues.
*   **Integration with Other Services:** This service is often called by other services, such as those related to order fulfillment or inventory adjustments, whenever a variance in inventory is detected.

```
    <simple-method method-name="createInventoryItemVariance" short-description="Create an InventoryItemVariance">

        <!-- add changes to availableToPromise and quantityOnHand -->
        <make-value entity-name="InventoryItem" value-field="inventoryItemLookup"/>
        <set-pk-fields map="parameters" value-field="inventoryItemLookup"/>
        <find-by-primary-key map="inventoryItemLookup" value-field="inventoryItem"/>

        <if-compare field="inventoryItem.inventoryItemTypeId" operator="not-equals" value="NON_SERIAL_INV_ITEM">
            <string-to-list string="Can only create an InventoryItemVariance for a Non-Serialized Inventory Item" list="error_list"/>
        </if-compare>
        <check-errors/>

        <!-- instead of updating InventoryItem, add an InventoryItemDetail -->
        <set from-field="parameters.inventoryItemId" field="createDetailMap.inventoryItemId"/>
        <set from-field="parameters.physicalInventoryId" field="createDetailMap.physicalInventoryId"/>
        <set from-field="parameters.availableToPromiseVar" field="createDetailMap.availableToPromiseDiff"/>
        <set from-field="parameters.quantityOnHandVar" field="createDetailMap.quantityOnHandDiff"/>
        <set from-field="parameters.quantityOnHandVar" field="createDetailMap.accountingQuantityDiff"/>
        <set from-field="parameters.reasonEnumId" field="createDetailMap.reasonEnumId"/>
        <set from-field="parameters.comments" field="createDetailMap.description"/>
        <!-- Added orderId and orderItemSeqId to track from InventoryItemDetail which order item is rejected as this service is called from createPhysicalInventoryAndVariance -->
        <set from-field="parameters.orderId" field="createDetailMap.orderId"/>
        <set from-field="parameters.orderItemSeqId" field="createDetailMap.orderItemSeqId"/>
        <call-service service-name="createInventoryItemDetail" in-map-name="createDetailMap"/>

        <make-value entity-name="InventoryItemVariance" value-field="newEntity"/>
        <set-pk-fields map="parameters" value-field="newEntity"/>
        <set-nonpk-fields map="parameters" value-field="newEntity"/>
        <set field="newEntity.changeByUserLoginId" from="userLogin.userLoginId"/>
        <create-value value-field="newEntity"/>

        <!-- TODO: (possibly a big deal?) check to see if any reserved inventory needs to be changed because of a change in availableToPromise -->
        <!-- TODO: make sure availableToPromise is never greater than the quantityOnHand? -->
    </simple-method>

```

