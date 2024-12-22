# Assignment: RESTful API Development with Moqui framework and MySQL

## Problem Statement

In this assignment, you will create and manage orders for an online retail business using RESTful APIs. The focus will be on interacting with a MySQL database to store and manage order-related data through a set of well-designed APIs.

---

### This assignment tests your ability to:

- **Define Entities in XML:** Use the Moqui Entity Engine to define database entities in XML format.
- **Set Up Database Relationships:** Leverage Moqui specifications to establish relationships between entities.
- **Implement RESTful APIs in Moqui:** Develop and expose services as REST APIs using the Moqui framework.
- **Handle CRUD Operations:** Implement Create, Read, Update, and Delete functionality through Moqui’s service engine.
- **Integrate Validation and Business Logic:** Apply strict input validation, such as mandatory field checks and format constraints (e.g., dates as `yyyy-MM-dd`), directly into service definitions.
- **Secure and Test APIs:** For example, return HTTP status codes:
  - `201 Created`: When a new resource, such as an order, is successfully created.

---

### Tasks

#### Task 1: Define Entities in XML

Develop the following entities in **XML format** as per the Moqui framework’s Entity Engine specifications. Each entity should define the structure of the database tables, primary keys, relationships, and constraints.

| Entity Name      | Fields                                                                                                   |
|------------------|---------------------------------------------------------------------------------------------------------|
| **Party**        | `party_id` (VARCHAR(20), PK), `party_type` (VARCHAR, NOT NULL), `first_name` (VARCHAR), `last_name` (VARCHAR) |
| **Contact_Mech** | `contact_mech_id` (VARCHAR(20), PK), `party_id` (VARCHAR(20), FK), `street_address` (VARCHAR, NOT NULL), `city` (VARCHAR), `state` (VARCHAR), `postal_code` (VARCHAR) |
| **Product**      | `product_id` (VARCHAR(20), PK), `product_name` (VARCHAR, NOT NULL), `color` (VARCHAR), `size` (VARCHAR)         |
| **Order_Header** | `order_id` (VARCHAR(20), PK), `order_date` (DATE, NOT NULL), `party_id` (VARCHAR(20), FK), `shipping_contact_mech_id` (VARCHAR(20), FK), `billing_contact_mech_id` (VARCHAR(20), FK) |
| **Order_Item**   | `order_item_seq_id` (VARCHAR(20), PK), `order_id` (VARCHAR(20), FK), `product_id` (VARCHAR(20), FK), `quantity` (INT, NOT NULL), `status` (VARCHAR) |

#### Task 2: Develop RESTful APIs for Party Data

Develop RESTful APIs for managing party data:

1. **Create a Party:** POST /parties
2. **Retrieve Party Details:** GET /parties/{party_id}
3. **Update a Party:** PUT /parties/{party_id}
4. **Delete a Party:** DELETE /parties/{party_id}
5. **Manage Contact Mechanisms for a Party:**
  - **Add Contact Mechanism:** POST /parties/{party_id}/contacts
  - **Retrieve Contact Mechanisms:** GET /parties/{party_id}/contacts
  - **Update Contact Mechanism:** PUT /parties/{party_id}/contacts/{contact_mech_id}
  - **Delete Contact Mechanism:** DELETE /parties/{party_id}/contacts/{contact_mech_id}

#### Task 3: Develop RESTful APIs for Product Data

Develop RESTful APIs for managing product data:

1. **Create a Product:** POST /products
2. **Retrieve Product Details:** GET /products/{product_id}
3. **Update a Product:** PUT /products/{product_id}
4. **Delete a Product:** DELETE /products/{product_id}

#### Task 4: Develop RESTful APIs for Order Data

Develop RESTful APIs for managing orders:

1. **Create an Order:** POST /orders
2. **Retrieve Order Details:** GET /orders/{order_id}
3. **Update an Order:** PUT /orders/{order_id}
4. **Delete an Order:** DELETE /orders/{order_id}
5. **Add an Order Item:** POST /orders/{order_id}/items

#### Task 5: Insert Sample Data

The following example data demonstrates typical use cases for an online retail business, including party, product, and order details:

1. **Scenario 1: John Doe’s Order**
  - **Party Information:**
    - Name: John Doe
    - Type: Customer
    - Contact: +1 650-253-0000, john.doe@example.com
  - **Shipping Address:**
    - 1600 Amphitheatre Parkway, Mountain View, CA, 94043
  - **Order Details:**
    - 2 units of a red T-Shirt, size M.
    - 1 unit of blue jeans, size 32.

2. **Scenario 2: Jane Smith’s Order**
  - **Party Information:**
    - Name: Jane Smith
    - Type: Customer
    - Contact: +1 212-736-3100, jane.smith@example.com
  - **Shipping Address:**
    - 350 Fifth Avenue, New York, NY, 10118
  - **Order Details:**
    - 1 unit of a white jacket, size L.
    - 1 unit of sneakers, size 9.

The data is provided in JSON format for clarity:

```json
{
  "parties": [
    {
      "party_id": 1,
      "party_type": "Customer",
      "first_name": "John",
      "last_name": "Doe"
    },
    {
      "party_id": 2,
      "party_type": "Customer",
      "first_name": "Jane",
      "last_name": "Smith"
    }
  ],
  "contact_mechanisms": [
    {
      "contact_mech_id": 1,
      "party_id": 1,
      "street_address": "1600 Amphitheatre Parkway",
      "city": "Mountain View",
      "state": "CA",
      "postal_code": "94043"
    },
    {
      "contact_mech_id": 2,
      "party_id": 2,
      "street_address": "350 Fifth Avenue",
      "city": "New York",
      "state": "NY",
      "postal_code": "10118"
    }
  ],
  "products": [
    {
      "product_id": 1,
      "product_name": "T-Shirt",
      "color": "Red",
      "size": "M"
    },
    {
      "product_id": 2,
      "product_name": "Jeans",
      "color": "Blue",
      "size": "32"
    },
    {
      "product_id": 3,
      "product_name": "Jacket",
      "color": "White",
      "size": "L"
    },
    {
      "product_id": 4,
      "product_name": "Sneakers",
      "color": "Black",
      "size": "9"
    }
  ]
}
```

#### Task 6: Test APIs

1. Use tools like Postman or CURL to test each API.
2. Verify proper responses, such as HTTP status codes `200 OK`, `201 Created`, and `400 Bad Request` for validation errors.

---

## Submission Instructions

- Commit the project code to GitHub.
- Include screenshots demonstrating successful execution of each API endpoint.
