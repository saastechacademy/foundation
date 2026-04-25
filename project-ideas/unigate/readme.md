# Unigate

## What it is
Unigate is a shared integration layer for communication and shipping. It keeps the auth and routing logic in one place so other apps (like Poorti) can call a single interface instead of dealing with each provider or carrier directly.

## What it does
Unigate provides:
- communication services (send emails, create workflow events)
- shipping services (rate shopping, request labels, refund labels)
- tenant-aware gateway auth and configuration

## Key services
Communication:
- `co.hotwax.unigate.ApiInterfaceServices.send#EmailCommunication`
- `co.hotwax.unigate.ApiInterfaceServices.create#WorkflowEvent`

Shipping:
- `co.hotwax.unigate.ApiInterfaceServices.get#ShippingRate`
- `co.hotwax.unigate.ApiInterfaceServices.request#ShippingLabels`
- `co.hotwax.unigate.ApiInterfaceServices.refund#ShippingLabels`

## Communication services (simple view)
Unigate supports a single communication contract and maps it to a provider:
- **Send Email**: `send#EmailCommunication`
  - For **Klaviyo**, Unigate maps `emailType` to a Klaviyo metric event and posts it to trigger a flow.
  - For **SMTP/custom gateways** (for example, Mayur), Unigate renders a template and sends email directly.
- **Workflow Event**: `create#WorkflowEvent`
  - For **Klaviyo**, Unigate posts an event to `/api/events/`.
  - For **SMTP/custom gateways**, events are typically not supported.

## How shipping works (high level)
1. A client calls Unigate (rate, label, or refund).
2. Unigate validates tenant and gateway auth.
3. Unigate routes the request to the configured carrier service.
4. The carrier service returns a normalized response.

## Rate shopping behavior
When a carrier does **not** support rate shopping, Unigate returns:
- `isRateShoppingSupported = false`
- `statusCode = 501`
- `shippingRates = []`

The caller should continue the flow without throwing errors.

## Related docs
- Carrier capability notes: `project-ideas/unigate/carriers.md`

## How Poorti uses Unigate
- Poorti calls Unigate for rates and labels.
- If Unigate is not enabled, Poorti can fall back to OMS services.

## Entities and workflows
This section lists the Unigate entities and how they are used, in a simple format.

### 1) Entities in scope

#### A. Party and tenant entities
- **Party**: base record for people/organizations.
- **Person**: person details for a Party.
- **Organization**: organization details for a Party.
- **PartyRole**: assigns roles to parties (tenant role).
- **RoleType**: defines role hierarchy.
- **UserAccount (extend)**: links a user to a Party.

#### B. Communication gateway entities
- **CommGatewayConfig**: defines which services are used for email and events.
- **CommGatewayAuth**: tenant-specific auth for a communication gateway (ties to `SystemMessageRemote`).

#### C. Shipping gateway entities
- **ShippingGatewayConfig**: defines which services are used for rate, label, refund, track, and validate address.
- **ShippingGatewayAuth**: tenant-specific auth for shipping gateway (ties to `SystemMessageRemote`).

#### D. View entities (for read convenience)
- **ShippingGatewayAuthAndConfig**: joins auth + config for shipping.
- **CommGatewayAuthAndConfig**: joins auth + config for communication.
- **UserLoginKeyAndParty**: links user login key with Party.

### 2) Workflows (simple view)

#### Communication
1. Configure `CommGatewayConfig` (provider service mapping).
2. Add tenant credentials in `CommGatewayAuth`.
3. Call `send#EmailCommunication` or `create#WorkflowEvent`.

#### Shipping
1. Configure `ShippingGatewayConfig` (rate/label/refund/track/validate mappings).
2. Add tenant credentials in `ShippingGatewayAuth`.
3. Call `get#ShippingRate` for rate shopping.
4. Call `request#ShippingLabels` for labels.
5. Call `refund#ShippingLabels` or other shipping services when needed.
