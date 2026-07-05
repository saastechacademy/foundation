# Tenant Onboarding

This document covers the complete flow for provisioning a new tenant in Unigate — from creating the party record to making the first authenticated API call.

A "tenant" in Unigate is any system (typically an OMS instance) that consumes UniMail or UniShip services. Each tenant is represented as a `Party` of type `PtyOrganization` and authenticates via a hashed API key.

---

## Overview

Onboarding has three steps:

1. **Create the tenant** — registers the Party, UserAccount, and group membership
2. **Generate an API key** — produces the plaintext key the tenant will use in request headers
3. **Configure gateway credentials** — links the tenant to one or more carrier or email provider accounts

Steps 1 and 2 are performed by an administrator. Step 3 can be done by either the administrator or the tenant admin through the Unigate UI.

---

## Step 1 — Create the Tenant

Call `co.hotwax.unigate.UnigateTenantServices.create#UnigateTenant`.

**Input**

| Parameter | Type | Required | Description |
|---|---|---|---|
| `organizationName` | String | Yes | Human-readable name (e.g. "Acme Corp") |
| `partyId` | String | No | Explicit party ID; auto-generated if omitted |

**What it does internally:**

```
create#UnigateTenant
  → create#co.hotwax.unigate.Party
      (partyTypeEnumId = 'PtyOrganization', organizationName = <input>)
  → create#moqui.security.UserAccount
      (userId = partyId, username = partyId, partyId = partyId)
  → create#moqui.security.UserGroupMember
      (userId = partyId, userGroupId = 'UNIGATE_API')
```

The `UNIGATE_API` user group controls which API endpoints the tenant can reach. All tenants are added to it automatically.

**Output**

```json
{ "partyId": "ACME_001" }
```

The returned `partyId` is the tenant's permanent identifier — it will appear as `tenantPartyId` in all gateway auth records.

---

## Step 2 — Generate an API Key

Call `co.hotwax.unigate.UnigateTenantServices.create#UserLoginKey`.

**Input**

| Parameter | Type | Required | Description |
|---|---|---|---|
| `userLoginId` | String | Yes | The `partyId` from Step 1 |

**What it does internally:**

```
create#UserLoginKey
  → loginKey = StringUtilities.getRandomString(40)
  → hashedKey = ec.ecfi.getSimpleHash(loginKey, "", LoginKeyHashType, false)
  → create#moqui.security.UserLoginKey
      (loginKey = hashedKey, userId = partyId, fromDate = now)
  → return plaintext loginKey to caller
```

**Output**

```json
{ "loginKey": "a7f2c9...40-char-random-string..." }
```

> **This is the only time the plaintext key is returned.** Unigate stores the hashed value. If the tenant loses the key, generate a new one — the old record stays in the database but a new one is created alongside it.

The tenant must include this key as the `api_key` header on every subsequent request, paired with their `tenant_Id` (the `partyId`).

---

## Step 3 — Configure Gateway Credentials

Before the tenant can call UniMail or UniShip, an administrator must create at least one gateway auth record tying the tenant to a specific provider.

### For Email (UniMail)

Create a `CommGatewayAuth` record:

```
POST /rest/s1/unigate/commGatewayAuth   (or via admin UI)

{
  "tenantPartyId": "ACME_001",
  "commGatewayConfigId": "MAYUR",       ← must exist in CommGatewayConfig
  "authTypeEnumId": "NoAuth",
  "baseUrl": "https://api.mayur.internal",
  "description": "Acme Mayur production"
}
```

The returned `commGatewayAuthId` is what the tenant passes in their email API calls.

### For Shipping (UniShip)

Create a `ShippingGatewayAuth` record:

```
POST /rest/s1/unigate/shippingGatewayAuth   (or via admin UI)

{
  "tenantPartyId": "ACME_001",
  "shippingGatewayConfigId": "FEDEX_CONFIG",   ← must exist in ShippingGatewayConfig
  "authTypeEnumId": "OAuth2",
  "baseUrl": "https://apis-sandbox.fedex.com",
  "clientId": "acme-fedex-client-id",
  "clientSecret": "acme-fedex-client-secret",
  "modeEnumId": "Sandbox",
  "description": "Acme FedEx sandbox account"
}
```

The returned `shippingGatewayAuthId` is what the tenant passes in their shipping API calls.

For scenarios where a single tenant needs **separate credentials per facility**, see [Carrier Account Management](../uniship/CarrierAccountManagement.md).

---

## Setting Up in OMS (Maarg)

In practice, Steps 1–3 above are never done by calling Unigate APIs directly. The **Unigate screen in Maarg** (`Oms > Unigate`) handles the full setup workflow for both email and shipping integrations. This is the primary interface for configuring the OMS side of the connection.

The Unigate section has two subscreens: **Communication Gateway** and **Shipping Gateway**.

---

### Prerequisite: UNIGATE_CONFIG

Both subscreens rely on a single `SystemMessageRemote` record in Maarg with `systemMessageRemoteId = UNIGATE_CONFIG`. This is the OMS's connection configuration to the Unigate instance — it stores:

| Field | Purpose |
|---|---|
| `internalId` | The Unigate `tenantPartyId` (the `partyId` created in Step 1 above) |
| `publicKey` | The plaintext API key returned from Step 2 (stored here for use by all OMS services) |
| `sendUrl` | The Unigate instance base URL (e.g. `https://unigate.hotwax.co`) |

The screen reads `UNIGATE_CONFIG` on load. If it is missing or incomplete, both subscreens are locked and show an error: *"UNIGATE_CONFIG is incomplete. Please finish configuring Tenant ID, API Key, and Instance URL."*

The **Communication Gateway** screen has a **Setup Tenant** button (visible only when `UNIGATE_CONFIG` does not yet exist). Clicking it opens a dialog to enter the Tenant ID, API Key, and Instance URL — this creates or updates the `UNIGATE_CONFIG` record. Once saved, the rest of the screen unlocks.

---

### Communication Gateway Screen

**Path:** `Oms > Unigate > Communication Gateway`

Once `UNIGATE_CONFIG` is set, this screen manages the full email integration setup in two sections:

#### 1. Communication Gateway Auths

This section lists all `CommGatewayAuth` records for the active tenant, fetched directly from Unigate via `UnigateServices.get#CommGatewayAuths`.

Use **Add Comm Auth** to create a new credential record. The dialog collects:
- `commGatewayConfigId` — the provider to use (populated from `CommGatewayConfig` records in Unigate)
- `commGatewayAuthId` — a unique identifier you assign (e.g. `KLAVIYO_PROD`)
- `baseUrl`, `publicKey`, `username`, `password`, `authHeaderName` — provider-specific auth fields

On submit, this calls `UnigateServices.create#CommGatewayAuth`, which proxies the call to the Unigate REST API and creates the `CommGatewayAuth` record in Unigate. The `commGatewayAuthId` returned here is what you'll reference in product store email settings.

Existing records can be edited or deleted inline.

#### 2. Product Store Email Settings

This section manages `ProductStoreEmailSetting` records — the OMS entity that ties an email type (e.g. `ORDER_COMPLETION`, `READY_FOR_PICKUP`) to a specific Unigate auth and email template.

Use **Add Email Setting** to create a new mapping. The dialog collects:
- `productStoreId` — which product store this setting applies to
- `emailType` — the email event type (from the `PRDS_EMAIL` enumeration)
- `fromAddress`, `subject` — sender and subject line
- `bodyScreenLocation` — the FreeMarker/Klaviyo template to render (dynamically loaded from `dbresource://oms/template/email/klaviyo/{emailType}/`)
- `gatewayAuthId` — the `commGatewayAuthId` to use for sending (populated from the auth list above)
- `systemMessageRemoteId` — defaults to `UNIGATE_CONFIG`

For Klaviyo-backed email types, the **Flow** column in the settings list shows whether a Klaviyo flow already exists for that template. If not, clicking **Flow** (+) triggers `UnigateServices.create#KlaviyoEmailFlow` to provision the flow in Klaviyo via Unigate.

---

### Shipping Gateway Screen

**Path:** `Oms > Unigate > Shipping Gateway`

This screen manages the shipping side of the integration. It has three sections:

#### 1. Shipping Gateway Auths

Lists all `ShippingGatewayAuth` records for the active tenant, fetched from Unigate via `UnigateServices.get#ShippingGatewayAuths`.

Use **Add Ship Auth** to create a new credential record. The dialog collects:
- `shippingGatewayConfigId` — the carrier config to use (e.g. `FEDEX_CONFIG`; populated from Unigate's `ShippingGatewayConfig` records)
- `shippingGatewayAuthId` — a unique identifier you assign (e.g. `SMUS_FEDEX_01`)
- `baseUrl` — carrier API base URL (sandbox or production)
- `publicKey`, `username`, `password`, `authHeaderName` — carrier-specific credentials

On submit, this calls `UnigateServices.create#ShippingGatewayAuth`, which proxies to the Unigate REST API and creates the record in Unigate. The `shippingGatewayAuthId` is then used in carrier configs below.

#### 2. Shipping Carrier Configurations

Lists `ShippingCarrierConfig` records in Maarg — these are the facility-level mappings that tell OMS which Unigate auth to use for a given carrier at a given facility. Full CRUD is available. Key fields include the `shippingGatewayAuthId` (pointing to the record created above), `facilityId`, `carrierPartyId`, label size, weight UOM, and packaging type.

#### 3. Shipping Carrier Billing Configurations

Lists `ShippingCarrierBillingConfig` records — billing overrides per carrier and sales channel. Also fully managed from this screen.

---

## Related Documents

- [TenantAuthFilter](../TenantAuthFilter.md) — how the API key is validated per request
- [Entity Model](../entity/entity-model.md) — full entity definitions
- [CommGatewayAuth](../entity/CommGatewayAuth.md) — email credential entity
- [ShippingGatewayAuth](../entity/ShippingGatewayAuth.md) — shipping credential entity
- [Carrier Account Management](../uniship/CarrierAccountManagement.md) — multi-facility credential pattern

