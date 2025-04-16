### Shipping Gateway Configuration in Moqui

Moqui provides a robust and flexible framework for managing shipping operations, including the ability to integrate with various shipping carriers and gateways. The entities defined in the `mantle.shipment.carrier` package play a key role in streamlining this integration process.

### Core Entities

1.  `ShippingGatewayConfig`

    *   Purpose: This entity serves as the central hub for configuring each shipping gateway you integrate with. This could be a third-party service like Shippo or EasyPost, or even a direct integration with a carrier's API (like FedEx or UPS). It stores the main settings and links to other entities for more detailed configurations.
    *   Key Fields:
        *   `shippingGatewayConfigId` (Primary Key): A unique identifier for this configuration.
        *   `shippingGatewayTypeEnumId`: Specifies the type of gateway being configured. This is an enumeration value, and you would typically define a new value for each supported gateway.
        *   `description`: A human-readable description of the gateway configuration.
        *   Service Names (e.g., `getOrderRateServiceName`, `requestLabelsServiceName`): These fields store the names of Moqui services responsible for handling specific shipping operations with this gateway. These services would contain the logic to interact with the gateway's API (e.g., request shipping rates, generate labels, track shipments).

        Example (JSON):

    ```json
    {
      "shippingGatewayConfigId": "SHIPPO_DEMO",
      "shippingGatewayTypeEnumId": "ShGtwyShippo",
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

    This example shows a configuration for the Shippo gateway, including the service names for various shipping operations.

2.  `CarrierShipmentMethod`

    *   Purpose: This entity defines the specific shipping methods offered by each carrier. It provides a standardized way to represent methods across different carriers, even if they use different internal codes or names.
    *   Key Fields:
        *   `carrierPartyId` (Part of Primary Key): The ID of the carrier party (e.g., "FEDEX," "UPS").
        *   `shipmentMethodEnumId` (Part of Primary Key): An enumeration value categorizing the method type (e.g., "GROUND," "AIR," "INTERNATIONAL").
        *   `carrierServiceCode`: The carrier's internal code for the method (e.g., "FEDEX_GROUND," "UPS_NEXT_DAY_AIR").
        *   `gatewayServiceCode`: The gateway's code for the method (if different from the carrier's code). This allows flexibility in mapping methods between your system and the gateway.

        Example (JSON):

    ```json
    {
      "carrierPartyId": "FEDEX",
      "shipmentMethodEnumId": "ShMthGround",
      "description": "FedEx Ground",
      "sequenceNum": 1,
      "carrierServiceCode": "FEDEX_GROUND",
      "gatewayServiceCode": "fedex_ground"
    }
    ```

    This example defines a "FedEx Ground" shipping method with its corresponding codes for the carrier and the gateway.

3.  `ShippingGatewayBoxType`

    *   Purpose: This entity allows you to map your internal box types to the specific box type codes used by a particular shipping gateway. This is important because different gateways might have their own unique identifiers or naming conventions for box types.
    *   Key Fields:
        *   `shippingGatewayConfigId` (Part of Primary Key): The ID of the gateway configuration.
        *   `shipmentBoxTypeId` (Part of Primary Key): The ID of your internal box type.
        *   `gatewayBoxId`: The corresponding box type code used by the gateway.

        Example (JSON):

    ```json
    {
      "shippingGatewayConfigId": "SHIPPO_DEMO",
      "shipmentBoxTypeId": "USPS_SmFlat",
      "gatewayBoxId": "USPS_SmallFlatRateBox"
    }
    ```

    This example maps the internal box type "USPS_SmFlat" to the gateway-specific code "USPS_SmallFlatRateBox" for the Shippo gateway.

4.  `ShippingGatewayCarrier`

    *   Purpose: This entity associates specific carriers with a shipping gateway configuration. It allows you to define which carriers can be used with a particular gateway.
    *   Key Fields:
        *   `shippingGatewayConfigId` (Part of Primary Key): The ID of the gateway configuration.
        *   `carrierPartyId` (Part of Primary Key): The ID of the carrier party.
        *   `gatewayAccountId`: (Optional) An account ID specific to the gateway. This might be required if the gateway needs to access a specific account with the carrier.

        Example (JSON):

    ```json
    {
      "shippingGatewayConfigId": "SHIPPO_DEMO",
      "carrierPartyId": "FEDEX",
      "gatewayAccountId": "fedex_account_123"
    }
    ```

    This example associates FedEx with the Shippo gateway and includes an optional `gatewayAccountId`.

5.  `ShippingGatewayOption`

    *   Purpose: This entity allows you to store additional configuration options or parameters that are specific to a particular shipping gateway. These options might not fit into the other entities but are necessary for the gateway to function correctly.
    *   Key Fields:
        *   `shippingGatewayConfigId` (Part of Primary Key): The ID of the gateway configuration.
        *   `optionEnumId` (Part of Primary Key): An enumeration value that identifies the type of option being stored.
        *   `optionValue`: The value of the option.

        Example (JSON):

    ```json
    {
      "shippingGatewayConfigId": "SHIPPO_DEMO",
      "optionEnumId": "SgoApiToken",
      "optionValue": "your_shippo_api_token"
    }
    ```

    This example stores the Shippo API token as an additional option for the Shippo gateway configuration.

### Relationships Between Entities

*   `ShippingGatewayConfig` has one-to-many relationships with `ShippingGatewayCarrier`, `ShippingGatewayMethod`, `ShippingGatewayBoxType`, and `ShippingGatewayOption`. This means a single gateway configuration can have multiple associated carriers, methods, box type mappings, and additional options.
*   `CarrierShipmentMethod` has a many-to-one relationship with `ShippingGatewayMethod`, allowing you to override method codes for specific gateways.
*   `ShipmentBoxType` has a many-to-one relationship with `ShippingGatewayBoxType`, enabling box type mapping for different gateways.



```xml
<mantle.shipment.carrier.ShippingGatewayConfig shippingGatewayConfigId="SHIPPO_DEMO"
        shippingGatewayTypeEnumId="ShGtwyShippo" description="Shippo API Demo"
        ... >
    
    <!-- set your Shippo Account IDs for carriers with records like these -->
    <carriers carrierPartyId="UPS" gatewayAccountId=""/>
    <carriers carrierPartyId="FedEx" gatewayAccountId=""/>
    <carriers carrierPartyId="DHLX" gatewayAccountId="shippo_dhlexpress_account"/>
    <carriers carrierPartyId="USPS" gatewayAccountId="shippo_usps_account"/>

</mantle.shipment.carrier.ShippingGatewayConfig>


```

