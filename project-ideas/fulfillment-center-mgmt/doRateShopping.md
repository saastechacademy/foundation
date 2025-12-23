# doRateShopping

The doRateShopping service's main objective is to identify the most suitable shipping method for a given shipment. 
It takes into account factors such as the shipment's origin and destination, weight, dimensions, desired delivery time, to find the most cost-effective method. 
The service integrates with a shipping gateway to retrieve rates and then selects the optimal option.

If you're looking to get a list of all rates available for a shipment, you should use the get#ShippingRates service.

## Detailed Implementation

1. Input and Initialization
    *   Shipment

2. Identify mapped shipping gateway
   1. Select carrier party id and ShipmentMethodTypeId from Shipment entity
   2. Check if the carrier party id is mapped to shipping gateway in ProductStoreShipmentMeth entity
   3. If the mapped shipping gateway does not have "supportsRateRequest:True" then do nothing. 
 
5. Rate Comparison and Selection:
    1. Filter rates based on the SLA criteria
       1. If the rates contain service days, filter results to match requested SLA
       2. If rates contain estimated delivery date, compute the number of days and filter results to match requested SLA
       3. If some rates don't contain service days or estimated delivery date, those rates should be demoted to the bottom of the rates. 
       4. If no date attributes are present, return all rates with no addional sorting
    2. Select the cheapest rate by sorting on estimated cost.
       1. If multiple rates have the same estimated cost, select the rate with the least number of days.
