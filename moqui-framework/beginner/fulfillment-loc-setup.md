
# **Fulfillment Inventory Management**

## **Objective:**
This assignment is designed to provide practical experience in managing a warehouse inventory system. Interns will engage in setting up a warehouse, managing stock levels. The goal is to familiarize you with the fundamental concepts of inventory management in a warehouse setting.

### **Activity 1: Setup Warehouse**

1. **Create a Warehouse Facility:**
   - Define a facility named "Main Warehouse".
   - Assign the type as "Warehouse".
   - Generate an XML snippet to represent this setup:
     ```xml
     <Facility facilityId="WAREHOUSE1" facilityName="Main Warehouse" type="Warehouse" />
     ```

2. **Define Warehouse Locations:**
   - Setup two main areas within the warehouse: Bulk and Pick.

3. **Product Assignment:**
   - Setup products for inventory management.
   - Assign locations to each product.
   - Ensure a minimum stock of 3 units for all products.

### **Activity 2: Manage Current Stock Levels**

1. **Initial Stock Setup:**
   - Create entries for 10 different products with random stock quantities.
   - Use this XML structure for your entries:
     ```xml
     <Asset assetId="A1001" productId="P001" quantityOnHandTotal="34" />
     ```
   - Extend this for products P002 to P010.

### **Activity 3: Plan and Execute Physical Count**

1. **Schedule Physical Count:**
   - Set a count date (e.g., "2023-01-01").
   - Status should be "PLANNED".
   - Use this XML snippet:
     ```xml
     <PhysicalInventory physicalInventoryId="PI1000" inventoryCountDate="2023-01-01" statusId="PLANNED" />
     <PhysicalCount physicalInventoryId="PI1000" productId="P001" />
     ```
   - Include additional entries for products P002 to P010.

2. **Update Count Status to 'In Progress':**
   - Change the count date and status to "IN_PROGRESS".
   - Add quantities for each product.
   - Example XML snippet:
     ```xml
     <PhysicalInventory physicalInventoryId="PI1000" inventoryCountDate="2023-01-01" statusId="IN_PROGRESS" />
     <PhysicalCount physicalInventoryId="PI1000" productId="P001" quantity="4" />
     ```
   - Continue for products P002 to P010.


### **View Entities Discussion:**

- **AssetAndDetailSummary**
- **AssetOnHandSummary**

Discuss these entities based on your activities and understanding of the system.

### **Instructions for Interns:**

- Carefully read through each activity and understand the objectives.
- Use the provided XML structures as templates for your tasks.
- Ensure accuracy in your XML coding to reflect realistic inventory scenarios.
- Discuss the implications and learnings from each activity.
- Prepare to discuss the "AssetAndDetailSummary" and "AssetOnHandSummary" view entities.

