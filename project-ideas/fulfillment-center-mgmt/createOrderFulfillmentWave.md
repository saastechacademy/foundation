### **Detailed Actions for `createOrderFulfillmentWave` Service**

#### Sample Input JSON
```
{
  "facilityId": "23763",
  "shipmentMethodTypeId": "OVERNIGHT_SHIPPING",
  "statusId": "PICKLIST_IN_PROGRESS",
  "pickers": 
    [{
        "partyId":"1001",
        "roleTypeId":"WAREHOUSE_PICKER"
    }],
  "orderItems": [
    {
      "orderId": "10000",
      "orderItemSeqId": "00101",
      "productId": "10001",
      "shipGroupSeqId":"00002",
      "inventoryItemId":"10000",
      "quantity": 1
    },
    {
      "orderId": "10000",
      "orderItemSeqId": "00102",
      "productId": "10017",
      "shipGroupSeqId":"00002",
      "inventoryItemId":"10000",
      "quantity": 1
    },
    {
      "orderId": "10010",
      "orderItemSeqId": "00101",
      "productId": "10001",
      "shipGroupSeqId":"00002",
      "inventoryItemId":"10010",
      "quantity": 1
    }
  ]
}
```

#### Input Parameters

- facilityId
- shipmentMethodTypeId
- statusId
- pickers
- orderItems

1. **Initialize the Picklist Map:**  
   * **Operation:** Constructs a map named `picklistMap` to hold the details required for creating a picklist.  
   * **Steps:**  
     * **Top-Level Fields:** Assigns values from the service's input parameters (`facilityId`, `shipmentMethodTypeId`, `statusId`) to `picklistMap`.  
     * **Pickers Processing:**  
       * Initializes `pickersList` to store the processed pickers.  
       * Iterates over each `picker` in the `pickers` list.  
       * For each picker, creates a new map with `partyId` and `roleTypeId`.  
       * Adds each `pickerMap` to `pickersList`.  
       * Assigns `pickersList` to the `pickers` field in `picklistMap`.  
     * **Order Items Processing:**  
       * Initializes `picklistOrderItemsList` to store the order items.  
       * Iterates over each `item` in the `orderItems`.  
       * Adds each item directly to `picklistOrderItemsList` 
       * Assigns `picklistOrderItemsList` to the `picklistOrderItems` field in `picklistMap`.  
2. **Service Call: `co.hotwax.poorti.FulfillmentServices.create#Picklist`**  
   * **Operation:** Creates a picklist using the `picklistMap`.  
   * **Steps:**  
     * **Input Map:** Sends `picklistMap` as input.  
     * **Output Map:** Receives `picklistOut` which contains the result of the picklist creation.  
     * **Logs:** Outputs the result to the logs for debugging or information purposes.  
3. **Update Order Fulfillment Map:**  
   * **Operation:** Prepares the `orderFulfillmentMap` with details necessary for updating the fulfillment status of each order item.  
   * **Steps:**  
     * **Initialization:** Creates a new map (`orderFulfillmentMap`) with default values.  
     * **Fields Assignment:**  
       * Sets `picklistId` in `orderFulfillmentMap` using the `picklistId` from `picklistOut`.  
       * Assigns `pickers` from the service input to `orderFulfillmentMap`.  
       * Sets status fields (`picklistItemStatusId`, `picklistItemStatusDesc`, `fulfillmentStatus`, `isPicked`) with predefined values.  
4. **Service Call (Iteration): `co.hotwax.poorti.SearchServices.update#OrderFulfillmentStatus`**  
   * **Operation:** Updates the fulfillment status for each order item in Solr.  
   * **Steps:**  
     * **Iteration:** Loops through each `orderItem` in the `orderItems` list.  
     * **Fields Assignment:**  
       * Sets `orderId` and `orderItemSeqId` from the current `orderItem`.  
     * **Service Call:**  
       * Sends `orderId`, `orderItemSeqId`, and `orderFulfillmentMap` to the `update#OrderFulfillmentStatus` service.  
       * The service updates the order fulfillment status in Solr based on the input parameters.  
5. **Service Call: `co.hotwax.poorti.FulfillmentServices.create#SalesOrderShipment`**  
   * **Operation:** Creates a sales order shipment based on the provided `orderItems` and `facilityId`.  
   * **Steps:**  
     * **Grouping Order Items:**  
       * Groups `orderItems` by `orderId` using `groupBy`.  
       * Iterates through each group (`orderEntry`) where `orderEntry.key` is `orderId` and `orderEntry.value` is a list of items.  
     * **Shipment Creation:**  
       * Creates a new map (`shipmentMap`) for each group with required shipment details.  
       * Calls the `create#org.apache.ofbiz.shipment.shipment.Shipment` service with `shipmentMap` to create the shipment.

6. The OrderItems are tagged "isPicked: Y" in SOLR doc.

[createPickList](PickList.md)
