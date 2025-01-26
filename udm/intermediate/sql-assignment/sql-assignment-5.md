# SQL Assignment 5

### Question 1: Investigating BOPIS Order Import Delays
The client has reported delays in BOPIS (Buy Online, Pickup In Store) order import times from Shopify to OMS. To investigate:

1. Identify the time taken for an order to be created in Shopify and subsequently approved in OMS. Orders are only visible in the BOPIS App after approval.
2. During spike periods, identify other jobs that ran within the same 30-minute window to assess the server load.

**Write an SQL query to:**
- Calculate the time difference between order creation in Shopify and approval in OMS.
- List jobs executed within a 30-minute window during identified spikes.

### Question 2: Rejected Orders with Variance
When a store rejects an order, they can specify whether it is rejected with "variance" or "no variance." Rejections with variance indicate that the item(s) should be marked as out of stock.

**Write an SQL query to:**
- Identify all subsequent orders containing the rejected item(s) that need to be flagged for rejection.
- Return a list of affected orders.

**Fields:**
1. Rejected Order ID
2. Rejected Product ID
3. Affected Order IDs

### Question 3: Transfer Orders Recommendation Report
To avoid prolonged out-of-stock situations at stores, the client wants a report recommending inventory transfers. The report should:
- Identify items that are low in stock or out of stock.
- Recommend source facilities within 200 miles of the destination.
- Ensure the source facility’s inventory does not fall below the minimum stock threshold after fulfilling the transfer.

**Write an SQL query to:**
- Generate the report with recommendations for inventory transfers.

**Fields:**
1. Low/Out of Stock Item ID
2. Destination Facility
3. Recommended Source Facility
4. Transferable Quantity
5. Distance (in miles)

### Question 4: Orders Fulfilled in Two Different Months
The client wants to identify orders fulfilled across two different months. For example, in Order 123, Item 001 was fulfilled on November 29, while Item 002 was fulfilled on December 2.

**Write an SQL query to:**
- Pull a list of all such orders.

Fields:
1. Order ID
2. Fulfilled Item ID
3. Fulfillment Date

### Question 5: Marketing Package Components Restock
A return was received and completed for a marketing package (kit product). Calculate how much Quantity on Hand (QoH) was increased for its components.

**Write an SQL query to:**
- Compute the QoH increase for each component of the returned marketing package.

**Fields:**
1. Return ID
2. Return Item Seq ID
3. Return Item Product ID
4. Marketing Package Component ID
5. Marketing Package Component QoH Increase

### Question 6: Net Transfers Between Facilities
At the end of every month, the retailer wants to see how much inventory was effectively moved between facilities. For example, if two facilities transferred a product back and forth with quantities 3 and 2 respectively, the net transfer is 1.

**Write an SQL query to:**
- Compute the net transfer quantity between all facilities for each product.

**Fields:**
1. Facility 1
2. Facility 2
3. Product Internal Name
4. Net Transferred Quantity

## Question 7: Total POS Sales Quantity vs POS Variance by Product

**Scenario:**  
A retailer needs visibility into how many items are sold through their POS (Point of Sale) system versus the recorded on-hand or counted quantities in the store. A “POS variance” occurs when the theoretical stock (based on POS sales) does not match the actual physical count or system records (e.g., cycle counts or manual corrections). The retailer wants to see, by product, the total quantity sold through POS within a given period and the associated variance for that same period.

**Write an SQL query to:**
1. Summarize total POS sales quantity for each product within the reporting period.  
2. Compare it to the variance (differences found in actual vs. expected stock) recorded in the system.  
3. Return a list of products with both their total POS sales and their total POS variance for the period.

**Fields:**  
1. Product ID
2. Product Name
3. Total POS Sales Quantity
4. Total POS Variance


## Question 8: Receiving Discrepancy — Outbound Transfer Order vs Corresponding Inbound Transfer Order

**Scenario:**  
A retailer transfers products between facilities (e.g., from a warehouse to a store or from one store to another). Each transfer (TO) has two parts:  
- **Outbound TO:** The “sending” facility documents how many units are shipped out.  
- **Inbound TO:** The “receiving” facility documents how many units are received.  

Sometimes, discrepancies arise where the quantity received is different from the quantity shipped. The retailer wants to identify and quantify these discrepancies for auditing and inventory reconciliation.

**Write an SQL query to:**
1. Compare the shipped quantity (outbound TO) with the received quantity (inbound TO) for each product.  
2. Return a list of all discrepancies between the outbound and inbound transfers.  
3. Include relevant facility and order details.

**Fields:**  
1. In Transfer Order ID
2. Out Transfer Order ID
3. Outbound Facility
4. Inbound Facility
5. Product ID  
6. Shipped Quantity
7. Received Quantity 
8. Discrepancy (Received Qty - Shipped Qty, or vice versa)

**Bonus:**
Reconcile the quantity in TO shipments and reciepts with inventory logs.