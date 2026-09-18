# `send#EmailCommunication`

This is the canonical UniMail API for sending an order transactional email or triggering a provider workflow.

## REST Endpoint

```http
POST /rest/s1/unigate/communication/email
Content-Type: application/json
api_key: <tenant-api-key>
tenant_Id: <tenant-party-id>
```

`api_key` authenticates the caller. `tenant_Id` scopes the request to the tenant that owns the referenced `CommGatewayAuth` record.

```bash
curl --fail-with-body --request POST \
  "${UNIGATE_API_ROOT}/communication/email" \
  --header "Content-Type: application/json" \
  --header "api_key: ${UNIGATE_API_KEY}" \
  --header "tenant_Id: ${UNIGATE_TENANT_ID}" \
  --data '{
    "commGatewayAuthId": "PARTNER_TEST",
    "emailType": "READY_FOR_PICKUP",
    "subject": "Your order is ready for pickup",
    "emailAddress": "alex@example.com",
    "messageData": {
      "orderId": "10001",
      "orderName": "WEB-10001",
      "orderDate": "2026-08-11T08:10:00Z",
      "completedDatetime": "",
      "grandTotal": 108.25,
      "firstName": "Alex",
      "lastName": "Morgan",
      "brandName": "Example Store",
      "sandbox": true,
      "isStorePickup": true,
      "facilityAddress": {},
      "shippingAddress": {},
      "billingAddress": {},
      "items": [],
      "allItems": [],
      "adjustments": [],
      "additionalFields": {}
    }
  }'
```

`UNIGATE_API_ROOT` is the API root, for example `https://unigate.example.com/rest/s1/unigate`.

## Interface Definition

**Implements:** `co.hotwax.unigate.ApiInterfaceServices.send#EmailCommunication`

### Top-Level Input

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| `commGatewayAuthId` | string | Yes | Identifies the tenant's endpoint and credential record. |
| `emailType` | string | Yes | Configured order event key, such as `READY_FOR_PICKUP`. |
| `subject` | string | Yes | Configured email subject or provider event label. |
| `emailAddress` | string | Yes | Recipient or customer identity for the event. |
| `messageData` | object | Yes | Canonical order, customer, address, item, and adjustment data. |

### Order and Customer Data

| `messageData` field | Type | Description |
| --- | --- | --- |
| `orderId` | string | Internal order identifier. |
| `orderName` | string | Customer-facing order name or number. |
| `orderDate` | string | Serialized order timestamp. |
| `completedDatetime` | string | Serialized completion timestamp when applicable. |
| `orderStatusUrl` | string | Customer order-status link when configured. |
| `orderUpdateUrl` | string | Customer self-service update link when configured. |
| `grandTotal` | number | Event-scope order total. |
| `firstName`, `lastName` | string | Customer name. |
| `brandName` | string | Retailer display name. |
| `sandbox` | boolean | Whether the event is a test event. |
| `isStorePickup` | boolean | Whether the event includes a store-pickup item. |
| `additionalFields` | object | Event-specific extension data; keys vary by `emailType`. |

### Addresses

`facilityAddress`, `shippingAddress`, and `billingAddress` are optional maps. Address maps can contain:

| Field | Applies to |
| --- | --- |
| `toName`, `address1`, `address2`, `city`, `stateProvinceGeoId`, `postalCode`, `countryGeoId`, `phoneNumber` | All address types |
| `facilityName`, `latitude`, `longitude` | Facility address |

Missing address data can be omitted or represented as an empty object.

### Items

`items` is the event-scoped subset. `allItems` contains the complete order item list and is useful for split-shipment or partial-cancellation templates.

Each item can contain:

| Field | Type | Description |
| --- | --- | --- |
| `productId`, `shipGroupSeqId` | string | Product and fulfillment group identifiers. |
| `color`, `size` | string | Variant attributes. |
| `quantity`, `unitPrice` | number | Item quantity and unit price. |
| `itemDescription`, `productName` | string | Display descriptions. |
| `productImageUrl`, `parentProductImageUrl`, `itemUrl` | string | Product links. |
| `itemStatus` | string | OMS item status ID. |
| `shipmentMethodTypeId` | string | Fulfillment or shipment method. |
| `trackingUrl`, `trackingCode` | string | Shipment tracking data when available. |
| `shipFromAddress` | object | Origin facility address for this item. |
| `adjustments` | array | Item-level charge, tax, and discount records. |

### Adjustments

Order-level `messageData.adjustments` and item-level `adjustments` use the same shape:

| Field | Type | Description |
| --- | --- | --- |
| `orderAdjustmentTypeId` | string | OMS adjustment type ID. |
| `amount` | number | Signed adjustment amount. |
| `comments` | string | Optional label or source detail. |

## Response

The service returns the gateway response and may include the rendered provider request:

```json
{
  "response": {
    "statusCode": 202,
    "response": ""
  },
  "requestBody": {}
}
```

The inner response body is provider-specific. Callers must inspect `response.statusCode`; an outer REST `2xx` does not by itself prove that the downstream provider accepted the event.

## Routing and Error Handling

1. `TenantAuthFilter` validates `api_key` and `tenant_Id`.
2. `CommunicationServices.send#EmailCommunication` loads `CommGatewayAuth` by `commGatewayAuthId`.
3. It loads `CommGatewayConfig` and resolves `sendEmailServiceName`.
4. The configured in-process adapter transforms and sends the request.
5. The adapter returns its downstream status and response.

Stable routing errors include:

| Condition | Result |
| --- | --- |
| Missing or invalid authentication headers | HTTP `401` |
| Unknown `commGatewayAuthId` | `No valid gateway auth config found for tenant` |
| Missing gateway configuration | `Email gateway configuration not found` |
| Missing `sendEmailServiceName` | `Gateway config is missing sendEmailServiceName service name` |

HTTP clients in the OMS and installed adapters can retry transport failures. Receivers must tolerate duplicate events.

## Related Documents

- [External partner integration](../external-order-email-integration.md)
- [UniMail overview](../readme.md)
- [Tenant authentication](../../tenant-auth-filter.md)
