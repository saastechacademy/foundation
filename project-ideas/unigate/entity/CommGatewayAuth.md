# `CommGatewayAuth`

`CommGatewayAuth` stores a tenant's endpoint and credentials for an installed UniMail adapter.

## Current Entity

```xml
<entity entity-name="CommGatewayAuth" package="co.hotwax.unigate"
        use="configuration" cache="true">
    <field name="commGatewayAuthId" type="id" is-pk="true"/>
    <field name="commGatewayConfigId" type="id" not-null="true"/>
    <field name="tenantPartyId" type="id" not-null="true"/>
    <field name="modeEnumId" type="id"/>
    <field name="authTypeEnumId" type="id"/>
    <field name="baseUrl" type="text-medium" enable-audit-log="update"/>
    <field name="authHeaderName" type="text-short"/>
    <field name="username" type="text-medium" enable-audit-log="update"/>
    <field name="password" type="text-medium" encrypt="true"
           enable-audit-log="update"/>
    <field name="publicKey" type="text-medium" enable-audit-log="update"/>
    <field name="description" type="text-medium"/>
</entity>
```

## Fields

| Field | Required | Purpose |
| --- | --- | --- |
| `commGatewayAuthId` | Yes | Stable identifier passed in each email API request. |
| `commGatewayConfigId` | Yes | Selects an installed adapter and its service-name routing. |
| `tenantPartyId` | Yes | Tenant that owns the endpoint and credentials. |
| `modeEnumId` | No | Environment or operating mode, such as sandbox or production. |
| `authTypeEnumId` | No | Describes the configured authentication method. Adapter code must still apply it. |
| `baseUrl` | No | Provider or partner endpoint base URL. |
| `authHeaderName` | No | Header used when sending `publicKey`. |
| `username` | No | Username for adapters that use username/password authentication. |
| `password` | No | Encrypted password field. |
| `publicKey` | No | API key, bearer value, or other public credential consumed by the adapter. |
| `description` | No | Operator-facing label. |

## Relationship to `CommGatewayConfig`

`CommGatewayAuth` does not make an arbitrary URL callable on its own. Its `commGatewayConfigId` points to a `CommGatewayConfig` record whose fields contain deployed Moqui service names:

- `sendEmailServiceName`
- `createEventServiceName`
- `createFlowServiceName`
- `getFlowServiceName`

Switching a tenant between adapters that are already installed is a data change. Adding a new in-process provider implementation still requires its service and template to be deployed. External partners should use the [partner-owned endpoint model](../unimail/external-order-email-integration.md) after HotWax enables a provider-neutral outbound adapter.

## Example

```http
POST /rest/s1/unigate/commGatewayAuth
Content-Type: application/json
api_key: <tenant-api-key>
tenant_Id: <tenant-party-id>
```

```json
{
  "commGatewayAuthId": "PARTNER_TEST",
  "tenantPartyId": "ACME_001",
  "commGatewayConfigId": "EXTERNAL_WEBHOOK",
  "authTypeEnumId": "ApiKeyHeader",
  "modeEnumId": "Sandbox",
  "baseUrl": "https://partner.example.com/hotwax/events",
  "authHeaderName": "Authorization",
  "publicKey": "Bearer test-token",
  "description": "Partner test endpoint"
}
```

`EXTERNAL_WEBHOOK` is illustrative. Use the configuration ID that HotWax confirms is installed in the target environment.

## Security

- Treat `password`, `publicKey`, and any bearer value as secrets even when the entity field is not marked `encrypt="true"`.
- The current source encrypts `password`; it does not mark `publicKey` as encrypted.
- Do not include credentials in screenshots, logs, documentation examples, or support messages.
- Restrict entity reads and writes to authorized tenant or platform administrators.
- Use separate test and production records and rotate credentials independently.
- Audit records contain endpoint and credential-field updates; never place secret values in descriptions.

## Related Documents

- [UniMail overview](../unimail/readme.md)
- [External partner integration](../unimail/external-order-email-integration.md)
- [Tenant onboarding](../tenant-onboarding.md)
- [Entity model](./entity-model.md)
