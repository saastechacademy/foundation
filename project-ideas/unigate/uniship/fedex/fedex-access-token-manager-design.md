# FedexAccessTokenManager: Design Document

---

## 1. Purpose

The `FedexAccessTokenManager` is responsible for managing FedEx OAuth `access_token` lifecycle for each tenant in the Shipping Gateway Microservice. It ensures that:

- A valid token is reused if available.
- A new token is fetched only when necessary.
- Tokens are isolated per tenant and per shipping gateway configuration.

---

## 2. Responsibilities

| Responsibility | Description |
|:---------------|:------------|
| Provide token on demand | `getAccessToken(tenantPartyId, shippingGatewayConfigId)` returns a valid access token. |
| Cache management | Use Moqui's `ec.cache` to store and retrieve tokens. |
| Token refresh | Refresh the token if missing or expired. |
| Safe tenant isolation | Use a composite cache key: `tenantPartyId|shippingGatewayConfigId`. |
| Error handling | Handle cases like missing credentials or failed OAuth requests. |

---

## 3. Cache Structure

| Element | Details |
|:--------|:--------|
| **Cache Name** | `fedex.token.cache` |
| **Cache Key** | `tenantPartyId|shippingGatewayConfigId` |
| **Cache Value** | Map with `accessToken` and `expiresAt` fields. |

Example value:

```groovy
[
  accessToken: "abcdefg123",
  expiresAt: 1710012345678L
]
```

---

## 4. Key Methods

### 4.1 Public Method

```groovy
String getAccessToken(String tenantPartyId, String shippingGatewayConfigId)
```
- Looks up token from cache.
- Checks if expired based on internal token `expiresAt` field.
- Fetches new token if needed.
- Returns valid token.

### 4.2 Internal Methods

| Method | Purpose |
|:-------|:--------|
| `buildCacheKey(tenantPartyId, shippingGatewayConfigId)` | Builds cache key string. |
| `loadTokenFromCache(cacheKey)` | Retrieves token data from cache. |
| `saveTokenToCache(cacheKey, tokenData)` | Saves token data into cache. |
| `isTokenExpired(tokenData)` | Checks if the token is expired considering a 2-minute buffer. |
| `fetchNewTokenFromFedEx(SystemMessageRemote smr)` | Calls FedEx OAuth endpoint using `client_id` and `client_secret`.

Note: Cache auto-expiration settings in Moqui may be used as a safety net for cache cleanup, but correctness of token validity must rely on checking the `expiresAt` timestamp manually.

---

## 5. Error Handling

| Case | Handling |
|:-----|:---------|
| No SystemMessageRemote found | Throw error: "Tenant gateway credentials not found." |
| OAuth call failure | Throw error: "Failed to retrieve FedEx access token." |
| Unexpected server response | Log and fail gracefully. |

---

## 6. Token Expiration Buffer

Apply a **2-minute buffer** when checking token expiry to avoid last-second expiration problems.

```groovy
bufferMillis = 2 * 60 * 1000
```

Condition:

```groovy
System.currentTimeMillis() + bufferMillis >= tokenData.expiresAt
```

Always manually verify token validity based on the `expiresAt` value even if the cache itself has an idle expiration configuration.

---

## 7. Cache TTL vs Token Validity

While Moqui's cache can be configured with idle expiration (TTL) to clean up old or unused entries, it should not be relied upon to guarantee access token validity. FedEx determines token validity based on the `expires_in` field at the time the token is issued.

Therefore:

- Cache TTL can assist with cleaning up unused tokens.
- The correctness of access token usage must always depend on checking the `expiresAt` field inside the cached token data.
- FedexAccessTokenManager must refresh the token based on its internal `expiresAt` value, not on cache eviction.

This ensures that tokens are refreshed accurately and that no expired token is used in API calls.

---

## 8. Notes on Implementation

- Cache must be global (shared across API requests).
- Always validate token expiration using the `expiresAt` field before reuse.
- Cache idle expiration in Moqui may be configured, but token correctness must not rely solely on it.
- The token fetching logic should only happen if strictly necessary.
- Logging should capture token refresh events for monitoring purposes.
- Ensure retry-once behavior if the OAuth call transiently fails.

---

# Conclusion

The `FedexAccessTokenManager` ensures efficient, safe, and scalable FedEx token management for a multi-tenant shipping gateway microservice. It follows Moqui caching practices and ensures token validity using internal expiration checks rather than relying solely on cache eviction policies.

References:
https://developer.fedex.com/api/en-us/catalog/authorization/v1/docs.html
