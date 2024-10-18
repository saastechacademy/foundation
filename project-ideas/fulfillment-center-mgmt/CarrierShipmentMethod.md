### CarrierShipmentMethod in Apache OFBiz

*   **Purpose:** The `CarrierShipmentMethod` entity in Apache OFBiz serves as a bridge between carriers (represented as `Party` entities with the role "CARRIER") and the shipping methods they offer (`ShipmentMethodType` entities). It allows the system to define and manage the specific shipping services that each carrier provides.

*   **Key Attributes:**
    *   `shipmentMethodTypeId`: The ID of the general shipment method type (e.g., "GROUND," "AIR").
    *   `partyId`: The ID of the carrier party.
    *   `roleTypeId`: The role type of the carrier, typically "CARRIER."
    *   `sequenceNumber`: A numeric value to define the order or priority of this method for the carrier.
    *   `carrierServiceCode`: A code specific to the carrier that identifies this particular service.

*   **Relationships:**
    *   The entity has a one-to-one relationship with `ShipmentMethodType` through the `shipmentMethodTypeId` foreign key.
    *   It also has a one-to-one relationship with `Party` (the carrier) through the `partyId` foreign key.
    *   Additionally, it has a one-to-one relationship with `PartyRole` to further specify the carrier's role (usually "CARRIER") using both `partyId` and `roleTypeId`.

### HotWax Commerce Custom Extension

HotWax Commerce extends the `CarrierShipmentMethod` entity by adding a new field:

*   `deliveryDays`: A numeric field to store the estimated number of days it takes for this shipping method to deliver a shipment.

### Significance of the Extension

This extension enhances the `CarrierShipmentMethod` entity by incorporating crucial information about the expected delivery time for each shipping method offered by a carrier. This information is valuable for:

*   **Rate Shopping and Selection:** During rate shopping, the system can use `deliveryDays` to filter out shipping methods that don't meet the desired Service Level Agreement (SLA) or delivery timeframe. This is evident in the `doRateShopping` service where the `deliveryDays` field is used to filter out shipping methods that don't meet the SLA defined by the default method.
*   **Customer Communication:** The estimated delivery time can be communicated to the customer, setting clear expectations and improving transparency.
*   **Order Fulfillment Planning:** The system can use `deliveryDays` to plan and optimize the fulfillment process, ensuring timely delivery of shipments.

### Example

Consider a scenario where a customer wants their order delivered within 3 days. During rate shopping, the system can query `CarrierShipmentMethod` entities and filter them based on the `deliveryDays` field to only consider methods that can fulfill this requirement.

### In conclusion

The HotWax Commerce extension to the `CarrierShipmentMethod` entity by adding the `deliveryDays` field provides valuable information about shipping method delivery times, enabling better decision-making during rate shopping, improved customer communication, and optimized order fulfillment planning.