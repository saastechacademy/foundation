# doRateShopping

**Purpose:**

Get shipping rates from the Carrier party for the ShipmentMethodTypes configured on the ProductStore and meet the deliveryDays/SLA criteria. 

The doRateShopping service's main objective is to identify the most suitable shipping method for a given shipment by comparing rates from various carriers. It takes into account factors such as the shipment's origin and destination, weight, dimensions, desired delivery time, and cost-effectiveness. The service seamlessly integrates with a shipping gateway to retrieve real-time rates and then selects the optimal option.

**Detailed Implementation**

1.  **Input and Initialization:**

2.  **Shipment and Order Data Retrieval:**
    *   Fetches the `Shipment` entity using `shipmentId`.
    *   Gets the `productStoreId` from the associated `OrderHeader`.
    *   Extracts the `facilityId` (origin) from the shipment.

3.  **Shipment Route Segment and Configuration Check:**
    *   Checks if the carrier and shipment method are configured for the product store. 

4.  **Carrier and Shipment Method Selection:**
    *   Gets carriers associated with the origin facility.
    *   For each carrier:
        *   Checks if there's a `CarrierShipmentMethod` entry with delivery days configured.
        *   If so, find methods for the same carrier with delivery days within the configured limit.
        ```
        List<GenericValue> facilityCarriers = EntityQuery.use(delegator).select("partyId").from("FacilityParty").where("facilityId", facilityId, "roleTypeId", "CARRIER").filterByDate().distinct().queryList();

        ```
    
5.  **Rate Comparison and Selection:**
    *   For each qualfied carrierShipmentMethod, call the appropriate carrier service to get rates.  
    *   Sort retrieved carrier shipmentMethodRates by estimated cost (ascending).
    *   Selects the cheapest method.

6.  **Return**
    *   return carrierPartyId, shipmentMethodTypeId, shippingRate 



