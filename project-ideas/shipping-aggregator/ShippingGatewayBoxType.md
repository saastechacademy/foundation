### Shipping Gateway Box Type Configuration

Different shipping carriers and shipping gateways may have their own unique identifiers for box types.

The `ShippingGatewayBoxType` entity in Moqui provides a solution to this challenge. It allows you to define mappings between your internal box type codes (defined in the `ShipmentBoxType` entity) and the specific codes used by each shipping gateway.

### Entity details

*   **Entity name:** `ShippingGatewayBoxType`
*   **Package:** `mantle.shipment.carrier`
*   **Purpose:** To override the `gatewayBoxId` on `ShipmentBoxType` for specific shipping gateways.
*   **Fields:**
    *   `shippingGatewayConfigId` (ID, Primary Key): The ID of the `ShippingGatewayConfig` for the specific gateway.
    *   `shipmentBoxTypeId` (ID, Primary Key): The ID of the default `ShipmentBoxType` to override.
    *   `gatewayBoxId` (Text-Medium): The box ID to use for this gateway.
*   **Relationships:**
    *   `ShippingGatewayConfig` (One)
    *   `ShipmentBoxType` (One)

### Example scenario

Let's say a retailer uses ShipStation as their shipping gateway and primarily ships with FedEx. The retailer has a standard box type in their Moqui system called "Retailer Box" with `shipmentBoxTypeId = "RETAILER_BOX"`.

*   FedEx, through ShipStation, requires the use of the code "FDX_RETAIL_BOX" for this specific box type.
*   The retailer also uses a "Ground" shipping method in their Moqui system, which needs to be mapped to ShipStation's "Ground" code for FedEx.

**Entity usage**

1.  **ShippingGatewayBoxType:**
    *   A `ShippingGatewayBoxType` record would be created to map the retailer's "RETAILER_BOX" to FedEx's "FDX_RETAIL_BOX" within ShipStation.
    *   This record would have:
        *   `shippingGatewayConfigId`: The ID of the ShipStation gateway configuration (e.g., "SHIPSTATION_CONFIG").
        *   `shipmentBoxTypeId`: "RETAILER_BOX"
        *   `gatewayBoxId`: "FDX_RETAIL_BOX"

2.  **ShippingGatewayMethod:**
    *   A `ShippingGatewayMethod` record would be created to map Moqui's "Ground" method to ShipStation's "Ground" code for FedEx shipments.
    *   This record would have:
        *   `shippingGatewayConfigId`: "SHIPSTATION_CONFIG"
        *   `carrierPartyId`: The `partyId` for FedEx.
        *   `shipmentMethodEnumId`: "ShMthGround" (or the corresponding enum ID for the ground shipping method).
        *   `gatewayServiceCode`: "Ground"

3.  **ShippingGatewayCarrier:**
    *   A `ShippingGatewayCarrier` record would be created to associate FedEx with the ShipStation configuration.
    *   This record would have:
        *   `shippingGatewayConfigId`: "SHIPSTATION_CONFIG"
        *   `carrierPartyId`: The `partyId` for FedEx.
        *   `gatewayAccountId`: (Optional, if there's a specific account ID needed for FedEx within ShipStation)

