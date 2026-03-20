# `create#UnishipTenant` Service

## 1. Overview

The `create#UnishipTenant` service provisions a new Tenant for the UniShip application.

A **Tenant** is:
- An Organization-type `Party`
- A registered client that consumes UniShip's REST APIs
- Authenticated via a secure `loginKey` and `tenantPartyId`

This service creates the following:
- A Party (with `partyTypeEnumId` = `PtyOrganization`)
- An associated `UserAccount` for API authentication

---

## 2. Input Parameters

| Name              | Type    | Required | Description                      |
|-------------------|---------|----------|----------------------------------|
| organizationName  | String  | Yes      | Name of the organization tenant. |

---

## 3. Output Parameters

| Name            | Type    | Description                                                                     |
|-----------------|---------|---------------------------------------------------------------------------------|
| tenantPartyId   | String  | The `partyId` created for the tenant organization, returned as `tenantPartyId`. |

---

## 4. Processing Logic

### Step-by-step execution:

#### ✅ Step 1: Create Party and Organization
- Uses `create#co.hotwax.uniship.Party`
- Creates a `Party` of type `PtyOrganization`
- Creates a related `Organization` record

```groovy
<service-call name="create#co.hotwax.uniship.Party"
              in-map="[partyTypeEnumId: 'PtyOrganization', organization: [organizationName: organizationName]]"
              out-map="context"/>
```

#### ✅ Step 2: Create UserAccount
- Uses `create#moqui.security.UserAccount`
- `partyId` is reused as the `username`
- This allows the tenant to be authenticated as a system user

```groovy
<service-call name="create#moqui.security.UserAccount"
              in-map="[partyId: partyId, username: partyId]"
              out-map="context"/>
```

- The value of `partyId` from above is mapped to `tenantPartyId` in the final output.

#### ✅ create#UserLoginKey service to Generate and Store Login Key
- A secure 40-character random string is generated
- It is hashed using Moqui’s configured login key hash algorithm
- A `UserLoginKey` record is inserted with current timestamp

```groovy
<script>
    import org.moqui.util.StringUtilities

    loginKey = StringUtilities.getRandomString(40)
    String hashedKey = ec.ecfi.getSimpleHash(loginKey, "", ec.ecfi.getLoginKeyHashType(), false)

    ec.service.sync().name("create#moqui.security.UserLoginKey")
        .parameters([loginKey: hashedKey, userId: userId, fromDate: ec.user.nowTimestamp])
        .disableAuthz().call()

    tenantPartyId = partyId
</script>
```

---

## 5. Authentication & Usage Guidance

- The returned `tenantPartyId` uniquely identifies the tenant.
- The returned `loginKey` is **only shown once**; it should be stored securely by the tenant.
- For every REST API call to UniShip, the client must send:

```
Headers:
X-Tenant-Id: {tenantPartyId}
X-Login-Key: {loginKey}
```

- These are validated by `TenantAuthFilter` using view-entity `UserLoginKeyWithParty`, which:
  - Verifies hashed loginKey and partyId match
  - Ensures current time is within the validity window (`fromDate` to `thruDate`)

---

## 6. Internal Services Used

| Service Name                          | Purpose                                     |
|--------------------------------------|---------------------------------------------|
| `create#co.hotwax.uniship.Party`     | Creates Party and Organization records      |
| `create#moqui.security.UserAccount`  | Creates a system user for the tenant        |
| `create#moqui.security.UserLoginKey` | Registers the tenant’s API login key        |

---

## 7. Notes for Developer and Support Teams

- If a tenant loses the `loginKey`, a create#UserLoginKey service is used regenerate it.
- You may want to add expiry (`thruDate`) handling in future releases.
- Ensure this service is **authz-disabled** if exposed externally, and guarded behind an admin layer or internal provisioning portal.
