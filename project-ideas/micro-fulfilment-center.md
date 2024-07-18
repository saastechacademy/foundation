
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

## packShipment

### Detailed Logic

1.  **Input:**
    *   Receive `shipmentId` as the input parameter.

2.  **Fetch Shipment:**
    *   Use `EntityQuery` to retrieve the `Shipment` entity based on the provided `shipmentId`.
    *   Validate that the shipment exists and is in the `SHIPMENT_APPROVED` status (precondition).

3.  **Fetch Shipment Items:**
    *   Query the `ShipmentItem` entity to get all items associated with the shipment.

4.  **Update Shipment Status:**
    *   Update the `statusId` of the `Shipment` entity to `SHIPMENT_PACKED` (postcondition), indicating it's been packed and is ready for shipment.

5.  **Fetch Order and Order Item Details:**
    *   For each `ShipmentItem`, use the `OrderShipment` entity to find the corresponding `orderId` and `orderItemSeqId`.

6.  **Update Picklist Items:**
    *   For each `orderId` and `orderItemSeqId` pair, query the `PicklistItem` entity to find associated items.
    *   Update the `itemStatusId` of these `PicklistItem` entities to `PICKITEM_PICKED`, indicating they have been picked for the packed shipment.


## Java Code Skeleton

```java
public static Map<String, Object> packShipment(DispatchContext dctx, Map<String, Object> context) {
    Delegator delegator = dctx.getDelegator();
    LocalDispatcher dispatcher = dctx.getDispatcher();
    GenericValue userLogin = (GenericValue) context.get("userLogin");

    String shipmentId = (String) context.get("shipmentId");

    try {
        // 1. Fetch Shipment
        GenericValue shipment = EntityQuery.use(delegator).from("Shipment").where("shipmentId", shipmentId).queryOne();
        if (shipment == null || !"SHIPMENT_APPROVED".equals(shipment.getString("statusId"))) {
            return ServiceUtil.returnError("Shipment not found or not in APPROVED status");
        }

        // 2. Fetch Shipment Items
        List<GenericValue> shipmentItems = EntityQuery.use(delegator).from("ShipmentItem").where("shipmentId", shipmentId).queryList();

        // 3. Update Shipment Status
        shipment.set("statusId", "SHIPMENT_PACKED");
        shipment.store();

        // 4. Fetch Order and Order Item Details & 5. Update Picklist Items
        for (GenericValue shipmentItem : shipmentItems) {
            // ... (Use OrderShipment to find orderId and orderItemSeqId)
            // ... (Query PicklistItem and update itemStatusId to PICKITEM_PICKED)
        }

    } catch (GenericEntityException e) {
        Debug.logError(e, MODULE);
        return ServiceUtil.returnError(e.getMessage());
    }

    return ServiceUtil.returnSuccess("Shipment packed successfully.");
}
```

### Key Corrections

*   **Shipment Status:** The precondition is now correctly checked for `SHIPMENT_APPROVED`, and the postcondition updates the status to `SHIPMENT_PACKED`.
*   **OFBiz Conventions:** The code adheres to OFBiz conventions for entity queries and updates.

## unpackOrderItems

### Detailed Logic

1.  **Input:**
    *   Receive `shipmentId` as the input parameter.

2.  **Fetch Shipment:**
    *   Use `EntityQuery` to retrieve the `Shipment` entity based on the provided `shipmentId`.
    *   Validate that the shipment exists and is in the `SHIPMENT_PACKED` status.

3.  **Fetch Shipment Items:**
    *   Query the `ShipmentItem` entity to get all items associated with the shipment.

4.  **Update Shipment Status:**
    *   Update the `statusId` of the `Shipment` entity to `SHIPMENT_APPROVED`, indicating it's no longer packed.

5.  **Fetch Order and Order Item Details:**
    *   For each `ShipmentItem`, use the `OrderShipment` entity to find the corresponding `orderId` and `orderItemSeqId`.

6.  **Update Picklist Items:**
    *   For each `orderId` and `orderItemSeqId` pair, query the `PicklistItem` entity to find associated items with the status `PICKITEM_PICKED`.
    *   Update the `itemStatusId` of these `PicklistItem` entities to `PICKITEM_PENDING`, indicating they are available for picking again.

7.  **Error Handling and Success:**
    *   Wrap the logic in a `try-catch` block to handle potential exceptions (e.g., `GenericEntityException`).
    *   Return a success message if all updates are successful.
    *   Return an error message with details if any errors occur.

## Java Code Skeleton

```java
public static Map<String, Object> unpackShipment(DispatchContext dctx, Map<String, Object> context) {
    Delegator delegator = dctx.getDelegator();
    LocalDispatcher dispatcher = dctx.getDispatcher();
    GenericValue userLogin = (GenericValue) context.get("userLogin");

    String shipmentId = (String) context.get("shipmentId");

    try {
        // 1. Fetch Shipment
        GenericValue shipment = EntityQuery.use(delegator).from("Shipment").where("shipmentId", shipmentId).queryOne();
        if (shipment == null || !"SHIPMENT_PACKED".equals(shipment.getString("statusId"))) {
            return ServiceUtil.returnError("Shipment not found or not in PACKED status");
        }

        // 2. Fetch Shipment Items
        List<GenericValue> shipmentItems = EntityQuery.use(delegator).from("ShipmentItem").where("shipmentId", shipmentId).queryList();

        // 3. Update Shipment Status
        shipment.set("statusId", "SHIPMENT_APPROVED");
        shipment.store();

        // 4. Fetch Order and Order Item Details & 5. Update Picklist Items
        for (GenericValue shipmentItem : shipmentItems) {
            String orderId = shipmentItem.getString("orderId");
            String orderItemSeqId = shipmentItem.getString("orderItemSeqId");

            // Use OrderShipment to find associated PicklistItems
            List<GenericValue> picklistItems = EntityQuery.use(delegator)
                .from("PicklistItem")
                .where("orderId", orderId, "orderItemSeqId", orderItemSeqId, "itemStatusId", "PICKITEM_PICKED")
                .queryList();

            for (GenericValue picklistItem : picklistItems) {
                picklistItem.set("itemStatusId", "PICKITEM_PENDING");
                picklistItem.store();
            }
        }

    } catch (GenericEntityException e) {
        Debug.logError(e, MODULE);
        return ServiceUtil.returnError(e.getMessage());
    }

    return ServiceUtil.returnSuccess("Shipment unpacked successfully.");
}
```

### Key Changes from `unpackOrderItems`

*   **Input:** Takes `shipmentId` instead of `orderId` and `picklistBinId`.
*   **Shipment Status Update:** Updates the shipment status to `SHIPMENT_APPROVED` instead of `SHIPMENT_CANCELLED`.
*   **PicklistItem Query:** The query for `PicklistItem` is modified to filter by `shipmentId` (obtained from `OrderShipment`) instead of `picklistBinId`.

### reinitializeShipment

The `reinitializeShipment` service is designed to reset a shipment to its initial state, specifically to the `SHIPMENT_INPUT` status. This is often done when modifications need to be made to a shipment after it has been approved or partially processed.

### Input Parameters

*   `shipmentId` (String): The ID of the shipment that needs to be reinitialized.

### Use Cases

This service is typically used in scenarios where:

*   **Item Rejection:** When an item within a shipment is rejected, the shipment might need to be reinitialized to allow for adjustments and potential reassignment of items.
*   **Shipment Modification:** If there are changes to the shipment details (e.g., shipping address, carrier), reinitializing the shipment can reset it to a state where these changes can be made.
*   **Error Correction:** If an error occurred during the initial shipment processing, reinitializing can provide a clean slate to correct the issue.
*   **Updating package box types:** In the `updateInProgressOrder` function, if the shipment label hasn't been generated or the box type has changed, the shipment is reinitialized.
*   **Processing ready-to-pack items:** In the `updateInProgressOrder` function, if an item needs to be moved to a different shipment, both the original and new shipments are reinitialized.
*   **Handling item rejections:** In the `updateInProgressOrder` function, the shipment is reinitialized for items with specific rejection reasons.

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


## cancelOrderItemInvResQty
The `cancelOrderItemInvResQty` service in the Apache OFBiz framework is designed to handle the cancellation of inventory reservations associated with a specific order item. Inventory reservations are typically made when an order is placed to ensure that the required quantity of a product is available for fulfillment.

### Purpose

The primary goal of this service is to adjust inventory reservations and potentially release reserved inventory back into the available pool. This is crucial in scenarios where an order item is canceled, modified, or rejected, and the reserved inventory needs to be updated accordingly.

### Workflow

1.  **Input Validation:** The service validates the input parameters, including `orderId`, `orderItemSeqId`, `shipGroupSeqId`, and `cancelQuantity`. It ensures that these parameters are valid and that the specified quantity to cancel doesn't exceed the reserved quantity.

2.  **Fetch Order Item Ship Group Assoc:** It retrieves the `OrderItemShipGroupAssoc` record, which links the order item to its shipment group and contains information about the reserved inventory.

3.  **Calculate New Reserved Quantity:** It calculates the new reserved quantity by subtracting the `cancelQuantity` from the existing `quantity` in the `OrderItemShipGroupAssoc` record.

4.  **Update Order Item Ship Group Assoc:** It updates the `OrderItemShipGroupAssoc` record with the new reserved quantity.

5.  **Release Inventory (If Applicable):**
    *   If the new reserved quantity is zero, it means the entire reservation for that order item is being canceled.
    *   In this case, the service calls the `deleteOrderItemShipGrpInvRes` service to remove the inventory reservation record (`OrderItemShipGrpInvRes`) associated with the order item. This effectively releases the reserved inventory back into the available pool.

6.  **Success or Error:**
    *   If all updates are successful, the service returns a success message.
    *   If any errors occur during the process (e.g., invalid input, database issues), the service returns an error message.

### Key Points

*   **Inventory Management:** This service plays a crucial role in maintaining accurate inventory levels by adjusting reservations based on order changes.
*   **Service Chaining:** It interacts with other services like `deleteOrderItemShipGrpInvRes` to handle the actual deletion of inventory reservation records.
*   **Error Handling:** It includes error handling to ensure data integrity and provide informative error messages.

```
    <simple-method method-name="cancelOrderItemInvResQty" short-description="Cancel Inventory Reservation Qty For An Item">
        <!--
            This will cancel the specified amount by looking through the reservations in order and cancelling
            just the right amount
        -->
        <if-empty field="parameters.cancelQuantity">
            <set from-field="parameters.orderId" field="cancelMap.orderId"/>
            <set from-field="parameters.orderItemSeqId" field="cancelMap.orderItemSeqId"/>
            <set from-field="parameters.shipGroupSeqId" field="cancelMap.shipGroupSeqId"/>
            <call-service service-name="cancelOrderInventoryReservation" in-map-name="cancelMap"/>
        </if-empty>
        <if-not-empty field="parameters.cancelQuantity">
            <set from-field="parameters.cancelQuantity" field="toCancelAmount"/>

            <set from-field="parameters.orderId" field="oisgirListLookupMap.orderId"/>
            <set from-field="parameters.orderItemSeqId" field="oisgirListLookupMap.orderItemSeqId"/>
            <set from-field="parameters.shipGroupSeqId" field="oisgirListLookupMap.shipGroupSeqId"/>
            <find-by-and entity-name="OrderItemShipGrpInvRes" map="oisgirListLookupMap" list="oisgirList" use-cache="false"/>
            <iterate list="oisgirList" entry="oisgir">
                <if-compare field="toCancelAmount" operator="greater" value="0" type="BigDecimal">
                    <if-compare-field field="oisgir.quantity" to-field="toCancelAmount" operator="greater-equals" type="BigDecimal">
                        <set from-field="toCancelAmount" field="cancelOisgirMap.cancelQuantity"/>
                    </if-compare-field>
                    <if-compare-field field="oisgir.quantity" to-field="toCancelAmount" operator="less" type="BigDecimal">
                        <set from-field="oisgir.quantity" field="cancelOisgirMap.cancelQuantity"/>
                    </if-compare-field>

                    <!-- Check if the product of OrderItem is a Kit Product, then we need to calculate cancel qty of components reservation on the basis of productAccos -->
                    <get-related-one relation-name="InventoryItem" value-field="oisgir" to-value-field="inventoryItem"/>
                    <entity-one entity-name="OrderItemAndProduct" value-field="orderItemAndProduct">
                        <field-map field-name="orderId" from-field="oisgir.orderId"/>
                        <field-map field-name="orderItemSeqId" from-field="oisgir.orderItemSeqId"/>
                        <field-map field-name="shipGroupSeqId" from-field="oisgir.shipGroupSeqId"/>
                        <field-map field-name="productTypeId" value="MARKETING_PKG_PICK"/>
                    </entity-one>

                    <if-not-empty field="orderItemAndProduct">
                        <!-- This means that OrderItem is of type MARKETING_PKG_PICK so we need to pick quantity of component products from its assoc -->
                        <set field="itemProductId" from="orderItemAndProduct.productId"/>
                        <set field="inventoryItemProductId" from="inventoryItem.productId"/>
                        <if-compare-field operator="not-equals" field="itemProductId" to-field="inventoryItemProductId">
                            <entity-and entity-name="ProductAssoc" list="productAssocs" filter-by-date="true">
                                <field-map field-name="productId" from-field="itemProductId"></field-map>
                                <field-map field-name="productIdTo" from-field="inventoryItemProductId"></field-map>
                                <field-map field-name="productAssocTypeId" value="PRODUCT_COMPONENT"></field-map>
                            </entity-and>
                            <first-from-list entry="productAssoc" list="productAssocs"/>

                            <if-not-empty field="productAssoc">
                                <calculate field="cancelOisgirMap.cancelQuantity">
                                    <calcop operator="multiply">
                                        <calcop operator="get" field="cancelOisgirMap.cancelQuantity"/>
                                        <calcop operator="get" field="productAssoc.quantity"/>
                                    </calcop>
                                </calculate>
                                <if-compare-field field="oisgir.quantity" to-field="cancelOisgirMap.cancelQuantity" operator="less" type="BigDecimal">
                                    <set from="oisgir.quantity" field="cancelOisgirMap.cancelQuantity"/>
                                </if-compare-field>
                            </if-not-empty>
                        </if-compare-field>
                        <else>
                            <!-- update the toCancelAmount -->
                            <calculate field="toCancelAmount" decimal-scale="6">
                                <calcop operator="subtract" field="toCancelAmount">
                                    <calcop operator="get" field="cancelOisgirMap.cancelQuantity"/>
                                </calcop>
                            </calculate>
                        </else>
                    </if-not-empty>

                    <set from-field="oisgir.orderId" field="cancelOisgirMap.orderId"/>
                    <set from-field="oisgir.orderItemSeqId" field="cancelOisgirMap.orderItemSeqId"/>
                    <set from-field="oisgir.shipGroupSeqId" field="cancelOisgirMap.shipGroupSeqId"/>
                    <set from-field="oisgir.inventoryItemId" field="cancelOisgirMap.inventoryItemId"/>
                    <call-service service-name="cancelOrderItemShipGrpInvRes" in-map-name="cancelOisgirMap"/>
                    <!-- checkDecomposeInventoryItem service is called to decompose a marketing package (if the product is a mkt pkg) -->
                    <set from-field="oisgir.inventoryItemId" field="checkDiiMap.inventoryItemId"/>
                    <call-service service-name="checkDecomposeInventoryItem" in-map-name="checkDiiMap"/>
                </if-compare>
            </iterate>
        </if-not-empty>
    </simple-method>

```

## rejectOrderItem

The "Process Non-Kit Item Rejection" of the `rejectOrderItem`.

### Purpose

This section of the code handles the rejection of individual order items that are not part of a kit (i.e., standalone products). The goal is to update the order item's association with the shipment group, adjust inventory levels, and log the rejection.

### Workflow

1.  **Fetch Ship Groups:** The code retrieves all `OrderItemShipGroupAssoc` records associated with the order item (`orderId` and `orderItemSeqId`) that are in a shippable state (`quantity` greater than zero).

2.  **Iterate Through Ship Groups:** For each ship group association:
    *   **Calculate `cancelReservationQuantity`:** If a specific `quantity` to reject was provided in the input, it's used. Otherwise, the entire remaining quantity in the ship group association is set as the `cancelReservationQuantity`.
    *   **Cancel Inventory Reservation:** The `cancelOrderItemInvResQty` service is called to cancel the corresponding inventory reservation for the `cancelReservationQuantity`.
    *   **Move to Rejected Ship Group (if applicable):** If the order item was originally associated with a non-NA facility, it's moved to a ship group associated with the `naFacilityId` (a designated facility for rejected items).
    *   **Create Order Facility Change:** An `OrderFacilityChange` record is created to log the change in facility for the rejected item.
    *   **Log External Fulfillment:** The `createUpdateExternalFulfillmentOrderItem` service is called to create or update an external fulfillment log entry, marking the item as rejected.
    *   **Create Order History:** An `OrderHistory` record is created with the event type `ITEM_REJECTED` to track the rejection in the order's history.

3.  **Record Inventory Variance:** If the `recordVariance` flag is set to "Y," and the rejection reason requires it, an inventory variance is recorded for the rejected quantity. This helps track inventory adjustments due to the rejection.

4.  **Set Auto Cancel Date:** If the `setAutoCancelDate` flag is set to "Y," the service calculates and sets an auto-cancel date for the order item based on the product store's configuration. This is typically used to automatically cancel orders that haven't been paid for within a certain timeframe.

### Key Points

*   **Targeted Rejection:** The service focuses on rejecting only the specified order item within the given ship group(s).
*   **Inventory and Order Management:** It handles inventory reservation cancellations, facility changes, and order history updates.
*   **Integration with Other Services:** It relies on other services like `cancelOrderItemInvResQty` and `createUpdateExternalFulfillmentOrderItem` to perform specific actions.
*   **Flexibility:** It can handle both partial and full rejections of an order item's quantity.

Once again:

1.  **Fetch Current Ship Group:**
    *   Retrieves the current ship group associated with the order item using `OrderItemShipGroupAssoc`.
    *   If found, fetches details of the ship group from `OrderItemShipGroup`.

2.  **Handle Kit Product Rejection (If Applicable):**
    *   Checks if the rejected item is part of a kit product.
    *   If so, performs the following actions:
        *   Cancels associated picklist items by updating their status to `PICKITEM_CANCELLED`.
        *   Releases reserved inventory for the kit product.
        *   Moves the ship group to the rejected item facility (`naFacilityId`) if it's different from the current facility.
        *   Creates `OrderFacilityChange` records for both the kit product and its components.
        *   Logs the rejection in the external fulfillment system and order history.

3.  **Fetch Quantity for Variance (If Applicable):**
    *   If `recordVariance` is "Y" and a valid `rejectReason` is provided, it fetches the quantity to record the variance.
    *   The variance quantity is determined based on the `rejectReasonDetail` (enumeration type).

4.  **Process Non-Kit Item Rejection:**
    *   If the item is not part of a kit, proceeds with the following:
        *   Fetches ship groups associated with the item at the specified facility, filtering by order and item status.
        *   Iterates through each ship group:
            *   Cancels associated picklist items.
            *   Releases reserved inventory.
            *   Adds the rejected item details (order ID, item sequence ID, ship group, quantity) to a list.
            *   Updates or deletes the `OrderItemShipGroupAssoc` based on the remaining quantity.
            *   Finds or creates a ship group in the rejected item facility (`naFacilityId`).
            *   Adds the item to the rejected item ship group.
            *   Creates an `OrderFacilityChange` record.
            *   Logs the rejection in the external fulfillment system and order history.
            *   Optionally sets an auto-cancel date for the order item (commented out in the code).

5.  **Record Variance (If Applicable):**
    *   If `recordVariance` is "Y" and the `rejectReason` requires it, records the variance for all available quantities of the product.
    *   Iterates through available inventory items and creates `PhysicalInventoryAndVariance` records.

6.  **Create Excluded Order Facility (If Applicable):**
    *   If `excludeOrderFacilityDuration` is provided, creates an `ExcludedOrderFacility` record to prevent future orders from being fulfilled from the rejected facility for a specified duration.


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

## Workflow Management

### 1. StatusFlow

**Purpose:** Defines a specific workflow or process. It outlines the permissible paths and sequences of statuses an entity can traverse.

**Example:** An "Order Fulfillment" workflow might have steps like creation, approval, processing, shipping, and completion.

**Key Fields:**

*   `statusFlowId`: Unique identifier (e.g., "ORDER_FULFILLMENT").
*   `description`: Describes the overall purpose of the workflow.

### 2. StatusFlowItem

**Purpose:** The glue that connects individual statuses (`StatusItem`) to specific workflows (`StatusFlow`). It defines which statuses are valid within a particular workflow.

**Key Fields:**

*   `statusFlowId`: The ID of the workflow the status belongs to.
*   `statusId`: The ID of the status item.

### 3. StatusFlowTransition

**Purpose:** Governs the rules for transitioning between statuses within a `StatusFlow`. It dictates which changes are allowed and under what conditions.

**Example:** A transition might be defined from "Processing" to "Shipped" only if inventory is available.

**Key Fields:**

*   `statusFlowId`: The ID of the workflow.
*   `statusId`: The current status.
*   `transitionName`: A descriptive name for the transition (e.g., "Ship Order").
*   `targetStatusId`: The status the entity will have after the transition.
*   `conditionExpr`: (Currently unused) Placeholder for future conditional logic.

**Sample data from OFBiz**

```
    <!-- ShipmentRouteSegment CarrierService status -->
    <StatusType description="ShipmentRouteSegment:CarrierService" hasTable="N"  statusTypeId="SHPRTSG_CS_STATUS"/>
    <StatusItem description="Not Started" sequenceId="01" statusCode="NOT_STARTED" statusId="SHRSCS_NOT_STARTED" statusTypeId="SHPRTSG_CS_STATUS"/>
    <StatusItem description="Confirmed" sequenceId="02" statusCode="CONFIRMED" statusId="SHRSCS_CONFIRMED" statusTypeId="SHPRTSG_CS_STATUS"/>
    <StatusItem description="Accepted" sequenceId="03" statusCode="ACCEPTED" statusId="SHRSCS_ACCEPTED" statusTypeId="SHPRTSG_CS_STATUS"/>
    <StatusItem description="Voided" sequenceId="08" statusCode="VOIDED" statusId="SHRSCS_VOIDED" statusTypeId="SHPRTSG_CS_STATUS"/>
    <StatusValidChange statusId="SHRSCS_NOT_STARTED" statusIdTo="SHRSCS_CONFIRMED" transitionName="Confirm"/>
    <StatusValidChange statusId="SHRSCS_CONFIRMED" statusIdTo="SHRSCS_ACCEPTED" transitionName="Accept"/>
    <StatusValidChange statusId="SHRSCS_CONFIRMED" statusIdTo="SHRSCS_VOIDED" transitionName="Void"/>
    <StatusValidChange statusId="SHRSCS_ACCEPTED" statusIdTo="SHRSCS_VOIDED" transitionName="Void"/>

    <!-- Picklist status -->
    <StatusType description="Picklist" hasTable="N"  statusTypeId="PICKLIST_STATUS"/>
    <StatusItem description="Created" sequenceId="01" statusCode="INPUT" statusId="PICKLIST_INPUT" statusTypeId="PICKLIST_STATUS"/>
    <StatusItem description="Assigned" sequenceId="02" statusCode="ASSIGNED" statusId="PICKLIST_ASSIGNED" statusTypeId="PICKLIST_STATUS"/>
    <StatusItem description="Printed" sequenceId="03" statusCode="PRINTED" statusId="PICKLIST_PRINTED" statusTypeId="PICKLIST_STATUS"/>
    <StatusItem description="Picked" sequenceId="10" statusCode="PICKED" statusId="PICKLIST_PICKED" statusTypeId="PICKLIST_STATUS"/>
    <StatusItem description="Cancelled" sequenceId="99" statusCode="CANCELLED" statusId="PICKLIST_CANCELLED" statusTypeId="PICKLIST_STATUS"/>

    
    <StatusValidChange statusId="PICKLIST_INPUT" statusIdTo="PICKLIST_ASSIGNED" transitionName="Assign"/>
    <StatusValidChange statusId="PICKLIST_INPUT" statusIdTo="PICKLIST_PRINTED" transitionName="Print"/>
    <StatusValidChange statusId="PICKLIST_INPUT" statusIdTo="PICKLIST_PICKED" transitionName="Pick"/>
    <StatusValidChange statusId="PICKLIST_INPUT" statusIdTo="PICKLIST_CANCELLED" transitionName="Cancel"/>
    <StatusValidChange statusId="PICKLIST_ASSIGNED" statusIdTo="PICKLIST_PICKED" transitionName="Pick"/>
    <StatusValidChange statusId="PICKLIST_ASSIGNED" statusIdTo="PICKLIST_PRINTED" transitionName="Print"/>
    <StatusValidChange statusId="PICKLIST_ASSIGNED" statusIdTo="PICKLIST_CANCELLED" transitionName="Cancel"/>
    <StatusValidChange statusId="PICKLIST_PRINTED" statusIdTo="PICKLIST_PICKED" transitionName="Pick"/>
    <StatusValidChange statusId="PICKLIST_PRINTED" statusIdTo="PICKLIST_CANCELLED" transitionName="Cancel"/>
    <StatusValidChange statusId="PICKLIST_PRINTED" statusIdTo="PICKLIST_COMPLETED" transitionName="Complete"/>

    <!-- Picklist item status -->
    <StatusType description="Picklist Item" hasTable="N" statusTypeId="PICKITEM_STATUS"/>
    <StatusItem description="Pending" sequenceId="01" statusCode="PENDING" statusId="PICKITEM_PENDING" statusTypeId="PICKITEM_STATUS"/>
    <StatusItem description="Picked" sequenceId="30" statusCode="PICKED"  statusId="PICKITEM_PICKED" statusTypeId="PICKITEM_STATUS"/>
    <StatusItem description="Completed" sequenceId="50" statusCode="COMPLETED" statusId="PICKITEM_COMPLETED" statusTypeId="PICKITEM_STATUS"/>
    <StatusItem description="Cancelled" sequenceId="99" statusCode="CANCELLED" statusId="PICKITEM_CANCELLED" statusTypeId="PICKITEM_STATUS"/>
    <StatusValidChange statusId="PICKITEM_PENDING" statusIdTo="PICKITEM_PICKED" transitionName="Picked"/>
    <StatusValidChange statusId="PICKITEM_PENDING" statusIdTo="PICKITEM_COMPLETED" transitionName="Complete"/>
    <StatusValidChange statusId="PICKITEM_PENDING" statusIdTo="PICKITEM_CANCELLED" transitionName="Cancel"/>
    <StatusValidChange statusId="PICKITEM_PICKED" statusIdTo="PICKITEM_COMPLETED" transitionName="Completed"/>


    <!-- Shipment status -->
    <StatusType description="Shipment" hasTable="N"  statusTypeId="SHIPMENT_STATUS"/>
        <!-- Shipment status -->
    <StatusItem description="Created" sequenceId="01" statusCode="INPUT" statusId="SHIPMENT_INPUT" statusTypeId="SHIPMENT_STATUS"/>
    <StatusItem description="Approved" sequenceId="08" statusCode="APPROVED" statusId="SHIPMENT_APPROVED" statusTypeId="SHIPMENT_STATUS"/>
    <StatusItem description="Scheduled" sequenceId="02" statusCode="SCHEDULED" statusId="SHIPMENT_SCHEDULED" statusTypeId="SHIPMENT_STATUS"/>
    <StatusItem description="Picked" sequenceId="03" statusCode="PICKED" statusId="SHIPMENT_PICKED" statusTypeId="SHIPMENT_STATUS"/>
    <StatusItem description="Packed" sequenceId="04" statusCode="PACKED" statusId="SHIPMENT_PACKED" statusTypeId="SHIPMENT_STATUS"/>
    <StatusItem description="Shipped" sequenceId="05" statusCode="SHIPPED" statusId="SHIPMENT_SHIPPED" statusTypeId="SHIPMENT_STATUS"/>
    <StatusItem description="Delivered" sequenceId="06" statusCode="DELIVERED" statusId="SHIPMENT_DELIVERED" statusTypeId="SHIPMENT_STATUS"/>
    <StatusItem description="Cancelled" sequenceId="99" statusCode="CANCELLED" statusId="SHIPMENT_CANCELLED" statusTypeId="SHIPMENT_STATUS"/>

    <StatusValidChange statusId="SHIPMENT_INPUT" statusIdTo="SHIPMENT_SCHEDULED" transitionName="Schedule"/>
    <StatusValidChange statusId="SHIPMENT_INPUT" statusIdTo="SHIPMENT_PICKED" transitionName="Pick"/>
    <StatusValidChange statusId="SHIPMENT_INPUT" statusIdTo="SHIPMENT_PACKED" transitionName="Pack"/>
    <StatusValidChange statusId="SHIPMENT_SCHEDULED" statusIdTo="SHIPMENT_PICKED" transitionName="Pick"/>
    <StatusValidChange statusId="SHIPMENT_SCHEDULED" statusIdTo="SHIPMENT_PACKED" transitionName="Pack"/>
    <StatusValidChange statusId="SHIPMENT_PICKED" statusIdTo="SHIPMENT_PACKED" transitionName="Pack"/>
    <StatusValidChange statusId="SHIPMENT_PACKED" statusIdTo="SHIPMENT_SHIPPED" transitionName="Ship"/>
    <StatusValidChange statusId="SHIPMENT_SHIPPED" statusIdTo="SHIPMENT_DELIVERED" transitionName="Deliver"/>
    <StatusValidChange statusId="SHIPMENT_INPUT" statusIdTo="SHIPMENT_CANCELLED" transitionName="Cancel"/>
    <StatusValidChange statusId="SHIPMENT_SCHEDULED" statusIdTo="SHIPMENT_CANCELLED" transitionName="Cancel"/>
    <StatusValidChange statusId="SHIPMENT_PICKED" statusIdTo="SHIPMENT_CANCELLED" transitionName="Cancel"/>


    <!-- Shipment SHIPMENT_STATUS status valid change data -->
    <StatusValidChange statusId="SHIPMENT_APPROVED" statusIdTo="SHIPMENT_INPUT" transitionName="Create" conditionExpression="directStatusChange == false"/>
    <StatusValidChange statusId='SHIPMENT_APPROVED' statusIdTo='SHIPMENT_PACKED' transitionName='Pack' sequenceNum='01' />
    <StatusValidChange statusId='SHIPMENT_APPROVED' statusIdTo='SHIPMENT_CANCELLED' transitionName='Cancel' sequenceNum='03' />
    <StatusValidChange statusId='SHIPMENT_APPROVED' statusIdTo='SHIPMENT_SHIPPED' transitionName='Ship' sequenceNum='02' />
    <StatusValidChange statusId='SHIPMENT_INPUT' statusIdTo='SHIPMENT_SCHEDULED' transitionName='Schedule' sequenceNum='01' conditionExpression="directStatusChange == false" />
    <StatusValidChange statusId='SHIPMENT_INPUT' statusIdTo='SHIPMENT_PICKED' transitionName='Pick' sequenceNum='02' conditionExpression="directStatusChange == false" />
    <StatusValidChange statusId='SHIPMENT_INPUT' statusIdTo='SHIPMENT_CANCELLED' transitionName='Cancel' sequenceNum='04' />
    <StatusValidChange statusId='SHIPMENT_INPUT' statusIdTo='SHIPMENT_PACKED' transitionName='Pack' sequenceNum='03' conditionExpression="directStatusChange == false" />
    <StatusValidChange statusId="SHIPMENT_INPUT" statusIdTo="SHIPMENT_APPROVED" transitionName="Approve" sequenceNum="05" conditionExpression="directStatusChange == false" />
    <StatusValidChange statusId='SHIPMENT_SCHEDULED' statusIdTo='SHIPMENT_PICKED' transitionName='Pick' sequenceNum='01' />
    <StatusValidChange statusId='SHIPMENT_SCHEDULED' statusIdTo='SHIPMENT_CANCELLED' transitionName='Cancel' sequenceNum='03' />
    <StatusValidChange statusId='SHIPMENT_SCHEDULED' statusIdTo='SHIPMENT_PACKED' transitionName='Pack' sequenceNum='02' />
    <StatusValidChange statusId='SHIPMENT_PACKED' statusIdTo='SHIPMENT_INPUT' transitionName='input' sequenceNum='02' conditionExpression="directStatusChange == false" />
    <StatusValidChange statusId='SHIPMENT_PACKED' statusIdTo='SHIPMENT_SHIPPED' transitionName='Ship' sequenceNum='01' />
    <StatusValidChange statusId='SHIPMENT_PACKED' statusIdTo='SHIPMENT_CANCELLED' transitionName='Cancel' sequenceNum='03' />
    <StatusValidChange statusId="SHIPMENT_PACKED" statusIdTo="SHIPMENT_APPROVED" transitionName="Approve" sequenceNum="04" conditionExpression="directStatusChange == false" />
    <StatusValidChange statusId='SHIPMENT_PICKED' statusIdTo='SHIPMENT_CANCELLED' transitionName='Cancel' sequenceNum='02' />
    <StatusValidChange statusId='SHIPMENT_PICKED' statusIdTo='SHIPMENT_PACKED' transitionName='Pack' sequenceNum='01' />
    <StatusValidChange statusId='SHIPMENT_SHIPPED' statusIdTo='SHIPMENT_DELIVERED' transitionName='Deliver' sequenceNum='01' />
```



## **PickListOrderItem Entity Design**

| Field Name             | Data Type     | Primary Key | Foreign Key | Description                                                                                 |
| :--------------------- | :------------ | :---------- | :---------- | :------------------------------------------------------------------------------------------ |
| pickListId             | id            | Yes         | Yes         | ID of the Picklist this item belongs to.                                                   |
| pickListItemSeqId      | id            | Yes         | -           | Unique sequence ID for the item within the picklist (e.g., "00001", "00002").              |
| orderId               | id            | Yes         | Yes         | ID of the order this item is associated with.                                              |
| orderItemSeqId         | id            | Yes         | Yes         | Sequence ID of the item within the order.                                                  |
| inventoryItemId        | id            | -           | Yes         | ID of the inventory item being picked (optional, could be null if not yet assigned).       |
| quantity               | decimal       | -           | -           | Quantity of the item to be picked.                                                         |
| itemStatusId           | id            | -           | Yes         | Status of the picklist item (e.g., "ITEM_APPROVED," "ITEM_PICKED," "ITEM_REJECTED").         |
| createdDate            | date-time     | -           | -           | Date and time when the picklist item was created.                                            |
| createdByUserLogin     | varchar(255)  | -           | -           | User who created the picklist item.                                                        |
| lastModifiedDate       | date-time     | -           | -           | Date and time when the picklist item was last modified.                                     |
| lastModifiedByUserLogin | varchar(255)  | -           | -           | User who last modified the picklist item.                                                   |

**Primary Key:**

*   The `PickListOrderItem` entity has a composite primary key consisting of:
    *   `pickListId`
    *   `pickListItemSeqId`
    *   `orderId`
    *   `orderItemSeqId`

**Foreign Keys:**

*   `pickListId` references the `Picklist` entity.
*   `orderId` and `orderItemSeqId` reference the `OrderItem` entity.
*   `itemStatusId` references the `StatusItem` entity (with `statusTypeId = "PICKLIST_ITEM_STATUS"`).
*   `inventoryItemId` references the `InventoryItem` entity (optional).

**Additional Considerations:**

*   **Status Management:** The `itemStatusId` field is crucial for tracking the progress of each item in the picklist (e.g., approved, picked, rejected).
*   **Inventory Assignment:** The `inventoryItemId` field can be used to associate a specific inventory item with the picklist item once it's been picked.
*   **Quantity:** The `quantity` field should be a decimal to allow for fractional quantities if needed.
*   **Auditing:** The `createdDate`, `createdByUserLogin`, `lastModifiedDate`, and `lastModifiedByUserLogin` fields provide an audit trail of changes to the picklist item.

**Example `PickListOrderItem` Record**

```
pickListId: "PL0005"
pickListItemSeqId: "00001"
orderId: "10000"
orderItemSeqId: "00101"
inventoryItemId: "10000"  
quantity: 1
itemStatusId: "ITEM_APPROVED"
createdDate: "2024-07-15 09:15:00"
createdByUserLogin: "admin456"
lastModifiedDate: "2024-07-15 09:15:00"
lastModifiedByUserLogin: "admin456"
```
### **createPickList**

**Sample JSON**
```
{
  "picklistId": "PL0005",
  "externalId": null, 
  "description": "Urgent Picklist for Backordered Items",
  "facilityId": "FACILITY_B",
  "shipmentMethodTypeId": "OVERNIGHT_SHIPPING",
  "statusId": "PICKLIST_IN_PROGRESS",
  "picklistDate": "2024-07-15T09:15:00",
  "createdByUserLogin": "admin456",
  "lastModifiedByUserLogin": "supervisor789",
  "picklistOrderItems":{
    "orderId": "10000",

  "orderItemSeqId": "00101",

  "inventoryItemId": "10000",

  "itemStatusId": "ITEM_APPROVED",

  "quantity": 1.5
  }
}
```
