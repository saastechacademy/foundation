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
