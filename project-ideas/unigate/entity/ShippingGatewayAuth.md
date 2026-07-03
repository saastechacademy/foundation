# `ShippingGatewayAuth`

## 1. Overview

The `ShippingGatewayAuth` record stores **tenant-specific authentication and endpoint information** for third-party shipping carriers such as FedEx, UPS, or ShipHawk.

---

## 2. Purpose

* Allows each tenant to configure one or more accounts with shipping gateways they intend to use.
* Enables the Unigate engine to route API requests to the appropriate gateway with tenant-specific credentials.
* Stores details such as authentication keys, mode (sandbox or production), and base URLs.

---

## 3. Entity: `ShippingGatewayAuth`

```xml
<entity entity-name="ShippingGatewayAuth" package="co.hotwax.unigate" use="configuration" cache="false">
    <field name="shippingGatewayAuthId" type="id" is-pk="true"/>
    <field name="tenantPartyId" type="id" not-null="true"/>
    <field name="shippingGatewayConfigId" type="id" not-null="true"/>

    <field name="modeEnumId" type="id"/>
    <field name="authTypeEnumId" type="id" not-null="true"/>
    <field name="baseUrl" type="text-medium" not-null="true"/>

    <field name="apiKey" type="text-medium" encrypt="true"/>
    <field name="clientId" type="text-medium"/>
    <field name="clientSecret" type="text-medium" encrypt="true"/>
    <field name="accessToken" type="text-very-long" encrypt="true"/>
    <field name="description" type="text-medium"/>

    <field name="lastUpdatedStamp" type="date-time"/>
    <field name="lastUpdatedTxStamp" type="date-time"/>
    <field name="createdStamp" type="date-time"/>
    <field name="createdTxStamp" type="date-time"/>

    <relationship type="one" related="co.hotwax.unigate.ShippingGatewayConfig">
        <key-map field-name="shippingGatewayConfigId"/>
    </relationship>
    <relationship type="one" related="co.hotwax.unigate.Party" short-alias="tenant">
        <key-map field-name="tenantPartyId"/>
    </relationship>
    <relationship type="one" title="Mode" related="moqui.basic.Enumeration" short-alias="modeEnum">
        <key-map field-name="modeEnumId"/>
    </relationship>
    <relationship type="one" title="AuthType" related="moqui.basic.Enumeration" short-alias="authTypeEnum">
        <key-map field-name="authTypeEnumId"/>
    </relationship>

    <index name="SHIP_GTWY_AUTH_TNT_CFG">
        <index-field name="tenantPartyId"/>
        <index-field name="shippingGatewayConfigId"/>
    </index>
</entity>
```

### Notes

* Credential fields use `encrypt="true"` so Moqui can store them encrypted at rest.

---

## 4. Setup Workflow

### Step-by-Step Instructions

1. **Tenant Manager Logs In**
   A privileged user (tenant admin or Unigate support) logs into the Unigate tenant manager interface.

2. **Navigate to Shipping Gateway Setup Page**
   Admin chooses to configure shipping gateway access for the tenant.

3. **Choose Gateway Type**
   Select from predefined options like ShipHawk, FedEx, UPS. These options are sourced from the `ShippingGatewayConfig` master entity.

4. **Enter Credentials**
   Provide base URL, auth type, and relevant credentials (API key, OAuth2 credentials, etc.).

5. **Save Configuration**
   A record is created in the `ShippingGatewayAuth` entity scoped to the `tenantPartyId`.

---

## 5. Example Use Case

A retailer (tenant) signs up and selects FedEx and ShipHawk for their shipments. The tenant admin configures:

* **FedEx:**

  * `modeEnumId`: `Sandbox`
  * `authTypeEnumId`: `ApiKey`
  * `baseUrl`: `https://api-sandbox.fedex.com`
  * `apiKey`: `abc123tenantfedexkey`

* **ShipHawk:**

  * `modeEnumId`: `Production`
  * `authTypeEnumId`: `ApiKey`
  * `baseUrl`: `https://api.shiphawk.com`
  * `apiKey`: `tenant-shiphawk-key`

These values are stored securely in `ShippingGatewayAuth` and used by the `get#OrderShippingRate` and `request#ShippingLabel` services.

---

## 6. Security Considerations

* Credential fields (e.g., `apiKey`, `clientSecret`) should be encrypted at rest using Moqui's field encryption capabilities.
* Access to view/edit credentials should be restricted via artifact authorization.

---

## 7. Internal Entity Relationship

* `tenantId` → references `Party` (Organization)
* `shippingGatewayConfigId` → references the predefined configuration for supported gateways
* Enum IDs (`modeEnumId`, `authTypeEnumId`) → map to values defined in `moqui.basic.Enumeration`

---

## 8. Admin Tools & Future Enhancements

* Admin UI for editing existing configurations
* Support for encrypted OAuth token refresh cycles (future)
* Multi-tenant validation tests (e.g., ping gateway)

---

## 9. Related Entities

| Entity Name             | Purpose                                    |
| ----------------------- | ------------------------------------------ |
| `Party`                 | Identifies the tenant                      |
| `ShippingGatewayConfig` | Identifies supported gateway integrations  |
| `Enumeration`           | Stores enum values like auth type and mode |

---

## 10. Developer Tips

* Cache sensitive fields minimally (`cache="false"` recommended).
* Never expose raw credentials via logs or API responses.
