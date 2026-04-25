# Shopify Transfer Order Bulk Test Results using GraphQL APIs

## Purpose

This document records the large-scale Shopify transfer-order tests run on `gorjana-sandbox.myshopify.com` on April 11, 2026.

The goals of this run were:

- prove large TO creation behavior on Shopify with real gorjana inventory
- prove shipment and receipt behavior beyond a few sample products
- identify Shopify constraints that appear only when moving from small TO tests to large route tests
- compare the observed inventory movement with the OMS transfer-order process

Raw evidence is stored under:

- `runtime/component/shopify-oms-bridge/docs/evidence/shopify_transfer_bulk_tests_2026-04-11`
- `runtime/component/shopify-oms-bridge/docs/evidence/shopify_transfer_bulk_tests_2026-04-11_exec2`
- `runtime/component/shopify-oms-bridge/docs/evidence/shopify_transfer_bulk_tests_2026-04-11_exec_cache`

## Executive Summary

- Three large route tests were executed against live gorjana sandbox inventory.
- The final execution set covered `3,285` variants, `14` Shopify transfer batches, and `16,425` units at quantity `5` per item.
- The route types tested were:
  - Laguna warehouse to store
  - store to store
  - store to warehouse
- Shopify did handle bulk transfer creation, shipment creation, in-transit movement, and receipt at this scale.
- Shopify also exposed two important large-scale constraints that must be accounted for before sync:
  - inventory items that appear in location inventory data can still fail transfer creation because they do not track inventory
  - shipment creation fails if the item is not already stocked and active at the destination location

## Route Set Executed

### Route 1: Laguna warehouse to Austin

- Route code: `LGW-AUS-EXEC2`
- Logical route type: warehouse to store
- Selected variants: `285`
- Quantity per item: `5`
- Total units: `1,425`
- Shopify transfer batches: `2`

Batch references:

- `TO-BULK-20260411-LGW-AUS-EXEC2-B01`
- `TO-BULK-20260411-LGW-AUS-EXEC2-B02`

### Route 2: Austin to Carlsbad

- Route code: `AUS-CAR-EXEC2`
- Logical route type: store to store
- Selected variants: `1,500`
- Quantity per item: `5`
- Total units: `7,500`
- Shopify transfer batches: `6`

Batch references:

- `TO-BULK-20260411-AUS-CAR-EXEC2-B01`
- `TO-BULK-20260411-AUS-CAR-EXEC2-B02`
- `TO-BULK-20260411-AUS-CAR-EXEC2-B03`
- `TO-BULK-20260411-AUS-CAR-EXEC2-B04`
- `TO-BULK-20260411-AUS-CAR-EXEC2-B05`
- `TO-BULK-20260411-AUS-CAR-EXEC2-B06`

### Route 3: Carlsbad to Laguna warehouse

- Route code: `CAR-LGW-EXEC2`
- Logical route type: store to warehouse
- Selected variants: `1,500`
- Quantity per item: `5`
- Total units: `7,500`
- Shopify transfer batches: `6`

Batch references:

- `TO-BULK-20260411-CAR-LGW-EXEC2-B01`
- `TO-BULK-20260411-CAR-LGW-EXEC2-B02`
- `TO-BULK-20260411-CAR-LGW-EXEC2-B03`
- `TO-BULK-20260411-CAR-LGW-EXEC2-B04`
- `TO-BULK-20260411-CAR-LGW-EXEC2-B05`
- `TO-BULK-20260411-CAR-LGW-EXEC2-B06`

## Overall Totals

- Logical routes executed: `3`
- Shopify transfer batches created: `14`
- Variants executed through transfer and shipment flow: `3,285`
- Units executed through transfer and shipment flow: `16,425`

This is the practical Shopify fan-out effect:

- one logical large route becomes multiple Shopify transfers
- each Shopify transfer then gets its own shipment
- each shipment then gets its own receive call

That fan-out is the core orchestration difference from OMS.

## Inventory Movement Compared With OMS

### Route 1: `LGW-AUS-EXEC2`

Inventory totals across the selected `285` variants:

| Stage | Origin available | Origin reserved | Origin on_hand | Destination available | Destination incoming | Destination on_hand |
| --- | --- | --- | --- | --- | --- | --- |
| Before | `518,506` | `1,425` | `519,972` | `1,553` | `0` | `1,553` |
| After ready | `517,081` | `2,850` | `519,972` | `1,553` | `0` | `1,553` |
| After in transit | `517,081` | `1,425` | `518,547` | `1,553` | `1,425` | `1,553` |
| After receive | `517,081` | `1,425` | `518,547` | `2,978` | `0` | `2,978` |

Observed behavior:

- Shopify reserved the route quantity at `READY_TO_SHIP`.
- Shopify moved the route quantity to destination `incoming` at shipment in-transit.
- Shopify moved the same quantity from destination `incoming` to destination `available` at receipt.
- This matches OMS inventory movement directionally.
- Shopify still leaves the receiver interaction shipment-driven, not TO-item-driven.

### Route 2: `AUS-CAR-EXEC2`

Inventory totals across the selected `1,500` variants before and through in-transit:

| Stage | Origin available | Origin reserved | Origin on_hand | Destination available | Destination incoming | Destination on_hand |
| --- | --- | --- | --- | --- | --- | --- |
| Before | `240,750` | `0` | `240,827` | `238,246` | `0` | `238,246` |
| After ready | `233,250` | `7,500` | `240,827` | `238,246` | `0` | `238,246` |
| After in transit | `233,250` | `0` | `233,327` | `238,246` | `7,500` | `238,246` |

Observed behavior:

- all six Shopify transfer batches reached `TRANSFERRED`
- all six shipment receipts succeeded
- the immediate final inventory snapshot failed with a network `Connection reset by peer` during long location paging
- a later recovery snapshot was no longer isolated because the Carlsbad-to-Laguna route had already started using the same destination location

Because of that, the cleanest proof for this route is:

- all six transfer batches are `TRANSFERRED`
- all six `receivedQuantity` values equal `totalQuantity`
- the in-transit aggregate showed the full `7,500` units in destination `incoming`

### Route 3: `CAR-LGW-EXEC2`

Inventory totals across the selected `1,500` variants:

| Stage | Origin available | Origin reserved | Origin on_hand | Destination available | Destination incoming | Destination on_hand |
| --- | --- | --- | --- | --- | --- | --- |
| Before | `246,849` | `0` | `246,849` | `63,714` | `0` | `64,224` |
| After ready | `239,349` | `7,500` | `246,849` | `63,714` | `0` | `64,224` |
| After in transit | `239,349` | `0` | `239,349` | `63,714` | `7,500` | `64,224` |
| After receive | `239,349` | `0` | `239,349` | `71,214` | `0` | `71,724` |

Observed behavior:

- Shopify again followed the same reservation -> in-transit -> receipt inventory pattern seen in smaller tests
- the batch fan-out was `6` Shopify transfers for one logical route
- this route is the strongest large-scale proof that Shopify can mirror the execution layer once items are already valid for both origin and destination

## Shopify Breaking Points Found During Bulk Testing

### 1. Transfer creation can fail on non-tracked inventory items

This was observed during the first large Laguna-to-Austin attempt.

Evidence:

- file: `runtime/component/shopify-oms-bridge/docs/evidence/shopify_transfer_bulk_tests_2026-04-11/LGW-AUS/01_create_ready_transfer.json`
- Shopify error: `The inventory item does not track inventory.`

Impact:

- location inventory discovery alone is not enough to build a Shopify transfer payload safely
- the line set must be filtered to `tracked=true` before transfer creation
- OMS TO items can include products that need additional Shopify-side validation before mirror creation

### 2. Shipment creation fails if the item is not stocked at the destination location

This was observed after the first large Laguna-to-Austin create-only run.

Evidence:

- files:
  - `runtime/component/shopify-oms-bridge/docs/evidence/shopify_transfer_bulk_tests_2026-04-11/LGW-AUS/01_create_ready_transfer.json`
  - `runtime/component/shopify-oms-bridge/docs/evidence/shopify_transfer_bulk_tests_2026-04-11/LGW-AUS/02_create_ready_transfer.json`
  - `runtime/component/shopify-oms-bridge/docs/evidence/shopify_transfer_bulk_tests_2026-04-11/LGW-AUS/01_create_shipment_in_transit.json`
- Shopify error code: `INVENTORY_STATE_NOT_ACTIVE`
- Shopify error message: `The item is not stocked at the destination location.`

Impact:

- Shopify allowed the ready-to-ship transfer creation
- Shopify then blocked shipment creation
- this means “transfer can be created” is not enough proof that the route is executable
- large-route planning must use the intersection of:
  - tracked items
  - origin items with enough available quantity
  - destination items that are already stocked and active

### 3. Large-route evidence capture itself is network-sensitive

Observed behavior:

- long location-inventory snapshot calls can hit `Connection reset by peer`
- long snapshot calls can also hit socket read timeouts
- this happened on evidence capture, not on the main transfer or receive mutations

Impact:

- Shopify mutation success and Shopify reporting reliability are not the same thing
- large-scale reconciliation and evidence collection should include retry logic
- this is another reason OMS should remain the authoritative operational ledger

## What The Bulk Test Proves About Shopify

### What Shopify can do

- create large transfer batches as `READY_TO_SHIP`
- reserve inventory at ready-to-ship at bulk scale
- create in-transit shipments at bulk scale
- move inventory from origin reserved/on-hand to destination incoming at bulk scale
- receive shipment quantities and complete transfer batches at bulk scale

### What Shopify still does not solve cleanly

- one logical TO still becomes many Shopify transfers
- one logical execution test still becomes many shipment records and many receive calls
- destination inventory-state preconditions are a Shopify execution constraint that OMS does not expose the same way at TO authoring time
- receiver work remains shipment-driven, not TO-item-driven
- Shopify data-quality constraints such as `tracked=true` still have to be enforced outside the transfer mutation itself

## OMS Comparison

What matched OMS:

- approval-like reservation timing at ready-to-ship
- issue-like inventory movement at shipment in-transit
- receipt moving destination `incoming -> available`

What remained weaker than OMS:

- batch fan-out across many transfer records
- shipment-centric execution and receipt
- destination-stocked execution precondition
- external-system retries needed even for evidence capture

Operational conclusion:

- Shopify can mirror large transfer execution when the route is prevalidated to Shopify’s rules
- OMS is still the better place to own TO orchestration, route validation, and exception handling

## Evidence Pointers

### Create-only failure evidence

- `runtime/component/shopify-oms-bridge/docs/evidence/shopify_transfer_bulk_tests_2026-04-11/LGW-AUS`

### Final execution evidence

- `runtime/component/shopify-oms-bridge/docs/evidence/shopify_transfer_bulk_tests_2026-04-11_exec2/LGW-AUS-EXEC2`
- `runtime/component/shopify-oms-bridge/docs/evidence/shopify_transfer_bulk_tests_2026-04-11_exec2/AUS-CAR-EXEC2`
- `runtime/component/shopify-oms-bridge/docs/evidence/shopify_transfer_bulk_tests_2026-04-11_exec2/CAR-LGW-EXEC2`

### Cached live location inventory used for route selection

- `runtime/component/shopify-oms-bridge/docs/evidence/shopify_transfer_bulk_tests_2026-04-11_exec_cache/LGW.json`
- `runtime/component/shopify-oms-bridge/docs/evidence/shopify_transfer_bulk_tests_2026-04-11_exec_cache/AUS.json`
- `runtime/component/shopify-oms-bridge/docs/evidence/shopify_transfer_bulk_tests_2026-04-11_exec_cache/CAR.json`
