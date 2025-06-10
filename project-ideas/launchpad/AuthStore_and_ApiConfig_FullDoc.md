
# 🔐 Understanding `authStore` and `apiConfig` in HotWax Commerce

This document explains the roles of `authStore` (frontend) and `apiConfig` (backend client config) in the HotWax Commerce architecture. It also compares them to help developers use them appropriately and follow best practices.

---

## 🧩 Part 1: `authStore` (Frontend - Launchpad)

### 📍 Location
`launchpad/src/store/auth.ts`

### 🧠 Purpose
Manages user authentication state, permissions, and instance (OMS) configuration across the frontend app.

### 🧰 Key Responsibilities

| Feature                  | Description |
|--------------------------|-------------|
| `oms`                   | Stores user-input OMS hostname |
| `token.value`           | Stores JWT token for auth |
| `token.expiration`      | Used to check if session is still valid |
| `login()`               | Authenticates user using username/password |
| `getBaseUrl()`          | Dynamically builds API base URL |
| `setOMS()`              | Sets OMS and calls `updateInstanceUrl()` |
| `setRedirectUrl()`      | Saves post-login navigation target |
| `permissions`           | Stores user permissions |
| `isAuthenticated`       | Getter to check token validity |

---

## 🔧 Part 2: `apiConfig` (Shared API Client - oms-api)

### 📍 Location
`oms-api/src/api/index.ts`

### 🧠 Purpose
Centralized Axios-based client configuration for making API requests with auth and routing context.

### 🧰 Key Responsibilities

| Feature                  | Description |
|--------------------------|-------------|
| `instanceUrl`           | Stores the current OMS base URL |
| `token`                 | Stores the auth token |
| `systemType`            | Determines if headers use `api_key` or `Authorization` |
| `updateInstanceUrl()`   | Sets `instanceUrl` dynamically |
| `updateToken()`         | Sets token for secured API calls |
| `requestInterceptor()`  | Adds auth headers to every request |
| `responseSuccess/Error` | Handles response events and errors globally |

---

## 🔄 Comparison: `authStore` vs. `apiConfig`

| Concern                        | `authStore`                          | `apiConfig`                          |
|--------------------------------|--------------------------------------|--------------------------------------|
| Layer                         | Frontend state (Pinia store)         | Shared HTTP client config (Axios)    |
| Primary Use                   | Manage auth session + OMS            | Apply auth/session data to requests  |
| Stores token?                 | ✅ Yes (`token.value`)               | ✅ Yes (`token`)                     |
| Stores base URL?              | ✅ Yes (`oms`, via getter)           | ✅ Yes (`instanceUrl`)               |
| Responsible for login logic?  | ✅ Yes                                | ❌ No                                 |
| Handles headers?              | ❌ No                                 | ✅ Yes (in interceptor)              |
| Used where?                   | Vue components, router guards        | All Axios API requests               |
| Communicates with?            | `apiConfig`                          | Backend OMS API                      |

---

## ✅ Best Practices for Developers

### Use `authStore` when:
- Managing login/logout UX
- Tracking token expiration
- Triggering permission resolution
- Getting/setting user or redirect info

### Use `apiConfig` when:
- Making HTTP requests to OMS APIs
- Setting headers/token programmatically
- Customizing client-wide request/response behavior

---

By using `authStore` for high-level auth state and `apiConfig` for transport-layer auth mechanics, you achieve a clean separation of concerns and reliable cross-app authentication.


---

## 🔁 Login Workflow and How `authStore` and `apiConfig` Interact

### 1. 🔹 User Launches the App
- The frontend checks for a stored session (`authStore.token.value`) and token validity (`authStore.isAuthenticated`).
- If invalid, the user is redirected to the login screen.

### 2. 🧾 User Enters OMS ID
- Input is captured in the login form (Launchpad).
- `authStore.setOMS(oms)` is triggered:
  - Updates `authStore.oms`
  - Calls `updateInstanceUrl(oms)` → updates `apiConfig.instanceUrl`

### 3. 🔍 System Checks for Supported Login Type
- Launchpad makes a request to `/checkLoginOptions` using the new `apiConfig.instanceUrl`.
- Server responds with `loginAuthType` → BASIC or SAML.

### 4. 👤 Username/Password Login (BASIC)
- If `loginAuthType === 'BASIC'`, the user is prompted for credentials.
- On submission, `authStore.login(username, password)` is called:
  - Makes a `POST /login` request using Axios (`apiConfig` sends token in header after receiving it)
  - Stores token and expiration in `authStore.token`
  - Calls `updateToken(token)` → sets `apiConfig.token`

### 5. 🔐 SAML Login
- If `loginAuthType !== 'BASIC'`, the user is redirected externally.
- The SAML identity provider returns with `?token` and `?expirationTime`.
- `authStore.samlLogin(token, expirationTime)` is called:
  - Sets token in both `authStore` and `apiConfig`
  - Retrieves and stores user profile

---

## 🧠 Summary of Workflow Integration

| Step                  | `authStore` Role                        | `apiConfig` Role                       |
|-----------------------|------------------------------------------|----------------------------------------|
| Set OMS               | Stores OMS, triggers `updateInstanceUrl` | Applies base URL for API calls         |
| Check login options   | -                                        | Uses new base URL for request          |
| Perform login         | Handles logic and state storage          | Sends token in headers                 |
| Store token           | Saves token + expiry                     | Receives token via `updateToken()`     |
| Make API calls        | -                                        | Applies token, handles errors globally |

---

These workflows ensure that authentication, routing, and request configuration remain decoupled but synchronized. Developers should rely on `authStore` for controlling the session, and on `apiConfig` for sending authenticated requests.



---

## 🧩 Additional Details for Login Workflow

### 🔍 1. `checkLoginOptions` — Determining Login Type

**Where it’s called:**  
Immediately after `authStore.setOMS()` is invoked in `Login.vue`, the app calls:

```ts
await fetchLoginOptions();
```

**What it does:**  
Sends a GET request to `/checkLoginOptions` on the configured OMS backend to determine what kind of login is supported.

**Response structure example:**
```json
{
  "loginAuthType": "BASIC" // or "SAML"
}
```

**Why it matters:**
- If the response is `BASIC`, the UI renders username/password inputs.
- If it’s not `BASIC`, the app initiates a SAML login flow using token from query string.

**Backed by:**
- API base URL comes from `authStore.getBaseUrl()`, which is dynamically set based on the entered OMS via `updateInstanceUrl()`.

---

### 🔐 2. `authStore.samlLogin(token, expirationTime)` — SAML Login Flow

**Where it’s used:**
- Called from `samlLogin()` method in `Login.vue` when the app is redirected back from a SAML IdP.
- URL includes query parameters like `?token=...&expirationTime=...`.

**What it does:**
- Saves the token and expiration in `authStore.token`.
- Calls `updateToken(token)` to update `apiConfig.token`.
- Fetches user profile using the token and stores it in `authStore.current`.

**Code pattern:**
```ts
await this.authStore.samlLogin(token, expirationTime);
```

**Why it matters:**
- Allows seamless single sign-on using external identity providers.
- Avoids manual credential entry.
- Ensures token and headers are synced across state and API config.

---

These two additions finalize the login process by clearly documenting how login type is detected and how federated authentication (SAML) is handled in a secure, integrated way across Launchpad and the OMS API.



---

## 📡 Deep Dive: `/checkLoginOptions` Server Response

### 📁 Source
The response for `/checkLoginOptions` is generated by a FreeMarker Template (`.ftl`) file on the server side in OFBiz. It dynamically responds based on whether SAML is enabled in the configuration.

### ⚙️ Server-Side Logic

```ftl
<#assign isSaml2SsoConfigured = EntityUtilProperties.getPropertyValue("security", "security.login.saml2.sso.enable", "false", delegator)! />
{
  <#if isSaml2SsoConfigured?boolean>
    "loginAuthType": "SAML2SSO",
    "loginAuthUrl": "<@ofbizUrl>saml2ssoLogin</@ofbizUrl>",
  <#else>
    "loginAuthType": "BASIC",
    "loginAuthUrl": "<@ofbizUrl>login</@ofbizUrl>",
  </#if>
  "maargInstanceUrl": "${(StringUtil.wrapString(Static["java.lang.System"].getProperty("maarg.instance.url")))!}"
}
```

### 🧾 Response Fields Explained

| Field              | Description |
|-------------------|-------------|
| `loginAuthType`   | Indicates whether the login should be via `"BASIC"` or `"SAML2SSO"` |
| `loginAuthUrl`    | Backend URL to initiate the login flow (used for redirection) |
| `maargInstanceUrl`| A special instance URL used when integrating with Maarg |

---

### 🔄 How Frontend Uses This Response

In Launchpad:

1. After setting the OMS:
   ```ts
   await fetchLoginOptions()
   ```

2. The response JSON is saved in a local variable, e.g. `this.loginOption`.

3. Conditional logic is applied:
   - If `loginAuthType === "BASIC"` → show username/password fields.
   - If `loginAuthType === "SAML2SSO"` → trigger SAML login using `loginAuthUrl`.

4. The optional `maargInstanceUrl` is used in Maarg-integrated apps to build redirect links or pre-fill context.

---

This response format enables frontend apps to adapt their login flow dynamically, supporting both password-based and SSO-based experiences using the same interface.



---

## 🔎 Context Returned by `getUserProfile` and Its Usage

The `getUserProfile` service is called immediately after a successful login. Its response is built from a FreeMarker Template (FTL) on the backend and serves as the source of user identity and context across the app ecosystem.

### 📥 What the Response Includes

| Field               | Description |
|--------------------|-------------|
| `partyId`          | Internal unique ID for the user |
| `partyName`        | User's display name |
| `userLoginId`      | Username |
| `userTimeZone`     | User's preferred timezone |
| `userLocale`       | Preferred language/locale |
| `omsInstanceName`  | Name of the running OMS instance |

### 📎 Optional Fields

- `partyImageUrl`: URL to the user's profile image, if configured.
- `email`: The user’s primary email address.
- `address`: A detailed JSON structure of the user’s postal address.

### 🏬 Facilities
An array of facilities associated with the user. Each object includes:

```json
{
  "facilityId": "STORE_1",
  "name": "Main Flagship Store",
  "roleTypeId": "WAREHOUSE",
  "roleTypeDescription": "Warehouse"
}
```

### 🔁 How It's Used

#### ✅ In Launchpad
- The response is assigned to `authStore.current`:
  ```ts
  this.current = await UserService.getUserProfile(token);
  this.authStore.setCurrent(current);
  ```

#### ✅ In DXP Components
- Components like `DxpTimeZoneSelect.vue` use `userTimeZone` from `authStore.current`.
- User info (name, image) is shown in headers and menus.

#### ✅ In Inventory Count App
- The `facilities` list drives which store or warehouse context to initialize.
- Locale and timezone from the profile adjust localized features.

### 📊 Summary Flow

```text
[Successful Login]
      ↓
[getUserProfile(token)]
      ↓
[FTL constructs user object with identity, contact, facilities]
      ↓
[authStore.setCurrent() stores the result]
      ↓
[All components/apps personalize behavior using authStore.current]
```

This user profile context is foundational for controlling visibility, localizing content, and initializing store context across HotWax Commerce applications.



---

## 🧷 Is `authStore` the Source of Truth?

Yes — in the HotWax Commerce front-end ecosystem, `authStore` acts as the **Single Source of Truth (SSoT)** for all user session context after login.

### ✅ Why `authStore` Is Considered the SSoT

1. **Stores all user profile data** after `getUserProfile()` is called.
   ```ts
   authStore.current = userProfileData;
   ```

2. **Used throughout the system**, including:
   - Launchpad for routing, redirects, and role-based rendering.
   - DXP components for personalized UI (e.g., user image, name, time zone).
   - Individual apps like Inventory Count for facility-specific access.

3. **Accessible globally** via:
   ```ts
   const { current } = useAuthStore();
   ```

4. **Feeds multiple downstream systems**:
   - `facilities` power fulfillment and inventory access.
   - `userLocale` and `userTimeZone` localize all date/time data.

### 📘 Best Practices

| Task                            | Why Use `authStore`                |
|----------------------------------|------------------------------------|
| Getting current user data        | It's already fetched and cached    |
| Applying facility context        | Pull from `authStore.current.facilities` |
| Reading locale/timezone prefs    | Use `authStore.current.userLocale` |
| Displaying user avatar and name  | Comes from `partyName`, `partyImageUrl` |

---

### 🧠 In Summary

`authStore` is the frontend layer’s canonical holder of authenticated user state. All apps and components reference it to remain consistent, context-aware, and session-aligned.
