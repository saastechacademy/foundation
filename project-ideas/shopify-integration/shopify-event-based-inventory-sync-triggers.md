# Shopify Event-Based Inventory Sync Triggers

## Purpose

This document defines the trigger points for a simple OMS to Shopify inventory sync.

OMS remains the system of record. Shopify is updated only for the inventory effect of OMS events at mapped Shopify locations. The design is delta-based only. It does not use daytime hard reset.

## Pre-Requisites

- OMS and Shopify inventory levels must match before this design is enabled.
- Sync must run only for product stores where a dedicated `ProductStoreSetting`, for example `SHOPIFY_INV_SYNC`, enables Shopify inventory sync.
- If the product store setting is off, the `SECA` must not attempt Shopify inventory sync.

Without a matched starting baseline, a delta-only design will drift instead of converge.

## Design Summary

Phase 1 is intentionally simple:

1. A service `SECA` runs after the OMS business service completes.
2. The `SECA` immediately tries to post the Shopify delta workflow.
3. If Shopify sync succeeds, nothing else is persisted just for sync tracking.
4. If Shopify sync fails or the trigger path is missed, log the failure context for support and manual replay.

This design does not use `SystemMessage`. It also does not introduce sync history entities in phase 1.

## Core Principles

- OMS decides the business event.
- Shopify receives only the inventory effect of that event.
- Only deltas are posted to Shopify.
- No daytime hard reset should be used for these flows.
- `SECA` is the primary integration trigger.
- Failure handling is log-first in phase 1.
- Transfer lifecycle is not mirrored in Shopify for business control. Transfer APIs are used only when Shopify requires them for inventory movement.

## Processing Flow

```mermaid
flowchart TD
    A[OMS business service completes] --> B[SECA checks ProductStoreSetting]
    B -->|sync disabled| C[Skip]
    B -->|sync enabled| D[Call Shopify sync service]
    D -->|success| E[Finish]
    D -->|failure| F[Write structured failure log]
```

## Sequence View

```mermaid
sequenceDiagram
    participant OMS as OMS Service
    participant SECA as Service SECA
    participant SYNC as Shopify Sync Service
    participant SHOP as Shopify

    OMS->>SECA: business transaction committed
    SECA->>SECA: check ProductStoreSetting
    SECA->>SYNC: call lane-specific sync service
    SYNC->>SHOP: post delta workflow
    SHOP-->>SYNC: success or error
    SYNC-->>SECA: result
    SECA-->>SECA: log failure when needed
```

## Trigger Matrix

| OMS event | SECA trigger boundary | Sync service | Shopify workflow | Notes |
| --- | --- | --- | --- | --- |
| Store-origin TO reservation reduces ATP | `co.hotwax.oms.impl.OrderReservationServices.process#OrderItemAllocation` after commit, only for transfer orders originating from stores | `sync#TransferReservationToShopify` | Create or update a minimal Shopify `InventoryTransfer` and move it to `READY_TO_SHIP` so origin `available` decreases and `reserved` increases | This exists only because Shopify cannot create `InventoryShipment` without `InventoryTransfer` |
| Store-origin TO outbound shipment reduces QOH | `co.hotwax.poorti.TransferOrderFulfillmentServices.ship#TransferOrderShipment` post-service | `sync#TransferShipmentToShopify` | Create `InventoryShipment`, then mark it in transit | This reproduces origin `on_hand` reduction and destination `incoming` increase |
| TO inbound receipt into store increases ATP and QOH | `ShipmentReceipt` create or update, grouped by `shipmentId + datetimeReceived + facilityId` | `sync#TransferReceiptToShopify` | `inventoryShipmentReceive` | Receipt must be shipment-backed for Shopify; non-shipment OMS receipts stay in exception handling |
| Online order shipped from store | `co.hotwax.poorti.FulfillmentServices.ship#Shipment` post-service | `sync#StoreFulfillmentToShopify` | Move Fulfillment Order to actual store when needed, then create fulfillment | This ensures Shopify applies fulfillment against the actual shipping store |
| External POS sale or non-Shopify sale reduces inventory | dedicated sales posting service boundary | `sync#InventoryAdjustmentToShopify` | `inventoryAdjustQuantities` | Use only when Shopify is not already the system that created the sale |
| Cycle count or approved manual variance changes QOH and ATP | `co.hotwax.cycleCount.InventoryCountServices.create#PhysicalInventory` when variance is applied | `sync#InventoryAdjustmentToShopify` | `inventoryAdjustQuantities` | Manual variance follows the same lane |
| External reset accepted by OMS | `reset#InventoryItem` or `create#ExternalInventoryReset` completion | `sync#InventoryAdjustmentToShopify` | `inventoryAdjustQuantities` using computed delta only | Even this lane stays delta-based after OMS computes the difference |
| TO cancel before shipment or receipt | `co.hotwax.orderledger.order.TransferOrderServices.cancel#TransferOrder` post-service | `sync#TransferReservationReleaseToShopify` | Cancel the related Shopify transfer or remove remaining draft or ready quantities so origin `available` is restored | Use this only to reverse inventory already deducted on Shopify by the earlier reservation delta; OMS blocks TO cancel once shipment or receipt has started |
| TO reject before shipment | `co.hotwax.poorti.TransferOrderFulfillmentServices.reject#TransferOrder` post-service | `sync#TransferReservationReleaseToShopify` | Cancel the related Shopify transfer or remove remaining quantities from the sellable route | Use this only to reverse inventory already deducted on Shopify by the earlier reservation delta |
| SO cancel before shipment | `co.hotwax.orderledger.order.OrderServices.cancel#SalesOrderItem` post-service | `sync#SalesReservationReleaseToShopify` | Reverse the earlier reservation delta so facility `available` increases | Use this when OMS owned the reservation that had already reduced Shopify ATP |
| SO reject before shipment | `co.hotwax.oms.order.OrderServices.reject#OrderItem` post-service | `sync#SalesReservationReleaseToShopify` | Reverse the earlier reservation delta so facility `available` increases | Use this when OMS owned the reservation that had already reduced Shopify ATP |

## Shopify Workflow By Lane

### 1. Store Fulfillment Lane

Use this for online orders fulfilled from stores.

Workflow:

1. Resolve the Shopify order and open fulfillment orders.
2. Resolve the actual shipping facility in OMS.
3. If Shopify assigned a different location, move the fulfillment order to the actual store.
4. Create the Shopify fulfillment from that store.

### 2. Transfer Shipment Lane

Use this for store to warehouse, warehouse to store, and store to store transfer movement.

Workflow:

1. On OMS reservation, create the minimum `InventoryTransfer` needed for Shopify inventory reservation.
2. On OMS ship, create `InventoryShipment` and mark it in transit.
3. On OMS receive, call `inventoryShipmentReceive`.
4. On OMS cancel or reject before ship, cancel or shrink the Shopify transfer so reserved stock is released.

### 3. Inventory Adjustment Lane

Use this for:

- cycle count
- manual variance
- external POS sale when Shopify did not create the sale
- reservation release adjustments when a compensation delta is simpler than a transfer cancellation
- external reset delta after OMS computes the difference

Workflow:

1. Resolve location and inventory item.
2. Build delta quantity change.
3. Post `inventoryAdjustQuantities`.

## Logging And Missed Events

Phase 1 does not create retry entities or sync history entities.

If a `SECA` call fails or a trigger path is missed, log enough information to support replay:

- event type
- source service name
- orderId, shipmentId, receiptId, or physicalInventoryId
- productStoreId
- facilityId
- resolved shopId
- resolved Shopify location id
- payload summary
- Shopify error text

This is enough to start with immediate sync and operational visibility. Persistent replay tables or scheduled retry can be added later if the failure pattern justifies the extra model.
