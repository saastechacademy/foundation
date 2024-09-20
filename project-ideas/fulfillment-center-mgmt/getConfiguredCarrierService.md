# getConfiguredCarrierService

The `getConfiguredCarrierService` is a utility function that retrieves the name of the service to be used for interacting with a specific carrier's API for a given shipment method type and request type (e.g., RATE_REQUEST, TRACKING, etc.).

**Functionality Breakdown**

1.  **Input Parameters:**
    *   `delegator`: The `Delegator` object used for database access.
    *   `carrierPartyId`: The ID of the carrier party (e.g., "FEDEX", "UPS").
    *   `shipmentMethodTypeId`: The ID of the shipment method type (e.g., "GROUND", "EXPRESS_SAVER").
    *   `requestType`: The type of request being made to the carrier's API (e.g., "RATE_REQUEST", "TRACKING").

2.  **Database Lookup:**
    *   The function first attempts to find a matching record in the `ShipmentRequest` entity based on the provided `carrierPartyId`, `shipmentMethodTypeId`, and `requestType`.
    *   If a record is found, it extracts the `serviceName` from that record. This `serviceName` represents the specific service that should be called to interact with the carrier's API for the given request type.

3.  **Return Value:**
    *   The function returns the `serviceName`, which is the name of the OFBiz service to be used for the carrier API interaction.
    *   If no configuration is found in either the database or the properties file, it returns `null`.

**Example**

*   If the `carrierPartyId` is "FEDEX," the `shipmentMethodTypeId` is "GROUND," and the `requestType` is "RATE_REQUEST," the function might:
    *   Find a `ShipmentRequest` record with `serviceName` = "fedexRateRequest" and return "fedexRateRequest."

