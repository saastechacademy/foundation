# Shipping Gateway Application: Project Requirements, Data Model, and API Specification

## Project Overview

This project aims to build a lightweight shipping gateway application that simplifies shipping management for e-commerce businesses. The application will provide a unified API for integrating with multiple shipping providers (e.g., FedEx, UPS, USPS) and offer a user-friendly interface for customers to manage their shipping needs. The application will not persist shipment data; all shipment details will be passed within the API requests and responses.

## Key Requirements

1.  **Customer/User Management:**
    *   Securely handle customer registration and account management.
    *   Provide an interface for managing API keys and authentication.
    *   Ensure data privacy and security.

2.  **Shipping API Integration and Abstraction:**
    *   Seamlessly integrate with multiple shipping providers (e.g., FedEx, UPS, USPS).
    *   Abstract the complexities of each provider's API into a simplified, unified API for customers.
    *   Enable label generation, tracking, and other essential shipping functions through the API.
    *   Ensure reliable communication and error handling with shipping providers.

## Proposed Solutions

### Technology Stack

*   **Moqui Framework:** For building the web interface, backend logic, and API facade.
*   **Apache Shiro:** For user authentication, session management, and API key-based authentication.
*   **Database (MySQL):** For storing customer data, API keys, and shipping information.
*   **SDKs/Libraries:** Utilize official SDKs or libraries from shipping providers (if available).

## Data Model and Entity Relationships

### Party Roles

The application recognizes two primary party roles:

1.  **Customers:** Organizations that utilize the shipping gateway to manage their shipping operations.
2.  **Carriers:** Shipping providers (e.g., FedEx, UPS, DHL) that integrate with the application.

### Entities

#### 1. [Party](../../udm/beginner/party.md)
*   **Purpose:** Represents both customers and carriers as organizations.

### Shipping Gateway Configuration Entities

Moqui Mantle uses a set of interconnected entities to manage shipping gateway configurations:

#### 1. [ShippingGatewayConfig](ShippingGatewayConfig.md)

#### 2. [ShippingGatewayCarrier](ShippingGatewayCarrier.md)

## Shipping Gateway Interfaces

These interfaces define the contract that your shipping gateway integrations will need to fulfill to interact with the Moqui Framework and provide shipping functionality:
Ref: https://github.com/moqui/mantle-usl/blob/master/service/mantle/shipment/CarrierServices.xml

1.  **`get#OrderShippingRate`:**
    *   **Purpose:** Calculates the shipping rate for an entire order, potentially consisting of multiple items and packages.
    *   **Key Inputs:** `orderId`, `orderPartSeqId`, `shippingGatewayConfigId`, package information, etc.
    *   **Key Outputs:** `shippingTotal`, `orderItemSeqId` (if an order item is created for the shipping charge).

2.  **`get#ShippingRatesBulk`:**
    *   **Purpose:** Retrieves shipping rates in bulk for multiple carrier services and packages.
    *   **Key Inputs:** `shippingGatewayConfigId`, list of carrier shipment methods, origin and destination details, package information.
    *   **Key Outputs:** List of `shippingRateInfoList` (containing rate details for each carrier/method combination), potentially updated origin/destination addresses.

3.  **`get#AutoPackageInfo`:**
    *   **Purpose:** Automatically determines package information (e.g., box type, weight) based on the items in the order.
    *   **Key Inputs:** List of `itemInfoList` (containing product IDs and quantities).
    *   **Key Outputs:** List of `packageInfoList` (containing package details).

4.  **`get#ShippingRate`:**
    *   **Purpose:** Calculates the shipping rate for a single shipment package and route segment.
    *   **Key Inputs:** `shipmentId`, `shipmentRouteSegmentSeqId`, `shipmentPackageSeqId`, `shippingGatewayConfigId`.

5.  **`request#ShippingLabels`:**
    *   **Purpose:** Requests shipping labels from the carrier for a shipment (single package or all packages).
    *   **Key Inputs:** `shipmentId`, `shipmentRouteSegmentSeqId`, `shipmentPackageSeqId` (optional), `shippingGatewayConfigId`.

6.  **`refund#ShippingLabels`:**
    *   **Purpose:** Initiates a refund for shipping labels.
    *   **Key Inputs:** `shipmentId`, `shipmentRouteSegmentSeqId`, `shipmentPackageSeqId` (optional), `shippingGatewayConfigId`.

7.  **`track#ShippingLabels`:**
    *   **Purpose:** Tracks the status of shipments.
    *   **Key Inputs:** `shipmentId`, `shipmentRouteSegmentSeqId`, `shipmentPackageSeqId` (optional), `shippingGatewayConfigId`.

8.  **`validate#ShippingPostalAddress`:**
    *   **Purpose:** Validates a shipping address using the specified gateway configuration.
    *   **Key Inputs:** `contactMechId`, `partyId`, `facilityId`, `shippingGatewayConfigId`.
    *   **Key Outputs:** Potentially updated `contactMechId` if the address is corrected.

### Useful links

*   https://github.com/moqui/mantle-shippo/tree/master
*   https://github.com/hotwax/mantle-fedex
*   https://github.com/hotwax/mantle-shipstation
*   https://github.com/hotwax/mantle-shipengine

