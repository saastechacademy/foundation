**API Design for Inventory Management Application in Apache OFBiz**

**Data Model**

The core entities used for modeling facility and location information in our inventory management application are:

*   **Facility:** Represents a physical location where inventory is stored.
    *   **facilityId** (Primary Key): Unique identifier for the facility.
    *   **facilityTypeId:** Type of facility (e.g., "RETAIL_STORE", "WAREHOUSE").
    *   **facilityName:** Name of the facility.

*   **FacilityLocation:** Represents a specific location within a facility where inventory can be stored (e.g., aisles, shelves, bins).
    *   **locationSeqId** (Primary Key): Unique identifier for the location within the facility.
    *   **locationTypeEnumId:** Type of location (e.g., "FLT_PICKLOC" for picking locations, "FLT_BULK" for bulk storage locations).
    *   **areaId**, **aisleId**, **sectionId**: Additional identifiers for organizing locations within the facility.

**Sample JSON Data for a Retail Store Facility**

```
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
**Explanation:**

*   **facilityId:** A unique identifier for the facility.
*   **facilityTypeId:** Indicates the type of facility, in this case, "RETAIL\_STORE".
*   **facilityName:** A descriptive name for the facility.
*   **facilityLocations:** An array containing details of each `FacilityLocation` within the facility.
    *   **locationSeqId:** A unique sequence ID for the location within the facility.
    *   **locationTypeEnumId:** The type of location, here it's "FLT\_PICKLOC" for all locations, indicating they are primary picking locations.
    *   **areaId:** Identifies the area within the facility (e.g., "A", "B", "C").
    *   **aisleId:** Identifies the aisle within the area (e.g., "01", "02").
    *   **sectionId:** Identifies the section within the aisle (e.g., "01", "02").


**Data model Product, association with Facility and storage location in the Facility**

*   **Product:** This entity stores the main details of a product, such as its ID, type, name, description, and various attributes like weight, dimensions, and images.

*   **ProductFacility:** This entity establishes the relationship between a product and a facility, indicating that the product is stocked or available at that facility. It also includes additional information like minimum stock levels, reorder quantities, and estimated shipping days.

*   **ProductFacilityLocation:** This entity further refines the product-facility relationship by specifying the exact location(s) within a facility where a particular product is stored. It includes details like minimum stock levels and move quantities for each location.

**Sample JSON Data for Products in a Facility**

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

**Explanation:**

*   **facilityId, facilityTypeId, facilityName:** Same as before, representing the retail store.
*   **products:** An array containing details of each product.
    *   **productId, productTypeId, productName:** Basic product information.
    *   **productFacility:** Details about the product's association with the facility.
        *   **minimumStock:** Minimum stock level to maintain at the facility.
        *   **reorderQuantity:** Quantity to reorder when stock falls below the minimum.
        *   **daysToShip:** Estimated shipping time from the facility.
    *   **productFacilityLocations:** An array specifying where the product is stored within the facility.
        *   **locationSeqId:** The location's unique identifier.
        *   **minimumStock:** Minimum stock level to maintain at this specific location.
        *   **moveQuantity:** Quantity to move when stock at this location falls below the minimum.
     


**The core entities used for modeling inventory are:**

*   **InventoryItem:** Represents a specific item in inventory, tracking its quantity, location, status, and other details.
    *   **inventoryItemId** (Primary Key): Unique identifier for the inventory item.
    *   **inventoryItemTypeId:** Type of inventory item (e.g., raw material, finished good).
    *   **productId:** The product associated with the inventory item.
    *   **statusId:** Current status of the inventory item (e.g., available, on hold).
    *   **facilityId:** The facility where the item is located.
    *   **locationSeqId:** The specific location within the facility.
    *   **lotId:** The lot or batch the item belongs to.
    *   **quantityOnHandTotal:** Total quantity of the item on hand.
    *   **availableToPromiseTotal:** Quantity available for reservation or sale.
    *   **accountingQuantityTotal:** Quantity used for accounting purposes.
    *   **unitCost:** Cost per unit of the item.
    *   **currencyUomId:** Currency of the unit cost.

*   **InventoryItemType:** Defines different types of inventory items.
    *   **inventoryItemTypeId** (Primary Key): Unique identifier for the inventory item type.
    *   **parentTypeId:** Allows for hierarchical categorization of item types.
    *   **description:** Description of the item type.

*   **InventoryItemDetail:** Records changes in inventory item quantities and other details over time.
    *   **inventoryItemId** (Primary Key): References the associated inventory item.
    *   **inventoryItemDetailSeqId** (Primary Key): Unique sequence ID for each detail record.
    *   **effectiveDate:** Date and time when the change occurred.
    *   **quantityOnHandDiff, availableToPromiseDiff, accountingQuantityDiff:** Changes in quantities.
    *   **reasonEnumId:** Reason for the change (e.g., sale, adjustment).

*   **ItemIssuance:** Represents the issuance of inventory items for various purposes (e.g., production, shipment).
    *   **itemIssuanceId** (Primary Key): Unique identifier for the issuance.
    *   **inventoryItemId:** The inventory item being issued.
    *   **quantity:** Quantity issued.

*   **InventoryItemVariance:** Tracks discrepancies between expected and actual inventory quantities during physical inventory counts.
    *   **inventoryItemId** (Primary Key): References the associated inventory item.
    *   **physicalInventoryId** (Primary Key): References the physical inventory count.
    *   **varianceReasonId:** Reason for the variance.
    *   **availableToPromiseVar, quantityOnHandVar:** Variance amounts.

*   **PhysicalInventory:** Represents a physical inventory count event.
    *   **physicalInventoryId** (Primary Key): Unique identifier for the count.
    *   **physicalInventoryDate:** Date of the count.

*   **VarianceReason:** Provides reasons for inventory variances.
    *   **varianceReasonId** (Primary Key): Unique identifier for the reason.
    *   **description:** Description of the reason.

**InventoryItem and InventoryItemDetail sample data**

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

**Explanation:**

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


**Validate Reset Inventory` input data provided for resetting inventory levels** 

**Purpose**

The primary purpose is to prevent errors and inconsistencies in inventory data by checking the following:

1.  **Product Identification:** Ensures that either a valid `productId` or `sku` (Stock Keeping Unit) is provided to identify the product whose inventory is being reset. Check if the product exists in the system and is not a virtual product (as virtual products don't have physical inventory).

2.  **Facility Identification:** Verify that a valid `facilityId` (or its external identifier, `externalFacilityId`) is provided to identify the facility where the inventory is located. Check if the facility exists in the system.

3.  **Location Identification:** If a `locationSeqId` is provided, it check if this location exists within the specified facility. This is important for tracking inventory at a granular level within a warehouse.

4.  **Quantity:** Checks if a valid `quantity` (or its deprecated alias, `availableQty`) is provided. This quantity represents the new inventory level to which the existing inventory will be reset.

**Error Handling**

If any of the validation checks fail, return an error message indicating the specific issue(s) found in the input data. This helps in identifying and correcting errors before proceeding with inventory updates.

**Input Parameters**

The service expects a map called `context` containing the following key-value pairs:

*   `locale`: The locale for error messages.
*   `payload`: A map containing the inventory data to be validated:
    *   `facilityId` (or `externalFacilityId`): The ID of the facility.
    *   `locationSeqId`: The ID of the location within the facility (optional).
    *   `productId` (or `sku`): The ID or SKU of the product.
    *   `quantity` (or `availableQty`): The new inventory quantity.

**Output**

The service returns a map with the following possible outcomes:

*   **Success:** If all validations pass, it returns a success message.
*   **Error:** If any validation fails, it returns an error message detailing the specific validation failures.

**Code Analysis**

Perform the following steps:

3.  **Product Validation:**
    *   Checks if either `productId` or `sku` is provided.
    *   If `productId` is provided, fetche the product from the database and checks if it's virtual.
    *   If `sku` is provided, find the corresponding `productId` and checks if the product is virtual.
    *   If the product is virtual, it adds an error message.
4.  **Facility Validation:**
    *   Check if either `facilityId` or `externalFacilityId` is provided.
    *   If `facilityId` is provided, it check if the facility exists.
    *   If `externalFacilityId` is provided, find the corresponding `facilityId` and checks if the facility exists.
    *   If neither facility ID is valid, it adds an error message.
5.  **Location Validation:**
    *   If `locationSeqId` is provided, it checks if the location exists within the specified facility.
    *   If the location is invalid, it adds an error message.
6.  **Quantity Validation:**
    *   Checks if either `quantity` or `availableQty` is provided.
    *   If neither is provided, it adds an error message.
7.  **Error Handling:**
    *   If any error messages were added, it returns an error result with the list of errors.
8.  **Success:** If all validations pass, it returns a success result.

**Example Usage in API**

In a REST API, you could use this service as follows:

1.  **Receive Request:** Get inventory data from the request body (JSON).
2.  **Call Service:** Pass the data to the `validateResetInventory` service.
3.  **Handle Response:**
    *   If successful, proceed with updating the inventory.
    *   If an error is returned, send an appropriate error response to the client with the validation failure details.

The `validateResetInventory` service is a crucial component in the inventory management system. It ensures that any request to modify inventory levels is accurate and valid before any changes are made. This helps maintain data integrity and prevent errors that could disrupt operations.

**Business Purpose**

The primary goal of this service is to validate the following aspects of an inventory reset request:

1.  **Product Identification:** The service confirms that the product whose inventory is being adjusted is correctly identified. This can be done using either the unique product ID or the product's SKU (Stock Keeping Unit). It also checks if the product is a physical item, as virtual products don't have inventory levels.

2.  **Facility Identification:** The service verifies that the facility where the inventory is located is accurately specified. This is done by checking the facility ID, which could be an internal identifier or an external code.

3.  **Location Identification (Optional):** If the inventory is stored in a specific location within the facility (like a shelf or bin), the service confirms the validity of this location ID. This is important for fine-grained inventory tracking.

4.  **Quantity:** The service ensures that a valid quantity is provided for the new inventory level. This quantity cannot be blank or invalid.

**Why Validation is Important**

Without proper validation, incorrect or incomplete data could lead to several problems:

*   **Incorrect Inventory Levels:** Adjusting the inventory of the wrong product or at the wrong location could lead to discrepancies between the system records and the actual physical inventory.
*   **Operational Disruptions:** If inventory levels are inaccurate, it can lead to stockouts, overstock situations, and delays in fulfilling orders.
*   **Financial Losses:** Inaccurate inventory data can result in incorrect financial reporting, impacting profitability and decision-making.

**How it Works**

The service takes the inventory reset request data as input. It then performs a series of checks to ensure the validity of the product, facility, location (if provided), and quantity. If any of these checks fail, the service returns a detailed error message explaining the issue. Only if all validations pass does the service allow the inventory update process to proceed.

**Benefits**

By using the `validateResetInventory` service, businesses can:

*   **Improve Data Accuracy:** Ensure that inventory data is consistently accurate and reliable.
*   **Prevent Errors:** Avoid costly mistakes caused by invalid inventory adjustments.
*   **Streamline Operations:** Facilitate smooth inventory management processes by catching errors early.
*   **Enhance Decision-Making:** Provide confidence in the inventory data used for decision-making.

Overall, this validation service plays a critical role in maintaining the integrity of inventory data, which is essential for efficient and profitable business operations.

