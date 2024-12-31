
## `create#org.apache.ofbiz.order.order.OrderHeader` Service

The `create#Order` The service is responsible for saving the prepared data to the database.

This service creates data in following entities:
- **OrderHeader**: The main order record, storing information such as order date, customer details, and total amounts.
- **OrderIdentificaion**:
- **OrderRole**:
- **OrderContactMech**:
- **OrderPaymentPreference**: Information about the payment method used for the order.
- **OrderItems**: Line items representing the products or services being ordered, including quantity, price, and any adjustments.
- **OrderAdjustments**: Any promotions, discounts, or taxes applied to the order.
- **OrderItemShipGroup**: Shipment details, including the shipping method, carrier, and destination.
- **OrderItemGroup**:
- **OrderItemAssoc**:


```json
{
  "orderId": "ORD123456",
  "orderTypeId": "SALES_ORDER",
  "statusId": "ORDER_CREATED",
  "entryDate": "2024-12-29T10:30:00Z",
  "priority": "MEDIUM",
  "currencyUom": "USD",
  "grandTotal": 120.50,
  "orderName": "John Doe's Order",
  "orderRoles": [
    {
      "partyId": "CUST123",
      "roleTypeId": "CUSTOMER"
    },
    {
      "partyId": "EMP456",
      "roleTypeId": "SALES_REP"
    }
  ],
  "orderItems": [
    {
      "orderItemSeqId": "00001",
      "productId": "PROD001",
      "productName": "Wireless Mouse",
      "quantity": 1,
      "unitPrice": 25.00,
      "itemDescription": "Ergonomic wireless mouse with Bluetooth",
      "statusId": "ITEM_ORDERED",
      "shipGroupSeqId": "00001",
      "requestedDeliveryDate": "2024-12-31",
      "requestedDeliveryTime": "10:00:00",
      "requestedShipMethTypeId": "GROUND",
      "deliveryWindow": 2.0,
      "orderItemAttributes": [
        {
          "attrName": "color",
          "attrValue": "Black",
          "attrDescription": "Preferred color"
        },
        {
          "attrName": "warranty",
          "attrValue": "2 years",
          "attrDescription": "Warranty period"
        }
      ]
    },
    {
      "orderItemSeqId": "00002",
      "productId": "PROD002",
      "productName": "Keyboard",
      "quantity": 1,
      "unitPrice": 35.00,
      "itemDescription": "Mechanical keyboard with backlight",
      "statusId": "ITEM_ORDERED",
      "shipGroupSeqId": "00002",
      "requestedDeliveryDate": "2024-12-31",
      "requestedDeliveryTime": "15:00:00",
      "requestedShipMethTypeId": "EXPRESS",
      "deliveryWindow": 1.5,
      "orderItemAttributes": [
        {
          "attrName": "keyLayout",
          "attrValue": "QWERTY",
          "attrDescription": "Keyboard layout"
        }
      ]
    },
    {
      "orderItemSeqId": "00003",
      "productId": "PROD003",
      "productName": "Monitor",
      "quantity": 1,
      "unitPrice": 150.00,
      "itemDescription": "24-inch 1080p LED Monitor",
      "statusId": "ITEM_ORDERED",
      "shipGroupSeqId": "00001",
      "requestedDeliveryDate": "2024-12-31",
      "requestedDeliveryTime": "14:00:00",
      "requestedShipMethTypeId": "GROUND",
      "deliveryWindow": 3.0,
      "orderItemAttributes": []
    },
    {
      "orderItemSeqId": "00004",
      "productId": "PROD004",
      "productName": "USB-C Hub",
      "quantity": 1,
      "unitPrice": 50.00,
      "itemDescription": "7-port USB-C Hub with Power Delivery",
      "statusId": "ITEM_ORDERED",
      "shipGroupSeqId": "00002",
      "requestedDeliveryDate": "2024-12-31",
      "requestedDeliveryTime": "16:00:00",
      "requestedShipMethTypeId": "EXPRESS",
      "deliveryWindow": 1.0,
      "orderItemAttributes": [
        {
          "attrName": "portCount",
          "attrValue": "7",
          "attrDescription": "Number of ports"
        },
        {
          "attrName": "powerDelivery",
          "attrValue": "Yes",
          "attrDescription": "Supports Power Delivery"
        }
      ]
    }
  ],
  "orderAdjustments": [
    {
      "adjustmentType": "PROMOTION_ADJUSTMENT",
      "description": "10% Discount",
      "amount": -5.00
    },
    {
      "adjustmentType": "TAX_ADJUSTMENT",
      "description": "Sales Tax",
      "amount": 5.50
    }
  ],
  "orderPaymentPreferences": [
    {
      "paymentMethodTypeId": "CREDIT_CARD",
      "statusId": "PAYMENT_NOT_PROCESSED",
      "amount": 120.50
    }
  ],
  "orderItemShipGroups": [
    {
      "shipGroupSeqId": "00001",
      "carrierPartyId": "UPS",
      "shipmentMethodTypeId": "GROUND",
      "facilityId": "FAC123",
      "contactMechId": "ADD123",
      "isGift": false
    },
    {
      "shipGroupSeqId": "00002",
      "carrierPartyId": "FEDEX",
      "shipmentMethodTypeId": "EXPRESS",
      "facilityId": "FAC124",
      "contactMechId": "ADD124",
      "isGift": true
    }
  ],
  "orderItemGroups": [
    {
      "orderId": "ORD123456",
      "orderItemGroupSeqId": "GRP001",
      "groupName": "Brokering Group 1",
      "parentGroupSeqId": null,
      "orderItemGroupTypeId": "BROKERING_ITEM_GRP",
      "fulfillmentLocationId": "FAC123"
    }
  ],
  "orderItemGroupAssoc": [
    {
      "orderId": "ORD123456",
      "orderItemSeqId": "00001",
      "orderItemGroupSeqId": "GRP001"
    },
    {
      "orderId": "ORD123456",
      "orderItemSeqId": "00002",
      "orderItemGroupSeqId": "GRP001"
    }
  ]
}

```

You can adjust this JSON to meet your specific requirements by adding or removing entities and fields as needed.
