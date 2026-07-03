# Tenant Model Design — Unigate Integration Gateway Microservice

## Overview

This document outlines the entity design and onboarding flow for a **multi-tenant shipping gateway microservice** built using the **Moqui Framework**. The system enables tenants (retailers) to interact with remote shipping carriers (e.g., Shippo, FedEx, ShipHawk) via a uniform API interface provided by Unigate.

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

### Step 1: Retailer Signs Up (via `create#UnigateTenant` service)

* Creates a Party of type `PtyOrganization`.
* Returns `tenantPartyId`.

### Step 2: Admin Configures Shipping Credentials

* Tenant admin selects from a predefined list of available shipping gateways (configured by the platform admin in `ShippingGatewayConfig`) and creates one or more mapping records in `ShippingGatewayAuth` scoped to `tenantPartyId`, alongside their credentials provisioned.

---

## 🧩 Operational Logic

| Concern                                     | Resolution                                                                                                          |
| ------------------------------------------- |---------------------------------------------------------------------------------------------------------------------|
| Retailer signs up with FedEx                | Use `create#UnigateTenant`, then `POST /rest/s1/unigate/shippingGatewayAuth`  `create#ShippingGatewayAuth` |

---


## ✅ Summary

| Layer      | Model                                                                    |
| ---------- | ------------------------------------------------------------------------ |
| Party      | Retailers (tenants) and carriers                                         |
| Gateway    | `ShippingGatewayConfig`                                                  |
| Credential | `ShippingGatewayAuth`   |

All components are connected via `tenantPartyId`, ensuring clean separation and secure access for multi-tenant integration workflows.
