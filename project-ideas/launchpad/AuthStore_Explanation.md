
# 🛡️ `authStore` in Launchpad — Authentication State Management

This document provides a comprehensive explanation of the `authStore` implemented in the Launchpad frontend of HotWax Commerce. It manages the user authentication lifecycle, token state, permissions, and base API URL configuration.

---

## 🏗️ Overview

The `authStore` is defined using **Pinia** in `src/store/auth.ts` and is responsible for:

- Token management (store, update, expiry check)
- User session validation
- Fetching and managing user permissions
- Providing OMS and base URL configuration
- Storing the logged-in user profile

---

## 🧾 State Structure

```ts
state: () => ({
  current: {} as any,            // User profile
  oms: '',                       // OMS base URL
  token: {
    value: '',                   // JWT token
    expiration: undefined        // Expiry timestamp
  },
  redirectUrl: '',               // Redirect target post-login
  maargOms: '',                  // For Maarg login contexts
  permissions: [] as any         // User permissions
})
```

---

## 🧠 Getters

### ✅ `isAuthenticated`
Checks whether a valid token exists and is not expired.

```ts
isAuthenticated: (state) => {
  let isTokenExpired = false;
  if (state.token.expiration) {
    const currTime = DateTime.now().toMillis();
    isTokenExpired = state.token.expiration < currTime;
  }
  return !!(state.token.value && !isTokenExpired);
}
```

---

### ✅ `getBaseUrl`

Constructs the API base URL from the environment or user input.

```ts
getBaseUrl: (state) => {
  let baseURL = process.env.VUE_APP_BASE_URL || state.oms
  return baseURL.startsWith('http') ?
    baseURL.includes('/api') ? baseURL : `${baseURL}/api/` :
    `https://${baseURL}.hotwax.io/api/`
}
```

---

## 🔐 Login Action

### `login(username, password)`
Handles user authentication and profile setup:

```ts
const resp = await UserService.login(username, password);
this.token = {
  value: resp.data.token,
  expiration: resp.data.expirationTime
}
this.current = await UserService.getUserProfile(this.token.value);
updateToken(this.token.value);
```

---

## 🔏 Permissions Handling

```ts
const serverPermissionsFromRules = getServerPermissionsFromRules();
const serverPermissions = await UserService.getUserPermissions(...);
const appPermissions = prepareAppPermissions(serverPermissions);

this.permissions = appPermissions;
setPermissions(appPermissions);
```

- Fetches server-level permissions based on rules
- Converts them into app-specific format
- Stores them locally and updates global permission utility

---

## 🔄 OMS and Redirect Configuration

### `setOMS(oms: string)`
Stores the OMS hostname and applies it in the adapter config.

### `setRedirectUrl(redirectUrl: string)`
Stores a redirect path for post-login actions.

---

## ✅ Summary

| Feature                | Responsibility                         |
|------------------------|-----------------------------------------|
| Token storage          | `state.token.value`                     |
| Token expiration check | `state.token.expiration`, `isAuthenticated` |
| Login flow             | `login()` → `UserService.login()`      |
| User profile fetch     | `UserService.getUserProfile(token)`     |
| Token propagation      | `updateToken()` (API layer)             |
| Permissions setup      | `getUserPermissions()` → `setPermissions()` |
| Base URL resolution    | `getBaseUrl()`                          |

The `authStore` provides a robust authentication mechanism across HotWax PWA frontends and allows smooth token and permission management using modern Vue + Pinia patterns.
