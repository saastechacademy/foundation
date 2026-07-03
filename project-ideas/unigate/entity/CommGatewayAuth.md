# `CommGatewayAuth`

## 1. Overview

The `CommGatewayAuth` record stores tenant-specific endpoint and credential data for communication gateways used by Unigate, such as Klaviyo and other future email or event providers.

---

## 2. Purpose

* Allows each tenant to configure one or more communication gateway accounts they intend to use.
* Enables the Unigate engine to route email or event API requests using tenant-specific credentials.
* Stores endpoint, authentication type, and credential values needed to call external communication providers.

---

## 3. Entity: `CommGatewayAuth`

```xml
<entity entity-name="CommGatewayAuth" package="co.hotwax.unigate" use="configuration" cache="false">
    <field name="commGatewayAuthId" type="id" is-pk="true"/>
    <field name="tenantPartyId" type="id" not-null="true"/>
    <field name="commGatewayConfigId" type="id" not-null="true"/>

    <field name="modeEnumId" type="id"/>
    <field name="authTypeEnumId" type="id" not-null="true"/>
    <field name="baseUrl" type="text-medium" not-null="true"/>
    <field name="authHeaderName" type="text-short"/>

    <field name="apiKey" type="text-medium" encrypt="true"/>
    <field name="username" type="text-medium"/>
    <field name="password" type="text-medium" encrypt="true"/>
    <field name="clientId" type="text-medium"/>
    <field name="clientSecret" type="text-medium" encrypt="true"/>
    <field name="accessToken" type="text-very-long" encrypt="true"/>
    <field name="refreshToken" type="text-very-long" encrypt="true"/>
    <field name="description" type="text-medium"/>
    <field name="extraConfigJson" type="text-very-long"/>

    <field name="lastUpdatedStamp" type="date-time"/>
    <field name="lastUpdatedTxStamp" type="date-time"/>
    <field name="createdStamp" type="date-time"/>
    <field name="createdTxStamp" type="date-time"/>

    <relationship type="one" related="co.hotwax.unigate.CommGatewayConfig">
        <key-map field-name="commGatewayConfigId"/>
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

    <index name="COMM_GTWY_AUTH_TNT_CFG">
        <index-field name="tenantPartyId"/>
        <index-field name="commGatewayConfigId"/>
    </index>
</entity>
```

### Notes

* Credential fields use `encrypt="true"` so Moqui can store them encrypted at rest.
* `authHeaderName` supports providers like Klaviyo that expect token values in a named HTTP header.
* `extraConfigJson` gives flexibility for provider-specific settings without changing the entity schema.

---

## 4. Setup Workflow

### Step-by-Step Instructions

1. **Tenant Manager Logs In**
   A privileged user, such as a tenant admin or Unigate support user, logs into the Unigate tenant manager interface.

2. **Navigate to Communication Gateway Setup Page**
   Admin chooses to configure communication gateway access for the tenant.

3. **Choose Gateway Type**
   Select from predefined options such as Klaviyo or another supported communication provider. These options are sourced from the `CommGatewayConfig` master entity.

4. **Enter Credentials**
   Provide base URL, auth type, and the relevant credentials for the provider, such as API key, bearer token, basic auth values, or OAuth client credentials.

5. **Save Configuration**
   A record is created in the `CommGatewayAuth` entity scoped to the `tenantPartyId`.

---

## 5. Example Use Cases

A retailer configures one communication provider for marketing events and another for transactional communication workflows.

* **Klaviyo:**

  * `modeEnumId`: `Production`
  * `authTypeEnumId`: `ApiKeyHeader`
  * `baseUrl`: `https://a.klaviyo.com/api`
  * `authHeaderName`: `Authorization`
  * `apiKey`: `Klaviyo-API-Key pk_live_xxxxx`

  These values support the current Klaviyo implementation, which needs `baseUrl`, `authHeaderName`, and `apiKey` to submit event payloads.

* **Mayur:**

  * `modeEnumId`: `Production`
  * `authTypeEnumId`: `NoAuth`
  * `baseUrl`: `https://example.mayur.internal/api`

  These values support the current Mayur implementation, which only needs the base URL to construct and send requests.

---

## 6. Security Considerations

* Credential fields such as `apiKey`, `password`, `clientSecret`, `accessToken`, and `refreshToken` should be encrypted at rest using Moqui field encryption.
* Access to view or edit communication gateway credentials should be restricted through artifact authorization.
* Raw secrets should never be exposed through logs, responses, or admin screens without masking.

---

## 7. Internal Entity Relationship

* `tenantPartyId` -> references `Party` and identifies the tenant owning the gateway credentials
* `commGatewayConfigId` -> references the predefined communication gateway definition
* Enum IDs (`modeEnumId`, `authTypeEnumId`) -> map to values defined in `moqui.basic.Enumeration`

---

## 8. Admin Tools & Future Enhancements

* Admin UI for editing existing communication gateway configurations
* Support for token refresh workflows using `refreshToken`
* Support for storing provider-specific metadata in `extraConfigJson`
* Validation or ping test to verify a tenant's gateway configuration before activation

---

## 9. Related Entities

| Entity Name | Purpose |
| --- | --- |
| `Party` | Identifies the tenant |
| `CommGatewayConfig` | Identifies supported communication gateway integrations |
| `Enumeration` | Stores enum values like auth type and mode |

---

## 10. Developer Tips

* Cache sensitive fields minimally; `cache="false"` is appropriate for this entity.
* Keep provider-specific request logic in services, and use `CommGatewayAuth` only for credential and endpoint data.
