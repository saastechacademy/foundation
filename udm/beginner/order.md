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

Next step: Expand upon the role of OrderItemShipGroup entity.


1. **OrderItemShipGroup**: Manages shipping details for an order. It groups multiple OrderItems for shipping purposes and links to shipping information via `contactMechId`.

2. **ContactMech**: A general-purpose entity for various contact mechanisms. In the context of shipping, it is used to reference a postal address.

3. **PostalAddress**: Stores detailed postal address information, such as street, city, postal code, and country. It is linked to `ContactMech` for address details.

4. **OrderAdjustment**: Handles adjustments to the order's pricing, including discounts, taxes, or shipping charges.

#### Entity Relationships

- **OrderItemShipGroup to OrderHeader**: Linked via `orderId`, associating the shipping group with its order.
- **OrderItemShipGroup to ContactMech**: Connected through `contactMechId` for shipping address details.
- **PostalAddress to ContactMech**: Linked by `contactMechId`, providing detailed address information.
- **OrderAdjustment to OrderHeader**: Linked via `OrderId`, associating adjustments with the specific order.
- **OrderAdjustment to OrderItemShipGroup**: Connected through `ShipGroupSeqId` for shipping-related adjustments.

### Updated Example JSON Data

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
    "shipmentMethodTypeId": "STANDARD",
    "facilityId": "FAC100",
    "contactMechId": "CM100"
  },
  "ContactMech": {
    "contactMechId": "CM100",
    "contactMechTypeId": "POSTAL_ADDRESS"
  },
  "PostalAddress": {
    "contactMechId": "CM100",
    "toName": "Customer Name",
    "attnName": "Receiving Department",
    "address1": "123 Main St",
    "city": "Metropolis",
    "postalCode": "12345",
    "countryGeoId": "USA"
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
