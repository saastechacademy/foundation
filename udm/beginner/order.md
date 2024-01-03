### Summary

1. **OrderHeader**: Represents general details of an order such as type, status, and customer information. It's the primary entity for an order.

2. **OrderItem**: Details each item in the order, linked to `OrderHeader` by `orderId`. Contains product details, quantity, and price.

3. **OrderItemShipGroup**: Manages shipping aspects of an order, linked to `OrderHeader`. It can group multiple `OrderItem`s for shipping purposes.

4. **OrderAdjustment**: Used for price adjustments like discounts, taxes, or shipping charges. Linked to `OrderHeader`, `OrderItem`, or `OrderItemShipGroup`. Key fields include `OrderAdjustmentId`, `OrderAdjustmentTypeId`, `OrderId`, `OrderItemSeqId`, and `ShipGroupSeqId`.

### Relationships

- **OrderAdjustment to OrderHeader**: Via `OrderId`, linking adjustments to the specific order.
- **OrderAdjustment to OrderItem**: Through `OrderItemSeqId`, for item-specific adjustments.
- **OrderAdjustment to OrderItemShipGroup**: Via `ShipGroupSeqId`, for shipping-related adjustments.

### Example JSON Data

```json
{
  "OrderHeader": {
    "orderId": "10001",
    "orderDate": "2024-01-03",
    "orderStatus": "CREATED",
    "partyId": "C100",
    "grandTotal": 95.00
  },
  "OrderItems": [
    {
      "orderId": "10001",
      "orderItemSeqId": "00001",
      "productId": "P100",
      "quantity": 2,
      "unitPrice": 20.00
    },
    {
      "orderId": "10001",
      "orderItemSeqId": "00002",
      "productId": "P200",
      "quantity": 1,
      "unitPrice": 50.00
    }
  ],
  "OrderItemShipGroup": {
    "orderId": "10001",
    "shipGroupSeqId": "01",
    "shipmentMethodTypeId": "STANDARD"
  },
  "OrderAdjustment": [
    {
      "orderAdjustmentId": "ADJ1001",
      "orderAdjustmentTypeId": "SHIPPING_CHARGES",
      "orderId": "10001",
      "orderItemSeqId": null,
      "shipGroupSeqId": "01",
      "amount": 5.00
    }
  ]
}

```

This JSON example represents a sales order with two items and a shipping charge adjustment. It demonstrates the relationships between the different entities and how adjustments are applied within the OFBiz data model.