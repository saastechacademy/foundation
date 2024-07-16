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

