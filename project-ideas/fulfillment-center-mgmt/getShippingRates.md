# getShippingRates

## Service name
`co.hotwax.poorti.shipping.ShippingServices.get#ShippingRates`

## Purpose
Fetch all available shipping rates for a shipment from Unigate. This service does not select a best rate or update shipment data.

## Inputs
- `shipmentId` (required)

## Outputs
- `shippingRates` (List)
  - `shippingEstimateAmount` - Estimated shipping cost returned by the gateway
  - `shipmentMethod` - Carrier service code used in the request (when available)
  - `carrierPartyId` - Carrier party ID used for the rate request
  - `carrierService` - Carrier service name returned by the gateway
  - `gatewayRateId` - Rate identifier returned by the gateway
  - `actualCarrierCode` - Carrier code returned by the gateway
  - `estimatedDeliveryDate` - Estimated delivery date (timestamp when parsed, otherwise string)
  - `estimatedDeliveryDateTs` - Parsed delivery date timestamp (null when parsing fails)

## Detailed flow
1. Load shipment data
   - Query `co.hotwax.shipment.OrderHeaderAndShipment` by `shipmentId`.
   - If no shipment exists, return error `Shipment [${shipmentId}] not found; cannot continue.`
2. Validate Unigate configuration
   - Fetch `SystemMessageRemote` with `systemMessageRemoteId = UNIGATE_CONFIG`.
   - If missing, return error `SystemMessageRemote [UNIGATE_CONFIG] not found; carrier call aborted.`
3. Determine carrier list
   - If `shipmentMethodTypeId` is present, fetch carriers from:
     - `org.apache.ofbiz.product.facility.FacilityCarrierShipment` by `facilityId`, `shipmentMethodTypeId`, `roleTypeId = CARRIER`
     - If none found, fall back to `org.apache.ofbiz.product.facility.FacilityParty` for the facility (with `date-filter`).
   - If no carrier list is found (or `shipmentMethodTypeId` is empty), use the shipment's `carrierPartyId` directly.
4. Resolve carrier shipment method (per carrier list entry)
   - Load `_NA_` `CarrierShipmentMethod` for `shipmentMethodTypeId` to get `deliveryDays`.
   - Find `CarrierShipmentMethod` for the carrier and matching `deliveryDays`.
   - If found, use its `carrierServiceCode` as `shipmentMethod`.
5. Build the rate request map
   - Template: `component://poorti/template/shipping/unigate/GetRateRequest.ftl`
   - Template requires:
     - `ShipmentAndOrder` and `ShipmentRouteSegment`
     - `ShippingCarrierConfig` (carrier + facility, with facility-null fallback)
   - When available, set `deliveryDays` and `shipmentMethod` on the request map.
6. Call Unigate
   - Call `ShippingServices.call#RateRequest`.
   - Only responses with `shippingEstimateAmount` and `carrierService` are kept.
7. Build the response list
   - For each successful response, map gateway fields into a `shippingRate` entry.
   - Parse `estimatedDeliveryDate` to `estimatedDeliveryDateTs` when possible and store both.

## Error and edge cases
- Missing shipment or `SystemMessageRemote` returns an error immediately.
- Missing `ShippingCarrierConfig` causes the request template to stop and the call to fail.
- If carrier shipment methods are missing for a carrier, that carrier is skipped.
- If Unigate calls fail or return incomplete data, the entry is skipped, and the list may be empty.

## Related services
- [doRateShopping](doRateShopping.md) uses this service to pick a best rate and update the shipment route segment.
