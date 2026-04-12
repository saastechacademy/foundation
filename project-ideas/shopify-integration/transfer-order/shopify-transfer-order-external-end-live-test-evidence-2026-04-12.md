# Shopify Transfer Order External-End Live Test Evidence

## Purpose

This document records the live Shopify tests run on April 12, 2026 for two one-sided transfer scenarios:

1. outbound from a Shopify location to an external destination managed outside Shopify
2. inbound to a Shopify location from an external origin managed outside Shopify

The goal was to prove whether Shopify `InventoryTransfer` and `InventoryShipment` support transfers where one side of the movement is omitted.

Raw API evidence is stored under:

- `runtime/component/shopify-oms-bridge/docs/evidence/shopify_transfer_external_end_tests_2026-04-12`

## Environment

- Shop: `gorjana-sandbox.myshopify.com`
- API version: `2026-01`
- SKU: `207-113-G`
- Inventory item: `gid://shopify/InventoryItem/46295996661804`
- Quantity tested: `1`
- Shopify location used as origin: `Atlanta`
- Shopify location used as destination: `Austin`

## Executive Result

Both scenarios ran successfully.

Shopify accepted:

- a ready-to-ship transfer with `originLocationId` set and `destinationLocationId` omitted
- a ready-to-ship transfer with `destinationLocationId` set and `originLocationId` omitted

In both cases Shopify also allowed an immediate `inventoryShipmentCreate` against the created transfer, and the shipment line item matched the transfer line item.

## Scenario 1: Outbound From Shopify Location To External Destination

Intent:

- ship inventory out of one Shopify location
- destination exists outside Shopify and is not represented as a Shopify location

Mutation shape:

- `originLocationId = Atlanta`
- `destinationLocationId` omitted
- `1` line item
- immediate `inventoryShipmentCreate` using the transfer id as `movementId`

Created records:

- Transfer: `#T0028`
- Reference: `TO-EXT-OUT-20260412-A`
- Transfer id: `gid://shopify/InventoryTransfer/3875110956`
- Shopify admin: `https://gorjana-sandbox.myshopify.com/admin/products/transfers/3875110956`
- Shipment: `#T0028-1`
- Shipment id: `gid://shopify/InventoryShipment/959316012`

What Shopify returned:

- transfer status: `READY_TO_SHIP`
- transfer `origin.name = Atlanta`
- transfer `destination = null`
- transfer line item:
  - inventory item `46295996661804`
  - SKU `207-113-G`
  - `totalQuantity = 1`
- transfer `shipments` contained:
  - shipment id `959316012`
  - shipment name `#T0028-1`
  - shipment status `DRAFT`
- shipment line item:
  - inventory item `46295996661804`
  - SKU `207-113-G`
  - `quantity = 1`
  - `unreceivedQuantity = 1`

Inventory snapshot:

| Stage | Atlanta available | Atlanta reserved | Atlanta on_hand | Austin available | Austin incoming | Austin on_hand |
| --- | --- | --- | --- | --- | --- | --- |
| Before scenario | `196` | `0` | `196` | `13` | `1` | `13` |
| After ready transfer and draft shipment | `195` | `1` | `196` | `13` | `1` | `13` |

Conclusion:

- Shopify supports an outbound transfer whose destination is external to Shopify
- at `READY_TO_SHIP`, Shopify reserved origin inventory even though no Shopify destination existed
- the immediate shipment create worked and remained linked through the transfer’s `shipments` collection

## Scenario 2: Inbound To Shopify Location From External Origin

Intent:

- receive stock into a Shopify location
- origin exists only in OMS or another external system and is not represented as a Shopify location

Mutation shape:

- `destinationLocationId = Austin`
- `originLocationId` omitted
- `1` line item
- immediate `inventoryShipmentCreate` using the transfer id as `movementId`

Created records:

- Transfer: `#T0029`
- Reference: `TO-EXT-IN-20260412-B`
- Transfer id: `gid://shopify/InventoryTransfer/3875143724`
- Shopify admin: `https://gorjana-sandbox.myshopify.com/admin/products/transfers/3875143724`
- Shipment: `#T0029-1`
- Shipment id: `gid://shopify/InventoryShipment/959348780`

What Shopify returned:

- transfer status: `READY_TO_SHIP`
- transfer `origin = null`
- transfer `destination.name = Austin`
- transfer line item:
  - inventory item `46295996661804`
  - SKU `207-113-G`
  - `totalQuantity = 1`
- transfer `shipments` contained:
  - shipment id `959348780`
  - shipment name `#T0029-1`
  - shipment status `DRAFT`
- shipment line item:
  - inventory item `46295996661804`
  - SKU `207-113-G`
  - `quantity = 1`
  - `unreceivedQuantity = 1`

Inventory snapshot:

| Stage | Atlanta available | Atlanta reserved | Atlanta on_hand | Austin available | Austin incoming | Austin on_hand |
| --- | --- | --- | --- | --- | --- | --- |
| Before scenario | `195` | `1` | `196` | `13` | `1` | `13` |
| After ready transfer and draft shipment | `195` | `1` | `196` | `13` | `1` | `13` |

Conclusion:

- Shopify supports an inbound transfer whose origin is external to Shopify
- Shopify allowed the transfer header and the shipment header even without a Shopify origin
- creating the ready transfer and draft shipment did not yet change Austin inventory in this test

## Important Technical Note

`InventoryShipment` still does not expose a direct parent-transfer field in the reviewed schema.

So the shipment-to-transfer linkage in these tests was proven by:

- creating the shipment with `movementId = inventoryTransfer.id`
- querying the transfer back and confirming the created shipment appeared under `inventoryTransfer.shipments`
- verifying the shipment line items matched the transfer line items exactly

## Final Conclusion

These two specific scenarios are supported by Shopify:

- Shopify location -> external destination
- external origin -> Shopify location

The tested result is not theoretical. Both flows created real Shopify transfers and real Shopify shipments with one omitted end of the movement.

What remains separate from this proof is later execution behavior such as:

- marking these shipments in transit
- receiving the inbound flow
- comparing inventory movement after in-transit and receipt

This run proves the create-and-link behavior only, which is the exact scope requested.
