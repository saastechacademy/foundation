## 🚀 Architecture: getShippingRate API in Multitenant Shipping Gateway Microservice

This document outlines the architecture and control flow for handling `getShippingRate` API requests in the multitenant shipping gateway microservice built on the Moqui framework.

---

### 🎯 Responsibilities
- Accept standard JSON input from an OMS.
- Decode tenant-specific context (tenantPartyId, shippingGatewayConfigId) from JWT.
- Look up the correct gateway configuration.
- Dynamically dispatch the request to the appropriate carrier-specific service.
- Return the rate options in a consistent structure.

---

### 📦 OMS Request Payload (Simplified)
```json
{
  "carrierPartyId": "FEDEX",
  "carrierAccountId": "123456",
  "shipmentPackages": [ ... ],
  "shipFromAddress": { "name": "Warehouse A", ... },
  "shipToAddress": { "name": "Customer B", ... }
}
```

---

### 🧠 Control Flow Diagram
```
 OMS Request JSON
       │
       ▼
+------------------+
| Facade Service   |
| (get#ShippingRate)|
+------------------+
       │
       ▼
  Parse JWT (tenant + config)
       │
       ▼
  Fetch gateway config (getRateServiceName)
       │
       ▼
  Fetch SystemMessageRemote + Options
       │
       ▼
+--------------------------+
| ✨ Transform Input Map    | ← per carrier
| (standard → gateway API) |
+--------------------------+
       │
       ▼
Call carrier-specific getRate service
       │
       ▼
+------------------------------+
| 🔁 Transform Response Format | ← per carrier
| (gateway → standard format) |
+------------------------------+
       │
       ▼
Return rates to OMS
```

---

### 🔧 Moqui Service Outline
```xml
<service verb="get" noun="ShippingRate" allow-remote="true">
    <in-parameters>
        <parameter name="shipmentRequest" type="Map" required="true"/>
        <parameter name="jwtToken" type="String" required="true"/>
    </in-parameters>
    <out-parameters>
        <parameter name="responseMap"/>
    </out-parameters>
    <actions>
        <!-- Decode JWT -->
        <script>
            def jwtData = ec.web.jwtVerify(jwtToken)
            context.tenantPartyId = jwtData.tenantPartyId
            context.shippingGatewayConfigId = jwtData.shippingGatewayConfigId
        </script>

        <!-- Fetch ShippingGatewayConfig -->
        <entity-find entity-name="ShippingGatewayConfig" single="true">
            <econdition field-name="shippingGatewayConfigId" value="${shippingGatewayConfigId}"/>
            <econdition field-name="tenantPartyId" value="${tenantPartyId}"/>
            <field-map field="getRateServiceName" to="rateService"/>
        </entity-find>

        <!-- Fetch SystemMessageRemote and Gateway Options -->
        <set field="gatewayOptions" from="co.hotwax.helper.ShippingAggregatorHelper.getShippingGatewayConfigOptions(ec, shippingGatewayConfigId)"/>
        <set field="gatewaySettings" from="co.hotwax.helper.ShippingAggregatorHelper.getSystemMessageRemoteSettings(ec, tenantPartyId, shippingGatewayConfigId)"/>

        <!-- Transform input to gateway-specific format -->
        <service-call name="transform#toGatewayRateRequest" in-map="shipmentRequest" out-map="transformedRequest">
            <override field="gatewayOptions" value="${gatewayOptions}"/>
            <override field="gatewaySettings" value="${gatewaySettings}"/>
        </service-call>

        <!-- Call carrier-specific service -->
        <service-call name="${rateService}" in-map="transformedRequest" out-map="rawGatewayResponse"/>

        <!-- Transform gateway response to standard format -->
        <service-call name="transform#fromGatewayRateResponse" in-map="rawGatewayResponse" out-map="responseMap"/>
    </actions>
</service>
```

---

### ✅ Key Considerations
- Each carrier gateway will respond using its own schema. You must implement a transformation step to normalize the response into a consistent structure before returning to the OMS.
- You must implement transformation logic per carrier to map your standard payload to their native API format.
- This architecture supports adding new carriers easily by simply defining their own transform and getRate services.
- JWT must be validated and signed by your own auth mechanism.
