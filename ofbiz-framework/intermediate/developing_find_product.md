# Assignment: Product Data Model in Apache OFBiz

## Objective  
You will be designing a "Find Product" view screen to simplify product management. The retailer requires that the product's name be unique for each product.  

You will define a structured approach for managing product information, implement services for product creation and updates, and establish relationships between products and categories. This will involve working with entities, services, and events within the OFBiz framework.  

By completing this assignment, you will:  
1. Understand how product-related entities are structured in OFBiz.  
2. Define a view-entity to facilitate product searches.  
3. Implement services to create and update product records.  
4. Establish relationships between products and categories.  
5. Use events to trigger product-related service execution.  
6. Test and validate the plugin to ensure proper functionality.  

## Assignment Tasks  

### Step 1: Reviewing the OFBiz Product Data Model  
1. The Apache OFBiz framework includes a **Product Data Model** that defines how product data is structured and related.  
2. Explore the entity definitions located in:  
   ```
   /ofbiz-framework/applications/datamodel/entitydef/
   ```  
3. Identify the entities relevant to this assignment, including:  
   - `Product`  
   - `ProductCategory`  
   - `ProductPrice`  
   - `ProductFeature`  
4. Understand how these entities relate to each other and how they will be used to store product data.  
5. Use this understanding to properly design the entity relationships in the later steps of the assignment.  

### Step 2: Setting Up the Plugin  
1. Create a new plugin named `ProductManagement` using Gradle.  
2. Ensure the plugin structure follows the standard OFBiz convention, including directories for configurations, entities, services, and web components.  

### Step 3: Defining the `FindProductView` View Entity  
1. Create a new view entity definition file in the plugin’s `entities` directory.  
2. Define a view-entity named `FindProductView` that retrieves product details, including:  
   - Product ID  
   - Product name  
   - Price (LIST_PRICE)
   - Product features
3. Ensure that the entity correctly joins relevant tables, such as `Product`, `ProductCategory`, and `ProductPrice`.  
4. Test the entity definition to confirm that it retrieves product data as expected.  

### Step 4: Implementing the `findProduct` Service  
1. Define a new service called `findProduct`.  
2. This service should allow searching for products using the following filters:  
   - Product ID  
   - Product name  
   - Price range  
   - Product feature  
3. Ensure the service allows filtering based on any type of product feature, such as color or size.
4. Implement logic to support case-insensitive and partial matches when searching for products.  
5. Ensure the service returns a list of products that match the provided criteria.  
6. Validate the service by calling it with different search parameters.  

### Step 5: Creating and Updating Products  
1. Define a service called `createProduct` to add new products. The service should:  
   - Take the product name, category, and price as required fields.  
   - Check if the product already exists using the `findProduct` service.  
   - Create a new product only if it does not already exist.  
2. Define a service called `updateProduct` to modify product details. The service should:  
   - Accept a product ID as a required input.  
   - Allow updates to the product’s category, price, and features.  
   - Ensure that the product exists before applying updates.  
3. Test both services by creating and updating product records in OFBiz.  

### Step 6: Establishing and Updating Virtual and Variant Relationships Between Products  
1. Define a service named `assocProductToVirtual` to establish a virtual relationship between a product and its variants. The service should:  
   - Accept a product ID and a virtual product ID as inputs.  
   - Ensure that both entities exist before creating the relationship.  
2. Define a service named `updateProductVariant` to modify an existing variant relationship. The service should:  
   - Accept a product ID and a virtual product ID as inputs.  
   - Make sure a virtual-varient relationship exists between the two.
   - Allow updating the variant association.  
3. Test both services by assigning and updating product-variant relationships.  

### Step 7: Using Events to Trigger Product Actions  
1. Configure an event in OFBiz that triggers the `createProduct` service when a new product is added.  
2. Configure an event that triggers the `updateProduct` service when product details are modified.  
3. Ensure that these events are properly mapped in the controller configuration.  
4. Test the events by simulating product creation and updates through the UI or service execution.  

### Step 8: Creating a Product Search Screen Using FTL  
1. Create a FreeMarker Template Language (FTL) file named `findProduct.ftl`.  
2. Develop a user interface to search for products using the `findProduct` service.  
3. Include input fields for filtering by Product ID, Product Name, Category, Price, and Features.  
4. Display the search results in a tabular format with pagination support.  
5. Ensure the UI interacts correctly with OFBiz backend services.  
6. Test the product search screen to confirm it retrieves and displays results properly.  

## Deliverables  
1. A fully functional OFBiz plugin named `ProductManagement`.  
2. Properly defined entities, services, and event mappings.  
3. Sample test cases used to validate the services and event triggers.  

## Evaluation Criteria  
1. **Correctness** – The plugin should function as expected and retrieve, create, and update product records properly.  
2. **Code Structure** – The project should be well-structured, following OFBiz conventions.  
3. **Entity Relationships** – The `FindProductView` entity should correctly join relevant data tables.  
4. **Service Implementation** – Services should handle input validation and ensure data integrity.  
5. **Event Handling** – Events should be correctly mapped and triggered within OFBiz.  
