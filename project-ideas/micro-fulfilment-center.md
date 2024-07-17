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

### **unpackOrderItems**

**Detailed Logic**

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

**Java Code Skeleton**

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

**Key Changes from `unpackOrderItems`:**

*   **Input:** Takes `shipmentId` instead of `orderId` and `picklistBinId`.
*   **Shipment Status Update:** Updates the shipment status to `SHIPMENT_APPROVED` instead of `SHIPMENT_CANCELLED`.
*   **PicklistItem Query:** The query for `PicklistItem` is modified to filter by `shipmentId` (obtained from `OrderShipment`) instead of `picklistBinId`.

### **reinitializeShipment**

The `reinitializeShipment` service is designed to reset a shipment to its initial state, specifically to the `SHIPMENT_INPUT` status. This is often done when modifications need to be made to a shipment after it has been approved or partially processed.

**Input Parameters**

*   `shipmentId` (String): The ID of the shipment that needs to be reinitialized.

**Use Cases**

This service is typically used in scenarios where:

*   **Item Rejection:** When an item within a shipment is rejected, the shipment might need to be reinitialized to allow for adjustments and potential reassignment of items.
*   **Shipment Modification:** If there are changes to the shipment details (e.g., shipping address, carrier), reinitializing the shipment can reset it to a state where these changes can be made.
*   **Error Correction:** If an error occurred during the initial shipment processing, reinitializing can provide a clean slate to correct the issue.
*   **Updating package box types:** In the `updateInProgressOrder` function, if the shipment label hasn't been generated or the box type has changed, the shipment is reinitialized.
*   **Processing ready-to-pack items:** In the `updateInProgressOrder` function, if an item needs to be moved to a different shipment, both the original and new shipments are reinitialized.
*   **Handling item rejections:** In the `updateInProgressOrder` function, the shipment is reinitialized for items with specific rejection reasons.

**Workflow**

1.  **Fetch Shipment Details:** The service retrieves the shipment record from the database using the provided `shipmentId`.

2.  **Fetch Order Item Ship Group:** It retrieves the associated `OrderItemShipGroup` record to determine the original `carrierPartyId` (the carrier responsible for the shipment) and `shipmentMethodTypeId` (the method of shipment).

3.  **Update Shipment:**
    *   The shipment's `statusId` is changed to `SHIPMENT_INPUT`.
    *   The original `carrierPartyId` and `shipmentMethodTypeId` are restored to the shipment record.

4.  **Update Shipment Route Segments:**
    *   If the shipment has associated route segments (`ShipmentRouteSegment`), the service updates them as well.
    *   The `shipmentMethodTypeId` and `carrierPartyId` of each route segment are set to the original values retrieved in step 2.

**Key Points**

*   The service focuses on resetting the shipment status and restoring original shipping details.
*   It ensures consistency by updating both the shipment and its associated route segments.
*   It provides a way to revert a shipment to an editable state for further modifications.


### **cancelOrderItemInvResQty**
The `cancelOrderItemInvResQty` service in the Apache OFBiz framework is designed to handle the cancellation of inventory reservations associated with a specific order item. Inventory reservations are typically made when an order is placed to ensure that the required quantity of a product is available for fulfillment.

**Purpose**

The primary goal of this service is to adjust inventory reservations and potentially release reserved inventory back into the available pool. This is crucial in scenarios where an order item is canceled, modified, or rejected, and the reserved inventory needs to be updated accordingly.

**Workflow**

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

**Key Points**

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


### **rejectOrderItem**

The "Process Non-Kit Item Rejection" of the `rejectOrderItem`.

**Purpose**

This section of the code handles the rejection of individual order items that are not part of a kit (i.e., standalone products). The goal is to update the order item's association with the shipment group, adjust inventory levels, and log the rejection.

**Workflow**

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

**Key Points**

*   **Targeted Rejection:** The service focuses on rejecting only the specified order item within the given ship group(s).
*   **Inventory and Order Management:** It handles inventory reservation cancellations, facility changes, and order history updates.
*   **Integration with Other Services:** It relies on other services like `cancelOrderItemInvResQty` and `createUpdateExternalFulfillmentOrderItem` to perform specific actions.
*   **Flexibility:** It can handle both partial and full rejections of an order item's quantity.

Let me know if you have any other questions.
