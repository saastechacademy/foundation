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

### JSON Payload for requestShippingLabel

```json
{
  "shipmentMethodTypeId": "STANDARD",
  "carrierPartyId": "FEDEX",
  "serviceLevel": "FEDEX_GROUND",
  "estimatedShipDate": "2025-03-26",

  // --- Optional shipment-level fields ---
  "referenceNumber": "ORDER-45678",               // Optional: Client's internal shipment reference
  "handlingInstructions": "Leave at side door.",   // Optional: Special carrier instructions
  "insuranceAmountUsd": 200.00,                    // Optional: Declared insurance value
  "currencyCode": "USD",                            // Optional: Currency for declared values
  "pickupRequired": false,                         // Optional: True if requesting pickup
  "estimatedDeliveryDate": "2025-03-30",            // Optional: Requested delivery date

  // --- Optional COD fields ---
  "codAmount": 150.00,                              // Optional: Amount to collect on delivery
  "codCurrencyCode": "USD",                         // Optional: Currency for COD amount
  "codPaymentMethod": "CASH",                       // Optional: Payment type accepted (CASH, CHECK, MONEY_ORDER)

  // --- Optional payment and label specification fields ---
  "shippingChargesPayment": {
    "paymentType": "SENDER",                       // Common case: Sender pays shipping charges
    "accountNumber": "789456123"                   // Optional: Sender's FedEx/Carrier account number
  },
  "labelSpecification": {
    "labelFormat": "PDF",                          // Label output format (PDF, ZPLII, EPL2, PNG)
    "labelStockType": "PAPER_4X6"                  // Label size (PAPER_4X6, etc.)
  },
  // ---------------------------------------

  "shipFrom": {
    "facilityId": "BROADWAY",
    "facilityName": "Broadway Warehouse",
    "address": {
      "name": "Broadway Fulfillment Center",
      "company": "Company Inc",
      "phone": "123-456-7890",
      "email": "warehouse@company.com",
      "addressLine1": "123 Broadway St",
      "addressLine2": "Suite 200",
      "city": "New York",
      "stateProvince": "NY",
      "postalCode": "10001",
      "countryCode": "US"
    }
  },

  "shipTo": {
    "address": {
      "name": "John Doe",
      "company": "Doe Enterprises",
      "phone": "987-654-3210",
      "email": "john.doe@example.com",
      "addressLine1": "789 Market St",
      "addressLine2": null,
      "city": "San Francisco",
      "stateProvince": "CA",
      "postalCode": "94103",
      "countryCode": "US"
    }
  },

  "packages": [
    {
      "packageCode": "PKG-001",
      "shipmentBoxTypeId": "YOUR_PACKAGING",
      "weight": 0.6614,
      "weightUomId": "WT_lb",
      "boxLength": 15,
      "boxWidth": 10,
      "boxHeight": 5,
      "dimensionUomId": "LEN_in",
      "items": [
        {
          "productId": "10003",
          "quantity": 1,
          "description": "Blue T-shirt",
          "unitWeight": 0.5,
          "unitWeightUomId": "WT_lb",
          "unitValue": 25.00,
          "unitValueCurrency": "USD"
        },
        {
          "productId": "10004",
          "quantity": 1,
          "description": "Red Hat",
          "unitWeight": 0.3,
          "unitWeightUomId": "WT_lb",
          "unitValue": 20.00,
          "unitValueCurrency": "USD"
        }
      ]
    }
  ]
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

