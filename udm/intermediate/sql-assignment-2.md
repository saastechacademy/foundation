# SQL Assignment 2

## Business Context

As part of the analytics team at [Your Company], you have been tasked with supporting multiple departments by providing critical insights into sales orders, returns, shipments, and inventory discrepancies. Your job is to help each team improve their processes by retrieving the required data efficiently. Each department has unique requirements, and they rely on you to provide detailed reports based on their needs.

You have already reviewed the data model used by the company, and your task is to write SQL queries that extract the necessary information. The data fetched from these queries will be used to streamline operations, enhance customer service, and improve financial reporting. 

## Task Categories

### 1. Sales Orders and Returns Overview

The sales and customer service teams are particularly focused on reviewing completed sales orders and returns to understand customer behavior and product performance.

#### a. Completed Order Items (Sales Orders, [YOUR_STORE], Physical Items)

The sales team is analyzing all completed physical items from sales orders to track how products are performing. Fetch the following columns to help them understand the order completion process:

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

#### b. Completed Return Items ([YOUR_STORE], Ecom Return Channel)

The returns process is crucial for understanding product satisfaction. Fetch return item details to provide insight into completed returns:

- `RETURN_ID`
- `ORDER_ID`
- `PRODUCT_STORE_ID`
- `STATUS_DATETIME`
- `ORDER_NAME`
- `FROM_PARTY_ID`
- `RETURN_DATE`
- `ENTRY_DATE`
- `RETURN_CHANNEL_ENUM_ID`

---

### 2. Shipment and Order Completion Review

The fulfillment and operations teams need to analyze orders completed in specific time frames and investigate discrepancies to ensure smooth processing.

#### a. Orders Completed in October 2023 (Shipping Address)

Fulfillment is interested in reviewing all orders completed in October 2023 and their respective shipping addresses. Fetch the following:

- `ORDER_ID`
- `CONTACT_MECH_ID` (for shipping address)

#### b. Physical Items Completed from Warehouse (September 2023)

The warehouse team is assessing their September performance. Retrieve the following data for physical items completed in the warehouse:

- `ORDER_ID`
- `ORDER_ITEM_SEQ_ID`
- `PRODUCT_ID`
- `QUANTITY`
- `FACILITY_ID`
- `SHIP_GROUP_SEQ_ID`
- `ORDER_STATUS`
- `STATUS_DATETIME`

#### c. Physical Items Ordered (September 2023)

Procurement needs to understand ordering patterns. Fetch details of physical items ordered during September 2023, including:

- `ORDER_ID`
- `ORDER_ITEM_SEQ_ID`
- `PRODUCT_ID`
- `QUANTITY`
- `ORDER_DATE`
- `ORDER_STATUS`
- `PRODUCT_TYPE_ID`

---

### 3. Financial Metrics for Sales Orders

The finance team requires specific insights into order creation and payment patterns to better understand revenue streams and customer payment preferences.

#### a. Created Sales Orders

Fetch data on all newly created sales orders, focusing on their total amount and the payment methods used. This helps in understanding financial performance:

- `ORDER_ID`
- `TOTAL_AMOUNT`
- `PAYMENT_METHOD` (Cash, Mastercard, Visa, PayPal, etc.)
- `SHOPIFY_ORDER_NAME`

#### b. Order Status Discrepancies

Approved orders should reflect accurate statuses. However, discrepancies can occur, causing delays in fulfillment. Help the team find these issues:

- **Approved Orders with Multiple Completed Items:**  
  Find orders where two or more items are marked as completed, but the order itself remains in the "approved" status.
  
- **Approved Orders with Multiple Canceled Items:**  
  Find orders where two or more items are canceled, but the order remains in the "approved" status.

---

### 4. Historical Order Insights

Understanding the order history is vital for operations and financial reporting. Past order data helps assess trends and identify issues for future improvement.

#### a. Completed Order Items (July 2023)

The operations team wants to review all completed order items from July 2023. Fetch these columns to help them analyze:

- `ORDER_ID`
- `ORDER_ITEM_SEQ_ID`
- `SHOPIFY_ORDER_ID`
- `SHOPIFY_PRODUCT_ID`

#### b. Orders Completed (August 2023)

Analyze orders completed in August 2023. Fetch the following columns for all completed orders:

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

---

### 5. Customer, Returns, and Inventory Insights

Customer relations and inventory control are integral to understanding product performance and ensuring that lost or damaged items are properly accounted for.

#### a. Customers Created in June 2023

The customer relations team needs to track all customers created in June 2023. Fetch customer data to help them analyze:

- `CUSTOMER_ID`
- `CUSTOMER_NAME`
- `EMAIL`
- `PHONE`
- `ENTRY_DATE`
- `CUSTOMER_STATUS`

#### b. Appeasements in July

Appeasements issued for customer satisfaction are a key metric for the customer service team. Fetch all relevant data about appeasements, including:

- `ORDER_ID`
- `APPEASEMENT_REASON`
- `APPEASEMENT_DATE`
- `APPEASEMENT_AMOUNT`
- `COMMENTS`

#### c. Returns vs. Appeasements

The finance team needs an explanation of the differences between returns and appeasements. Provide a detailed explanation of these two processes and how they differ in the system.

#### d. Return Details

Fetch detailed information regarding returns to assist with customer satisfaction analysis:

- `RETURN_ID`
- `ENTRY_DATE`
- `RETURN_ADJUSTMENT_TYPE_ID`
- `AMOUNT`
- `COMMENTS`
- `ORDER_ID`
- `ORDER_DATE`
- `RETURN_DATE`
- `PRODUCT_STORE_ID`

#### e. Inventory Variances (Lost/Damaged)

The inventory team is investigating losses and damages. Fetch all product inventory variances where the reason is "VAR_LOST" or "VAR_DAMAGED," including:

- `PRODUCT_ID`
- `FACILITY_ID`
- `VARIANCE_TYPE`
- `QUANTITY`
- `ENTRY_DATE`
- `REASON`

---

### 6. Order Returns and Inventory Issues

Returning products multiple times can indicate a recurring problem. Find data related to multiple returns and inventory losses.

#### a. Orders with Multiple Returns

Identify orders with multiple returns to understand recurring product or service issues:

- `ORDER_ID`
- `RETURN_ID`
- `RETURN_DATE`
- `RETURN_REASON`
- `RETURN_QUANTITY`

## Conclusion

By completing this data fetch assignment, you will provide key insights that will improve operational processes, financial reporting, and customer service. Make sure your SQL queries are efficient and accurate, addressing the specific data requirements outlined by each department.