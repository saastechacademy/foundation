# Outbound Transfer Shipment	
Prepare data and calls [createShipment](../oms/createShipment.md)

## **Purpose:**

* The POST transferShipments API is used to create the OUT_TRANSFER type shipment for the transfer order.   

## **API Spec:**

- The API creates the Transfer Shipment for the TO. 
- The service to create the Transfer Shipment will record data in `Shipment`, `ShipmentItem`, `ShipmentPackage`, `ShipmentPackageContent`, `ShipmentRouteSegment`, `ShipmentPackageRouteSeg`, `OrderShipment` and `ShipmentStatus` based on a list of `OrderItem`s belonging to the same `OrderItemShipGroup`.
- The data is prepared to call the [createShipment](../oms/createShipment.md).

#### API parameters

**Input**
1. orderId* - The ID of the Transfer Order in OMS.
2. externalId - The ID of the Shipment in the external system.
3. trackingNumber - The tracking number for the Shipment. This could be used to store the tracking number of the
   Shipment to be created in OMS if fulfilled externally by third party eg. Wh to Store TOs from NetSuite.
4. shipmentStatusId - The ID of the Shipment Status in OMS.
5. items* list - The list of order items to be fulfilled.
   1. orderItemSeqId - The Seq ID of the Transfer Order Item in OMS.
   2. shipGroupSeqId - The Ship Group Seq ID of the Transfer Order Item in OMS.
   3. externalId - The ID of the Shipment Item in the external system.
   4. productId - The ID of the product in OMS for the Transfer Order Item.
   5. quantity - The quantity of the item to be fulfilled.

**Output**
1. shipmentId

### Sample Payload

**Sample 1**

This json corresponds to the input for "Create Shipment" action for Transfer Orders in the Fulfillment app for OMS.
By Default, the Shipment will be created in 'SHIPMENT_PACKED' status in OMS.

* Method: POST
* API: {baseUrl}/rest/s1/poorti/transferShipments
* Input:
    ```json
    {
       "payload": {
           "orderId": "M101175",
           "items": [
               {
                   "orderItemSeqId": "01",
                   "shipGroupSeqId": "00001",
                   "productId": "10079",
                   "quantity": 10
               },
               {
                   "orderItemSeqId": "02",
                   "shipGroupSeqId": "00001",
                   "productId": "10326",
                   "quantity": 10
               }
           ]
       }
    }
    ```

**Sample 2**

- This json corresponds to the input for creating the Shipments of Transfer Orders synced from external systems like NetSuite.
- In this scenario, the Shipment will be created in 'SHIPMENT_SHIPPED' status in OMS.

```json
{
   "payload": {
       "orderId": "M101175",
       "externalId": "46653929",
       "trackingNumber": "12345",
       "shipmentStatusId": "SHIPMENT_SHIPPED",
       "items": [
           {
               "orderItemSeqId": "01",
               "externalId": "1",
               "shipGroupSeqId": "00001",
               "productId": "10079",
               "quantity": 10
           },
           {
               "orderItemSeqId": "02",
               "externalId": "2",
               "shipGroupSeqId": "00001",
               "productId": "10326",
               "quantity": 10
           }
       ]
   }
}
```

### Sample Output

This returns the Shipment ID for the Shipment created for the Transfer Order.

```json
{
   "shipmentId": "M101785"
}
```


