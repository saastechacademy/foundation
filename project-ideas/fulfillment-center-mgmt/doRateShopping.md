# doRateShopping

The doRateShopping service's main objective is to identify the most suitable shipping method for a given shipment. 
It takes into account factors such as the shipment's origin and destination, weight, dimensions, desired delivery time, to find the most cost-effective method. 
The service integrates with a shipping gateway to retrieve rates and then selects the optimal option.

If you're looking to get a list of all rates available for a shipment, you should use the get#ShippingRates service.

## Detailed Implementation

1. Input and Initialization
    *   Shipment

2. Identify mapped UniGate shipping gateway
   1. Select carrier party id from Shipment entity
   2. Check if the carrier party id is mapped to UniGate shipping gateway in ShippingGatewayConfig entity
   3. If the mapped UniGate shipping gateway does not have "supportsRateRequest:True" then skip payload preperation and copy shipment carrier and method to route segment and proceed with calling get#ShippingLabel
   4. If not mapped, return error

3. Prepare request payload
    1. Fetch Entities & Configurations:
        *   `ShipmentRequest`: Retrieve `Shipment`, `ShipmentRouteSegment`, and `ShipmentAndOrder` entities.
        *   `ShippingCarrierConfig`: Fetch configuration for the ProductStore, Carrier, and Facility. if specific facility config is missing, fallback to the default store/carrier config.

    2. Basic Request Context:
        *   Populate `dateOfSale`, `orderId`, and `carrierPartyId`.
        *   From `ShippingCarrierConfig`, map: `tenantId`, `shippingGatewayConfigId`, `packagingType`, `carrierAccountId`, `customerNumber`, and `pickupType`.

    3. Origin Address:
        *   Retrieve `OriginPostalAddress` and `OriginTelecomNumber` from the `ShipmentRouteSegment`.
        *   Map fields: `name`, `companyName`, `address1`, `address2`, `city`, `state`, `postalCode`, `country`, `phone`.
        *   Include `facilityId` and `companyName` (from Product Store title or company name).

    4. Destination Address:
        *   Retrieve `DestinationPostalAddress` and `DestTelecomNumber`.
        *   Check for Residential Address (`check#IsResidentialAddress`).
        *   Map fields: `toName`, `address1`, `address2`, `city`, `state`, `postalCode`, `country`, `phone`, and `residential` flag.

    5. Packages Construction:
        *   Iterate through `ShipmentPackages`.
        *   Package Level:
            *   Map `boxLength`, `boxWidth`, `boxHeight`, `dimensionUnit`.
            *   Calculate and convert `weight` to Carrier's defined UOM (`carrierWeightUomId`).
        *   Item Level (within Package):
            *   Iterate `ShipmentPackageContents`.
            *   Map `quantity`, `description` (ProductName), `sku` (InternalName), `unitPrice`, `currency`.
            *   Convert item weight to Carrier's UOM.
            *   Include `GoodIdentification` IDs (e.g., UPC, EAN).

    6. Summary Data:
        *   Calculate `totalPackageWeight`.
        *   Include `currencyUomId`.
        *   Map `FacilityIdentifications` (e.g., specific facility codes).


    1. Resolve Tenant & Gateway Configuration:
        *   Query `ShippingCarrierConfig` using `ProductStore`, `Carrier`, and `Origin Facility`.
        *   Fallback: If no facility-specific config exists, query using only `ProductStore` and `Carrier`.
        *   Extracted Fields:
            *   `tenantId`: The specific UniGate tenant.
            *   `shippingGatewayConfigId`: Configuration ID for the gateway.
            *   `carrierAccountId`: Account number for the carrier.

    2. Resolve API Endpoint & Credentials:
        *   Retrieve `SystemMessageRemote` entity using ID `UNIGATE_CONFIG`.
        *   Extracted Fields:
            *   `sendUrl`: Base URL for the UniGate API.
            *   `password`: Used as the `api_key`.

    3. Execute Rate Request:
        *   Service: `call#RateRequest`
        *   URL: `${sendUrl}/rest/s1/unigate/shipment/rate`
        *   Method: `POST`
        *   Headers:
            *   `tenant_Id`: From `ShippingCarrierConfig.tenantId`.
            *   `api_key`: From `SystemMessageRemote.password`.
        *   Body: The constructed request map (JSON).

    4. Parse Response:
        *   Extract `shippingEstimateAmount`, `shipmentMethod`, `carrierPartyId`, `carrierService`, `gatewayRateId`, `actualCarrierCode`.
    
5. Rate Comparison and Selection:
    1. Filter rates based on the SLA criteria
       1. If the rates contain service days, filter results to match requested SLA
       2. If rates contain estimated delivery date, compute the number of days and filter results to match requested SLA
       3. If some rates don't contain service days or estimated delivery date, those rates should be demoted to the bottom of the rates. 
       4. If no date attributes are present, return all rates with no addional sorting
    2. Select the cheapest rate by sorting on estimated cost.
       1. If multiple rates have the same estimated cost, select the rate with the least number of days.
   
6. Return
    *   Always attempt to populate the following fields:
        *   ShipmentRouteSegment
            *   Carrier party id - Actual carrier code returned from gateway
            *   Shipment method type id - Actual service code returned from gateway
            *   Actual service cost
            *   Estimated start date - Carrier pickup time
            *   Estimated arrival date - Carrier delivery time
            *   Carrier account number - account id rate is returned against
            *   Carrier service - Service name returned from gateway
            *   Gateway rate id - Rate id returned from gateway
            *   Gateway message - Message returned from gateway
            *   Gateway status - Error status returned from gateway
        *   ShipmentPackageRouteSegment
            *   Label image
            *   Label url
            *   Tracking code


NOTE:
The in payload is Shipment JSON with all the details needed to get the Shipping label. A Shipment may have one or more Packages. It's possible that the carrier does not support more than one package per shipment. In that case, the get shipping label for each package route segment. 

I think we should model the input JSON on lines of the Shipment JSON that aggregators like ShipStation will accept. 

