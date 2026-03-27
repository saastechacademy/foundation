### Shipping Gateway Configuration

### Core Entities

1. `ShippingGatewayConfig`

    *   **Purpose**: This entity serves as the global, tenant-agnostic central hub for configuring each shipping gateway integrated into the platform. This represents the API definition for a carrier (like FedEx or UPS) and defines the underlying software services used to process requests to that carrier.
    *   **Key Fields**:
        *   `shippingGatewayConfigId` (Primary Key): A unique identifier for this configuration (e.g., `FEDEX_GLOBAL`).
        *   Service Names (e.g., `getOrderRateServiceName`, `requestLabelsServiceName`): These fields store the names of the internal Moqui services responsible for handling specific shipping operations with this gateway. When UniShip routes a tenant's request for FedEx, it will invoke these specific service definitions.

    **Example Representation (JSON):**

    ```json
    {
      "shippingGatewayConfigId": "FEDEX_GLOBAL",
      "description": "FedEx REST API Integration",
      "getOrderRateServiceName": "co.hotwax.unigate.UnigateServices.get#OrderShippingRate",
      "requestLabelsServiceName": "co.hotwax.unigate.UnigateServices.request#ShippingLabels",
      "refundLabelsServiceName": "co.hotwax.unigate.UnigateServices.refund#ShippingLabels"
    }
    ```
