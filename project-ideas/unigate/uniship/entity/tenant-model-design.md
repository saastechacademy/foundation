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
| `ShippingGatewayAuthConfig` | Stores **tenant-specific credentials** and endpoint config. Supports immutability. | Stores **tenant-specific credentials** and endpoint config. Supports immutability. |

---

---

## 🚀 Tenant Onboarding Flow

### Step 1: Retailer Signs Up (via `create#UnishipTenant` service)

* Creates a Party of type `PtyOrganization`.
* Returns `tenantPartyId`.

### Step 2: Admin Configures Shipping Credentials

* Tenant admin selects from a predefined list of available shipping gateways (configured by the platform admin in `ShippingGatewayConfig`) and creates one or more immutable records in `ShippingGatewayAuthConfig` scoped to `tenantPartyId`.

---

## 🔐 Entity Definition: `ShippingGatewayAuthConfig`

> This entity is **immutable**. Any change to credentials or endpoint must result in a **new record**. The previous record should be expired using `thruDate`.

```xml
<entity entity-name="ShippingGatewayAuthConfig" package="co.hotwax.uniship"
        use="configuration" cache="true">
    <description>Stores per-tenant authentication and endpoint info for shipping gateways.</description>

    <field name="shippingGatewayAuthConfigId" type="id" is-pk="true"/>
    <field name="tenantPartyId" type="id" not-null="true"/>
    <field name="shippingGatewayConfigId" type="id" not-null="true"/>

    <field name="modeEnumId" type="id"/>
    <field name="authTypeEnumId" type="id" not-null="true"/>
    <field name="baseUrl" type="text-medium" not-null="true"/>

    <!-- Credentials -->
    <field name="apiKey" type="text-medium" encrypt="true"/>
    <field name="username" type="text-medium"/>
    <field name="password" type="text-medium" encrypt="true"/>
    <field name="sharedSecret" type="text-medium" encrypt="true"/>

    <!-- OAuth2 Fields -->
    <field name="oauthTokenUrl" type="text-medium"/>
    <field name="clientId" type="text-medium"/>
    <field name="clientSecret" type="text-medium" encrypt="true"/>

    <!-- Validity Window -->
    <field name="fromDate" type="date-time" not-null="true"/>
    <field name="thruDate" type="date-time"/>
    <field name="description" type="text-medium"/>

    <!-- Relationships -->
    <relationship type="one" related="co.hotwax.uniship.Party" short-alias="tenant">
        <key-map field-name="tenantPartyId"/>
    </relationship>
    <relationship type="one" related="moqui.basic.Enumeration" short-alias="authType">
        <key-map field-name="authTypeEnumId"/>
    </relationship>
    <relationship type="one" related="moqui.basic.Enumeration" short-alias="mode">
        <key-map field-name="modeEnumId"/>
    </relationship>
    <relationship type="one" related="co.hotwax.uniship.ShippingGatewayConfig" short-alias="gatewayConfig">
        <key-map field-name="shippingGatewayConfigId"/>
    </relationship>
</entity>
```

---

## 🧩 Operational Logic

| Concern                                     | Resolution                                                                                                                          |
| ------------------------------------------- |-------------------------------------------------------------------------------------------------------------------------------------|
| Retailer signs up with FedEx                | Use `create#UnishipTenant`, then `create#ShippingGatewayAuthConfig` and create#UserLoginKey for tenant to securely call uniship API |
| Update required for auth or endpoint config | Create new record, set `fromDate`, expire previous with `thruDate`                                                                  |
| Querying active config                      | Use `conditionDate("fromDate", "thruDate", now)` in entity-find                                                                     |

---

## 📚 Enum & Seed Data

```xml
<moqui.basic.EnumerationType enumTypeId="ShippingGatewayAuthType" description="Shipping Gateway Auth Type"/>
<moqui.basic.Enumeration enumId="SgatApiKey" description="API Key" enumTypeId="ShippingGatewayAuthType"/>

<moqui.basic.EnumerationType enumTypeId="ShippingGatewayMode" description="Shipping Gateway Mode"/>
<moqui.basic.Enumeration enumId="SgmSandbox" description="Sandbox" enumTypeId="ShippingGatewayMode"/>
<moqui.basic.Enumeration enumId="SgmProduction" description="Production" enumTypeId="ShippingGatewayMode"/>
```

---

## 🧠 Best Practices

* Only one active `ShippingGatewayAuthConfig` should exist at any time for a given `(tenantPartyId + shippingGatewayConfigId)` pair.

* Validate `fromDate`/`thruDate` to prevent overlapping validity windows.

* Never overwrite credentials — expire old records using `thruDate`.

* Use only `fromDate`/`thruDate` and `conditionDate` — the entity does not include an `isActive` field.

* Secure sensitive fields with encryption.

* Filter all entity queries to return only current/valid configurations.

---

## ✅ Summary

| Layer      | Model                                               |
| ---------- | --------------------------------------------------- |
| Party      | Retailers (tenants) and carriers                    |
| Gateway    | `ShippingGatewayConfig`                             |
| Credential | `ShippingGatewayAuthConfig` (immutable, per-tenant) |

All components are connected via `tenantPartyId`, ensuring clean separation and secure access for multi-tenant integration workflows.
