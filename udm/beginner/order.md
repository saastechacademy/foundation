### This assignment tests your ability to Model:
1. Order and order items
2. Order parties and contact mechanisms
3. Order adjustments
4. Order status and terms
5. Order Item Associations

Model order data such that businesses has information to answer many questions about orders; For instance:

1. When is the expected delivery time?
2. Who is responsible for paying for the order?
3. What is the price for each product that is ordered?
4. What people and organizations are involved in the order?
5. Who placed the order? To whom is the order being shipped?


### Tasks
1. Setup custom component, "ordermgmtsystem"
2. Setup Order and related entities defined in this document.
3. Build UI using Forms and Screens.
4. Demonstrate use of your application to manage sample order data. Prepare set of sample data based on your online shopping experience.
5. Add Entities and UI for managing Order contactmech, Order status, Order adjustments, Order payments.


# Introduction to Order Data Model

This document provides an overview of the Order data model, focusing on its core entities - OrderHeader, OrderPart, OrderItem, and related entities. It describes the structure for handling purchase and sales orders, splitting them for shipping and handling, and tracking order statuses. Additionally, we provide sample JSON data for orders with multiple parts and items.

## Order Data Model Overview

Example: John Doe places an order for two items with ABC Organization. ABC Organization also places an order for 50 new laptops.

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
      "orderDate": "2024-09-15"
    },
    {
      "orderId": "ORD123",
      "statusId": "CREATED",
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
      "statusId": "CREATED",
      "partTotal": 1154.99

    },
    {
      "orderId": "ORD123",
      "orderPartSeqId": "00001",
      "vendorPartyId": "VEN456",
      "postalContactMechId": "10002",
      "telecomContactMechId": "10000",
      "statusId": "CREATED",
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
        "statusId": "CREATED",
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
        }
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
    "statusId": "CREATED",
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