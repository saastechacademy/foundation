# getShippingRates

## Service name
`co.hotwax.poorti.shipping.ShippingServices.get#ShippingRates`

## Purpose
Fetch all available shipping rates for a shipment. If Unigate is disabled, the service delegates to the OMS REST service for rates and returns that list. This service does not select a best rate or update shipment data.

## Inputs
- `shipmentId` (required)

## Outputs
- `shippingRates` (List)
  - `shippingEstimateAmount` - Estimated shipping cost returned by the gateway
  - `shipmentMethod` - Carrier service code used in the request
  - `shipmentMethodTypeId` - Shipment method type mapped to the store configuration
  - `carrierPartyId` - Carrier party ID used for the rate request
  - `carrierService` - Carrier service name returned by the gateway
  - `gatewayRateId` - Rate identifier returned by the gateway
  - `actualCarrierCode` - Carrier code returned by the gateway
  - `currencyUomId` - Currency of the rate
  - `estimatedDeliveryDate` - Estimated delivery date (string or parsed timestamp)

## Detailed flow
1. Load shipment data
   - Query `co.hotwax.shipment.ShipmentAndOrder` by `shipmentId`.
   - If no shipment exists, return error `No shipment found with Id ${shipmentId}`.
2. Decide which rate source to use
   - Call `ShippingServices.check#UnigateEnabled` to read `UNIGATE_ENABLED` for the shipment's `productStoreId`.
   - If Unigate is not enabled, call `co.hotwax.poorti.shipping.OmsRestShippingServices.get#ShippingRates`,
     copy `shippingRates` from the response, and return.
3. Validate Unigate configuration
   - Fetch `SystemMessageRemote` with `systemMessageRemoteId = UNIGATE_CONFIG`.
   - If missing, return error `SystemMessageRemote not found with ID: UNIGATE_CONFIG`.
4. Determine carrier parties for the facility
   - First try `org.apache.ofbiz.product.facility.FacilityCarrierShipment` by `facilityId` and `roleTypeId = CARRIER`.
   - If none found, fall back to `org.apache.ofbiz.product.facility.FacilityParty` with `date-filter`.
   - If still none, return error `No carrier setup for getting shipping rates.`
5. Resolve shipment methods for each carrier
   - Find `ProductStoreShipmentMeth` for the `productStoreId`, `partyId`, and `roleTypeId = CARRIER`.
   - Build a unique list of `shipmentMethodTypeId`.
   - Fetch `CarrierShipmentMethod` for those method types and build a list of:
     - `carrierServiceCode`
     - `shipmentMethodTypeId`
6. Build the rate request map (per carrier)
   - Template: `component://poorti/template/shipping/unigate/GetRateRequest.ftl`
   - Required data and validations in the template:
     - `ShipmentAndOrder` and `ShipmentRouteSegment` must exist (otherwise the template stops).
     - `ShippingCarrierConfig` must exist for the carrier and facility (with a facility-null fallback).
   - Core request fields assembled:
     - `tenantId`, `shippingGatewayConfigId`, `accessAccountNbr`, `customerNumber`
     - `carrierPartyId`, `dateOfSale` (yyyy-MM-dd), `currencyUomId`
     - `pickupType`, `packagingType`
     - `originAddress` and `destAddress` (including phone and residential flag)
     - `packages` (dimensions, weights, and order item details)
     - `weightValue` (sum of package weights), `weightUnit`
     - `countryId` (origin country)
     - `facilityIdentificationMap`
7. Call Unigate for each shipment method
   - Set `rateRequestMap.shipmentMethod` to the `carrierServiceCode`.
   - Call `ShippingServices.call#RateRequest`:
     - POST `${SystemMessageRemote.sendUrl}/rest/s1/unigate/shipment/rate`
     - Headers: `tenant_Id`, `api_key`
     - Body: `rateRequestMap` (JSON)
   - Only responses with `shippingEstimateAmount` and `carrierService` are kept.
8. Build the response list
   - For each successful response, map gateway fields into a `shippingRate` entry (see Outputs).
   - If a response includes `estimatedDeliveryDate`, it is parsed into a timestamp when possible.

## Error and edge cases
- Missing shipment or system configuration returns errors immediately.
- If no carrier is configured for the facility, the service returns an error.
- If no shipment methods are configured for a carrier, no rates are added for that carrier.
- If Unigate calls fail or return incomplete data, the entry is skipped, and the list may be empty.

## Related services
- [doRateShopping](doRateShopping.md) uses this service to pick a best rate and update the shipment route segment.
- `ShippingServices.check#UnigateEnabled` determines whether to call Unigate or OMS.
- `OmsRestShippingServices.get#ShippingRates` provides the fallback rate list when Unigate is disabled.
