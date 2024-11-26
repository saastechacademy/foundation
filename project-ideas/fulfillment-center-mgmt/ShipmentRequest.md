# getShipmentRequest
# putShipmentRequest
# postShipmentRequest
# deleteShipmentRequest

The `getShipmentRequest` is a simple get API to retrieves the name of the service to be used for interacting with a specific carrier's API for a given shipment method type and request type (e.g., RATE_REQUEST, TRACKING, etc.).

1.  **Input Parameters:**
    *   `carrierPartyId`: The ID of the carrier party (e.g., "FEDEX", "UPS").
    *   `shipmentMethodTypeId`: The ID of the shipment method type (e.g., "GROUND", "EXPRESS_SAVER").
    *   `requestType`: The type of request being made to the carrier's API (e.g., "RATE_REQUEST", "TRACKING").

