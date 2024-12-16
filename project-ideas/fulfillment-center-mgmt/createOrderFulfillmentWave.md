### **Detailed Actions for `createOrderFulfillmentWave` Service**

#### Sample Input JSON
```
{
  "facilityId": "23763",
  "pickers": 
    [{
        "partyId":"1001",
    }],
  "orderItems": [
    {
      "orderId": "10000",
      "orderItemSeqId": "00101",
      "shipGroupSeqId":"00002",
      "productId": "10001",
      "inventoryItemId":"10000",
      "quantity": 1
    },
    {
      "orderId": "10000",
      "orderItemSeqId": "00102",
      "shipGroupSeqId":"00002",
      "productId": "10017",
      "inventoryItemId":"10000",
      "quantity": 1
    },
    {
      "orderId": "10010",
      "orderItemSeqId": "00101",
      "shipGroupSeqId":"00002",
      "productId": "10001",
      "inventoryItemId":"10010",
      "quantity": 1
    }
  ]
}
```

#### Input Parameters

- facilityId
- pickers
- orderItems

1. **Service Call: `co.hotwax.poorti.FulfillmentServices.create#SalesOrderShipment`**
    * **Operation:** For each ship group, create a sales order shipment based on the provided `orderItems` and `facilityId`.
2. **Service Call (Iteration): `co.hotwax.poorti.SearchServices.update#OrderFulfillmentStatus`**
    * **Operation:** Updates the fulfillment status for each order item in Solr.
    * **Steps:**
        * **Iteration:** Loops through each `orderItem` in the `orderItems` list.
        * **Fields Assignment:**
            * Sets `orderId` and `orderItemSeqId` from the current `orderItem`.
        * **Service Call:**
            * Sends `orderId`, `orderItemSeqId`, and `orderFulfillmentMap` to the `update#OrderFulfillmentStatus` service.
            * The service updates the order fulfillment status in Solr based on the input parameters.
3. **Initialize the Picklist Map:**  
   * **Steps:**  
     * **Pickers Processing:**  
       * Initializes `pickersList` to store the processed pickers.  
       * Iterates over each `picker` in the `pickers` list.  
       * For each picker, creates a new map with `partyId` and `roleTypeId` is picker.  
       * Adds each `pickerMap` to `pickersList`.  
       * Assigns `pickersList` to the `pickers` field in `picklistMap`.  
4. **Service Call: `co.hotwax.poorti.FulfillmentServices.create#Picklist`**  
   * **Operation:** Creates a picklist using the list of created shipments.  
5. **Return picklistId** The event handler will then use picklistId to generate pdf return to the webapp.


[createPickList](PickList.md)
