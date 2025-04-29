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
<service name="request#ShippingLabels" location="component://shipping-gateway/service/shipping/ShippingServices.xml" auth="true">
    <description>Request shipping labels from carrier gateway</description>

    <in-parameters>
        <parameter name="shipmentMethodTypeId" type="String" required="true"/>
        <parameter name="carrierPartyId" type="String" required="true"/>
        <parameter name="serviceLevel" type="String" required="true"/>
        <parameter name="estimatedShipDate" type="Timestamp" required="true"/>

        <parameter name="referenceNumber" type="String" optional="true"/>
        <parameter name="handlingInstructions" type="String" optional="true"/>
        <parameter name="insuranceAmountUsd" type="BigDecimal" optional="true"/>
        <parameter name="currencyCode" type="String" optional="true"/>
        <parameter name="pickupRequired" type="Boolean" optional="true"/>
        <parameter name="estimatedDeliveryDate" type="Timestamp" optional="true"/>

        <parameter name="codAmount" type="BigDecimal" optional="true"/>
        <parameter name="codCurrencyCode" type="String" optional="true"/>
        <parameter name="codPaymentMethod" type="String" optional="true"/>

        <parameter name="shippingChargesPayment" type="Map" optional="true">
            <parameter name="paymentType" type="String" required="true"/>
            <parameter name="accountNumber" type="String" optional="true"/>
        </parameter>

        <parameter name="labelSpecification" type="Map" optional="true">
            <parameter name="labelFormat" type="String" required="true"/>
            <parameter name="labelStockType" type="String" required="true"/>
        </parameter>

        <parameter name="shipFrom" type="Map" required="true">
            <parameter name="facilityId" type="String" optional="true"/>
            <parameter name="facilityName" type="String" optional="true"/>
            <parameter name="address" type="Map" required="true">
                <parameter name="name" type="String" required="true"/>
                <parameter name="company" type="String" optional="true"/>
                <parameter name="phone" type="String" required="true"/>
                <parameter name="email" type="String" optional="true"/>
                <parameter name="addressLine1" type="String" required="true"/>
                <parameter name="addressLine2" type="String" optional="true"/>
                <parameter name="city" type="String" required="true"/>
                <parameter name="stateProvince" type="String" required="true"/>
                <parameter name="postalCode" type="String" required="true"/>
                <parameter name="countryCode" type="String" required="true"/>
            </parameter>
        </parameter>

        <parameter name="shipTo" type="Map" required="true">
            <parameter name="address" type="Map" required="true">
                <parameter name="name" type="String" required="true"/>
                <parameter name="company" type="String" optional="true"/>
                <parameter name="phone" type="String" required="true"/>
                <parameter name="email" type="String" optional="true"/>
                <parameter name="addressLine1" type="String" required="true"/>
                <parameter name="addressLine2" type="String" optional="true"/>
                <parameter name="city" type="String" required="true"/>
                <parameter name="stateProvince" type="String" required="true"/>
                <parameter name="postalCode" type="String" required="true"/>
                <parameter name="countryCode" type="String" required="true"/>
            </parameter>
        </parameter>

        <parameter name="packages" type="List" required="true">
            <parameter name="packageMap" type="Map">
                <parameter name="packageCode" type="String" required="true"/>
                <parameter name="shipmentBoxTypeId" type="String" required="true"/>
                <parameter name="weight" type="BigDecimal" required="true"/>
                <parameter name="weightUomId" type="String" required="true"/>
                <parameter name="boxLength" type="BigDecimal" required="true"/>
                <parameter name="boxWidth" type="BigDecimal" required="true"/>
                <parameter name="boxHeight" type="BigDecimal" required="true"/>
                <parameter name="dimensionUomId" type="String" required="true"/>

                <parameter name="items" type="List" optional="true">
                    <parameter name="itemMap" type="Map">
                        <parameter name="productId" type="String" required="true"/>
                        <parameter name="quantity" type="BigDecimal" required="true"/>
                        <parameter name="description" type="String" optional="true"/>
                        <parameter name="unitWeight" type="BigDecimal" optional="true"/>
                        <parameter name="unitWeightUomId" type="String" optional="true"/>
                        <parameter name="unitValue" type="BigDecimal" optional="true"/>
                        <parameter name="unitValueCurrency" type="String" optional="true"/>
                    </parameter>
                </parameter>
            </parameter>
        </parameter>
    </in-parameters>

    <out-parameters>
        <parameter name="shippingLabelList" type="List" optional="true"/>
        <parameter name="trackingNumberList" type="List" optional="true"/>
    </out-parameters>

    <actions>
        <set field="shippingGatewayConfig" from="ec.context.shippingGatewayConfig"/>
        <if condition="!shippingGatewayConfig">
            <return error="true" message="Shipping Gateway configuration not found."/>
        </if>

        <log message="Received shipment request: ${parameters}" level="info"/>

        <script>
            // Optional validation: check essential fields
            // Example: if (!parameters.shipFrom || !parameters.shipTo || !parameters.packages) return error
        </script>

        <service-call name="yourCarrierAdapterService#transformAndSendShipmentRequest"
                      in-map="parameters" out-map="carrierResponse"/>

        <set field="shippingLabelList" from="carrierResponse.shippingLabelList"/>
        <set field="trackingNumberList" from="carrierResponse.trackingNumberList"/>
    </actions>
</service>
```

---

### ✅ Key Considerations
- Each gateway has its own label schema and response structure.
- Transformation logic must be implemented per gateway to adapt input and output.
- Authentication tokens and environment URLs are stored in `SystemMessageRemote`.
- Adding a new carrier only requires new transform + gateway service definitions.

