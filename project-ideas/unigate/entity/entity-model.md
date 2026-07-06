## Entity Model — Unigate

This document outlines the entities used by the Unigate platform (UniMail and UniShip) to manage tenant identity, gateway configuration, and credential storage. The model is intentionally lightweight — it does not adopt the full Mantle UDM.

---

### Tenant Identity Entities

These entities represent tenant organizations and their roles in the system. The `Party` → `Organization` + `PartyRole` pattern is used for all tenants.

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
<entity entity-name="Party" package="co.hotwax.unigate">
    <field name="partyId" type="id" is-pk="true"/>
    <field name="partyTypeEnumId" type="id"/>
    <field name="pseudoId" type="text-short"/>
    <field name="comments" type="text-long"/>
    <field name="ownerPartyId" type="id"/>

    <relationship type="one" title="PartyType" related="moqui.basic.Enumeration" short-alias="type">
        <key-map field-name="partyTypeEnumId"/>
    </relationship>
    <relationship type="one-nofk" related="co.hotwax.unigate.Organization" short-alias="organization"/>
    <relationship type="one-nofk" related="co.hotwax.unigate.Person" short-alias="person"/>
    <relationship type="many" related="co.hotwax.unigate.PartyRole" short-alias="roles">
        <key-map field-name="partyId"/>
    </relationship>

    <seed-data>
        <moqui.basic.EnumerationType enumTypeId="PartyType" description="Party Type"/>
        <moqui.basic.Enumeration enumId="PtyOrganization" enumTypeId="PartyType" description="Organization"/>
        <moqui.basic.Enumeration enumId="PtyPerson" enumTypeId="PartyType" description="Person"/>
        <!-- Seed party for records with no explicit owner -->
        <co.hotwax.unigate.Party partyId="_NA_" partyTypeEnumId="PtyPerson"/>
    </seed-data>
</entity>
```

#### `Organization`
```xml
<entity entity-name="Organization" package="co.hotwax.unigate">
    <field name="partyId" type="id" is-pk="true"/>
    <field name="organizationName" type="text-medium"/>

    <relationship type="one" related="co.hotwax.unigate.Party">
        <key-map field-name="partyId"/>
    </relationship>

    <index name="PTY_ORG_NAME_IDX"><index-field name="organizationName"/></index>
</entity>
```

#### `PartyRole`
```xml
<entity entity-name="PartyRole" package="co.hotwax.unigate">
    <field name="partyId" type="id" is-pk="true"/>
    <field name="roleTypeId" type="id" is-pk="true"/>
    <field name="fromDate" type="date-time" is-pk="true"/>
    <field name="thruDate" type="date-time"/>

    <relationship type="one" related="co.hotwax.unigate.Party"/>
    <relationship type="one" related="moqui.basic.Enumeration">
        <key-map field-name="roleTypeId"/>
    </relationship>

    <seed-data>
        <moqui.basic.EnumerationType enumTypeId="RoleType" description="Party Role Type"/>
        <moqui.basic.Enumeration enumId="UnigateTenant" enumTypeId="RoleType" description="Unigate API Tenant"/>
    </seed-data>
</entity>
```

### Gateway Configuration Entities

#### `CommGatewayConfig`
> Defines the shared service-level configuration for each communication gateway, mapping abstract operations to concrete service implementations.

```xml
<entity entity-name="CommGatewayConfig" package="co.hotwax.unigate" use="configuration" cache="true">
    <field name="commGatewayConfigId" type="id" is-pk="true"/>
    <field name="description" type="text-medium"/>
    <field name="sendEmailServiceName" type="text-medium"/>
    <field name="createEventServiceName" type="text-medium"/>
    <field name="createFlowServiceName" type="text-medium"/>
    <field name="getFlowServiceName" type="text-medium"/>
</entity>
```

| Service Name Field | Operation |
|---|---|
| `sendEmailServiceName` | Routes `send#EmailCommunication` calls |
| `createEventServiceName` | Routes `create#WorkflowEvent` calls |
| `createFlowServiceName` | Routes `create#EmailFlow` calls |
| `getFlowServiceName` | Routes `get#EmailFlow` calls |

This entity is **read-heavy** and cached. Changes require a cache clear.

#### `ShippingGatewayConfig`
> Defines core service routing for each shipping carrier. See [ShippingGatewayConfig.md](ShippingGatewayConfig.md) for full documentation.

```xml
<entity entity-name="ShippingGatewayConfig" package="co.hotwax.unigate" use="configuration" cache="true">
    <field name="shippingGatewayConfigId" type="id" is-pk="true"/>
    <field name="description" type="text-medium"/>
    <field name="getRateServiceName" type="text-medium"/>
    <field name="requestLabelsServiceName" type="text-medium"/>
    <field name="refundLabelsServiceName" type="text-medium"/>
    <field name="trackLabelsServiceName" type="text-medium"/>
    <field name="validateAddressServiceName" type="text-medium"/>
</entity>
```

---

### Authentication and Credential Entities

- **[CommGatewayAuth](CommGatewayAuth.md)** — per-tenant credentials for email providers
- **[ShippingGatewayAuth](ShippingGatewayAuth.md)** — per-tenant credentials for shipping carriers

---

### Security View Entity

#### `UserLoginKeyAndParty`
A view entity defined in `UnigateViewEntities.xml` that joins `moqui.security.UserLoginKey` with `moqui.security.UserAccount`. Used exclusively by `TenantAuthFilter` to validate API key + tenant ID combinations in a single database query.

| Alias | Source Entity | Field |
|---|---|---|
| `loginKey` | `UserLoginKey` | Hashed API key |
| `userId` | `UserLoginKey` | User identifier |
| `fromDate` | `UserLoginKey` | Key validity start |
| `thruDate` | `UserLoginKey` | Key validity end |
| `partyId` | `UserAccount` | Tenant party ID |

#### `UserAccount` Extension
Unigate extends `moqui.security.UserAccount` with a `partyId` field that links Moqui's authentication system to Unigate's Party model. This extension is defined in `UnigateEntities.xml`.

---

### Deprecated Entity

#### `CommGatewayAuthOld` (table: `COMM_GATEWAY_AUTH_OLD`)
Legacy schema that linked communication gateway auth to `SystemMessageRemote`. Superseded by `CommGatewayAuth`. Data is migrated via `CommunicationServices.migrate#CommGatewayAuth`. The old records are **not deleted** during migration, allowing parallel operation until cutover is confirmed.

---

### Notes

- These entities are sufficient to classify and authenticate each tenant.
- Additional `RoleType` entries (e.g., `UnigateTenant`, `Carrier`) can be added as needed.
- The `_NA_` party (`partyId = '_NA_'`, type `PtyPerson`) is a seed record for records with no explicit owner.
