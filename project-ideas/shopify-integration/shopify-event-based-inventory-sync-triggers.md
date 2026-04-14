# Shopify Event-Based Inventory Sync Triggers

## Purpose

This document summarizes the OMS events that should drive Shopify inventory updates and recommends the lowest-load trigger boundary for each event.

The target design is event-based. OMS remains the system of record. Shopify is updated so store inventory stays usable during the day without relying on repeated full resets.

## Executive Summary

The event model should be split into four lanes:

1. Store fulfillment events
2. Transfer shipment events
3. Inventory adjustment events
4. External reset events

Do not drive this from broad `InventoryItemDetail` or `Shipment` watches. Those entities are too generic and too noisy. Use the business event that actually changed inventory, queue a small outbox message, and let a dedicated Shopify feed service post the corresponding Shopify workflow.

For transfer orders, this means:

- create only the minimum Shopify `InventoryTransfer` records needed to support `InventoryShipment`
- do not use Shopify to manage OMS transfer order lifecycle
- use Shopify transfer and shipment APIs only to reproduce the inventory effect that OMS already decided

## Recommended Trigger Model

Use one shared queue service and multiple small sender services.

### Shared Queue

- `queue#ShopifyInventoryEvent`
- Inputs: `eventType`, `entityName`, `primaryKey`, `shopId`, `facilityId`, `eventDate`
- Responsibility:
  - create one outbox/system-message style event
  - deduplicate by a deterministic key
  - retry safely
  - hand off to the correct sender service

### Sender Services

- `send#ShopifyStoreFulfillmentEvent`
- `send#ShopifyTransferShipmentOutEvent`
- `send#ShopifyTransferReceiptInEvent`
- `send#ShopifyInventoryAdjustmentEvent`
- `send#ShopifyInventoryResetEvent`

This split is better than one large receiver because each lane has different source entities, grouping rules, and Shopify APIs.

## Trigger Matrix

| OMS event | Recommended trigger boundary | Why this is the right trigger | Shopify workflow | Feed service behavior |
| --- | --- | --- | --- | --- |
| Store-origin TO reservation reduces ATP | `co.hotwax.oms.impl.OrderReservationServices.process#OrderItemAllocation` after commit, only for transfer orders originating from stores | This is the exact point where OMS reserves sellable inventory for the TO | Create or update a Shopify `InventoryTransfer` and move it to `READY_TO_SHIP` so Shopify origin `available` decreases and `reserved` increases | Build one transfer payload per OMS TO and store route, resolve origin and destination Shopify locations, aggregate line quantities by `inventoryItemId`, create draft transfer if needed, then mark ready to ship |
| Store-origin TO shipment reduces QOH | `co.hotwax.poorti.TransferOrderFulfillmentServices.ship#TransferOrderShipment` post-service | This service creates `ItemIssuance`, writes `InventoryItemDetail.quantityOnHandDiff = -qty`, and marks the shipment `SHIPMENT_SHIPPED` | Ensure prerequisite `InventoryTransfer` exists, create Shopify `InventoryShipment`, then mark shipment in transit | Read the shipped OMS transfer shipment, map order items to Shopify inventory items, create the shipment against the transfer, push tracking if available, and mark in transit so Shopify origin `on_hand` drops and destination `incoming` rises |
| TO receipt into store increases ATP and QOH | `ShipmentReceipt` create or update, grouped by `shipmentId + datetimeReceived + facilityId` | Receipt quantity is stored on `ShipmentReceipt`, not on a single shipment status transition | `inventoryShipmentReceive` against the existing Shopify shipment | Group shipment-backed receipts from the same receiving session, sum by `shipmentItemId`, and post receipt quantities to Shopify; if OMS creates receipt rows without shipment linkage, keep them in exception handling because Shopify cannot receive against a transfer item without a shipment line |
| Online order shipped from store | `co.hotwax.poorti.FulfillmentServices.ship#Shipment` post-service | This is the point where OMS issues stock and marks the shipment shipped | First move the Shopify Fulfillment Order to the actual shipping store when needed, then create the Shopify fulfillment | Resolve Shopify order and fulfillment order, compare assigned location with actual OMS shipping facility, call Fulfillment Order move when the store differs, then create the fulfillment with tracking |
| External POS sale or non-Shopify-origin sale reduces ATP or QOH | A dedicated sales posting boundary, not Shopify fulfillment | There is no Shopify order or fulfillment order to absorb this inventory change | Use `inventoryAdjustQuantities` as an inventory-only correction path | For final sale, reduce `available` and `on_hand`; for reservation-only behavior, reduce `available` only; do not do this for Shopify POS orders because Shopify already owns those reservations and fulfillments |
| Cycle count or approved manual variance changes ATP and QOH | `co.hotwax.cycleCount.InventoryCountServices.create#PhysicalInventory` when `decisionOutcomeEnumId = APPLIED`, or an outbox event on created `PhysicalInventory` / `InventoryItemVariance` | This is the business-approved inventory correction point | `inventoryAdjustQuantities` | Post the applied variance to Shopify for the mapped location and inventory item; when OMS changed both ATP and QOH together, send both quantity-state adjustments; manual variance should use this same lane |
| External authoritative reset from ERP, WMS, or NetSuite | `reset#InventoryItem` result or `create#ExternalInventoryReset` completion | This is the authoritative reconciliation boundary | Absolute set workflow using Shopify inventory set mutations, not transfer or fulfillment APIs | Resolve the final authoritative quantities and set them in Shopify; use delta mutations only when the external source explicitly sends deltas, otherwise use set-style mutations so Shopify lands on the same truth as OMS |

## Why These Trigger Boundaries Are Lower Load

### Do Not Watch `Shipment`

`Shipment` changes for many reasons that do not all require Shopify inventory updates:

- creation
- package changes
- route segment changes
- tracking updates
- status changes

A broad `Shipment` feed would create unnecessary reads and false positives.

### Use `ShipmentReceipt` For Inbound TO Inventory

Inbound transfer receipt should not be driven only from `receive#TransferOrder` or from `ShipmentStatus`.

OMS receiving can:

- split one receiving action across multiple shipments
- receive at item level
- create over-receipt rows without shipment linkage
- stamp all rows from one receiving session with the same `datetimeReceived`

That means `ShipmentReceipt` is the durable source for inbound quantity, and `shipmentId + datetimeReceived + facilityId` is the correct grouping key for Shopify receipt posting.

### Use Post-Service Or Tx-Commit Boundaries For Outbound Events

For outbound TO shipment and sales shipment, the correct event happens only after OMS has already written the issuance and inventory ledger entries. That keeps Shopify sync aligned with committed OMS state and avoids duplicate or premature calls.

## Shopify Workflow By Lane

### 1. Store Fulfillment Events

Use this for online orders shipped from stores.

Workflow:

1. Find the Shopify order and open fulfillment orders.
2. Identify the actual shipping store from OMS.
3. If Shopify assigned a different location, move the fulfillment order to the actual store.
4. Create the Shopify fulfillment from that store.

This is the correct Shopify equivalent because store-shipped orders should be fulfilled against the actual retail location that issued the inventory.

### 2. Transfer Shipment Events

Use this for store to warehouse, warehouse to store, and store to store transfer movement.

Workflow:

1. On reservation, create the minimum Shopify `InventoryTransfer` representation and move it to `READY_TO_SHIP` when OMS has reserved ATP that Shopify must reflect.
2. On ship, create `InventoryShipment` from the transfer and mark it in transit.
3. On receive, call `inventoryShipmentReceive`.

This is the cleanest Shopify equivalent available today because Shopify does not allow `InventoryShipment` without `InventoryTransfer`.

### 3. Inventory Adjustment Events

Use this for cycle count and approved manual correction.

Workflow:

1. Read the approved variance from OMS.
2. Resolve the Shopify inventory item and location.
3. Post `inventoryAdjustQuantities`.

Use this when the business action is a correction, not a shipment or fulfillment.

### 4. External Reset Events

Use this when an external system is the source of truth and OMS has already accepted the reconciliation.

Workflow:

1. Read the final authoritative quantity after `reset#InventoryItem` or `create#ExternalInventoryReset`.
2. Resolve the Shopify inventory item and location.
3. Set Shopify to the final target quantity using set-style inventory mutations.

This lane should not reuse transfer or fulfillment APIs because the business event is reconciliation, not movement.

## Transfer-Specific Notes

Live Shopify transfer testing proved the following behavior:

- Shopify cannot create `InventoryShipment` without `InventoryTransfer`
- `READY_TO_SHIP` reduces origin `available` and increases origin `reserved`
- marking shipment in transit reduces origin `on_hand` and increases destination `incoming`
- receiving increases destination `available` and decreases destination `incoming`

That means the minimum Shopify flow needed to reproduce OMS transfer inventory is:

1. reserve using `InventoryTransfer` in ready state when OMS reservation must affect Shopify ATP
2. ship using `InventoryShipment`
3. receive using `inventoryShipmentReceive`

## Implementation Notes

- Prefer service ECAs or tx-commit hooks for outbound reservation and shipment events.
- Prefer `ShipmentReceipt`-driven feeds for inbound transfer receipt.
- Keep one idempotency key per business event, not per retry.
- If event-based posting fails, replay from the outbox. Do not fall back first to broad polling of `InventoryItemDetail`.
- Scheduled recovery can exist as a safety net, but it should read failed outbox events, not re-derive all business changes from scratch.

## Recommended Initial Cut

Implement these three triggers first:

1. `process#OrderItemAllocation` for store-origin transfer reservation
2. `ship#TransferOrderShipment` for outbound transfer shipment
3. `ShipmentReceipt` create or update for inbound transfer receipt

Then add:

4. `ship#Shipment` for store fulfillment of online orders
5. `create#PhysicalInventory` for cycle count and manual variance
6. `reset#InventoryItem` or `create#ExternalInventoryReset` for authoritative resets

This gives the shortest path to reducing daytime inventory drift on Shopify while keeping OMS as the only system that owns the business process.

## References

- `runtime/component/oms/service/co/hotwax/oms/impl/OrderReservationServices.xml`
- `runtime/component/oms/service/co/hotwax/orderledger/order/TransferOrderServices.xml`
- `runtime/component/poorti/service/co/hotwax/poorti/TransferOrderFulfillmentServices.xml`
- `runtime/component/poorti/service/co/hotwax/poorti/FulfillmentServices.xml`
- `runtime/component/poorti/service/co/hotwax/cycleCount/InventoryCountServices.xml`
- `project-ideas/fulfillment-center-mgmt/inventory-mgmt/reset_inventory_item_spec.md`
- `project-ideas/fulfillment-center-mgmt/inventory-mgmt/external_inventory_reset_design.md`
- Shopify Admin GraphQL: `inventoryTransferCreate`, `inventoryTransferMarkAsReadyToShip`, `inventoryShipmentCreate`, `inventoryShipmentMarkInTransit`, `inventoryShipmentReceive`, `inventoryAdjustQuantities`, `inventorySetQuantities`, `fulfillmentOrderMove`, `fulfillmentCreate`
