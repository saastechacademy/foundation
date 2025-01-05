## Assignment: Building a Product Information Management (PIM) System for NotNaked

This assignment focuses on designing and implementing a Product Information Management (PIM) system for NotNaked, leveraging the Universal Data Model (UDM) and integrating with the Shopify Product API.  You will use MySQL for the database.

## Project Overview: NotNaked's Product Information Management

NotNaked needs a PIM system to manage their product catalog.  Your objective is to design and implement PIM system, focusing integration with Shopify.

## Assignment Details

This assignment is divided into three parts:

### Part 1: Database Design

* **Objective:** Design a UDM-compliant database schema in MySQL for storing product information.
* **Tasks:**
    1. Create the necessary tables to store product information, including:
        * Basic Product Information: Product Name, Description, SKU, Universal Product Code (UPC), Global Trade Item Number (GTIN), etc.
        * Product Variations:  Size, Color, Material, etc.  (Consider how to handle different variations and combinations.)
        * Product Categories: Categorization of products to organize the catalog.
        * Pricing Information:  List Price, Sale Price, Cost, etc.
    2. Define appropriate data types, primary keys, and foreign keys for each table.  Ensure data integrity and referential integrity.
    3. Provide the Data Definition Language (DDL) SQL statements for creating these tables in MySQL. Your SQL script should be executable without errors.
    4.  Include clear and concise comments in your SQL script explaining the purpose of each table and column.

### Part 2: Data Access Logic (Pseudo-code)

* **Objective:** Design the logic for accessing and manipulating product data within the Moqui Framework.
* **Tasks:**
    1. Write pseudo-code for creating a new product record.  This should include validating input data and handling potential errors (e.g., duplicate SKUs).
    2. Write pseudo-code for retrieving a product record based on its unique identifier (e.g., SKU or product ID).
    3. Write pseudo-code for updating an existing product record. This should include handling changes to product variations, pricing, and other attributes.
    4. Write pseudo-code for handling product deletions (consider implications and alternatives like "soft deletes" or archiving).

### Part 3: Data Integration with Shopify (Mapping and Pseudo-code)

* **Objective:** Design the mapping between your PIM system and the Shopify Product API, and write pseudo-code to handle the integration.
* **Tasks:**

    1. **Mapping:**
        * Map the fields from the Shopify Product API to your UDM-based data model.
            * Pay particular attention to `variants` which contain information about product variations (e.g., size, color) and their respective SKUs, prices, and inventory quantities.  Also, note that `options` define the available variations for a product.
        * Clearly explain how you will handle data type differences and multi-valued fields like `variants` and `images`.  Provide examples of the transformation process.

    2. **Pseudo-code:**
        * Write pseudo-code to retrieve product data from the Shopify Product API.
        * Write pseudo-code to transform the Shopify data into the format required by your UDM-based data model.
        * Write pseudo-code to store the transformed data into your MySQL database. This should include handling any potential conflicts or duplicates.  Consider using `upsert` functionality where appropriate.
        * Test your pseudo-code against the sample JSON data provided in the **[product data](shopify-samples/product-json)** folder (this folder will be provided separately).


## Deliverables

* **SQL Script (`create_tables.sql`):** Containing the DDL for your database schema.
* **Pseudo-code Document (`data_access_logic.md`):** Containing the pseudo-code for data access, manipulation, and Shopify integration.
* **Mapping Document (`shopify_product_mapping.md`):** Describing the mapping between your PIM system and the Shopify Product API.


## Evaluation Criteria

* **Completeness:** Have all tasks been addressed?
* **Correctness:** Is the database schema designed correctly? Does the pseudo-code implement the required functionality? Is the data mapping accurate and complete?
* **UDM Adherence:** Does the database schema follow UDM principles?
* **Clarity and Documentation:** Are the SQL script, pseudo-code, and mapping document well-commented and easy to understand?
* **Efficiency:** Is the database schema designed for efficient data access and retrieval?

### References:
https://shopify.dev/docs/api/admin-rest/2024-01/resources/product

