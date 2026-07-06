# Shopify Product Sync Design Outline

This document describes the design for the product synchronization between Shopify and the OMS. The sync process is divided into clear stages to ensure reliability and handle API constraints.

### The Stages of Sync:

1.  **Queuing the Request**: We create a system message to fetch data for products that were recently updated. This message has the filters needed for the Shopify GraphQL query.
2.  **Sending to Shopify**: We send the message to Shopify to start a "Bulk Operation." We only do this if Shopify is not already busy with another bulk operation.
3.  **Checking Completion**: We keep checking (polling) until the bulk operation is finished at Shopify. Once it's done, we get the result file link.
4.  **Data Preparation**: We download the JSONL file. Then we convert this data into a nested JSON list and send it to the MDM (OMS) layer.
5.  **Diff Computation**: The system looks at the new incoming data and compares it with the "Last Processed Data." This tells us exactly what has changed (Price, Title, Tags, etc.).
6.  **Updating Database**: We apply only the changes (the "diffs") to the database. This keeps the update very fast and clean.
7.  **Saving History**: Finally, we save the new data as a "history" snapshot. This will be used as the base for comparison the next time the sync runs.

---

This outline shows the complete workflow of a product sync, from the moment a change is detected in Shopify to the final update in our database.
