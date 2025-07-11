# requestShippingLabel service design

This document outlines the architecture and control flow for handling `requestShippingLabel` API requests.

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
    <service verb="request" noun="ShippingLabels">
    <description>Request a shipping label from the configured carrier</description>

    <in-parameters>
        <parameter name="shipmentId" type="String" required="true"/>
        <parameter name="carrierPartyId" type="String" required="true"/>
        <parameter name="shipmentMethodTypeId" type="String" required="true"/>

        <parameter name="shipFrom" type="Map" required="true">
            <parameter name="address" type="Map" required="true">
                <parameter name="name" type="String" required="true"/>
                <parameter name="company" type="String" required="false"/>
                <parameter name="phone" type="String" required="true"/>
                <parameter name="email" type="String" required="false"/>
                <parameter name="addressLine1" type="String" required="true"/>
                <parameter name="addressLine2" type="String" required="false"/>
                <parameter name="city" type="String" required="true"/>
                <parameter name="stateProvince" type="String" required="true"/>
                <parameter name="postalCode" type="String" required="true"/>
                <parameter name="countryCode" type="String" required="true"/>
                <parameter name="isResidential" type="Boolean" required="false"/>
            </parameter>
        </parameter>

        <parameter name="shipTo" type="Map" required="true">
            <parameter name="address" type="Map" required="true">
                <parameter name="name" type="String" required="true"/>
                <parameter name="company" type="String" required="false"/>
                <parameter name="phone" type="String" required="true"/>
                <parameter name="email" type="String" required="false"/>
                <parameter name="addressLine1" type="String" required="true"/>
                <parameter name="addressLine2" type="String" required="false"/>
                <parameter name="city" type="String" required="true"/>
                <parameter name="stateProvince" type="String" required="true"/>
                <parameter name="postalCode" type="String" required="true"/>
                <parameter name="countryCode" type="String" required="true"/>
                <parameter name="isResidential" type="Boolean" required="false"/>
            </parameter>
        </parameter>

        <parameter name="packages" type="List" required="true">
            <parameter name="entry" type="Map">
                <parameter name="trackingNumber" type="String" required="false"/>
                <parameter name="shipmentPackageSeqId" type="String" required="true"/>
                <parameter name="weight" type="BigDecimal" required="true"/>
                <parameter name="weightUomId" type="String" required="true"/>
                <parameter name="boxLength" type="BigDecimal" required="true"/>
                <parameter name="boxWidth" type="BigDecimal" required="true"/>
                <parameter name="boxHeight" type="BigDecimal" required="true"/>
                <parameter name="dimensionUomId" type="String" required="true"/>
            </parameter>
        </parameter>

        <parameter name="referenceNumbers" type="List" required="false">
            <parameter name="entry" type="Map">
                <parameter name="type" type="String" required="true"/>
                <parameter name="value" type="String" required="true"/>
            </parameter>
        </parameter>

        <parameter name="labelSpec" type="Map" required="false">
            <parameter name="format" type="String" required="false"/>
            <parameter name="size" type="String" required="false"/>
        </parameter>
    </in-parameters>

    <out-parameters>
        <parameter name="shippingLabels" type="List" required="false"/>
    </out-parameters>

    <actions>
        <set field="shippingGatewayConfig" from="ec.context.shippingGatewayConfig"/>
        <if condition="!shippingGatewayConfig">
            <return error="true" message="Shipping Gateway configuration not found."/>
        </if>

        <service-call name="transform#toGatewayLabelRequest"
                      in-map="parameters" out-map="gatewayRequest"/>

        <service-call name="${shippingGatewayConfig.getLabelServiceName}"
                      in-map="gatewayRequest" out-map="gatewayResponse"/>

        <service-call name="transform#fromGatewayLabelResponse"
                      in-map="gatewayResponse" out-map="responseMap"/>

        <set field="shippingLabels" from="responseMap.shippingLabels"/>
    </actions>
</service>
```

---

### ✅ Key Considerations
- Each gateway has its own label schema and response structure.
- Transformation logic must be implemented per gateway to adapt input and output.
- Authentication tokens and environment URLs are stored in `SystemMessageRemote`.
- Adding a new carrier only requires new transform + gateway service definitions.

