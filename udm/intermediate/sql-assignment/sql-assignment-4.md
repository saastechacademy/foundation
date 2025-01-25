## Questions:

### Question 1: Investigating BOPIS Order Import Delays
The client has reported delays in BOPIS (Buy Online, Pickup In Store) order import times from Shopify to OMS. To investigate:

1. Identify the time taken for an order to be created in Shopify and subsequently approved in OMS. Orders are only visible in the BOPIS App after approval.
2. During spike periods, identify other jobs that ran within the same 30-minute window to assess the server load.

Write an SQL query to:
- Calculate the time difference between order creation in Shopify and approval in OMS.
- List jobs executed within a 30-minute window during identified spikes.

### Question 2: Rejected Orders with Variance
When a store rejects an order, they can specify whether it is rejected with "variance" or "no variance." Rejections with variance indicate that the item(s) should be marked as out of stock.

Write an SQL query to:
- Identify all subsequent orders containing the rejected item(s) that need to be flagged for rejection.
- Return a list of affected orders.

Fields:
1. Rejected Order ID
2. Rejected Product ID
3. Affected Order IDs

### Question 3: Low Stock or Out of Stock Items Report
To avoid prolonged out-of-stock situations at stores, the client wants a report recommending inventory transfers. The report should:
- Identify items that are low in stock or out of stock.
- Recommend source facilities within 200 miles of the destination.
- Ensure the source facility’s inventory does not fall below the minimum stock threshold after fulfilling the transfer.

Write an SQL query to:
- Generate the report with recommendations for inventory transfers.

Fields:
1. Low/Out of Stock Item ID
2. Destination Facility
3. Recommended Source Facility
4. Transferable Quantity
5. Distance (in miles)

### Question 4: Orders Fulfilled in Two Different Months
The client wants to identify orders fulfilled across two different months. For example, in Order 123, Item 001 was fulfilled on November 29, while Item 002 was fulfilled on December 2.

Write an SQL query to:
- Pull a list of all such orders.

Fields:
1. Order ID
2. Fulfilled Item ID
3. Fulfillment Date

### Question 5: Return Impact on Marketing Package Components
A return was received and completed for a marketing package (kit product). Calculate how much Quantity on Hand (QoH) was increased for its components.

Write an SQL query to:
- Compute the QoH increase for each component of the returned marketing package.

Fields:
1. Return ID
2. Return Item Seq ID
3. Return Item Product ID
4. Marketing Package Component ID
5. Marketing Package Component QoH Increase

### Question 6: Net Transfers Between Facilities
At the end of every month, the retailer wants to see how much inventory was effectively moved between facilities. For example, if two facilities transferred a product back and forth with quantities 3 and 2 respectively, the net transfer is 1.

Write an SQL query to:
- Compute the net transfer quantity between all facilities for each product.

Fields:
1. Facility 1
2. Facility 2
3. Product Internal Name
4. Net Transferred Quantity

### Submission Requirements:
1. For each question, include the SQL query and a brief explanation of your approach.
2. Document any assumptions made while writing the SQL queries.
3. Submit your answers in a markdown file formatted for GitHub.

---

### Evaluation Criteria:
- Accuracy of SQL queries.
- Clarity and completeness of explanations.
- Proper formatting and adherence to the assignment requirements.