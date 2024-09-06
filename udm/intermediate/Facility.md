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

### ProductFacilityLocation
This entity further refines the product-facility relationship by specifying the exact location(s) within a facility where a particular product is stored. It includes details like minimum stock levels and move quantities for each location.

```json
{
    "productId": "10000",
    "minimumStock": 20.0,
    "reorderQuantity": 10.0,
    "daysToShip": 5,
    "facilityId":"100165",
    "productFacilityLocations": [
      {
        "productId": "10000",
        "facilityId":"100165",
        "locationSeqId": "L001",
        "minimumStock": 10.0,
        "moveQuantity": 20.0
      },
      {
        "productId": "10000",
        "facilityId":"100165",
        "locationSeqId": "L002",
        "minimumStock": 15.0,
        "moveQuantity": 30.0
      }
    ]
  }
```

## Explanation

- **productId, productTypeId, productName:** Basic product information.
- **productFacility:** Details about the product's association with the facility.
  - **minimumStock:** Minimum stock level to maintain at the facility.
  - **reorderQuantity:** Quantity to reorder when stock falls below the minimum.
  - **daysToShip:** Estimated shipping time from the facility.
- **productFacilityLocations:** An array specifying where the product is stored within the facility.
  - **locationSeqId:** The location's unique identifier.
  - **minimumStock:** Minimum stock level to maintain at this specific location.
  - **moveQuantity:** Quantity to move when stock at this location falls below the minimum.


### Role of the `FacilityParty` Entity

The `FacilityParty` entity in Apache OFBiz serves as a bridge to connect `Facility` entities (representing physical locations like warehouses or stores) with `Party` entities (representing various business partners, including carriers in this context). It essentially defines the relationship between a facility and the parties that play specific roles within that facility.

**Key Attributes**

*   `facilityId`: The ID of the facility.
*   `partyId`: The ID of the party associated with the facility.
*   `roleTypeId`: The type of role the party plays at the facility (e.g., "CARRIER", "OWNER", "MANAGER").
*   `fromDate` and `thruDate`: The date range during which this association is valid.

**Significance in Shipping Carrier Management**

In the context of shipping and the OMS, the `FacilityParty` entity is crucial for:

1.  **Identifying Carriers at a Facility:** By querying `FacilityParty` with the `roleTypeId` set to "CARRIER," you can retrieve a list of all carriers that are associated with a specific facility. This information is essential when determining which carriers are available to handle shipments originating from that facility.

2.  **Managing Carrier Relationships:** The entity allows you to track the relationships between facilities and carriers, including the specific roles they play. This can be useful for managing contracts, agreements, and other aspects of the business relationship.

3.  **Enabling Rate Shopping:** During the rate shopping process (as seen in the `doRateShopping` service), the system needs to know which carriers are available at the origin facility to request shipping rates from them. The `FacilityParty` entity provides this crucial information.

### Role of the `CarrierShipmentMethod` Entity

The `CarrierShipmentMethod` entity in the standard Apache OFBiz framework serves as a bridge between carriers (`Party` entities with the role "CARRIER") and the shipping methods they offer (`ShipmentMethodType` entities). It allows the system to define and manage the specific shipping services that each carrier provides.

**Key Attributes in Standard OFBiz**

*   `shipmentMethodTypeId`: The ID of the general shipment method type (e.g., "GROUND," "AIR").
*   `partyId`: The ID of the carrier party.
*   `roleTypeId`: The role type of the carrier, typically "CARRIER."
*   `sequenceNumber`: A numeric value to define the order or priority of this method for the carrier.
*   `carrierServiceCode`: A code specific to the carrier that identifies this particular service.

**Relationships in Standard OFBiz**

*   The entity has a one-to-one relationship with `ShipmentMethodType` through the `shipmentMethodTypeId` foreign key.
*   It also has a one-to-one relationship with `Party` (the carrier) through the `partyId` foreign key.
*   Additionally, it has a one-to-one relationship with `PartyRole` to further specify the carrier's role (usually "CARRIER") using both `partyId` and `roleTypeId`.

**HotWax Commerce Custom Extension**

HotWax Commerce extends the `CarrierShipmentMethod` entity by adding a new field:

*   `deliveryDays`: A numeric field to store the estimated number of days it takes for this shipping method to deliver a shipment.

**Significance of the Extension**

This extension enhances the `CarrierShipmentMethod` entity by incorporating crucial information about the expected delivery time for each shipping method offered by a carrier. This information is valuable for:

*   **Rate Shopping and Selection:** During rate shopping, the system can use `deliveryDays` to filter out shipping methods that don't meet the desired Service Level Agreement (SLA) or delivery timeframe.
*   **Customer Communication:** The estimated delivery time can be communicated to the customer, setting clear expectations and improving transparency.
*   **Order Fulfillment Planning:** The system can use `deliveryDays` to plan and optimize the fulfillment process, ensuring timely delivery of shipments.

**Example**

Consider a scenario where a customer wants their order delivered within 3 days. During rate shopping, the system can query `CarrierShipmentMethod` entities and filter them based on the `deliveryDays` field to only consider methods that can fulfill this requirement.

### **ProductStoreShipmentMeth in Apache OFBiz**

In the standard OFBiz framework, the `ProductStoreShipmentMeth` entity serves as a crucial link between a `ProductStore` and the shipping methods it offers to customers. It allows each product store to define and configure the specific shipping options available for its products.

**Key Attributes in Standard OFBiz**

*   `productStoreShipMethId`: A unique identifier for this specific product store shipment method record
*   `productStoreId`: The ID of the product store.
*   `shipmentMethodTypeId`: The ID of the general shipment method type (e.g., "GROUND," "AIR")
*   `partyId`: The ID of the carrier party associated with this method (if applicable).
*   `roleTypeId`: The role type of the carrier, typically "CARRIER."
*   `minWeight`: The minimum weight for which this method is applicable.
*   `maxWeight`: The maximum weight for which this method is applicable.
*   `minSize`: The minimum size for which this method is applicable.
*   `maxSize`: The maximum size for which this method is applicable.
*   `minTotal`: The minimum order total for which this method is applicable.
*   `maxTotal`: The maximum order total for which this method is applicable.
*   `allowUspsAddr`: A flag indicating whether this method allows USPS addresses.
*   `requireUspsAddr`: A flag indicating whether this method requires USPS addresses.
*   `allowCompanyAddr`: A flag indicating whether this method allows company addresses.
*   `requireCompanyAddr`: A flag indicating whether this method requires company addresses.
*   `includeNoChargeItems`: A flag indicating whether to include items with no charge in the calculation.
*   `includeFeatureGroup`: A feature group ID that this method might be associated with.
*   `serviceName`: The name of the service to be used for this method (if applicable).
*   `configProps`: Configuration properties for this method.

**Relationships in Standard OFBiz**

*   The entity has a many-to-one relationship with `ProductStore` through the `productStoreId` foreign key.
*   It has a many-to-one relationship with `ShipmentMethodType` through the `shipmentMethodTypeId` foreign key.
*   It also has an optional many-to-one relationship with `CarrierShipmentMethod` through `shipmentMethodTypeId` and `partyId`, allowing the association of specific carriers with the shipping methods offered by the store.

### **HotWax Commerce Custom Extensions**

HotWax Commerce extends the `ProductStoreShipmentMeth` entity with the following fields:

*   `fromDate` and `thruDate`: These fields define the date range during which this shipping method is valid and available for the product store.
*   `isShippingWeightRequired`: A flag indicating whether shipping weight is required for this method.
*   `isTrackingRequired`: A flag indicating whether tracking is required for this method.

### **Usage in HotWax Commerce**

These extensions serve the following purposes in HotWax Commerce:

*   **Time-Based Availability:** The `fromDate` and `thruDate` fields allow for scheduling the availability of shipping methods, enabling promotions or seasonal offerings.
*   **Shipping Weight Requirement:** The `isShippingWeightRequired` flag can be used to enforce that products have shipping weight information when this method is selected, ensuring accurate rate calculations.
*   **Tracking Requirement:** The `isTrackingRequired` flag can be used to mandate that shipments using this method must have tracking information, enhancing visibility and customer service.

### **Example**

*   A product store might configure a "Free Shipping" method with a `fromDate` and `thruDate` to offer it only during a specific holiday season.
*   Another store might have a "Heavy Item Shipping" method with `isShippingWeightRequired` set to "Y" to ensure accurate shipping costs for heavier products.

