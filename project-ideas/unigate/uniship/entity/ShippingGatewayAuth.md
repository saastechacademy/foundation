# Configure `ShippingGatewayAuth`

## 1. Overview

The `ShippingGatewayAuth` mapping record is the critical bridge connecting a tenant to a shipping carrier gateway and their private authentication credentials. 

This entity is **immutable**. To update any credential mapping, a **new record must be created**, and the previous mapping record should be **expired by setting its `thruDate`**. This ensures a complete history of configuration changes for audit and rollback purposes across all tenants.

---

## 2. Purpose

* Maps a specific tenant to a predefined shipping gateway (e.g., FedEx, USPS).
* Links to the raw credentials securely stored in Moqui's native `moqui.service.message.SystemMessageRemote`.
* Ensures traceability and historical accuracy by enforcing immutability natively via `fromDate` scaling.

---

## 3. Entity: `ShippingGatewayAuth`

| Field Name                  | Type     | Required | Description                                                                                |
| --------------------------- | -------- | -------- | ------------------------------------------------------------------------------------------ |
| systemMessageRemoteId       | String   | Yes      | Primary key (Part 1). Links to the encrypted credentials.                                  |
| shippingGatewayConfigId     | String   | Yes      | Primary key (Part 2). Refers to the predefined shipping gateway type (e.g., FedEx).        |
| tenantPartyId               | String   | Yes      | Primary key (Part 3). Party ID of the specific tenant using this configuration.            |
| fromDate                    | DateTime | Yes      | Primary key (Part 4). Effective start date, enabling multiple historical records.          |
| thruDate                    | DateTime | No       | Expiry date, if any.                                                                       |

> **Note on Credentials:** Sensitive connection details like the API Key, Shared Secret, Username, and Password, alongside the actual connection URL are **never** stored in `ShippingGatewayAuth`. They are instead securely managed inside the linked `SystemMessageRemote` record.

---

## 4. Setup Workflow

### Step-by-Step Instructions

1. **Tenant Manager Logs In**
   A privileged user logs into the UniShip tenant manager interface.

2. **Navigate to Shipping Gateway Setup Page**
   Admin chooses to configure shipping gateway access for the tenant.

3. **Provide Secure Credentials to SystemMessageRemote**
   The system securely provisions a new `SystemMessageRemote` record, automatically encrypting the provided authentication tokens and URLs.
   
4. **Choose Gateway Type**
   Admin selects from predefined gateway options (sourced from the global `ShippingGatewayConfig` entity).

5. **Create Immutable Mapping**
   A new record is generated in the `ShippingGatewayAuth` entity scoped directly to the `tenantPartyId`, `shippingGatewayConfigId`, and the newly created `systemMessageRemoteId`.

6. **Effective Dating**
   The mapping is effective immediately via `fromDate`.
   
7. **Update Handling**
   If changes are needed later, a new `SystemMessageRemote` and `ShippingGatewayAuth` mapping is provisioned, and the old mapping's `thruDate` is populated.

---

## 5. Security Considerations

* Credential fields (e.g., `password`, `sharedSecret`) are natively encrypted at rest by Moqui inside `SystemMessageRemote`.
* The `ShippingGatewayAuth` table serves purely as a lookup router without ever exposing the sensitive string values directly.
* All backend API calls should filter entity queries using `conditionDate("fromDate", "thruDate", now)` to return only current/valid mappings and sort them descending by `fromDate`.

---

## 6. Internal Entity Relationship

* `tenantPartyId` → references the tenant Organization (`Party`)
* `shippingGatewayConfigId` → references the global definition for the carrier (`ShippingGatewayConfig`)
* `systemMessageRemoteId` → references the safe vault for credentials (`SystemMessageRemote`)
