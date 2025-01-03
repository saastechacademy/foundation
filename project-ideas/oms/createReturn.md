## `create#org.apache.ofbiz.order.return.ReturnHeader`

Input JSON

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
  ]
}
```