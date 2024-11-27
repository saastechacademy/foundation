### reinitializeShipment

### Input Parameters

*   `shipmentId` (String): The ID of the shipment that needs to be reinitialized.

1. **Shipment Status Update:**

* Set the shipment's `statusId` to "SHIPMENT_INPUT".

2. **Shipment Route Segment Update:**
* Retrieve the `ShipmentRouteSegment` record associated with the shipment.
* Update `shipmentMethodTypeId` and `carrierPartyId`, set it to NULL
* Update `ShipmentRouteSegment` status to SHRSCS_NOT_STARTED
