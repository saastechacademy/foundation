# Service naming best practices
## Choice of verb.

**1. consume:**

- **Role:**  Handles the initial processing of incoming messages (data) from external sources or triggers (e.g., Shopify webhooks, local feed files).
- **Functionality:**
    - Extracts data from the message payload.
    - Performs validation and error handling.
    - May transform the data into a format suitable for further processing.
    - Often triggers the next step in the workflow (e.g., sending data to Shopify, queuing further messages).
- **Examples:**
    - `consume#FulfillmentFeed`: Processes incoming fulfillment data from an OMS.
    - `consume#GraphQLBulkImportFeed`: Processes incoming bulk import feeds (product tags, variants).
    - `consume#BulkOperationsFinishWebhookPayload`:  Processes incoming Shopify webhook payloads.

**2. send:**

- **Role:**  Transmits data or requests to external systems or queues (e.g., Shopify, AWS SQS).
- **Functionality:**
    - Prepares the data or request payload (e.g., using templates).
    - Handles authentication and communication with the external system.
    - May update the message status to indicate successful sending.
- **Examples:**
    - `send#ShopifyFulfillmentSystemMessage`:  Sends fulfillment data to Shopify.
    - `send#BulkMutationSystemMessage`:  Sends bulk mutation requests to Shopify.
    - `send#OrderUpdatedAtToQueue`: Sends order update timestamps to a queue.

**3. process:**

- **Role:**  Performs intermediate processing or decision-making on data within the workflow.
- **Functionality:**
    - Analyzes or transforms data received from previous steps.
    - Makes decisions based on the data (e.g., whether to retry a failed operation, which subsequent service to call).
- **Examples:**
    - `process#BulkOperationResult`: Fetches and processes bulk operation results from Shopify, deciding whether to mark the operation as successful or failed.

**4. poll:**

- **Role:**  Periodically checks an external system or queue for new data or events.
- **Functionality:**
    - Initiates requests to the external system (e.g., Shopify) or polls a queue (e.g., SFTP).
    - Triggers further processing based on the received data.
- **Examples:**
    - `poll#BulkOperationResult`: Checks the status of a running bulk operation on Shopify.
    - `poll_SystemMessageSftp_OMSFulfillmentFeed`: Polls an SFTP server for new fulfillment feed files.

**5. queue:**

- **Role:**  Places messages (data or requests) into a queue for later processing.
- **Functionality:**
    - Creates `SystemMessage` records and sets their status to "Produced" (`SmsgProduced`).
    - The queued messages are then picked up and processed by other services (e.g., send services) when appropriate.
- **Examples:**
    - `queue#SystemMessage`:  Queues a `SystemMessage` for sending (used in multiple places).
    - `queue#BulkQuerySystemMessage`: Queues a bulk query request for processing.

**6. generate:**

- **Role:** Creates data files or reports based on existing data or query results.
- **Functionality:**
    - Retrieves data from Moqui entities or external sources.
    - Formats the data into a specific file format (e.g., JSON, CSV).
    - Stores the file locally or sends it to an external system.
- **Examples:**
    - `generate#OrderMetafieldsFeed`: Generates a JSON feed of order metafield data.
    - `generate#ShopifyFulfillmentAckFeed`:  Generates a Shopify fulfillment acknowledgment feed.

**Key Takeaways**

- **Clear Separation of Concerns:** The use of these verbs helps to clearly define the different stages and responsibilities within the integration process.
- **Modularity and Reusability:** Each service typically focuses on a specific task, making them easier to maintain and reuse in other workflows.
- **Orchestration:**  The combination of `consume`, `send`, `process`, `poll`, `queue`, and `generate` services allows you to create complex, automated workflows that handle various aspects of your Shopify integration.
