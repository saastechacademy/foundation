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

## Additional Considerations

*   **Error Handling:** Implement robust error handling to gracefully manage failures in communication with the shipping providers' APIs.
*   **Caching:** Consider caching API responses from shipping providers to improve performance (optional).
*   **Webhooks:** Utilize webhooks to receive real-time updates from shipping providers (optional).
*   **Security:** Prioritize security best practices for API key management, data storage, and communication with external APIs.
