# Shopify Event-Based Inventory Sync Implementation

## Purpose

This document describes the current phase 1 implementation for Shopify inventory sync with direct `SECA` action and no dedicated sync history entities.

The goal is to keep the implementation small, understandable, and close to the real OMS business events.

The implementation manages Shopify inventory only for POS/store locations that exist in Shopify. Non-Shopify facilities are out of scope, except the `_NA_` facility reset path used for accumulated inventory.

## Scope

This implementation covers these lanes:

1. Transfer shipment
2. Transfer receipt
3. Store fulfillment shipment
4. Inventory adjustment for cycle count, manual variance, external POS sale, and `_NA_` accumulated inventory reset delta from `ExternalInventoryReset`

Reservation sync is intentionally not included in phase 1. For sales orders, Shopify inventory should change when the POS/store shipment is issued, not when OMS reservation happens.

## What Phase 1 Does Not Add

- no sync history entities
- no outbox entity
- no `SystemMessage`
- no scheduled retry table scan
- no generic `InventoryItemDetail` data feed

Phase 1 is immediate-action integration from `SECA` with logging on failure.

## High-Level Design

```mermaid
classDiagram
    class SecaTrigger {
      +check product store setting
      +call lane sync service
      +log failures
    }
    class TransferSyncService {
      +post#ShopifyTransferShipment
      +receive#ShopifyTransferShipment
    }
    class FulfillmentSyncService {
      +post#ShopifyFulfillment
    }
    class AdjustmentSyncService {
      +post#ShopifyPhysicalInventoryVariance
      +post#ShopifyManualPhysicalInventoryVariance
      +post#ShopifyExternalInventoryReset
      +post#ShopifyInventoryAdjustments
    }

    SecaTrigger --> TransferSyncService
    SecaTrigger --> FulfillmentSyncService
    SecaTrigger --> AdjustmentSyncService
```

## Service Roles

### 1. Transfer Sync Services

Implemented roles:

- `co.hotwax.sob.transfer.ShopifyTransferOrderServices.post#ShopifyTransferShipment`
- `co.hotwax.sob.transfer.ShopifyTransferOrderServices.receive#ShopifyTransferShipment`

Responsibilities:

`post#ShopifyTransferShipment`
- find the shipped OMS transfer shipment
- resolve the Shopify shop from `productStoreId` and mapped route facilities
- aggregate shipment lines by Shopify inventory item
- create Shopify `InventoryTransfer`
- create Shopify `InventoryShipment`
- store created Shopify shipment ids in `ShipmentAttribute` `SHPFY_INV_SHIPMENTS`

`receive#ShopifyTransferShipment`
- process each `ShipmentReceipt` row after commit
- reuse `SHPFY_INV_SHIPMENTS` when already created for the OMS shipment
- if `SHPFY_INV_SHIPMENTS` is missing, initialize Shopify transfer and shipment from the OMS shipment first
- for `TO_Receive_Only`, initialize the Shopify transfer with destination location only and leave origin blank
- call `inventoryShipmentReceive` against the existing Shopify shipment line

### 2. Store Fulfillment Sync Service

Implemented role:

- `co.hotwax.sob.fulfillment.FulfillmentFeedServices.post#ShopifyFulfillment`

Responsibility:

- resolve Shopify order and fulfillment orders
- compare assigned location with actual OMS shipping store
- move the fulfillment order when required
- create the Shopify fulfillment

This is the correct store-shipment equivalent for Shopify.

### 3. Inventory Adjustment Sync Services

Implemented roles:

- `co.hotwax.sob.product.InventoryServices.post#ShopifyPhysicalInventoryVariance`
- `co.hotwax.sob.product.InventoryServices.post#ShopifyManualPhysicalInventoryVariance`
- `co.hotwax.sob.product.InventoryServices.post#ShopifyExternalInventoryReset`
- `co.hotwax.sob.product.InventoryServices.post#ShopifyInventoryAdjustments`

Responsibility:

- handle adjustment-style deltas only
- call `inventoryAdjustQuantities`

This service should be reused for:

- cycle count
- manual variance
- external POS sale where Shopify did not create the sale
- `_NA_` accumulated inventory reset delta from the created `ExternalInventoryReset` record

Manual variance is intentionally filtered:

- `post#ShopifyManualPhysicalInventoryVariance` only syncs when the persisted `InventoryItemDetail` rows for the `physicalInventoryId` do not carry `orderId`, `returnId`, or `shipmentId`
- this prevents order-specific, shipment-specific, or return-specific physical inventory records from being pushed as manual adjustment deltas

## SECA Responsibilities

The `SECA` should do only three things:

1. identify the source business key
2. call the lane sync service
3. log failure without disturbing committed OMS work

The `SECA` should not:

- contain business mapping logic
- build GraphQL payloads
- query Shopify directly

## Suggested SECA Layout

| OMS service | SECA timing | Sync service |
| --- | --- | --- |
| `co.hotwax.poorti.TransferOrderFulfillmentServices.ship#TransferOrderShipment` | `post-commit` | `co.hotwax.sob.transfer.ShopifyTransferOrderServices.post#ShopifyTransferShipment` |
| `create#org.apache.ofbiz.shipment.receipt.ShipmentReceipt` | `post-commit` | `co.hotwax.sob.transfer.ShopifyTransferOrderServices.receive#ShopifyTransferShipment` |
| `co.hotwax.poorti.FulfillmentServices.ship#Shipment` | `post-commit` | `co.hotwax.sob.fulfillment.FulfillmentFeedServices.post#ShopifyFulfillment` |
| `co.hotwax.cycleCount.InventoryCountServices.create#PhysicalInventory` | `post-commit` | `co.hotwax.sob.product.InventoryServices.post#ShopifyPhysicalInventoryVariance` |
| `co.hotwax.poorti.FulfillmentServices.create#PhysicalInventory` | `post-commit` | `co.hotwax.sob.product.InventoryServices.post#ShopifyManualPhysicalInventoryVariance` |
| `create#ExternalInventoryReset` | `post-commit` | `co.hotwax.sob.product.InventoryServices.post#ShopifyExternalInventoryReset` |

## Failure Handling

Phase 1 failure handling is intentionally simple:

- OMS business work is already committed
- Shopify sync is attempted immediately
- failure is logged
- no sync history row is created
- replay is manual in phase 1

Current async behavior is lane-specific:

- transfer shipment sync is async
- fulfillment sync is async
- cycle count variance sync is async
- receipt sync is intentionally not async, to avoid parallel `ShipmentReceipt` rows creating duplicate Shopify transfer/shipment records for the same OMS shipment
- manual physical inventory sync remains immediate post-commit with `ignore-error="true"`

This is acceptable for the first cut because:

- the design stays small
- the business boundary stays clear
- support can inspect logs by source business key

If failures become frequent, the next enhancement should be a small retry or outbox model. That should be justified by production behavior, not added upfront.

## Service Interaction Example

Example: `TO_Receive_Only` warehouse-to-store receipt

1. OMS creates the transfer order and advances it through approval into pending receipt.
2. OMS creates `ShipmentReceipt` rows as the store receives inventory.
3. `SECA` fires after each `ShipmentReceipt` commit.
4. Receipt sync resolves the Shopify shop, destination location, and product inventory item mapping.
5. If `SHPFY_INV_SHIPMENTS` already exists on the OMS shipment, the service reuses those Shopify shipment ids.
6. If `SHPFY_INV_SHIPMENTS` is missing, the service initializes Shopify transfer and shipment from the OMS shipment.
7. For `TO_Receive_Only`, the created Shopify transfer uses destination location only, so origin remains blank on Shopify.
8. The service then calls `inventoryShipmentReceive` for the accepted quantity on the matching Shopify shipment line.
9. Subsequent receipt rows for the same OMS shipment reuse the stored Shopify shipment ids instead of creating new receipt-side Shopify documents.

## Implementation Notes

- fail fast on missing location or product mapping
- never hard reset inventory from these event paths
- use adjustment mutations only for adjustment-style events
- use transfer and shipment APIs only for actual transfer movement
- do not mirror OMS lifecycle for control purposes in Shopify
- skip non-Shopify facilities except the explicitly handled `_NA_` accumulated inventory reset path
- do not implement reservation sync in phase 1
- persist Shopify transfer shipment ids on the OMS shipment using `ShipmentAttribute` `SHPFY_INV_SHIPMENTS`
- for `TO_Receive_Only`, treat shipment-level initialization as the normal path when no prior Shopify shipment exists
- one `ExternalInventoryReset` row currently results in one Shopify adjustment call; reset rows are not grouped by `resetDateResourceId` in phase 1

## Operational Note

This approach is the right starting point for a small implementation.

It gives immediate sync at the right OMS boundary without introducing extra entities. If reliability gaps appear later, then add persistent replay after observing actual failure patterns.
