# Tenant Model Design — Unigate Integration Gateway

## Overview

This document describes the entity design and onboarding flow for Unigate's multi-tenant integration platform. The system enables tenants (retailers / OMS instances) to interact with shipping carriers and communication providers via a uniform API, with all tenant-specific credentials stored and isolated per `tenantPartyId`.

---

## 🎯 Goals

1. Multi-tenant configuration for gateway authentication.
2. Clear separation between shared gateway logic and tenant-specific credentials.

---

## 🔧 Core Entities Referenced in Tenant Setup

Entity
`Party`, 
`PartyRole`

---

---

## Tenant Onboarding Flow

### Step 1: Tenant Provisioning (via `create#UnigateTenant` service)

* Calls `co.hotwax.unigate.UnigateTenantServices.create#UnigateTenant`.
* Creates a `Party` of type `PtyOrganization` in the `co.hotwax.unigate` package.
* Creates an associated `UserAccount` (userId = partyId) and adds to the `UNIGATE_API` user group.
* Returns `partyId` as the permanent tenant identifier.

### Step 2: Configure Gateway Credentials

* Tenant admin selects from available shipping or communication gateways (configured by the platform admin in `ShippingGatewayConfig` or `CommGatewayConfig`).
* Creates one or more `ShippingGatewayAuth` or `CommGatewayAuth` records scoped to `tenantPartyId`, with their carrier API credentials.
* The returned auth ID is passed in every subsequent API call.

---

## 🧩 Operational Logic

| Concern | Resolution |
| ------------------------------------------- |---------------------------------------------------------------------------------------------------------------------|
| Retailer signs up with FedEx | Use `create#UnigateTenant`, then create `ShippingGatewayAuth` with `shippingGatewayConfigId=FEDEX_CONFIG` |
| Retailer signs up with Klaviyo | Use `create#UnigateTenant`, then create `CommGatewayAuth` with `commGatewayConfigId=KLAVIYO` |

---


## ✅ Summary

| Layer      | Model                                                                    |
| ---------- | ------------------------------------------------------------------------ |
| Party      | Retailers (tenants) and carriers                                         |
| Gateway    | `ShippingGatewayConfig`                                                  |
| Credential | `ShippingGatewayAuth`   |

All components are connected via `tenantPartyId`, ensuring clean separation and secure access for multi-tenant integration workflows.
