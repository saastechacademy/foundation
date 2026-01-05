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
   - Fetch `co.hotwax.shipment.OrderHeaderAndShipment` by `shipmentId`.
   - If missing, return error `Shipment [${shipmentId}] not found; cannot continue.`
2. Load SLA date
   - Fetch `OrderItemShipGroup` using `primaryOrderId` and `primaryShipGroupSeqId`.
   - Parse `estimatedDeliveryDate` to a timestamp when present.
3. Retrieve rates
   - Call `ShippingServices.get#ShippingRates` with `shipmentId`.
   - Extract `shippingRates` from the response.
4. Choose the best rate
   - If `estimatedDeliveryDate` exists, filter to rates with `estimatedDeliveryDateTs <= estimatedDeliveryDate`.
   - If the filter yields none, fall back to all rates.
   - Sort eligible rates by `shippingEstimateAmount` (ascending) and choose the first.
5. Resolve shipment method type (if missing)
   - Pull `carrierServiceCode` from `bestRate.shipmentMethod` or `bestRate.carrierServiceCode`.
   - If `bestRate.shipmentMethodTypeId` is empty, look up `CarrierShipmentMethod` by:
     - `partyId = bestRate.carrierPartyId` (fallback to shipment carrierPartyId)
     - `roleTypeId = CARRIER`
     - `carrierServiceCode`
   - Use the resulting `shipmentMethodTypeId` when found.
6. Update shipment route segment
   - Update the first `ShipmentRouteSegment` with:
     - `carrierPartyId` from `bestRate`
     - `shipmentMethodTypeId` (resolved above)
     - `actualCost` from `shippingEstimateAmount`
     - `carrierServiceStatusId = SHRSCS_CONFIRMED`
     - `carrierService`
     - `actualCarrierCode`
     - `gatewayRateId`
   - Persist using `update#org.apache.ofbiz.shipment.shipment.ShipmentRouteSegment`.

## Error and edge cases
- If `get#ShippingRates` returns no rates, the service does not update the shipment route segment.
- If `bestRate` cannot be determined, it returns `No rate found for shipmentId: ${shipmentId}`.
- Errors from `get#ShippingRates` will bubble up (for example, missing shipment or Unigate configuration).

## Related services
- [getShippingRates](getShippingRates.md) provides the rate list used for selection.
