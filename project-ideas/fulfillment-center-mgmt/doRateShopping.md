# doRateShopping

## Service name
`co.hotwax.poorti.shipping.ShippingServices.do#RateShopping`

## Purpose
Select the best shipping rate for a shipment and update the shipment route segment with the chosen carrier and cost details. The service delegates rate retrieval to [getShippingRates](getShippingRates.md).

## Inputs
- `shipmentId` (required)

## Outputs
- `bestRate` (Map)
  - Selected rate map from `shippingRates` (same shape as entries returned by [getShippingRates](getShippingRates.md)).

The service also updates the shipment route segment in the database.

## Detailed flow
1. Load shipment data
   - Fetch `org.apache.ofbiz.shipment.shipment.Shipment` by `shipmentId`.
   - If missing, return error `Shipment [${shipmentId}] not found; cannot continue.`
   - Load the related `OrderHeader` and `ShipmentRouteSegment` list.
2. Retrieve rates
   - Call `ShippingServices.get#ShippingRates` with `shipmentId`.
   - Extract `shippingRates` from the response.
3. Choose the best rate
   - If there is exactly one rate, use it as `bestRate`.
   - If there are multiple rates:
     - Parse `slaDeliveryDate` from the shipment (if present) to a timestamp.
     - Parse each rate's `estimatedDeliveryDate` to a timestamp when needed.
     - If SLA exists, filter to rates with `estimatedDeliveryDate <= slaDeliveryDate`.
     - If the filter yields none, fall back to all rates.
     - Sort eligible rates by `shippingEstimateAmount` (ascending) and choose the first.
4. Resolve shipment method type (if missing)
   - Pull `carrierServiceCode` from `bestRate.shipmentMethod` or `bestRate.carrierServiceCode`.
   - If `bestRate.shipmentMethodTypeId` is empty, look up `CarrierShipmentMethod` by:
     - `partyId = carrierPartyId`
     - `roleTypeId = CARRIER`
     - `carrierServiceCode`
   - Use the resulting `shipmentMethodTypeId` when found.
5. Update shipment route segment
   - If `carrierPartyId` and `shipmentMethodTypeId` are present, update the first
     `ShipmentRouteSegment` with:
     - `carrierPartyId`
     - `shipmentMethodTypeId`
     - `actualCost` from `shippingEstimateAmount`
     - `carrierServiceStatusId = SHRSCS_CONFIRMED`
     - `carrierService`
     - `actualCarrierCode`
     - `gatewayRateId`
   - Persist using entity-auto service `update#org.apache.ofbiz.shipment.shipment.ShipmentRouteSegment`.

## Error and edge cases
- If no rates are returned, the service returns `No carrier setup for Rate Shopping` (success type).
- If `bestRate` cannot be determined, it returns `No rate found for shipmentId: ${shipmentId}`.
- If a rate does not include `shipmentMethodTypeId`, the service attempts to infer it via `CarrierShipmentMethod`.
 - Errors from `get#ShippingRates` will bubble up (for example, missing shipment or Unigate configuration).

## Related services
- [getShippingRates](getShippingRates.md) provides the rate list used for selection.
