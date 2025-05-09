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
| `ShippingGatewayAuthConfig` | Stores **retailer-specific connection details** like API token and service URL (with `tenantPartyId`). |

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
    shippingGatewayTypeEnumId="ShGtwyRemote"
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

#### Step 5: Record retailer's gateway credentials using `ShippingGatewayAuthConfig`
```xml
    <entity entity-name="ShippingGatewayAuthConfig" package="co.hotwax.uniship"
            use="configuration" cache="true">
    <description>Defines tenant-specific authentication and endpoint details for shipping gateway integrations.</description>

    <field name="shippingGatewayAuthConfigId" type="id" is-pk="true"/>
    <field name="tenantPartyId" type="id" not-null="true"/>
    <field name="shippingGatewayConfigId" type="id" not-null="true"/>

    <field name="modeEnumId" type="id">
        <description>Sandbox or Production mode</description>
    </field>
    <field name="authTypeEnumId" type="id" not-null="true"/>
    <field name="baseUrl" type="text-medium" not-null="true"/>

    <!-- Credentials -->
    <field name="apiKey" type="text-medium" encrypt="true"/>
    <field name="username" type="text-medium"/>
    <field name="password" type="text-medium" encrypt="true"/>
    <field name="sharedSecret" type="text-medium" encrypt="true"/>

    <!-- OAuth-specific fields -->
    <field name="oauthTokenUrl" type="text-medium"/>
    <field name="clientId" type="text-medium"/>
    <field name="clientSecret" type="text-medium" encrypt="true"/>

    <!-- Runtime configuration -->
    <field name="sendTimeoutSeconds" type="number-integer"/>
    <field name="retryLimit" type="number-integer"/>
    <field name="isActive" type="text-indicator"/>

    <relationship type="one" related="co.hotwax.uniship.Party" short-alias="tenant">
        <key-map field-name="tenantPartyId"/>
    </relationship>
    <relationship type="one" related="moqui.basic.Enumeration" short-alias="authType">
        <key-map field-name="authTypeEnumId"/>
    </relationship>
    <relationship type="one" related="moqui.basic.Enumeration" short-alias="mode">
        <key-map field-name="modeEnumId"/>
    </relationship>
    <relationship type="one" related="co.hotwax.uniship.ShippingGatewayConfig" short-alias="gatewayConfig">
        <key-map field-name="shippingGatewayConfigId"/>
    </relationship>
    <seed-data>
        <moqui.basic.EnumerationType enumTypeId="ShippingGatewayAuthType" description="Shipping Gateway Auth Type"/>
        <moqui.basic.Enumeration enumId="SgatApiKey" description="API Key" enumTypeId="ShippingGatewayAuthType"/>

        <moqui.basic.EnumerationType enumTypeId="ShippingGatewayMode" description="Shipping Gateway Mode"/>
        <moqui.basic.Enumeration enumId="SgmSandbox" description="Sandbox" enumTypeId="ShippingGatewayMode"/>
        <moqui.basic.Enumeration enumId="SgmProduction" description="Production" enumTypeId="ShippingGatewayMode"/>

    </seed-data>
</entity>
```

---

### 🔍 Key Design Considerations

#### ✅ Use `ShippingGatewayAuthConfig` with `tenantPartyId`
- Designed to manage external system connections.
- Multi-tenant friendly and scalable.
- Lets you store API token, service URL, and other credentials per retailer.

---

### 🧩 How it All Comes Together

| Concern | Solution                                                                                        |
|--------|-------------------------------------------------------------------------------------------------|
| Retailer wants to use Shippo | Choose `ShippingGatewayConfig`, setup `ShippingGatewayAuthConfig` with `tenantPartyId` for token. |
| Shipments must use correct gateway | Lookup `ShippingGatewayAuthConfig` by `tenantPartyId + shippingGatewayConfigId`.                |

---

### ✅ Summary
Use Moqui's existing model with:
- **One gateway config per service provider** (Shippo, FedEx, etc.)
- **ShippingGatewayAuthConfig (with tenantPartyId)** for per-retailer token + endpoint
