The `ShipmentPackageRouteSeg` and `ShipmentRouteSegment` entities, their roles within the Apache OFBiz framework, and the customizations made in HotWax Commerce.

### ShipmentPackageRouteSeg (Apache OFBiz)

*   **Purpose:** The `ShipmentPackageRouteSeg` entity in Apache OFBiz is designed to establish a connection between individual packages within a shipment (`ShipmentPackage`) and the specific route segments (`ShipmentRouteSegment`) they traverse during transit. It allows for tracking and managing the movement of each package along different legs of the shipment's journey.

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



**ShipmentRouteSegment in Apache OFBiz and HotWax Commerce**

The `ShipmentRouteSegment` entity in Apache OFBiz represents a single leg or step in the transportation of a shipment from its origin to its destination. It stores details about the origin and destination facilities, carrier, shipping method, estimated and actual dates, costs, and tracking information for that specific segment of the shipment's journey.

**Key Attributes in Standard OFBiz**

*   `shipmentId` and `shipmentRouteSegmentId`: Primary keys identifying the shipment and the specific route segment.
*   `deliveryId`: The ID of the delivery associated with this segment (if applicable).
*   `originFacilityId`, `destFacilityId`: IDs of the origin and destination facilities.
*   `originContactMechId`, `destContactMechId`: Contact information for origin and destination.
*   `originTelecomNumberId`, `destTelecomNumberId`: Telecom contact information for origin and destination.
*   `carrierPartyId`: The carrier responsible for this segment.
*   `shipmentMethodTypeId`: The type of shipping method used.
*   `carrierServiceStatusId`: The status of the carrier service for this segment.
*   `carrierDeliveryZone`, `carrierRestrictionCodes`, `carrierRestrictionDesc`: Carrier-specific details about delivery zones and restrictions.
*   `billingWeight`, `billingWeightUomId`: Weight used for billing and its unit of measurement.
*   `actualTransportCost`, `actualServiceCost`, `actualOtherCost`, `actualCost`, `currencyUomId`: Cost details for this segment.
*   `actualStartDate`, `actualArrivalDate`, `estimatedStartDate`, `estimatedArrivalDate`: Date and time information for the segment.
*   `trackingIdNumber`, `trackingDigest`: Tracking details.
*   `updatedByUserLoginId`, `lastUpdatedDate`: Information about the last update.
*   `homeDeliveryType`, `homeDeliveryDate`: Details about home delivery if applicable.
*   `thirdPartyAccountNumber`, `thirdPartyPostalCode`, `thirdPartyCountryGeoCode`: Information related to third-party accounts or locations.
*   `upsHighValueReport`: Data for UPS high-value shipment reports.

**HotWax Commerce Custom Extensions**

HotWax Commerce has extended the `ShipmentRouteSegment` entity with the following additional fields:

*   `codReturnLabelImage`, `codReturnLabelHtml`, `codCollectionAmount`: Fields related to Cash On Delivery (COD) handling.
*   `carrierAccountNumber`: The carrier account number used for this segment.
*   `carrierService`: The name of the specific carrier service.
*   `isGenerateThirdPartyLabel`: Indicates if a third-party label should be generated.
*   `isTrackingRequired`: Indicates if tracking is required for this segment.
*   `referenceNumber`: A reference number for this segment.
*   `actualCarrierCode`: The actual carrier code used.
*   `labelImage`: A binary field to store the shipping label image
*   `labelImageUrl`: A text field to store the URL of the shipping label image
*   `labelHtml`: A text field to store the HTML representation of the shipping label
*   `requestedDeliveryDate`: A date field to store the customer's requested delivery date
*   `requestedDeliveryTime`: A time field to store the customer's requested delivery time
*   `requestedShipMethTypeId`: An ID field to store the customer's requested shipping method type
*   `deliveryWindow`: A floating-point field to store the delivery window in days or hours

## Usage in HotWax Commerce**

**Removal of ShipmentPackageRouteSeg:** HotWax Commerce has simplified the model by assuming one package per shipment. Therefore, they've removed the need for ShipmentPackageRouteSeg and moved relevant tracking and label information directly to the ShipmentRouteSegment entity.

*   **ShipmentRouteSegment Extensions:** The added fields in `ShipmentRouteSegment` cater to HotWax-specific requirements, such as:
    *   COD handling (`codReturnLabelImage`, `codReturnLabelHtml`, `codCollectionAmount`)
    *   Third-party label generation (`isGenerateThirdPartyLabel`)
    *   Explicit tracking requirement (`isTrackingRequired`)
    *   Additional carrier and service details (`carrierAccountNumber`, `carrierService`, `actualCarrierCode`)
    *   Customer-requested delivery preferences (`requestedDeliveryDate`, `requestedDeliveryTime`, `requestedShipMethTypeId`, `deliveryWindow`)
    *   Label storage and retrieval (`labelImage`, `labelImageUrl`, `labelHtml`)

