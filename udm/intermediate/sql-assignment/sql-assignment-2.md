# SQL Assignment 2

Below is a structured list of queries for **Mixed Party + Order** scenarios and **Inventory Management & Transfers**, along with several additional questions. Each section contains the **Business Problem** and the **Fields to Retrieve**, **without** example SQL code.

---

## 5. Mixed Party + Order Queries

### 5.1 Shipping Addresses for October 2023 Orders

**Business Problem:**  
Customer Service might need to verify addresses for orders placed or completed in October 2023. This helps ensure shipments are delivered correctly and prevents address-related issues.

**Fields to Retrieve:**  
- `ORDER_ID` 
- `PARTY_ID` (Customer ID)  
- `CUSTOMER_NAME` (or FIRST_NAME / LAST_NAME)  
- `STREET_ADDRESS`  
- `CITY` 
- `STATE_PROVINCE`
- `POSTAL_CODE`  
- `COUNTRY_CODE`  
- `ORDER_STATUS`  
- `ORDER_DATE`


### 5.2 Orders from New York

**Business Problem:**  
Companies often want region-specific analysis to plan local marketing, staffing, or promotions in certain areas—here, specifically, New York.

**Fields to Retrieve:**  
- `ORDER_ID` 
- `CUSTOMER_NAME` 
- `STREET_ADDRESS` (or shipping address detail)  
- `CITY`  
- `STATE_PROVINCE`
- `POSTAL_CODE` 
- `TOTAL_AMOUNT`
- `ORDER_DATE`  
- `ORDER_STATUS`

---

### 5.3 Top-Selling Product in New York

**Business Problem:**  
Merchandising teams need to identify the best-selling product(s) in a specific region (New York) for targeted restocking or promotions.

**Fields to Retrieve:**  
- `PRODUCT_ID`  
- `INTERNAL_NAME`
- `TOTAL_QUANTITY_SOLD`  
- `CITY` / `STATE` (within New York region) 
- `REVENUE` (optionally, total sales amount)

### 7.3 Store-Specific (Facility-Wise) Revenue

**Business Problem:**  
Different physical or online stores (facilities) may have varying levels of performance. The business wants to compare revenue across facilities for sales planning and budgeting.

**Fields to Retrieve:**  
- `FACILITY_ID`
- `FACILITY_NAME`  
- `TOTAL_ORDERS` 
- `TOTAL_REVENUE`  
- `DATE_RANGE` 

## 8. Inventory Management & Transfers

### 8.1 Lost and Damaged Inventory

**Business Problem:**  
Warehouse managers need to track “shrinkage” such as lost or damaged inventory to reconcile physical vs. system counts.

**Fields to Retrieve:**  
- `INVENTORY_ITEM_ID` 
- `PRODUCT_ID` 
- `FACILITY_ID` 
- `QUANTITY_LOST_OR_DAMAGED` 
- `REASON_CODE` (Lost, Damaged, Expired, etc.)  
- `TRANSACTION_DATE`

### 8.2 Low Stock or Out of Stock Items Report

**Business Problem:**  
Avoiding out-of-stock situations is critical. This report flags items that have fallen below a certain reorder threshold or have zero available stock.

**Fields to Retrieve:**  
- `PRODUCT_ID`
- `PRODUCT_NAME` 
- `FACILITY_ID`  
- `QOH` (Quantity on Hand)  
- `ATP` (Available to Promise)  
- `REORDER_THRESHOLD` 
- `DATE_CHECKED`

### 8.3 Retrieve the Current Facility (Physical or Virtual) of Open Orders

**Business Problem:**  
The business wants to know where open orders are currently assigned, whether in a physical store or a virtual facility (e.g., a distribution center or online fulfillment location).

**Fields to Retrieve:**  
- `ORDER_ID`  
- `ORDER_STATUS`
- `FACILITY_ID`  
- `FACILITY_NAME`  
- `FACILITY_TYPE_ID`

### 8.4 Items Where QOH and ATP Differ

**Business Problem:**  
Sometimes the **Quantity on Hand (QOH)** doesn’t match the **Available to Promise (ATP)** due to pending orders, reservations, or data discrepancies. This needs review for accurate fulfillment planning.

**Fields to Retrieve:**  
- `PRODUCT_ID`
- `FACILITY_ID`
- `QOH` (Quantity on Hand)  
- `ATP` (Available to Promise)  
- `DIFFERENCE` (QOH - ATP)

### 8.5 Order Item Current Status Changed Date-Time

**Business Problem:**  
Operations teams need to audit when an order item’s status (e.g., from “Pending” to “Shipped”) was last changed, for shipment tracking or dispute resolution.

**Fields to Retrieve:**  
- `ORDER_ID` 
- `ORDER_ITEM_SEQ_ID` 
- `CURRENT_STATUS_ID` 
- `STATUS_CHANGE_DATETIME`
- `CHANGED_BY`


### 8.6 Total Orders by Sales Channel

**Business Problem:**  
Marketing and sales teams want to see how many orders come from each channel (e.g., web, mobile app, in-store POS, marketplace) to allocate resources effectively.

**Fields to Retrieve:**  
- `SALES_CHANNEL`
- `TOTAL_ORDERS`
- `TOTAL_REVENUE`
- `REPORTING_PERIOD` 
