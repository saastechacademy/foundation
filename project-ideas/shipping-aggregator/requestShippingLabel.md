## 🚀 Architecture: requestShippingLabel API in Multitenant Shipping Gateway Microservice

This document outlines the architecture and control flow for handling `requestShippingLabel` API requests in the multitenant shipping gateway microservice built on the Moqui framework.

---

### 🎯 Responsibilities
- Accept standard JSON input from an OMS for label generation.
- Extract tenant and shipping gateway config from JWT.
- Load the correct configuration and credentials.
- Transform request into carrier-specific format.
- Call the correct carrier label service.
- Normalize the response to a consistent format and return to OMS.

---

### 📦 OMS Request Payload (Simplified)
```json
{
  "carrierPartyId": "FEDEX",
  "carrierAccountId": "123456",
  "shipmentPackages": [ ... ],
  "shipFromAddress": { "name": "Warehouse A", ... },
  "shipToAddress": { "name": "Customer B", ... },
  "imageType": "PDF",
  "pickupType": "DROPOFF_AT_FEDEX_LOCATION"
}
```

---

### 🧠 Control Flow Diagram
```
 OMS Request JSON
       │
       ▼
+----------------------+
| Facade Service       |
| (request#ShippingLabel) |
+----------------------+
       │
       ▼
Parse JWT (tenant + config)
       │
       ▼
Fetch ShippingGatewayConfig (requestLabelsServiceName)
       │
       ▼
Fetch SystemMessageRemote + Options
       │
       ▼
+----------------------------+
| ✨ Transform Input Map      | ← per carrier
| (standard → gateway format) |
+----------------------------+
       │
       ▼
Call carrier-specific requestLabel service
       │
       ▼
+-------------------------------+
| 🔁 Transform Response Format  | ← per carrier
| (gateway → standard format)  |
+-------------------------------+
       │
       ▼
Return label + tracking info to OMS
```

---

### 🔧 Moqui Service Outline
```xml
<service verb="request" noun="ShippingLabel" allow-remote="true">
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
            <field-map field="requestLabelsServiceName" to="labelService"/>
        </entity-find>

        <!-- Fetch SystemMessageRemote and Gateway Options -->
        <set field="gatewayOptions" from="co.hotwax.helper.ShippingAggregatorHelper.getShippingGatewayConfigOptions(ec, shippingGatewayConfigId)"/>
        <set field="gatewaySettings" from="co.hotwax.helper.ShippingAggregatorHelper.getSystemMessageRemoteSettings(ec, tenantPartyId, shippingGatewayConfigId)"/>

        <!-- Transform input to gateway-specific format -->
        <service-call name="transform#toGatewayLabelRequest" in-map="shipmentRequest" out-map="transformedRequest">
            <override field="gatewayOptions" value="${gatewayOptions}"/>
            <override field="gatewaySettings" value="${gatewaySettings}"/>
        </service-call>

        <!-- Call carrier-specific service -->
        <service-call name="${labelService}" in-map="transformedRequest" out-map="rawGatewayResponse"/>

        <!-- Transform gateway response to standard format -->
        <service-call name="transform#fromGatewayLabelResponse" in-map="rawGatewayResponse" out-map="responseMap"/>
    </actions>
</service>
```

---

### ✅ Key Considerations
- Each gateway has its own label schema and response structure.
- Transformation logic must be implemented per gateway to adapt input and output.
- Authentication tokens and environment URLs are stored in `SystemMessageRemote`.
- Adding a new carrier only requires new transform + gateway service definitions.

