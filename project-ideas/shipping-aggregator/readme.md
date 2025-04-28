# Shipping Gateway API Specification

---

## 1. Introduction

The Shipping Gateway Microservice provides a unified API interface for integrating with multiple shipping providers (e.g., FedEx, UPS, Shippo, DHL). It acts as a stateless pass-through system, processing shipment rate, label, and tracking requests without persisting shipment data.

This system supports multi-tenant operations, using a JWT token to identify the tenant and the associated shipping gateway configuration.

---

## 2. Key Requirements

- **Customer/User Management:**  
  Securely manage tenant retailers and their API access through JWT tokens.

- **Unified Shipping API Abstraction:**  
  Integrate with multiple carriers while exposing a single clean API interface to OMS clients.

- **Stateless Shipment Handling:**  
  The Shipping Gateway does not store or persist any shipment data. All data is passed through temporarily.

- **Multi-Tenant Isolation:**  
  Each API call is isolated to a specific retailer tenant based on the JWT token.

- **Reliable Error Management:**  
  Standardized error responses and graceful error handling for communication with carrier APIs.

- **Scalability and Extensibility:**  
  Easily plug new carrier integrations in the future without breaking the API contract.

---

## 3. Entity Model Reference

The Shipping Gateway Microservice uses a lightweight multi-tenant data model.

Key entities:

- **Party** — Represents both tenants (retailers) and shipping carriers.
- **PartyRole** — Distinguishes between Tenant and Carrier parties.
- **ShippingGatewayConfig** — Defines the configuration for each shipping gateway (e.g., FedEx, UPS).
- **SystemMessageRemote** — Stores tenant-specific API credentials securely.

👉 Refer to the full [Entity Model Design](entity-model.md) document for detailed definitions.

---

## 4. Authentication and Authorization

- All API requests require an Authorization header with a JWT token.
- The JWT must include at minimum:
  - `tenantPartyId`
  - `shippingGatewayConfigId`
- Token validation and tenant identification are mandatory for every request.

---

## 5. API Service Contracts

| API Name                   | Purpose                                      |
|:---------------------------|:---------------------------------------------|
| `get#OrderShippingRate`     | Get shipping rate for an entire order.       |
| `get#ShippingRatesBulk`     | Get bulk shipping rates for multiple methods.|
| `get#AutoPackageInfo`       | Automatically calculate packaging details.  |
| `get#ShippingRate`          | Get shipping rate for a single package.      |
| `request#ShippingLabels`    | Request generation of shipping labels.       |
| `refund#ShippingLabels`     | Request refund/cancellation of labels.       |
| `track#ShippingLabels`      | Track shipment status.                      |
| `validate#ShippingPostalAddress` | Validate a shipping address.             |

---

## 6. API Request and Response Structures

### Example: `request#ShippingLabels`

**Request JSON:**
```json
{
  // Sample request JSON will be added later
}
```

**Response JSON:**
```json
{
  // Sample response JSON will be added later
}
```

_(Other APIs will follow a similar clean request/response structure.)_

---

## 7. Error Handling and Standard Response Format

All errors return JSON responses with an appropriate HTTP status code.

**Example Error Response:**
```json
{
  "errorCode": "AUTH_FAILED",
  "errorMessage": "Authorization token missing or invalid."
}
```

| HTTP Status | Typical Causes                  |
|:------------|:---------------------------------|
| 400         | Invalid input parameters.        |
| 401         | Missing or invalid authorization.|
| 403         | Tenant not authorized for resource.|
| 500         | Internal server error.           |

---

## 8. Multi-Tenant Behavior

- `tenantPartyId` is extracted from JWT and used to lookup tenant-specific configurations.
- `shippingGatewayConfigId` is used to select the shipping gateway settings.
- All API calls are scoped and isolated per tenant.

---

## 9. Notes and Assumptions

- Shipping Gateway Microservice does **not persist** shipment data.
- All APIs are synchronous.
- OMS client is responsible for retry logic if transient failures occur.
- Rate limiting and throttling may be introduced in future versions.

---
