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





## API Specification for Party Management

This API specification defines the endpoints and operations for managing parties (customers and organizations) within the shipping gateway application, aligning with the Moqui Mantle service implementations.


### Endpoints

1.  **Find Party**

    *   **Endpoint:** `/mantle/party/PartyServices/find#Party` (POST)
    *   **Purpose:** Search for parties based on various criteria (party ID, type, role, name, contact details, etc.).
    *   **Request Body:**

```json
{
  "partyId": (Optional),
  "partyTypeEnumId": (Optional),
  "roleTypeId": (Optional),
  "organizationName": (Optional),
  "firstName": (Optional),
  "lastName": (Optional),
  "address1": (Optional),
  "city": (Optional),
  "postalCode": (Optional),
  "countryCode": (Optional),
  "contactNumber": (Optional),
  "emailAddress": (Optional),
  "orderByField": (Optional, default: "firstName,organizationName"),
  "pageIndex": (Optional, default: 0),
  "pageSize": (Optional, default: 20)
}
```

    *   **Response Body:**

```json
{
  "partyIdList": [
    {
      "partyId": "Party ID"
    },
    ...
  ],
  "partyIdListCount": (Total count of matching parties)
}
```

2.  **Search Party**

    *   **Endpoint:** `/mantle/party/PartyServices/search#Party` (POST)
    *   **Purpose:** More flexible search for parties using a search index and additional filters (e.g., `anyField` for full-text search, `customerStatusId`).
    *   **Request Body:** Similar to `findParty`, but with additional search-specific parameters.
    *   **Response Body:**

```json
{
  "documentList": [
    {
      "partyId": "Party ID",
      "partyTypeEnumId": "Party Type",
      "roles": ["Role1", "Role2"],
      "organization": {
        "organizationName": "Organization Name"
      }
    },
    ...
  ],
  "documentListCount": (Total count of matching parties)
}
```

3.  **Get User Notice Counts**

    *   **Endpoint:** `/mantle/party/PartyServices/get#UserNoticeCounts` (GET)
    *   **Purpose:** Retrieve counts of various notifications (e.g., messages, tasks) for the authenticated user.
    *   **Request Body:** (None)
    *   **Response Body:**

```json
{
  "partyId": "User's Party ID",
  "notificationCount": (Number),
  "messageCount": (Number),
  "eventCount": (Number),
  "taskCount": (Number)
}
```

4.  **Create Person**

    *   **Endpoint:** `/mantle/party/PartyServices/create#Person` (POST)
    *   **Purpose:** Create a new party of type "Person" (may not be directly relevant for your use case).
    *   **Request Body:** (See Moqui Mantle service definition for parameters)
    *   **Response Body:**

```json
{
  "partyId": "Newly created party ID"
}
```

5.  **Create Organization**

    *   **Endpoint:** `/mantle/party/PartyServices/create#Organization` (POST)
    *   **Purpose:** Create a new organization party (customer or carrier).
    *   **Request Body:**

```json
{
  "partyTypeEnumId": "PtyOrganization",
  "roles": ["Customer" or "Carrier"],
  "organization": {
    "organizationName": "Organization Name"
  }
}
```

    *   **Response Body:**

```json
{
  "partyId": "Newly created party ID"
}
```

6.  **Update Party Detail**

    *   **Endpoint:** `/mantle/party/PartyServices/update#PartyDetail` (PUT)
    *   **Purpose:** Update the details of an existing party.
    *   **Request Body:**

```json
{
  "partyId": "Party ID to update",
  "organization": {
    "organizationName": "Updated Organization Name"
  }
  // Other fields as needed
}
```

    *   **Response Body:**

```json
{
  "success": true
}
```

7.  **Ensure Party Role**

    *   **Endpoint:** `/mantle/party/PartyServices/ensure#PartyRole` (POST)
    *   **Purpose:** Ensure a party has a specific role.
    *   **Request Body:**

```json
{
  "partyId": "Party ID",
  "roleTypeId": "Role Type ID"
}
```

    *   **Response Body:**

```json
{
  "success": true
}
```
ing gateway integrations.

## Shipping Gateway Interfaces

These interfaces define the contract that your shipping gateway integrations will need to fulfill to interact with the Moqui Framework and provide shipping functionality:

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

**Key Services for Building Integrations**

*   **`calculate#OrderShipping`:** This service is a high-level entry point for calculating shipping costs for an entire order. It calls the appropriate `getOrderRateServiceName` based on the shipping gateway configuration.

*   **`calculate#OrderPartShipping`:** This service calculates shipping for a specific part of an order. It handles tasks like deleting existing shipping charges, determining package information (if the `getAutoPackageInfoName` service is available), and calling the `getOrderRateServiceName` to get the actual rate.

*   **`get#OrderShippingRatesBulk`:** This service retrieves shipping rates in bulk for multiple carriers and methods. It interacts with both the `getShippingRatesBulkName` and `getOrderRateServiceName` services based on the gateway configuration.

*   **`request#ShipmentLabels`:** This service is responsible for requesting shipping labels for a shipment. It retrieves the necessary gateway details and then calls the `requestLabelsServiceName` to interact with the specific shipping provider's API.

*   **`refund#ShipmentLabels` and `track#ShipmentLabels`:** These services follow a similar pattern to `request#ShipmentLabels`, retrieving gateway details and calling the appropriate service to handle refunds or tracking.

*   **`validate#PostalAddress`:** This service is a wrapper around the `validate#ShippingPostalAddress` interface. It handles the logic of determining which gateway configuration to use for validation and then calls the corresponding service.


## System setup guide

Here's sample data to setup FedEx gateway and a detailed system setup guide:

**1. Enumeration Records**

*   These records define the necessary configuration options for the FedEx gateway:
    *   `SgoFedExClientId`: Stores the FedEx REST API Client ID.
    *   `SgoFedExClientSecret`: Stores the FedEx REST API Client Secret.
    *   `SgoFedExAccountNumber`: Stores the FedEx Account Number.
    *   `ShGtwyFedEx`: Identifies the FedEx REST API as the shipping gateway type.
    *   `EgFedExOption`: Defines an enumeration group for FedEx gateway options.

**2. ShipmentBoxType Records**

*   These records define the various box types supported by FedEx, including their dimensions and corresponding gateway box IDs. This information is crucial for accurate rate calculation and label generation.

**3. ShippingGatewayConfig Record**

*   This record is the core configuration for the FedEx shipping gateway:
    *   `shippingGatewayConfigId`: "FedEx_DEMO" (a unique identifier for this configuration).
    *   `shippingGatewayTypeEnumId`: "ShGtwyFedEx" (indicates that this is a FedEx gateway).
    *   `description`: "FedEx API Demo" (a brief description).
    *   `getRateServiceName`: "mantle.FedExServices.get#ShippingRate" (the service used to get shipping rates).
    *   `requestLabelServiceName`: "mantle.FedExServices.create#ShippingLabel" (the service used to create shipping labels).
    *   **`methods` (child elements):** Map Moqui's standard shipment methods to FedEx's specific service codes.
    *   **`options` (child elements):** Store the FedEx API credentials and label type preferences.

**4. PartySetting Record**

*   This record sets the default shipping gateway for the organization "ORG_ZIZI_RETAIL" to the "FedEx_DEMO" configuration.

**System Setup Guide**


1.  **Data Import:**
    *   Prepare and Import the configuration XML data into your database. This will create the necessary records in the `moqui.basic.Enumeration`, `mantle.shipment.ShipmentBoxType`, `mantle.shipment.carrier.ShippingGatewayConfig`, and `mantle.party.PartySetting` entities.

2.  **Service Implementation:**
    *   Implement the Moqui services referenced in the `ShippingGatewayConfig` record:
        *   `mantle.FedExServices.get#ShippingRate`
        *   `mantle.FedExServices.create#ShippingLabel`
    *   These services should handle the communication with the FedEx API to retrieve rates and generate labels.

3.  **Configuration:**
    *   Update the `optionValue` fields in the `ShippingGatewayConfig.options` records with your actual FedEx API credentials.

**Important Note**
We will copy over limited set entity definition and services from Moqui UDM and USL. 

Useful links


https://github.com/hotwax/mantle-fedex

https://github.com/hotwax/mantle-shipstation


https://github.com/hotwax/mantle-shipengine


