# Introduction to Shipment Data Model

This document provides an overview of the Shipment data model, focusing on its core entities - Shipment, ShipmentItem, ShipmentPackage, and ShipmentRouteSegment. It describes the structure for managing both incoming and outgoing shipments, handling route segments, and tracking shipment packages. Additionally, we provide sample JSON data for shipment creation.

## Shipment Data Model Overview

Example: John Doe orders a product from ABC Organization. The order is split into two packages and shipped via ground transport, with tracking for both packages and costs associated with each route segment.

### Entities
#### 1. Shipment
- **Description**: Represents the overall shipment, tracking details such as the type of shipment, origin, destination, status, and costs.
- **Key Attribute**: `shipmentId`
- **Example**: Let's create a shipment record for an outgoing sales order.

```json
{
  "Shipment": {
    "shipmentId": "SHIP001",
    "shipmentTypeEnumId": "SALES_SHIPMENT",
    "fromPartyId": "ORG456",
    "toPartyId": "PER123",
    "estimatedShipDate": "2024-09-16",
    "statusId": "PACKED",
    "estimatedShipCost": 15.00,
    "costUomId": "USD",
    "binLocationNumber": 10
  }
}
```

#### 2. ShipmentItem
- **Description**: Represents the items in a shipment, detailing the product and quantity being shipped.
- **Key Attributes**: `shipmentItemSeqId`, `productId`
- **Example**: Let's create shipment items for the shipment.

```json
{
  "ShipmentItem": {
    "shipmentId": "SHIP001",
    "productId": "PROD20001",
    "quantity": 1
  }
}
```

#### 3. ShipmentItemSource

- **Description**: Tracks the relationship between shipment items and their associated orders or returns.
- **Key Attributes**: shipmentItemSeqId, orderId, orderItemSeqId
- **Example**: Let's link the shipment items to their corresponding order items.

```json
{
  "ShipmentItemSource": {
    "shipmentId": "SHIP001",
    "productId": "PROD20001",
    "quantity": 1,
    "orderId": "ORD789",
    "orderItemSeqId": "00001",
    "statusId": "PACKED"
  }
}
```

#### 4. ShipmentPackage

- **Description**: Represents the packaging of items in a shipment. Each package may contain one or more shipment items.
- **Key Attributes**: `shipmentId`, `shipmentPackageSeqId`
- **Example**: Let's create shipment packages for the shipment.

```json
{
  "ShipmentPackage": {
    "shipmentId": "SHIP001",
    "shipmentPackageSeqId": "00001",
    "weight": 5,
    "weightUomId": "LBS"
  }
}
```

#### 5. ShipmentPackageContent

- **Description**: Tracks the contents of each package, associating each shipment item with the package it is contained in.
- **Key Attributes**: `shipmentId`, `shipmentPackageSeqId`, `productId`
- **Example**: Let's track which items are in each package.

```json
{
  "ShipmentPackageContent": {
    "shipmentId": "SHIP001",
    "shipmentPackageSeqId": "00001",
    "productId": "PROD20001",
    "quantity": "1"
  }
}
```

#### 6. ShipmentRouteSegment

- **Description**: Represents the route of the shipment, detailing the carrier, origin, and destination.
- **Key Attributes**: `shipmentId`, `shipmentRouteSegmentId`
- **Example**: Let's create a route segment for the shipment.

```json
{
  "ShipmentRouteSegment": {
    "shipmentId": "SHIP001",
    "shipmentRouteSegmentId": "SEG001",
    "carrierPartyId": "CARRIER001",
    "shipmentMethodEnumId": "GROUND",
    "originPostalContactMechId": "LOC001",
    "destPostalContactMechId": "LOC002"
  }
}
```

#### 7. ShipmentPackageRouteSeg

- **Description**: Represents the route of the shipment, detailing the carrier, origin, and destination.
- **Key Attributes**: `shipmentId`, `shipmentRouteSegmentId`, `shipmentRouteSegmentSeqId`
- **Example**: Let's create a route segment for the shipment.

```json
{
  "ShipmentPackageRouteSeg": {
    "shipmentId": "SHIP001",
    "shipmentRouteSegmentId": "",
    "shipmentRouteSegmentSeqId": "",
    "trackingCode": "4455667788",
    "labelImage": "/images/shippingLabel/4455667788.jpeg",
    "labelPrinted": "PRINTED"
  }
}
```

## Complete JSON
### Complete Shipment with Route Segments and Packages

```json
{
  "Shipment": {
    "shipmentId": "SHIP001",
    "shipmentTypeEnumId": "SALES_SHIPMENT",
    "fromPartyId": "ORG456",
    "toPartyId": "PER123",
    "estimatedShipDate": "2024-09-16",
    "statusId": "PACKED",
    "estimatedShipCost": 15.00,
    "costUomId": "USD",
    "binLocationNumber": 10,
    "ShipmentItem": {
      "productId": "PROD20001",
      "quantity": 1
    },
    "ShipmentRouteSegment": {
      "shipmentRouteSegmentId": "SEG001",
      "carrierPartyId": "CARRIER001",
      "shipmentMethodEnumId": "GROUND",
      "originPostalContactMechId": "LOC001",
      "destPostalContactMechId": "LOC002",
      "ShipmentPackage": {
        "shipmentPackageSeqId": "00001",
        "weight": 5,
        "weightUomId": "LBS",
        "ShipmentPackageContent": {
          "productId": "PROD20001",
          "quantity": "1"
        },
        "ShipmentPackageRouteSeg": {
          "shipmentRouteSegmentSeqId": "RTSEG001",
          "trackingCode": "4455667788",
          "labelImage": "/images/shippingLabel/4455667788.jpeg",
          "labelPrinted": "PRINTED"
        }
      }
    }
  }
}
```