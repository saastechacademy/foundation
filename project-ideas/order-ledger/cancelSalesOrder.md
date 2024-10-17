# OMS/Shopify Canceled Order(s) and Items Sync Design

## Shopify Connector
Shopify connector will generate a periodic json(l) feed of canceled Shopify orders and items. An order representation in the feed would generally contain following attributes,
1. Order - id, name, cancelledAt, cancelReason, transactions
2. Order Item - id, sku, quantity, nonFulfillableQuantity, __parentId

In Shopify admin, order/items could be canceled in following two ways and specific attributes informs about a canceled order or canceled order item quantity,
1. If an order is canceled from Shopify admin UI via “Order > More Actions > Cancel Order”, then the whole Shopify order and its items are marked as canceled. In such a case, the cancelledAt attribute on the order in the json(l) feed gives the date/time of order cancellation and can be used to identify if the whole order has been canceled.
2. The other way is to cancel individual order items in Shopify admin UI “Order > Restock/Refund” option. In such a case individual order item cancellation and canceled quantity could be identified with nonFulfillableQuantity attribute on order line item.

Additionally, if the payment was captured at Shopify before cancellation the refund transaction also needs to be logged in OMS against the canceled order.

Below is a sample schema and feed example.
```
{"id":"gid:\/\/shopify\/Order\/6280604516516","name":"HCDEV#2611","displayFulfillmentStatus":"UNFULFILLED","cancelledAt":null,"cancelReason":null,"cancellation":null,"transactions":[{"id":"gid:\/\/shopify\/OrderTransaction\/7400324399268","parentTransaction":null,"kind":"AUTHORIZATION","status":"SUCCESS","processedAt":"2024-08-13T11:12:01Z","amountSet":{"presentmentMoney":{"amount":"73.0","currencyCode":"USD"}},"gateway":"bogus","paymentDetails":{"company":"Bogus"}}]}
{"id":"gid:\/\/shopify\/LineItem\/16015145861284","sku":"WH09-XS-Green","quantity":1,"currentQuantity":0,"unfulfilledQuantity":0,"nonFulfillableQuantity":1,"__parentId":"gid:\/\/shopify\/Order\/6280604516516"}
{"id":"gid:\/\/shopify\/LineItem\/16015145894052","sku":"WT08-XS-Black","quantity":1,"currentQuantity":0,"unfulfilledQuantity":0,"nonFulfillableQuantity":1,"__parentId":"gid:\/\/shopify\/Order\/6280604516516"}
{"id":"gid:\/\/shopify\/Order\/6280605434020","name":"HCDEV#2612","displayFulfillmentStatus":"UNFULFILLED","cancelledAt":null,"cancelReason":null,"cancellation":null,"transactions":[{"id":"gid:\/\/shopify\/OrderTransaction\/7400325382308","parentTransaction":null,"kind":"AUTHORIZATION","status":"SUCCESS","processedAt":"2024-08-13T11:12:54Z","amountSet":{"presentmentMoney":{"amount":"101.5","currencyCode":"USD"}},"gateway":"bogus","paymentDetails":{"company":"Bogus"}},{"id":"gid:\/\/shopify\/OrderTransaction\/7400328364196","parentTransaction":{"id":"gid:\/\/shopify\/OrderTransaction\/7400325382308"},"kind":"CAPTURE","status":"SUCCESS","processedAt":"2024-08-13T11:16:01Z","amountSet":{"presentmentMoney":{"amount":"101.5","currencyCode":"USD"}},"gateway":"bogus","paymentDetails":{"company":"Bogus"}},{"id":"gid:\/\/shopify\/OrderTransaction\/7400328659108","parentTransaction":{"id":"gid:\/\/shopify\/OrderTransaction\/7400328364196"},"kind":"REFUND","status":"SUCCESS","processedAt":"2024-08-13T11:16:14Z","amountSet":{"presentmentMoney":{"amount":"101.5","currencyCode":"USD"}},"gateway":"bogus","paymentDetails":{"company":"Bogus"}}]}
{"id":"gid:\/\/shopify\/LineItem\/16015148187812","sku":"MSH02-32-Black","quantity":1,"currentQuantity":0,"unfulfilledQuantity":0,"nonFulfillableQuantity":1,"__parentId":"gid:\/\/shopify\/Order\/6280605434020"}
{"id":"gid:\/\/shopify\/LineItem\/16015148220580","sku":"MH09-XS-Blue","quantity":1,"currentQuantity":0,"unfulfilledQuantity":0,"nonFulfillableQuantity":1,"__parentId":"gid:\/\/shopify\/Order\/6280605434020"}
{"id":"gid:\/\/shopify\/Order\/6280606187684","name":"HCDEV#2613","displayFulfillmentStatus":"UNFULFILLED","cancelledAt":"2024-08-13T11:16:47Z","cancelReason":"CUSTOMER","cancellation":{"staffNote":null},"transactions":[{"id":"gid:\/\/shopify\/OrderTransaction\/7400326463652","parentTransaction":null,"kind":"AUTHORIZATION","status":"SUCCESS","processedAt":"2024-08-13T11:13:53Z","amountSet":{"presentmentMoney":{"amount":"84.0","currencyCode":"USD"}},"gateway":"bogus","paymentDetails":{"company":"Bogus"}},{"id":"gid:\/\/shopify\/OrderTransaction\/7400329052324","parentTransaction":{"id":"gid:\/\/shopify\/OrderTransaction\/7400326463652"},"kind":"VOID","status":"SUCCESS","processedAt":"2024-08-13T11:16:46Z","amountSet":{"presentmentMoney":{"amount":"0.0","currencyCode":"USD"}},"gateway":"bogus","paymentDetails":{"company":"Bogus"}}]}
{"id":"gid:\/\/shopify\/LineItem\/16015150350500","sku":"WSH04-28-Black","quantity":1,"currentQuantity":0,"unfulfilledQuantity":0,"nonFulfillableQuantity":1,"__parentId":"gid:\/\/shopify\/Order\/6280606187684"}
{"id":"gid:\/\/shopify\/LineItem\/16015150383268","sku":"WH09-XS-Green","quantity":1,"currentQuantity":0,"unfulfilledQuantity":0,"nonFulfillableQuantity":1,"__parentId":"gid:\/\/shopify\/Order\/6280606187684"}
```

## Feed conversion for OMS consumption
The json(l) feed would have all the orders that have been updated for any reason since last sync. For OMS consumption It is important to identify only those orders and/or items that have been canceled. Need to convert json(l) feed to a json feed with only relevant orders, items and related attributes

## OMS API
Order items in OMS are exploded, so for one Shopify order line item number of order items in OMS are equal to Shopify order line item quantity. Cancelation flow needs to account for this scenario. Also, if the payment was captured in Shopify before order cancelation then the relevant refund transaction from Shopify must be logged against the respective order in OMS.
1. Write a wrapper service that identifies oms order items to be canceled based on the diff between OMS canceled quantity and Shopify canceled quantity and subsequently calls cancelOrderItem OMS API to cancel relevant order items. Need to make sure that cancelOrderItem API also marks the order as canceled if all order items in that order are canceled.
2. Additionally, if cancelOrder API exists in OMS then it could be utilized to cancel the complete order against a Shopify order with non null cancelledAt date.
3. Look for the available API to log the OrderPaymentPreference of type refund if the respective refund transaction is available in order json and not already logged in any other data sync.

**Note:** At some point we should plan implementing cancelOrder and cancelOrderItem API in Moqui OMS layer.

## Detailed Design Considerations
### AS-IS Implementation
Current implementation in HCOMS is cancelShopifyOrderItem service which processes shopify refunds of kind ‘cancel/no_restock’ to cancel order items in HC. This part won’t be relevant in the new implementation. But we need to consider actions specific to identifying and canceling order items in OMS. The following actions needs to be considered,
1. Since the order items are exploded by default in OMS, it identifies all the OMS order items against a Shopify order item. Also does the necessary calculation and validations for `cancelQuantity`.
2. In the next step, it iterates over `cancelQuantity` and calls `ShopifyOrderServices.cancelShopifyOrderItem()` method. This method performs the following actions:
   * Fetches open OMS order items for the given Shopify order items.
   * Gets the first order item giving priority to non-brokered order items.
   * Calls OOTB OFBiz `cancelOrderItem` service for the identified item.
   * Creates a negative sales tax adjustment for the order item.
   * Creates a communication event for order item cancellation.
3. In the last step, it calls `getRefundTransactionsAndCreateOrderPayment` service.
   * It fetches refund transactions from Shopify for the order and for each transaction calls `getTransactionAndCreateOrderPaymentPreference` service, which does a bunch of validation and mapping and updates or creates `OrderPaymentPreference`.

### TO-BE Implementation
The new cancel order API and services would be implemented in the Moqui framework. Following API and services need to be implemented,
1. cancelShopifyOrderItem: This is the main API wrapper service that implements the logic described in the AS-IS implementation above.
2. Desired behavior from the following OOTB OFBiz services needs to be replicated in Moqui:
   * cancelOrderItem
     - createOrderItemChange
     - createOrderNote
     - cancelOrderItemInvResQty
       * cancelOrderItemShipGrpInvRes
         - createInventoryItemDetail
     - changeOrderItemStatus
       - checkOrderItemStatus (seca) (OOTB)
         * changeOrderStatus
           - ~~releaseOrderPayments~~ (seca) (Custom): OMS isn’t responsible for payment processing, so this service shouldn’t be needed.
           - ~~processRefundReturnForReplacement~~ (seca) (OOTB): This service too is irrelevant; OMS isn’t an RMA and doesn’t process refunds and replacements.
           - ~~onPOCancelAdjustAtpOnOtherPo~~ (seca) (custom for PO)
           - onChangeOrderStatus
           - ~~cancelOrderOnMarketplace~~ (Custom)
           - createOrderIndex
           - ~~checkEmailAddressAndSendOrderCompleteNotification~~
           - sendOrderCancelNotification (Later)
           - sendOrderCompleteNotification (Later)
             * createOrderNotificationLog
           - sendOrderSmsNotification (Later)
       - checkAndRejectOrderItem (seca) (Custom)
       - rejectTransferOrderItem (seca) (Custom)
       - ~~adjustAtpOnOtherPO~~ (seca) (Custom for PO)
       - checkOrderItemAndCapturePayament (Custom): Called on item completion.
       - ~~onChangeOrderItemStatus~~(seca) This is a publisher service, so irrelevant as of now.
       - createOrderIndex
       - ~~checkEmailAddressAndSendOrderCancelledNotification~~
       - ~~completeKitProduct~~ (On item completion)
       - ~~cancelKitComponents~~ (On item cancellation)
       - checkValidASNAndUpdateAtp (seca)
     - resetGrandTotal (seca)
     - sendOrderChangeNotification (seca) (Later)

#### OMS/Shopify Middleware (Accelerator)
In the process of implementing this API we will start designing and implementing a middleware component to map and transform Shopify order data into OMS order schema. A few of the desired capabilities of this component in context of this API would be as follows,
1. Map Shopify `orderId` to OMS `orderId`: Currently, the logic is driven through the `OrderIdentification` entity. We may want to use the integration entity `ShopifyShopOrder`.
2. Get OMS exploded order items against Shopify `orderLineItemId`.
3. Calculate the balance `cancelQuantity` between the Shopify order line item `cancelQuantity` and OMS exploded order items aggregated `cancelQuantity`.
4. With respect to the balance `cancelQuantity`, get eligible exploded order items in OMS against Shopify `orderLineItemId` for cancellation. These items should be included in the Cancel Order JSON.
5. Map and transform Shopify `OrderTransaction` to create `OrderPaymentPreference` in OMS:
   * Map `currencyUomId`.
   * Map Shopify transaction `statusId` to OMS `OrderPaymentPreference` `statusId`.
   * Map Shopify transaction `gateway` to OMS `paymentMethodTypeId`.
   * If the Shopify order currency is different from the OMS order currency, use the Shopify transaction `exchange_rate` if available. Otherwise, derive it from the `UOMConversion` entity in OMS. If the exchange rate couldn’t be derived, the transaction amount is set to null.
   * Map the remaining relevant Shopify transaction fields to generate OMS `OrderPaymentPreference` JSON to be included in the Cancel Order JSON.



