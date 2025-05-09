# Get Order Shipping Rate

---

## Overview

This document defines the request structure for the `get#OrderShippingRate` service in the Shipping Gateway Microservice. It calculates shipping rates for a complete order based on provided address and package details using nested JSON structures.

The OMS will call this service with a fully resolved shipment payload. The microservice will:

1. Verify JWT for tenant and gateway config.
2. Retrieve injected `ShippingGatewayConfig`.
3. Validate and transform the request into carrier-specific rate query format.
4. Call the carrier/gateway rate API.
5. Normalize and return `rateInfoList` to the OMS.

---

## JSON Input Structure

```json
{
  "shipmentMethodTypeId": "STANDARD",
  "serviceLevel": "GROUND",
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
      "countryCode": "US",
      "isResidential": false,
      "isPoBox": false
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
      "countryCode": "US",
      "isResidential": true,
      "isPoBox": false
    }
  },
  "packages": [
    {
      "shipmentBoxTypeId": "YOUR_PACKAGING",
      "weight": 2.5,
      "weightUomId": "WT_lb",
      "boxLength": 10,
      "boxWidth": 5,
      "boxHeight": 8,
      "dimensionUomId": "LEN_in",
      "items": [
        {
          "productId": "10003",
          "quantity": 2,
          "description": "Blue T-shirt",
          "unitWeight": 0.5,
          "unitWeightUomId": "WT_lb",
          "unitValue": 25.00,
          "unitValueCurrency": "USD"
        }
      ]
    }
  ],
  "referenceNumbers": [
    { "type": "ORDER", "value": "ORD-45678" }
  ],
  "accessorials": [
    { "type": "LIFT_GATE", "value": "true", "optionValue": "" }
  ],
  "pickupWindow": {
    "startTime": "2025-05-01T09:00:00Z",
    "endTime": "2025-05-01T17:00:00Z"
  },
  "applyPolicies": true
}
```

---

## Field Value Guidelines

| Field                | Allowed Values                              | Default When Omitted |
| -------------------- | ------------------------------------------- | -------------------- |
| shipmentMethodTypeId | STANDARD, EXPRESS, OVERNIGHT                | STANDARD             |
| serviceLevel         | Carrier-specific codes (e.g., GROUND, 2DAY) | Carrier default      |
| isResidential        | true, false                                 | false                |
| isPoBox              | true, false                                 | false                |
| accessorials[].type  | LIFT\_GATE, INSIDE\_DELIVERY, etc.          | none                 |
| includePolicies      | true, false                                 | false                |

---

## Control Flow

1. Decode and verify JWT (extract `tenantPartyId`, `shippingGatewayConfigId`).
2. Access `ShippingGatewayConfig` from `ec.context`.
3. Validate required fields (`shipFrom`, `shipTo`, `packages`).
4. Call `transform#toGatewayRateRequest` to build carrier payload.
5. Invoke carrier rate service via `${shippingGatewayConfig.getRateServiceName}`.
6. Call `transform#fromGatewayRateResponse` to normalize rates.
7. Return `rateInfoList` array to the OMS.

---

## Service Definition

```xml
<?xml version="1.0" encoding="UTF-8"?>
<services xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xsi:noNamespaceSchemaLocation="https://moqui.org/xsd/service-definition-3.xsd">

    <service verb="get" noun="OrderShippingRate">
        <description>Calculate shipping rate for a complete order</description>

        <in-parameters>
            <parameter name="shipmentMethodTypeId" type="String" required="true"/>
            <parameter name="serviceLevel" type="String" required="true"/>

            <parameter name="shipFrom" type="Map" required="true">
                <parameter name="facilityId" type="String" required="false"/>
                <parameter name="facilityName" type="String" required="false"/>
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
                    <parameter name="isPoBox" type="Boolean" required="false"/>
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
                    <parameter name="isPoBox" type="Boolean" required="false"/>
                </parameter>
            </parameter>

            <parameter name="packages" type="List" required="true">
                <parameter name="entry" type="Map">
                    <parameter name="shipmentBoxTypeId" type="String" required="true"/>
                    <parameter name="weight" type="BigDecimal" required="true"/>
                    <parameter name="weightUomId" type="String" required="true"/>
                    <parameter name="boxLength" type="BigDecimal" required="true"/>
                    <parameter name="boxWidth" type="BigDecimal" required="true"/>
                    <parameter name="boxHeight" type="BigDecimal" required="true"/>
                    <parameter name="dimensionUomId" type="String" required="true"/>
                    <parameter name="items" type="List" required="false">
                        <parameter name="entry" type="Map">
                            <parameter name="productId" type="String" required="true"/>
                            <parameter name="quantity" type="BigDecimal" required="true"/>
                            <parameter name="description" type="String" required="false"/>
                            <parameter name="unitWeight" type="BigDecimal" required="false"/>
                            <parameter name="unitWeightUomId" type="String" required="false"/>
                            <parameter name="unitValue" type="BigDecimal" required="false"/>
                            <parameter name="unitValueCurrency" type="String" required="false"/>
                        </parameter>
                    </parameter>
                </parameter>
            </parameter>

            <parameter name="referenceNumbers" type="List" required="false">
                <parameter name="entry" type="Map">
                    <parameter name="type" type="String" required="true"/>
                    <parameter name="value" type="String" required="true"/>
                </parameter>
            </parameter>

            <parameter name="accessorials" type="List" required="false">
                <parameter name="entry" type="Map">
                    <parameter name="type" type="String" required="true"/>
                    <parameter name="value" type="String" required="true"/>
                    <parameter name="optionValue" type="String" required="false"/>
                </parameter>
            </parameter>

            <parameter name="pickupWindow" type="Map" required="false">
                <parameter name="startTime" type="Timestamp" required="true" format="yyyy-MM-dd'T'HH:mm:ssX"/>
                <parameter name="endTime" type="Timestamp" required="true" format="yyyy-MM-dd'T'HH:mm:ssX"/>
            </parameter>

            <parameter name="applyPolicies" type="Boolean" required="false"/>
        </in-parameters>

        <out-parameters>
            <parameter name="rateInfoList" type="List" required="false"/>
        </out-parameters>

        <actions>
            <set field="shippingGatewayConfig" from="ec.context.shippingGatewayConfig"/>
            <if condition="!shippingGatewayConfig">
                <return error="true" message="Shipping Gateway configuration not found."/>
            </if>

            <service-call name="transform#toGatewayRateRequest"
                          in-map="parameters" out-map="gatewayRequest"/>

            <service-call name="${shippingGatewayConfig.getRateServiceName}"
                          in-map="gatewayRequest" out-map="gatewayResponse"/>

            <service-call name="transform#fromGatewayRateResponse"
                          in-map="gatewayResponse" out-map="responseMap"/>

            <set field="rateInfoList" from="responseMap.rateInfoList"/>
        </actions>
    </service>

</services>

```

## Carrier Support Matrix

This table shows which request fields are required or supported by major carriers and aggregators:

| Field                | FedEx | UPS | Shippo | EasyPost | ShipHawk | Notes |
|----------------------|:-----:|:---:|:------:|:--------:|:--------:|:-----|
| shipFrom.address     |   ✓   |  ✓  |   ✓    |    ✓     |    ✓     | Residential/PO flags supported |
| shipTo.address       |   ✓   |  ✓  |   ✓    |    ✓     |    ✓     |     |
| packages.weight      |   ✓   |  ✓  |   ✓    |    ✓     |    ✓     |     |
| packages.dimensions  |   ✓   |  ✓  |   ✓    |    ✓     |    ✓     |     |
| referenceNumbers     |   ✓   |  ✓  |   ✓    |    ✓     |    ✓     | Mapped to metadata or refs |
| accessorials         |   ✓   |  ✓  |   ✓    |    ✓     |    ✓     | Liftgate, inside delivery, etc. |
| pickupWindow         |   ✓   |  ✓  |   ✗    |    ✗     |    ✓     | Scheduled pickups |
| applyPolicies        |   ✓   |  ✓  |   ✗    |    ✗     |    ✓     | Carrier rules/policies |

> Fields marked ✗ are not directly supported by that carrier’s API but can be handled via custom logic or defaults.

---

## Carrier Dry-Run Validation

We’ve validated the `get#OrderShippingRate` request structure against live sandbox/test APIs of each carrier and aggregator to ensure complete coverage and correct mapping:

| Carrier     | Endpoint Tested             | Key Observations                                                                                      |
|-------------|-----------------------------|-------------------------------------------------------------------------------------------------------|
| **FedEx**   | `/rate/v1/rates/quotes`     | Requires `shipFrom.address`, `shipTo.address`, `packages` with weight/dims, supports residential flags.           |
| **UPS**     | `/rest/Rate`                | Requires origin/destination, supports `referenceNumbers`, accessorial codes.                              |
| **Shippo**  | `/shipments/rates/`         | Maps `referenceNumbers` to shipment metadata, supports insurance via `insurance_amount`.                 |
| **EasyPost**| `/rates`                    | Supports weight/dimension arrays, `insurance`, `delivery_confirm` options.                              |
| **ShipHawk**| `/rate_requests`            | Fully aligns with our schema, supports all fields including `pickupWindow` and `applyPolicies`.          |

All required fields are accepted by each API; unsupported optional fields (`✗`) can be handled via defaults.

---
```
