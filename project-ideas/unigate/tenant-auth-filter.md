## TenantAuthFilter Implementation Design

### Overview

`TenantAuthFilter.groovy` is a [servlet filter](https://www.oracle.com/java/technologies/filters.html) designed to secure Unigate REST API endpoints by enforcing multi-tenant authentication using login keys and tenant identifiers. It is registered in `MoquiConf.xml` and protects all endpoints under `/rest/s1/unigate/*`.

---

### 1. Purpose

To authenticate API requests based on:

* `api_key` – the plaintext API key provided by the tenant (hashed internally before lookup)
* `tenant_Id` – the tenant's `partyId` (set during onboarding)

Only requests where the hashed `api_key` matches a `UserLoginKey` record **and** the associated `partyId` matches `tenant_Id` are allowed to proceed.

---

### 2. Configuration

#### MoquiConf.xml

Two key configurations ensure the filter functions correctly:

```xml
<default-property name="webapp_require_session_token" value="false"/>
```

* Disables Moqui’s default requirement for a session token on web requests.
* Required to support stateless REST authentication via headers.

```xml
<filter name="TenantAuthFilter" class="co.hotwax.unigate.TenantAuthFilter" async-supported="true">
    <url-pattern>/rest/s1/unigate/*</url-pattern>
</filter>
```

* Applies the `TenantAuthFilter` to all Unigate API endpoints.

---

### 3. Protected Endpoints

All endpoints under `/rest/s1/unigate/*` are protected. The filter runs before Moqui's REST framework dispatches the request, so `require-authentication` flags in REST descriptors have no effect on whether the filter executes.

---

### 4. Authentication Logic

* Reads `api_key` and `tenant_Id` from HTTP request headers.
* If either header is missing, immediately returns `401` with `"Missing authentication headers."`
* Hashes the `api_key` value using Moqui's `getSimpleHash()` with the configured `LoginKeyHashType`.
* Queries the `UserLoginKeyAndParty` view entity for a record where `loginKey` equals the hashed value.
* Validates that the `partyId` from the matched record equals the `tenant_Id` header value. If not, returns `401` with `"Invalid credentials."`
* If validation passes, sets `tenantPartyId` as a request attribute and passes the request to the next filter in the chain.
* Any exception during this process returns `500` with `"Authentication failure: {message}"` — distinguishing system failures from credential failures.
* The Moqui `ExecutionContext` is initialized per request and **always** destroyed in a `finally` block, regardless of outcome, to prevent context leaks.

---

### 5. Entity Usage

* **UserLoginKeyAndParty** (a view-entity joining `moqui.security.UserLoginKey` and `moqui.security.UserAccount`): Used to verify that the hashed login key and `partyId` match.
* **Hashing**: Performed using Moqui's `ec.ecfi.getSimpleHash(loginKey, "", ec.ecfi.getLoginKeyHashType(), false)`. The stored keys are hashed; plaintext keys are never stored.

---

### 6. Design Considerations

* **Multi-Tenant Security**: The filter ensures requests are only allowed for users who belong to the specified tenant.
* **Stateless Authentication**: Relies on headers for authentication, suitable for REST APIs.
* **Bypasses Session Token Requirement**: The session token requirement is disabled to allow secure, stateless access.
