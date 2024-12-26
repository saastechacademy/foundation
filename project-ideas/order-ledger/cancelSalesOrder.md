# OMS/Shopify Canceled Order(s) and Items Sync Design

## Shopify Connector
Shopify connector will generate a periodic json feed of updated Shopify orders and items. Follwoing attributes in the feed would be relevant for order item cancellation,
1. orders - id, name
   - id
   - name
   - updatedAt
   - lineItems
     - id
     - sku
     - quantity
     - nonFulfillableQuantity
   - transactions
     - id
     - parentTransaction
     - kind
     - status
     - processedAt
     - amountSet
       - presentmentMoney
       - shopMoney
     - gateway
     - paymentDetails
       - company
     - receiptJson

In Shopify admin, order/items could be canceled in following two ways and specific attributes informs about a canceled order or canceled order item quantity,
1. If an order is canceled from Shopify admin UI via “Order > More Actions > Cancel Order”, then the whole Shopify order and its items are marked as canceled. In such a case, the cancelledAt attribute on the order in the feed gives the date/time of order cancellation and can be used to identify if the whole order has been canceled.
2. The other way is to cancel individual order items in Shopify admin UI “Order > Restock/Refund” option. In such a case individual order item cancellation and canceled quantity could be identified with nonFulfillableQuantity attribute on order line item.

Additionally, if the payment was captured at Shopify before cancellation the refund transaction also needs to be logged in OMS against the canceled order.

Below is a sample schema and feed example.
```
[ {
  "id" : "gid://shopify/Order/6364127953060",
  "name" : "HCDEV#2693",
  "updatedAt" : "2024-09-30T10:23:37Z",
  "returnStatus" : "NO_RETURN",
  "taxesIncluded" : false,
  "customer" : {
    "id" : "gid://shopify/Customer/6911550881956",
    "firstName" : "Mridul",
    "lastName" : "Pathak",
    "email" : "mridul.pathak@hotwaxsystems.com",
    "phone" : null
  },
  "originalTotalPriceSet" : {
    "presentmentMoney" : {
      "amount" : "336.09",
      "currencyCode" : "USD"
    }
  },
  "currentTotalPriceSet" : {
    "presentmentMoney" : {
      "amount" : "144.49",
      "currencyCode" : "USD"
    }
  },
  "channelInformation" : {
    "channelId" : "gid://shopify/ChannelInformation/58562838692",
    "channelDefinition" : {
      "channelName" : "Online Store"
    }
  },
  "billingAddress" : {
    "firstName" : "Mridul",
    "lastName" : "Pathak",
    "address1" : "Main st 200",
    "address2" : null,
    "city" : "SLC",
    "provinceCode" : "UT",
    "countryCodeV2" : "US",
    "phone" : null,
    "zip" : "84111"
  },
  "transactions" : [ {
    "id" : "gid://shopify/OrderTransaction/7505033986212",
    "parentTransaction" : null,
    "kind" : "AUTHORIZATION",
    "status" : "SUCCESS",
    "processedAt" : "2024-09-30T07:26:20Z",
    "amountSet" : {
      "presentmentMoney" : {
        "amount" : "336.09",
        "currencyCode" : "USD"
      },
      "shopMoney" : {
        "amount" : "336.09",
        "currencyCode" : "USD"
      }
    },
    "gateway" : "bogus",
    "paymentDetails" : {
      "company" : "Bogus"
    },
    "receiptJson" : "{\"authorized_amount\":\"336.09\"}"
  }, {
    "id" : "gid://shopify/OrderTransaction/7505259593892",
    "parentTransaction" : {
      "id" : "gid://shopify/OrderTransaction/7505033986212"
    },
    "kind" : "CAPTURE",
    "status" : "SUCCESS",
    "processedAt" : "2024-09-30T10:13:20Z",
    "amountSet" : {
      "presentmentMoney" : {
        "amount" : "336.09",
        "currencyCode" : "USD"
      },
      "shopMoney" : {
        "amount" : "336.09",
        "currencyCode" : "USD"
      }
    },
    "gateway" : "bogus",
    "paymentDetails" : {
      "company" : "Bogus"
    },
    "receiptJson" : "{\"paid_amount\":\"336.09\"}"
  }, {
    "id" : "gid://shopify/OrderTransaction/7505268474020",
    "parentTransaction" : {
      "id" : "gid://shopify/OrderTransaction/7505259593892"
    },
    "kind" : "REFUND",
    "status" : "SUCCESS",
    "processedAt" : "2024-09-30T10:23:36Z",
    "amountSet" : {
      "presentmentMoney" : {
        "amount" : "191.6",
        "currencyCode" : "USD"
      },
      "shopMoney" : {
        "amount" : "191.6",
        "currencyCode" : "USD"
      }
    },
    "gateway" : "bogus",
    "paymentDetails" : {
      "company" : "Bogus"
    },
    "receiptJson" : "{\"paid_amount\":\"191.60\"}"
  } ],
  "lineItems" : [ {
    "id" : "gid://shopify/LineItem/16259204022436",
    "variant" : {
      "id" : "gid://shopify/ProductVariant/44342300508324",
      "barcode" : "WJ08XSGrayHC",
      "sku" : "WJ08-XS-Gray"
    },
    "quantity" : 2,
    "nonFulfillableQuantity" : 2
  }, {
    "id" : "gid://shopify/LineItem/16259204055204",
    "variant" : {
      "id" : "gid://shopify/ProductVariant/44342249423012",
      "barcode" : "MH09XSBlueHC",
      "sku" : "MH09-XS-Blue"
    },
    "quantity" : 3,
    "nonFulfillableQuantity" : 1
  } ]
}, {
  "id" : "gid://shopify/Order/6364129460388",
  "name" : "HCDEV#2694",
  "updatedAt" : "2024-09-30T10:23:54Z",
  "returnStatus" : "NO_RETURN",
  "taxesIncluded" : false,
  "customer" : {
    "id" : "gid://shopify/Customer/6911550881956",
    "firstName" : "Mridul",
    "lastName" : "Pathak",
    "email" : "mridul.pathak@hotwaxsystems.com",
    "phone" : null
  },
  "originalTotalPriceSet" : {
    "presentmentMoney" : {
      "amount" : "146.58",
      "currencyCode" : "USD"
    }
  },
  "currentTotalPriceSet" : {
    "presentmentMoney" : {
      "amount" : "60.73",
      "currencyCode" : "USD"
    }
  },
  "channelInformation" : {
    "channelId" : "gid://shopify/ChannelInformation/58562838692",
    "channelDefinition" : {
      "channelName" : "Online Store"
    }
  },
  "billingAddress" : {
    "firstName" : "Mridul",
    "lastName" : "Pathak",
    "address1" : "Main st 200",
    "address2" : null,
    "city" : "SLC",
    "provinceCode" : "UT",
    "countryCodeV2" : "US",
    "phone" : null,
    "zip" : "84111"
  },
  "transactions" : [ {
    "id" : "gid://shopify/OrderTransaction/7505035428004",
    "parentTransaction" : null,
    "kind" : "AUTHORIZATION",
    "status" : "SUCCESS",
    "processedAt" : "2024-09-30T07:27:27Z",
    "amountSet" : {
      "presentmentMoney" : {
        "amount" : "146.58",
        "currencyCode" : "USD"
      },
      "shopMoney" : {
        "amount" : "146.58",
        "currencyCode" : "USD"
      }
    },
    "gateway" : "bogus",
    "paymentDetails" : {
      "company" : "Bogus"
    },
    "receiptJson" : "{\"authorized_amount\":\"146.58\"}"
  }, {
    "id" : "gid://shopify/OrderTransaction/7505259954340",
    "parentTransaction" : {
      "id" : "gid://shopify/OrderTransaction/7505035428004"
    },
    "kind" : "CAPTURE",
    "status" : "SUCCESS",
    "processedAt" : "2024-09-30T10:13:31Z",
    "amountSet" : {
      "presentmentMoney" : {
        "amount" : "146.58",
        "currencyCode" : "USD"
      },
      "shopMoney" : {
        "amount" : "146.58",
        "currencyCode" : "USD"
      }
    },
    "gateway" : "bogus",
    "paymentDetails" : {
      "company" : "Bogus"
    },
    "receiptJson" : "{\"paid_amount\":\"146.58\"}"
  }, {
    "id" : "gid://shopify/OrderTransaction/7505268801700",
    "parentTransaction" : {
      "id" : "gid://shopify/OrderTransaction/7505259954340"
    },
    "kind" : "REFUND",
    "status" : "SUCCESS",
    "processedAt" : "2024-09-30T10:23:54Z",
    "amountSet" : {
      "presentmentMoney" : {
        "amount" : "85.85",
        "currencyCode" : "USD"
      },
      "shopMoney" : {
        "amount" : "85.85",
        "currencyCode" : "USD"
      }
    },
    "gateway" : "bogus",
    "paymentDetails" : {
      "company" : "Bogus"
    },
    "receiptJson" : "{\"paid_amount\":\"85.85\"}"
  } ],
  "lineItems" : [ {
    "id" : "gid://shopify/LineItem/16259206774948",
    "variant" : {
      "id" : "gid://shopify/ProductVariant/44342320431268",
      "barcode" : "WT08XSBlackHC",
      "sku" : "WT08-XS-Black"
    },
    "quantity" : 2,
    "nonFulfillableQuantity" : 1
  }, {
    "id" : "gid://shopify/LineItem/16259206807716",
    "variant" : {
      "id" : "gid://shopify/ProductVariant/44342261383332",
      "barcode" : "MS01XSBlackHC",
      "sku" : "MS01-XS-Black"
    },
    "quantity" : 3,
    "nonFulfillableQuantity" : 2
  } ]
}, {
  "id" : "gid://shopify/Order/6364130050212",
  "name" : "HCDEV#2695",
  "updatedAt" : "2024-09-30T10:24:10Z",
  "returnStatus" : "NO_RETURN",
  "taxesIncluded" : false,
  "customer" : {
    "id" : "gid://shopify/Customer/6911550881956",
    "firstName" : "Mridul",
    "lastName" : "Pathak",
    "email" : "mridul.pathak@hotwaxsystems.com",
    "phone" : null
  },
  "originalTotalPriceSet" : {
    "presentmentMoney" : {
      "amount" : "234.0",
      "currencyCode" : "USD"
    }
  },
  "currentTotalPriceSet" : {
    "presentmentMoney" : {
      "amount" : "121.98",
      "currencyCode" : "USD"
    }
  },
  "channelInformation" : {
    "channelId" : "gid://shopify/ChannelInformation/58562838692",
    "channelDefinition" : {
      "channelName" : "Online Store"
    }
  },
  "billingAddress" : {
    "firstName" : "Mridul",
    "lastName" : "Pathak",
    "address1" : "Main st 200",
    "address2" : null,
    "city" : "SLC",
    "provinceCode" : "UT",
    "countryCodeV2" : "US",
    "phone" : null,
    "zip" : "84111"
  },
  "transactions" : [ {
    "id" : "gid://shopify/OrderTransaction/7505036181668",
    "parentTransaction" : null,
    "kind" : "AUTHORIZATION",
    "status" : "SUCCESS",
    "processedAt" : "2024-09-30T07:28:16Z",
    "amountSet" : {
      "presentmentMoney" : {
        "amount" : "234.0",
        "currencyCode" : "USD"
      },
      "shopMoney" : {
        "amount" : "234.0",
        "currencyCode" : "USD"
      }
    },
    "gateway" : "bogus",
    "paymentDetails" : {
      "company" : "Bogus"
    },
    "receiptJson" : "{\"authorized_amount\":\"234.00\"}"
  } ],
  "lineItems" : [ {
    "id" : "gid://shopify/LineItem/16259208020132",
    "variant" : {
      "id" : "gid://shopify/ProductVariant/44342277046436",
      "barcode" : "MSH0232BlackHC",
      "sku" : "MSH02-32-Black"
    },
    "quantity" : 3,
    "nonFulfillableQuantity" : 2
  }, {
    "id" : "gid://shopify/LineItem/16259208052900",
    "variant" : {
      "id" : "gid://shopify/ProductVariant/44342326886564",
      "barcode" : "WSH0628GrayHC",
      "sku" : "WSH06-28-Gray"
    },
    "quantity" : 3,
    "nonFulfillableQuantity" : 1
  } ]
} ]
```

## Feed conversion for OMS consumption
The json feed would have all the orders that have been updated for any reason since last sync. For OMS consumption It is important to identify only those orders and/or items that have been canceled. Need to transform json feed with only relevant orders, items and related attributes.

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
           - ~~onChangeOrderStatus~~
           - ~~cancelOrderOnMarketplace~~ (Custom)
           - createOrderIndex
           - ~~checkEmailAddressAndSendOrderCompleteNotification~~
           - ~~sendOrderCancelNotification~~ (Later) We are not a notification system anymore.
           - ~~sendOrderCompleteNotification~~ (Later) We are not a notification system anymore.
             * ~~createOrderNotificationLog~~ We are not a notification system anymore.
           - ~~sendOrderSmsNotification~~ (Later) We are not a notification system anymore.
         * checkAndRejectOrderItem (seca) (Custom)
         * rejectTransferOrderItem (seca) (Custom)
         * ~~adjustAtpOnOtherPO~~ (seca) (Custom for PO)
         * ~~checkOrderItemAndCapturePayament (Custom)~~: Called on item completion. Not needed as we are not a payment gateway.
         * ~~onChangeOrderItemStatus~~
         * createOrderIndex
         * ~~checkEmailAddressAndSendOrderCancelledNotification~~
         * ~~completeKitProduct~~ (On item completion)
         * ~~cancelKitComponents~~ (On item cancellation)
         * checkValidASNAndUpdateAtp
     - ~~resetGrandTotal~~ (seca) In new implementation we won't be doing any order calculations in OMS, we will always sync these details from external ecommerce platform.
     - ~~sendOrderChangeNotification~~ (seca)
    
#### Moqui OMS API

**cancel#SalesOrderItem**  
We will consider that order items would always be exploded in OMS and implement the logic accordingly. Given that order item quantity would always be 1 so we don't need quantity as an input. We also don't need to calculate cancelQuantity and identify order items explicitly. We could simply validate order item status and update status and cancelQuantity fields on order item. Refer OFBiz OrderServices.cancel#OrderItem service for relevant code and implement the new service as described below.
1. Input
   - orderId
   - orderItemSeqId
   - shipGroupSeqId
   - reason
   - comment
2. Validate order item status, if already canceled or completed log error.
3. Update OrderItem.cancelQuantity and OrderItemShipGroupAssoc.cancelQuantity.
4. Call create#OrderItemChange inline with relevant input. This can be a simple entity auto operation.
5. Call create#OrderNote inline with relevant input. This can be a simple entity auto operation.
6. Call cancel#OrderItemInvResQty inline with relevant input. A new service to be implemented, refer implementation details below.
7. Call get#OrderItemSalesTaxTotal (new helper service) inline and if taxTotal is greater than zero, call create#OrderAdjustment inline with relevant input. Refer ShopifyOrderServices.cancel#ShopifyOrderItem method at L2943.
8. Call create#CommunicationEvent inline with relevant input. Refer ShopifyOrderServices.cancel#ShopifyOrderItem method. This can be a simple entity auto operation.
9. Call change#SalesOrderItemStatus inline with relevant input. A new service to be implemented, refer implementation details below.

**cancel#OrderItemInvResQty**  
Considering that order items would always be exploded and each order item would represent a single quantity, there should ideally only be one associated inventory reservation record to be removed,
1. Input
   - orderId
   - orderItemSequId
   - shipGroupSeqId
2. Find OrderItemShipGroupInvRes records (ideally only one should be returned) and delete them.
3. Call create#InventoryItemDetail inline with relevant input.  This can be a simple entity auto operation.

**change#SalesOrderItemStatus**  
1. Input
   - orderId
   - orderItemSeqId
   - statusId
   - changeReason
   - statusDateTime
3. Validate StatusValidChange, a helper method _check#ValidStatusChange_ could be implemented to return boolean value.
4. Update OrderItem.statusId.
5. Call create#OrderStatus inline with relevant input. This can be a simple entity auto operation.
6. If statusId is canceled or completed call check#CancelCompleteSalesOrder inline, refer implementation details below.

**check#CancelCompleteSalesOrder**
1. Input
   - orderId
2. Refer check#CancelCompleteOrder service in https://github.com/moqui/mantle-usl/blob/master/service/mantle/order/OrderServices.xml, the code should be written in the same fashion in context of OFBiz data model instead of Moqui data model as follows,
   - Replace Moqui OrderHeader reference with OFBiz OrderHeader reference
   - Replace Moqui OrderPart reference with OFBiz OrderItem reference
   - Replace Moqui update#OrderHeader entity auto operation with inline change#SalesOrderStatus service call (setItemStatus=false), refer implementation details below.

**change#SalesOrderStatus**
1. Input
   - orderId
   - statusId
   - changeReason
   - setItemStatus
2. Validate StatusValidChange.
3. Update OrderHeader.statusId.
4. Call create#OrderStatus inline with relevant input.
5. If setItemStatus=true, iterate through related OrderItem records and call change#SalesOrderItemStatus inline.

> TODO
>
> - checkAndRejectOrderItem
> - rejectTransferOrderItem
> - checkValidASNAndUpdateAtp
> - createOrderIndex

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



