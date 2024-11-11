# SQL Assignment 2

## Introduction

In today's data-driven environment, insightful analytics are pivotal for organizations aiming to optimize operations, enhance customer satisfaction, and improve financial performance. As a member of the analytics team at [Your Company], your role is to extract and analyze data that provides actionable insights across various departments, including sales, customer service, fulfillment, finance, and operations.

This assignment outlines a comprehensive analytics story that delves into sales performance, operational efficiency, financial health, customer relations, and inventory management. By logically categorizing and analyzing the data, you will help each department understand their processes better and make informed decisions to drive the company forward.

## 1. Sales Performance and Customer Behavior

Understanding sales performance and customer behavior is essential for driving revenue growth and enhancing product offerings. This section focuses on analyzing completed sales orders, historical sales data, and returns to gain insights into product performance and customer satisfaction.

### a. Analysis of Completed Sales Orders

The sales team is interested in tracking the performance of physical items from completed sales orders. Retrieve the following data to help them analyze product performance and sales channels:

- **ORDER_ID**
- **ORDER_ITEM_SEQ_ID**
- **PRODUCT_ID**
- **PRODUCT_TYPE_ID**
- **IS_PHYSICAL**
- **IS_DIGITAL**
- **SALES_CHANNEL_ENUM_ID**
- **ORDER_DATE**
- **ENTRY_DATE**
- **STATUS_ID**
- **STATUS_DATETIME**
- **ORDER_TYPE_ID**
- **PRODUCT_STORE_ID**

This data will enable the team to assess which products are performing well, identify trends across different sales channels, and understand the efficiency of the order completion process.

### b. Evaluation of Completed Return Items

Returns provide valuable insights into customer satisfaction and product issues. Fetch the following return item details to analyze completed returns:

- **RETURN_ID**
- **ORDER_ID**
- **PRODUCT_STORE_ID**
- **STATUS_DATETIME**
- **ORDER_NAME**
- **FROM_PARTY_ID**
- **RETURN_DATE**
- **ENTRY_DATE**
- **RETURN_CHANNEL_ENUM_ID**

Analyzing this information helps identify patterns in returns, understand reasons behind customer dissatisfaction, and address product-related issues promptly.

### c. Review of Completed Orders in July 2023

The operations team requires data on completed orders from **July 2023** to assess performance. Retrieve:

- **ORDER_ID**
- **ORDER_ITEM_SEQ_ID**
- **Shopify Order ID**
- **Shopify Product ID**

This helps in evaluating the effectiveness of sales strategies and product popularity during that period.

### d. Analysis of August 2023 Completed Orders

For a broader perspective, fetch data on orders completed in **August 2023**:

- **PRODUCT_ID**
- **PRODUCT_TYPE_ID**
- **PRODUCT_STORE_ID**
- **TOTAL_QUANTITY**
- **INTERNAL_NAME**
- **FACILITY_ID**
- **EXTERNAL_ID**
- **FACILITY_TYPE_ID**
- **ORDER_HISTORY_ID**
- **ORDER_ID**
- **ORDER_ITEM_SEQ_ID**
- **SHIP_GROUP_SEQ_ID**

This comprehensive dataset allows for in-depth analysis of sales trends, operational efficiency, and product performance.

## 2. Fulfillment Efficiency and Operational Review

Efficient fulfillment processes are crucial for customer satisfaction and operational cost management. This section focuses on analyzing shipment details, order completion times, warehouse performance, and procurement patterns.

### a. Shipping Address Analysis for October 2023 Orders

The fulfillment team needs to review orders completed in **October 2023** and their shipping addresses to optimize delivery processes. Retrieve:

- **ORDER_ID**
- **CONTACT_MECH_ID** (Shipping Address)

This will help in identifying geographical areas with high order volumes and potential delivery challenges.

### b. Warehouse Performance for September 2023

To assess warehouse efficiency, fetch data on physical items completed from the warehouse in **September 2023**:

- **ORDER_ID**
- **ORDER_ITEM_SEQ_ID**
- **PRODUCT_ID**
- **QUANTITY**
- **FACILITY_ID**
- **SHIP_GROUP_SEQ_ID**
- **ORDER_STATUS**
- **STATUS_DATETIME**

Analyzing this data can highlight bottlenecks, inventory management issues, and opportunities for process improvements within the warehouse operations.

### c. Procurement Patterns for September 2023

Understanding ordering patterns aids in inventory planning and procurement strategies. Retrieve details of physical items ordered in **September 2023**:

- **ORDER_ID**
- **ORDER_ITEM_SEQ_ID**
- **PRODUCT_ID**
- **QUANTITY**
- **ORDER_DATE**
- **ORDER_STATUS**
- **PRODUCT_TYPE_ID**

This information will help the procurement team anticipate demand and adjust purchasing accordingly.

## 3. Financial Health and Order Integrity

Financial performance is directly linked to accurate order processing and payment collection. This section addresses the creation of sales orders, payment methods, and discrepancies in order statuses.

### a. Newly Created Sales Orders and Payment Methods

The finance team needs data on all newly created sales orders to understand revenue streams and customer payment preferences. Fetch:

- **ORDER_ID**
- **TOTAL_AMOUNT**
- **PAYMENT_METHOD** (e.g., Cash, Mastercard, Visa, PayPal)
- **Shopify Order ID**

This data provides insights into sales volume, preferred payment options, and potential areas to streamline the payment process.

## 4. Customer Relations and Satisfaction

Building strong customer relationships is vital for long-term success. This section focuses on analyzing customer data, appeasements, returns, and recurring return issues to improve customer service and satisfaction.

### a. New Customers Acquired in June 2023

The customer relations team wants to track customers created in **June 2023** to tailor engagement strategies. Retrieve:

- **CUSTOMER_ID**
- **CUSTOMER_NAME**
- **EMAIL**
- **PHONE**
- **ENTRY_DATE**
- **CUSTOMER_STATUS**

This data helps in understanding customer demographics and enhancing communication efforts.

### b. Analysis of Appeasements Issued in July

Appeasements are often issued to address customer grievances. Fetch details to analyze their impact:

- **ORDER_ID**
- **APPEASEMENT_REASON**
- **APPEASEMENT_DATE**
- **APPEASEMENT_AMOUNT**
- **COMMENTS**

Understanding the reasons behind appeasements can lead to improvements in products and services.

### c. Distinguishing Returns from Appeasements

**Explanation:**

- **Returns** involve customers sending back products due to issues like defects or dissatisfaction, leading to refunds or exchanges. This affects inventory and revenue directly.
- **Appeasements** are compensations offered (e.g., discounts, credits) without requiring product returns, aimed at resolving customer complaints and maintaining goodwill.

Recognizing the differences helps in developing appropriate strategies for customer satisfaction and financial management.

### d. Detailed Return Information

To further analyze returns, retrieve:

- **RETURN_ID**
- **ENTRY_DATE**
- **RETURN_ADJUSTMENT_TYPE_ID**
- **AMOUNT**
- **COMMENTS**
- **ORDER_ID**
- **ORDER_DATE**
- **RETURN_DATE**
- **PRODUCT_STORE_ID**

This data assists in pinpointing specific issues and implementing corrective actions.

### e. Identifying Orders with Multiple Returns

Repeated returns on the same order indicate underlying issues. Fetch details to investigate:

- **ORDER_ID**
- **RETURN_ID**
- **RETURN_DATE**
- **RETURN_REASON**
- **RETURN_QUANTITY**

Understanding these patterns helps in addressing product defects or service problems, ultimately improving customer satisfaction.

## 5. Inventory Management and Variance Analysis

Effective inventory management minimizes losses due to discrepancies like lost or damaged goods. This section focuses on identifying and analyzing inventory variances.

### a. Investigating Lost and Damaged Inventory

The inventory team needs to examine variances caused by loss or damage. Fetch:

- **PRODUCT_ID**
- **FACILITY_ID**
- **VARIANCE_TYPE**
- **QUANTITY**
- **ENTRY_DATE**
- **REASON**

Analyzing this data helps in implementing measures to reduce inventory shrinkage and improve asset protection.