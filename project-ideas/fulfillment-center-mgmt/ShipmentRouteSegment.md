### ShipmentPackageRouteSeg

*   **Purpose:** The `ShipmentPackageRouteSeg` entity connects `ShipmentPackage` and the specific route segments (`ShipmentRouteSegment`) they traverse during transit.

*   **Key Attributes:**
    *   `shipmentId`, `shipmentPackageSeqId`, `shipmentRouteSegmentId`: These form the primary key, uniquely identifying each record and linking it to the corresponding shipment, package, and route segment.
    *   `trackingCode`: The tracking code assigned to the package for this route segment.
    *   `boxNumber`: An identifier for the box or container within the package.
    *   `labelImage`, `labelIntlSignImage`: Byte arrays to store images of the shipping label and any international shipping signs.
    *   `labelHtml`: HTML representation of the shipping label.
    *   `labelPrinted`: An indicator to track if the label has been printed.
    *   `internationalInvoice`: A byte array for storing the international commercial invoice if applicable.
    *   `packageTransportCost`, `packageServiceCost`, `packageOtherCost`: Costs associated with the package for this route segment, including transport, service, and other miscellaneous costs.
    *   `codAmount`: The amount to be collected on delivery (Cash On Delivery).
    *   `insuredAmount`: The insured value of the package.
    *   `currencyUomId`: The currency used for the cost and insured amount values.

*   **Relationships:**
    *   The entity has relationships with:
        *   `ShipmentPackage`: Links to the specific package within the shipment.
        *   `Shipment`: Links to the overall shipment.
        *   `ShipmentRouteSegment`: Links to the specific route segment the package is on.
        *   `Uom`: Links to the unit of measurement for the currency used.

*   **HotWax Commerce Extensions:**
    *   `labelImageUrl`: A URL pointing to the shipping label image.
    *   `internationalInvoiceUrl`: A URL pointing to the international commercial invoice.
    *   `packagePickupPrn`: An ID related to the package pickup process.
    *   `packagePickupDate`: The date and time of the package pickup.
    *   `gatewayMessage` and `gatewayStatus`: Information about the status and any messages from the shipping gateway integration.

**Detailed Implementation**
    *   GET, PUT, POST, DELETE Rest resources.

**ShipmentRouteSegment**

*   **Purpose:** The `ShipmentRouteSegment` It stores details about this specific segment, including:
    *   Origin and destination facilities
    *   Carrier information
    *   Shipping method
    *   Estimated and actual shipment dates
    *   Costs associated with the segment
    *   Tracking details
    *   Other relevant attributes

*   **Key Attributes:**
    *   `shipmentId`, `shipmentRouteSegmentId`: Primary keys identifying the shipment and the specific route segment
    *   `deliveryId`: If applicable, links to the `Delivery` entity
    *   `originFacilityId`, `destFacilityId`: IDs of the origin and destination facilities
    *   `originContactMechId`, `destContactMechId`: Contact information for origin and destination
    *   `originTelecomNumberId`, `destTelecomNumberId`: Telecom contact information
    *   `carrierPartyId`: The carrier responsible for this segment
    *   `shipmentMethodTypeId`: The type of shipping method used
    *   `carrierServiceStatusId`: The status of the carrier service
    *   `carrierDeliveryZone`, `carrierRestrictionCodes`, `carrierRestrictionDesc`: Carrier-specific details
    *   `billingWeight`, `billingWeightUomId`: Weight used for billing and its unit of measurement
    *   `actualTransportCost`, `actualServiceCost`, `actualOtherCost`, `actualCost`, `currencyUomId`: Cost breakdown
    *   `actualStartDate`, `actualArrivalDate`, `estimatedStartDate`, `estimatedArrivalDate`: Date/time information
    *   `trackingIdNumber`, `trackingDigest`: Tracking details
    *   `updatedByUserLoginId`, `lastUpdatedDate`: Last update information
    *   `homeDeliveryType`, `homeDeliveryDate`: Home delivery details (if applicable)
    *   `thirdPartyAccountNumber`, `thirdPartyPostalCode`, `thirdPartyCountryGeoCode`: Third-party related info
    *   `upsHighValueReport`: Data for UPS high-value shipments

*   **Relationships:**
    *   Links to `Shipment`, `Delivery`, `Party`, `ShipmentMethodType`, `Facility`, `ContactMech`, `PostalAddress`, `TelecomNumber`, `StatusItem`, and `Uom` entities.

**HotWax Commerce Customizations**

HotWax Commerce extends this entity to include:

*   `codReturnLabelImage`, `codReturnLabelHtml`, `codCollectionAmount`: Handles Cash On Delivery (COD) scenarios.
*   `carrierAccountNumber`: Stores the carrier's account number used for this segment.
*   `isGenerateThirdPartyLabel`: Indicates if a third-party shipping label should be generated.
*   `isTrackingRequired`: Specifies if tracking is mandatory for this segment.
*   `referenceNumber`: Provides an additional reference number for the segment.
*   `actualCarrierCode`: Stores the actual carrier code used.

**Detailed Implementation**
*   GET, PUT, POST, DELETE Rest resources.

