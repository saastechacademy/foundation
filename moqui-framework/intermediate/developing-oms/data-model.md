## Assignment 2: Implementing the OMS Data Model with Moqui and REST APIs

**Learning Objectives:**

* Translate a data model design into Moqui entities.
* Develop REST APIs to interact with the Order Management System (OMS) data.

**Background:**

In the assignment referenced below, you designed the Order data model and mapped it to the Shopify Order API. Now, you will implement this model in Moqui and expose its functionality through REST APIs.

https://github.com/saastechacademy/foundation/blob/main/udm/intermediate/activity-design-order.md


**Tasks:**

1.  **Moqui Entity Definitions:**
    *   Translate your Order data model design into Moqui entity definitions (XML files).
    *   Utilize Mantle UDM (Universal Data Model) entities whenever possible for standard concepts.
    *   Create any custom entities required for specific OMS functionalities.

2.  **REST API Implementation:**
    *   Using the Moqui framework, implement RESTful endpoints for the following operations:
        *   Creating a new order
        *   Retrieving an order by ID
        *   Updating an existing order
        *   Listing all orders (with optional filtering and pagination)
    *   Ensure that your APIs:
        *   Follow RESTful design principles (resource-oriented, HTTP verbs, status codes).
        *   Handle input validation and error conditions gracefully.
        *   Return appropriate JSON responses for each operation.
        *   Can be tested using tools like Postman or curl.

3.  **Documentation:**
    *   Clearly document your Moqui entity definitions, explaining the purpose of each field.
    *   Provide detailed documentation (e.g., using OpenAPI/Swagger) for your REST APIs, including:
        *   Endpoint URLs
        *   Supported HTTP methods
        *   Input parameters (with data types and validation rules)
        *   Output responses (with examples)
        *   Error codes and descriptions

**Tips:**

*   Review the Moqui documentation on entities and REST services.
*   Leverage Mantle UDM entities for common fields (e.g., parties, addresses).
*   Use Moqui's validation features to ensure data integrity.
*   Test your APIs thoroughly to catch and fix any issues.

**Submission:**

Submit your Moqui entity definitions, REST API implementation, and documentation to your "moqui-training" repository on GitHub.
