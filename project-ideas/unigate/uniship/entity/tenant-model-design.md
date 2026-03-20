# Tenant Model Design — UniShip Shipping Gateway Microservice

## Overview

This document outlines the entity design and onboarding flow for a **multi-tenant shipping gateway microservice** built using the **Moqui Framework**. The system enables tenants (retailers) to interact with remote shipping carriers (e.g., Shippo, FedEx, ShipHawk) via a uniform API interface provided by UniShip.

---

## 🎯 Goals

1. Multi-tenant configuration for gateway authentication.
2. Clear separation between shared gateway logic and tenant-specific credentials.
3. Full auditability via immutable configuration records.

---

## 🔧 Core Entities Referenced in Tenant Setup

| Entity                      | Purpose                                                                            |                                                                                    |
| --------------------------- | ---------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------- |
| `Party`, `PartyRole`        | Defines tenants.                                                                   |                                                                                    |
| `SystemMessageRemote`       | Stores **tenant-specific credentials** and endpoint config natively.               | Stores **tenant-specific credentials** and endpoint config natively.               |
| `ShippingGatewayAuth`       | Maps credentials to a tenant and gateway config. Supports immutability via dates.  | Maps credentials to a tenant and gateway config. Supports immutability via dates.  |

---

---

## Tenant Onboarding Flow

### Step 1: Retailer Signs Up (via `create#UnishipTenant` service)

* Creates a Party of type `PtyOrganization`.
* Returns `tenantPartyId`.

### Step 2: Admin Configures Shipping Credentials

* Tenant admin selects from a predefined list of available shipping gateways (configured by the platform admin in `ShippingGatewayConfig`) and creates one or more immutable mapping records in `ShippingGatewayAuth` scoped to `tenantPartyId`, alongside their credentials provisioned securely in `SystemMessageRemote`.

---

## 🔐 Entity Definitions: `ShippingGatewayAuth` & `SystemMessageRemote`

> The auth mapping entity is **immutable**. Any change to credentials or endpoint must result in a **new record**. The previous mapping record should be expired using `thruDate` (note: `thruDate` exists purely on the mapping entity, not on `SystemMessageRemote`).

### `moqui.service.message.SystemMessageRemote`
Moqui's native messaging entity used to securely store `sendUrl`, `username`, `password`, `publicKey`, and `sharedSecret`.

### `co.hotwax.unigate.ShippingGatewayAuth`

```xml
<entity entity-name="ShippingGatewayAuth" package="co.hotwax.unigate" cache="true">
    <field name="systemMessageRemoteId" type="id" is-pk="true"/>
    <field name="shippingGatewayConfigId" type="id" is-pk="true"/>
    <field name="tenantPartyId" type="id" is-pk="true"/>
    <field name="fromDate" type="date-time" is-pk="true"/>
    <field name="thruDate" type="date-time"/>
    
    <relationship type="one" related="moqui.service.message.SystemMessageRemote" short-alias="remote"/>
    <relationship type="one" related="co.hotwax.unigate.ShippingGatewayConfig"/>
    <relationship type="one" related="co.hotwax.unigate.Party" short-alias="tenant">
        <key-map field-name="tenantPartyId"/>
    </relationship>
</entity>
```

---

## 🧩 Operational Logic

| Concern                                     | Resolution                                                                                                                          |
| ------------------------------------------- |-------------------------------------------------------------------------------------------------------------------------------------|
| Retailer signs up with FedEx                | Use `create#UnishipTenant`, then `POST /rest/s1/unigate/shippingGatewayAuth` replacing `create#ShippingGatewayAuthConfig`           |
| Update required for auth or endpoint config | Create new auth record and nested credentials, set `fromDate`, expire previous auth mapping with `thruDate`                                                                  |
| Querying active config                      | Use `conditionDate("fromDate", "thruDate", now)` in entity-find on `ShippingGatewayAuth`                                                                     |

---

## 🧠 Best Practices


* Never overwrite credentials directly inside a configuration — simply insert newer mapping records or expire old mapping records using `thruDate` (on `ShippingGatewayAuth`).

* Use only `fromDate`/`thruDate` and `conditionDate` — the auth mapping entity natively tracks history instead of using an `isActive` boolean.

* Secure sensitive fields with encryption (natively handled by `moqui.service.message.SystemMessageRemote`).

* Filter all entity queries to return only current/valid configurations and sort them to prioritize the latest configurations.

---

## ✅ Summary

| Layer      | Model                                                                     |
| ---------- | ------------------------------------------------------------------------- |
| Party      | Retailers (tenants) and carriers                                          |
| Gateway    | `ShippingGatewayConfig`                                                   |
| Credential | `SystemMessageRemote` (data) & `ShippingGatewayAuth` (immutable mapping)  |

All components are connected via `tenantPartyId`, ensuring clean separation and secure access for multi-tenant integration workflows.
