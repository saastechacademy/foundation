### Shipping Gateway Configuration

### Core Entities

1. `ShippingGatewayConfig`

    *   Purpose: This entity serves as the central hub for configuring each shipping gateway you integrate with. This could be a third-party service like Shippo or EasyPost, or even a direct integration with a carrier's API (like FedEx or UPS). It stores the main settings and links to other entities for more detailed configurations.
    *   Key Fields:
        *   `shippingGatewayConfigId` (Primary Key): A unique identifier for this configuration.
        *   `shippingGatewayTypeEnumId`: Specifies the type of gateway being configured. 
        *   Service Names (e.g., `getOrderRateServiceName`, `requestLabelsServiceName`): These fields store the names of Moqui services responsible for handling specific shipping operations with this gateway. These services would contain the logic to interact with the gateway's API (e.g., request shipping rates, generate labels, track shipments).

        Example (JSON):

    ```json
    {
      "shippingGatewayConfigId": "SHIPPO_DEMO",
      "shippingGatewayTypeEnumId": "ShGtwyRemote",
      "description": "Shippo API Demo",
      "getOrderRateServiceName": "mantle.shippo.ShippoServices.get#OrderShippingRate",
      "requestLabelsServiceName": "mantle.shippo.ShippoServices.request#ShippingLabels",
      "getShippingRatesBulkName": "mantle.shippo.ShippoServices.get#ShippingRatesBulk",
      "getAutoPackageInfoName": "",
      "getRateServiceName": "mantle.shippo.ShippoServices.get#ShippingRate",
      "refundLabelsServiceName": "mantle.shippo.ShippoServices.refund#ShippingLabels",
      "trackLabelsServiceName": "mantle.shippo.ShippoServices.track#ShippingLabels",
      "validateAddressServiceName": "mantle.shippo.ShippoServices.validate#PostalAddress"
    }
    ```

2. `ShippingGatewayOption`

    *   Purpose: This entity allows you to store additional configuration options or parameters that are specific to a particular shipping gateway. These options might not fit into the other entities but are necessary for the gateway to function correctly.
    *   Key Fields:
        *   `shippingGatewayConfigId` (Part of Primary Key): The ID of the gateway configuration.
        *   `optionEnumId` (Part of Primary Key): An enumeration value that identifies the type of option being stored.
        *   `optionValue`: The value of the option.

