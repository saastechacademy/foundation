**Detailed Design**

**Purpose:**

*   Prepare Shipment data using the OrderItems data. The service takes list of OrderItem to be shipped in one shipment, using the OrderItem data, it prepares the data needed to call [createShipment](createShipment.md).

**Inputs:**

*   `orderItems` : List of orderItems to be shipped.


**Entities**

The `OrderItemShipGroup` entity in Apache OFBiz represents a group of order items that will be shipped together. It's a way to organize items within an order for fulfillment purposes, especially when an order might have items that need to be shipped separately (e.g., from different warehouses or with different shipping methods).

**Key attributes of the OrderItemShipGroup entity:**

*   **orderId** (id): The ID of the order to which this ship group belongs.
*   **shipGroupSeqId** (id): A sequential ID to distinguish multiple ship groups within the same order.
*   **shipmentMethodTypeId** (id): The type of shipment method chosen for this ship group (e.g., ground shipping, air shipping).
*   **carrierPartyId** (id): The ID of the carrier responsible for shipping this group of items.
*   **carrierRoleTypeId** (id): The role type of the carrier (e.g., CARRIER).
*   **contactMechId** (id): The contact mechanism ID for the shipping address associated with this ship group.
*   **telecomContactMechId** (id): The contact mechanism ID for the telephone number associated with this ship group.
*   **shippingInstructions** (long-varchar): Any special shipping instructions for this group of items.
*   **maySplit** (indicator): Indicates whether this ship group can be split into multiple shipments if necessary.
*   **giftMessage** (long-varchar): A gift message associated with this ship group, if applicable.
*   **isGift** (indicator): Indicates whether this ship group is a gift.
*   **carrierDeliveryZone** (short-varchar): The delivery zone specified by the carrier for this ship group.
*   **carrierRestrictionCodes** (short-varchar): Any restriction codes imposed by the carrier on this ship group.
*   **carrierRestrictionDesc** (very-long): A description of any carrier restrictions.
*   **estimatedShipDate** (date-time): The estimated ship date for this group of items.
*   **estimatedDeliveryDate** (date-time): The estimated delivery date for this group of items.

**How it relates to the Shipment entity:**

When creating a `Shipment` entity, many of its fields can be populated using information from the corresponding `OrderItemShipGroup`. This includes:

*   **shipmentTypeId**:  Usually set to "SALES_SHIPMENT" for sales orders
*   **primaryOrderId**:  Taken directly from the `OrderItemShipGroup`'s `orderId`
*   **primaryShipGroupSeqId**: Taken directly from the `OrderItemShipGroup`'s `shipGroupSeqId`
*   **destinationContactMechId**:  Taken from the `OrderItemShipGroup`'s `contactMechId`
*   **destinationTelecomNumberId**: Taken from the `OrderItemShipGroup`'s `telecomContactMechId`
*   **carrierPartyId**: Taken from the `OrderItemShipGroup`'s `carrierPartyId`
*   **shipmentMethodTypeId**: Taken from the `OrderItemShipGroup`'s `shipmentMethodTypeId`
*   **handlingInstructions**: Taken from the `OrderItemShipGroup`'s `shippingInstructions`
*   **estimatedShipDate**:  Can be initialized with the `OrderItemShipGroup`'s `estimatedShipDate`
*   **estimatedDeliveryDate**: Can be initialized with the `OrderItemShipGroup`'s `estimatedDeliveryDate`

**In essence:**

The `OrderItemShipGroup` acts as a bridge between the `OrderHeader` (the overall order) and the `Shipment` (the physical fulfillment of part or all of the order). It provides essential details about how a specific group of items within an order should be shipped, which directly informs the creation and management of the corresponding `Shipment`.


