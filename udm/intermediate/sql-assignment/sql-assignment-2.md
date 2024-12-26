# SQL Assignment 2

As a member of the analytics team, your task is to use SQL to extract specific data sets that provide insights across various departments. Retrieve the following data for analysis.

## 1. Sales Performance and Customer Behavior

### a. Completed Sales Orders

Retrieve data for physical items from completed sales orders:

- `ORDER_ID`
- `ORDER_ITEM_SEQ_ID`
- `PRODUCT_ID`
- `PRODUCT_TYPE_ID`
- `IS_PHYSICAL`
- `IS_DIGITAL`
- `SALES_CHANNEL_ENUM_ID`
- `ORDER_DATE`
- `ENTRY_DATE`
- `STATUS_ID`
- `STATUS_DATETIME`
- `ORDER_TYPE_ID`
- `PRODUCT_STORE_ID`

### b. Completed Return Items

Fetch details of completed returns:

- `RETURN_ID`
- `ORDER_ID`
- `PRODUCT_STORE_ID`
- `STATUS_DATETIME`
- `ORDER_NAME`
- `FROM_PARTY_ID`
- `RETURN_DATE`
- `ENTRY_DATE`
- `RETURN_CHANNEL_ENUM_ID`

### c. Completed Orders in July 2023

Retrieve orders completed in July 2023:

- `ORDER_ID`
- `ORDER_ITEM_SEQ_ID`
- `Shopify Order ID`
- `Shopify Product ID`

### d. Completed Orders in August 2023

Fetch data for orders completed in August 2023:

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

## 2. Fulfillment Efficiency and Operational Review

### a. Shipping Addresses for October 2023 Orders

Retrieve shipping addresses for orders completed in October 2023:

- `ORDER_ID`
- `CONTACT_MECH_ID` (Shipping Address)

### b. Warehouse Performance for September 2023

Fetch data on physical items completed from the warehouse in September 2023:

- `ORDER_ID`
- `ORDER_ITEM_SEQ_ID`
- `PRODUCT_ID`
- `QUANTITY`
- `FACILITY_ID`
- `SHIP_GROUP_SEQ_ID`
- `ORDER_STATUS`
- `STATUS_DATETIME`

### c. Procurement Patterns for September 2023

Retrieve details of physical items ordered in September 2023:

- `ORDER_ID`
- `ORDER_ITEM_SEQ_ID`
- `PRODUCT_ID`
- `QUANTITY`
- `ORDER_DATE`
- `ORDER_STATUS`
- `PRODUCT_TYPE_ID`

## 3. Financial Health and Order Integrity

### a. Newly Created Sales Orders and Payment Methods

Fetch data on all newly created sales orders:

- `ORDER_ID`
- `TOTAL_AMOUNT`
- `PAYMENT_METHOD` (e.g., Cash, Mastercard, Visa, PayPal)
- `Shopify Order ID`

## 4. Customer Relations and Satisfaction

### a. New Customers Acquired in June 2023

Retrieve data for customers created in June 2023:

- `CUSTOMER_ID`
- `CUSTOMER_NAME`
- `EMAIL`
- `PHONE`
- `ENTRY_DATE`
- `CUSTOMER_STATUS`

### b. Appeasements Issued in July

Fetch details of appeasements issued:

- `ORDER_ID`
- `APPEASEMENT_REASON`
- `APPEASEMENT_DATE`
- `APPEASEMENT_AMOUNT`
- `COMMENTS`

### c. Distinguishing Returns from Appeasements

- **Returns**: Products sent back by customers; involves refunds or exchanges.
- **Appeasements**: Compensation offered without requiring product returns.

### d. Detailed Return Information

Retrieve detailed return data:

- `RETURN_ID`
- `ENTRY_DATE`
- `RETURN_ADJUSTMENT_TYPE_ID`
- `AMOUNT`
- `COMMENTS`
- `ORDER_ID`
- `ORDER_DATE`
- `RETURN_DATE`
- `PRODUCT_STORE_ID`

### e. Orders with Multiple Returns

Identify orders with multiple returns:

- `ORDER_ID`
- `RETURN_ID`
- `RETURN_DATE`
- `RETURN_REASON`
- `RETURN_QUANTITY`

## 5. Inventory Management and Variance Analysis

### a. Lost and Damaged Inventory

Retrieve data on inventory variances due to loss or damage:

- `PRODUCT_ID`
- `FACILITY_ID`
- `VARIANCE_TYPE`
- `QUANTITY`
- `ENTRY_DATE`
- `REASON`