## Retailer (Tenant) Onboarding Process

---

### 📝 Step 1: Retailer Registration
- The UniShip tenants administrator creates Tenant in UniShip by passing the Tenant name. The system reponds with the tenantPartyId and the api access Token. 

- The 
---

### 🧱 Step 2: Create Retailer as a Tenant Party
```xml
<Party partyId="RETAILER_123" partyTypeEnumId="PtyOrganization">
    <organization organizationName="Retailer 123"/>
    <roles roleTypeId="Tenant"/>
</Party>
```

---

### 🔐 Step 3: Store Retailer's API Token in SystemMessageRemote
```xml
<ShippingGatewayAuthConfig
        ShippingGatewayAuthConfigId="SHIPPO_RETAILER_123"
        shippingGatewayConfigId="SmrShippo"
    tenantPartyId="RETAILER_123"
    authToken="shippo_live_token_xyz"
    serviceUrl="https://api.goshippo.com"
    enabledFlag="Y"/>
```

---

### 🎟️ Step 4: Generate Key for Retailer
- This token is required in the Authorization header of API requests.

---

### 📡 Step 6: Retailer Uses the Gateway API
- Retailer’s OMS uses the key token to:
    - Identify tenant

---
