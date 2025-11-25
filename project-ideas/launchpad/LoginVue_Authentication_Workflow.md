
# 🔐 Authentication Workflow in Launchpad — `Login.vue` Overview

This document summarizes the responsibilities and workflow of the `Login.vue` file within the Launchpad frontend of the HotWax Commerce ecosystem.

---

## 🧩 Login.vue — Primary Responsibilities

### ✅ Form Binding & UI Logic
- Provides a two-step form:
  - OMS Instance URL
  - Username & Password
- Uses Vue's `v-model` to bind data (`username`, `password`, `instanceUrl`).
- Contains buttons that trigger `setOms()` and `login()`.

### ✅ Integration with Auth Store
- Uses `useAuthStore()` from Pinia to manage state.
- Delegates login logic to `authStore.login()`.

### ✅ Service Dependency
- Relies on `UserService` for API communication:
  - `login()` — authenticates and retrieves token.
  - `getUserProfile()` — retrieves authenticated user profile.

---

## 🏗️ Token Lifecycle and Workflow

### 📥 Token Generation
- `UserService.login(username, password)` sends a `POST` request to `/login`.
- Receives a `token` and `expirationTime` in response.

### 🧠 Token Storage and Propagation
- `authStore.token.value` and `token.expiration` store JWT and expiry.
- `updateToken()` pushes token to API layer for request headers.

### 👤 User Context
- `getUserProfile(token)` retrieves and stores user details in `authStore.current`.

### ✅ Session Validation
- Getter `authStore.isAuthenticated` checks if token is:
  - Present
  - Not expired (compared using `luxon` time utils).

---

## 🔁 API Request Authentication

| Step                      | Code Location                      | Action |
|---------------------------|------------------------------------|--------|
| Submit credentials        | `Login.vue` via `authStore.login()` | Calls `UserService.login()` |
| Token received            | `UserService.login()`               | Extracts `token` and `expirationTime` |
| Token stored              | `authStore.token`                   | Stored in Pinia state |
| Token set for requests    | `updateToken()`                     | Likely sets Axios auth headers |
| Profile fetched           | `UserService.getUserProfile(token)` | Uses token for user data |
| Permissions fetched       | `getUserPermissions(token)`         | For access control |
| Session validity checked  | `authStore.isAuthenticated`         | Used in routing guards, etc. |

---

## ✅ Conclusion

`Login.vue` acts as the front-facing UI for initiating authentication, while the logic and token handling are abstracted into the Pinia `authStore` and `UserService`. It is a well-separated, clean implementation that integrates deeply with shared DXP components and Launchpad's service layer.
