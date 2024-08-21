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
         "boxWidth": 10
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
            "shipmentId": "10025",
            "shipmentItemSeqId": "001"
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

13. **OrderShipments (orderShipments):**

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


Prepare data for creating a new `Shipment` entity in the database. Let's break down the data elements it includes, their significance, and any associated rules:

1.  **shipmentId:**

    *   **Significance:** The unique identifier for the new shipment.
    *   **Rule:** It's generated using `delegator.getNextSeqId("Shipment")` to ensure uniqueness.

2.  **externalId:**

    *   **Significance:** An optional external identifier for the shipment, potentially used for integration with other systems.
    *   **Rule:** If provided in the input, it's included as-is.

4.  **statusId:**

    *   **Significance:** The initial status of the shipment.
    *   **Rule:** If not provided in the input, it defaults to "SHIPMENT_INPUT."

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

3.  **Order Shipment Context Creation:**
    *   A `createOrderShipmentCtx` map is created to hold the data for the `createOrderShipment` service call.
    *   The map is populated with the following key-value pairs:
        *   `"shipmentId"`: The ID of the shipment.
        *   `"shipmentItemSeqId"`: The sequence ID of the shipment item obtained in step 1.
        *   `"orderId"`: The ID of the order.
        *   `"orderItemSeqId":` 
        *   `"userLogin"`: The userLogin object representing the user performing the operation.

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

