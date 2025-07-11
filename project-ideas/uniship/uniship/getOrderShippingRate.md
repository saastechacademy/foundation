# get#OrderShippingRate service design

---

## Service Purpose

The `get#OrderShippingRate` service is a front-facing gateway microservice API that calculates shipping rates for a fully specified shipment. It supports multi-tenant architecture and allows each tenant to route requests to their configured shipping gateway implementation (e.g., FedEx, UPS, Shippo).

This service **does not** perform the transformation or direct integration with the external shipping API. That responsibility is delegated to the **gateway-specific implementation service**, which must also implement the same service interface defined in `ApiInterfaceServices.xml`.

---

## Key Responsibilities

* Validate presence of required parameters: `tenantPartyId`, `shippingGatewayConfigId`, `shipFrom`, `shipTo`, `packages`.
* Ensure that the provided gateway config (`shippingGatewayConfigId`) is authorized for the given tenant (`tenantPartyId`) via a valid `ShippingGatewayAuthConfig`.
* Resolve the `ShippingGatewayConfig` entity to find the gateway-specific implementation service name.
* Pass the full input to the resolved service for carrier-specific rate calculation.
* Return normalized `rateInfoList` response to the caller.

---

## Input Parameters

The service accepts a deeply nested JSON object containing:

* **Cross-cutting**:

  * `tenantPartyId` (String, required)
  * `shippingGatewayConfigId` (String, required)
* **Shipment configuration**:

  * `shipmentMethodTypeId` (String)
  * `serviceLevel` (String)
  * `shipFrom` (Map: includes `facilityId`, `facilityName`, `address`)
  * `shipTo` (Map: includes `address`)
  * `packages` (List: includes box info and items)
  * `referenceNumbers`, `accessorials`, `pickupWindow`, `applyPolicies`

---

## Output

* `rateInfoList` (List of available rates for the shipment)
* Possible `error` response with descriptive `message`

---

## Security and Validation

1. **Tenant Validation**

   * Entity: `co.hotwax.uniship.ShippingGatewayAuthConfig`
   * Lookup using:

     * `tenantId = tenantPartyId`
     * `shippingGatewayConfigId`
   * Must find at least one valid record (validity check via `fromDate`/`thruDate`).

2. **Gateway Resolution**

   * Entity: `co.hotwax.uniship.ShippingGatewayConfig`
   * Used to retrieve implementation-specific service name:

     * `getRateServiceName` (e.g. co.hotwax.fedex.FedexServices.get#ShippingRate)

---

## Control Flow

```plaintext
→ Receive request with shipment + tenant/gateway context
→ Validate required fields (tenantPartyId, shippingGatewayConfigId, shipFrom, shipTo, packages)
→ Lookup auth config (ShippingGatewayAuthConfig)
→ Lookup gateway config (ShippingGatewayConfig)
→ Resolve target service name from getRateServiceName
→ Call gateway-specific implementation with same input
→ Receive and return normalized rateInfoList
```

---

## Interface Contract

This service **implements** the interface defined in `ApiInterfaceServices.xml`:

```xml
<service verb="get" noun="ShippingRate" type="interface">
```

All gateway-specific services must also implement this interface to ensure input/output compatibility.

---

## Service Implementation Responsibilities

| Concern                | Front-facing service      | Gateway-specific service      |
| ---------------------- | ------------------------- | ----------------------------- |
| Parameter validation   | ✅ Basic structure present | ✅ Carrier-specific validation |
| Auth + config lookup   | ✅ Required                | ❌ Already done                |
| Request transformation | ❌                         | ✅                             |
| Carrier API call       | ❌                         | ✅                             |
| Response normalization | ❌                         | ✅                             |

---

## Dependencies

* `co.hotwax.uniship.ShippingGatewayAuthConfig`
* `co.hotwax.uniship.ShippingGatewayConfig`
* All gateway-specific services returned by `getRateServiceName`

---

## Error Conditions

* ❌ Missing `tenantPartyId` or `shippingGatewayConfigId`
* ❌ No `ShippingGatewayAuthConfig` found for tenant
* ❌ No `ShippingGatewayConfig` found for config ID
* ❌ Downstream service error (propagated from implementation)

---

## Service Definition

```xml
<services xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xsi:noNamespaceSchemaLocation="https://moqui.org/xsd/service-definition-3.xsd">

    <service verb="get" noun="OrderShippingRate">
        <description>Calculate shipping rate for a complete order</description>

        <in-parameters>
            <parameter name="tenantPartyId" type="String" required="true"/>
            <parameter name="shippingGatewayConfigId" type="String" required="true"/>
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
            <entity-find entity-name="co.hotwax.uniship.ShippingGatewayAuthConfig" value-field="authConfig">
                <econdition field="tenantId" from="tenantPartyId"/>
                <econdition field="shippingGatewayConfigId" from="shippingGatewayConfigId"/>
                <order-by field="fromDate"/>
            </entity-find>

            <if condition="!authConfig">
                <return error="true" message="Unauthorized: No auth configuration found for tenant and gateway config."/>
            </if>

            <entity-find entity-name="co.hotwax.uniship.ShippingGatewayConfig" value-field="shippingGatewayConfig">
                <econdition field="shippingGatewayConfigId" from="shippingGatewayConfigId"/>
            </entity-find>

            <if condition="!shippingGatewayConfig">
                <return error="true" message="Shipping Gateway configuration not found."/>
            </if>

            <service-call name="${shippingGatewayConfig.getRateServiceName}"
                          in-map="parameters" out-map="responseMap"/>

            <set field="rateInfoList" from="responseMap.rateInfoList"/>
        </actions>
    </service>

</services>
```

---

## Example Usage

```bash
POST /rest/s1/uniship/shipment/rate
```

### Sample JSON Input

```json
{
  "tenantPartyId": "HOTWAX_RETAILER",
  "shippingGatewayConfigId": "SHIPPO_GATEWAY_CONFIG",
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
