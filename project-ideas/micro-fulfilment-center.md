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

