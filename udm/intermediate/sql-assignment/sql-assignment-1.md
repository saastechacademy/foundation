# SQL Assignment 1

### 1 New Customers Acquired in June 2023

**Business Problem:**  
The marketing team ran a campaign in June 2023 and wants to see how many new customers signed up during that period.

**Fields to Retrieve:**  
- `PARTY_ID`  
- `FIRST_NAME`  
- `LAST_NAME`  
- `EMAIL`  
- `PHONE`  
- `ENTRY_DATE`

### 2 List All Active Physical Products

**Business Problem:**  
Merchandising teams often need a list of all physical products to manage logistics, warehousing, and shipping.

**Fields to Retrieve:**  
- `PRODUCT_ID`  
- `PRODUCT_TYPE_ID`  
- `INTERNAL_NAME`

### 3 Products Missing NetSuite ID

**Business Problem:**  
A product cannot sync to NetSuite unless it has a valid NetSuite ID. The OMS needs a list of all products that still need to be created or updated in NetSuite.

**Fields to Retrieve:**  
- `PRODUCT_ID`  
- `INTERNAL_NAME`  
- `PRODUCT_TYPE_ID`  
- `NETSUITE_ID` (or similar field indicating the NetSuite ID; may be `NULL` or empty if missing)

### 4 Product IDs Across Systems

**Business Problem:**  
To sync an order or product across multiple systems (e.g., Shopify, HotWax, ERP/NetSuite), the OMS needs to know each system’s unique identifier for that product. This query retrieves the Shopify ID, HotWax ID, and ERP ID (NetSuite ID) for all products.

**Fields to Retrieve:**  
- `PRODUCT_ID` (internal OMS ID)  
- `SHOPIFY_ID`  
- `HOTWAX_ID`  
- `ERP_ID` or `NETSUITE_ID` (depending on naming)

### 5 Completed Orders in August 2023

**Business Problem:**  
After running similar reports for a previous month, you now need all completed orders in August 2023 for analysis.

**Fields to Retrieve:**  
- `PRODUCT_ID`  
- `PRODUCT_TYPE_ID`  
- `PRODUCT_STORE_ID`  
- `TOTAL_QUANTITY`  
- `INTERNAL_NAME`  
- `FACILITY_ID`  
- `EXTERNAL_ID`  
- `FACILITY_TYPE_ID`  
- `ORDER_HISTORY_ID`  
- `ORDER_ID`  
- `ORDER_ITEM_SEQ_ID`  
- `SHIP_GROUP_SEQ_ID`

### 7 Newly Created Sales Orders and Payment Methods

**Business Problem:**  
Finance teams need to see new orders and their payment methods for reconciliation and fraud checks.

**Fields to Retrieve:**  
- `ORDER_ID`
- `TOTAL_AMOUNT`
- `PAYMENT_METHOD`  
- `Shopify Order ID` (if applicable)

### 8 Payment Captured but Not Shipped

**Business Problem:**  
Finance teams want to ensure revenue is recognized properly. If payment is captured but no shipment has occurred, it warrants further review.

**Fields to Retrieve:**  
- `ORDER_ID`  
- `ORDER_STATUS`  
- `PAYMENT_STATUS`  
- `SHIPMENT_STATUS`

### 9 Orders Completed Hourly

**Business Problem:**  
Operations teams may want to see how orders complete across the day to schedule staffing.

**Fields to Retrieve:**  
- `TOTAL ORDERS`  
- `HOUR`

### 10 BOPIS Orders Revenue (Last Year)

**Business Problem:**  
**BOPIS** (Buy Online, Pickup In Store) is a key retail strategy. Finance wants to know the revenue from BOPIS orders for the previous year.

**Fields to Retrieve:**  
- `TOTAL ORDERS`  
- `TOTAL REVENUE`

### 11 Canceled Orders (Last Month)

**Business Problem:**  
The merchandising team needs to know how many orders were canceled in the previous month and their reasons.

**Fields to Retrieve:**  
- `TOTAL ORDERS`  
- `CANCELATION REASON`

### 12 Product Threshold Value

**Business Problem**
The retailer has set a threshild value for products that are sold online, in order to avoid over selling. 

**Fields to Retrieve:**
- `PRODUCT ID`
- `THRESHOLD`