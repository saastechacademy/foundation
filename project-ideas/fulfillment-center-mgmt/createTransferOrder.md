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
      "externalId": 43321190,
      "orderName": "TO0034444",
      "statusFlowId": "TO_PendingFulfill",
      "productStoreId": "STORE",
      "statusId": "ORDER_CREATED",
      "originExternalFacilityId": 150,
      "destinationExternalFacilityId": 94,
      "orderDate": "2025-01-29",
      "shipGroups": [
         {
            "shipmentMethodTypeId": "STANDARD",
            "carrierPartyId": "_NA_",
            "items": [
               {
                  "statusId": "ITEM_CREATED",
                  "externalId": 1,
                  "quantity": 2,
                  "productId": "",
                  "productIdentifications": [
                     {
                        "idValue": 164013,
                        "idType": "NETSUITE_PRODUCT_ID"
                     }
                  ]
               },
               {
                  "statusId": "ITEM_CREATED",
                  "externalId": 2,
                  "quantity": 2,
                  "productId": "",
                  "productIdentifications": [
                     {
                        "idValue": 164367,
                        "idType": "NETSUITE_PRODUCT_ID"
                     }
                  ]
               },
               {
                  "statusId": "ITEM_CREATED",
                  "externalId": 3,
                  "quantity": 4,
                  "productId": "",
                  "productIdentifications": [
                     {
                        "idValue": 164368,
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

| Create TO API payload field                     | OMS create Order OOTB           | Comments                                                                               |
|-------------------------------------------------|---------------------------------|----------------------------------------------------------------------------------------|
| statusFlowId                                    | statusFlowId                    | - new field to be added in OrderHeader                                                 |
| externalId                                      | externalId                      |                                                                                        |
| orderName                                       | orderName                       |                                                                                        |
| statusId                                        | statusId                        |                                                                                        |
| productStoreId                                  | productStoreId                  |                                                                                        |
| originExternalFacilityId                        | shipGroups.facilityId           | - Fetch facilityId using externalId from Facility                                      |
| destinationExternalFacilityId                   | shipGroups.orderFacilityId      | - Fetch facilityId using externalId from Facility                                      |
| orderDate                                       | orderDate                       |                                                                                        |
| shipGroups.shipmentMethodTypeId                 | shipGroups.shipmentMethodTypeId |                                                                                        |
| shipGroups.carrierPartyId                       | shipGroups.carrierPartyId       |                                                                                        |
| shipGroups.items.statusId                       | shipGroups.items.statusId       |                                                                                        |
| shipGroups.items.externalId                     | shipGroups.items.externalId     |                                                                                        |
| shipGroups.items.quantity                       | shipGroups.items.quantity       |                                                                                        |
| shipGroups.items.productIdentifications.idValue | shipGroups.items.productId      | - Fetch productId from GoodIdentifications using idValue and goodIdentifiicationTypeId |
| shipGroups.items.productIdentifications.idType  |                                 |                                                                                        |

## create#SalesOrder Service

1. Input Parameters
   1. payload  - This will be the order JSON Map.

2. Logic
   1. Set payload.orderTypeId = "TRANSFER_ORDER"
   2. Prepare entryDate as nowTimestamp and set in payload.entryDate
   3. Get the OMS Facility ID for originExternalFacilityId to send in shipGroups.facilityId
      - Fetch and remove the originExternalFacilityId from payload
      - Entity Find on Facility condition on externalId
      - Set the Facility.facilityId in payload.shipGroups.facilityId
      - Also set this in payload.originFacilityId
   4. Get the OMS Facility ID for destinationExternalFacilityId to send in shipGroups.orderFacilityId
      - Fetch and remove the destinationExternalFacilityId from payload
      - Entity Find on Facility condition on externalId
      - Set the Facility.facilityId in payload.shipGroups.orderFacilityId
   5. Iterate on shipGroups.items
      1. Set payload.shipGroups.items.orderItemTypeId - PRODUCT_ORDER_ITEM
      2. Prepare the itemDescription for shipGroups.items
         - TODO update the behavior to be generic, if no productId, then check productIdentifications
         - Fetch and remove the shipGroups.items.productIdentifications
         - Entity Find on GoodIdentification using productIdentifications.idType and idValue
         - Set the GoodIdentification.productId in shipGroups.items.productId
   6. TODO check the preparation of other fields if populated in current TO creation
   7. Call create#org.apache.ofbiz.order.order.OrderHeader in-map="payload"
   8. TODO discuss the creation of TO in Solr ?

### Fields not handled with comparison to as-is impl
   1. shipGroups.items.maySplit