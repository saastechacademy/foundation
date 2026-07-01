# Step 3: Confirming the Bulk Operation

In this step, we get the final confirmation from Shopify. We use two parallel methods: **Polling** and **Webhooks**. They both help to reach the same result by calling the same processing service.

### Things involved
1.  **Poller Service**: `co.hotwax.shopify.system.ShopifySystemMessageServices.poll#BulkOperationResult`.
2.  **Processor Service**: `co.hotwax.shopify.system.ShopifySystemMessageServices.process#BulkOperationResult`. This handles the final result logic for both methods.
3.  **Webhook Type**: `BulkOperationsFinish`. This listens for the Shopify event when a bulk operation finishes.
4.  **Endpoint**: `/rest/s1/shopify/webhook/payload` (mapped to `co.hotwax.shopify.webhook.ShopifyWebhookServices.receive#WebhookPayload`).
5.  **Status Mapping**: 
    - `completed` -> **`SmsgConfirmed`**
    - `canceled` -> **`SmsgCancelled`**
    - `failed` or `expired` -> **`SmsgError`**

---

### Two Ways to Confirm

#### Method 1: Polling (Direct Check)
The scheduled job `poll_BulkOperationResult_ShopifyBulkQuery` runs this path.
*   **Search**: It looks for any message with status **`SmsgSent`** in the `ShopifyBulkQuery` parent group.
*   **Checking Shopify**: It takes the **`remoteMessageId`** and calls Shopify's API via `co.hotwax.shopify.graphQL.ShopifyBulkImportServices.get#BulkOperationResult`.
*   **Finalizing**: Once it sees the status is `COMPLETED`, it calls the **Processor Service**.

#### Method 2: Webhooks (Real-time Notification)
This method receives a direct "Finished" update from Shopify.
*   **Reception**: Shopify sends a payload to our system. This creates an incoming message of type `BulkOperationsFinish`.
*   **Finding the Request**: The consumer service `co.hotwax.shopify.system.ShopifySystemMessageServices.consume#BulkOperationsFinishWebhookPayload` reads the Shopify ID and finds our matching **Outgoing** sync message.
*   **Finalizing**: It then calls the same **Processor Service** (`process#BulkOperationResult`).

---

### The Final Process (Common Logic)
The `co.hotwax.shopify.system.ShopifySystemMessageServices.process#BulkOperationResult` service manages the final work:
1.  **Error Handling**: If Shopify returns an error, the service creates a record in the **`SystemMessageError`** table to log exactly why it failed.
2.  **Release the Sync Queue**: It updates the outgoing message status to **`SmsgConfirmed`**. This releases the "lock" so Step 2 can send the next sync job in the queue.
3.  **Create the Results Message**:
    - It creates a **New Incoming System Message** (using `org.moqui.impl.SystemMessageServices.receive#IncomingSystemMessage`).
    - It saves the Shopify **result file URL** in the `messageText`.
    - It populates the **`parentMessageId`** with our original **`systemMessageId`**. This is how we keep the vertical link for full traceability back to the original request.
    - This link allows us to know exactly which bulk query produced which result file.

---

### Key Technical Notes:
*   **Polling Limit**: The poller service only checks **one** message at a time (`limit="1"`). This keeps the process focused if many shops are running at once.
*   **Traceability**: Using **`parentMessageId`** is the standard way we link the incoming result message back to the outgoing request.

---

### Service Call Chain:

#### For Polling:
1.  **Scheduled Job** $\rightarrow$ `co.hotwax.shopify.system.ShopifySystemMessageServices.poll#BulkOperationResult`
2.  `poll#BulkOperationResult` $\rightarrow$ `co.hotwax.shopify.system.ShopifySystemMessageServices.process#BulkOperationResult`
3.  `process#BulkOperationResult` $\rightarrow$ `org.moqui.impl.SystemMessageServices.receive#IncomingSystemMessage`

#### For Webhook:
1.  Shopify sends `bulk_operations/finish` notification.
2.  **`co.hotwax.shopify.webhook.ShopifyWebhookServices.receive#WebhookPayload`** creates an incoming message.
3.  `co.hotwax.shopify.system.ShopifySystemMessageServices.consume#BulkOperationsFinishWebhookPayload` $\rightarrow$ `co.hotwax.shopify.system.ShopifySystemMessageServices.process#BulkOperationResult`
4.  `process#BulkOperationResult` handles final status and result link logic.
