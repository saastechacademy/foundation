# SQL Assignment 4

### 1 Total Shipments in January 2022

**Business Problem:**  
Logistics managers want to see how many shipments went out at the start of 2022. This helps assess shipping volumes and plan for post-holiday periods.

**Fields to Retrieve:**  
- `SHIPMENT_ID`  
- `SHIPMENT_DATE`  
- `FACILITY_ID` 
- `ORDER_ID`  

### 2 Shipments by Tracking Number

**Business Problem:**  
Customer Service often needs to look up shipments by **tracking number** to answer delivery queries quickly.

**Fields to Retrieve:**  
- `SHIPMENT_ID`  
- `ORDER_ID`  
- `TRACKING_NUMBER`  
- `SHIPMENT_DATE`  
- `CARRIER_PARTY_ID`
- `SHIPMENT_STATUS`

### 3 Average Shipments per Month (Q1 2022)

**Business Problem:**  
Operations wants to find the **average number of shipments** from all stores for each month in **Q1 2022** (January, February, March).

**Fields to Retrieve:**  
- `MONTH`
- `AVERAGE_SHIPMENTS`

### 4 Brokered but Not Shipped Orders

**Business Problem:**  
Merchandising teams need to track orders that have been **brokered** (allocated to a facility) but **not shipped**. They also want to know how long it has been since the order was brokered.

**Fields to Retrieve:**  
- `ORDER_ID`  
- `BROKERED_DATE` 
- `BROKERED_FACILITY_ID`  
- `SHIPMENT_STATUS`  
- `TIME_SINCE_BROKERING`

### 5 Multi-Item Orders (Single Ship Group)

**Business Problem:**  
For analyzing shipping efficiency, some businesses want to know which **multi-item orders** (more than one product) were **fulfilled in one shipment** (same ship group).

**Fields to Retrieve:**  
- `ORDER_ID`  
- `TOTAL_ITEMS_IN_ORDER`  
- `SHIP_GROUP_SEQ_ID`
- `SHIPMENT_ID`  
- `FACILITY_ID`  
- `SHIPMENT_DATE`

### 6 Orders Shipped from Stores (25 Days Before New Year)

**Business Problem:**  
Retailers often run **holiday promos** in late December and need visibility into orders shipped from **stores** (as opposed to warehouses) for the final 25 days of the year.

**Fields to Retrieve:**  
- `ORDER_ID`  
- `SHIPMENT_ID`  
- `FACILITY_ID` (store ID)  
- `SHIPMENT_DATE`  
- `ORDER_DATE`  
- `TOTAL_ITEMS`  
- `CUSTOMER_STATE`

### 7 Single-Item Orders Fulfilled from Warehouses (Last Month)

**Business Problem:**  
Identify how many single-item orders were fulfilled from **warehouse facilities** in the previous month, to assess picking/packing efficiency.

**Fields to Retrieve:**  
- `ORDER_ID`  
- `TOTAL_ORDER_ITEMS`
- `FACILITY_ID`
- `SHIPMENT_ID`  
- `SHIPMENT_DATE`  
- `ORDER_COMPLETION_DATE`

### 8 Shipping Refunds (Last Month)

**Business Problem:**  
The finance department needs to confirm the **total value of shipping refunds** processed last month to measure potential overages or carrier-related service issues.

**Fields to Retrieve:**  
- `RETURN_ADJUSTMENT_ID`
- `ORDER_ID`  
- `REFUND_AMOUNT`  
- `REFUND_REASON_CODE`
- `REFUND_DATE`  
- `CUSTOMER_ID`

---

### 9 Shipping Revenue (Last Month)

**Business Problem:**  
Finance also needs to know how much was **earned from shipping charges** in the same period, often a subset of overall revenue.

**Fields to Retrieve:**  
- `TOTAL ORDER`  
- `TOTAL_SHIPPING_REVENUE`
- `MONTH`

### 10 Returns Without Restock Location

**Business Problem:**  
A restock location should be specified when a product is returned, so the item can re-enter the correct facility’s inventory. The business wants to find returns missing this detail.

**Fields to Retrieve:**  
- `RETURN_ID`  
- `ORDER_ID`  
- `RETURN_DATE`  
- `FROM_PARTY_ID` 
- `RESTOCK_FACILITY_ID` 
- `RETURN_REASON`

### 11 How Long It Takes Facilities (Stores) to Fulfill Orders

**Business Problem:**  
Management needs to measure the average **fulfillment time** (order creation to shipment or pick-up) at each store/facility.

**Fields to Retrieve:**  
- `FACILITY_ID`  
- `ORDER_ID`  
- `ORDER_DATE`  
- `SHIPMENT_DATE`
- `FULFILLMENT_TIME` 
- `AVERAGE_FULFILLMENT_TIME` 

### 12 List the Product’s Primary ID

**Business Problem:**  
Every retailer has a specific product ID type that they throughout their systems for consistency, such as SKU or UPCA. Identify which one is used, and return the ID value for all products.

**Fields to Retrieve:**  
- `PRODUCT_ID` 
- `PRIMARY ID TYPE`
- `PRIMARY ID VALUE`