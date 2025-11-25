# UniShip
**Uniform API for Shipping Integration — Built as a Moqui Component**

---

## 1. Introduction

The UniShip microservice provides a unified API interface for integrating with multiple shipping providers (e.g., FedEx, UPS, Shippo, DHL). It acts as a stateless pass-through system, processing shipment rate, label, and tracking requests without persisting shipment data.

This system supports multi-tenant operations, using a userLoginKey and tenantId to [authenticate and authorize](TenantAuthFilter.md) use of the associated shipping gateway.

---

## 2. Key Requirements

- **Unified Shipping API Abstraction:**  
  Integrate with multiple carriers while exposing a single clean API interface to OMS clients.

- **Stateless Shipment Handling:**  
  Uniship does not store or persist any shipment data. All data is passed through temporarily.

- **Multi-Tenant Isolation:**  
  Each API call is isolated to a specific retailer (tenant).

- **Reliable Error Management:**  
  Standardized error responses and graceful error handling for communication with carrier APIs.

- **Scalability and Extensibility:**  
  Easily plug new carrier integrations in the future without breaking the API contract.

---

## 3. Entity Model Reference

The Shipping Gateway Microservice uses a lightweight multi-tenant [data model](entity/tenant-model-design.md).

Key entities:

- **Party** — Represents both tenants (retailers) and shipping carriers.
- **PartyRole** — Distinguishes between Tenant and Application user parties.
- **ShippingGatewayConfig** — Defines the configuration for each shipping gateway (e.g., FedEx, UPS).
- **ShippingGatewayAuthConfig** — Stores tenant-specific API credentials securely.

👉 Refer to the full [Entity Model Design](entity/entity-model.md) document for detailed definitions.

---

## 4. Authentication and Authorization

- All API requests require an Authorization header with a key token.
- The request must include at minimum:
  - `tenantPartyId`
  - `shippingGatewayConfigId`
- Key validation and tenant identification are mandatory for every request.
- Refer [TenantAuthFilter](TenantAuthFilter.md) for detail design.

---

## 5. API Interfaces
- [get#OrderShippingRate](uniship/getOrderShippingRate.md)
- [request#ShippingLabels](uniship/requestShippingLabel.md)
- [refund#ShippingLabels](uniship/refundShippingLabels.md)

| API Name                         | Purpose                                      |
|:---------------------------------|:---------------------------------------------|
| `get#ShippingRatesBulk`          | Get bulk shipping rates for multiple methods.|
| `get#AutoPackageInfo`            | Automatically calculate packaging details.  |
| `get#ShippingRate`               | Get shipping rate for a single package.      |
| `track#ShippingLabels`           | Track shipment status.                      |
| `validate#ShippingPostalAddress` | Validate a shipping address.             |

---

## 6. Multi-Tenant Behavior

- `tenantPartyId` is used to lookup tenant-specific configurations.
- `shippingGatewayConfigId` is used to select the shipping gateway settings.
- All API calls are scoped and isolated per tenant.

---

## 7. Quick Design Principles for API Request Structure

- API request must be **self-contained**.
- Shipping Gateway should **never need to look up** data like ContactMechId.
- API request must include:
  - Origin Address
  - Destination Address
  - Package List
  - (Optionally) Shipment Items inside Packages
  - Carrier Method if available.
- Units (UOMs) for dimensions and weight must be **explicit** inside the request.
- Assume one route segment per shipment request.
- Origin Facility Name and Address must be resolved and included.
- Shipment status information is not needed and should not be sent.

## 8. Notes and Assumptions

- Shipping Gateway Microservice does **not persist** shipment data.
- All APIs are synchronous.
- OMS client is responsible for retry logic if transient failures occur.
- Rate limiting and throttling may be introduced in future versions.

---
