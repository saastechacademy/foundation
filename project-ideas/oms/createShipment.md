## create#org.apache.ofbiz.shipment.shipment.Shipment

### POS orders are simple case, 
* POS sales orders are created, for the order, Shipment is created in the completed status. 
* The Picking and Packaging process is not required, in such scenario, the input shipment map will not have `shipmentPackages`,`shipmentPackageContents`, `shipmentRouteSegments`, `shipmentPackageRouteSegs`


### Sample Sales Order shipment JSON payload**
```json
{
  "originFacilityId": "BROADWAY",
  "carrierPartyId": "_NA_",
  "shipmentMethodTypeId": "STANDARD",
  "originContactMechId": "10000",
  "originTelecomNumberId": null,
  "destinationContactMechId": "10423",
  "destinationTelecomNumberId": null,
  "handlingInstructions": null,
  "estimatedShipDate": null,
  "estimatedDeliveryDate": null,
  "createdDate": "2025-03-26T01:32:53.484",
  "shipmentTypeId": "SALES_SHIPMENT",
  "statusId": "SHIPMENT_APPROVED",
  "primaryOrderId": "4",
  "primaryShipGroupSeqId": "00002",
  "partyIdTo": "10092",
  "partyIdFrom": "COMPANY",
  "routeSegments": [
    {
      "originFacilityId": "BROADWAY",
      "carrierPartyId": "_NA_",
      "shipmentMethodTypeId": "STANDARD",
      "originContactMechId": "10000",
      "originTelecomNumberId": null,
      "carrierService": null,
      "destContactMechId": "10423",
      "destTelecomNumberId": null,
      "carrierServiceStatusId": "SHRSCS_NOT_STARTED",
      "isTrackingRequired": "N",
      "billingWeight": 0.6614,
      "billingWeightUomId": "WT_lb",
      "packages": [
        {
          "shipmentBoxTypeId": "YOURPACKNG",
          "weight": 0.6614,
          "packageName": "A",
          "dateCreated": "2025-03-26T01:32:53.51",
          "boxLength": 15,
          "boxHeight": 5,
          "boxWidth": 10,
          "dimensionUomId": "LEN_in",
          "weightUomId": "WT_lb",
          "packageRouteSegs": [{}],
          "shipmentItems": [
            {
              "productId": "10003",
              "quantity": 1,
              "packageContents": {
                "quantity": 1
              }
            },
            {
              "productId": "10004",
              "quantity": 1,
              "packageContents": {
                "quantity": 1
              }
            }
          ]
        }
      ]
    }
  ],
  "status": [
    {
      "statusId": "SHIPMENT_APPROVED",
      "statusDate": "2025-03-26T01:32:53.512",
      "changeByUserLoginId": "hotwax.user"
    }
  ]
}
```
#### OrderShipment 
- For every item in the Shipment, use create#org.apache.ofbiz.order.order.OrderShipment to create OrderShipment record.
- This should be done separately in the code and not via Shipment payload (no relationship to be added in ShipmentItem) as Shipment and Order are 2 separate
services and OrderShipment is like an integration entity to store the order and shipment associations.


