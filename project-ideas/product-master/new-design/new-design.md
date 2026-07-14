Ab tumhe pata hai ki pehle kya design use hua tha, then fir usme kuchh problems the jiski wajah se iss design ko rethink kiya hai. logically kuchh bhi changes nahi hai. but pehle jo execution that usko re architext kiya hai

Here I am adding the new design for the product sync in the stages:

Steps:
1. Queuing a system message for creating a bulk operation to fetch the data of recently updated products, contains a filters that helps in exapanding a graphql query to create a bulk operation on shopify
2. Sent the queued system message to shopify to run a mutation to create a bulk operation and wo bhi tab jab ki shopify par already koi bulk operation run nahi ho raha hai 
3. Confirming the bulk operation is completed and then fetching the data from the bulk operation.
4. Convert the JSONL dataframe into nested json list and upload in to the MDM.
MDM processes a single record of product data json list, 
5. Diff computation by looking into the last processed data against the incoming data
6. Made the changes into the database according to computed difference
7. Save the product update history based on the new coming data for future


Lets discuss the technical details of the above steps in details
### Step 1: Creating a bulk operation on shopify for the recent updates coming in the various products which needs to resync.

Iss step me pehle do chije involved hai 
1. ek service job jo ki generic service hai co.hotwax.shopify.system.ShopifySystemMessageServices.queue#BulkQuerySystemMessage
2. ek system message type BulkProductAndVariantsByIdQuery
{
    "sendServiceName": "co.hotwax.shopify.system.ShopifySystemMessageServices.send#BulkQuerySystemMessage",
    "systemMessageTypeId": "BulkProductAndVariantsByIdQuery",
    "parentTypeId": "ShopifyBulkQuery",
    "consumeServiceName": "co.hotwax.shopify.system.ShopifySystemMessageServices.consume#ProductVariantUpdates",
    "_entity": "moqui.service.message.SystemMessageType",
    "sendPath": "component://shopify-connector/template/graphQL/BulkProductAndVariantsByIdQuery.ftl",
}

Flow:
1. Job (queue_BulkQuerySystemMessage_BulkProductAndVariantsByIdQuery) is scheduled jo run hokar system message type id and system message remote id service ko pass kar deta hai
2. Services lookup for the older message by system message type id (BulkProductAndVariantsByIdQuery) and system message remote id for the last sync date (like SHOP_CONFIG)
3. fir filterQuery or computed from date, thruDate values ke sath compare karke ek system message queue karta hai, then service ka kaam complete ho jata hai (sendNow:false, creates SmsgProduced outgoing SystemMessage)
4. Yahi se system message directly sent nahi karte hai because there is limitation in the shopify that only executes on bulk operation be shopify shop, isliye isko bhejne ke liye some mechanism ki jarurat padti hai


### Step 2: Sent the queued system message to shopify to run a mutation to create a bulk operation and wo bhi tab jab ki shopify par already koi bulk operation run nahi ho raha hai 
Sabse pehle baat karte hai ki shopify ka contraint hai ki wo only allows to run onyl one bulk operation at a time per shop

Isko manage karne ke liye saara logic co.hotwax.shopify.system.ShopifySystemMessageServices.send#ProducedBulkOperationSystemMessage me hai

ek or baat hai bulk operation karne ke liye jo system message banta hai uski status life cycle iss tarah hai 

SmsgProduced, SmsgSending, SmsgSent, SmsgConfirmed

SmsgProduced - jab system message queue hota hai
SmsgSending - jab system message sent ho raha hota hai
SmsgSent - Jab uss system message ke corresponding jo bulk operation tha wo shopify par create ho chuka hai, means wo create ho kar run ho rha hai
SmsgConfirmed - jab hame confirmation mil jata hai ki bulk operation complete ho chuka hai, means ki jo bulk operation chal raha tha wo complete ho gaya hai or abhi kuchh nahi chal raha hai

So, jo service hai wo pehle check karegi ki koi SmsgSent hai ya nahi, agar hai to wo wahi par ruk jayegi, agar nahi hai to wo SmsgProduced ko sent karne ke liye corresponding send service execute karega

Also there is service job (send_ProducedBulkOperationSystemMessage_ShopifyBulkQuery) which executes this service and passed the parent system message type id (ShopifyBulkQuery)

Flow:
1. Job (send_ProducedBulkOperationSystemMessage_ShopifyBulkQuery) is sceduled and it will call the send#ProducedBulkOperationSystemMessage service and pass the parent system message type id (ShopifyBulkQuery)
2. This service checks for any SmsgSent message for the given parent system message type id, if found then it will not do anything and return, else it will proceed with sending this message by calling configured sendServiceName (co.hotwax.shopify.system.ShopifySystemMessageServices.send#BulkQuerySystemMessage)
3. send karne ki service, message text parse karti hai, expand the graphql query using the ftl template (sendPath) and then calls a shopify graphql api

### Step 3: Confirming the bulk operation is completed and then fetching the data from the bulk operation.

Confirmation ke do tarike hai
1. Ki hum ek or service job run kare jo ki SmsgSent status me system message hai uske liye polling kare uske corresponding bulk operation ke status ko shopify par check kare
2. Ki hum bulk_operations/finish topic ko subscribe kar le jo hame realtime me confirmation de dega

Hum confirmation ke liye dono tariko ko sath me use kar sakte hai, if webhook notification miss ho jaye to polling job ke through confirmation mil jayega

1. Polling job (poll_BulkOperationResult_ShopifyBulkQuery)
- Runs service co.hotwax.shopify.system.ShopifySystemMessageServices.poll#BulkOperationResult passing ShopifyBulkQuery as parentSystemMessageTypeId
- Select first SmsgSent system message for which it checks the status by passing id to the service co.hotwax.shopify.system.ShopifySystemMessageServices.process#BulkOperationResult
- then on completion it receives and incoming system message with same system message type and remote id, and saves the result file url in the new message
- update the status of the outgoing message to SmsgConfirmed

2. Webhook notification
- Received on endpoint /rest/s1/shopify/webhook/payload at service co.hotwax.shopify.webhook.ShopifyWebhookServices.receive#WebhookPayload
- This recieves and system message of type BulkOperationsFinish, in the consume process it searches for the system message by received bulk operation id
- Called the service co.hotwax.shopify.system.ShopifySystemMessageServices.process#BulkOperationResult passed system message id, and the flow continues

### Stpe 4: Convert the JSONL dataframe into nested json list and upload it to the MDM.

Is step me jo core service involved hai wo hai **co.hotwax.shopify.system.ShopifySystemMessageServices.consume#ProductVariantUpdates**. 

Triggering Mechanism:
Jaise hi Step 3 complete hota hai, framework `receive#IncomingSystemMessage` call karta hai. Kyuki humne `BulkProductAndVariantsByIdQuery` message type par `consumeServiceName` me ye service configure ki hai, isliye framework directly isko trigger kar deta hai.

Logic & Flow:
1. **Download URL**: Ye service `systemMessage.messageText` se Shopify ka download URL uthati hai.
2. **Streaming Parse**: JSONL file bahut badi ho sakti hai, isliye isko line-by-line stream kiya jata hai. 
3. **Nesting Logic**: 
   - Agar line me `__parentId` nahi hai, to wo **Root Product** hai.
   - Agar line me `__parentId` hai, to wo child hai (Variant ya Metafield). 
   - Service in children ko uske correct parent product ke andar nest kar deti hai (standard JSON hierarchy banane ke liye).
4. **Temporary Storage**: Ye nested JSON ko temporary file (`runtime/tmp/`) me save karta hai.
5. **MDM Handover**: Fir ye service **co.hotwax.util.UtilityServices.upload#DataManagerFile** ko call karti hai with `configId: SYNC_SHOPIFY_PRODUCT`.
6. **Traceability**: Upload karte waqt `systemMessageId` ko parameters me pass kiya jata hai. Isse hume pata rehta hai ki MDM me jo data gaya hai wo kis sync request se aaya tha.

Data Manager Configuration:
```json
{
    "importServiceName": "co.hotwax.sob.product.ProductServices.sync#ShopifyProduct",
    "_entity": "co.hotwax.datamanager.DataManagerConfig",
    "configId": "SYNC_SHOPIFY_PRODUCT",
    "executionModeId": "DMC_QUEUE"
}
```

### Step 5: Diff computation by looking into the last processed data against the incoming data.

Upload hone ke baad MDM logic execute hota hai. Iska configuration **DataManagerConfig** (`configId: SYNC_SHOPIFY_PRODUCT`) me hai, jo trigger karta hai service: **co.hotwax.sob.product.ProductServices.sync#ShopifyProduct**.

Flow & Logic:
1. **Queue Execution**: MDM configuration `DMC_QUEUE` mode me hai, isliye ye process background me queue ho jata hai.
2. **History Lookup**: Service pehle **co.hotwax.product.ProductUpdateHistory** table se us product ka purana record (last processed state) fetch karti hai.
3. **Change Detection (Hashing)**:
   - Ye incoming data (JSON) aur purane data ko **SHA-256 Hashing** ke through compare karta hai.
   - Ye in gaps ko check karta hai: Core Details (Title, Vendor, Handle), Tags, Metafields, aur Features (Options).
4. **differenceMap**: Agar koi difference milta hai, to service ek **differenceMap** (JSON) create karti hai jisme sirf changed values (added/removed) hoti hai.
5. **History Update**: Ye naya data aur `differenceMap` ko `ProductUpdateHistory` me update kar deta hai for future reference.

### Step 6: Made the changes into the database according to computed difference.

Is step me `differenceMap` ka use karke actual database entities ko update kiya jata hai.

Logic:
1. **Worker Logic**: Script ke andar `consumeProductUpdateHistoryWorker` logic chalta hai jo `differenceMap` ko read karta hai.
2. **Selective Updates**: Agar `differenceMap` me koi changes hai (e.g. Tags added), tabhi wo corresponding service ko call karta hai.
3. **Entity Operations**:
   - **Product**: `store#org.apache.ofbiz.product.product.Product` call karke core details update hote hai.
   - **Keywords**: `create#ProductKeyword` ya `delete#ProductKeyword` tags ke liye use hota hai.
   - **Features**: Selectable features (options) ko manage karne ke liye calls hote hai.
   - **Assocs**: Product variants aur parent products ke link (ProductAssoc) ensure kiye jate hai.

Is tarah se hum sirf wahi data update karte hai jo Shopify me change hua tha, unnecessary database hits avoid ho jate hai.

### Step 7: Save the product update history based on the new coming data for future.

Jab ingestion complete ho jata hai, tab final kaam hota hai baseline ko update karna.

Logic:
1. **Closing the Loop**: Service `store#co.hotwax.product.ProductUpdateHistory` call karti hai.
2. **Persistence**: Naye hashes, naya JSON data, aur logic me use hua `differenceMap` history table me save ho jate hai.
3. **Traceability**: Isme `systemMessageId` bhi save hota hai taki future me hum kisi bhi change ko audit kar sake.

Ab agli baar jab sync chalega, to Step 5 isi naye data ko baseline mankar diff compute karega.
