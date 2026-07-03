# Dynamics 365 Connector Foundation

This document captures the generic connector-level modeling used across the `hotwax-d365` integration flows.

## 1. Technical Architecture
- **Protocols / Interfaces**:
  - OData v4 (REST) for direct entity-based sync
  - Data Management Framework (DMF) / Data Package APIs for package import/export
- **Authentication**: OAuth 2.0 Client Credentials Flow via Microsoft Entra ID
- **Mapping Strategy**:
  - **Legal Entity Mapping**: Moqui `ProductStore` / `Organization` -> D365 `dataAreaId`
  - **Logic**: Every request must explicitly include the mapped `dataAreaId`

## 2. Connector Foundation

### 2.1 Credentials Storage (`SystemMessageRemote`)
- Create `D365Auth` record in the `SystemMessageRemote` entity.
- Suggested fields:
  - `username` for Azure client id
  - `password` for Azure client secret
  - `sendUrl` for Azure token endpoint (tenant-specific, v2.0 format: `https://login.microsoftonline.com/{tenantId}/oauth2/v2.0/token`)
  - `receiveUrl` for D365 instance base URL
  - `systemMessageRemoteId` as the connector key (for example `D365_HotWax_Dev`)
  - `description` for environment context

```json
{
  "systemMessageRemoteId": "D365_HotWax_Dev",
  "username": "YOUR_CLIENT_ID",
  "password": "YOUR_CLIENT_SECRET",
  "sendUrl": "https://login.microsoftonline.com/YOUR_TENANT_ID/oauth2/v2.0/token",
  "receiveUrl": "YOUR_D365_INSTANCE_URL",
  "description": "Dynamics 365 Finance & Operations Remote for HotWax Dev Environment",
  "_entity": "moqui.service.message.SystemMessageRemote"
}
```

> [!IMPORTANT]
> The v2.0 token endpoint requires a `scope` parameter in the token request body with the value `https://YOUR_D365_INSTANCE_URL/.default` (e.g. `https://usncax1aos.cloud.onebox.dynamics.com/.default`). The v1.0 endpoint (`/oauth2/token`) uses a `resource` parameter instead. Ensure the `get#AzureAccessToken` service passes the correct parameter for whichever endpoint version is configured in `sendUrl`.

### 2.2 Legal Entity Mapping
- Use `ProductStore.externalId` to store the mapping from Moqui `ProductStore` to D365 `dataAreaId`.

### 2.3 Token Management
- Implement the service `get#AzureAccessToken` in the `hotwax-d365` component.
- Service responsibilities:
  - load credentials from `SystemMessageRemote`
  - call the Azure OAuth2 token endpoint
  - cache and reuse the access token until expiry

### 2.4 Generic OData Client
- Implement the service `send#D365ODataRequest`.
- Service responsibilities:
  - inject the access token
  - resolve the D365 base URL
  - include the `dataAreaId` context — the mechanism differs by operation type:
    - **Reads (GET)**: OData returns only the service user's default company by default. To query a specific non-default company, append `?cross-company=true&$filter=dataAreaId eq 'XXXX'` to the request.
    - **Writes (POST/PATCH)**: Set the `dataAreaId` field directly in the entity payload. D365 handles the company context switch automatically.
  - centralize common OData request handling

## 3. Technical Reference: OData Metadata

| Term | Meaning |
| :--- | :--- |
| **EntitySet** | The URL collection or endpoint, for example `CustomersV3`. |
| **EntityType** | The schema definition and structure of the data object. |
| **Key** | The primary key fields. |
| **Nullable=\"false\"** | The field cannot be null. Note: this does not prevent an empty string — additional business-level validation may still be required. |

---

## Related Docs

- [business_process_foundations.md](./business_process_foundations.md) — Foundational D365 concepts: multi-company structure, the Party model, and number sequences.
- [d365_sysoperation_framework.md](./d365_sysoperation_framework.md) — The D365-side X++ batch operation pattern (SysOperation Framework) used for all custom periodic jobs in this integration.
