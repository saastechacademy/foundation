## Setting up a New Shipping Carrier in Apache OFBiz

This process involves creating and configuring entities to represent the carrier, its offered shipping methods, and their availability within a specific product store. 

### Entities and their Roles

1.  **`Party`**

    *   Represents any business partner, including shipping carriers.
    *   Key attributes:
        *   `partyId`: Unique identifier for the party
        *   `partyTypeId`:  Categorizes the party (e.g., "PARTY_GROUP" for companies, "PERSON" for individuals)

2.  **`ProductStore`**

    *   Represents an online or physical store where products are sold.
    *   Key attributes:
        *   `productStoreId`: Unique identifier for the store

3.  **`Facility`**

    *   Represents a physical location, like a warehouse or retail store, from which shipments originate.
    *   Key attributes:
        *   `facilityId`: Unique identifier for the facility

4.  **`FacilityParty`**

    *   Links a `Facility` to a `Party` and defines the role the party plays at that facility.
    *   Key attributes:
        *   `facilityId`
        *   `partyId`
        *   `roleTypeId` (e.g., "CARRIER")

5.  **`ShipmentMethodType`**

    *   Defines the general types of shipping methods (e.g., "GROUND," "AIR").
    *   Key attributes:
        *   `shipmentMethodTypeId`: Unique identifier
        *   `description`: Human-readable description

6.  **`CarrierShipmentMethod`**

    *   Associates a `Party` (carrier) with specific `ShipmentMethodType`s they offer.
    *   Key attributes:
        *   `shipmentMethodTypeId`
        *   `partyId`
        *   `roleTypeId` ("CARRIER")
        *   `carrierServiceCode`: Carrier-specific code for the service

7.  **`ProductStoreShipmentMeth`**

    *   Links a `ProductStore` to the `CarrierShipmentMethod`s it offers.
    *   Key attributes:
        *   `productStoreId`
        *   `shipmentMethodTypeId`
        *   `partyId`
        *   Additional attributes in HotWax for configuration (e.g., `deliveryDays`, `isShippingWeightRequired`, `isTrackingRequired`)

### Setup Process

1.  **Create Carrier Party:**
    *   Create a `Party` record with `partyTypeId` = "PARTY_GROUP."
    *   Create a corresponding `PartyGroup` record.
    *   Assign the "CARRIER" role to the party using `PartyRole`.
    *   *Example: The provided data creates "UPS" as a carrier party.*

2.  **Define Shipment Method Types (if new):**
    *   If the carrier offers new shipping methods not already defined, create `ShipmentMethodType` records for them.
    *   *Example: The data defines "GROUND," "STANDARD," and "EXPRESS" types.*

3.  **Link Carrier to Shipment Methods:**
    *   Create `CarrierShipmentMethod` records to associate the carrier (`partyId`) with the `shipmentMethodTypeId`s it offers.
    *   Set the `carrierServiceCode` for each method as provided by the carrier.
    *   In HotWax, also set the `deliveryDays` for each method.
    *   *Example: The data links "UPS" to the three shipment method types with specific service codes and sequence numbers.*

4.  **Enable Methods for Product Store:**
    *   Create `ProductStoreShipmentMeth` records to link the `productStoreId` to the desired `CarrierShipmentMethod`s.
    *   Configure additional HotWax attributes like `isShippingWeightRequired` and `isTrackingRequired` as needed.
    *   *Example: The data enables all three UPS methods for product store 9000, associating them with the "upsRateEstimate" service.*

5.  **Associate Carrier with Facilities (Optional):**
    *   If the carrier operates from specific facilities, create `FacilityParty` records to link them, setting `roleTypeId` to "CARRIER."
    *   This is important for the `doRateShopping` service to identify available carriers at the origin facility.

6. **Setup [CustomMethod](/udm/intermediate/CustomMethod.md)**

```
    <entity entity-name="ShipmentBoxType"
            package-name="org.apache.ofbiz.shipment.shipment"
            title="Shipment Box Type">
      <field name="shipmentBoxTypeId" type="id"></field>
      <field name="description" type="description"></field>
      <field name="dimensionUomId" type="id"></field>
      <field name="boxLength" type="fixed-point"></field>
      <field name="boxWidth" type="fixed-point"></field>
      <field name="boxHeight" type="fixed-point"></field>
      <field name="weightUomId" type="id"></field>
      <field name="boxWeight" type="fixed-point"></field>
      <prim-key field="shipmentBoxTypeId"/>
      <relation type="one" fk-name="SHMT_BXTP_DUOM" title="Dimension" rel-entity-name="Uom">
        <key-map field-name="dimensionUomId" rel-field-name="uomId"/>
      </relation>
      <relation type="one" fk-name="SHMT_BXTP_WUOM" title="Weight" rel-entity-name="Uom">
        <key-map field-name="weightUomId" rel-field-name="uomId"/>
      </relation>
    </entity>

    <entity entity-name="CarrierShipmentMethBoxType"
            package-name="co.hotwax.warehouse.packing"
            title="Entity contains Party, ShipmentBoxType and ShipmentMethodType" >
        <field name="partyId" type="id"/>
        <field name="shipmentBoxTypeId" type="id"/>
        <field name="shipmentMethodTypeId" type="id"/>
        <prim-key field="partyId"/>
        <prim-key field="shipmentBoxTypeId"/>
        <prim-key field="shipmentMethodTypeId"/>
        <relation type="one" fk-name="CARR_SHIPBOX_TYPE" rel-entity-name="ShipmentBoxType">
            <key-map field-name="shipmentBoxTypeId"/>
        </relation>
        <relation type="one" fk-name="CARR_PARTY" rel-entity-name="Party">
            <key-map field-name="partyId"/>
        </relation>
        <relation type="one" fk-name="CARR_SHIPMETH_TYPE" rel-entity-name="ShipmentMethodType">
            <key-map field-name="shipmentMethodTypeId"/>
        </relation>
    </entity>


```

**Using ShipmentRequest entity**

Retrieve the name of the service to be used for interacting with a specific carrier's API for a given shipment method type and request type (e.g., RATE_REQUEST, TRACKING, etc.).

```
    conditionList.add(EntityCondition.makeCondition("carrierPartyId", carrierPartyId));
    conditionList.add(EntityCondition.makeCondition("shipmentMethodTypeId", shipmentMethodTypeId));
    conditionList.add(EntityCondition.makeCondition("requestType", requestType));
    GenericValue shipmentRequest = EntityQuery.use(delegator).from("ShipmentRequest").where(conditionList).cache().queryFirst();
    carrierServiceName = shipmentRequest.getString("serviceName");

```

Sample code for calling service when you have its name

```
    try {
        if(UtilValidate.isNotEmpty(carrierServiceName)) {
            DispatchContext dctx = dispatcher.getDispatchContext();
            Map <String, Object> serviceCtx = dctx.getModelService(serviceName).makeValid(serviceFields, ModelService.IN_PARAM);
            serviceResp = dispatcher.runSync(serviceName, serviceCtx);
        }
    } catch (GenericServiceException e) {
        Debug.logError(e, MODULE);
    }
```