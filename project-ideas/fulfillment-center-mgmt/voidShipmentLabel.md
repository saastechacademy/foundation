## Reset the ShipmentRouteSegment entity for the Shipment. 

One of the use case for this services is, when user wants to manually get shipping label, before retry, first clear previous shipping label details. 
The other case, is when we modify Shipment Package after it was packed, once package contents are modified we have to void previous shipping label and get new one.

```
    public static Map<String, Object> voidShipmentPackageLabel(DispatchContext dctx, Map<String, Object> context) {
        Delegator delegator = dctx.getDelegator();
        String shipmentId = (String) context.get("shipmentId");
        String shipmentPackageSeqId = (String) context.get("shipmentPackageSeqId");
        try {
            GenericValue shipmentPackageRouteSeg = EntityQuery.use(delegator).from("ShipmentPackageRouteSeg").where("shipmentId", shipmentId, "shipmentPackageSeqId", shipmentPackageSeqId).queryFirst();
            if (shipmentPackageRouteSeg != null) {
                shipmentPackageRouteSeg.set("labelImage", null);
                shipmentPackageRouteSeg.set("labelImageUrl", null);
                shipmentPackageRouteSeg.set("trackingCode", null);
                shipmentPackageRouteSeg.set("labelHtml", null);
                shipmentPackageRouteSeg.store();
            }
        } catch (GenericEntityException e) {
            Debug.logError(e, MODULE);
            return ServiceUtil.returnError(e.getMessage());
        }
        return ServiceUtil.returnSuccess();
    }

```

**ShipmentRouteSegment Entity Definition in HotWax Commerce**

The following table outlines the fields of the `ShipmentRouteSegment` entity in HotWax Commerce, incorporating both the standard OFBiz fields and the custom fields added by HotWax:

| Field Name | Type | Description |
|---|---|---|
| `shipmentId` | id | The ID of the shipment to which this route segment belongs. |
| `shipmentRouteSegmentId` | id | A unique identifier for this specific route segment within the shipment. |
| `deliveryId` | id | The ID of the `Delivery` entity associated with this route segment, if applicable (e.g., for last-mile delivery). |
| `originFacilityId` | id | The ID of the facility from which this route segment originates. |
| `destFacilityId` | id | The ID of the facility where this route segment ends. |
| `originContactMechId` | id | The ID of the contact mechanism (address, phone number, etc.) at the origin of this segment. |
| `originTelecomNumberId` | id | The ID of the telecom number at the origin of this segment. |
| `destContactMechId` | id | The ID of the contact mechanism at the destination of this segment. |
| `destTelecomNumberId` | id | The ID of the telecom number at the destination of this segment. |
| `carrierPartyId` | id | The ID of the party (company or individual) responsible for carrying out this route segment. |
| `shipmentMethodTypeId` | id | The type of shipment method used for this segment (e.g., ground, air). |
| `carrierServiceStatusId` | id | The status of the carrier service for this segment (e.g., scheduled, in-transit, delivered). |
| `carrierDeliveryZone` | short-varchar | The delivery zone assigned by the carrier for this segment. |
| `carrierRestrictionCodes` | short-varchar | Any restriction codes applied by the carrier to this segment. |
| `carrierRestrictionDesc` | very-long | A description of any carrier restrictions for this segment. |
| `billingWeight` | fixed-point | The weight used for billing purposes for this segment. |
| `billingWeightUomId` | id | The unit of measurement for the billing weight. |
| `actualTransportCost` | currency-amount | The actual cost of transportation for this segment. |
| `actualServiceCost` | currency-amount | The actual cost of additional services for this segment. |
| `actualOtherCost` | currency-amount | Any other actual costs incurred for this segment. |
| `actualCost` | currency-amount | The total actual cost for this segment (sum of transport, service, and other costs). |
| `currencyUomId` | id | The currency used for the cost amounts. |
| `actualStartDate` | date-time | The actual date and time this segment started. |
| `actualArrivalDate` | date-time | The actual date and time this segment arrived at its destination. |
| `estimatedStartDate` | date-time | The estimated start date and time for this segment. |
| `estimatedArrivalDate` | date-time | The estimated arrival date and time for this segment. |
| `trackingIdNumber` | short-varchar | The tracking number or ID for this segment. |
| `trackingDigest` | very-long | A digest or summary of tracking information for this segment. |
| `updatedByUserLoginId` | id-vlong | The ID of the user who last updated this segment. |
| `lastUpdatedDate` | date-time | The date and time of the last update to this segment. |
| `homeDeliveryType` | id | The type of home delivery service used for this segment, if applicable. |
| `homeDeliveryDate` | date-time | The scheduled date for home delivery for this segment. |
| `thirdPartyAccountNumber` | id | An account number associated with a third-party involved in this segment. |
| `thirdPartyPostalCode` | id | The postal code associated with a third-party involved in this segment. |
| `thirdPartyCountryGeoCode` | id | The country code associated with a third-party involved in this segment. |
| `upsHighValueReport` | byte-array | A byte array potentially storing a high-value report from UPS for this segment. |
| `codReturnLabelImage` | byte-array | A byte array storing the image of the COD return label. (HotWax Customization) |
| `codReturnLabelHtml` | very-long | HTML content of the COD return label. (HotWax Customization) |
| `codCollectionAmount` | currency-amount | The amount to be collected on delivery (COD). (HotWax Customization) |
| `carrierAccountNumber` | id | The carrier's account number associated with this segment. (HotWax Customization) |
| `carrierService` | name | The name of the specific carrier service used for this segment. (HotWax Customization) |
| `isGenerateThirdPartyLabel` | indicator | Indicates whether a third-party label should be generated for this segment. (HotWax Customization) |
| `isTrackingRequired` | indicator | Indicates whether tracking is required for this segment. (HotWax Customization) |
| `referenceNumber` | name | A reference number for this segment. (HotWax Customization) |
| `actualCarrierCode` | id | The actual carrier code used for this segment. (HotWax Customization) |

**Key Relationships:**

* **Shipment:** Each `ShipmentRouteSegment` belongs to a single `Shipment`.
* **Carrier Party:** The `carrierPartyId` links the segment to the `Party` responsible for its execution.
* **ShipmentMethodType:** The `shipmentMethodTypeId` specifies the type of shipping method used for this segment.
* **Origin and Destination Facilities & Contact Mechanisms:** The `originFacilityId`, `destFacilityId`, `originContactMechId`, etc., link the segment to its origin and destination points.
* **UOMs:** The `billingWeightUomId` and `currencyUomId` connect the segment to the relevant Units of Measure for billing weight and currency.

**HotWax Customizations:**

HotWax has extended the standard `ShipmentRouteSegment` entity with additional fields to accommodate specific business requirements related to COD (Cash On Delivery), third-party labels, tracking, and carrier details. These customizations enhance the system's ability to handle more complex shipment scenarios and integrate with various carrier services.
