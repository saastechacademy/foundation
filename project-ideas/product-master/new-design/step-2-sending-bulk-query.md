# Step 2: Sending the Bulk Query Message

This step handles the actual Shopify API call. We built it this way specifically to deal with **Shopify’s limit**: only one bulk operation can run at a time per shop.

### Things involved
1.  **Scheduler**: `co.hotwax.shopify.system.ShopifySystemMessageServices.send#ProducedBulkOperationSystemMessage`. This is a scheduled service that looks for queued work.
2.  **Parent Group**: `ShopifyBulkQuery`. This is the `parentTypeId` used to group all bulk requests (like Product, Inventory, and Order queries). 
3.  **The Sender**: `co.hotwax.shopify.system.ShopifySystemMessageServices.send#BulkQuerySystemMessage`. This is the service that actually builds the Shopify request.

---

### Detailed Technical Flow:

#### 1. The Locking Check
When the scheduled job runs, it passes a **`parentSystemMessageTypeId`** (ShopifyBulkQuery). 
The service then does an `entity-find` on the `SystemMessage` table. 
*   **Search**: It looks for any message where `statusId == 'SmsgSent'` and the `parentTypeId` matches.
*   **The Constraint**: If it finds even one record, it logs a message: *"Aborting, ShopifyBulkQuery Operation already in progress."* and stops. This prevents sending another request while Shopify is still busy.

#### 2. Selecting the next Message
If no active (`SmsgSent`) message is found:
*   **Filtering**: It looks for messages in `SmsgProduced` status with the same `parentTypeId`.
*   **Ordering**: It picks the message with the oldest **`initDate`** (First-In, First-Out).
*   **Retry Logic**: It checks the **`failCount`**. If the count is less than the **`retryLimit`** (default is 3), it moves to the send step. If it has failed too many times, it sets the status to `SmsgError`.

#### 3. Calling Shopify API
The manager calls the **Sender service**. This service does the following:
*   **Credentials**: It uses the `systemMessageRemoteId` from the message to get the correct Shopify API keys.
*   **Building the Query**: It reads the JSON dates and filters from the `messageText`. It then uses the **`sendPath`** (which points to an `.ftl` file) to build the complete GraphQL mutation.
*   **HTTP POST**: It calls `co.hotwax.shopify.common.ShopifyHelperServices.send#ShopifyGraphqlRequest` to send a POST request to Shopify.

#### 4. Storing the Shopify ID
Once Shopify confirms the mutation started:
- The system gets the `id` of the bulk operation from Shopify's response.
- It saves this ID in the **`remoteMessageId`** field of our system message.
- It updates the status to **`SmsgSent`**.

Now the system is "Locked." Any other bulk query job that runs now will see this `SmsgSent` message and wait until it is finished.

---

### Service Call Chain:

1.  **Scheduled Job**: `send_ProducedBulkOperationSystemMessage_ShopifyBulkQuery`
2.  **mantle-shopify-connector**: `co.hotwax.shopify.system.ShopifySystemMessageServices.send#ProducedBulkOperationSystemMessage`
    -   **Action**: Checks for active `SmsgSent` messages to handle the "Busy" lock.
3.  **moqui-framework**: `org.moqui.impl.SystemMessageServices.send#ProducedSystemMessage`
    -   **Action**: Standard framework service to trigger the sending process.
4.  **mantle-shopify-connector**: `co.hotwax.shopify.system.ShopifySystemMessageServices.send#BulkQuerySystemMessage`
    -   **Action**: Expands the FTL template and prepares the GraphQL mutation.
5.  **mantle-shopify-connector**: `co.hotwax.shopify.common.ShopifyHelperServices.send#ShopifyGraphqlRequest`
    -   **Action**: Sends the request to Shopify and updates status to `SmsgSent`.
