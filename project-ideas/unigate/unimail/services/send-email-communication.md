# `send#EmailCommunication`

This is the primary service interface for sending an email via a communication gateway.

## Interface Definition

**Implements:** `co.hotwax.unigate.ApiInterfaceServices.send#EmailCommunication`

### Input Parameters

| Parameter | Type | Required | Description |
|---|---|---|---|
| `commGatewayAuthId` | String | Yes | Identifier for the `CommGatewayAuth` record that stores credentials and baseUrl. |
| `emailType` | String | Yes | The type of email being sent (e.g., `ORDER_COMPLETION`, `READY_FOR_PICKUP`). |
| `subject` | String | Yes | The subject line of the email. |
| `emailAddress` | String | Yes | The recipient's email address. |
| `messageData` | Map | Yes | A comprehensive map containing all order, customer, facility, shipping, billing, item, and adjustment data to be rendered in the email template. |

**`messageData` Details:**
Includes fields like `orderId`, `orderName`, `grandTotal`, `firstName`, `lastName`, and nested maps/lists for `facilityAddress`, `shippingAddress`, `billingAddress`, `items` (with `adjustments`), and order-level `adjustments`.

### Output Parameters

| Parameter | Type | Required | Description |
|---|---|---|---|
| `response` | Map | Yes | The raw response object/map returned by the provider API. |
| `requestBody` | Map | No | The processed request body sent to the provider, useful for logging and debugging. |

## Implementation Responsibility

1. **Load Credentials:** Fetch `CommGatewayAuth` using the provided `commGatewayAuthId`.
2. **Template Rendering:** Render the provider-specific request payload using FreeMarker and the provided `messageData`.
3. **API Call:** Call the provider's API endpoint (e.g., `/send`) to dispatch the email.
4. **Error Handling:** Handle API errors and set `response` accordingly.
