## Assignment: Building a Customer Data Platform (CDP) for NotNaked

This assignment builds upon your understanding of the Party modeul of Universal Data Model (UDM). You will design and implement key components of a Customer Data Platform (CDP) for NotNaked, focusing on integration with Shopify. You will use MySQL for the database.

## Project Overview: NotNaked's Customer Data Platform

This CDP will serve as the central hub for all customer-related information. Your goal is to design and implement cdp component, integration with Shopify, their e-commerce platform.

## Assignment Details

This assignment is divided into three parts:

### Part 1: Database Design

* **Objective:** Design a UDM-compliant database schema in MySQL for storing customer data.
* **Tasks:**
    1. Create the necessary tables to store customer information, including:
        * Basic Information:  First Name, Last Name, Email, Phone Number, Date of Birth, etc.
        * Addresses:  Billing Address, Shipping Address (consider multiple addresses per customer)
        * Contact Information: Email, Phone Numbers, Social Media Handles (consider multiple contact mechanisms per customer)
        * Customer Preferences:  Marketing Opt-ins, Preferred Communication Channels, etc.
    2. Define appropriate data types, primary keys, and foreign keys for each table.  Ensure data integrity and referential integrity.
    3. Provide the Data Definition Language (DDL) SQL statements for creating these tables in MySQL.  Your SQL script should be executable without errors.
    4. Include clear and concise comments in your SQL script explaining the purpose of each table and column.

### Part 2: Data Access Logic (Pseudo-code)

* **Objective:** Design the logic for accessing and manipulating customer data within the Moqui Framework.
* **Tasks:**
    1.  Write pseudo-code for creating a new customer record.  This should include validating input data and handling potential errors.
    2.  Write pseudo-code for retrieving a customer record based on their unique identifier.
    3.  Write pseudo-code for updating an existing customer record.  This should include handling changes to addresses, contact information, and preferences.
    4.  Write pseudo-code for deleting a customer record (consider implications and potential alternatives like "soft deletes").

### Part 3: Data Integration with Shopify (Mapping and Pseudo-code)

* **Objective:** Design the mapping between your CDP and the Shopify Customer API and write pseudo-code to handle the integration.
* **Tasks:**
    1. **Mapping:**
        * Map the fields from the Shopify Customer API to your UDM-based data model, for example `id`, `first_name`, `last_name`, `email`, `phone`, `verified_email`, `addresses`.
        * For the `addresses` field (which is an array of address objects in Shopify), map the following sub-fields: `address1`, `address2`, `city`, `province`, `zip`, `country`, `phone`.
        * Clearly explain how you will handle data type differences and multi-valued fields like `addresses`. Provide examples of the transformation process.

    2. **Pseudo-code:**
        * Write pseudo-code to retrieve customer data from the Shopify Customer API.  This should include error handling and data validation.
        * Write pseudo-code to transform the Shopify data into the format required by your UDM-based data model.
        * Write pseudo-code to store the transformed data into your MySQL database.  This should include handling any potential conflicts or duplicates.  Consider using the `upsert` operation if applicable.
        * Test your pseudo-code against the sample JSON data provided in the **[customer data](shopify-samples/customers-json)** folder (this folder will be provided separately).


## Deliverables

* **SQL Script (`create_tables.sql`):**  Containing the DDL for your database schema.
* **Pseudo-code Document (`data_access_logic.md`):**  Containing the pseudo-code for data access, manipulation, and Shopify integration.
* **Mapping Document (`shopify_customer_mapping.md`):**  Describing the data mapping between your CDP and the Shopify Customer API.


## Evaluation Criteria

* **Completeness:**  Have all tasks been addressed?
* **Correctness:**  Is the database schema designed correctly? Does the pseudo-code implement the required functionality?  Is the data mapping accurate and complete?
* **UDM Adherence:**  Does the database schema follow UDM principles?
* **Clarity and Documentation:**  Are the SQL script, pseudo-code, and mapping document well-commented and easy to understand?
* **Efficiency:** Is the database schema designed for efficient data access and retrieval?
