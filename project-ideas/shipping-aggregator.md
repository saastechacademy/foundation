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

#### 1. `Party`

*   **Purpose:** Represents both customers and carriers as organizations.
*   **Key Fields:**
    *   `partyId`: Unique identifier (e.g., "ORG_ACME" for a customer, "FedEx" for a carrier).
    *   `partyTypeEnumId`:  "PtyOrganization" for both customer and carrier organizations.
    *   `roles`: Collection of roles indicating the party's function (e.g., ["Customer", "CustomerBillTo"] or ["Carrier"]).

#### 2. `Organization`

*   **Purpose:** Stores additional details specific to organizations (both customers and carriers).
*   **Key Fields:**
    *   `partyId`: (PK) Links to the corresponding `Party` record.
    *   `organizationName`: The name of the organization (e.g., "Acme Corporation" or "FedEx").
    *   (Other fields from Moqui Mantle as needed: `officeSiteName`, `annualRevenue`, `numEmployees`, etc.)

#### 3. `PartyRole`

*   **Purpose:** Assigns roles (e.g., "Customer", "Carrier") to parties.
*   **Key Fields:**
    *   `partyId`: (PK) Links to the corresponding `Party` record.
    *   `roleTypeId`:  The role identifier (e.g., "Customer" or "Carrier").

### Shipping Gateway Configuration Entities

Moqui Mantle uses a set of interconnected entities to manage shipping gateway configurations:

#### 1. `ShippingGatewayConfig`

*   **Description:**
    *   The central entity storing general configuration for each shipping provider integration.
    *   Acts as a reference point for all other related entities.
    *   Each shipping gateway integration should define a `ShippingGatewayType` Enumeration record plus an entity with a shared PK (i.e., PK is `shippingGatewayConfigId`).

*   **Key Fields:**

    *   **shippingGatewayConfigId (ID, Primary Key):** Unique identifier for the configuration.
    *   **shippingGatewayTypeEnumId (ID):** References an enumeration (`ShippingGatewayType`) to categorize the gateway type (e.g., "Local," "Third-Party").
    *   **description (Text-Medium):** A human-readable description of the configuration.
    *   **Service Names (Text-Medium):** References to various Moqui services responsible for different aspects of the integration:
        *   `getOrderRateServiceName`: Service implementing `mantle.shipment.CarrierServices.get#OrderShippingRate` interface.
        *   `getShippingRatesBulkName`: Service implementing `mantle.shipment.CarrierServices.get#ShippingRatesBulk` interface.
        *   `getAutoPackageInfoName`: Service implementing `mantle.shipment.CarrierServices.get#AutoPackageInfo` interface.
        *   `getRateServiceName`: Service implementing `mantle.shipment.CarrierServices.get#ShippingRate` interface.
        *   `requestLabelsServiceName`: Service implementing `mantle.shipment.CarrierServices.request#ShippingLabels` interface.
        *   `refundLabelsServiceName`: Service implementing `mantle.shipment.CarrierServices.refund#ShippingLabels` interface.
        *   `trackLabelsServiceName`: Service implementing `mantle.shipment.CarrierServices.track#ShippingLabels` interface.
        *   `validateAddressServiceName`: Service implementing `mantle.shipment.CarrierServices.validate#ShippingPostalAddress` interface.

*   **Relationships:**

    *   **ShippingGatewayType (One):** Links to the enumeration defining the type of gateway.
    *   **ShippingGatewayBoxType (Many):** Connects to configurations for box types specific to this gateway.
    *   **ShippingGatewayCarrier (Many):** Associates the gateway with supported carriers.
    *   **ShippingGatewayMethod (Many):** Defines specific shipping methods offered through this gateway.
    *   **ShippingGatewayOption (Many):** Holds additional configuration options for the gateway.

#### 2. `CarrierShipmentMethod`

*   **Purpose:** Defines available shipping methods for each carrier.
*   **Key Fields:**
    *   `carrierPartyId`: (PK) The `partyId` of the carrier offering this method.
    *   `shipmentMethodEnumId`: (PK) An ID referencing a standardized shipment method (e.g., "ShMthGround" for Ground shipping).
    *   `description`, `sequenceNum`, `carrierServiceCode`, `scaCode`, `gatewayServiceCode`: Provide additional details and codes for the shipping method.

#### 3. `CarrierShipmentBoxType`

*   **Purpose:** Specifies the standard box types that each carrier supports.
*   **Key Fields:**
    *   `carrierPartyId`: (PK) The `partyId` of the carrier supporting this box type.
    *   `shipmentBoxTypeId`: (PK) An ID referencing a standardized box type (e.g., "SmallFlatRateBox").
    *   `packagingTypeCode`, `oversizeCode`: Provide additional information about the box type.

#### 4. `ShippingGatewayBoxType`

*   **Description:**
    *   Maps standard shipment box types to specific box IDs used by the shipping gateway.
    *   Used to override `gatewayBoxId` on `ShipmentBoxType`.

*   **Key Fields:**
    *   `shippingGatewayConfigId` (ID, Primary Key):** Foreign key referencing the parent `ShippingGatewayConfig`.
    *   `shipmentBoxTypeId` (ID, Primary Key):** Foreign key referencing a standard box type.
    *   `gatewayBoxId` (Text-Medium):** The box ID used by the shipping gateway.

#### 5. `ShippingGatewayCarrier`

*   **Description:**
    *   Associates a shipping carrier (represented by the `Party` entity) with a specific gateway configuration.

*   **Key Fields:**
    *   `shippingGatewayConfigId` (ID, Primary Key):** Foreign key referencing the parent `ShippingGatewayConfig`.
    *   `carrierPartyId` (ID, Primary Key):** Foreign key referencing the `Party` entity representing the carrier.
    *   `gatewayAccountId` (Text-Medium):** Account ID used with the gateway for this carrier.

#### 6. `ShippingGatewayMethod`

*   **Description:**
    *   Maps standard shipping methods (e.g., GROUND, AIR) to specific service codes used by the shipping gateway.
    *   Used to override `gatewayServiceCode` on `CarrierShipmentMethod`.

*   **Key Fields:**
    *   `shippingGatewayConfigId` (ID, Primary Key):** Foreign key referencing the parent `ShippingGatewayConfig`.
    *   `carrierPartyId` (ID, Primary Key):** Foreign key referencing the carrier.
    *   `shipmentMethodEnumId` (ID, Primary Key):** Foreign key referencing the standard shipping method from the `moqui.basic.Enumeration` table.
    *   `gatewayServiceCode` (Text-Short):** The service code used by the gateway for this method.

#### 7. `ShippingGatewayOption`

*   **Description:**
    *   Stores additional configuration options for a shipping gateway.

*   **Key Fields:**
    *   `shippingGatewayConfigId` (ID, Primary Key):** Foreign key referencing the parent `


Useful links

https://github.com/hotwax/mantle-fedex
https://github.com/hotwax/mantle-shipstation
https://github.com/hotwax/mantle-shipengine


