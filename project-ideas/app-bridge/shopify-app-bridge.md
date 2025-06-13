## Shopify App Bridge Data Model — Overview and Deep Dive

### High-Level Overview
The Shopify App Bridge data model connects HotWax Commerce with the Shopify ecosystem using the following key entities:

- **ShopifyShop**: Captures metadata for each merchant’s Shopify store.
- **ShopifyApp**: Describes an installed or published Shopify app (custom/public).
- **ShopifyShopApp**: Join table representing app installations per shop.
- **HotwaxInstance**: Maps a shop to the backend OMS environment.
- **ShopifyAppAccessScope / ShopAppAcceptedScope**: Tracks granted and requested permissions.
- **UserLogin**: Represents authenticated users accessing via Shopify.

---

## 1. Focused Entity Analysis

### ShopifyShop (co.hotwax.shopify.shop)
Metadata and identity for a Shopify merchant store.

- `shopId`, `externalId`
- `shopName`, `email`, `phone`, `shopOwner`
- `domain`, `myshopifyDomain`, `timezone`, `planName`
- `weightUnit`, `currency`, `countryCode`, `createdDate`

### ShopifyApp (co.hotwax.shopify.app)
Describes a public or custom Shopify app registered by HotWax Commerce.

- `appId`, `appTypeId`, `statusId`, `appName`, `appVersion`
- `clientId`, `clientSecret` (encrypted)
- `createdDate`

### ShopifyShopApp (co.hotwax.shopify.app)
Records app installation by a Shopify shop and tokens exchanged.

- Composite PK: `shopId`, `appId`, `fromDate`
- `installedAppVersion`, `shopAccessToken`, `hotwaxAccessToken`
- `hotwaxInstanceId`, `comments`, `thruDate`

### HotwaxInstance (co.hotwax.shopify.app)
Backend OMS instance to which a shop routes requests.

- `instanceId`, `hostAddress`

---

## 2. App Registration Process in HotWax Commerce

1. **Admin registers a new app** in `ShopifyApp` entity:
   - Set `clientId`, `clientSecret`, `appId`, `appName`, `appTypeId`, etc.
2. **When a merchant installs the app**, create a `ShopifyShopApp`:
   - Set `shopId`, `appId`, `fromDate`, version, tokens, and `hotwaxInstanceId`
3. **Create the corresponding `ShopifyShop`** record:
   - Pull metadata from Shopify `/shop.json` endpoint.
4. **Assign the shop to an `HotwaxInstance`**:
   - `dev`, `prod`, `uat`, etc.

---

## 3. Token Parsing from Shopify Session Token

The `sessionToken` from Shopify is a signed JWT. We decode it to extract:

- `aud` → the Shopify **clientId** → used to look up `ShopifyApp`
- `dest` → the **shop domain** → used to confirm identity
- `sub` → the **Shopify user ID** making the request

These values are used to build `externalAuthId = dest#sub`.

---

## 4. Token Validation Workflow

1. **Decode JWT** without verification.
2. Extract `aud`, `dest`, `sub`, `exp`, `nbf`, `iss`.
3. Look up `ShopifyApp` by `clientId = aud` and fetch `clientSecret`.
4. Verify JWT using HMAC256 and `iss = dest + '/admin'`.
5. Reject expired or not-yet-valid tokens.
6. Ensure `aud` matches clientId, and domain match between `dest` and known shop.

---

## 5. User Sync & Login

If validation succeeds:

1. Build `externalAuthId = dest#sub`.
2. Find existing `UserLogin` with this ID.
3. If none found:
   - Create new `Party` and `UserLogin`
   - Set `isExternal = Y`, assign default group `SHOPIFY_USER`
4. Generate Moqui login token using `create#moqui.security.UserAccountToken`

**Returned Fields**:
- `userLoginId`, `partyId`, `validToken`, `shopDomain`, `userId`, `appId`, `moquiToken`

---

Let me know if you want visual diagrams or REST resource examples to complete this flow.