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

Populate origin postal address and telecom information in a Shipment entity based on the associated origin facilities.

*   Find a contact mechanism associated with the origin facility that has the purpose "PRIMARY_LOCATION" and set it as the shipment's `originContactMechId`.
*   Find a contact mechanism associated with the origin facility that has the purpose "PRIMARY_PHONE" and set it as the shipment's `originTelecomNumberId`.



**In essence:**

The `OrderItemShipGroup` acts as a bridge between the `OrderHeader` (the overall order) and the `Shipment` (the physical fulfillment of part or all of the order). It provides essential details about how a specific group of items within an order should be shipped, which directly informs the creation and management of the corresponding `Shipment`.

Let's outline the design for a service that creates `Shipment`, `ShipmentItem`, `ShipmentPackage`, `ShipmentRouteSegment`, `ShipmentPackageRouteSeg` and `OrderShipment` records based on a list of `OrderItem`s belonging to the same `OrderItemShipGroup`.

**Key attributes of the `ShipmentPackage` entity in OFBiz:**

The `ShipmentPackage` entity in the Shipment data model holds information about individual packages within a shipment. It captures details such as:

*   **Physical Characteristics:** Dimensions (length, width, height) and weight, along with their respective units of measurement.
*   **Packaging Type:** The type of box or container used for the package (`shipmentBoxTypeId`).
*   **Store Package-Level Information:** The `ShipmentPackage` entity is responsible for storing all the relevant details about a physical package within a shipment.
*   **Facilitate Rate Calculation:** The dimensions and weight stored in this entity are crucial for calculating accurate shipping rates from carrier APIs.



### **Service Name**

*   `createSalesOrderShipment`

### **Purpose**

*   Streamline the shipment creation process when all `OrderItem`s belong to a single `OrderItemShipGroup`.
*   Leverage the `OrderItem` and `OrderItemShipGroup` data to populate the necessary fields in the `Shipment`, `ShipmentItem`, `ShipmentPackage`, `ShipmentRouteSegment`, `ShipmentPackageRouteSeg` and `OrderShipment` entities.

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

5.  **Prepare ShipmentRouteSegment:**
    *   Extract relevant data from the `OrderItemShipGroup`:.

5.  **Prepare ShipmentPackage:**
    *   `weight`: Calculate OrderItemShipgroup Package Weight.
    *   `shipmentBoxTypeId`: `YOURPACKNG` The type of box or container used for the package.


6.  **Prepare Order Shipments:**
    *   Iterate through the `orderItems` list again.
    *   For each `OrderItem`:
        *   Extract `orderItemSeqId`.
        *   Create an `OrderShipment` map linking the `OrderItem` to the `Shipment`.

7.  **Return Success:**
    *   Return a success message with the created `shipmentId`.

### **Outputs**

*   `shipmentId`: The ID of the newly created `Shipment`.
*   `successMessage`: A message indicating successful creation.

### **Dependencies**

*   Entity services for creating `Shipment`, `ShipmentItem`, `ShipmentPackage`, `ShipmentRouteSegment`, `ShipmentPackageRouteSeg` and `OrderShipment`.

### **Assumptions**

*   All `OrderItem`s belong to the same `OrderItemShipGroup`.
*   The shipment type is "SALES_SHIPMENT."
*   The service handles the basic data preparation of shipment-related entities.


### Calculate OrderItemShipgroup Package Weight

Create a view entity that joins `OrderItem` and `Product` to efficiently retrieve product shipping weights for order items within the same ship group.

### **Example Code (Illustrative)**

```xml
<view-entity entity-name="OrderItemProductWeightView"
             package-name="org.apache.ofbiz.order.order"> 
    <member-entity entity-alias="OI" entity-name="OrderItem"/>
    <member-entity entity-alias="P" entity-name="Product"/>

    <alias-all entity-alias="OI"/>  
    <alias entity-alias="P" name="shippingWeight" field="shippingWeight"/>
    <alias entity-alias="P" name="productWeight" field="productWeight"/>

    <view-link entity-alias="OI" rel-entity-alias="P">
        <key-map field-name="productId"/>
    </view-link>
</view-entity>
```


**Explanation:**

*   **`view-entity`:** Defines the view entity named `OrderItemProductWeightView`.
*   **`member-entity`:** Specifies the base entities involved in the join: `OrderItem` and `Product`.
*   **`alias-all`:** Includes all attributes from `OrderItem` in the view.
*   **`alias`:** Selectively includes the `shippingWeight` and `productWeight` attributes from the `Product` entity.
*   **`view-link`:** Establishes the join condition:
    *   `OrderItem` is linked to `Product` based on `productId`.


### **Example Code (Illustrative)**

```java
// Assuming you have the 'orderId' and 'shipGroupSeqId'

EntityCondition condition = EntityCondition.makeCondition(
    EntityCondition.makeCondition("orderId", orderId),
    EntityCondition.makeCondition("shipGroupSeqId", shipGroupSeqId)
);

List<GenericValue> orderItems = EntityQuery.use(delegator)
    .from("OrderItemProductWeightView")
    .where(condition)
    .queryList();

BigDecimal totalWeight = BigDecimal.ZERO;
for (GenericValue orderItem : orderItems) {
    // ... (same weight calculation logic as in calcShipmentPackageTotalWeight)
    totalWeight = totalWeight.add(productWeight.multiply(quantity));
}
```





### **Example Code (Illustrative)**

```java
public static Map<String, Object> createSalesOrderShipment(DispatchContext dctx, Map<String, ? extends Object> context) {
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

***NOTE:***

*This service assumes following data exists in the system*

```
<ShipmentBoxType shipmentBoxTypeId="YOURPACKNG" description="Your Packaging" dimensionUomId="LEN_in" boxLength="15" boxWidth="10" boxHeight="5"/>
<CarrierShipmentMethBoxType partyId="_NA_" shipmentBoxTypeId="YOURPACKNG" shipmentMethodTypeId="NO_SHIPPING"/>
<CarrierShipmentMethBoxType partyId="_NA_" shipmentBoxTypeId="YOURPACKNG" shipmentMethodTypeId="STANDARD"/>

```