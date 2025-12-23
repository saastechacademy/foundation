# doRateShopping

The doRateShopping service's main objective is to identify the most suitable shipping method for a given shipment. It uses [getShippingRates](getShippingRates.md) service to retrieve shipping rates for a shipment and then selects the most cost-effective shipping method.

## Detailed Implementation

Parameters 
IN
*   ShipmentId

OUT
* ShippingMethodTypeId
* carrierPartyId

To identify Unigate Gateway config Need productStoreId, carrierPartyId, facilityId
Get it from OrderHeaderAndShipment view.
https://demo-oms.hotwax.io/webtools/control/FindGeneric?entityName=OrderHeaderAndShipment


For given estimatedDeliveryDate, get all rates from shipping gateway

Rate Comparison and Selection:
    1. Filter rates based on the SLA criteria
       1. If the rates contain service days, filter results to match requested SLA
       2. If rates contain estimated delivery date, compute the number of days and filter results to match requested SLA
       3. If some rates don't contain service days or estimated delivery date, those rates should be demoted to the bottom of the rates. 
       4. If no date attributes are present, return all rates with no addional sorting
    2. Select the cheapest rate by sorting on estimated cost.
       1. If multiple rates have the same estimated cost, select the rate with the least number of days.
