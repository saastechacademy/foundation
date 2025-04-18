## Retailer (Tenant) Onboarding Process

---

### 📝 Step 1: Retailer Registration
- Retailer submits:
    - Preferred shipping gateway (e.g., Shippo)
    - API token/credentials

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
<SystemMessageRemote
    systemMessageRemoteId="SHIPPO_RETAILER_123"
    systemMessageRemoteTypeEnumId="SmrShippo"
    tenantPartyId="RETAILER_123"
    authToken="shippo_live_token_xyz"
    serviceUrl="https://api.goshippo.com"
    enabledFlag="Y"/>
```

---

### 🎟️ Step 4: Generate JWT Token for Retailer
- Embed the following in the JWT:
```json
{
  "tenantPartyId": "RETAILER_123",
  "shippingGatewayConfigId": "SHIPPO_CONFIG"
}
```
- This token is required in the Authorization header of API requests.

---

### 📡 Step 6: Retailer Uses the Gateway API
- Retailer’s OMS uses the JWT token to:
    - Identify tenant

---
