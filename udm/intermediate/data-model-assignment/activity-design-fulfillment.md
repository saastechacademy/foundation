# Design Order Fulfillment System and Create mapping with Shopify Fulfillment API.

Learning objectives 
* Read API documentation, and develop application using it. 
* Design Data Model, with UDM foundation
* Document solution before starting to code. 

You are part of a team developing OMS.You are assigned three tasks. 
1. Design Shipment data model. 
2. Prepare design document with details of Shopify Fulfillment model mapping with UDM/OFBiz Shipment and Order data model. 
3. Write pseudo code for parsing Shopify API response and then storing it in UDM/OFBiz model.
4. Test your pseudo code for all the sample JSON provided in `shopify-samples/orders-json` folder


References:
https://shopify.dev/docs/api/admin-rest/2024-01/resources/fulfillment

Note: 
This task only includes writing DDL to create entities in MySQL. This task does not include writing any code or API calls.


## Assignment: Building an Order Fulfillment System for NotNaked

This assignment focuses on designing and implementing core components of an Order Fulfillment System for NotNaked, using the Universal Data Model (UDM) and integrating with the Shopify Fulfillment API.  You will use MySQL for the database.

## Project Overview: NotNaked's Order Fulfillment Challenge

NotNaked needs a system to manage the fulfillment process for its online orders.  Your objective is to design and implement parts of this system, concentrating on efficient data storage, retrieval, and seamless integration with Shopify.

## Assignment Details

This assignment is divided into three parts:

### Part 1: Database Design

* **Objective:** Design a UDM-compliant database schema in MySQL for storing order fulfillment information.
* **Tasks:**
    1. Create the necessary tables to store Shipment (fulfillment) information, including:
        * Basic Shipment Information: Shipment ID, Order ID, Shipment Information: Order ID, Status, Tracking Number, Shipping Carrier, Shipping Method, etc.
        * Fulfillment Items:  Product details and quantity for each item included in the Shipment.
        * Shipment Information (if applicable):  Shipment ID, Shipment Date, Estimated Delivery Date, etc. (Consider how fulfillments relate to shipments in your model.)
        * Inventory Adjustments:  Record changes in inventory levels resulting from fulfillment.

    2. Define appropriate data types, primary keys, and foreign keys for each table. Ensure data integrity and referential integrity.
    3. Provide the DDL SQL statements for creating these tables in MySQL.  Your SQL script should be executable without errors.
    4. Include clear and concise comments in your SQL script explaining the purpose of each table and column.

### Part 2: Data Access Logic (Pseudo-code)

* **Objective:** Design the logic for accessing and manipulating Shipment data within the Moqui Framework.
* **Tasks:**
    1. Write pseudo-code for creating a new Shipment record.
    2. Write pseudo-code for retrieving a Shipment record based on its unique identifier.
    3. Write pseudo-code for updating an existing Shipment record.  This should include handling status changes (e.g., marking a Shipment as "shipped" or "delivered").
    4. Write pseudo-code for handling potential issues like partial fulfillments or cancellations.

### Part 3: Data Integration with Shopify (Mapping and Pseudo-code)

* **Objective:** Design the mapping between your Shipment and the Shopify Fulfillment API and write pseudo-code to handle the integration.
* **Tasks:**
    1. **Mapping:**
        * Map the following required fields from the Shopify Fulfillment API to your UDM-based data model: `id`, `order_id`, `status`, `created_at`, `service`, `tracking_number`, `tracking_company`, `tracking_url`, `line_items`.  Pay particular attention to the `line_items` array, which details the items included in the fulfillment.
        * Clearly explain how you will handle data type differences and multi-valued fields. Provide examples of data transformations.

    2. **Pseudo-code:**
        * Write pseudo-code to retrieve fulfillment data from the Shopify Fulfillment API. Include error handling and data validation.
        * Write pseudo-code to transform the Shopify data into the format required by your UDM-based data model.
        * Write pseudo-code to store the transformed data into your MySQL database.  Handle potential conflicts or duplicates. Consider using `upsert` functionality where appropriate.
        * Test your pseudo-code against the sample JSON data provided in the [orders json](../data-model-assignment/shopify-samples/orders-json) folder (this folder will be provided separately).

## Deliverables

* **SQL Script (`create_tables.sql`):** Containing the DDL for your database schema.
* **Pseudo-code Document (`data_access_logic.md`):** Containing the pseudo-code for data access, manipulation, and Shopify integration.
* **Mapping Document (`shopify_fulfillment_mapping.md`):** Describing the data mapping between your fulfillment system and the Shopify Fulfillment API.

## Evaluation Criteria

* **Completeness:** Have all tasks been addressed?
* **Correctness:** Is the database schema designed correctly?  Does the pseudo-code implement the required functionality? Is the data mapping accurate and complete?
* **UDM Adherence:** Does the database schema follow UDM principles?
* **Clarity and Documentation:** Are the SQL script, pseudo-code, and mapping document well-commented and easy to understand?
* **Efficiency:** Is the database schema designed for efficient data access and retrieval?

