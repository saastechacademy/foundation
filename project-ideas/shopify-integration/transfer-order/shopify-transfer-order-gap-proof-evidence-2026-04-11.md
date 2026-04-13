# Shopify Transfer Order Gap Proof

## Purpose

This document records the follow-up Shopify tests run on April 11, 2026 to prove the remaining OMS Transfer Order gap claims that were still pending after the happy-path and bulk execution runs.

The focus here is not basic transfer execution. The focus is proving the cases where OMS behavior cannot be represented cleanly on Shopify.

Raw API evidence is stored under:

- `runtime/component/shopify-oms-bridge/docs/evidence/shopify_transfer_gap_tests_2026-04-11`

## Test Data Used

### Shopify shop

- Shop: `gorjana sandbox`
- Domain: `gorjana-sandbox.myshopify.com`
- API version: `2026-01`

### Locations and SKU

- Origin:
  - `gid://shopify/Location/71900561452`
  - `Atlanta`
- Destination:
  - `gid://shopify/Location/63145443372`
  - `Austin`
- Inventory item:
  - `gid://shopify/InventoryItem/46295996661804`
  - SKU `207-113-G`

### Transfers created for this proof run

- `#T0026`
  - reference: `TO-LIVE-20260411-D`
  - purpose: partial receipt plus post-shipment close and receive-shape proof
  - Shopify admin: `https://gorjana-sandbox.myshopify.com/admin/products/transfers/3875012652`
- `#T0027`
  - reference: `TO-LIVE-20260411-E`
  - purpose: cancel versus reject proof
  - Shopify admin: `https://gorjana-sandbox.myshopify.com/admin/products/transfers/3875045420`

These transfers were left in Shopify.

## Executive Summary

This run proved the remaining important gaps directly with live API behavior:

- Shopify has `inventoryShipmentReceive`, but no transfer-level receive mutation.
- Shopify receive input accepts only `shipmentLineItemId`, `quantity`, and `reason`.
- Passing a transfer id to `inventoryShipmentReceive` fails with `RESOURCE_NOT_FOUND`.
- Attempting to include `inventoryItemId` in shipment receive input fails validation because that field does not exist on the input type.
- After a partial receipt, `inventoryTransferRemoveItems` cannot be used to close the remaining quantity because the transfer is already `IN_PROGRESS`.
- Shopify cancel exists and works, but the `InventoryTransfer` type still has no reject-reason or reject-location fields, so this is not equivalent to OMS reject-to-parking behavior.

## Scenario Proofs

## `TO_Receive_Only` and receipt without shipment linkage

OMS can create a receive-only TO and then receive against TO items.

Shopify proof:

- mutation root introspection showed `inventoryShipmentReceive`
- mutation root introspection did not show any `inventoryTransferReceive` mutation
- `InventoryShipmentReceiveItemInput` has only:
  - `shipmentLineItemId`
  - `quantity`
  - `reason`
- attempting to call `inventoryShipmentReceive` with a transfer id returned:
  - `Invalid id: gid://shopify/InventoryTransfer/3875012652`
  - error code `RESOURCE_NOT_FOUND`

Operational meaning:

- receive is shipment-driven in Shopify
- there is no transfer-level receive action to mirror OMS TO-item receiving
- this is the concrete reason `TO_Receive_Only` cannot be mirrored cleanly when OMS does not have a Shopify shipment context

Key evidence:

- `39_mutation_root_introspection.json`
- `40_receive_input_type_introspection.json`
- `48_attempt_receive_with_transfer_id_D.json`

## Unexpected-item receipt

OMS can receive an unexpected item without an `orderItemSeqId`.

Shopify proof:

- attempted to send `inventoryItemId` inside `InventoryShipmentReceiveItemInput`
- Shopify rejected the request before execution
- exact validation message:
  - `Field is not defined on InventoryShipmentReceiveItemInput`

Operational meaning:

- Shopify shipment receive cannot accept a new item not already represented as a shipment line
- this is not just a missing UI affordance
- the GraphQL input model itself does not allow that OMS behavior

Key evidence:

- `40_receive_input_type_introspection.json`
- `49_attempt_unexpected_item_field_D.json`

## Receiver-driven close after partial receipt

OMS allows the receiver to partially receive and then close the remaining expected quantity.

Shopify proof flow:

1. created ready-to-ship transfer `#T0026`
2. created shipment `#T0026-1` with quantity `2`
3. marked the shipment `IN_TRANSIT`
4. partially received quantity `1`
5. attempted `inventoryTransferRemoveItems` on the remaining line

Live result:

- partial receive succeeded
- shipment became `PARTIALLY_RECEIVED`
- transfer became `IN_PROGRESS`
- transfer line showed:
  - `shippedQuantity = 2`
  - `shippableQuantity = 0`
- `inventoryTransferRemoveItems` failed with:
  - `Transfer can only have its items removed in a Draft or Ready-to-ship status.`

Operational meaning:

- once shipment linkage has advanced the transfer to `IN_PROGRESS`, Shopify no longer exposes a remove-and-close path for the remaining quantity
- this is weaker than OMS receive-and-close and weaker than OMS close-fulfillment after partial execution

Key evidence:

- `41_create_ready_transfer_D.json`
- `43_create_shipment_D.json`
- `45_mark_in_transit_D.json`
- `46_receive_partial_D.json`
- `47_attempt_remove_after_partial_D.json`
- `50_shipment_detail_after_partial_D.json`
- `51_transfer_detail_after_partial_D.json`

## Inventory state after the failed close attempt

Current inventory snapshot for SKU `207-113-G` after the `#T0026` partial receive:

- Atlanta:
  - `available = 196`
  - `incoming = 0`
  - `reserved = 0`
  - `on_hand = 196`
- Austin:
  - `available = 13`
  - `incoming = 1`
  - `reserved = 0`
  - `on_hand = 13`

Operational meaning:

- one unit has been received into Austin availability
- one unit is still open in Austin incoming
- the failed close attempt did not resolve that remaining incoming quantity
- OMS can close that residual expectation explicitly; Shopify could not in this tested flow

Key evidence:

- `55_inventory_levels_after_gap_tests_item_207-113-G.json`

## Reject versus cancel

OMS reject is stronger than a simple cancel because it carries reject routing and reject state semantics.

Shopify proof flow:

1. created draft transfer `#T0027`
2. cancelled the draft transfer successfully
3. introspected the `InventoryTransfer` type fields

Live result:

- cancel succeeded
- transfer status became `CANCELED`
- `InventoryTransfer` fields did not include reject-specific fields such as reject reason or reject location

Operational meaning:

- Shopify cancel is a valid partial equivalent for OMS cancel before execution starts
- Shopify cancel is not the same as OMS reject-to-`REJECTED_ITM_PARKING`

Key evidence:

- `52_inventoryTransfer_type_introspection.json`
- `53_create_draft_transfer_E.json`
- `54_cancel_transfer_E.json`
- `cancel_summary.json`

## Final Conclusion

The earlier execution tests had already proven that Shopify can mirror the basic transfer lifecycle when shipment context exists.

This follow-up run proved the opposite side as well:

- Shopify cannot receive at transfer level
- Shopify cannot receive arbitrary unexpected items through shipment receive
- Shopify cannot cleanly express receiver-driven close after partial receipt once shipment execution has started
- Shopify cancel is not OMS reject

That closes the main proof gap between the OMS scenarios and the Shopify transfer model.
