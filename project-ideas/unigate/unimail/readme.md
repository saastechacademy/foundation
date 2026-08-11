# UniMail — Uniform Email Gateway

UniMail is the email side of Unigate. It gives callers a single API surface for sending transactional emails and tracking lifecycle events, regardless of which installed email provider the tenant has configured. Switching between installed adapters is database configuration. Adding a new in-process adapter still requires provider service code and a Unigate deployment.

External partners use a different model: they host an HTTPS receiver while HotWax configures a provider-neutral outbound adapter. See [External Partner Integration for Order Email Events](./external-order-email-integration.md).

---

## How Routing Works

Every UniMail API call carries a `commGatewayAuthId`. `CommunicationServices` uses this to:

1. Look up the `CommGatewayAuth` record (tenant credentials + endpoint)
2. Follow its `commGatewayConfigId` to `CommGatewayConfig` (which provider)
3. Read the relevant `*ServiceName` field to get the fully-qualified Moqui service name
4. Call that service dynamically, passing the full request context through

This means the routing layer has zero knowledge of individual providers. All provider logic lives in the implementation service.

```mermaid
sequenceDiagram
    participant OMS as OMS / Caller
    participant Filter as TenantAuthFilter
    participant Router as CommunicationServices
    participant Impl as MayurServices
    participant API as Mayur API

    OMS->>Filter: POST /communication/email\n api_key + tenant_Id headers
    Filter->>Filter: hash api_key, query UserLoginKeyAndParty
    Filter-->>OMS: 401 if invalid
    Filter->>Router: set tenantPartyId, pass request

    Router->>Router: find CommGatewayAuth by commGatewayAuthId
    Router->>Router: find CommGatewayConfig → sendEmailServiceName
    Router->>Impl: dynamic service-call(sendEmailServiceName, full context)

    Impl->>Impl: load FreeMarker template
    Impl->>Impl: render template with messageData
    Impl->>Impl: look up emailType → endpoint (relatedEnumId)
    Impl->>API: POST JSON with retry(2, 4)
    API-->>Impl: HTTP response
    Impl-->>Router: statusCode + response
    Router-->>OMS: response
```

---

## Entities

UniMail uses the shared Unigate tenant identity entities (`Party`, `Organization`, `PartyRole`) plus two of its own configuration entities:

### `CommGatewayConfig`

Defines which services handle each abstract operation for a given provider. One record per provider, shared across all tenants. See the [Entity Model documentation](../entity/entity-model.md) for full configuration details.

### `CommGatewayAuth`

Per-tenant credential and endpoint data for a specific provider. One record per tenant+provider combination.
See the [CommGatewayAuth entity doc](../entity/CommGatewayAuth.md) for the current field list and setup workflow.

---

## APIs

### `POST /rest/s1/unigate/communication/email` — Send an Email

Routes to `CommunicationServices.send#EmailCommunication`, which delegates to the provider's `sendEmailServiceName`.

**Required headers:** `api_key`, `tenant_Id`

See the [send#EmailCommunication](./services/send-email-communication.md) service documentation for detailed request and response payload schemas.

**Error responses:**

| Condition | Response |
|---|---|
| Missing/invalid `api_key` or `tenant_Id` | `401 Unauthorized` |
| `commGatewayAuthId` not found | `error=true`, message: "No valid gateway auth config found for tenant" |
| `CommGatewayConfig` not found | `error=true`, message: "Email gateway configuration not found" |
| `sendEmailServiceName` not set on config | `error=true`, message: "Gateway config is missing sendEmailServiceName service name" |

---

### `POST /rest/s1/unigate/communication/flow` — Create an Email Flow

Routes to `CommunicationServices.create#EmailFlow`, which delegates to `createFlowServiceName`. See the [services directory](./services/) for detailed explanations of all email APIs.

---

## Related Documents

- [CommGatewayAuth](../entity/CommGatewayAuth.md) — credential entity reference
- [External Partner Integration](./external-order-email-integration.md) — partner-owned receiver and order event contract
- [Add In-Process Email Gateway](./add-email-gateway.md) — internal adapter implementation
- [send#EmailCommunication](./services/send-email-communication.md) — email sending service design
- [create#EmailFlow](./services/create-email-flow.md) — automated flow provisioning design
- [get#EmailFlow](./services/get-email-flow.md) — flow status retrieval design
- [Tenant Onboarding](../tenant-onboarding.md) — provisioning a tenant with email access
- [TenantAuthFilter](../tenant-auth-filter.md) — request authentication
