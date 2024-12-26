The **ProductStoreShipmentMeth** entity is link between a **ProductStore** and the shipping methods it offers to customers.

**Key attributes**

*   productStoreShipMethId: A unique identifier for this specific product store shipment method record
*   productStoreId: The ID of the product store
*   shipmentMethodTypeId: The ID of the general shipment method type (e.g., "GROUND," "AIR")
*   partyId: The ID of the carrier party associated with this method (if applicable)
*   roleTypeId: The role type of the carrier, typically "CARRIER"
*   minWeight: The minimum weight for which this method is applicable
*   maxWeight: The maximum weight for which this method is applicable
*   minSize: The minimum size for which this method is applicable
*   maxSize: The maximum size for which this method is applicable
*   minTotal: The minimum order total for which this method is applicable
*   maxTotal: The maximum order total for which this method is applicable
*   allowUspsAddr: A flag indicating whether this method allows USPS addresses
*   requireUspsAddr: A flag indicating whether this method requires USPS addresses
*   allowCompanyAddr: A flag indicating whether this method allows company addresses
*   requireCompanyAddr: A flag indicating whether this method requires company addresses
*   includeNoChargeItems: A flag indicating whether to include items with no charge in the calculation
*   includeFeatureGroup: A feature group ID that this method might be associated with
*   serviceName: The name of the service to be used for this method (if applicable)
*   configProps: Configuration properties for this method
*   shipmentCustomMethodId: The ID of the custom shipping method (if applicable)

**Relationships**

*   The entity has a many-to-one relationship with `ProductStore` through the `productStoreId` foreign key
*   It has a many-to-one relationship with `ShipmentMethodType` through the `shipmentMethodTypeId` foreign key
*   It also has an optional many-to-one relationship with `CarrierShipmentMethod` through `shipmentMethodTypeId` and `partyId`, allowing the association of specific carriers with the shipping methods offered by the store
*   It has an optional many-to-one relationship with `CustomMethod` through the `shipmentCustomMethodId` foreign key

**How it is used**

The `ProductStoreShipmentMeth` entity acts as a bridge between a product store and the shipping methods it offers, allowing each store to define and configure the specific shipping options available for its products.


The rate shopping process, this entity is queried to retrieve a list of configured shipping methods for the given `productStoreId`, `partyId` (carrier), and a set of `shipmentMethodTypeIds` configured for the carrier in [CarrierShipmentMethod](CarrierShipmentMethod.md). 

Get shipping rates from the Carrier party for the ShipmentMethodTypes configured on the ProductStore and meet the deliveryDays/SLA criteria. 

Implement REST Resources for managing ProductStoreShipmentMeth. 
