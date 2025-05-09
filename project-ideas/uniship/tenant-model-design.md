## Shipping Gateway Microservice Design

This document outlines the design approach for implementing a **Shipping Gateway Microservice** using the **Moqui Framework**, considering a multi-tenant use case where retailers configure and interact with shipping gateways like **Shippo**, **FedEx**, or **ShipStation**.

---

### ✅ Core Goals
1. **Centralized configuration** of shipping gateway integrations.
2. Clean separation of shared gateway logic and per-retailer data.

---

### 🧱 Core Entities in Use (in Setup Order)

| Entity | Purpose |
|--------|---------|
| `Party` + `PartyRole` | Used to define carriers and retailers (tenants) before referencing them elsewhere. |
| `ShippingGatewayConfig` | Defines shared service behavior of a shipping gateway (label generation, tracking). |
| `SystemMessageRemote` | Stores **retailer-specific connection details** like API token and service URL (with `tenantPartyId`). |

---

### 🧭 Configuration Flow

---

### 🏗️ Application Provider Setup (Performed Once)

#### Step 1: Define supported shipping carriers
```xml
<Party partyId="FEDEX" partyTypeEnumId="PtyOrganization">
    <organization organizationName="FedEx"/>
    <roles roleTypeId="Carrier"/>
</Party>
```

#### Step 2: Preconfigure available shipping gateways
```xml
<ShippingGatewayConfig
    shippingGatewayConfigId="SHIPPO_CONFIG"
    shippingGatewayTypeEnumId="ShGtwyShippo"
    requestLabelsServiceName="..."
    refundLabelsServiceName="...">
</ShippingGatewayConfig>
```

---

### 🧾 Retailer (Tenant) Onboarding

#### Step 3: Retailer signs up for the aggregator service
- Retailer registers and provides shipping gateway preferences and credentials.

#### Step 4: Create a Party record for the retailer
```xml
<Party partyId="RETAILER_123" partyTypeEnumId="PtyOrganization">
    <organization organizationName="Retailer 123"/>
    <roles roleTypeId="Tenant"/>
</Party>
```

#### Step 5: Record retailer's gateway credentials using `SystemMessageRemote`
```xml
<SystemMessageRemote
    systemMessageRemoteId="SHIPPO_RETAILER_123"
    systemMessageRemoteTypeEnumId="ShGtwyShippo"
    tenantPartyId="RETAILER_123"
    authToken="shippo_live_token_abc123"
    serviceUrl="https://api.goshippo.com"
    enabledFlag="Y"/>
```

---

### 🔍 Key Design Considerations

#### ✅ Use `SystemMessageRemote` with `tenantPartyId`
- Designed to manage external system connections.
- Multi-tenant friendly and scalable.
- Lets you store API token, service URL, and other credentials per retailer.

---

### 🧩 How it All Comes Together

| Concern | Solution                                                                                        |
|--------|-------------------------------------------------------------------------------------------------|
| Retailer wants to use Shippo | Choose `ShippingGatewayConfig`, setup `SystemMessageRemote` with `tenantPartyId` for token. |
| Shipments must use correct gateway | Lookup `SystemMessageRemote` by `tenantPartyId + systemMessageRemoteTypeEnumId`.                |

---

### ✅ Summary
Use Moqui's existing model with:
- **One gateway config per service provider** (Shippo, FedEx, etc.)
- **SystemMessageRemote (with tenantPartyId)** for per-retailer token + endpoint
