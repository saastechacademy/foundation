# getShippingRates

The getShippingRates service's main objective is to retrieve a list of qualified shipping rates for a given shipment. 
It takes into account factors such as the shipment's origin and destination, weight, dimensions, and desired delivery time to obtain rates from integrated shipping gateways.
This service returns all available rates that meet the criteria.
[doRateShopping](doRateShopping.md) uses this service and then retuns the best rate for the shipment.

6. Return
    *   Return a list of qualified `shippingRates`, where each rate object contains:
        *   shippingEstimateAmount - Actual service cost
        *   shipmentMethodTypeId - Service code (e.g., standard, express)
        *   carrierPartyId - Actual carrier code
        *   carrierService - Service name returned from gateway
        *   gatewayRateId - Rate id returned from gateway
        *   currencyUomId - Currency of the rate
