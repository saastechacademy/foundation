### create#SalesReturn (Application Layer)
This service will take in the order JSON in OMSNewOrdersFeed and set up a complete order by performing any surrounding crud operations as needed.
1. Parameters
    * Input Parameters
        * returnJson (Map) (See sample JSON below)
2. Set orderPaymentPreferences = remove returnJson.orderPaymentPreferences
3. Call create#org.apache.ofbiz.order.return.ReturnHeader for returnJson map
4. Iterate through orderPaymentPreferences and call create#org.apache.ofbiz.order.order.OrderPaymentPreference for each entry.

```json
{
   "externalId": "5758438048022",
   "returnHeaderTypeId": "CUSTOMER_RETURN",
   "statusId": "RETURN_COMPLETED",
   "fromPartyId": "10021",
   "toPartyId": "COMPANY",
   "destinationFacilityId": "CENTRAL_WAREHOUSE",
   "currencyUomId": "USD",
   "items": [
      {
         "externalId": "44342250930340",
         "returnReasonId": "RTN_NOT_WANT",
         "returnTypeId": "RTN_REFUND",
         "returnItemTypeId": "RET_FPROD_ITEM",
         "productId": "10071",
         "orderId": "10240",
         "orderItemSeqId": "00101",
         "statusId": "RETURN_RECEIVED",
         "expectedItemStatus": "INV_RETURNED",
         "returnQuantity": 1,
         "returnPrice": 60,
         "reason": "Return Reason Note"
      }
   ],
   "identifications": [
      {
         "returnIdentificationTypeId": "SHOPIFY_RTN_ID",
         "idValue": "5758438048022"
      }
   ],
   "orderPaymentPreferences": [
      {
         "statusId" : "PAYMENT_REFUNDED",
         "paymentMethodTypeId" : "EXT_SHOP_OTHR_GTWAY",
         "orderId" : "10032",
         "maxAmount" : 191.6,
         "presentmentAmount" : "191.6",
         "presentmentCurrencyUom" : "USD",
         "exchangeRate" : null,
         "manualRefNum" : "7505268474020"
      }
   ]
}
```