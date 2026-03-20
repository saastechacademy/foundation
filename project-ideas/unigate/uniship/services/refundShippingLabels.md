
# refund#ShippingLabels service design

---

## Overview

This service cancels or voids a previously generated shipping label by invoking the corresponding refund API offered by the carrier or gateway. It is useful when the customer cancels the order, the label is generated in error, or the shipment must be voided before fulfillment.

---

## Supported Carriers

### ✅ API Schema Validation Summary

Based on the official refund/cancellation API documentation of each integrated shipping carrier, the current API schema supports all required identifiers needed for label refunds.

| Carrier     | Required for Refund | Required Parameter(s)        | Matches UniShip Schema? | Notes |
|-------------|----------------------|-------------------------------|--------------------------|-------|
| **FedEx**   | ✅ Yes               | `trackingNumber`             | ✅ Yes                   | [FedEx Cancel API](https://developer.fedex.com/api/en-us/catalog/ship/v1/docs.html#operation/Create%20Shipment) - uses tracking number for cancellation |
| **UPS**     | ✅ Yes               | `trackingNumber`             | ✅ Yes                   | [UPS Void Shipment API](https://developer.ups.com/api/reference?loc=en_US&tag=Shipping) - requires tracking number (1Z...) |
| **Shippo**  | ✅ Yes               | `labelId`                    | ✅ Yes                   | [Shippo Refund API](https://goshippo.com/docs/reference#refunds) - refund by label (transaction) ID |
| **EasyPost**| ✅ Yes               | `shipmentId`                 | ✅ Yes                   | [EasyPost Refund API](https://docs.easypost.com/docs/shipments/shipping-refund) - requires shipment ID |
| **ShipHawk**| ✅ Yes (via cancel)  | `shipmentId`                 | ✅ Yes                   | [ShipHawk Cancel API](https://apidocs.shiphawk.com/#cancel-a-shipment) - no direct refund API, uses cancel shipment instead |

➡️ At least one of the fields — `shipmentId`, `labelId`, or `trackingNumber` — is required depending on the gateway. The API is designed to provide all three as optional inputs.

### 🔍 Parameter Support Across Gateways

| Parameter        | FedEx | UPS | Shippo | EasyPost | ShipHawk | Notes |
|------------------|:-----:|:---:|:------:|:--------:|:--------:|-------|
| `shipmentId`     |  ✗    | ✗   | ✅     | ✅       | ✅       | Required by Shippo, EasyPost, and ShipHawk for refunds or cancellations |
| `labelId`        |  ✗    | ✗   | ✅     | ✗        | ✗        | Required for Shippo refund endpoint (`POST /refunds`) |
| `trackingNumber` | ✅    | ✅  | ✗     | ✗        | ✗        | Used for native carrier refund APIs (FedEx, UPS) |
| `carrier`        | ✅    | ✅  | ✅     | ✅       | ✅       | Always needed to select adapter logic |
| `reason`         | Optional | Optional | Optional | Optional | Optional | Not required by carriers but logged by OMS/gateway |

---

## Request JSON Schema

```json
{
  "shipmentId": "SHIPMENT123",
  "trackingNumber": "1Z12345E6205277936",
  "labelId": "LBL123456",
  "carrier": "UPS",
  "reason": "Customer cancelled order"
}
```

> Only one of `labelId`, `shipmentId`, or `trackingNumber` may be required depending on the carrier.

---

## Service Definition

```xml
    <service verb="refund" noun="ShippingLabels">
   <description>Cancel or refund a shipping label</description>

   <in-parameters>
      <parameter name="shipmentId" type="String" required="false"/>
      <parameter name="labelId" type="String" required="false"/>
      <parameter name="trackingNumber" type="String" required="false"/>
      <parameter name="carrier" type="String" required="true"/>
      <parameter name="reason" type="String" required="false"/>
   </in-parameters>

   <out-parameters>
      <parameter name="status" type="String" required="false"/>
      <parameter name="message" type="String" required="false"/>
      <parameter name="carrierResponse" type="Map" required="false"/>
   </out-parameters>

   <actions>
      <set field="shippingGatewayConfig" from="ec.context.shippingGatewayConfig"/>
      <if condition="!shippingGatewayConfig">
         <return error="true" message="Shipping Gateway configuration not found."/>
      </if>

      <service-call name="transform#toGatewayLabelRefundRequest"
                    in-map="parameters" out-map="gatewayRequest"/>

      <service-call name="${shippingGatewayConfig.getRefundServiceName}"
                    in-map="gatewayRequest" out-map="gatewayResponse"/>

      <service-call name="transform#fromGatewayLabelRefundResponse"
                    in-map="gatewayResponse" out-map="responseMap"/>

      <set field="status" from="responseMap.status"/>
      <set field="message" from="responseMap.message"/>
      <set field="carrierResponse" from="responseMap.carrierResponse"/>
   </actions>
</service>
```

---

## Control Flow

1. Extract carrier and shipment identifiers from input
2. Resolve gateway config using `ec.context.shippingGatewayConfig`
3. Call adapter-specific refund service, e.g.:
   - `co.hotwax.fedex.refund#Label`
   - `co.hotwax.ups.refund#Label`
   - `co.hotwax.shippo.refund#Label`
   - `co.hotwax.easypost.refund#Label`
   - `co.hotwax.shiphawk.cancel#Shipment`
4. Return status, carrier response, and error if any

---

## API Documentation Links

Below are the direct links to refund/cancel label API documentation for each carrier:

- [FedEx - Create/Cancel Shipment](https://developer.fedex.com/api/en-us/catalog/ship/v1/docs.html#operation/Create%20Shipment)
- [UPS - Shipment Processing APIs](https://developer.ups.com/api/reference?loc=en_US&tag=Shipping)
- [Shippo - Refund a Label](https://goshippo.com/docs/reference#refunds)
- [EasyPost - Refund Labels](https://docs.easypost.com/docs/shipments/shipping-refund)
- [ShipHawk - Cancel a Shipment](https://apidocs.shiphawk.com/#cancel-a-shipment)

---

## Next Steps

- Add refund capability to each gateway adapter
- Write integration tests to verify correct refund behavior
- Update OMS error handling for rejected refunds
