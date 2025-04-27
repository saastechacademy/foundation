# SystemMessageRemote Entity: Functional Design

---

## Overview

The `SystemMessageRemote` entity manages tenant-specific credentials and API endpoint details for shipping providers (FedEx, Shippo, UPS) in the Shipping Gateway Microservice.

---

## Purpose

| Purpose | Description                                                                                        |
|:--------|:---------------------------------------------------------------------------------------------------|
| Credential Management | Stores tenant's `client_id`, `client_secret`, and `authToken`.                                     |
| Endpoint Configuration | Stores base URLs for shipping provider APIs.                                                       |
| Tenant Separation | Links credentials to specific tenants using `tenantPartyId`.                                       |
| Runtime Lookup | Retrieves credentials at API call time based on tenant identity and systemMessageRemoteTypeEnumId. |

---

## Key Fields

| Field | Description |
|:------|:------------|
| `systemMessageRemoteId` | Unique ID for the record. |
| `tenantPartyId` | Tenant this record belongs to. |
| `shippingGatewayConfigId` | Linked gateway configuration. |
| `authToken` | Optional OAuth token. |
| `endpointBaseUrl` | API endpoint base URL. |
| `remoteId` | Client ID (e.g., FedEx OAuth client ID). |
| `sharedSecret` | Client Secret. |
| `remoteUser` | Username (if needed). |
| `remotePassword` | Password (if needed). |
| `enabledFlag` | Active/inactive flag. |

---

## Application Flow

```plaintext
Tenant Registers
    ↓
SystemMessageRemote record created
    ↓
API Call (Rate/Label/Tracking)
    ↓
Lookup SystemMessageRemote using tenantPartyId and systemMessageRemoteTypeEnumId.

By convention, systemMessageRemoteTypeEnumId will match the shippingGatewayConfigId.
    ↓
Fetch credentials and endpoint
    ↓
Call shipping provider API
```

---

## Example

```xml
<SystemMessageRemote
    systemMessageRemoteId="SHIPPO_RETAILER_123"
    systemMessageRemoteTypeEnumId="SmrFedex"
    tenantPartyId="RETAILER_123"
    authToken="fedex_oauth_token"
    endpointBaseUrl="https://apis.fedex.com"
    remoteId="fedex_client_id"
    sharedSecret="fedex_client_secret"
    enabledFlag="Y"/>
```

---

## Capabilities in First Release

- Provide tools to track token expiry and manage token refresh.
- Encrypt `sharedSecret` and `remotePassword`.
- Add audit logging for credential updates.

---
