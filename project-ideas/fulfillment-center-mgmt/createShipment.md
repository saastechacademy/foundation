## createShipment

**Sample shipment JSON representation**

```json
{
    "shipmentId": "10025",
    "shipmentTypeId": "SALES_SHIPMENT",
    "statusId": "SHIPMENT_INPUT",
    "primaryOrderId": "OR12345",
    "primaryShipGroupSeqId": "00001",
    "partyIdFrom": "COMPANY",
    "partyIdTo": "10001", 
    "originFacilityId": "WAREHOUSE_A",
    "destinationFacilityId": null,
    "originContactMechId": "12345",
    "originTelecomNumberId": "67890",
    "destinationContactMechId": "54321",
    "destinationTelecomNumberId": "09876",
    "estimatedShipCost": 15.99,
    "estimatedReadyDate": "2024-07-15 10:00:00",
    "estimatedShipDate": "2024-07-16 14:30:00",
    "estimatedArrivalDate": "2024-07-20 16:45:00",
    "shipmentItems": [ 
        {
            "shipmentItemSeqId": "001",
            "productId": "String - Product ID",
            "quantity": "Number - Quantity of the product"
        }
    ],
    "shipmentPackages": [
        {
             "shipmentPackageSeqId": "00001",
             "boxTypeId": "YOURPACKNG",
             "weight": 5.5,
             "weightUomId": "WT_lb",
             "dimensionUomId": "LEN_in",
             "boxLength": 12,
             "boxHeight": 8,
             "boxWidth": 10
         }
    ],
    "shipmentRouteSegments": [
        {
            "shipmentRouteSegmentId": "00001",
            "originFacilityId": "WAREHOUSE_A",
            "destinationFacilityId": "HUB_B",
            "estimatedArrival": "2024-07-17 09:00:00",
            "shipmentPackageRouteSegs": [
                {
                "shipmentPackageSeqId": "00001", 
                "trackingCode": "TRACK12345", 
                "boxNumber": "BOX001",
                "labelImage": null, 
                "labelIntlSignImage": null, 
                "labelHtml": "<html>...</html>", 
                "labelPrinted": "N", 
                "internationalInvoice": null, 
                "packageTransportCost": 5.0, 
                "packageServiceCost": 2.5, 
                "packageOtherCost": 0.5, 
                "codAmount": 0.0, 
                "insuredAmount": 50.0, 
                "currencyUomId": "USD",
                "labelImageUrl": "https://example.com/label10025.png",
                "internationalInvoiceUrl": null,
                "packagePickupPrn": "PICKUP123",
                "packagePickupDate": "2024-07-16 08:30:00",
                "gatewayMessage": "Package accepted by carrier",
                "gatewayStatus": "SUCCESS"
                }
            ]
        },
    ],
    "shipmentPackageContents":[
    {
      "shipmentItemSeqId": "001",
      "shipmentPackageSeqId": "00001",
      "quantity": 1
    }
    ],
    "orderShipments":[
        {
            "orderId": "OR12345",
            "orderItemSeqId": "001",
            "shipmentId": "10025",
            "shipmentItemSeqId": "001"
            "shipGroupSeqId": "001",
        }
    ]
}
```

