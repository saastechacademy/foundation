# **Facility Management API**

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

## Sample JSON Data for Products in a Facility

```json
[
  {
    "productId": "P100",
    "facilityId": "23763",
    "minimumStock": 10,
    "reorderQuantity": 50,
    "daysToShip": 3,
    "lastInventoryCount": 120
  },
  {
    "productId": "P200",
    "facilityId": "23763",
    "minimumStock": 5,
    "reorderQuantity": 30,
    "daysToShip": 2,
    "lastInventoryCount": 85
  }
]
```
### ProductFacilityLocation
This entity further refines the product-facility relationship by specifying the exact location(s) within a facility where a particular product is stored. It includes details like minimum stock levels and move quantities for each location.

```json
[
  {
    "productId": "P100",
    "facilityId": "23763",
    "locationSeqId": "ZONE1", 
    "minimumStock": 5,       
    "moveQuantity": 10       
  },
  {
    "productId": "P100",
    "facilityId": "23763",
    "locationSeqId": "ZONE2", 
    "minimumStock": 8,       
    "moveQuantity": 15       
  },
  {
    "productId": "P200",
    "facilityId": "23763",
    "locationSeqId": "SHELF1",
    "minimumStock": 2,       
    "moveQuantity": 5        
  }
]
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
