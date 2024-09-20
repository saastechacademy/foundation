# shouldDoRateShopping

Encapsulates the logic to decide whether to proceed with rate shopping.

**Function Signature**

```java
private static boolean shouldDoRateShopping(GenericValue shipment, Boolean forceRateShop, String shipmentMethodTypeId) {
    // ... implementation ...
}
```

**Input Parameters**

*   `shipment`: The `GenericValue` representing the `Shipment` entity.
*   `forceRateShop`: A boolean flag indicating whether to force rate shopping even if a carrier is already assigned (optional, defaults to `false`).
*   `shipmentMethodTypeId`: The shipment method type ID from the `ShipmentRouteSegment`.

**Logic**

1.  **Carrier Check:**
    *   Retrieve the `carrierPartyId` from the shipment's first route segment (assuming one segment per shipment).
    *   If `carrierPartyId` is "_NA_" (no carrier assigned) OR `forceRateShop` is true, proceed to the next check.
    *   Otherwise, return `false` (no rate shopping needed).

2.  **Shipment Method Check:**
    *   If `shipmentMethodTypeId` is "STOREPICKUP," return `false` (no rate shopping for in-store pickup).

3.  **Product Store Configuration Check:**
    *   Retrieve the `productStoreId` from the associated `OrderHeader`.
    *   Query the `ProductStoreShipmentMeth` entity to count the number of records where:
        *   `partyId` is not "_NA_" (carrier is assigned)
        *   `roleTypeId` is "CARRIER"
        *   `productStoreId` matches the retrieved `productStoreId`
        *   Either `isTrackingRequired` is "Y" or `isTrackingRequired` is null
    *   If the count is greater than 0, return `true` (rate shopping is needed).
    *   Otherwise, return `false`.

4.  **Facility Group Check for Auto Shipping Label:**
    *   Retrieves the `facilityId` associated with the shipment.
    *   Checks if the facility belongs to the "AUTO_SHIPPING_LABEL" facility group using the `isFacilityInGroup` helper function.
    *   If it does, it returns `true` (rate shopping is needed for facilities in this group).


**Return Value**

*   `true`: If rate shopping should be performed.
*   `false`: If rate shopping is not required.


