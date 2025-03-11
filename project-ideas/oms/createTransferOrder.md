# create#TransferOrder

Transfer Order is created and processed for moving inventory within the Organization. 

A Transfer order could be created in third party system e.g NetSuite. 
A Transfer order could be processed in third party WMS / Fulfillment application. 

1. A TO might be imported in the OMS system for a Shipment shipped from third party system to be received in fulfillment location managed by OMS.
2. A TO might be imported in the OMS system for a Shipment to be shipped from fulfillment location managed by OMS and received in location managed by third party.
3. A TO might be imported in the OMS system for a Shipment to be shipped and received from fulfillment locations both managed by OMS.

## API Spec

The API for managing TO builds on the [createOrder](../oms/createOrder.md)

```json
{
   "payload": {
      "externalId": "43321190",
      "orderName": "TO0034444",
      "statusFlowId": "TO_PendingFulfill",
      "productStoreId": "STORE",
      "originFacilityId": "150",
      "orderDate": "2025-01-29",
      "shipGroups": [
         {
            "shipmentMethodTypeId": "STANDARD",
            "carrierPartyId": "_NA_",
            "destinationFacilityId": "94",
            "items": [
               {
                  "productId": "164013",
                  "externalId": "1",
                  "quantity": 2
               },
               {
                  "productId": "164367",
                  "externalId": "2",
                  "quantity": 2
               },
               {
                  "productId": "164368",
                  "externalId": "3",
                  "quantity": 4
               }
            ]
         }
      ]
   }
}
```

## Mapping with OOTB create#org.apache.ofbiz.order.order.OrderHeader

| Create TO API payload field              | OMS create Order OOTB                        | 
|------------------------------------------|----------------------------------------------|
| externalId                               | externalId                                   |
| orderName                                | orderName                                    |
| statusFlowId                             | statusFlowId                                 |
| productStoreId                           | productStoreId                               |
| originFacilityId                         | shipGroups.facilityId <br/> originFacilityId |
| orderDate                                | orderDate                                    |
| shipGroups.destinationFacilityId         | shipGroups.orderFacilityId                   |
| shipGroups.shipmentMethodTypeId          | shipGroups.shipmentMethodTypeId              |
| shipGroups.carrierPartyId                | shipGroups.carrierPartyId                    |
| shipGroups.items.productId               | shipGroups.items.productId                   |
| shipGroups.items.externalId              | shipGroups.items.externalId                  |
| shipGroups.items.quantity                | shipGroups.items.quantity                    |

## create#TransferOrder Service

1. Input Parameters
   1. payload  - This will be the order JSON Map.

2. Service Actions
   1. Set payload.orderTypeId = "TRANSFER_ORDER"
   2. Set payload.statusId = "ORDER_CREATED"
   3. Set entryDate as ec.user.nowTimestamp and set in payload.entryDate
   4. Set createdBy as ec.user.getUsername()?:ec.user.getUserId()
   5. Get ProductStore using payload.productStoreId, required for the TO creation
   6. Set salesChannelEumId as productStore.defaultSalesChannelEnumId if not in the payload
   7. Set currencyUom as productStore.defaultCurrencyUomId if not in the payload
   8. Iterate on payload.shipGroups - shipGroup
      1. Remove and set destinationFacilityId from shipGroup as orderFacilityId in shipGroup
      2. Iterate on shipGroup.items - item
         1. Set shipGroups.items.orderItemTypeId - PRODUCT_ORDER_ITEM
         2. Set item.statusId = "ITEM_CREATED"
   9. Call create#org.apache.ofbiz.order.order.OrderHeader in-map="payload" 
   10. Call oms service call#CreateOrderIndex with orderId async="true" ignore-error="true"

### Payload prepared for OOTB create#org.apache.ofbiz.order.order.OrderHeader

```json
{
   "externalId": "43321190",
   "orderName": "TO0034444",
   "statusFlowId": "TO_PendingFulfill",
   "productStoreId": "STORE",
   "statusId": "ORDER_CREATED",
   "orderTypeId": "TRANSFER_ORDER",
   "orderDate": "2025-01-29",
   "entryDate": "2025-01-29 18:00:00",
   "originFacilityId": "150",
   "shipGroups": [
      {
         "shipmentMethodTypeId": "STANDARD",
         "carrierPartyId": "_NA_",
         "facilityId": "150",
         "orderFacilityId": "94",
         "items": [
            {
               "orderItemTypeId": "PRODUCT_ORDER_ITEM",
               "statusId": "ITEM_CREATED",
               "externalId": "1",
               "quantity": 2,
               "productId": "58160"
            },
            {
               "orderItemTypeId": "PRODUCT_ORDER_ITEM",
               "statusId": "ITEM_CREATED",
               "externalId": "2",
               "quantity": 2,
               "productId": "58163"
            },
            {
               "orderItemTypeId": "PRODUCT_ORDER_ITEM",
               "statusId": "ITEM_CREATED",
               "externalId": "3",
               "quantity": 4,
               "productId": "58162"
            }
         ]
      }
   ]
}
```