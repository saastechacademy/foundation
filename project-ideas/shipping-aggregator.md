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

### API Specification

**Base URL:** `/api/v1`

**Authentication:**

*   API keys are required for all endpoints except `/customers/register` and `/customers/login`.
*   Include the API key in the `Authorization` header as `Bearer <api_key>`.

**Customer/User Management**

*   **POST /customers/register**
    *   Request Body:
        *   `name` (string, required): Customer name
        *   `email` (string, required): Customer email (unique)
        *   `company_name` (string, optional): Company name
        *   `address` (object, required):
            *   `line1` (string, required): Address line 1
            *   `line2` (string, optional): Address line 2
            *   `city` (string, required): City
            *   `state` (string, required): State/Province
            *   `postal_code` (string, required): Postal code
            *   `country` (string, required): Country code (ISO 3166-1 alpha-2)
        *   `phone` (string, optional): Phone number
    *   Response:
        *   201 Created: Successful registration, includes initial API key
        *   400 Bad Request: Invalid request data
        *   409 Conflict: Email already in use

*   **POST /customers/login**
    *   Request Body:
        *   `email` (string, required): Customer email
        *   `password` (string, required): Customer password
    *   Response:
        *   200 OK: Successful login, includes authentication token
        *   401 Unauthorized: Invalid credentials

*   **GET /customers/{customer_id}/api_keys** (Requires authentication)
    *   Response:
        *   200 OK: List of API keys for the customer
        *   401 Unauthorized

*   **POST /customers/{customer_id}/api_keys** (Requires authentication)
    *   Request Body:
        *   `description` (string, optional): Description of the API key
    *   Response:
        *   201 Created: New API key generated
        *   401 Unauthorized

*   **DELETE /customers/{customer_id}/api_keys/{key_id}** (Requires authentication)
    *   Response:
        *   204 No Content: API key successfully deleted
        *   401 Unauthorized
        *   404 Not Found: API key not found

**Shipping Integration**

*   **POST /shipments/create** (Requires authentication)
    *   Request Body:
        *   `carrier` (string, required): Carrier code (e.g., "fedex", "ups")
        *   `service_level` (string, optional): Service level code (e.g., "ground", "priority_overnight")
        *   `from_address` (object, required): Sender's address (same format as above)
        *   `to_address` (object, required): Recipient's address (same format as above)
        *   `parcels` (array, required): Array of parcel objects
            *   `length` (number, required): Length in inches
            *   `width` (number, required): Width in inches
            *   `height` (number, required): Height in inches
            *   `weight` (number, required): Weight in pounds
    *   Response:
        *   201 Created: Shipment created, includes shipment ID and tracking number
        *   400 Bad Request: Invalid request data
        *   401 Unauthorized

*   **GET /shipments/{shipment_id}/track** (Requires authentication)
    *   Response:
        *   200 OK: Tracking information for the shipment
        *   401 Unauthorized
        *   404 Not Found: Shipment not found

*   **GET /shipments/{shipment_id}/label** (Requires authentication)
    *   Response:
        *   200 OK: Shipping label (PDF or ZPL format)
        *   401 Unauthorized
        *   404 Not Found: Shipment not found

## Shipping Gateway Configuration API

The ShippingGatewayConfig entity stores configuration settings for integrating with various shipping providers (e.g., FedEx, UPS, DHL, etc.). Each record represents a unique configuration for a specific provider, allowing customization per customer or on a global level.

**Base URL:** `/rest/s1/data/ShippingGatewayConfig`

**Authentication:**

* Requires appropriate authentication and authorization (e.g., user login or API key) to access these endpoints.

**Endpoints:**

1.  **Create Shipping Gateway Configuration (POST)**

    *   **Endpoint:** `/`
    *   **Method:** `POST`
    *   **Request Body (JSON):**

```json
{
  "gatewayConfigId": "string (unique ID for the configuration)",
  "description": "string (description of the provider)",
  "serviceName": "string (name of the service implementing the integration)",
  "configProps": {
    "key1": "value1",
    "key2": "value2",
    // ... other provider-specific properties
  },
  "partyId": "string (required, ID of the associated party)" 
}
```

    *   **Response:**
        *   `201 Created`: Successfully created the configuration.
        *   `400 Bad Request`: Invalid or missing data in the request (including a missing or null `partyId`).
        *   `409 Conflict`: A configuration with the same `gatewayConfigId` already exists.

2.  **Get Shipping Gateway Configuration (GET)**

    *   **Endpoint:** `/{gatewayConfigId}`
    *   **Method:** `GET`
    *   **Response:**
        *   `200 OK`: Returns the configuration details in JSON format (same structure as the request body).
        *   `404 Not Found`: The specified configuration does not exist.

3.  **Update Shipping Gateway Configuration (PUT)**

    *   **Endpoint:** `/{gatewayConfigId}`
    *   **Method:** `PUT`
    *   **Request Body (JSON):**
        *   Same as the request body for creating a configuration, but you can omit fields that you don't want to update.  The `partyId` cannot be changed or set to null in an update.
    *   **Response:**
        *   `200 OK`: Successfully updated the configuration.
        *   `400 Bad Request`: Invalid or missing data in the request (including attempts to change or remove the `partyId`).
        *   `404 Not Found`: The specified configuration does not exist.

4.  **Delete Shipping Gateway Configuration (DELETE)**

    *   **Endpoint:** `/{gatewayConfigId}`
    *   **Method:** `DELETE`
    *   **Response:**
        *   `204 No Content`: Successfully deleted the configuration.
        *   `404 Not Found`: The specified configuration does not exist.

**Key Changes:**

*   The `partyId` field in the request body is now explicitly marked as **required** for the `POST` (create) endpoint.
*   The `PUT` (update) endpoint will now reject requests that attempt to change or remove the `partyId`. This ensures that the association between a configuration and a party remains consistent.
*   The `400 Bad Request` error response is now used for any invalid input, including a missing or null `partyId`.

By making this change, you guarantee that every shipping gateway configuration is linked to a specific party (customer), which can be helpful for managing permissions, billing, and reporting in your shipping gateway application.


## Carrier Shipment Method Management

**Entity Description:**

The `CarrierShipmentMethod` entity represents the specific shipping methods available from different carriers. It associates these methods with carriers, categorizes them using enumeration values, and provides additional details for integration with shipping providers.

**Base URL:** `/api/v1/carrierShipmentMethods`

**Authentication:**

* Requires appropriate authentication and authorization (e.g., user login or API key with admin privileges) to access these endpoints.

**Endpoints:**

1.  **Get All Carrier Shipment Methods (GET)**

    *   **Endpoint:** `/`
    *   **Method:** `GET`
    *   **Query Parameters:**
        *   `carrierPartyId` (optional): Filter by carrier party ID.
        *   `shipmentMethodEnumId` (optional): Filter by shipment method type.
        *   `limit` (optional): Limit the number of results.
        *   `offset` (optional): Offset for pagination.
    *   **Response:**
        *   200 OK: Returns a list of `CarrierShipmentMethod` objects in JSON format.
        *   400 Bad Request: Invalid query parameters.

2.  **Get Carrier Shipment Method by ID (GET)**

    *   **Endpoint:** `/{carrierPartyId}/{shipmentMethodEnumId}`
    *   **Method:** `GET`
    *   **Path Parameters:**
        *   `carrierPartyId`: The ID of the carrier party.
        *   `shipmentMethodEnumId`: The ID of the shipment method type.
    *   **Response:**
        *   200 OK: Returns the `CarrierShipmentMethod` object in JSON format.
        *   404 Not Found: The specified shipment method does not exist.

3.  **Create Carrier Shipment Method (POST)**

    *   **Endpoint:** `/`
    *   **Method:** `POST`
    *   **Request Body (JSON):**

```json
{
  "carrierPartyId": "string (required, ID of the carrier party)",
  "shipmentMethodEnumId": "string (required, ID of the shipment method type)",
  "description": "string (optional, description of the shipment method)",
  "sequenceNum": "integer (optional, order of the shipment method)",
  "carrierServiceCode": "string (required, carrier's code for the method)",
  "scaCode": "string (optional, Standard Carrier Alpha Code)",
  "gatewayServiceCode": "string (optional, code used by the gateway)"
}
```

    *   **Response:**
        *   201 Created: Successfully created the carrier shipment method.
        *   400 Bad Request: Invalid or missing data in the request.
        *   409 Conflict: A shipment method with the same carrierPartyId and shipmentMethodEnumId already exists.

4.  **Delete Carrier Shipment Method (DELETE)**

    *   **Endpoint:** `/{carrierPartyId}/{shipmentMethodEnumId}`
    *   **Method:** `DELETE`
    *   **Path Parameters:**
        *   `carrierPartyId`: The ID of the carrier party.
        *   `shipmentMethodEnumId`: The ID of the shipment method type.
    *   **Response:**
        *   204 No Content: Successfully deleted the carrier shipment method.
        *   404 Not Found: The specified shipment method does not exist.


**Key Considerations:**

*   The `shipmentMethodEnumId` must be a valid value from the `ShipmentMethod` enumeration defined in `moqui.basic.Enumeration`.
*   To modify a shipment method's type, delete the existing record and create a new one with the desired `shipmentMethodEnumId`.
*   Ensure the `shipmentMethodEnumId` in the request body is a valid enumeration value using validation logic.

