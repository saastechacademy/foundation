# SQL Assignment 3

### 1 Completed Sales Orders (Physical Items)

**Business Problem:**  
Merchants need to track only physical items (requiring shipping and fulfillment) for logistics and shipping-cost analysis.

**Fields to Retrieve:**  
- `ORDER_ID`  
- `ORDER_ITEM_SEQ_ID`  
- `PRODUCT_ID`  
- `PRODUCT_TYPE_ID`  
- `SALES_CHANNEL_ENUM_ID`  
- `ORDER_DATE`  
- `ENTRY_DATE`  
- `STATUS_ID`  
- `STATUS_DATETIME`  
- `ORDER_TYPE_ID`  
- `PRODUCT_STORE_ID`  

### 2 Completed Return Items

**Business Problem:**  
Customer service and finance often need insights into **returned items** to manage refunds, replacements, and inventory restocking.

**Fields to Retrieve:**  
- `RETURN_ID`  
- `ORDER_ID`  
- `PRODUCT_STORE_ID`  
- `STATUS_DATETIME`  
- `ORDER_NAME`  
- `FROM_PARTY_ID`
- `RETURN_DATE`  
- `ENTRY_DATE`  
- `RETURN_CHANNEL_ENUM_ID`

### 3 Single-Return Orders (Last Month)

**Business Problem:**  
The mechandising team needs a list of orders that only have one return.

**Fields to Retrieve:**  
- `PARTY_ID`  
- `FIRST_NAME`

### 4 Returns and Appeasements 

**Business Problem:**  
The retailer needs the total amount of items, were returned as well as how many appeasements were issued.

**Fields to Retrieve:**  
- `TOTAL RETURNS`
- `RETURN $ TOTAL`
- `TOTAL APPEASEMENTS`
- `APPEASEMENTS $ TOTAL`

### 5 Detailed Return Information

**Business Problem:**  
Certain teams need granular return data (reason, date, refund amount) for analyzing return rates, identifying recurring issues, or updating policies.

**Fields to Retrieve:**  
- `RETURN_ID`  
- `ENTRY_DATE`  
- `RETURN_ADJUSTMENT_TYPE_ID` (refund type, store credit, etc.)  
- `AMOUNT`  
- `COMMENTS`  
- `ORDER_ID`  
- `ORDER_DATE`  
- `RETURN_DATE`  
- `PRODUCT_STORE_ID`

### 6 Orders with Multiple Returns

**Business Problem:**  
Analyzing orders with multiple returns can identify potential fraud, chronic issues with certain items, or inconsistent shipping processes.

**Fields to Retrieve:**  
- `ORDER_ID`  
- `RETURN_ID`  
- `RETURN_DATE`  
- `RETURN_REASON`  
- `RETURN_QUANTITY`


### 7 Store with Most One-Day Shipped Orders (Last Month)

**Business Problem:**  
Identify which facility (store) handled the highest volume of “one-day shipping” orders in the previous month, useful for operational benchmarking.

**Fields to Retrieve:**  
- `FACILITY_ID`
- `FACILITY_NAME`  
- `TOTAL_ONE_DAY_SHIP_ORDERS`  
- `REPORTING_PERIOD`


### 8 List of Warehouse Pickers

**Business Problem:**  
Warehouse managers need a list of employees responsible for picking and packing orders to manage shifts, productivity, and training needs.

**Fields to Retrieve:**  
- `PARTY_ID` (or Employee ID)  
- `NAME` (First/Last)  
- `ROLE_TYPE_ID` (e.g., “WAREHOUSE_PICKER”)  
- `FACILITY_ID` (assigned warehouse)  
- `STATUS` (active or inactive employee)

---

### 9 Total Facilities That Sell the Product

**Business Problem:**  
Retailers want to see how many (and which) facilities (stores, warehouses, virtual sites) currently offer a product for sale.

**Fields to Retrieve:**  
- `PRODUCT_ID`  
- `PRODUCT_NAME` (or `INTERNAL_NAME`)  
- `FACILITY_COUNT` (number of facilities selling the product)  
- (Optionally) a **list of FACILITY_IDs** if more detail is needed

---

### 10 Total Items in Various Virtual Facilities

**Business Problem:**  
Retailers need to study the relation of inventory levels of products to the type of facility it's stored at. Retrieve all inventory levels for products at locations and include the facility type Id. Do not retrieve facilities that are of type Virtual.

**Fields to Retrieve:**  
- `PRODUCT_ID`  
- `FACILITY_ID`
- `FACILITY_TYPE_ID`
- `QOH` (Quantity on Hand)  
- `ATP` (Available to Promise)

### 11 Transfer Orders Without Inventory Reservation

**Business Problem:**  
When transferring stock between facilities, the system should reserve inventory. If it isn’t reserved, the transfer may fail or oversell.

**Fields to Retrieve:**  
- `TRANSFER_ORDER_ID`  
- `FROM_FACILITY_ID`  
- `TO_FACILITY_ID`  
- `PRODUCT_ID`  
- `REQUESTED_QUANTITY`  
- `RESERVED_QUANTITY`  
- `TRANSFER_DATE`  
- `STATUS`

### 12 Orders Without Picklist

**Business Problem:**  
A picklist is necessary for warehouse staff to gather items. Orders missing a picklist might be delayed and need attention.

**Fields to Retrieve:**  
- `ORDER_ID`  
- `ORDER_DATE`  
- `ORDER_STATUS`  
- `FACILITY_ID`
- `DURATION` (How long has the order been assigned at the facility)
