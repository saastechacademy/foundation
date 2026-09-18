# Step 1: Queuing the Bulk Query Message

In this step, we just create a system message entry to track what data we need from Shopify. We don't call the Shopify API yet because we only want to plan the sync here.

### Things involved
1.  **Service**: `co.hotwax.shopify.system.ShopifySystemMessageServices.queue#BulkQuerySystemMessage`. This is the core service that prepares the request.
2.  **System Message Type**: `BulkProductAndVariantsByIdQuery`.
    
    Here is the data setup for this type:
    ```json
    {
        "systemMessageTypeId": "BulkProductAndVariantsByIdQuery",
        "parentTypeId": "ShopifyBulkQuery",
        "sendServiceName": "co.hotwax.shopify.system.ShopifySystemMessageServices.send#BulkQuerySystemMessage",
        "consumeServiceName": "co.hotwax.shopify.system.ShopifySystemMessageServices.consume#ProductVariantUpdates",
        "sendPath": "component://shopify-connector/template/graphQL/BulkProductAndVariantsByIdQuery.ftl",
        "_entity": "moqui.service.message.SystemMessageType"
    }
    ```

3.  **Data Parameters**:
    - `systemMessageTypeId`: `BulkProductAndVariantsByIdQuery`
    - `systemMessageRemoteId`: The ID for the Shopify shop.
    - `fromDateBuffer`: A value (usually in minutes) used to avoid missing data.

---

### How the flow works:

1.  **Job Execution**: A scheduled job runs and calls the service. It passes the `systemMessageTypeId` and `systemMessageRemoteId`.
2.  **Date Computation**: 
    - The service first looks for the last successful message (`statusId: SmsgConfirmed`) to get the `processedDate`. 
    - It uses this date as the starting point. It also subtracts the `fromDateBuffer` minutes and converts the final time to **UTC format** for Shopify.
    - If `filterQuery` or `thruDate` are provided in the job, the service handles them too.
3.  **Preparing Message Text**: All these parameters (dates, filters) are converted into a JSON string. This JSON is saved in the `messageText` field of the new system message.
4.  **Creating the Entry**: The service calls `org.moqui.impl.SystemMessageServices.queue#SystemMessage` to create the record:
    - **statusId**: `SmsgProduced`
    - **isOutgoing**: `Y`
    - **sendNow**: `false` (This is very important so the sync doesn't start immediately).

By keeping `sendNow` as `false`, we just put the "request" in the queue. The next job will pick it up only when no other bulk operation is running on Shopify.

---

### Service Call Chain:

1.  **Scheduled Job**: `queue_BulkQuerySystemMessage_BulkProductAndVariantsByIdQuery`
2.  **mantle-shopify-connector**: `co.hotwax.shopify.system.ShopifySystemMessageServices.queue#BulkQuerySystemMessage`
    -   **Action**: Computes dates and prepares JSON parameters.
3.  **moqui-framework**: `org.moqui.impl.SystemMessageServices.queue#SystemMessage`
    -   **Action**: Saves the message as `SmsgProduced` with `sendNow=false`.
