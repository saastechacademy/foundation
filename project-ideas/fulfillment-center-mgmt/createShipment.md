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
            "estimatedArrival": "2024-07-17 09:00:00",
            "shipmentPackageRouteSeg": [
                {
                "shipmentPackageSeqId": "00001", 
                "trackingCode": "TRACK12345", 
                "boxNumber": "BOX001",
                "labelImage": null, 
                "labelIntlSignImage": null, 
                "labelHtml": "<html>...</html>", 
                "labelPrinted": "N", 
                "internationalInvoice": null, 
                "packageTransportCost": 5.0, 
                "packageServiceCost": 2.5, 
                "packageOtherCost": 0.5, 
                "codAmount": 0.0, 
                "insuredAmount": 50.0, 
                "currencyUomId": "USD",
                "labelImageUrl": "https://example.com/label10025.png",
                "internationalInvoiceUrl": null,
                "packagePickupPrn": "PICKUP123",
                "packagePickupDate": "2024-07-16 08:30:00",
                "gatewayMessage": "Package accepted by carrier",
                "gatewayStatus": "SUCCESS"
                }
            ]
        },
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

2.  **Shipment Type ID (shipmentTypeId):**

    *   **Validity:** If provided, the `shipmentTypeId` must exist in the `ShipmentType` entity.
    *   **Default Value:** If not provided, defaults to "SALES_SHIPMENT".

3.  **Order ID (orderId) and Order External ID (orderExternalId):**

    *   **External ID Resolution:** If only `orderExternalId` is provided.
    *   **Ship Group Validity (Optional):** 

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
