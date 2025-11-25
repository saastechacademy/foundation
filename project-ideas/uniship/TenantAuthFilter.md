## TenantAuthFilter Implementation Design

### Overview

`TenantAuthFilter.groovy` is a [servlet filter](https://www.oracle.com/java/technologies/filters.html) designed to secure selected UniShip REST API endpoints by enforcing multi-tenant authentication using login keys and tenant identifiers. It is registered in `MoquiConf.xml` and protects endpoints defined in `uniship.rest.xml`.

---

### 1. Purpose

To authenticate API requests based on:

* `X-Login-Key` – a temporary, hashed login token
* `X-Tenant-Id` – tenant-specific identifier (party ID)

Only requests with valid and active credentials for the specified tenant are allowed to proceed.

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
<filter name="TenantAuthFilter" class="co.hotwax.uniship.TenantAuthFilter" async-supported="true">
    <url-pattern>/rest/s1/uniship/shipment/*</url-pattern>
</filter>
```

* Applies the `TenantAuthFilter` to secure relevant UniShip API endpoints.

---

### 3. Protected Endpoints

Defined in `uniship.rest.xml`:

* `/shipment/rate` – currently marked as `require-authentication="false"` (can be updated for enforcement)
* `/shipment/label`
* `/shipment/label/refund`

These endpoints are secured by the filter based on path matching, regardless of the `require-authentication` flag in the REST descriptor.

---

### 4. Authentication Logic

* Reads `X-Login-Key` and `X-Tenant-Id` from HTTP headers.
* Hashes the login key using the configured algorithm.
* Looks up a matching record in `UserLoginKeyWithParty` where:

  * `loginKey` matches the hashed value,
  * `partyId` matches the tenant ID,
  * and the current time falls between `fromDate` and `thruDate`.
* If a match is found, logs in the user and allows the request to proceed.
* Otherwise, responds with `401 Unauthorized`.

---

### 5. Entity Usage

* **UserLoginKeyWithParty** (a view-entity): Used to verify that the login key and tenant ID are valid for the current timestamp.
* **Hashing**: Performed using Moqui’s `getSimpleHash()` function with the configured `login-key.@encrypt-hash-type`.

---

### 6. Design Considerations

* **Multi-Tenant Security**: The filter ensures requests are only allowed for users who belong to the specified tenant.
* **Stateless Authentication**: Relies on headers for authentication, suitable for REST APIs.
* **Bypasses Session Token Requirement**: The session token requirement is disabled to allow secure, stateless access.
