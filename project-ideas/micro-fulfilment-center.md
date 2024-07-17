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

The `PhysicalInventory` and `InventoryItemVariance` entities work together to manage and track discrepancies in inventory levels during physical inventory counts, with the `VarianceReason` entity providing context for those discrepancies.

### **PhysicalInventory**

*   Represents a specific physical inventory count event.
*   Key attributes:
    *   `physicalInventoryId` (Primary Key): Unique identifier for the inventory count.
    *   `physicalInventoryDate`: Date and time of the count.
    *   `partyId`: The person responsible for conducting the count.
    *   `generalComments`: General notes or observations about the count.

### **InventoryItemVariance**

*   Represents a discrepancy found for a specific inventory item during a physical inventory count.
*   Key attributes:
    *   `inventoryItemId` (Primary Key): The ID of the inventory item with the variance.
    *   `physicalInventoryId` (Primary Key): The ID of the associated physical inventory count.
    *   `varianceReasonId`: The reason for the variance, referencing the `VarianceReason` entity.
    *   `availableToPromiseVar`: The difference between the expected and actual available-to-promise (ATP) quantity.
    *   `quantityOnHandVar`: The difference between the expected and actual quantity on hand (QOH).
    *   `comments`: Additional notes about the variance.

### **VarianceReason**

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

### **How They Work Together**

1.  **Physical Inventory Count:** A `PhysicalInventory` record is created to document the count.
2.  **Variance Discovery:** If a discrepancy is found for an item, an `InventoryItemVariance` record is created, linked to the `PhysicalInventory` and the specific `InventoryItem`.
3.  **Reason Assignment:** The `varianceReasonId` in the `InventoryItemVariance` record is set to the appropriate reason from the `VarianceReason` entity.
4.  **Variance Recording:** The `availableToPromiseVar` and `quantityOnHandVar` fields are populated with the differences in ATP and QOH quantities, respectively.
5.  **Analysis and Action:** The variances are analyzed to identify patterns and trends. Corrective actions are taken based on the variance reasons (e.g., security measures for theft, improved handling for damage).

### **Business Requirement Fulfillment**

*   **Accurate Inventory Records:** Identifying and correcting variances ensures accurate inventory data.
*   **Loss Prevention and Root Cause Analysis:** Variance reasons help pinpoint the causes of discrepancies, enabling targeted loss prevention measures.
*   **Operational Efficiency:** Accurate inventory data supports efficient operations like order fulfillment and production planning.
*   **Financial Reporting:** Reliable inventory data is essential for accurate financial reports.

By leveraging these entities and their relationships, businesses can effectively manage inventory discrepancies, improve accuracy, and optimize inventory processes. The `VarianceReason` entity adds valuable context to variances, facilitating informed decision-making and targeted actions to address inventory issues.

**Sample data**

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

**Explanation:**

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



### **packShipment**

**Detailed Logic**

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


**Java Code Skeleton**

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

**Key Corrections:**

*   **Shipment Status:** The precondition is now correctly checked for `SHIPMENT_APPROVED`, and the postcondition updates the status to `SHIPMENT_PACKED`.
*   **OFBiz Conventions:** The code adheres to OFBiz conventions for entity queries and updates.
