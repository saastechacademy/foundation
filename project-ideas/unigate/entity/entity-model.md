## Entity Model UniShip Microservice

This document outlines the minimal set of entities required to support a multitenant shipping gateway microservice, using the Moqui framework without adopting the full Mantle UDM.

---

### Entities for Uniship Tenant Management

#### 1. `Party`
Represents any participant — in this context, your uniship tenant (retailer).
- `partyId` (PK)
- `partyTypeEnumId` (set to `PtyOrganization` for tenants)

#### 2. `Organization`
Extends `Party` when `partyTypeEnumId = 'PtyOrganization'`.
- `partyId` (PK, FK to Party)
- `organizationName`

#### 3. `PartyRole`
Assigns a role to a party for classification and access control.
- `partyId` (PK, FK to Party)
- `roleTypeId` (e.g., `UnishipTenant`)
- `fromDate` (PK)
- `thruDate`

---

### XML Definitions for Tenant Entities

Below are the XML definitions for the three core entities, modeled in alignment with Moqui’s UDM structure.

#### `Party`
```xml
<entity entity-name="Party" package="co.hotwax.uniship">
    <field name="partyId" type="id" is-pk="true"/>
    <field name="partyTypeEnumId" type="id"/>
    <field name="statusId" type="id"/>
    <field name="description" type="text-short"/>
    <field name="createdDate" type="date-time"/>

    <relationship type="one" title="PartyType" related="moqui.basic.Enumeration" short-alias="type">
        <key-map field-name="partyTypeEnumId"/>
    </relationship>
    <relationship type="one-nofk" related="co.hotwax.uniship.Organization" short-alias="organization"/>
    <relationship type="many" related="co.hotwax.uniship.PartyRole" short-alias="roles">
        <key-map field-name="partyId"/>
    </relationship>

    <seed-data>
        <moqui.basic.EnumerationType enumTypeId="PartyType" description="Party Type"/>
        <moqui.basic.Enumeration enumId="PtyOrganization" enumTypeId="PartyType" description="Organization"/>
        <moqui.basic.Enumeration enumId="PtyPerson" enumTypeId="PartyType" description="Person"/>
    </seed-data>

    <master name="default">
        <detail relationship="type"/>
        <detail relationship="organization"/>
        <detail relationship="roles"/>
    </master>
</entity>
```

#### `Organization`
```xml
<entity entity-name="Organization" package="co.hotwax.uniship">
    <field name="partyId" type="id" is-pk="true"/>
    <field name="organizationName" type="name"/>

    <relationship type="one" related="co.hotwax.uniship.Party">
        <key-map field-name="partyId"/>
    </relationship>
</entity>
```

#### `PartyRole`
```xml
<entity entity-name="PartyRole" package="co.hotwax.uniship">
    <field name="partyId" type="id" is-pk="true"/>
    <field name="roleTypeId" type="id" is-pk="true"/>
    <field name="fromDate" type="date-time" is-pk="true"/>
    <field name="thruDate" type="date-time"/>

    <relationship type="one" related="co.hotwax.uniship.Party"/>
    <relationship type="one" related="moqui.basic.Enumeration">
        <key-map field-name="roleTypeId"/>
    </relationship>

    <seed-data>
        <moqui.basic.EnumerationType enumTypeId="RoleType" description="Party Role Type"/>
        <moqui.basic.Enumeration enumId="UnishipTenant" enumTypeId="RoleType" description="Retailer Tenant"/>
    </seed-data>
</entity>
```

### Gateway Configuration Entities

#### `ShippingGatewayConfig`
> Defines core service configuration for each shipping gateway logic universally (e.g. FEDEX, UPS).

```xml
<entity entity-name="ShippingGatewayConfig" package="co.hotwax.unigate" use="configuration" cache="true">
    <field name="shippingGatewayConfigId" type="id" is-pk="true"/>
    <field name="description" type="text-medium"/>
    <field name="getOrderRateServiceName" type="text-medium"/>
    <field name="getShippingRatesBulkName" type="text-medium"/>
    <field name="getAutoPackageInfoName" type="text-medium"/>
    <field name="getRateServiceName" type="text-medium"/>
    <field name="requestLabelsServiceName" type="text-medium"/>
    <field name="refundLabelsServiceName" type="text-medium"/>
    <field name="trackLabelsServiceName" type="text-medium"/>
    <field name="validateAddressServiceName" type="text-medium"/>
</entity>
```

### [ShippingGatewayAuth](ShippingGatewayAuth.md) Entity

> **Note**: A nearly identical structure exists for `CommGatewayConfig` and `CommGatewayAuth` to map Communication/Email Gateways (like Klaviyo or SNS) to specific tenants.

### Notes on Unigate Tenant Entity Setup

- These three entities are sufficient to define and classify each tenant (retailer) in the system.
- You may define additional `RoleType` entries (e.g., `UnishipTenant`, `Carrier`) as needed.
