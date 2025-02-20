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
[
  {
    "externalId": 43321190,
    "orderName": "TO0034444",
    "statusFlowId": "TO_PendingFulfill",
    "productStoreId": "STORE",
    "statusId": "ORDER_CREATED",
    "sourceExternalFacilityId": 150,
    "destinationExternalFacilityId": 94,
    "entryDate": "2025-01-29",
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
  },
  {
    "externalId": 43621163,
    "orderName": "TO0035070",
    "statusFlowId": "TO_PendingReceive",
    "productStoreId": "STORE",
    "statusId": "ORDER_CREATED",
    "sourceExternalFacilityId": 152,
    "destinationExternalFacilityId": 125,
    "entryDate": "2025-02-18",
    "shipGroups": [
      {
        "shipmentMethodTypeId": "STANDARD",
        "carrierPartyId": "_NA_",
        "items": [
          {
            "statusId": "ITEM_CREATED", 
            "externalId": 1, 
            "quantity": 1,  
            "productId": "", 
            "productIdentifications": [ 
              {
                "idValue": 161864,
                "idType": "NETSUITE_PRODUCT_ID"
              }
            ]
          },
          {
            "statusId": "ITEM_CREATED", 
            "externalId": 10, 
            "quantity": 1,     
            "productId": "", 
            "productIdentifications": [ 
              {
                "idValue": 159417,
                "idType": "NETSUITE_PRODUCT_ID"
              }
            ]
          },
          {
            "statusId": "ITEM_CREATED", 
            "externalId": 13, 
            "quantity": 1,     
            "productId": "", 
            "productIdentifications": [ 
              {
                "idValue": 160359,
                "idType": "NETSUITE_PRODUCT_ID"
              }
            ]
          },
          {
            "statusId": "ITEM_CREATED", 
            "externalId": 4, 
            "quantity": 1,     
            "productId": "", 
            "productIdentifications": [ 
              {
                "idValue": 159884,
                "idType": "NETSUITE_PRODUCT_ID"
              }
            ]
          },
          {
            "statusId": "ITEM_CREATED", 
            "externalId": 7, 
            "quantity": 1,     
            "productId": "", 
            "productIdentifications": [ 
              {
                "idValue": 160237,
                "idType": "NETSUITE_PRODUCT_ID"
              }
            ]
          }
         ]
      }
    ]
  }
]
```

## Mapping with OOTB create#org.apache.ofbiz.order.order.OrderHeader

| Create TO API payload field                     | OMS create Order OOTB           | Comments                                                                               |
|-------------------------------------------------|---------------------------------|----------------------------------------------------------------------------------------|
| statusFlowId                                    | statusFlowId                    | - new field to be added in OrderHeader                                                 |
| externalId                                      | externalId                      |                                                                                        |
| orderName                                       | orderName                       |                                                                                        |
| statusId                                        | statusId                        |                                                                                        |
| productStoreId                                  | productStoreId                  |                                                                                        |
| sourceExternalFacilityId                        | orderHeader.originFacilityId    | - Fetch facilityId using externalId to pass in originFacilityId                        |
| destinationExternalFacilityId                   | shipGroups.facilityId           | - Fetch facilityId using externalId to pass in facilityId                              |
| entryDate                                       | orderDate                       |                                                                                        |
| shipGroups.shipmentMethodTypeId                 | shipGroups.shipmentMethodTypeId |                                                                                        |
| shipGroups.carrierPartyId                       | shipGroups.carrierPartyId       |                                                                                        |
| shipGroups.items.statusId                       | shipGroups.items.statusId       |                                                                                        |
| shipGroups.items.externalId                     | shipGroups.items.externalId     |                                                                                        |
| shipGroups.items.quantity                       | shipGroups.items.quantity       |                                                                                        |
| shipGroups.items.productIdentifications.idValue | shipGroups.items.productId      | - Fetch productId from GoodIdentifications using idValue and goodIdentifiicationTypeId |
| shipGroups.items.productIdentifications.idType  |                                 |                                                                                        |

## create#SalesOrder Service 

1. Input Parameters
   1. The fields in the "Create TO API payload field" column in the above mapping table will be the input parameters.

2. Default values to be handled in service while preparing input for OOTB create Order
   1. orderTypeId - TRANSFER_ORDER
   2. shipGroups.items.orderItemTypeId - PRODUCT_ORDER_ITEM
   
3. Other fields to be prepared in the service logic for OOTB create Order
   1. entryDate - Set as nowTimestamp to pass in OOTB createOrder
   2. shipGroups.items.itemDescription - Fetch from ParentProduct.productName
   3. shipGroups.items.maySplit - do we need to handle this?