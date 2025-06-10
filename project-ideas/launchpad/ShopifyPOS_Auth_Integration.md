
## Integrate ShopifyPOS SessionToken Based Authentication for PWA Apps

### 🎯 Objective

Enable Progressive Web Apps (PWAs) developed with Ionic + Vue to work seamlessly inside Shopify POS by authenticating users using Shopify App Bridge's `getSessionToken` method. The goal is to leverage existing backend token validation and reuse standard frontend login workflows already implemented in HotWax Commerce apps.

---

### 🧠 What We Know

1. **Shopify App Bridge Requirement:**

   - The app must import and initialize `@shopify/app-bridge`.
   - `getSessionToken(app)` will be the method to retrieve a secure session token from Shopify POS.

2. **Backend Capability:**

   - HotWax Commerce (Moqui-based backend) already has a service called `validate#ShopifySessionToken`.
   - This service accepts Shopify session token and returns a valid OMS API token, used across all PWA apps.

3. **Existing Frontend Architecture:**

   - All PWA apps use `authStore` to store and access user token, profile, and configuration.
   - Authentication decisions are made by checking a `loginAuthType` returned by `/checkLoginOptions` API.
   - Existing login types: `BASIC` and `SAML2SSO`.

4. **Central Launcher Design:**

   - The Launchpad application (aka "HCApps") will act as the single entry point into the ShopifyPOS embedded mode.
   - Only one app — **HCApps** — needs to be published to the Shopify POS App Store.
   - After being launched by the POS, **HCApps** will:
     1. Authenticate the user using `getSessionToken()`.
     2. Call `validate#ShopifySessionToken` to get OMS API token.
     3. Set up shared state via `authStore` and `apiConfig`.
     4. Display tiles for all available embedded PWAs.
   - When the user clicks on a tile (e.g., Inventory Count), that sub-app loads within the same viewport and reuses the authenticated context (token, OMS instance, user profile).

---

### ♻️ Streamlined Auth Flow for HCApps (POS Launcher)

The authentication logic in HCApps will be significantly simpler than Launchpad’s `Login.vue` implementation because:

- HCApps will always run inside Shopify POS embedded mode.
- It only needs to handle one type of authentication: `ShopifyPosSessionToken`.
- There is no need to request OMS input, SAML login options, or redirect logic.

#### HCApps Init Flow:

1. Call `getSessionToken(app)` from Shopify App Bridge
2. Send the token to `validate#ShopifySessionToken`
3. Response includes:
   - OMS API token → stored via `authStore.setToken()`
   - Optionally, OMS instance URL → stored via `authStore.setOMS()`
4. Fetch user profile via `getUserProfile()`
5. Store user profile in `authStore.setCurrent()`
6. Proceed to render the tile-based UI for sub-apps

All launched sub-apps can now access and use the shared `authStore` and `apiConfig` seamlessly, just like in browser-based PWA usage.

---

### 💡 Proposed Strategy

#### 1. Simplified Init in HCApps

- Instead of routing through `Login.vue`, HCApps will use its own init logic:
  1. Initialize App Bridge
  2. Call `getSessionToken(app)`
  3. Send session token to `validate#ShopifySessionToken`
  4. Save returned OMS token using `authStore.setToken()`
  5. Optionally save OMS instance via `authStore.setOMS()`
  6. Fetch and set user profile via `getUserProfile()` and `authStore.setCurrent()`

#### 2. Leverage Existing Token Handling

- Once OMS token is retrieved and saved, everything else remains identical to the BASIC login flow.
- All API requests use Axios with Authorization header already managed.

#### 3. Benefit: Minimal Disruption

- No need to rewrite backend logic
- No need to change `authStore`, token handling, or routing
- App stays aligned with architecture of existing PWA apps

---

### 🧪 Test Strategy

- Simulate Shopify POS iframe environment locally
- Test cases:
  - Valid session token flow
  - Expired session token
  - Missing `AppBridge`

---

### 📦 Next Steps

1. Implement init logic in HCApps for session token handling
2. Connect session token with existing `authStore` and `apiConfig`
3. Build tile-based navigation UI
4. QA in POS sandbox
5. Validate access and context sharing with sub-apps

---

This approach balances architecture alignment, reuse, and seamless Shopify POS compatibility.
