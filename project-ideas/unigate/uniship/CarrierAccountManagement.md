# Unigate Setup Guide: Single Tenant with Multiple Carrier Accounts

**The Previous Approach:** Creating a new "Tenant" in Unigate for every single facility strictly because each facility required its own carrier credentials. This inevitably creates hundreds of tenants, and it was very cumbersome to create config data and manage them.

**The Solution:** Decouple the carrier credentials from the concept of a Tenant. 
- A single logical Tenant represents the overarching business.
- A single generic `ShippingGatewayConfig` defines the carrier's API services.
- Numerous distinct `SystemMessageRemote` (SystemMessageRemote) records in Unigate hold the isolated credentials for each specific facility.
- Unigate links these via `ShippingGatewayAuth`.
- OMS natively stores the `systemMessageRemoteId` mapping at the facility level and injects it into the request payload. Unigate then seamlessly queries the precise auth record using the triad of `tenantId`, `shippingGatewayConfigId`, and `systemMessageRemoteId`.

---

## Architecture Breakdown

### 1. In Unigate
* **Tenant Setup:** The Tenant (`Party`, `Organization`, `UserAccount`, `UserLoginKey`) represents the oms-instance and acts as the integration user. 
* **Carrier Config:** The `ShippingGatewayConfig` per carrier maps the integration Java services.
* **API Credentials:** Distinct `SystemMessageRemote` records store the unique Carrier API Keys for each facility.
* **Auth Mapping:** `ShippingGatewayAuth` records map the `Tenant` + `ShippingGatewayConfig` perfectly to its corresponding unique `SystemMessageRemote`. 

### 2. In OMS
* **Facility Configuration:** The `ShippingCarrierConfig` entity at the facility level natively points to:
    1. The `tenantId` 
    2. The `shippingGatewayConfigId`
    3. **The Unigate `systemMessageRemoteId`** (The unique identifier representing this facility's credentials inside Unigate's SystemMessageRemote table).
* **Unigate Connection:** OMS maintains a `SystemMessageRemote` per Tenant. This SystemMessageRemote stores the Unigate instance URL and the single super-secret Login Key to talk to Unigate on behalf of all the stores for that Tenant.

---

## Multi Account Use Case Example

To illustrate this design, we will use a retail ecosystem (encompassing multiple brands across hundreds of facilities) as our primary example. For the purpose of this analogy, we have considered 150 fulfillment facilities/warehouses.

- **Tenant Setup:** A single Tenant, `SMUS`, represents the entire company entity acting as the interface to OMS.
- **Carrier Config:** `FEDEX_CONFIG` maps the generic FedEx rate and label services for all 150 facilities.
- **API Credentials:** 150 different SystemMessageRemote records are created to hold specific credentials for Facility 1, Facility 2, etc. (e.g., `FEDEX_ACCOUNT_01`).
- **Auth Mapping:** 150 records link the `SMUS` tenant and its `FEDEX_CONFIG` to the 150 distinct facility SystemMessageRemote records.
- **Facility Configuration:** The facility configuration for Facility 1 in OMS natively points to `SMUS` (Tenant), `FEDEX_CONFIG` (Gateway), and `FEDEX_ACCOUNT_01` (SystemMessageRemote ID).
- **Unigate Connection:** OMS uses a single `UNIGATE_CONFIG` SystemMessageRemote holding the single super-secret key to connect to Unigate on behalf of all 150 stores.

---

## Execution Flow
1. Facility `FACILITY_01` triggers a FedEx shipping label request in OMS.
2. OMS extracts `tenantId`, `shippingGatewayConfigId`, and `systemMessageRemoteId` from `ShippingCarrierConfig`.
3. OMS authenticates against the Unigate API using its stored Unigate URL and Login Key.
4. The label request payload securely carries the specific `tenantId`, `shippingGatewayConfigId`, and `systemMessageRemoteId`.
5. Unigate receives the payload and queries the `ShippingGatewayAuth` entity matching all three identifiers perfectly.
6. Unigate extracts the specific API credentials natively from the matched SystemMessageRemote, authenticates with the carrier, and returns the result.

---

## Sample Data (XML Implementation)

### Unigate Data Model
```xml
<?xml version="1.0" encoding="UTF-8"?>
<entity-facade-xml type="demo">

    <!-- The Single Unified Tenant -->
    <co.hotwax.unigate.Party partyId="SMUS" partyTypeEnumId="PtyOrganization">
        <organization organizationName="org_name"/>
    </co.hotwax.unigate.Party>
    
    <moqui.security.UserAccount userId="SMUS_SYS_USER" username="smus.unigate.sys" userFullName="SMUS System Account" partyId="SMUS"/>
    <moqui.security.UserLoginKey userId="SMUS_SYS_USER" loginKey="SUPER_SECRET_SMUS_KEY" fromDate="2025-05-07T08:00:00"/>
    <moqui.security.UserGroupMember userGroupId="UNIGATE_API" userId="SMUS_SYS_USER" fromDate="2025-05-07T08:00:00"/>

    <!-- The Single Gateway Configuration for FedEx -->
    <co.hotwax.unigate.ShippingGatewayConfig shippingGatewayConfigId="FEDEX_CONFIG"
                                             description="Fedex Services Config"
                                             getRateServiceName="co.hotwax.shipping.fedex.FedexServices.get#ShippingRate"
                                             requestLabelsServiceName="co.hotwax.shipping.fedex.FedexServices.request#ShippingLabels"
                                             refundLabelsServiceName="co.hotwax.shipping.fedex.FedexServices.refund#ShippingLabels" />

    <!-- Distinct SystemMessageRemote records for Multiple Facilities -->
    <moqui.service.message.SystemMessageRemote systemMessageRemoteId="FEDEX_ACCOUNT_01" description="FedEx Auth Keys strictly for Store 01" sendUrl="https://apis-sandbox.fedex.com" username="facility01_user" sharedSecret="facility01_secret"/>
    <moqui.service.message.SystemMessageRemote systemMessageRemoteId="FEDEX_ACCOUNT_02" description="FedEx Auth Keys strictly for Store 02" sendUrl="https://apis-sandbox.fedex.com" username="facility02_user" sharedSecret="facility02_secret"/>

    <!-- Auth Mapping linking the Triad: Config + Tenant + SystemMessageRemote -->
    <co.hotwax.unigate.ShippingGatewayAuth shippingGatewayConfigId="FEDEX_CONFIG" tenantPartyId="SMUS" systemMessageRemoteId="FEDEX_ACCOUNT_01"/>
    <co.hotwax.unigate.ShippingGatewayAuth shippingGatewayConfigId="FEDEX_CONFIG" tenantPartyId="SMUS" systemMessageRemoteId="FEDEX_ACCOUNT_02"/>

</entity-facade-xml>
```

### OMS Data Model
```xml
<?xml version="1.0" encoding="UTF-8"?>
<entity-facade-xml type="demo">

    <!-- OMS connection to Unigate APIs for the specific Tenant -->
    <SystemMessageRemote systemMessageRemoteId="UNIGATE_CONFIG" 
                         description="Unigate connection for SMUS Tenant"
                         sendUrl="https://unigate.hotwax.co" 
                         password="SUPER_SECRET_SMUS_KEY" />

    <!-- Facility Configs caching the unigate credential SystemMessageRemote mappings -->
    <ShippingCarrierConfig id="STORE_01_FEDEX_01" productStoreId="STORE_01" carrierPartyId="FEDEX"
                           facilityId="FACILITY_01" tenantId="SMUS" shippingGatewayConfigId="FEDEX_CONFIG" 
                           systemMessageRemoteId="FEDEX_ACCOUNT_01" 
                           weightUomId="WT_lb" packagingType="YOUR_PACKAGING" dropoffType="USE_SCHEDULED_PICKUP"
                           labelSize="PAPER_4X6" labelImageType="PNG" physicalStoreLabelSize="PAPER_4X6"
                           distributionCenterLabelSize="PAPER_4X6" carrierAccountId="1111111" customerNumber="2222222"/>

    <ShippingCarrierConfig id="STORE_02_FEDEX_02" productStoreId="STORE_02" carrierPartyId="FEDEX"
                           facilityId="FACILITY_02" tenantId="SMUS" shippingGatewayConfigId="FEDEX_CONFIG" 
                           systemMessageRemoteId="FEDEX_ACCOUNT_02" 
                           weightUomId="WT_lb" packagingType="YOUR_PACKAGING" dropoffType="USE_SCHEDULED_PICKUP"
                           labelSize="PAPER_4X6" labelImageType="PNG" physicalStoreLabelSize="PAPER_4X6"
                           distributionCenterLabelSize="PAPER_4X6" carrierAccountId="3333333" customerNumber="4444444"/>

</entity-facade-xml>
```
