# Uniship carrier notes

This document captures carrier-specific capabilities and how Uniship normalizes responses. It is intended as a quick reference for integration behavior.

## Normalized rate response (Unigate)
All carrier rate services return a common response shape:
- `success` (Boolean)
- `statusCode` (Integer)
- `isRateShoppingSupported` (Boolean)
- `shippingRates` (List)

When rate shopping is not supported, Uniship returns:
- `isRateShoppingSupported = false`
- `statusCode = 501`
- `shippingRates = []`

## Carrier capability matrix
| Carrier | Rate shopping | Labels | Notes |
| --- | --- | --- | --- |
| FedEx | Yes | Yes | Returns rate list or a single normalized rate. |
| Purolator | Yes | Yes | SOAP-based rate and label APIs. |
| Shiphawk | Yes | Yes | Rate shopping via `/rates`. |
| Canada Post | Yes | Yes | XML rate response parsed to normalized fields. |
| Forza | Yes | Yes | Rate response decoded from payload; normalized to rate list. |
| C807 | No | Yes | Returns `isRateShoppingSupported = false`. |
| DrivIn | No | Yes | Uses `post#Order` flow, no rate API. |
| Terminal Express | No | Yes | Uses `post#Order` flow, no rate API. |
| Multientrega | No | Yes | Uses third-party aggregator, no rate API. |
| CargoTrans | No | Yes | Uses `post#Order` flow, no rate API. |

## Implementation guidelines
- Carrier services that do not support rate shopping must return a successful response with `isRateShoppingSupported = false` so upstream callers can continue without errors.
- Carrier services that do support rate shopping should return `shippingRates` as a list of maps, even when the carrier only returns a single rate.
- Label requests may return label bytes or a `labelImageUrl`, but should always place those under `shippingLabelMap.packages` for consistency.
