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
      "originExternalFacilityId": "150",
      "destinationExternalFacilityId": "94",
      "orderDate": "2025-01-29",
      "shipGroups": [
         {
            "shipmentMethodTypeId": "STANDARD",
            "carrierPartyId": "_NA_",
            "items": [
               {
                  "externalId": "1",
                  "quantity": 2,
                  "productId": "",
                  "goodIdentifications": [
                     {
                        "idValue": "164013",
                        "idType": "NETSUITE_PRODUCT_ID"
                     }
                  ]
               },
               {
                  "statusId": "ITEM_CREATED",
                  "externalId": "2",
                  "quantity": 2,
                  "productId": "",
                  "goodIdentifications": [
                     {
                        "idValue": "164367",
                        "idType": "NETSUITE_PRODUCT_ID"
                     }
                  ]
               },
               {
                  "statusId": "ITEM_CREATED",
                  "externalId": "3",
                  "quantity": 4,
                  "productId": "",
                  "goodIdentifications": [
                     {
                        "idValue": "164368",
                        "idType": "NETSUITE_PRODUCT_ID"
                     }
                  ]
               }
            ]
         }
      ]
   }
}
```

## Mapping with OOTB create#org.apache.ofbiz.order.order.OrderHeader

| Create TO API payload field                            | OMS create Order OOTB                        | Comments                                                                               |
|--------------------------------------------------------|----------------------------------------------|----------------------------------------------------------------------------------------|
| statusFlowId                                           | statusFlowId                                 | - new field to be added in OrderHeader                                                 |
| externalId                                             | externalId                                   |                                                                                        |
| orderName                                              | orderName                                    |                                                                                        |
| statusId                                               | statusId                                     |                                                                                        |
| productStoreId                                         | productStoreId                               |                                                                                        |
| originExternalFacilityId                               | shipGroups.facilityId <br/> originFacilityId | - Fetch facilityId using externalId from Facility                                      |
| destinationExternalFacilityId                          | shipGroups.orderFacilityId                   | - Fetch facilityId using externalId from Facility                                      |
| orderDate                                              | orderDate                                    |                                                                                        |
| shipGroups.shipmentMethodTypeId                        | shipGroups.shipmentMethodTypeId              |                                                                                        |
| shipGroups.carrierPartyId                              | shipGroups.carrierPartyId                    |                                                                                        |
| shipGroups.items.statusId                              | shipGroups.items.statusId                    |                                                                                        |
| shipGroups.items.externalId                            | shipGroups.items.externalId                  |                                                                                        |
| shipGroups.items.quantity                              | shipGroups.items.quantity                    |                                                                                        |
| shipGroups.items.goodIdentifications.idValue <br/> shipGroups.items.goodIdentifications.idType | shipGroups.items.productId                   | - Fetch productId from GoodIdentifications using idValue and goodIdentifiicationTypeId |

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
      1. Get the OMS Facility ID for originExternalFacilityId and destinationExternalFacilityId
         1. Fetch and remove the originExternalFacilityId from payload
         2. Fetch and remove the destinationExternalFacilityId from payload
         3. Entity Find on Facility entity with operator IN and condition on externalId field with above values
         4. Set the OMS Facility corresponding to originExternalFacilityId in shipGroup.facilityId and shipGroup.originFacilityId
         5. Set the OMS Facility corresponding to destinationExternalFacilityId in shipGroup.orderFacilityId
      2. Iterate on shipGroup.items - item
         1. Set shipGroups.items.orderItemTypeId - PRODUCT_ORDER_ITEM
         2. Set item.statusId = "ITEM_CREATED"
         3. Check if productId available in the payload or not
         4. If not, check for goodIdentifications in the payload and get the OMS productId 
            1. Fetch and remove the item.goodIdentifications
            2. Iterate on item.goodIdentifications - goodIdentification
            3. Entity Find on GoodIdentification using idType and idValue
            4. Set the productId in item.productId
            5. Break the loop if productId is found
         5. Prepare the itemDescription for item
            1. Entity find on ProductAssocAndFrom view with conditions on productIdTo=<productId>, productAssocTypeId="PRODUCT_VARIANT" with date filter order by -fromDate
            2. Set shipGroups.items.itemDescription from productName from ProductAssocAndFrom result
   9. Call create#org.apache.ofbiz.order.order.OrderHeader in-map="payload" transaction="force-new" 
   10. Call oms service call#CreateOrderIndex with orderId transaction="force-new" ignore-error="true"

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