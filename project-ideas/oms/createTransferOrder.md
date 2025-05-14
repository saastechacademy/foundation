# create#TransferOrder

Transfer Order is created and processed for moving inventory within the Organization. 

A Transfer order could be created in third party system e.g NetSuite. 
A Transfer order could be processed in third party WMS / Fulfillment application. 

A Transfer Order could be created for one or more of the below scenarios:
1. Warehouse to Store - A TO might be imported in the OMS system for a Shipment shipped from third party system to be received in fulfillment location managed by OMS.
2. Store to Warehouse - A TO might be imported in the OMS system for a Shipment to be shipped from fulfillment location managed by OMS and received in location managed by third party.
3. Store to Store - A TO might be imported in the OMS system for a Shipment to be shipped and received from fulfillment locations both managed by OMS.

## API Spec

- The API for managing TO builds on the [createOrder](../oms/createOrder.md)
- The statusFlowId field will be used as the indicator to identify the Transfer Orders for different facility types, on the basis of which the TOs will be fulfilled and/or received in OMS.
- The service corresponding to this API is create#TransferOrder in oms component which is the application layer service to create TOs.
- The API will perform certain validations and call the ootb create#org.apache.ofbiz.order.order.OrderHeader to create TO in OMS.
- If TOs are being synced from external system like NetSuite, below payloads need to used as per the type of TO. 

### Sample payloads

1. Warehouse to Store
```json
{
   "payload": {
      "externalId": "TO0000001",
      "orderName": "TO0000001",
      "productStoreId": "STORE",
      "statusId": "ORDER_CREATED",
      "orderTypeId": "TRANSFER_ORDER",
      "orderDate": "2025-04-05",
      "statusFlowId": "TO_Receive_Only",
      "grandTotal": 0,
      "shipGroups": [
         {
            "shipmentMethodTypeId": "STANDARD",
            "carrierPartyId": "_NA_",
            "facilityId": "CENTRAL_WAREHOUSE",
            "items": [
               {
                  "externalId": "1",
                  "orderItemTypeId": "PRODUCT_ORDER_ITEM",
                  "quantity": 2,
                  "statusId": "ITEM_CREATED",
                  "unitListPrice": 0,
                  "unitPrice": 0,
                  "productId": "41192"
               },
               {
                  "externalId": "2",
                  "orderItemTypeId": "PRODUCT_ORDER_ITEM",
                  "quantity": 5,
                  "statusId": "ITEM_CREATED",
                  "unitListPrice": 0,
                  "unitPrice": 0,
                  "productId": "40920"
               },
               {
                  "externalId": "3",
                  "orderItemTypeId": "PRODUCT_ORDER_ITEM",
                  "quantity": 3,
                  "statusId": "ITEM_CREATED",
                  "unitListPrice": 0,
                  "unitPrice": 0,
                  "productId": "40812"
               }
            ],
            "orderFacilityId": "BROADWAY"
         }
      ],
      "entryDate": "2025-05-08T22:44:35-07:00",
      "originFacilityId": "CENTRAL_WAREHOUSE"
   }
}
```

2. Store to Warehouse
```json
{
    "payload": {
        "externalId": "TO0000002",
        "orderName": "TO0000002",
        "productStoreId": "STORE",
        "statusId": "ORDER_CREATED",
        "orderTypeId": "TRANSFER_ORDER",
        "orderDate": "2025-04-05",
        "statusFlowId": "TO_Fulfill_Only",
        "grandTotal": 0,
        "shipGroups": [
            {
                "shipmentMethodTypeId": "STANDARD",
                "carrierPartyId": "_NA_",
                "facilityId": "BROADWAY",
               "items": [
                  {
                     "externalId": "1",
                     "orderItemTypeId": "PRODUCT_ORDER_ITEM",
                     "quantity": 2,
                     "statusId": "ITEM_CREATED",
                     "unitListPrice": 0,
                     "unitPrice": 0,
                     "productId": "41192"
                  },
                  {
                     "externalId": "2",
                     "orderItemTypeId": "PRODUCT_ORDER_ITEM",
                     "quantity": 5,
                     "statusId": "ITEM_CREATED",
                     "unitListPrice": 0,
                     "unitPrice": 0,
                     "productId": "40920"
                  },
                  {
                     "externalId": "3",
                     "orderItemTypeId": "PRODUCT_ORDER_ITEM",
                     "quantity": 3,
                     "statusId": "ITEM_CREATED",
                     "unitListPrice": 0,
                     "unitPrice": 0,
                     "productId": "40812"
                  }
               ],
                "orderFacilityId": "CENTRAL_WAREHOUSE"
            }
        ],
        "entryDate": "2025-05-08T22:44:35-07:00",
        "originFacilityId": "BROADWAY"
    }
}
```

3. Store to Store
```json
{
    "payload": {
        "externalId": "TO0000003",
        "orderName": "TO0000003",
        "productStoreId": "STORE",
        "statusId": "ORDER_CREATED",
        "orderTypeId": "TRANSFER_ORDER",
        "orderDate": "2025-04-05",
        "statusFlowId": "TO_Fulfill_And_Receive",
        "grandTotal": 0,
        "shipGroups": [
            {
                "shipmentMethodTypeId": "STANDARD",
                "carrierPartyId": "_NA_",
                "facilityId": "BROADWAY",
                "items": [
                    {
                        "externalId": "1",
                        "orderItemTypeId": "PRODUCT_ORDER_ITEM",
                        "quantity": 2,
                        "statusId": "ITEM_CREATED",
                        "unitListPrice": 0,
                        "unitPrice": 0,
                        "productId": "41192"
                    },
                    {
                        "externalId": "2",
                        "orderItemTypeId": "PRODUCT_ORDER_ITEM",
                        "quantity": 5,
                        "statusId": "ITEM_CREATED",
                        "unitListPrice": 0,
                        "unitPrice": 0,
                        "productId": "40920"
                    },
                    {
                        "externalId": "3",
                        "orderItemTypeId": "PRODUCT_ORDER_ITEM",
                        "quantity": 3,
                        "statusId": "ITEM_CREATED",
                        "unitListPrice": 0,
                        "unitPrice": 0,
                        "productId": "40812"
                    }
                ],
                "orderFacilityId": "WEST_JORDAN"
            }
        ],
        "entryDate": "2025-05-08T22:44:35-07:00",
        "originFacilityId": "BROADWAY"
    }
}
```