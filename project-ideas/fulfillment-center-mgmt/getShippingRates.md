# getShippingRates

The getShippingRates service's main objective is to retrieve a list of qualified shipping rates for a given shipment. 
It takes into account factors such as the shipment's origin and destination, weight, dimensions, and desired delivery time to obtain rates from integrated shipping gateways.
Unlike `doRateShopping`, which selects the best rate, this service returns all available rates that meet the criteria.

## Detailed Implementation

1. Input and Initialization
    *   Shipment
    *   

2. Identify mapped UniGate shipping gateway
   1. Select carrier party id from Shipment entity
   2. Check if the carrier party id is mapped to UniGate shipping gateway in ShippingGatewayConfig entity
   3. If not mapped, return error

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
    
5. Rate Filtering and Collection:
    1. Filter rates based on the SLA criteria
       1. If the rates contain service days, filter results to match requested SLA
       2. If rates contain estimated delivery date, compute the number of days and filter results to match requested SLA
       3. If some rates don't contain service days or estimated delivery date, those rates should be demoted to the bottom of the rates. 
       4. If no date attributes are present, include all rates.
   
6. Return
    *   Return a list of qualified `shippingRates`, where each rate object contains:
        *   shippingEstimateAmount - Actual service cost
        *   shipmentMethodTypeId - Service code (e.g., standard, express)
        *   carrierPartyId - Actual carrier code
        *   carrierService - Service name returned from gateway
        *   gatewayRateId - Rate id returned from gateway
        *   currencyUomId - Currency of the rate
