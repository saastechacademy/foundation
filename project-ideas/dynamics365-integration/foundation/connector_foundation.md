# Dynamics 365 Connector Foundation

This document captures the generic connector-level modeling used across the `hotwax-d365` integration flows.

## 1. Technical Architecture
- **Protocols / Interfaces**:
  - OData v4 (REST) for direct entity-based sync
  - Data Management Framework (DMF) / Data Package APIs for package import/export
- **Authentication**: OAuth 2.0 Client Credentials Flow via Azure AD
- **Mapping Strategy**:
  - **Legal Entity Mapping**: Moqui `ProductStore` / `Organization` -> D365 `dataAreaId`
  - **Logic**: Every request must explicitly include the mapped `dataAreaId`

## 2. Connector Foundation

### 2.1 Credentials Storage (`SystemMessageRemote`)
- Create `D365Auth` record in the `SystemMessageRemote` entity.
- Suggested fields:
  - `username` for Azure client id
  - `password` for Azure client secret
  - `sharedSecret` for Azure tenant id
  - `sendUrl` for token endpoint
  - `receiveUrl` for D365 instance base URL

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
  - include the `dataAreaId` context
  - centralize common OData request handling

## 3. Technical Reference: OData Metadata

| Term | Meaning |
| :--- | :--- |
| **EntitySet** | The URL collection or endpoint, for example `CustomersV3`. |
| **EntityType** | The schema definition and structure of the data object. |
| **Key** | The primary key fields. |
| **Nullable=\"false\"** | A required field that cannot be empty. |
