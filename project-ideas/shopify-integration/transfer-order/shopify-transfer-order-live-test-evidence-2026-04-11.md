# Shopify Transfer Order Live Test Evidence

## Purpose

This document records the live Shopify transfer-order tests run against `gorjana-sandbox.myshopify.com` on April 11, 2026.

The goals were:

- prove the current Shopify transfer and shipment flow with live API evidence
- capture inventory impact at each major step and compare it to OMS flow semantics
- verify which previously documented gaps are true live gaps and which need correction

Raw API responses are stored under:

- `runtime/component/shopify-oms-bridge/docs/evidence/shopify_transfer_tests_2026-04-11`

## Environment

### Shopify shop

- Shop: `gorjana sandbox`
- Domain: `gorjana-sandbox.myshopify.com`
- API version: `2026-01`

### Live token scope result

Confirmed present on April 11, 2026:

- `read_inventory`
- `write_inventory`
- `read_locations`
- `read_inventory_transfers`
- `write_inventory_transfers`
- `read_inventory_shipments`
- `write_inventory_shipments`
- `read_inventory_shipments_received_items`
- `write_inventory_shipments_received_items`

## Test Data Used

### Locations

- Origin:
  - `gid://shopify/Location/71900561452`
  - `Atlanta`
- Destination:
  - `gid://shopify/Location/63145443372`
  - `Austin`

### Inventory item

- Inventory item:
  - `gid://shopify/InventoryItem/46295996661804`
  - SKU: `207-113-G`

### Shopify transfers created during this run

- `#T0007`
  - reference: `TO-LIVE-20260411-A`
  - purpose: full single-shipment happy path with partial and final receipt
- `#T0008`
  - reference: `TO-LIVE-20260411-B`
  - purpose: one transfer split into two shipments, then received shipment by shipment
- `#T0009`
  - reference: `TO-LIVE-20260411-C`
  - purpose: over-receipt probe

These transfers were intentionally left in Shopify at the user’s request.

## Live Results Summary

| Scenario | Live result | Classification |
| --- | --- | --- |
| Create draft transfer | succeeded | `Clean Equivalent` |
| Mark ready to ship | succeeded | `Clean Equivalent` |
| Create draft shipment | succeeded | `Clean Equivalent` |
| Set shipment tracking | succeeded | `Clean Equivalent` |
| Mark shipment in transit | succeeded | `Clean Equivalent` |
| Partial receive | succeeded | `Clean Equivalent` |
| Final receive | succeeded | `Clean Equivalent` |
| Two shipments under one transfer | succeeded | `Partial Equivalent` |
| Receive two shipments in one TO-item-style action | not available; receive is shipment-id based | `No Clean Equivalent` |
| Over-receipt against shipment line | succeeded live | `Partial Equivalent` |

## Inventory Impact Compared With OMS

### Single-shipment happy path: `#T0007`

Item:

- SKU `207-113-G`
- Quantity `2`
- Origin `Atlanta`
- Destination `Austin`

### Inventory snapshots

| Stage | Atlanta available | Atlanta reserved | Atlanta on_hand | Austin available | Austin incoming | Austin on_hand |
| --- | --- | --- | --- | --- | --- | --- |
| Before create | `203` | `0` | `203` | `11` | `0` | `11` |
| After draft create | `203` | `0` | `203` | `11` | `0` | `11` |
| After ready to ship | `201` | `2` | `203` | `11` | `0` | `11` |
| After shipment draft create | `201` | `2` | `203` | `11` | `0` | `11` |
| After mark in transit | `201` | `0` | `201` | `11` | `2` | `11` |
| After partial receive of `1` | `201` | `0` | `201` | `12` | `1` | `12` |
| After final receive of `1` | `201` | `0` | `201` | `13` | `0` | `13` |

### OMS comparison

| Shopify live behavior | OMS comparison |
| --- | --- |
| Draft transfer creation does not change inventory | Matches OMS TO creation behavior |
| `READY_TO_SHIP` reduces origin `available` and increases origin `reserved` | Matches OMS approval and reservation semantics more closely than previously assumed |
| Draft shipment creation causes no further inventory change | Consistent with OMS shipment-create being a staging step, not inventory issue |
| `IN_TRANSIT` releases origin `reserved`, reduces origin `on_hand`, and increases destination `incoming` | Matches OMS ship behavior more closely than a pure header-state transition |
| Partial receipt decreases destination `incoming` and increases destination `available`/`on_hand` only by the received quantity | Matches OMS partial receipt semantics at a quantity level |
| Final receipt consumes the remaining destination `incoming` and fully increases destination `available`/`on_hand` | Matches OMS completion behavior at inventory level |

### Key conclusion

Shopify’s live inventory behavior is closer to the OMS transfer lifecycle than the earlier pre-scope analysis suggested:

- reservation happens at ready-to-ship
- issue happens at in-transit
- receipt moves incoming to available incrementally

The main differences are not the core inventory movement itself. The main differences remain:

- receive is shipment-scoped instead of TO-item-scoped
- OMS has richer control for receive-only, receive-and-close, reject-to-parking, and close-fulfillment flows

## Transfer And Shipment State Evidence

### `#T0007` happy path

Observed state path:

- Transfer: `DRAFT` -> `READY_TO_SHIP` -> `TRANSFERRED`
- Shipment: `DRAFT` -> `IN_TRANSIT` -> `PARTIALLY_RECEIVED` -> `RECEIVED`

Key evidence files:

- `02_create_draft_transfer_A.json`
- `04_mark_ready_transfer_A.json`
- `06_create_shipment_draft_A.json`
- `10_mark_shipment_in_transit_A.json`
- `12_receive_partial_shipment_A.json`
- `15_receive_final_shipment_A.json`
- `18_transfer_detail_after_full_receive_A.json`

## Multi-Shipment Evidence

### `#T0008` one transfer with two shipments

Observed behavior:

- one transfer was created with quantity `2`
- two separate shipments were created, each with quantity `1`
- the transfer moved to `IN_PROGRESS` while one shipment was received and the other remained `IN_TRANSIT`
- the transfer moved to `TRANSFERRED` only after both shipments were separately received

Key evidence:

- `22_transfer_detail_with_two_shipments_B.json`
- `26_transfer_detail_after_receiving_shipment1_B.json`
- `29_transfer_detail_after_receiving_shipment2_B.json`

### OMS comparison

OMS receiving is TO-item-centric:

- the receiver can work against the TO item
- OMS can internally split one received quantity across multiple eligible shipments

Shopify receiving is shipment-centric:

- each receive mutation is tied to one `inventoryShipment`
- each shipment must be received in its own receive call

This is a real live gap in workflow shape even though the net inventory movement can still be made correct.

## Over-Receipt Evidence

### `#T0009` over-receipt probe

Transfer setup:

- transfer quantity: `1`
- shipment quantity: `1`
- receive request quantity: `2`

Live result:

- Shopify accepted the receive call
- shipment line `acceptedQuantity` became `2` even though shipment line `quantity` was `1`
- transfer `receivedQuantity` became `2` even though transfer `totalQuantity` was `1`
- destination inventory increased by `2`

Key evidence:

- `35_attempt_over_receive_C.json`
- `37_shipment_detail_after_over_receive_C.json`
- `38_transfer_detail_after_over_receive_C.json`

### OMS comparison

This materially changes the earlier assumption:

- Shopify does allow over-receipt live
- but the over-receipt is still represented through shipment receipt records, not as OMS-style TO-item-only receipt without shipment linkage

So the corrected conclusion is:

- over-receipt is not absent in Shopify
- over-receipt is present, but it is shipment-scoped rather than TO-item-scoped

## Remaining Gaps Still Standing

These were not disproven by the live test and should still be treated as real gaps unless later evidence shows otherwise:

1. `TO_Receive_Only`
   - Shopify still has no first-class receive-only transfer orchestration equivalent
2. Receipt without shipment linkage
   - live Shopify receive calls still require `inventoryShipment` and shipment line ids
3. Unexpected-item receipt
   - live Shopify receive flow still operates on shipment line ids, not arbitrary newly arrived products
4. Receiver-driven close of partial receipt
   - not shown in the live run
5. Reject to `REJECTED_ITM_PARKING`
   - not represented in Shopify transfer cancel flow
6. OMS close-fulfillment semantics
   - Shopify still has remove-item and shipment-flow tools, not the same item-close semantics

## Operational Notes

### Read-after-write timing

The prior day’s run had shown one short read-after-write inconsistency on a newly created draft transfer.

This day’s run did not reproduce that issue in the main happy path, but the integration should still be designed with short retry tolerance because Shopify remains an external system.

### Date fields

Some returned `dateCreated` and `dateReceived` values reflected Shopify’s own server-side handling and were not always identical to the requested timestamps. That should be treated as normal API behavior, not as a local OMS issue.
