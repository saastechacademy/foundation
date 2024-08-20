**Sample shipment JSON representation**

```json
{
    "shipmentId": "10025",
    "shipmentTypeId": "SALES_SHIPMENT",
    "statusId": "SHIPMENT_INPUT",
    "primaryOrderId": "OR12345",
    "primaryShipGroupSeqId": "00001",
    "partyIdFrom": "COMPANY",
    "partyIdTo": "10001", 
    "originFacilityId": "WAREHOUSE_A",
    "destinationFacilityId": null,
    "originContactMechId": "12345",
    "originTelecomNumberId": "67890",
    "destinationContactMechId": "54321",
    "destinationTelecomNumberId": "09876",
    "estimatedShipCost": 15.99,
    "estimatedReadyDate": "2024-07-15 10:00:00",
    "estimatedShipDate": "2024-07-16 14:30:00",
    "estimatedArrivalDate": "2024-07-20 16:45:00",
    "shipmentItems": [ 
        {
            "productId": "(Optional) String - Product ID",
            "sku": "(Optional) String - Product SKU",
            "quantity": "Number - Quantity of the product"
        }
    ],
    "shipmentPackage": {
         "shipmentPackageSeqId": "00001",
         "boxTypeId": "YOURPACKNG",
         "weight": 5.5,
         "weightUomId": "WT_lb",
         "dimensionUomId": "LEN_in",
         "boxLength": 12,
         "boxHeight": 8,
         "boxWidth": 10,
         "shipmentPackageContents": [
                {
                    "shipmentItemSeqId": "00001",
                    "quantity": 1
                }
            ]
         },
    "shipmentRouteSegments": [
        {
            "shipmentRouteSegmentId": "00001",
            "originFacilityId": "WAREHOUSE_A",
            "destinationFacilityId": "HUB_B",
            "estimatedArrival": "2024-07-17 09:00:00"
        }
    ],
    "orderShipments":[
        {
            "orderId": "OR12345",
            "orderItemSeqId": "001",
            "shipGroupSeqId": "001",
            "shipmentId": "",
            "shipmentItemSeqId": ""
        }
    ]
}
```

### **Comprehensive Data Validation Requirements**

1.  **External Shipment ID (externalId):**

    *   **Uniqueness:** If provided, the `externalId` must be unique within the `Shipment` entity.

2.  **Shipment Type ID (shipmentTypeId):**

    *   **Validity:** If provided, the `shipmentTypeId` must exist in the `ShipmentType` entity.
    *   **Default Value:** If not provided, defaults to "SALES_SHIPMENT".

3.  **Order ID (orderId) and Order External ID (orderExternalId):**

    *   **Existence:** Either `orderId` or `orderExternalId` is required.
    *   **External ID Resolution:** If only `orderExternalId` is provided, the service should fetche the corresponding `orderId`.
    *   **Order Validity:** The `orderId` must exist in the `OrderHeader` entity and match the correct `orderTypeId` ("SALES_ORDER" ).
    *   **Ship Group Validity (Optional):** If `shipGroupSeqId` is provided, it must be valid within the specified order.

5.  **Party IDs (partyIdFrom, externalPartyIdFrom, partyIdTo, externalPartyIdTo):**

    *   **Applicability:** These validations apply only to Sales Shipment (`shipmentTypeId` != "SALES_SHIPMENT").
    *   **Party From:** Either `partyIdFrom` or `externalPartyIdFrom` is required, and it must be valid.
    *   **Party To:** Either `partyIdTo` or `externalPartyIdTo` is required, and it must be valid.

6.  **Facility IDs (originFacilityId, externalOriginFacilityId, destinationFacilityId, externalDestinationFacilityId):**

    *   **Facility Origin:** Either `originFacilityId` or `externalOriginFacilityId` is required, and it must be valid.
    *   **Facility Destination (Optional):** If provided, either `destinationFacilityId` or `externalDestinationFacilityId` must be valid.

7.  **Status ID (status):**

    *   **Validity:** If provided, the `status` must be a valid `statusId` for the "SHIPMENT_STATUS" type.
    *   **Default Value:** If not provided, defaults to "SHIPMENT_INPUT."

8.  **Dates (estimatedReadyDate, estimatedShipDate, estimatedArrivalDate):**

    *   **Format:** If provided, dates must follow specific formats (e.g., "yyyy-MM-dd HH:mm:ss").

9.  **Ship From Information (shipFrom):**

    *   **Postal Address:** If provided, the postal address ID (`id`) or external ID (`externalId`) must be valid.
    *   **Phone Number:** If provided, the phone number ID (`id`) or external ID (`externalId`) must be valid.

10. **Ship To Information (shipTo):**

    *   **Postal Address:** If provided, the postal address ID (`id`) or external ID (`externalId`) must be valid.
    *   **Phone Number:** If provided, the phone number ID (`id`) or external ID (`externalId`) must be valid.

11. **Items (shipmentItems):**

    *   **Product Identification:** For each item, either `productId` or `sku` is required.
    *   **Product/SKU Validity:** The provided `productId` or `sku` must exist in the `Product` entity.

12. **Package (shipmentPackage):**

    *   **Package Details:** For each package, validations are performed for:
        *   `dimensionUomId`: Must be a valid unit of measurement for length.
        *   `weightUomId`: Must be a valid unit of measurement for weight.
        *   `boxTypeId`: If provided, must be a valid shipment box type.
        *   `boxLength`, `boxHeight`, `boxWidth`, `weight`: If provided, must be convertible to BigDecimal.

    *   **Package Items:** If `items` are included within a package, the same validations as for the top-level `items` list are applied.

13. **OrderShipmentItems (OrderShipments):**

    *   **OrderId:** For each item, `orderId`.
    *   **OrderItemSeqid:** 
    *   **ShipGroupSeqId:**
    *   **ShipmentId**
    *   **ShipmentItemSeqId**

**Additional Considerations:**

*   **Default Values:** The service should set default values for `shipmentTypeId`, `statusId`, `boxTypeId`, `weightUomId`, and `dimensionUomId` if they are not provided.
*   **Error Handling:** The service should collects all validation errors and returns them in a consolidated error message if any validation fails.


**BigDecimal Handling in `createSalesShipment`**

The service should take extra care to ensure that numeric values, especially those representing monetary amounts or quantities, are handled using the `BigDecimal` data type. This is crucial for financial calculations to avoid precision errors that can occur with floating-point types like `float` or `double`.

**Data Elements and Parameters Specifically Handled for BigDecimal**

1.  **estimatedShipCost:**

    *   **Input:** The service receives this value from the `shipmentsMap` as an `Object`.
    *   **Conversion:** It should use `ObjectType.simpleTypeConvert` to explicitly convert the input value to a `BigDecimal`, specifying the locale for potential decimal formatting differences.
    *   **Usage:** This `BigDecimal` value is then used when creating the `Shipment` entity.

2.  **boxLength, boxHeight, boxWidth, weight (within packages):**

    *   **Input:** These values are nested within the `packages` list in the `shipmentsMap`.
    *   **Conversion:** Similar to `estimatedShipCost`, the code converts these values to `BigDecimal` using `ObjectType.simpleTypeConvert`.
    *   **Usage:** The converted `BigDecimal` values are used when creating the `ShipmentPackage` entity.

3.  **quantity (within items and packageItems):**

    *   **Input:** These values are found within the `items` and `packageItems` lists.
    *   **Conversion:** Again, `ObjectType.simpleTypeConvert` is used to convert the input quantity to `BigDecimal`.
    *   **Usage:** The `BigDecimal` quantities are used when creating `ShipmentItem` and `ShipmentPackageContent` entities.

**Explanation and Requirements**

*   **Why BigDecimal?**  `BigDecimal` is used for its arbitrary precision, ensuring accurate representation of decimal numbers. This is essential for financial calculations and inventory management where even small errors can accumulate.

*   **Conversion:** The `ObjectType.simpleTypeConvert` method is a utility function in OFBiz that handles the conversion of various data types. In this case, it's used to safely convert the input values (which might be strings, numbers, or other objects) into the desired `BigDecimal` format.

*   **Locale:** The locale is passed to `simpleTypeConvert` to handle potential differences in decimal separators (e.g., "." vs ",").


Prepare data for creating a new `Shipment` entity in the database. Let's break down the data elements it includes, their significance, and any associated rules:

1.  **shipmentId:**

    *   **Significance:** The unique identifier for the new shipment.
    *   **Rule:** It's generated using `delegator.getNextSeqId("Shipment")` to ensure uniqueness.

2.  **externalId:**

    *   **Significance:** An optional external identifier for the shipment, potentially used for integration with other systems.
    *   **Rule:** If provided in the input, it's included as-is.

3.  **shipmentTypeId:**

    *   **Significance:** The type of shipment (e.g., "SALES_SHIPMENT").
    *   **Rule:** If not provided in the input, it defaults to "SALES_SHIPMENT".

4.  **statusId:**

    *   **Significance:** The initial status of the shipment.
    *   **Rule:** If not provided in the input, it defaults to "SHIPMENT_INPUT."

5.  **primaryOrderId:**

    *   **Significance:** The ID of the primary order associated with the shipment.
    *   **Rule:** Included only if the `orderId` is provided in the input.

6.  **picklistBinId:**

    *   **Significance:** The ID of the picklist bin from which items were picked for the shipment.
    *   **Rule:** Included only if the `picklistBinId` is provided in the input.

7.  **primaryShipGroupSeqId:**

    *   **Significance:** The sequence ID of the primary shipment group within the order.
    *   **Rule:** Included only if both `orderId` and `shipGroupSeqId` are provided in the input.

8.  **partyIdFrom:**

    *   **Significance:** The ID of the party (e.g., company) initiating the shipment.
    *   **Rule:** If not provided directly, it's resolved from the `externalPartyIdFrom` if available.

9.  **partyIdTo:**

    *   **Significance:** The ID of the party receiving the shipment (e.g., customer).
    *   **Rule:** If not provided directly, it's resolved from the `externalPartyIdTo` if available.

10. **originFacilityId:**

    *   **Significance:** The ID of the facility from which the shipment originates.
    *   **Rule:** If not provided directly, it's resolved from the `externalOriginFacilityId` if available.

11. **destinationFacilityId:**

    *   **Significance:** The ID of the destination facility (if applicable).
    *   **Rule:** If not provided directly, it's resolved from the `externalDestinationFacilityId` if available.

12. **originContactMechId:**

    *   **Significance:** The contact mechanism ID for the origin's location (e.g., address).
    *   **Rule:** Resolved from the `shipFrom` information in the input if available.

13. **originTelecomNumberId:**

    *   **Significance:** The contact mechanism ID for the origin's phone number.
    *   **Rule:** Resolved from the `shipFrom` information in the input if available.

14. **destinationContactMechId:**

    *   **Significance:** The contact mechanism ID for the destination's location (e.g., address).
    *   **Rule:** Resolved from the `shipTo` information in the input if available.

15. **destinationTelecomNumberId:**

    *   **Significance:** The contact mechanism ID for the destination's phone number.
    *   **Rule:** Resolved from the `shipTo` information in the input if available.

16. **estimatedShipCost:**

    *   **Significance:** The estimated cost of shipping.
    *   **Rule:** Included only if provided in the input.

17. **estimatedArrivalDate, estimatedReadyDate, estimatedShipDate:**

    *   **Significance:** Estimated dates for arrival, readiness, and shipping.
    *   **Rule:** Included only if provided in the input and converted to Timestamp objects.


Enforce constraints on when the status of a shipment can be changed. Prevent invalid status transitions, particularly those that would revert a shipment to an earlier stage after it has reached specific milestones.

**Requirement**

1. **Scenario 1:** If the desired transition is from any status to "SHIPMENT_SHIPPED" and the current status of the `testShipment` is already "SHIPMENT_SHIPPED," the transition is not allowed.

2. **Scenario 2:** If the desired transition is from any status to "SHIPMENT_DELIVERED" and the current status of the `testShipment` is already "SHIPMENT_SHIPPED" or "SHIPMENT_DELIVERED," the transition is not allowed.

**How It Helps Manage Shipment Data**

*   **Prevents Invalid Transitions:** The method enforces business rules that prevent a shipment from moving backward in its lifecycle. Once a shipment is shipped or delivered, it shouldn't be possible to change its status to something that implies it's still in the warehouse.

*   **Data Integrity:** By restricting invalid status changes, the method helps maintain the integrity of the shipment data. It ensures that the status accurately reflects the shipment's progress.

*   **User Guidance:** The error message provides feedback to the user, explaining why the requested operation is not allowed. This helps users understand the system's constraints and make appropriate decisions.

**Example**

Let's say a user tries to change the status of a shipment that's already been marked as "Shipped" back to "Packed." Detect invalid transition, generate an error message like "Cannot perform operation Pack when the shipment is in the Shipped status," and add it to the `error_list`. This prevents the invalid status change and informs the user of the reason.


**Set originContactMechId based on originFacilityId**

1.  **Set Origin Information:**
    *   If the `originFacilityId` is present in the shipment:
        *   If `originContactMechId` is empty, it finds a contact mechanism associated with the origin facility with the purpose "PRIMARY_LOCATION" or "SHIP_ORIG_LOCATION" and sets it as the `originContactMechId`.
        *   If `originTelecomNumberId` is empty, it finds a contact mechanism associated with the origin facility with the purpose "PRIMARY_PHONE" and sets it as the `originTelecomNumberId`.

**How It Helps Manage Shipment Data**

*   **Automation:** The method automates the process of filling in missing contact and telecom information, saving time and reducing manual effort.
*   **Data Completeness:** It ensures that shipments have complete contact information for both origin and destination, which is crucial for communication and tracking.
*   **Accuracy:** By deriving information directly from the associated facilities, it reduces the risk of errors in manually entering contact details.
*   **Efficiency:** The method only updates the shipment if changes were made, avoiding unnecessary database writes.

**Update shipment details based on the primary order associated with it**

1.  **Retrieve Shipment and Order Data:**
    *   If `Shipment.primaryOrderId` and `primaryShipGroupSeqId` are present in the shipment, fetch the corresponding `OrderHeader` and `OrderItemShipGroup` entities. These entities hold details about the order and the specific group of items within the order that the shipment is fulfilling.

1.  **Set Shipment Type:**
    *   Determines the `shipmentTypeId` based on the `orderTypeId` of the associated order:
        *   If the order is a "SALES_ORDER," the shipment type is set to "SALES_SHIPMENT."
 
2.  **Set Origin Facility (For Store Shipments):**
    *   If the shipment is a "SALES_SHIPMENT" from a store with a single inventory facility, and the `originFacilityId` is not already set, retrieve the `ProductStore` entity and set the `originFacilityId` to the store's `inventoryFacilityId`.

3.  **Set Party Information (From/To):**
    *   Fetche `OrderRole` entities associated with the order.
    *   If `partyIdFrom` (the party shipping the goods) is not set, try to find it from the order roles with the "SHIP_FROM_VENDOR" role types.
    *   If `partyIdTo` (the party receiving the goods) is not set, try to find it from the order roles with the "SHIP_TO_CUSTOMER" or "CUSTOMER" role types.

4.  **Set Contact Information:**
    *   Fetche `OrderContactMech` entities associated with the order.
    *   If `destinationContactMechId` (shipping address) is not set, it tries to find it from the order contact mechanisms with the "SHIPPING_LOCATION" purpose.
    *   If `originContactMechId` is not set, it tries to find it from the order contact mechanisms with the "SHIP_ORIG_LOCATION" purpose.
    *   Similary set `destinationTelecomNumberId` and `originTelecomNumberId` (phone numbers).

5.  **Handle Special Case for Store Pickup:**
    *   If the order is a "SALES_ORDER" and the shipment method is "STOREPICKUP," the `destinationContactMechId` is set to the same value as `originContactMechId`.

6. **Create Shipment Route Segment:**
    *   If no `ShipmentRouteSegment` exists for the shipment, it create one using the gathered information (origin/destination facilities, contact mechanisms, shipping method, carrier, etc.).

**Prepare data for ShipmentItem**

1.  **Extraction of Item Details:**

    *   For each item in the `Shipmentitems` :
        *   `productId`: The ID of the product to be included in the shipment.
        *   `sku`: The SKU (Stock Keeping Unit) of the product, which can be used to look up the `productId` if it's not provided directly.
        *   `itemSeqId`: A sequence ID for the shipment item, likely used for ordering or identification within the shipment.
        *   `orderItemSeqId`: The sequence ID of the corresponding order item from the original order.
        *   `quantity`: The quantity of the product to be included in the shipment.

2.  **Product ID Resolution:**

    *   If the `productId` is not provided but the `sku` is,  lookup database in the `Product` entity to find the corresponding `productId` based on the `internalName` (which is assumed to be the SKU).

3.  **Data Conversion:**

    *   The `quantity` value, which might be provided as a string or another numeric type, is explicitly converted to a `BigDecimal` using `ObjectType.simpleTypeConvert`. This ensures accurate representation of quantities, especially for fractional values.

**Rules and Error Handling:**

*   **Required Fields:** Either `productId` or `sku` is required for each item. If both are missing, an error is added to the `errorList`.
*   **Valid Product:** The provided `productId` or the `productId` derived from the `sku` must exist in the `Product` entity. If not, an error is added to the `errorList`.
*   **Quantity Conversion:** The `quantity` must be convertible to a `BigDecimal`. While the code doesn't explicitly handle a `NumberFormatException`, it's good practice to add error handling for this scenario.

### **Prepares data to  `createOrderShipment`**

2.  **Order and Ship Group Information:**
    *   Check if both `orderId` (the ID of the order) and `shipGroupSeqId` (the sequence ID of the shipment group within the order) are available. If so, it proceeds to create `OrderShipment` entities.

3.  **Order Shipment Context Creation:**
    *   A `createOrderShipmentCtx` map is created to hold the data for the `createOrderShipment` service call.
    *   The map is populated with the following key-value pairs:
        *   `"shipmentId"`: The ID of the shipment.
        *   `"shipmentItemSeqId"`: The sequence ID of the shipment item obtained in step 1.
        *   `"orderId"`: The ID of the order.
        *   `"userLogin"`: The userLogin object representing the user performing the operation.

4.  **OrderItemShipGroup Retrieval:**
    *   The code queries the database for an `OrderItemShipGroup` entity that matches the `orderId`, `productId` (of the current item), `shipGroupSeqId`, and has a `statusId` of either "ITEM_APPROVED" or "ITEM_CREATED."
    *   This entity represents the association between an order item and a shipment group.

6.  **Order Shipment Creation:**
    *   If an `OrderItemShipGroup` entity is found, use `shipGroupSeqId` and `orderItemSeqId`.

1.  **Package Details Extraction:**
    *   Package as following details:
        *   `boxTypeId`: The type of box used for the package.
        *   `packageSeqId`: A sequence ID for the package, likely used for ordering or identification within the shipment.
        *   `dimensionUomId`: The unit of measurement for the package dimensions (e.g., "LEN_in" for inches).
        *   `weightUomId`: The unit of measurement for the package weight (e.g., "WT_lb" for pounds).
        *   `boxLength`, `boxHeight`, `boxWidth`, `weight`: The dimensions and weight of the package.
        *   `items`: A list of items included in the package (this is used later for creating `ShipmentPackageContent` entities).

2.  **Default Values and Conversions:**
    *   If `boxTypeId` is not provided, it defaults to a value from the configuration ("YOURPACKNG" in this case).
    *   If `weightUomId` is not provided, it tries to get it from the origin facility's default or a system-wide default ("WT_lb").
    *   If `dimensionUomId` is not provided, it defaults to a system-wide default ("LEN_in").
    *   The `boxLength`, `boxHeight`, `boxWidth`, and `weight` values are converted to `BigDecimal` for precision.

3.  **Shipment Package Context Creation:**
    *   A `shipmentPackage` map is created to hold the data for the `ShipmentPackage`.
    *   The map is populated with the following key-value pairs:
        *   `"shipmentId"`: The ID of the shipment.
        *   `"shipmentPackageSeqId"`: The sequence ID of the package.
        *   `"boxLength"`, `"boxHeight"`, `"boxWidth"`, `"weight"`: The package dimensions and weight (as `BigDecimal`).
        *   `"shipmentBoxTypeId"`: The type of box.
        *   `"dimensionUomId"`: The unit of measurement for dimensions.
        *   `"weightUomId"`: The unit of measurement for weight.
        *   `"userLogin"`: The userLogin object representing the user performing the operation.

**Rules and Error Handling:**

*   **Dimension and Weight UoM Validation:** The `dimensionUomId` and `weightUomId` are validated against the `Uom` entity to ensure they are valid units of measurement for length and weight, respectively.
*   **Box Type Validation:** If `boxTypeId` is provided, it's validated against the `ShipmentBoxType` entity.


The code that prepares data `ShipmentPackageContent`: 

1.  **Outer Loop (Packages):** Iterates over each package in the `packages` list from the input.

2.  **Inner Loop (Package Items):** Iterates over the `items` list within each package.

1.  **Shipment and Package IDs:**
    *   The `shipmentId` (of the overall shipment) and `shipmentPackageSeqId` (of the current package) are obtained from the outer scope.

2.  **Product ID Resolution:**
    *   For each item in the package, the code checks if `productId` is provided. If not, and `sku` is available, it fetche the corresponding `productId` from the `Product` entity using the `internalName` (assumed to be the SKU).

3.  **Shipment Item Sequence ID Resolution:**
    *   If `shipmentItemSeqId` (the sequence ID of the shipment item) is not provided, find it by querying the `ShipmentItem` entity based on the `shipmentId` and `productId`. This assumes that the `ShipmentItem` entities were already created earlier.

4.  **Quantity Conversion:**
    *   If the `quantity` of the item in the package is provided, it's converted to a `BigDecimal` for precision.

5.  **Context Map Creation:**
    *   the `shipmentPackageContent` map is populated with:
        *   `"shipmentId"`
        *   `"shipmentPackageSeqId"`
        *   `"shipmentItemSeqId"` (if found)
        *   `"quantity"` (if provided and converted to `BigDecimal`)

**Rules and Error Handling:**

*   **Product ID or SKU Required:** Either `productId` or `sku` must be provided for each item in the package.
*   **Valid Product:** The `productId` (whether provided directly or derived from the `sku`) must exist in the `Product` entity.
*   **Shipment Item Existence:** The `shipmentItemSeqId` must correspond to an existing `ShipmentItem` within the shipment.




**Key Points and Explanations:**

*   **Shipment:**  Core shipment details like ID, type, status, order information, parties involved, facility information, contact information, estimated cost, and dates.
*   **shipmentStatus:** An array to capture the history of status changes for the shipment. In this sample, it only has the initial "SHIPMENT_INPUT" status.
*   **shipmentItems:** An array listing the items in the shipment with their quantities.
*   **shipmentPackages:** An array of packages, each with details like dimensions, weight, box type, and a list of its contents (`shipmentPackageContents`).
*   **shipmentRouteSegments:** An array defining the route segments (legs) of the shipment, with origin/destination facilities and estimated arrival times.

**Additional Notes:**

*   The `OrderItemShipGroupAssoc` and `ItemIssuance` entities are not included in this JSON structure as they would be created and managed separately within the system.
*   The actual values in this JSON are placeholders. You'd replace them with real data based on your specific shipment. 
*   The structure aligns with the entity relationships defined in the ER diagram

