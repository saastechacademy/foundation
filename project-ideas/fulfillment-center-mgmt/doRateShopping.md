# doRateShopping

**Purpose:**

*   Finds the optimal shipping method for a shipment by comparing rates from various carriers.
*   Considers factors like origin, destination, weight, dimensions, delivery time, and cost.
*   Integrates with a shipping gateway for real-time rate retrieval.

**Detailed Implementation**

1.  **Input and Initialization:**
    *   Takes `shipmentId`, `forceRateShop` (optional, default: false), and `generateLabel` (optional) as input.
    *   Initializes variables to store shipment methods, weight unit, and party ID.
    *   Sets `generateLabel` to true if the facility is configured for auto-label generation or if explicitly requested.

2.  **Shipment and Order Data Retrieval:**
    *   Fetches the `Shipment` entity using `shipmentId`.
    *   Gets the `productStoreId` from the associated `OrderHeader`.
    *   Extracts the `facilityId` (origin) from the shipment.

3.  **Shipment Route Segment and Configuration Check:**
    *   Retrieves the first `ShipmentRouteSegment` (assuming one per shipment).
    *   Checks if the carrier and shipment method are configured for the product store.
    *   If not configured and the method isn't "STOREPICKUP," the order is processed offline.

4.  **Carrier and Shipment Method Selection:**
    *   If no carrier is assigned (`carrierPartyId` is "_NA_") or `forceRateShop` is true, and the method isn't "STOREPICKUP," it proceeds with rate shopping.
    *   Gets carriers associated with the origin facility (`facilityCarrierShipments`).
    *   For each carrier:
        *   Checks if there's a `CarrierShipmentMethod` entry with delivery days configured.
        *   If so, finds other methods for the same carrier with delivery days within the configured limit.
        *   Considers the `shipmentMethodTypeId` suggested by the brokering algorithm.
        *   Calls `getShipmentMethods` to fetch rates from the carrier's API.
        *   If no rates are found and "STANDARD" hasn't been tried, attempts to get "STANDARD" rates and triggers an event if express shipping is unavailable.
```
                        List<GenericValue> facilityCarrierShipments = EntityQuery.use(delegator).select("partyId").from("FacilityParty").where("facilityId", facilityId, "roleTypeId", "CARRIER").filterByDate().distinct().queryList();

```

5.  **Rate Comparison and Selection:**
    *   Sorts retrieved `shipmentMethods` by estimated cost (ascending).
    *   Selects the cheapest method.
    *   If `shipmentMethodTypeId` and `carrierPartyId` are missing, retrieves them from `CarrierShipmentMethod`.

6.  **Update or Return:**
    *   If `generateLabel` is true or the method is "STOREPICKUP," updates the `ShipmentRouteSegment` with the selected details.
    *   Otherwise, returns the selected shipping method, carrier, cost, and billing weight.

**Supporting Functions**

1.  **`getShipmentMethods` (in `WarehouseServices.txt`)**

    *   **Purpose:** Fetches shipping methods and rates from a carrier's API.
    *   **Key Steps:**
        *   Retrieves shipment and facility details.
        *   Gets configured shipment methods for the product store.
        *   Constructs the request payload (`serviceFields`) for the carrier API, including:
            *   Origin and destination addresses
            *   Package details (weight, dimensions, type)
            *   Shipment value, currency, weight unit
            *   Carrier and shipment method IDs
        *   Calls the appropriate carrier service (determined by `getConfiguredCarrierService`) to get rates.
        *   Handles errors and logs if the service is not configured.
        *   Returns the list of `shipmentMethods` with rates.

2.  **`getConfiguredCarrierService` (in `WarehouseHelper.txt`)**

    *   **Purpose:** Retrieves the service name to use for a specific carrier, shipment method, and request type.
    *   **Key Steps:**
        *   Looks for a custom configuration in the `ShipmentRequest` entity.
        *   If not found, falls back to a default configuration from `shipment.properties`.
        *   Returns the service name or `null` if no configuration is found.

3.  **`getShipmentPackedQuantity`, `getShipmentTotalWeight`, `getShipmentPackages`, `getShipmentRouteSegment`, `getOriginPostalAddress`, `getDestinationPostalAddress` (in `ShipmentReadHelper.txt`)**

    *   **Purpose:** These helper functions retrieve various shipment-related data from the database, such as:
        *   Total packed quantity
        *   Total weight
        *   Package details
        *   Route segment information
        *   Origin and destination addresses
    *   **Usage in `getShipmentMethods`:** They provide the necessary data to construct the `serviceFields` map for the carrier API request.

**Overall Flow**

1.  `doRateShopping` receives shipment ID and flags.
2.  It retrieves shipment, order, and route segment details.
3.  If needed, it finds suitable carriers and shipment methods.
4.  `getShipmentMethods` is called for each carrier/method combination:
    *   It gathers shipment data using helper functions.
    *   It uses `getConfiguredCarrierService` to find the right carrier service.
    *   It calls the carrier API to get rates.
5.  `doRateShopping` compares rates, selects the cheapest, and updates the shipment or returns the result.


In the `getShipmentMethods` implementation, the `ProductStoreShipmentMeth` entity is queried to retrieve a list of configured shipping methods for the given `productStoreId`, `partyId` (carrier), and a set of `shipmentMethodTypeIds`. This list is then used to filter the available shipping methods and ensure that only the ones supported by the store are considered during the rate shopping process.
