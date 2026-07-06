# Unigate Setup Guide: Single Tenant with Multiple Carrier Accounts

**The Problem:** When a business operates hundreds of fulfillment facilities, each facility often has its own carrier account with distinct credentials (different account numbers, API keys, etc.). The naive approach — creating a separate Unigate tenant per facility — results in an explosion of tenant records that is operationally unmanageable.

**The Solution:** Keep a single logical Tenant for the entire business, but create one `ShippingGatewayAuth` record per facility. Each record stores that facility's credentials directly. The OMS stores the `shippingGatewayAuthId` at the facility level and passes it in every request. Unigate uses it to look up the exact credentials for that facility.

The key insight: `ShippingGatewayAuth` is the unit of isolation for credentials — not the Tenant.

---

## Architecture

### In Unigate

| Component | Role |
|---|---|
| `Party` + `UserAccount` + `UserLoginKey` | One record set per business entity (the "Tenant"). The single API key used by OMS to talk to Unigate. |
| `ShippingGatewayConfig` | One record per carrier. Stores the service names that handle rate, label, and refund operations for that carrier. Shared across all tenants and facilities. |
| `ShippingGatewayAuth` | **One record per facility**. Stores the carrier API credentials (`baseUrl`, `apiKey`, `clientId`, `clientSecret`) specific to that facility's carrier account. Scoped to a `tenantPartyId` + `shippingGatewayConfigId`. |

### In OMS

| Component | Role |
|---|---|
| `ShippingCarrierConfig` (facility-level) | Stores the `shippingGatewayAuthId` that maps this facility to its specific credential record in Unigate. |
| Connection config | OMS stores the Unigate base URL and the tenant's single API key to authenticate all requests to Unigate. |

---

## Multi-Account Example

150 fulfillment facilities, all under a single business (`SMUS`), each with their own FedEx account credentials.

- **Tenant:** One `SMUS` party — represents the entire business in Unigate.
- **Carrier Config:** One `FEDEX_CONFIG` record — maps FedEx operations to FedEx service implementations.
- **Per-Facility Credentials:** 150 `ShippingGatewayAuth` records — one per facility, each holding that facility's FedEx `clientId`, `clientSecret`, and `baseUrl`.
- **OMS Facility Config:** Each facility's `ShippingCarrierConfig` in OMS stores the `shippingGatewayAuthId` for its own `ShippingGatewayAuth` record in Unigate.

---

## Execution Flow

1. Facility `FACILITY_01` triggers a FedEx label request in OMS.
2. OMS reads `shippingGatewayAuthId = SMUS_FEDEX_01` from `ShippingCarrierConfig` for `FACILITY_01`.
3. OMS authenticates to Unigate using the tenant's API key (`api_key` header) and tenant ID (`tenant_Id` header).
4. The label request payload carries `shippingGatewayAuthId = SMUS_FEDEX_01`.
5. Unigate's `ShippingServices` looks up `ShippingGatewayAuth` by `shippingGatewayAuthId` — gets `FACILITY_01`'s FedEx credentials.
6. Unigate calls FedEx using those credentials and returns the label to OMS.

No per-facility tenant overhead. No `systemMessageRemoteId` passed in the payload.

---

## Sample Data

### Unigate Data

```xml
<?xml version="1.0" encoding="UTF-8"?>
<entity-facade-xml type="demo">

    <!-- Single Tenant representing the entire business -->
    <co.hotwax.unigate.Party partyId="SMUS" partyTypeEnumId="PtyOrganization">
        <organization organizationName="SMUS Organization"/>
    </co.hotwax.unigate.Party>

    <moqui.security.UserAccount userId="SMUS_SYS_USER" username="smus.unigate.sys"
                                 userFullName="SMUS System Account" partyId="SMUS"/>
    <moqui.security.UserLoginKey userId="SMUS_SYS_USER" loginKey="SUPER_SECRET_SMUS_KEY"
                                  fromDate="2025-05-07T08:00:00"/>
    <moqui.security.UserGroupMember userGroupId="UNIGATE_API" userId="SMUS_SYS_USER"
                                     fromDate="2025-05-07T08:00:00"/>

    <!-- Single Gateway Configuration for FedEx — shared across all facilities -->
    <co.hotwax.unigate.ShippingGatewayConfig
        shippingGatewayConfigId="FEDEX_CONFIG"
        description="FedEx Services Config"
        getRateServiceName="co.hotwax.shipping.fedex.FedexServices.get#ShippingRate"
        requestLabelsServiceName="co.hotwax.shipping.fedex.FedexServices.request#ShippingLabels"
        refundLabelsServiceName="co.hotwax.shipping.fedex.FedexServices.refund#ShippingLabels"/>

    <!-- One ShippingGatewayAuth per facility — each holds that facility's FedEx credentials -->
    <co.hotwax.unigate.ShippingGatewayAuth
        shippingGatewayAuthId="SMUS_FEDEX_01"
        shippingGatewayConfigId="FEDEX_CONFIG"
        tenantPartyId="SMUS"
        authTypeEnumId="OAuth2"
        baseUrl="https://apis-sandbox.fedex.com"
        clientId="facility01_client_id"
        clientSecret="facility01_client_secret"
        modeEnumId="Sandbox"
        description="FedEx credentials for Facility 01"/>

    <co.hotwax.unigate.ShippingGatewayAuth
        shippingGatewayAuthId="SMUS_FEDEX_02"
        shippingGatewayConfigId="FEDEX_CONFIG"
        tenantPartyId="SMUS"
        authTypeEnumId="OAuth2"
        baseUrl="https://apis-sandbox.fedex.com"
        clientId="facility02_client_id"
        clientSecret="facility02_client_secret"
        modeEnumId="Sandbox"
        description="FedEx credentials for Facility 02"/>

</entity-facade-xml>
```

### OMS Data

The OMS stores the `shippingGatewayAuthId` at the facility level so it can be passed in each Unigate API call:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<entity-facade-xml type="demo">

    <!-- OMS stores Unigate connection details for the SMUS tenant -->
    <!-- api_key is the plaintext key generated by create#UserLoginKey for SMUS_SYS_USER -->
    <!-- This is used in the api_key + tenant_Id headers on every Unigate request -->

    <!-- Facility-level config: each facility knows its own shippingGatewayAuthId in Unigate -->
    <ShippingCarrierConfig id="STORE_01_FEDEX_01" productStoreId="STORE_01" carrierPartyId="FEDEX"
                           facilityId="FACILITY_01" tenantId="SMUS"
                           shippingGatewayConfigId="FEDEX_CONFIG"
                           shippingGatewayAuthId="SMUS_FEDEX_01"
                           weightUomId="WT_lb" packagingType="YOUR_PACKAGING"
                           dropoffType="USE_SCHEDULED_PICKUP" labelSize="PAPER_4X6"
                           labelImageType="PNG" carrierAccountId="1111111"/>

    <ShippingCarrierConfig id="STORE_02_FEDEX_02" productStoreId="STORE_02" carrierPartyId="FEDEX"
                           facilityId="FACILITY_02" tenantId="SMUS"
                           shippingGatewayConfigId="FEDEX_CONFIG"
                           shippingGatewayAuthId="SMUS_FEDEX_02"
                           weightUomId="WT_lb" packagingType="YOUR_PACKAGING"
                           dropoffType="USE_SCHEDULED_PICKUP" labelSize="PAPER_4X6"
                           labelImageType="PNG" carrierAccountId="3333333"/>

</entity-facade-xml>
```

> **Note on OMS integration:** The OMS `ShippingCarrierConfig.shippingGatewayAuthId` field is illustrative — the exact OMS entity schema may differ. The key point is that OMS must store and pass the correct `shippingGatewayAuthId` per facility in every Unigate API request.

---

## Related Documents

- [ShippingGatewayAuth entity](../entity/ShippingGatewayAuth.md) — full field reference and setup workflow
- [ShippingGatewayConfig entity](../entity/ShippingGatewayConfig.md) — carrier service routing config
- [UniShip README](./README.md) — request routing and label pipeline
- [Tenant Onboarding](../tenant-onboarding.md) — creating the tenant and initial credentials
