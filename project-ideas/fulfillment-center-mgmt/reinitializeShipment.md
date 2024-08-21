### reinitializeShipment

The `reinitializeShipment` service is designed to reset a shipment to its initial state, specifically to the `SHIPMENT_INPUT` status and associated route segment details back to their initial state. This is often done when modifications need to be made to a shipment after it has been approved or partially processed.


### Input Parameters

*   `shipmentId` (String): The ID of the shipment that needs to be reinitialized.

1. **Shipment Status Update:**

* Set the shipment's `statusId` to "SHIPMENT_INPUT". 

2. **Shipment Route Segment Update:**
* Get the related `OrderItemShipGroup`. 
* Retrieve the `ShipmentRouteSegment` record associated with the shipment.
* Updates `shipmentMethodTypeId` and `carrierPartyId`.

