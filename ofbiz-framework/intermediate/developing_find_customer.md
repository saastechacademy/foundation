# Assignment: Build a Dynamic Customer Finder

## Objective  
You will be designing a "Find Customer" view screen to simplify customer management. The retailer requires that the customer's email address, identified by `contactMechPurposeTypeId="EmailPrimary"`, serves as the unique identifier for each customer.

You will create a custom OFBiz plugin to manage customer records, define a dynamic customer finder, and establish relationships between parties. This will involve working with entities, services, and events within the OFBiz framework.  

By completing this assignment, you will:  
1. Understand how to create and structure an OFBiz plugin.  
2. Define a view-entity to facilitate customer searches.  
3. Implement services to create and update customer records.  
4. Establish relationships between two parties and update them dynamically.  
5. Use events to trigger service execution within OFBiz.  
6. Test and validate the plugin to ensure proper functionality.  

## Assignment Tasks  

### Step 1: Reviewing the OFBiz Data Model
1. The Apache OFBiz framework includes a **Data Model** that defines how data is structured and related.  
2. Explore the entity definitions located in:  
   ```
   /ofbiz-framework/applications/datamodel/entitydef/
   ```
3. Identify the entities relevant to this assignment, including:  
   - `Party` 
   - `Person` 
   - `ContactMech`
4. Understand how these entities relate to each other and how they will be used to store customer data.  
5. Use this understanding to properly design the entity relationships in the later steps of the assignment.  

### Step 2: Setting Up the Plugin  
1. Create a new plugin named `CustomerManagement` using Gradle.  
2. Ensure the plugin structure follows the standard OFBiz convention, including directories for configurations, entities, services, and web components.  

### Step 3: Defining the `FindCustomerView` View Entity  
1. Create a new view entity definition file in the plugin’s `entities` directory.  
2. Define a view-entity named `FindCustomerView` that retrieves customer details, including:  
   - Email address  
   - First name  
   - Last name  
   - Contact number  
   - Postal address  
3. Ensure that the entity correctly joins relevant tables, such as `Party`, `Person`, and `ContactMech`.  
4. Test the entity definition to confirm that it retrieves customer data as expected.  

### Step 4: Implementing the `findCustomer` Service  
1. Define a new service called `findCustomer`.  
2. This service should allow searching for customers using the following filters:  
   - Email address  
   - First name  
   - Last name  
   - Contact number  
   - Postal address  
3. Implement logic to support case-insensitive and partial matches when searching.  
4. Ensure the service returns a list of customers that match the provided criteria.  
5. Validate the service by calling it with different search parameters.  

### Step 5: Creating and Updating Customers  
1. Define a service called `createCustomer` to add new customers. The service should:  
   - Take the email address, first name, and last name as required fields. 
   - Check if the customer already exists using the `findCustomer` service. 
   - Create a new customer only if they do not already exist.  
2. Define a service called `updateCustomer` to modify customer details. The service should:  
   - Accept an email address as a required input.  
   - Allow updates to the customer’s postal address and phone number.  
   - Ensure that the customer exists before applying updates.  
3. Test both services by creating and updating customer records in OFBiz.  

### Step 6: Establishing and Updating Relationships Between Parties  
1. Define a service named `createRelationship` to establish a relationship between two parties. The service should:  
   - Accept two party IDs as inputs.  
   - Require a relationship type identifier.  
   - Store the relationship details in the database.  
2. Define a service named `updateRelationship` to modify an existing relationship between two parties. The service should:  
   - Accept the two party IDs and relationship type as inputs.  
   - Allow updating the status of the relationship.  
3. Test both services by creating and updating relationships between parties.  

### Step 7: Using Events to Trigger Customer Actions  
1. Configure an event in OFBiz that triggers the `createCustomer` service when a new customer is added.  
2. Configure an event that triggers the `updateCustomer` service when customer details are modified.  
3. Ensure that these events are properly mapped in the controller configuration.  
4. Test the events by simulating customer creation and updates through the UI or service execution.  

### Step 8: Creating a Product Search Screen Using FTL  
1. Create a FreeMarker Template Language (FTL) file named `findCustomer.ftl`.  
2. Develop a user interface to search for customers using the `findCustomer` service.  
3. Include input fields for filtering by Party ID, Customer Name, Email Address, Phone Number, and Address.  
4. Display the search results in a tabular format with pagination support.  
5. Ensure the UI interacts correctly with OFBiz backend services.  
6. Test the product search screen to confirm it retrieves and displays results properly.  

## Deliverables  
1. A fully functional OFBiz plugin named `CustomerManagement`.  
2. Properly defined entities, services, and event mappings.  
3. Sample test cases used to validate the services and event triggers.  

## Evaluation Criteria  
1. **Correctness** – The plugin should function as expected and retrieve, create, and update customer records properly.  
2. **Code Structure** – The project should be well-structured, following OFBiz conventions.  
3. **Entity Relationships** – The `FindCustomerView` entity should correctly join relevant data tables.  
4. **Service Implementation** – Services should handle input validation and ensure data integrity.  
5. **Event Handling** – Events should be correctly mapped and triggered within OFBiz.  