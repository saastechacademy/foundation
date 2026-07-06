# Adding a New Shipping Carrier to UniShip

This guide covers integrating a new carrier with UniShip's routing system. The pattern is identical for all carriers: implement three service interfaces, create FreeMarker template(s), register a `ShippingGatewayConfig` record, and provision `ShippingGatewayAuth` for each tenant using the carrier.

No changes to `ShippingServices.xml` are needed.

---

## Step 1 — Implement the Three Service Interfaces

Create `service/co/hotwax/shipping/{carrier}/{CarrierName}Services.xml`. All three operations must implement the contracts defined in `ApiInterfaceServices.xml`.

### Required Implementations

1. **Rate Service**
   - **Implements:** `co.hotwax.unigate.ApiInterfaceServices.get#ShippingRate`
   - **Detailed Design:** See [getShippingRate](./services/get-shipping-rate.md) for full context/mapping rules.
   - **Responsibility:** Load auth credentials from `ShippingGatewayAuth`, render the request template, call the carrier's rating API, and map the response to the `shippingRates` list.

2. **Label Service**
   - **Implements:** `co.hotwax.unigate.ApiInterfaceServices.request#ShippingLabels`
   - **Detailed Design:** See [requestShippingLabel](./services/requestShippingLabel.md) for full context/mapping rules.
   - **Responsibility:** Load auth credentials, render the label request template, call the carrier API, and populate `shippingLabelMap` with tracking IDs and base64-encoded label images.

3. **Refund Service**
   - **Implements:** `co.hotwax.unigate.ApiInterfaceServices.refund#ShippingLabels`
   - **Detailed Design:** See [refundShippingLabels](./services/refundShippingLabels.md) for full context/mapping rules.
   - **Responsibility:** Call the carrier's cancellation/refund endpoint for each tracking ID and return `success=true` or error messages.

---

## Step 2 — Create FreeMarker Templates

Create templates under `template/shipping/{carrier}/`. The templates have access to the full service context (all in-parameters are available as FTL variables).

**Rate request example:**
```freemarker
<#-- template/shipping/{carrier}/GetRateRequest.ftl -->
<@compress single_line=true>
{
    "origin": {
        "name": "${originAddress.toName!}",
        "address1": "${originAddress.address1!}",
        "city": "${originAddress.city!}",
        "state": "${originAddress.stateOrProvinceCode!}",
        "zip": "${originAddress.postalCode!}",
        "country": "${originAddress.countryCode!}"
    },
    "destination": {
        "name": "${destAddress.toName!}",
        "address1": "${destAddress.address1!}",
        "city": "${destAddress.city!}",
        "state": "${destAddress.stateOrProvinceCode!}",
        "zip": "${destAddress.postalCode!}",
        "country": "${destAddress.countryCode!}"
    },
    "packages": [
    <#list parcels![] as parcel>
        {
            "weight": ${parcel.weightValue!0},
            "weight_unit": "${parcel.weightUnit!}",
            "length": ${parcel.length!0},
            "width": ${parcel.width!0},
            "height": ${parcel.height!0}
        }<#sep>,</#sep>
    </#list>
    ],
    "service": "${shipmentMethod!}"
}
</@compress>
```

---

## Step 3 — Register in ShippingGatewayConfig

```xml
<!-- In your component's data/SeedData.xml or via admin UI -->
<co.hotwax.unigate.ShippingGatewayConfig
    shippingGatewayConfigId="NEW_CARRIER"
    description="New Carrier Name"
    getRateServiceName="co.hotwax.shipping.newcarrier.NewCarrierServices.get#NewCarrierShippingRate"
    requestLabelsServiceName="co.hotwax.shipping.newcarrier.NewCarrierServices.request#NewCarrierShippingLabel"
    refundLabelsServiceName="co.hotwax.shipping.newcarrier.NewCarrierServices.refund#NewCarrierShippingLabel"/>
```

Leave fields null for operations you haven't implemented — the routing layer will return a "service name not configured" error if those operations are called.

---

## Step 4 — Provision ShippingGatewayAuth for Each Tenant

```json
POST /rest/s1/unigate/shippingGatewayAuth
{
  "tenantPartyId": "TENANT_001",
  "shippingGatewayConfigId": "NEW_CARRIER",
  "authTypeEnumId": "OAuth2",
  "baseUrl": "https://api.newcarrier.com",
  "clientId": "tenant-client-id",
  "clientSecret": "tenant-client-secret",
  "modeEnumId": "Production",
  "description": "Tenant 001 production account"
}
```

The returned `shippingGatewayAuthId` is what the tenant passes in all API calls.

---

## Special Cases

### OAuth Token Caching

If your carrier uses short-lived OAuth tokens, implement a token cache service following the C807 pattern:

```groovy
// Cache key: tenantPartyId + "|" + shippingGatewayConfigId
def cacheKey = "${tenantPartyId}|${shippingGatewayConfigId}"
def cache = ec.cache.getCache("YOUR_CARRIER")
def cachedToken = cache.get(cacheKey)

if (!cachedToken) {
    // Fetch new token from carrier OAuth endpoint
    // Store in cache with putIfAbsent
    cache.putIfAbsent(cacheKey, newToken)
}
```

Add cache configuration in `MoquiConf.xml`:
```xml
<cache name="YOUR_CARRIER" expire-time-idle="86400"/>
```

### SOAP/XML Carriers

For SOAP carriers (like Purolator), render an XML FreeMarker template and set the content type accordingly:

```groovy
def headers = [
    "Content-Type": "text/xml;charset=UTF-8",
    "SOAPAction": "http://carrier.com/Action"
]
// Use basic auth via RestClient.basicAuth(username, password)
```

---

## Carrier Integration Checklist

- [ ] Three services implement `ApiInterfaceServices` contracts
- [ ] Auth credentials read from `ShippingGatewayAuth` — no hardcoded credentials
- [ ] Base URL read from `shippingGatewayAuth.baseUrl` — no hardcoded URLs
- [ ] `shippingLabelMap` includes `referenceNumber` + `packages[trackingIdNumber, imageBytes]`
- [ ] `success=false` + `errorMessages` on carrier API errors (not exception)
- [ ] FreeMarker templates render valid payloads for the carrier
- [ ] `ShippingGatewayConfig` record created
- [ ] End-to-end test with a real tenant + sandbox carrier account

---

## Related Documents

- [UniShip README](./README.md) — full architecture and carrier patterns
- [ShippingGatewayAuth](../entity/ShippingGatewayAuth.md) — credential entity
- [ShippingGatewayConfig](../entity/ShippingGatewayConfig.md) — config entity
- [Carrier Account Management](./CarrierAccountManagement.md) — multi-account per tenant
