# Retailer (Tenant) Onboarding Process

---

## 📝 Retailer Registration
- The UniShip tenants administrator [creates tenant](createTenant.md) in UniShip by passing the tenant name. The system responds with the tenantPartyId and the api access token. 

---

### 🧱 Step 1: Create Retailer as a Tenant Party
```xml
<Party partyId="RETAILER_123" partyTypeEnumId="PtyOrganization">
    <organization organizationName="Retailer 123"/>
    <roles roleTypeId="Tenant"/>
</Party>
```
---

### 🎟️ Step 2: Generate Key for Retailer
- This token is required in the Authorization header of API requests.
- create#UserLoginKey service is used to generate a secure key for the tenant.

```xml

---

## Configure ShippingGateway

### 🔐 Step 3: Store Retailer's API Token in ShippingGatewayAuthConfig
```xml
<ShippingGatewayAuthConfig
        ShippingGatewayAuthConfigId="SHIPPO_RETAILER_123"
        shippingGatewayConfigId="SmrShippo"
    tenantPartyId="RETAILER_123"
    authToken="shippo_live_token_xyz"
    serviceUrl="https://api.goshippo.com"
    enabledFlag="Y"/>
```

## Start using UniShip services

---

### 📡 Step 5: Retailer Uses the Gateway API
- Retailer’s OMS uses the tenantId ('X-Tenant-Id') token (`X-Login-Key`) to make API calls.  

---
