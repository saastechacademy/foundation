# `createSalesOrderShipment`

**Purpose:**

*   The service input is list of OrderItem to be shipped in one shipment, using the OrderItem data, it prepares the data needed to call [createShipment](createShipment.md).

**Inputs:**

*   `orderItems` : List of orderItems to be shipped.


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
        *   `Product`:
        *   `OrderStatus`:
        *   `OrderItemShipGroup`: Fulfillment details 
        *   `OrderItemShipGrpInvRes`:


**Key Customizations in HotWax Commerce**

*   **Ship Group:** The `shipGroupSeqId` 
*   **Customer Preferences:** `requestedDeliveryDate`, `requestedDeliveryTime`, and `requestedShipMethTypeId`.


The `OrderItemShipGroup` entity in Apache OFBiz represents a group of order items that will be shipped together. It's a way to organize items within an order for fulfillment purposes, especially when an order might have items that need to be shipped separately (e.g., from different warehouses or with different shipping methods).

**Key attributes of the OrderItemShipGroup entity:**

*   **Core OFBiz Attributes:**

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

*   **HotWax Commerce Extensions**

    *   `carrierAccountNumber`: to store the account number used with the carrier for this shipment group.
    *   `carrierService`: to capture more specific details about the carrier service chosen (e.g., "FedEx Ground," "UPS 2nd Day Air").
    *   `orderFacilityId`: information related to the facility from which the order is placed.


**How it relates to the Shipment entity:**

When creating a `Shipment` entity, many of its fields can be populated using information from the corresponding `OrderItemShipGroup`. This includes:

*   **shipmentTypeId**:  "SALES_SHIPMENT" for sales orders
*   **primaryOrderId**:  `OrderItemShipGroup`'s `orderId`
*   **primaryShipGroupSeqId**: `OrderItemShipGroup`'s `shipGroupSeqId`
*   **destinationContactMechId**:  `OrderItemShipGroup`'s `contactMechId`
*   **destinationTelecomNumberId**: `OrderItemShipGroup`'s `telecomContactMechId`
*   **carrierPartyId**: `OrderItemShipGroup`'s `carrierPartyId`
*   **shipmentMethodTypeId**: `OrderItemShipGroup`'s `shipmentMethodTypeId`
*   **handlingInstructions**: `OrderItemShipGroup`'s `shippingInstructions`
*   **estimatedShipDate**:  `OrderItemShipGroup`'s `estimatedShipDate`
*   **estimatedDeliveryDate**: `OrderItemShipGroup`'s `estimatedDeliveryDate`

Populate origin postal address and telecom information in a Shipment entity based on the associated origin facilities.

*   Find a contact mechanism associated with the origin facility that has the purpose "PRIMARY_LOCATION" and set it as the shipment's `originContactMechId`.
*   Find a contact mechanism associated with the origin facility that has the purpose "PRIMARY_PHONE" and set it as the shipment's `originTelecomNumberId`.



### Workflow:

The service that creates `Shipment`, `ShipmentItem`, `ShipmentPackage`, `ShipmentRouteSegment`, `ShipmentPackageRouteSeg` and `OrderShipment` records based on a list of `OrderItem`s belonging to the same `OrderItemShipGroup`.

**Key attributes of the `ShipmentPackage` entity in OFBiz:**

The `ShipmentPackage` entity in the Shipment data model holds information about individual packages within a shipment. It captures details such as:

*   **Physical Characteristics:** Dimensions (length, width, height) and weight, along with their respective units of measurement.
*   **Packaging Type:** The type of box or container used for the package (`shipmentBoxTypeId`).
*   **Store Package-Level Information:** The `ShipmentPackage` entity is responsible for storing all the relevant details about a physical package within a shipment.
*   **Facilitate Rate Calculation:** The dimensions and weight stored in this entity are crucial for calculating accurate shipping rates from carrier APIs.

### **Outputs**

*   `shipmentId`: The ID of the newly created `Shipment`.
*   `successMessage`: A message indicating successful creation.

### **Dependencies**

*   Entity services for creating `Shipment`, `ShipmentItem`, `ShipmentPackage`, `ShipmentRouteSegment`, `ShipmentPackageRouteSeg` and `OrderShipment`.

### **Assumptions**

*   All `OrderItem`s belong to the same `OrderItemShipGroup`.
*   The shipment type is "SALES_SHIPMENT."
