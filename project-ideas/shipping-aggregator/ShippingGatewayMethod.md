The `ShippingGatewayMethod` entity allows to **override the default `gatewayServiceCode`** on a per-gateway basis. This is useful when different shipping gateways have their own specific codes or identifiers for the same shipping methods.

**How it works**

*   Default `gatewayServiceCode`: The `CarrierShipmentMethod` entity defines a default `gatewayServiceCode` for each shipping method offered by a carrier.
*   Gateway-specific overrides: The `ShippingGatewayMethod` entity allows you to specify a different `gatewayServiceCode` for a specific shipping gateway configuration.
*   Matching: The `ShippingGatewayMethod` entity uses a composite primary key consisting of `shippingGatewayConfigId`, `carrierPartyId`, and `shipmentMethodEnumId` to match the override to the correct `CarrierShipmentMethod` record.

**Example**

Let's say you have a FedEx shipping method with a default `gatewayServiceCode` of "FEDEX_GROUND." However, for a specific shipping gateway integration (e.g., ShipStation), you need to use the code "FG" instead.

You would create a `ShippingGatewayMethod` record with the following:

*   `shippingGatewayConfigId`: The ID of the ShipStation gateway configuration.
*   `carrierPartyId`: The ID of the FedEx carrier party.
*   `shipmentMethodEnumId`: "ShMthGround" (or the corresponding enum ID for the ground shipping method).
*   `gatewayServiceCode`: "FG"

