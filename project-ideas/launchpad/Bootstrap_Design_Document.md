
# 🚀 HotWax Commerce Bootstrap Design Document

This document defines the architecture, data elements, and flow for the bootstrap (authentication and initialization) process in HotWax Commerce applications. It supports multiple entry points and authentication strategies depending on the environment.

---

## 🧭 Dual Entry Points: Launchpad vs HCApps

HotWax Commerce supports two distinct user entry paths into the OMS ecosystem:

| Attribute              | **Launchpad (Web PWA)**               | **HCApps (Shopify POS Embedded App)** |
|------------------------|----------------------------------------|----------------------------------------|
| Access Point           | Browser (desktop/mobile)               | Embedded inside Shopify POS            |
| Trigger                | User navigates and enters OMS ID       | Shopify merchant opens HCApps app      |
| Auth Source            | User login / SAML IdP                  | Shopify App Bridge sessionToken        |
| Token Exchange Flow    | Direct (login) or redirected (SAML)    | `validate#ShopifySessionToken` service |
| Token Storage          | `authStore`, `apiConfig`               | `authStore`, `apiConfig`               |
| App Selector           | Manual launch from UI                  | Workflow launcher shown by HCApps      |

---

## 🔐 Step 1: OMS Discovery and Login Options (Launchpad)

### ➡️ Why OMS ID First?
HotWax Commerce is a **multi-tenant SaaS** platform where each merchant has their **own OMS instance**. Each OMS may have different authentication rules (e.g., SAML enabled).

### 🪪 User Input
```
Enter your OMS ID:
```

### 🌐 Call to `checkLoginOptions`
```http
GET https://<oms-host>/checkLoginOptions
```
This public endpoint responds with:
```json
{
  "loginAuthType": "BASIC" or "SAML2SSO",
  "loginAuthUrl": "/login" or "/saml2ssoLogin",
  "maargInstanceUrl": "https://merchant.hotwax.io"
}
```

This determines which login UI to render and where token exchange should happen.

---

## 🔁 Step 2: Authentication Mode Decision

### 🔹 BASIC
- User enters `username` and `password`
- Calls `authStore.login()` → token returned
- Sets token in `authStore`, `apiConfig`

### 🔸 SAML2SSO
- Redirects user to external SAML login (`loginAuthUrl`)
- Upon return, receives `?token` and `expirationTime`
- Calls `authStore.samlLogin(token)`

### 🟣 HCApps Embedded Mode (Shopify POS)
- HCApps initializes **Shopify App Bridge**
- Calls `getSessionToken()` from Shopify
- Sends token to OMS via `validate#ShopifySessionToken`
- OMS responds with HotWax token + expiration
- HCApps stores it in `authStore`, `apiConfig`
- Calls `getUserProfile()` and initializes workflows

---

## 🧠 Data Elements in the Bootstrap Flow

| Data Element           | Source                     | Used in                          |
|------------------------|----------------------------|----------------------------------|
| `oms`                  | User input / query param   | `authStore.setOMS()`             |
| `token`                | URL param / server resp    | `authStore.token`, `apiConfig`   |
| `expirationTime`       | URL param / server resp    | `authStore.token.expiration`     |
| `loginAuthType`        | `checkLoginOptions` resp   | Branching login UI               |
| `maargInstanceUrl`     | `checkLoginOptions` resp   | Setting base URL                 |
| `userProfile`          | `getUserProfile()`         | `authStore.current`              |
| `facilities`           | `getUserProfile()`         | Routing, permissions             |

---

## 🔄 Post-Login Initialization

### 1. Token Handling
```ts
authStore.setToken(token, expirationTime)
apiConfig.updateToken(token)
```

### 2. Fetch User Profile
```ts
const profile = await UserService.getUserProfile(token)
authStore.setCurrent(profile)
```

### 3. Workflow Availability
In HCApps, the dashboard displays workflows (like Inventory Count) based on permissions/roles.

---

## ✅ Summary
- Launchpad and HCApps are **independent bootstrap entry points**
- Each has its own authentication path:
  - Manual + SAML via Launchpad
  - SessionToken via Shopify in HCApps
- Token and context are normalized into `authStore` and `apiConfig`
- `authStore` is the **Single Source of Truth (SSoT)** for session context

---

Next: We will define the **state transitions and responsibility matrix** for each data element.
