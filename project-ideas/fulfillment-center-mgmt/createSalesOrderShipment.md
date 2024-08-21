**Detailed Design**

**Purpose:**

*   Prepare Shipment data using the OrderItems data. The service takes list of OrderItem to be shipped in one shipment, using the OrderItem data, it prepares the data needed to call [createShipment](createShipment.md).

**Inputs:**

*   `orderItems` : List of orderItems to be shipped.


**Entities**

The `OrderItem` entity in HotWax Commerce is an extension of the standard `OrderItem` entity in Apache OFBiz. It represents a single item within a customer's order, capturing details about the product, quantity, pricing, and fulfillment status. HotWax Commerce has customized this entity to include additional fields and relationships that cater to their specific business needs.

**Key Attributes and Relationships**

*   **Core OFBiz Attributes:**
    *   `orderId` (id): Unique identifier of the order.
    *   `orderItemSeqId` (id): Sequential ID to distinguish multiple items within an order.
    *   `productId` (id): ID of the product being ordered.
    *   `quantity` (fixed-point): Quantity of the product ordered.
    *   `unitPrice` (currency-precise): Price per unit of the product.
    *   `statusId` (id): Current status of the order item (e.g., created, approved, shipped).

*   **HotWax Commerce Extensions:**
    *   `shipGroupSeqId` (id): Identifies the ship group the item belongs to within the order.
    *   `returnTillDate` (date-time): Last date for returning the item.
    *   `requestedDeliveryDate` (date), `requestedDeliveryTime` (time): Customer's requested delivery date and time.
    *   `requestedShipMethTypeId` (id): Customer's requested shipping method.
    *   `deliveryWindow` (floating-point): Delivery window in days or hours.

*   **Relationships:**
    *   **Core OFBiz Relationships:**
        *   `OrderHeader`: Connects the item to its parent order.
        *   `Product`: Links the item to the product details.
        *   `StatusItem`: Defines the possible statuses for the order item.
        *   `OrderItemShipGroup`: Fulfillment details 


**Key Customizations in HotWax Commerce**

*   **Ship Group:** The `shipGroupSeqId` allows for grouping items within an order for shipping purposes, enabling features like split shipments or handling different shipping methods/addresses within the same order.
*   **Customer Preferences:** `requestedDeliveryDate`, `requestedDeliveryTime`, and `requestedShipMethTypeId` capture customer preferences for delivery and shipping.


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

Let's outline the design for a service that creates `Shipment`, `ShipmentItem`, and `OrderShipment` records based on a list of `OrderItem`s belonging to the same `OrderItemShipGroup`.

### **Service Name**

*   `createSalesOrderShipment`

### **Purpose**

*   Streamline the shipment creation process when all `OrderItem`s belong to a single `OrderItemShipGroup`.
*   Leverage the `OrderItem` and `OrderItemShipGroup` data to populate the necessary fields in the `Shipment`, `ShipmentItem`, and `OrderShipment` entities.

### **Inputs**

*   `orderItems`: A list of `GenericValue` objects representing the `OrderItem`s to be included in the shipment.
*   `userLogin`: The `GenericValue` object representing the user initiating the service.

### **Logic**

1.  **Input Validation:**
    *   Check if `orderItems` is not empty.
    *   Ensure all `OrderItem`s have the same `orderId` and `shipGroupSeqId`.
    *   Retrieve the `OrderItemShipGroup` using the common `orderId` and `shipGroupSeqId`.

2.  **Prepare Shipment Data:**
    *   Extract relevant data from the first `OrderItem` and the `OrderItemShipGroup`:
        *   `orderId`
        *   `shipGroupSeqId`
        *   `shipmentMethodTypeId`
        *   `contactMechId` (shipping address)
        *   `telecomContactMechId` (shipping phone number)
        *   `shippingInstructions`
        *   `estimatedShipDate`
        *   `estimatedDeliveryDate`
        *   `originFacilityId` OrderItemShipGroup.facilityId

3.  **Prepare Shipment:**
    *   Prepare a new `Shipment` record using the prepared data.
    *   Set `shipmentTypeId` to "SALES_SHIPMENT" (assuming it's a sales order).
    *   Set an appropriate `statusId` (e.g., "SHIPMENT_INPUT").
    *   Set `originFacilityId` using OrderItemShipGroup.facilityId.

4.  **Prepare Shipment Items:**
    *   Iterate through the `orderItems` list.
    *   For each `OrderItem`:
        *   Extract `productId` and `quantity`.
        *   Create a `ShipmentItem` record map associated with the newly created `Shipment`.

5.  **Prepare Order Shipments:**
    *   Iterate through the `orderItems` list again.
    *   For each `OrderItem`:
        *   Extract `orderItemSeqId`.
        *   Create an `OrderShipment` map linking the `OrderItem` to the `Shipment`.

6.  **Return Success:**
    *   Return a success message with the created `shipmentId`.

### **Outputs**

*   `shipmentId`: The ID of the newly created `Shipment`.
*   `successMessage`: A message indicating successful creation.

### **Dependencies**

*   Entity services for creating `Shipment`, `ShipmentItem`, and `OrderShipment`.

### **Assumptions**

*   All `OrderItem`s belong to the same `OrderItemShipGroup`.
*   The shipment type is "SALES_SHIPMENT."
*   The service handles the basic data preparation of shipment-related entities.

### **Example Code (Illustrative)**

```java
public static Map<String, Object> createShipmentFromOrderItems(DispatchContext dctx, Map<String, ? extends Object> context) {
    Delegator delegator = dctx.getDelegator();
    LocalDispatcher dispatcher = dctx.getDispatcher();
    List<GenericValue> orderItems = (List<GenericValue>) context.get("orderItems");
    GenericValue userLogin = (GenericValue) context.get("userLogin");

    // Input validation (ensure all orderItems belong to the same ship group)
    // ...

    // Retrieve OrderItemShipGroup
    GenericValue orderItemShipGroup = // ... fetch using orderId and shipGroupSeqId

    // Prepare shipment data
    Map<String, Object> shipmentData = new HashMap<>();
    shipmentData.put("shipmentTypeId", "SALES_SHIPMENT");
    shipmentData.put("primaryOrderId", orderItems.get(0).getString("orderId"));
    shipmentData.put("primaryShipGroupSeqId", orderItems.get(0).getString("shipGroupSeqId"));
    // ... populate other fields from OrderItemShipGroup


    // Prepare ShipmentItems and OrderShipments
    for (GenericValue orderItem : orderItems) {
        // ... create ShipmentItem
        // ... create OrderShipment
    }

    return ServiceUtil.returnSuccess("Shipment created successfully with ID: " + shipmentId);
}
```
