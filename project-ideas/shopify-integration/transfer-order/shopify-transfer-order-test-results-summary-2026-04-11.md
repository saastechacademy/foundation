# Shopify Transfer Order Test Results Summary

## Purpose

This document consolidates the Shopify transfer-order test results run on `gorjana-sandbox.myshopify.com` through April 11, 2026.

It is the single entry point for:

- small live transfer and shipment tests
- large bulk route tests
- Shopify admin links for the created transfers
- inventory snapshots observed at each major step
- the main gaps between OMS Transfer Order behavior and Shopify transfer behavior

Supporting detail remains in the companion documents in this folder.

## Executive Summary

The test set proved that Shopify can execute transfer creation, ready-to-ship reservation, shipment creation, in-transit movement, and receipt with live gorjana sandbox inventory.

The same test set also proved that Shopify is not a one-to-one replacement for OMS Transfer Order orchestration:

- one logical OMS TO can fan out into many Shopify transfers because of the `250`-line mutation limit
- one logical OMS shipment or receive operation can fan out into many Shopify shipments and many receive calls
- Shopify receipt is shipment-line based, while OMS receipt is TO-item based
- Shopify execution has item and location preconditions that OMS TO authoring does not expose in the same way

## Test Set Covered

| Scenario group | Scenario | Route type | Variants | Units | Shopify transfers | Outcome |
| --- | --- | --- | --- | --- | --- | --- |
| Small live | `TO-LIVE-20260411-A` | Store to store | `1` | `2` | `1` | Full happy path succeeded |
| Small live | `TO-LIVE-20260411-B` | Store to store | `1` | `2` | `1` | One transfer with two shipments succeeded |
| Small live | `TO-LIVE-20260411-C` | Store to store | `1` | `1 requested / 2 received` | `1` | Over-receipt succeeded |
| Gap proof | `TO-LIVE-20260411-D` | Store to store | `1` | `2` | `1` | Partial receipt succeeded; transfer-level receive and post-shipment close failed cleanly |
| Gap proof | `TO-LIVE-20260411-E` | Store to store | `1` | `1` | `1` | Draft cancel succeeded; reject semantics still absent |
| Bulk create-only probe | `TO-BULK-20260411-LGW-AUS-B01/B02` | Warehouse to store | `500` logical attempt split across `2` transfers | create-only probe | `2` | Transfer create succeeded, shipment execution exposed destination and tracking constraints |
| Bulk execution | `LGW-AUS-EXEC2` | Warehouse to store | `285` | `1,425` | `2` | End-to-end execution succeeded |
| Bulk execution | `AUS-CAR-EXEC2` | Store to store | `1,500` | `7,500` | `6` | End-to-end execution succeeded |
| Bulk execution | `CAR-LGW-EXEC2` | Store to warehouse | `1,500` | `7,500` | `6` | End-to-end execution succeeded |

Overall executed scale:

- logical bulk routes: `3`
- executed variants: `3,285`
- executed units: `16,425`
- executed Shopify transfer batches: `14`

## Shopify Admin Links

All links use the Shopify admin transfer URL pattern:

`https://gorjana-sandbox.myshopify.com/admin/products/transfers/<numeric_id>`

### Small live tests

| Scenario | Reference | Transfer number | Admin link |
| --- | --- | --- | --- |
| Happy path | `TO-LIVE-20260411-A` | `#T0007` | `https://gorjana-sandbox.myshopify.com/admin/products/transfers/3874193452` |
| Two shipments under one transfer | `TO-LIVE-20260411-B` | `#T0008` | `https://gorjana-sandbox.myshopify.com/admin/products/transfers/3874226220` |
| Over-receipt probe | `TO-LIVE-20260411-C` | `#T0009` | `https://gorjana-sandbox.myshopify.com/admin/products/transfers/3874258988` |
| Gap proof: partial receive and failed close | `TO-LIVE-20260411-D` | `#T0026` | `https://gorjana-sandbox.myshopify.com/admin/products/transfers/3875012652` |
| Gap proof: cancel versus reject | `TO-LIVE-20260411-E` | `#T0027` | `https://gorjana-sandbox.myshopify.com/admin/products/transfers/3875045420` |

### Bulk create-only probe

| Scenario | Reference | Admin link |
| --- | --- | --- |
| Laguna to Austin create-only probe batch 1 | `TO-BULK-20260411-LGW-AUS-B01` | `https://gorjana-sandbox.myshopify.com/admin/products/transfers/3874488364` |
| Laguna to Austin create-only probe batch 2 | `TO-BULK-20260411-LGW-AUS-B02` | `https://gorjana-sandbox.myshopify.com/admin/products/transfers/3874521132` |

### Bulk execution routes

| Route | Reference | Admin link |
| --- | --- | --- |
| `LGW-AUS-EXEC2` | `TO-BULK-20260411-LGW-AUS-EXEC2-B01` | `https://gorjana-sandbox.myshopify.com/admin/products/transfers/3874553900` |
| `LGW-AUS-EXEC2` | `TO-BULK-20260411-LGW-AUS-EXEC2-B02` | `https://gorjana-sandbox.myshopify.com/admin/products/transfers/3874586668` |
| `AUS-CAR-EXEC2` | `TO-BULK-20260411-AUS-CAR-EXEC2-B01` | `https://gorjana-sandbox.myshopify.com/admin/products/transfers/3874619436` |
| `AUS-CAR-EXEC2` | `TO-BULK-20260411-AUS-CAR-EXEC2-B02` | `https://gorjana-sandbox.myshopify.com/admin/products/transfers/3874652204` |
| `AUS-CAR-EXEC2` | `TO-BULK-20260411-AUS-CAR-EXEC2-B03` | `https://gorjana-sandbox.myshopify.com/admin/products/transfers/3874684972` |
| `AUS-CAR-EXEC2` | `TO-BULK-20260411-AUS-CAR-EXEC2-B04` | `https://gorjana-sandbox.myshopify.com/admin/products/transfers/3874717740` |
| `AUS-CAR-EXEC2` | `TO-BULK-20260411-AUS-CAR-EXEC2-B05` | `https://gorjana-sandbox.myshopify.com/admin/products/transfers/3874750508` |
| `AUS-CAR-EXEC2` | `TO-BULK-20260411-AUS-CAR-EXEC2-B06` | `https://gorjana-sandbox.myshopify.com/admin/products/transfers/3874783276` |
| `CAR-LGW-EXEC2` | `TO-BULK-20260411-CAR-LGW-EXEC2-B01` | `https://gorjana-sandbox.myshopify.com/admin/products/transfers/3874816044` |
| `CAR-LGW-EXEC2` | `TO-BULK-20260411-CAR-LGW-EXEC2-B02` | `https://gorjana-sandbox.myshopify.com/admin/products/transfers/3874848812` |
| `CAR-LGW-EXEC2` | `TO-BULK-20260411-CAR-LGW-EXEC2-B03` | `https://gorjana-sandbox.myshopify.com/admin/products/transfers/3874881580` |
| `CAR-LGW-EXEC2` | `TO-BULK-20260411-CAR-LGW-EXEC2-B04` | `https://gorjana-sandbox.myshopify.com/admin/products/transfers/3874914348` |
| `CAR-LGW-EXEC2` | `TO-BULK-20260411-CAR-LGW-EXEC2-B05` | `https://gorjana-sandbox.myshopify.com/admin/products/transfers/3874947116` |
| `CAR-LGW-EXEC2` | `TO-BULK-20260411-CAR-LGW-EXEC2-B06` | `https://gorjana-sandbox.myshopify.com/admin/products/transfers/3874979884` |

## Inventory Snapshot Summary

### Small live happy path: `TO-LIVE-20260411-A`

Item:

- SKU `207-113-G`
- quantity `2`
- origin `Atlanta`
- destination `Austin`

| Stage | Atlanta available | Atlanta reserved | Atlanta on_hand | Austin available | Austin incoming | Austin on_hand |
| --- | --- | --- | --- | --- | --- | --- |
| Before create | `203` | `0` | `203` | `11` | `0` | `11` |
| After draft create | `203` | `0` | `203` | `11` | `0` | `11` |
| After ready to ship | `201` | `2` | `203` | `11` | `0` | `11` |
| After shipment draft create | `201` | `2` | `203` | `11` | `0` | `11` |
| After mark in transit | `201` | `0` | `201` | `11` | `2` | `11` |
| After partial receive of `1` | `201` | `0` | `201` | `12` | `1` | `12` |
| After final receive of `1` | `201` | `0` | `201` | `13` | `0` | `13` |

### Small live two-shipment path: `TO-LIVE-20260411-B`

Observed state result:

- one transfer with quantity `2`
- two shipments created with quantity `1` each
- transfer moved to `IN_PROGRESS` after the first shipment receipt
- transfer moved to `TRANSFERRED` only after the second shipment receipt

Inventory conclusion:

- Shopify kept the inventory movement correct
- the operational gap is the workflow shape because receipt must be called per shipment, not once per TO item

### Small live over-receipt path: `TO-LIVE-20260411-C`

Observed state result:

- transfer quantity: `1`
- shipment quantity: `1`
- received quantity accepted by Shopify: `2`
- transfer `receivedQuantity` became `2`

Inventory conclusion:

- destination inventory increased by `2`
- Shopify does allow over-receipt live
- the gap is not absence of over-receipt
- the gap is that over-receipt is still shipment-scoped rather than TO-item-scoped

### Gap proof path: `TO-LIVE-20260411-D`

Observed state result:

- transfer `#T0026` was created ready to ship with quantity `2`
- shipment `#T0026-1` was created and moved to `IN_TRANSIT`
- partial receipt of `1` succeeded
- shipment became `PARTIALLY_RECEIVED`
- transfer became `IN_PROGRESS`
- transfer line showed `shippedQuantity = 2` and `shippableQuantity = 0`
- `inventoryTransferRemoveItems` then failed with:
  - `Transfer can only have its items removed in a Draft or Ready-to-ship status.`
- `inventoryShipmentReceive` called with the transfer id failed with:
  - `Invalid id: gid://shopify/InventoryTransfer/3875012652`
- trying to add `inventoryItemId` to the shipment receive input failed schema validation because that field is not defined

Inventory conclusion:

- after the partial receipt, Austin held `available = 13` and `incoming = 1` for SKU `207-113-G`
- Atlanta held `available = 196` and `reserved = 0`
- Shopify preserved the open incoming remainder, but did not allow a receiver-side close of that remainder

### Gap proof path: `TO-LIVE-20260411-E`

Observed state result:

- draft transfer `#T0027` was created successfully
- `inventoryTransferCancel` moved it to `CANCELED`
- `InventoryTransfer` schema introspection showed no reject-specific fields such as reject reason or reject destination

Inventory conclusion:

- Shopify cancel is valid as a cancel
- it is not a full reject equivalent to OMS reject-to-parking behavior

### Bulk route: `LGW-AUS-EXEC2`

| Stage | Origin available | Origin reserved | Origin on_hand | Destination available | Destination incoming | Destination on_hand |
| --- | --- | --- | --- | --- | --- | --- |
| Before | `518,506` | `1,425` | `519,972` | `1,553` | `0` | `1,553` |
| After ready | `517,081` | `2,850` | `519,972` | `1,553` | `0` | `1,553` |
| After in transit | `517,081` | `1,425` | `518,547` | `1,553` | `1,425` | `1,553` |
| After receive | `517,081` | `1,425` | `518,547` | `2,978` | `0` | `2,978` |

Route conclusion:

- reservation happened at ready-to-ship
- issue happened at in-transit
- receipt moved destination `incoming -> available`
- one logical warehouse-to-store route became `2` Shopify transfers and `2` Shopify shipments

### Bulk route: `AUS-CAR-EXEC2`

| Stage | Origin available | Origin reserved | Origin on_hand | Destination available | Destination incoming | Destination on_hand |
| --- | --- | --- | --- | --- | --- | --- |
| Before | `240,750` | `0` | `240,827` | `238,246` | `0` | `238,246` |
| After ready | `233,250` | `7,500` | `240,827` | `238,246` | `0` | `238,246` |
| After in transit | `233,250` | `0` | `233,327` | `238,246` | `7,500` | `238,246` |
| After receive recovery snapshot | `233,250` | `0` | `233,327` | `238,901` | `0` | `238,901` |

Route note:

- all six transfers reached `TRANSFERRED`
- all six batch `receivedQuantity` values matched the transferred quantities
- the immediate isolated final snapshot failed during long pagination and the final values shown above are from the later recovery summary already present in the evidence set

### Bulk route: `CAR-LGW-EXEC2`

| Stage | Origin available | Origin reserved | Origin on_hand | Destination available | Destination incoming | Destination on_hand |
| --- | --- | --- | --- | --- | --- | --- |
| Before | `246,849` | `0` | `246,849` | `63,714` | `0` | `64,224` |
| After ready | `239,349` | `7,500` | `246,849` | `63,714` | `0` | `64,224` |
| After in transit | `239,349` | `0` | `239,349` | `63,714` | `7,500` | `64,224` |
| After receive | `239,349` | `0` | `239,349` | `71,214` | `0` | `71,724` |

Route conclusion:

- this was the cleanest large store-to-warehouse proof
- Shopify again mirrored the reservation, in-transit, and receipt inventory movement
- one logical route still became `6` Shopify transfers and `6` Shopify shipments

## What Shopify Matched Well

| OMS intent | Shopify live result |
| --- | --- |
| TO header creation without immediate inventory movement | matched |
| approval-like reservation timing | matched at `READY_TO_SHIP` |
| shipment staging before inventory issue | matched |
| issue inventory on ship | matched at `IN_TRANSIT` |
| receipt moves destination `incoming -> available` | matched |
| partial receipt by quantity | matched |
| multiple shipments under one transfer | supported |

## What Broke Or Needed Extra Shopify Preconditions

| Area | Observed result | Impact |
| --- | --- | --- |
| Large TO line count | `250` lines per mutation forced batch fan-out | one OMS TO becomes many Shopify transfers |
| Shipment and receipt execution | one shipment and one receive call per Shopify transfer/shipment set | one OMS operation becomes many Shopify operations |
| Inventory tracking | non-tracked items failed transfer creation | Shopify-side prevalidation is required |
| Destination inventory state | shipment create failed with `INVENTORY_STATE_NOT_ACTIVE` if the item was not stocked at destination | executable routes are a stricter subset of authorable OMS routes |
| Receipt model | receive is shipment-line based | OMS TO-item receiving does not map cleanly |
| Over-receipt | supported, but through shipment receive only | OMS and Shopify can reach the same inventory effect through different control shapes |
| Receive-only and close semantics | transfer-level receive and post-shipment close are not available | OMS exception handling remains stronger |
| Reject semantics | cancel exists but reject routing fields are absent | OMS reject-to-parking does not map cleanly |
| Evidence and reconciliation at scale | long inventory snapshots can time out or reset | retry logic is needed even when mutations succeed |

## OMS Versus Shopify Operational Conclusion

These tests prove that Shopify can mirror transfer execution when the line set is prevalidated to Shopify’s own rules and when the route is broken into Shopify-sized batches.

These tests also prove that OMS should remain the system of record for Transfer Order orchestration because OMS is stronger in the areas that matter operationally:

- one logical TO stays one logical TO
- receiving is TO-item oriented instead of shipment-call oriented
- receive-only and receiver-driven exception flows remain cleaner in OMS
- Shopify-specific execution preconditions can be enforced by OMS before any external mutation is attempted

## Companion Documents

- `shopify-transfer-order-inventory-transfer-mapping.md`
- `shopify-transfer-order-vs-oms-gap-analysis.md`
- `shopify-transfer-order-scenarios.md`
- `shopify-transfer-order-live-test-evidence-2026-04-11.md`
- `shopify-transfer-order-gap-proof-evidence-2026-04-11.md`
- `shopify-transfer-order-bulk-live-test-evidence-2026-04-11.md`
