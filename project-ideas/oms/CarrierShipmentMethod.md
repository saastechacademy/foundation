### CarrierShipmentMethod in Apache OFBiz

*   **Purpose:** The `CarrierShipmentMethod` entity connects carriers (`Party` in the role "CARRIER") and the shipping methods they offer (`ShipmentMethodType` entities). It allows the system to define and manage the specific shipping services that each carrier provides.

*   **Key Attributes:**
    *   `shipmentMethodTypeId`: The ID of the general shipment method type (e.g., "GROUND," "AIR").
    *   `partyId`: The ID of the carrier party.
    *   `roleTypeId`: The role type of the carrier, typically "CARRIER."
    *   `sequenceNumber`: A numeric value to define the order or priority of this method for the carrier.
    *   `carrierServiceCode`: A code specific to the carrier that identifies this particular service.

*   **Relationships:**
    *   `ShipmentMethodType` the `shipmentMethodTypeId` foreign key.
    *   `Party` (the carrier) the `partyId` foreign key.
    *   `PartyRole` carrier's role ("CARRIER") using both `partyId` and `roleTypeId`.

### HotWax Commerce Custom Extension

HotWax Commerce extends the `CarrierShipmentMethod` entity by adding a new field:

*   `deliveryDays`: A numeric field to store the estimated number of days it takes for this shipping method to deliver a shipment.

### Significance of the Extension

*   **Rate Shopping and Selection:** Use `deliveryDays` to filter out shipping methods that don't meet the desired Service Level Agreement (SLA).
