# Assignment: Build a Dynamic Order Finder

## Objective  
You will be designing a **"Find Order"** view screen to simplify order management. The retailer requires a structured approach to managing order information, implementing services for order creation and updating only the shipping address. Additionally, you will establish relationships between orders, customers, and order items.

By completing this assignment, you will:  
1. Understand how order-related entities are structured in OFBiz.  
2. Define a view-entity to facilitate order searches.  
3. Implement services to create and update order records (only shipping address updates allowed).  
4. Establish relationships between orders, customers, and order items.  
5. Use events to trigger order-related service execution.  
6. Develop a UI to enable searching for orders based on various filters.  
7. Test and validate the plugin to ensure proper functionality.  

## Assignment Tasks  

### **Step 1: Reviewing the OFBiz Order Data Model**  
1. The Apache OFBiz framework includes an **Order Management System (OMS)** that defines how order data is structured and related.  
2. Explore the entity definitions located in:  
   ```
   /ofbiz-framework/applications/datamodel/entitydef/
   ```  
3. Identify the entities relevant to this assignment, including:  
   - `OrderHeader`  
   - `OrderItem`  
   - `OrderStatus`  
   - `OrderPaymentPreference`  
   - `OrderContactMech` (for shipping addresses)  
   - `Party` (to get customer details)  
4. Understand how these entities relate to each other and how they will be used to store and retrieve order data.  

### **Step 2: Setting Up the Plugin**  
1. Create a new plugin named `OrderManagement` using Gradle.  
2. Ensure the plugin structure follows the standard OFBiz convention, including directories for configurations, entities, services, and web components.  

### **Step 3: Defining the `FindOrderView` View Entity**  
1. Create a new view entity definition file in the plugin’s `entities` directory.  
2. Define a view-entity named `FindOrderView` that retrieves order details, including:  
   - Order ID  
   - Customer Name (from `Party`)  
   - Order Status  
   - Order Total  
   - Payment Status  
   - Shipping Address  
3. Ensure that the entity correctly joins relevant tables, such as `OrderHeader`, `OrderItem`, `OrderStatus`, and `OrderContactMech`.  
4. Test the entity definition to confirm that it retrieves order data as expected.  

### **Step 4: Implementing the `findOrder` Service**  
1. Define a new service called `findOrder`.  
2. This service should allow searching for orders using the following filters:  
   - Order ID  
   - Customer Name  
   - Order Date Range  
   - Order Status  
   - Payment Status  
   - Shipping Address  
3. Implement logic to support case-insensitive and partial matches when searching for orders.  
4. Ensure the service returns a list of orders that match the provided criteria, along with metadata for pagination.  
5. Validate the service by calling it with different search parameters.  

### **Step 5: Creating and Updating Orders**  
1. Define a service called `createOrder` to add new orders. The service should:  
   - Take the customer ID, ordered items (product IDs and quantities), shipping address, and payment preferences as required fields.  
   - Automatically generate an Order ID.  
   - Set the initial order status to `"ORDER_CREATED"`.  
   - Ensure that the products exist and that there is sufficient inventory before creating the order.  
2. Define a service called `updateOrderShippingAddress` to **only** modify the shipping address of an existing order. The service should:  
   - Accept an Order ID and a new shipping address.  
   - Ensure that the order exists before applying updates.  
   - Validate that the order has not yet been shipped.  
   - Update the `OrderContactMech` entity with the new shipping address.  
3. Test both services by creating orders and updating their shipping addresses in OFBiz.  

### **Step 6: Using Events to Trigger Order Actions**  
1. Configure an event in OFBiz that triggers the `createOrder` service when a new order is placed.  
2. Configure an event that triggers the `updateOrderShippingAddress` service when an order’s shipping address is modified.  
3. Ensure that these events are properly mapped in the controller configuration.  
4. Test the events by simulating order creation and shipping address updates through the UI or service execution.  

### **Step 7: Creating an Order Search Screen Using FTL**  
1. Create a FreeMarker Template Language (FTL) file named `findOrder.ftl`.  
2. Develop a user interface to search for orders using the `findOrder` service.  
3. Include input fields for filtering by Order ID, Customer Name, Date Range, Status, Payment Status, and Shipping Address.  
4. Display the search results in a tabular format with pagination support.  
5. Ensure the UI interacts correctly with OFBiz backend services.  
6. Test the order search screen to confirm it retrieves and displays results properly.  

### **Step 8: Creating an Order Ship Group Management Screen (FTL)**  
1. Create a FreeMarker Template Language (FTL) file named `createOrderShipGroup.ftl`.  
2. Develop a user interface to:  
   - **Enter an Order ID** to create a new ship group.  
   - **Select a shipping method** from a dropdown menu.  
   - **Optionally enter an estimated delivery date**.  
   - **Submit the request to create a ship group** using the `createOrderItemShipGroup` service.  
3. Create another FTL file named `findOrderShipGroups.ftl` that allows users to:  
   - **Enter an Order ID** to view all associated ship groups.  
   - **Display the retrieved ship group data in a table** with pagination.  
   - **Show shipment statuses and related order items**.  
4. Ensure the UI interacts correctly with OFBiz backend services.  
5. Test both screens to confirm they display and update shipment groups properly.  


## **Deliverables**  
1. A fully functional OFBiz plugin named `OrderManagement`.  
2. Properly defined entities, services, and event mappings.  
3. Sample test cases used to validate the services and event triggers.  

## **Evaluation Criteria**  
1. **Correctness** – The plugin should function as expected and retrieve, create, and update order records properly.  
2. **Code Structure** – The project should be well-structured, following OFBiz conventions.  
3. **Entity Relationships** – The `FindOrderView` entity should correctly join relevant data tables.  
4. **Service Implementation** – Services should handle input validation and ensure data integrity.  
5. **Event Handling** – Events should be correctly mapped and triggered within OFBiz.  

