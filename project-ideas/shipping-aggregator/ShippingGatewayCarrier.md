# Business Requirements

* The application should allow retailers to use their own billing accounts with specific shipping carriers (e.g., a retailer using their FedEx account).
* This billing account information should be included in rate requests and shipping label requests to the carrier.

## Solution Design

* **ShippingGatewayCarrier:** This entity will be used to store the retailer's billing account ID for a specific carrier. The `gatewayAccountId` field will store the billing account ID.

### Implementation Steps

1. **Party and Carrier Setup:**
    * Create a `Party` entity for the retailer.
    * Ensure a `Party` entity exists for the relevant carrier (e.g., FedEx).

2. **Shipping Gateway Configuration:**
    *   Create a `ShippingGatewayConfig` record for the shipping gateway service being used. This could be for a service like Shippo or for direct access to the carrier's API (e.g., FedEx).
    * Create a `ShippingGatewayCarrier` record:
        * Set the `shippingGatewayConfigId` to the ID of the Shippo configuration.
        * Set the `carrierPartyId` to the ID of the carrier (e.g., FedEx).
        * Set the `gatewayAccountId` to the retailer's billing account ID for that carrier.

3. **Service Implementation:**
    * The rate calculation and label generation services to:
        * Retrieve the `gatewayAccountId` from the `ShippingGatewayCarrier` entity based on the `shippingGatewayConfigId` and `carrierPartyId`.
        * Include the `gatewayAccountId` in the rate requests and label requests to the shipping provider's API.

### Example

Let's say the retailer is "Acme Corp" and they have a billing account with FedEx with ID "FEDEX_BILLING_123." The shipping gateway service used is Shippo, and its configuration ID is "SHIPPO_CONFIG."

* A `Party` entity would exist for "Acme Corp."
* A `Party` entity would exist for "FedEx."
* A `ShippingGatewayConfig` record would exist for "SHIPPO_CONFIG."
* A `ShippingGatewayCarrier` record would be created with:
    * `shippingGatewayConfigId` = "SHIPPO_CONFIG"
    * `carrierPartyId` = (The `partyId` for FedEx)
    * `gatewayAccountId` = "FEDEX_BILLING_123"

### Example (Using FedEx API directly)

Let's say the retailer is "Beta LLC" and they have a billing account with FedEx with ID "FEDEX\_BILLING\_456." You are using FedEx's API directly, and the `ShippingGatewayConfig` ID for FedEx is "FEDEX\_CONFIG."

*   A `Party` entity would exist for "Beta LLC."
*   A `Party` entity would exist for "FedEx."
*   A `ShippingGatewayConfig` record would exist for "FEDEX\_CONFIG."
*   A `ShippingGatewayCarrier` record would be created with:
    *   `shippingGatewayConfigId` = "FEDEX\_CONFIG"
    *   `carrierPartyId` = (The `partyId` for FedEx)
    *   `gatewayAccountId` = "FEDEX\_BILLING\_456"

