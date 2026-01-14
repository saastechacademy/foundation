# Unigate

## What it is
Unigate is the shared integration layer for outbound communication and shipping gateways. It centralizes tenant-aware authentication, gateway configuration, and routing so upstream apps (like Poorti) can call one interface for shipping or communication without embedding carrier-specific logic.

Unigate is implemented as two modules:
- **Unimail**: outbound communication (email + workflow events)
- **Uniship**: shipping gateway configuration and carrier integrations

This document consolidates the current design and behavior. Detailed specs live in the existing unimail/uniship docs referenced below.

## Unimail (communication)
Purpose: expose a single interface for sending email and emitting workflow events, with tenant-specific credentials.

Key interface services:
- `co.hotwax.unigate.ApiInterfaceServices.send#EmailCommunication`
- `co.hotwax.unigate.ApiInterfaceServices.create#WorkflowEvent`

Core idea:
- Unimail looks up tenant-specific auth (gateway config + credentials) and routes the request to the configured communication provider.

Related docs:
- `project-ideas/unigate/unimail/readme.md`

## Uniship (shipping gateways)
Purpose: manage shipping gateway configuration and route requests to carrier integrations for rate shopping, label creation, and refunds.

Key interface services:
- `co.hotwax.unigate.ApiInterfaceServices.get#ShippingRate`
- `co.hotwax.unigate.ApiInterfaceServices.request#ShippingLabels`
- `co.hotwax.unigate.ApiInterfaceServices.refund#ShippingLabels`

Core entities:
- **ShippingGatewayConfig**: defines gateway-level service names for rate, label, and refund.
- **ShippingGatewayAuth**: ties a tenant + gateway to credentials (`SystemMessageRemote`), enabling tenant-aware access.

Execution flow (rate shopping):
1. Upstream service calls Unigate rate API.
2. Unigate validates tenant + gateway auth.
3. Unigate loads `ShippingGatewayConfig` to resolve the carrier service to call.
4. Carrier-specific service executes and returns a normalized response.

Behavioral guarantees:
- For carriers that do **not** support rate shopping, the rate service returns:
  - `isRateShoppingSupported = false`
  - `statusCode = 501`
  - `shippingRates = []`
- The caller is expected to handle this without throwing errors.

Related docs:
- `project-ideas/unigate/uniship/readme.md`
- `project-ideas/unigate/uniship/entity/entity-model.md`
- `project-ideas/unigate/uniship/entity/ShippingGatewayConfig.md`
- `project-ideas/unigate/uniship/entity/ShippingGatewayAuthConfig.md`
- `project-ideas/unigate/uniship/TenantAuthFilter.md`

## How Poorti uses Unigate
- Poorti calls Unigate for rate shopping and label requests.
- If Unigate is not enabled, Poorti can fall back to OMS services.
- Rate shopping responses are normalized through Unigate so Poorti does not need carrier-specific logic.

## Suggested next doc
- Carrier capability matrix and integration notes (see `project-ideas/unigate/carriers.md`).
