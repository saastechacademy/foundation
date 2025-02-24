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
      "statusId": "ORDER_CREATED",
      "originExternalFacilityId": "150",
      "destinationExternalFacilityId": "94",
      "orderDate": "2025-01-29",
      "shipGroups": [
         {
            "shipmentMethodTypeId": "STANDARD",
            "carrierPartyId": "_NA_",
            "items": [
               {
                  "statusId": "ITEM_CREATED",
                  "externalId": "1",
                  "quantity": 2,
                  "productId": "",
                  "productIdentifications": [
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
                  "productIdentifications": [
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
                  "productIdentifications": [
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
| shipGroups.items.productIdentifications.idValue <br/> shipGroups.items.productIdentifications.idType | shipGroups.items.productId                   | - Fetch productId from GoodIdentifications using idValue and goodIdentifiicationTypeId |

## create#SalesOrder Service

1. Input Parameters
   1. payload  - This will be the order JSON Map.

2. Service Actions
   1. Set payload.orderTypeId = "TRANSFER_ORDER"
   2. Prepare entryDate as ec.user.nowTimestamp and set in payload.entryDate
   3. Iterate on payload.shipGroups
      1. Get the OMS Facility ID for originExternalFacilityId and destinationExternalFacilityId
         1. Fetch and remove the originExternalFacilityId from payload
         2. Fetch and remove the destinationExternalFacilityId from payload
         3. Entity Find on Facility entity with operator IN and condition on externalId field with above values
         4. Set the OMS Facility corresponding to originExternalFacilityId in payload.shipGroups.facilityId and payload.originFacilityId
         5. Set the OMS Facility corresponding to destinationExternalFacilityId in payload.shipGroups.orderFacilityId
      2. Iterate on shipGroups.items
         1. Set shipGroups.items.orderItemTypeId - PRODUCT_ORDER_ITEM
         2. Check if productId available in the payload or not
         3. If not, check for productIdentifications in the payload and get the OMS productId 
            - Fetch and remove the shipGroups.items.productIdentifications
            - Entity Find on GoodIdentification using productIdentifications.idType and idValue
            - Set the productId in shipGroups.items.productId
         4. Prepare the itemDescription for shipGroups.items
            - Entity find on ProductAssocAndFrom view with conditions on productIdTo=<productId>, productAssocTypeId="PRODUCT_VARIANT" with date filter order by -fromDate
            - Set shipGroups.items.itemDescription from productName from ProductAssocAndFrom result
   4. Call create#org.apache.ofbiz.order.order.OrderHeader in-map="payload"
   5. TODO discuss the creation of TO in Solr ?

### Fields not handled with comparison to as-is impl
1. salesChannelEnumId
   - set from ProductStore.defaultSalesChannelEnumId?
2. currencyUom
   - set from ProductStore.defaultCurrencyUom?
3. shipGroups.maySplit
4. shipGroups.isGift
5. shipGroups.items.prodCatalogId
6. shipGroups.items.isPromo
7. shipGroups.items.unitPrice
8. shipGroups.items.unitListPrice
9. shipGroups.items.isModifiedPrice

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