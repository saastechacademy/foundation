# Introduction to Order Data Model

This document provides an overview of the Order data model, focusing on its core entities - OrderHeader, OrderPart, OrderItem, and related entities. It describes the structure for handling purchase and sales orders, splitting them for shipping and handling, and tracking order statuses. Additionally, we provide sample JSON data for orders with multiple parts and items.

## Order Data Model Overview

Example: John Doe places an order with ABC Organization, which includes two parts: one item shipped from Warehouse A to Location 1, and another item shipped from Warehouse B to Location 2.

### Entities
#### 1. OrderHeader
- **Description**: Represents the main entity for an order. It can be either a `PURCHASE_ORDER` or a `SALES_ORDER`.
- **Key Attribute**: `orderId`
- **Example**: Let's create the relevant order headers one for a `PURCHASE_ORDER` and one for a `SALES_ORDER`.
```json
{
  "OrderHeader": [
    {
      "orderId": "ORD789",
      "statusId": "PARTIALLY_FULFILLED",
      "orderDate": "2024-09-19"
    },
    {
      "orderId": "ORD123",
      "statusId": "ORDER_PLACED",
      "orderDate": "2024-09-19"
    }
  ]
}
```

#### 2. OrderPart
- **Description**: A part of an order representing a specific shipment, delivery method, or shipping address. Each part can have a different customer or vendor if applicable.
- **Key Attributes**: `orderPartSeqId`, `orderId`
- **Example**: Let's create the relevant order parts for the order.
```json
{
  "OrderPart": [
    {
      "orderId": "ORD789",
      "orderPartSeqId": "00001",
      "customerPartyId": "PER123",
      "postalContactMechId": "10003",
      "statusId": "COMPLETED",
      "partTotal": 1364.99
    },
    {
      "orderId": "ORD789",
      "orderPartSeqId": "00002",
      "customerPartyId": "PER123",
      "postalContactMechId": "10003",
      "statusId": "PLACED",
      "partTotal": 1154.99

    },
    {
      "orderId": "ORD123",
      "orderPartSeqId": "00001",
      "vendorPartyId": "VEN456",
      "postalContactMechId": "10002",
      "telecomContactMechId": "10000",
      "statusId": "PLACED",
      "partTotal": 64999.50
    }
  ]
}
```
#### 3. Order Item
- **Description**: Represents individual items on the order, each associated with a single OrderPart.
- **Key Attributes**: `orderItemSeqId`, `orderId`
- **Example**: Let's create the relevant order items for the order parts.
```json
{
  "OrderItem": [
    {
      "orderId": "ORD789",
      "orderPartSeqId": "00001",
      "orderItemSeqId": "00001",
      "productId": "PROD20001",
      "quantity": 1,
      "unitPrice": 1299.99,
      "OrderItem": {
        "orderItemSeqId": "00003",
        "productId": "SALES_TAX",
        "unitPrice": 65.00
      }
    },
    {
      "orderId": "ORD789",
      "orderPartSeqId": "00002",
      "orderItemSeqId": "00002",
      "productId": "PROD10002",
      "quantity": 1,
      "unitPrice": 1099.99,
      "OrderItem": {
        "orderItemSeqId": "00004",
        "productId": "SALES_TAX",
        "unitPrice": 55.00
      }
    },
    {
      "orderId": "ORD123",
      "orderPartSeqId": "00001",
      "orderItemSeqId": "00001",
      "productId": "PROD20001",
      "quantity": 50,
      "unitPrice": 1299.99
    }
  ]
}
```

## Complete JSONs
### 1. Sales Order
```json
{
  "OrderHeader": {
    "orderId": "ORD789",
    "statusId": "PARTIALLY_FULFILLED",
    "orderDate": "2024-09-19",
    "OrderPart": [
      {
        "orderPartSeqId": "00001",
        "customerPartyId": "PER123",
        "postalContactMechId": "10003",
        "statusId": "COMPLETED",
        "partTotal": 1364.99,
        "OrderItem": {
          "orderItemSeqId": "00001",
          "productId": "PROD20001",
          "quantity": 1,
          "unitPrice": 1299.99,
          "OrderItem": {
            "orderItemSeqId": "00003",
            "productId": "SALES_TAX",
            "unitPrice": 65.00
          }
        }
      },
      {
        "orderPartSeqId": "00002",
        "customerPartyId": "PER123",
        "postalContactMechId": "10003",
        "statusId": "PLACED",
        "partTotal": 1154.99,
        "OrderItem": {
          "orderItemSeqId": "00002",
          "productId": "PROD10002",
          "quantity": 1,
          "unitPrice": 1099.99,
          "OrderItem": {
            "orderItemSeqId": "00004",
            "productId": "SALES_TAX",
            "unitPrice": 55.00
          }
        },
      }
    ]
  }
}
```


### 2. Purchase Order
```json
{
  "OrderHeader": { 
    "orderId": "ORD123",
    "statusId": "ORDER_PLACED",
    "orderDate": "2024-09-19",
    "OrderPart": {
      "orderPartSeqId": "00001",
      "vendorPartyId": "VEN456",
      "postalContactMechId": "10002",
      "telecomContactMechId": "10000",
      "statusId": "PART_PLACED",
      "partTotal": 64999.50,
      "OrderItem": {
        "orderItemSeqId": "00001",
        "productId": "PROD20001",
        "quantity": 50,
        "unitPrice": 1299.99
      }
    }
  }
}
```















#### 6. Invoice Item
- **Description**: Represents the billing details for a purchase order, including invoice items and amounts due.
- **Key Attributes**: invoiceId, statusId, invoiceDate, dueDate
- **Example**: Let's create the relevant invoice data for `PURCHASE_ORDER`.
```json
{
  "InvoiceItem" {
    "InvoiceId": "INV001",
    "invoiceItemSeqId": "00001",
    "productId": "PROD20001",
    "quantity": 50,
    "amount": 64999.50,
  }
}
```















# Order Entities

## Entities Overview

### 1. OrderHeader
- **Description**: Represents the general details of an order including type, status, and customer information. It is the primary entity for an order.
- **Key Fields**: orderId, orderDate, orderStatus, partyId, grandTotal.

### 2. OrderItem
- **Description**: Details each item in the order. It is linked to the OrderHeader by orderId and contains product details, quantity, and price.
- **Key Fields**: orderId, orderItemSeqId, productId, quantity, unitPrice.

### 3. OrderItemShipGroup
- **Description**: Manages shipping details for an order. It groups multiple OrderItems for shipping purposes and links to shipping information via contactMechId. Also links to the OrderHeader.
- **Key Fields**: orderId, shipGroupSeqId, shipmentMethodTypeId, facilityId, contactMechId.

### 4. ContactMech
- **Description**: A general-purpose entity for various contact mechanisms. In the context of shipping, it is used to reference a postal address.
- **Key Fields**: contactMechId, contactMechTypeId.

### 5. PostalAddress
- **Description**: Stores detailed postal address information. It is linked to ContactMech for address details.
- **Key Fields**: contactMechId, toName, attnName, address1, city, postalCode, countryGeoId.

### 6. OrderAdjustment
- **Description**: Handles adjustments to the order's pricing, including discounts, taxes, or shipping charges. Linked to OrderHeader, OrderItem, or OrderItemShipGroup.
- **Key Fields**: orderAdjustmentId, orderAdjustmentTypeId, orderId, orderItemSeqId, shipGroupSeqId, amount.

## Entity Relationships

- **OrderAdjustment to OrderHeader**: Linked via OrderId for associating adjustments to the specific order.
- **OrderAdjustment to OrderItem**: Through OrderItemSeqId for item-specific adjustments.
- **OrderAdjustment to OrderItemShipGroup**: Via ShipGroupSeqId for shipping-related adjustments.
- **OrderItemShipGroup to OrderHeader**: Linked via orderId, associating the shipping group with its order.
- **OrderItemShipGroup to ContactMech**: Connected through contactMechId for shipping address details.
- **PostalAddress to ContactMech**: Linked by contactMechId, providing detailed address information.

## JSON Data Example

```json
{
  "OrderHeader": {
    "orderId": "10001",
    "orderTypeId": "SALES_ORDER",
    "orderName": "SU#2770",
    "salesChannelEnumId": "WEB_SALES_CHANNEL",
    "orderDate": "2020-05-28 08:50:43",
    "entryDate": "2020-05-28 08:54:30.259",
    "orderStatus": "ORDER_CREATED",
    "productStoreId": "SU_STORE",
    "grandTotal": 95.00
  },
  "OrderItems": [
    {
      "orderId": "10001",
      "orderItemSeqId": "00001",
      "productId": "P100",
      "quantity": 2,
      "unitPrice": 20.00,
      "statusId": "ITEM_CREATED"  
    },
    {
      "orderId": "10001",
      "orderItemSeqId": "00002",
      "productId": "P200",
      "quantity": 1,
      "unitPrice": 50.00,
      "statusId": "ITEM_CREATED" 
    }
  ],
  "OrderItemShipGroup": {
    "orderId": "10001",
    "shipGroupSeqId": "01",
    "shipmentMethodTypeId": "STANDARD",
    "facilityId": "FAC100",
    "contactMechId": "CM100"
  },
  "orderContactMech": {
    "orderId": "10001",
    "contactMechId": "CM100",
    "contactMechPurposeTypeId": "POSTAL_ADDRESS"
  },
  "PostalAddress": {
    "contactMechId": "CM100",
    "toName": "Jhon M Doe",
    "address1": "123 Main St",
    "city": "New York",
    "postalCode": "12345",
    "countryGeoId": "USA"
  },
  "OrderAdjustment": [
    {
      "orderAdjustmentId": "ADJ1001",
      "orderAdjustmentTypeId": "SHIPPING_CHARGES",
      "orderId": "10001",
      "orderItemSeqId": null,
      "shipGroupSeqId": "001",
      "amount": 5.00,
      "createdDate": "2020-08-11 12:53:15.987"
    }
  ]
}
```