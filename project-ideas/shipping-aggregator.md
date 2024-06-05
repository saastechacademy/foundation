# Shipping Gateway Application: Project Requirements and API Specification

## Project Overview

This project aims to build a shipping gateway application that simplifies shipping management for e-commerce businesses. The application will provide a unified API for integrating with multiple shipping providers and offer a user-friendly interface for customers to manage their shipping needs.

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
*   **Database (e.g., PostgreSQL, MySQL):** For storing customer data, API keys, and shipping information.
*   **SDKs/Libraries:** Utilize official SDKs or libraries from shipping providers (if available).

## Shipping Gateway Application: Data Model and Entity Relationships

This is outline of the core data model and entity relationships for a lightweight shipping gateway application built on the Moqui Framework. The application facilitates interaction between customers (organizations needing shipping services) and carriers (shipping providers).

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

#### 4. `CarrierShipmentMethod`

*   **Purpose:** Defines available shipping methods for each carrier.
*   **Key Fields:**
    *   `carrierPartyId`: (PK) The `partyId` of the carrier offering this method.
    *   `shipmentMethodEnumId`: (PK) An ID referencing a standardized shipment method (e.g., "ShMthGround" for Ground shipping).
    *   `description`, `sequenceNum`, `carrierServiceCode`, `scaCode`, `gatewayServiceCode`: Provide additional details and codes for the shipping method.

#### 5. `CarrierShipmentBoxType`

*   **Purpose:** Specifies the standard box types that each carrier supports.
*   **Key Fields:**
    *   `carrierPartyId`: (PK) The `partyId` of the carrier supporting this box type.
    *   `shipmentBoxTypeId`: (PK) An ID referencing a standardized box type (e.g., "SmallFlatRateBox").
    *   `packagingTypeCode`, `oversizeCode`: Provide additional information about the box type.

#### 6. `ShippingGatewayConfig`

*   **Purpose:** Stores configuration settings for each integrated shipping gateway.
*   **Key Fields:**
    *   `shippingGatewayConfigId`: (PK) Unique identifier for the configuration.
    *   `shippingGatewayTypeEnumId`: An ID referencing the type of gateway (e.g., "ShGtwyShippo").
    *   `description`: Description of the gateway configuration.
    *   (Other fields for service names related to rate calculation, label generation, tracking, etc.)

#### 7. `ShippingGateway[BoxType, Carrier, Method, Option]`

*   **Purpose:** These entities allow customization of the interaction between each shipping gateway and carriers, box types, shipping methods, and additional options.
*   **Key Fields:**
    *   `shippingGatewayConfigId`: (PK) Links to the parent `ShippingGatewayConfig`.
    *   Additional PK fields depending on the specific entity (e.g., `shipmentBoxTypeId`, `carrierPartyId`, `shipmentMethodEnumId`, `optionEnumId`).
    *   Fields for overriding default values, providing gateway-specific IDs, etc.

### Entity Relationships

*   `Party` has a one-to-one relationship with `Organization`.
*   `Party` has a one-to-many relationship with `PartyRole`.
*   `CarrierShipmentMethod` and `CarrierShipmentBoxType` have a many-to-one relationship with `Party` (through `carrierPartyId`).
*   `ShippingGateway[BoxType, Carrier, Method, Option]` have a many-to-one relationship with `ShippingGatewayConfig`.


**Party Management Services**

These services handle the core operations for creating, retrieving, updating, and deleting parties (customers and carriers) along with their associated organization details and roles.

*   **`findParty`:**
    *   **Purpose:** Searches for parties based on various criteria like `partyId`, `partyTypeEnumId`, `roleTypeId`, names, addresses, contact information, etc.
    *   **Relevance:** Essential for your application to allow users to search and select existing parties (customers or carriers).

*   **`searchParty`:**
    *   **Purpose:**  Similar to `findParty`, but uses a search index for potentially faster and more flexible searches.
    *   **Relevance:**  Can be used to provide a more advanced search interface for parties.

*   **`createAccount`:**
    *   **Purpose:** Creates a new user account, including the associated `Party`, `Person`, `UserAccount`, and `ContactMech` records.
    *   **Relevance:**  Potentially useful for your application if you allow self-registration of customer accounts.

*   **`updateAccount`:**
    *   **Purpose:** Updates an existing user account's details.
    *   **Relevance:**  Necessary for allowing users to modify their account information.

*   **`createPartyUserAccount`:**
    *   **Purpose:** Creates a `UserAccount` for an existing `Party`.
    *   **Relevance:**  Could be used if you have a separate process for creating parties and then later adding user accounts to them.

*   **`updatePartyUserAccount`:**
    *   **Purpose:** Updates the `UserAccount` and primary email address for a party.
    *   **Relevance:**  Useful for managing user accounts linked to parties.

*   **`createPerson`:**
    *   **Purpose:** Creates a new party of type "Person" (likely not directly relevant for your use case as you're dealing with organizations).

*   **`createOrganization`:**
    *   **Purpose:** Creates a new party of type "Organization" along with the associated `Organization` record.
    *   **Relevance:**  Essential for creating both customer and carrier parties in your application.

*   **`updatePartyDetail`:**
    *   **Purpose:** Updates the details of an existing party, including both `Person` and `Organization` attributes.
    *   **Relevance:**  Necessary for allowing modifications to party information.

*   **`convertPartyToOrganization` and `convertPartyToPerson`:**
    *   **Purpose:** Convert a party from one type to another.
    *   **Relevance:**  Likely not needed in your application unless you anticipate needing to change a party's type.

*   **`ensurePartyRole`:**
    *   **Purpose:** Ensures a party has a specific role, creating it if necessary.
    *   **Relevance:**  Useful for assigning roles like "Customer" or "Carrier" to parties.

## Shipping Gateway Configuration Entities

Moqui Mantle uses a set of interconnected entities to manage shipping gateway configurations:

### 1. ShippingGatewayConfig

*   **Description:**
    *   The central entity storing general configuration for each shipping provider integration.
    *   Acts as a reference point for all other related entities.

*   **Key Fields:**

    *   **shippingGatewayConfigId (ID, Primary Key):** Unique identifier for the configuration.
    *   **shippingGatewayTypeEnumId (ID):** References an enumeration (`ShippingGatewayType`) to categorize the gateway type (e.g., "Local," "Third-Party").
    *   **description (Text-Medium):** A human-readable description of the configuration.
    *   **Service Names (Text-Medium):** References to various Moqui services responsible for different aspects of the integration:
        *   `getOrderRateServiceName`: Calculates shipping rates for an order.
        *   `getShippingRatesBulkName`: Retrieves shipping rates in bulk.
        *   `getAutoPackageInfoName`: Gets package information automatically.
        *   `getRateServiceName`: Retrieves shipping rates for a single shipment.
        *   `requestLabelsServiceName`: Requests shipping labels.
        *   `refundLabelsServiceName`: Handles refunds for labels.
        *   `trackLabelsServiceName`: Tracks shipments.
        *   `validateAddressServiceName`: Validates shipping addresses.

*   **Relationships:**

    *   **ShippingGatewayType (One):** Links to the enumeration defining the type of gateway.
    *   **ShippingGatewayBoxType (Many):** Connects to configurations for box types specific to this gateway.
    *   **ShippingGatewayCarrier (Many):** Associates the gateway with supported carriers.
    *   **ShippingGatewayMethod (Many):** Defines specific shipping methods offered through this gateway.
    *   **ShippingGatewayOption (Many):** Holds additional configuration options for the gateway.

### 2. ShippingGatewayBoxType

*   **Description:**
    *   Maps standard shipment box types to specific box IDs used by the shipping gateway.

*   **Key Fields:**
    *   **shippingGatewayConfigId (ID, Primary Key):** Foreign key referencing the parent `ShippingGatewayConfig`.
    *   **shipmentBoxTypeId (ID, Primary Key):** Foreign key referencing a standard box type.
    *   **gatewayBoxId (Text-Medium):** The box ID used by the shipping gateway.

### 3. ShippingGatewayCarrier

*   **Description:**
    *   Associates a shipping carrier (represented by the `Party` entity) with a specific gateway configuration.

*   **Key Fields:**
    *   **shippingGatewayConfigId (ID, Primary Key):** Foreign key referencing the parent `ShippingGatewayConfig`.
    *   **carrierPartyId (ID, Primary Key):** Foreign key referencing the `Party` entity representing the carrier.
    *   **gatewayAccountId (Text-Medium):** Account ID used with the gateway for this carrier.

### 4. ShippingGatewayMethod

*   **Description:**
    *   Maps standard shipping methods (e.g., GROUND, AIR) to specific service codes used by the shipping gateway.

*   **Key Fields:**
    *   **shippingGatewayConfigId (ID, Primary Key):** Foreign key referencing the parent `ShippingGatewayConfig`.
    *   **carrierPartyId (ID, Primary Key):** Foreign key referencing the carrier.
    *   **shipmentMethodEnumId (ID, Primary Key):** Foreign key referencing the standard shipping method from the `moqui.basic.Enumeration` table.
    *   **gatewayServiceCode (Text-Short):** The service code used by the gateway for this method.

### 5. ShippingGatewayOption

*   **Description:**
    *   Stores additional configuration options for a shipping gateway.

*   **Key Fields:**
    *   **shippingGatewayConfigId (ID, Primary Key):** Foreign key referencing the parent `ShippingGatewayConfig`.
    *   **optionEnumId (ID, Primary Key):** Foreign key referencing the type of option from the `ShippingGatewayOption` enumeration.
    *   `optionValue` (Text-Medium): The value of the option.


## Carrier Shipment Method Management

**Entity Description:**

The `CarrierShipmentMethod` entity represents the specific shipping methods available from different carriers. It associates these methods with carriers, categorizes them using enumeration values, and provides additional details for integration with shipping providers.


Useful links

https://github.com/hotwax/mantle-fedex
https://github.com/hotwax/mantle-shipstation
https://github.com/hotwax/mantle-shipengine


