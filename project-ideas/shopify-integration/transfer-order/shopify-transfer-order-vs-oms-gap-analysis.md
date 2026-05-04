# Shopify Transfer Order Vs OMS Gap Analysis

## Purpose

This document explains why OMS should remain the transfer-order system of record even if Shopify transfer APIs are adopted as a downstream mirror.

## Method And Evidence Standard

- Primary OMS evidence comes from the Maarg services, REST definitions, and transfer-order seed and status data in the local repo.
- Supporting OMS workflow intent comes from the foundation TO design docs on GitHub, reviewed on April 10, 2026.
- Shopify Admin GraphQL docs are treated as the normative source for transfer and shipment behavior.
- Shopify community threads are treated as operational evidence only, not as normative API rules.
- Conclusions that combine live behavior, OMS workflow, and Shopify docs are called out directly in the prose where needed.

## Executive Verdict

- Shopify now offers enough transfer and shipment APIs to mirror a basic draft -> ready -> ship -> receive execution flow.
- Shopify still does not model OMS flow ownership, TO-item-based receiving, unexpected-item receipt, receiver-side close behavior, reservation control, or reject-to-parking semantics cleanly.
- Shopify is suitable as an execution mirror and evidence surface, not as the primary TO workflow engine.

## Capability Comparison Matrix

| OMS capability | Shopify equivalent | Gap or breaking point | Operational impact | Evidence source |
| --- | --- | --- | --- | --- |
| Explicit TO flow types: `TO_Fulfill_Only`, `TO_Receive_Only`, `TO_Fulfill_And_Receive` | Transfer header plus shipment lifecycle | Shopify does not expose an equivalent flow-type model for authoring intent | Harder to encode whether OMS owns ship, receive, or both | OMS codebase, foundation TO docs, Shopify docs, and live behavior |
| Separate approval gates for store-fulfilled and warehouse-fulfilled TOs | Draft transfer then ready-to-ship transfer | Shopify supports draft and ready transitions, but not OMS-specific approval semantics | Approval meaning must stay in OMS | OMS codebase and Shopify docs |
| Order-item identity via `orderItemSeqId` | Transfer line items over `InventoryItem` | Shopify lines are inventory-item based, not OMS order-item based | Harder to preserve item-level business semantics and downstream reconciliation | OMS codebase and Shopify docs |
| Draft TO item edits before approval | `inventoryTransferSetItems` | Live testing showed edits also work after `READY_TO_SHIP` until shipment work starts, so the true breaking point is shipment linkage rather than draft status alone | Draft editing remains possible longer than a strict draft-only model suggests, but OMS still owns the business rule boundary | OMS codebase, Shopify docs, and live tests |
| Receive-only transfer flow | No clean equivalent | Shopify is oriented toward created transfer plus shipment plus receipt, not OMS receive-only orchestration | `TO_Receive_Only` should stay OMS-only | OMS codebase, foundation TO docs, and Shopify docs |
| Shipment creation separate from shipment ship | `inventoryShipmentCreate`, then `inventoryShipmentMarkInTransit` or `inventoryShipmentCreateInTransit` | Shopify can create and ship, but the transfer APIs do not replace OMS package, route-segment, and warehouse staging semantics | Shopify can mirror execution, but OMS remains richer as the operational workflow | OMS codebase and Shopify docs |
| Receipt can be entered against TO items and internally split across shipments | `inventoryShipmentReceive` | Shopify receives against shipment line items, not TO items | Receiving UI and workflow become shipment-centric in Shopify instead of item-centric | OMS codebase, foundation TO docs, and Shopify docs |
| Receipt without shipment reference | No clean equivalent | Shopify receipt requires shipment id and shipment receive line items | OMS can continue receiving when shipment linkage is missing; Shopify cannot mirror that directly | OMS codebase and Shopify docs |
| Over-receipt against TO item | Shipment-scoped over-receipt via `inventoryShipmentReceive` | Live testing showed Shopify accepts over-receipt, but only through shipment receive and not as TO-item-only receipt | OMS still owns the richer TO-item-centric over-receipt workflow and reconciliation | OMS codebase, foundation TO docs, Shopify docs, and live tests |
| Unexpected item receipt with no `orderItemSeqId` | No clean equivalent | Shopify receive flow works on existing shipment line items, not on arbitrary newly arrived products | Unexpected arrivals cannot be represented cleanly in Shopify TO flow | OMS codebase, foundation TO docs, and Shopify docs |
| Receiver can receive and close an item even when only part of the expected quantity arrived | No clean equivalent | Shopify has receipt and cancel tools, but not an OMS-style receiver-driven close of residual TO quantity | Residual receiving exceptions must stay in OMS | OMS codebase, foundation TO docs, and Shopify docs |
| Reject to `REJECTED_ITM_PARKING` with reject reason | `inventoryTransferCancel` at best | Cancel is weaker than reject-to-facility routing | Loss of reject destination semantics if OMS is not source of truth | OMS codebase, foundation TO docs, and Shopify docs |
| Close fulfillment with remaining reservation release and `cancelQuantity` handling | `inventoryTransferRemoveItems` at best | Shopify only removes shippable quantity not already tied to shipments | OMS can close partially fulfilled items more safely and explicitly | OMS codebase and Shopify docs |
| Reservation and reservation release as part of TO state changes | No reviewed first-class equivalent in transfer flow | Shopify reviewed transfer surface does not model OMS reservation control points | Reservation logic must remain in OMS | OMS codebase and Shopify docs |
| Large TO with `1,548` distinct items | One or more transfers | Shopify input arrays max out at `250` | Requires `7` transfer batches for the sample TO | TO sample, Shopify limits docs, and batching math |
| Transfer webhook visibility from draft state | Documented transfer webhooks start at item-change, ready, cancel, and complete topics | No documented create topic for draft transfer creation | Requires reconciliation or polling for draft visibility | Shopify docs and community posts |
| Shipment-to-transfer correlation in webhook-driven flows | `InventoryTransfer` has shipments; `InventoryShipment` object does not expose parent transfer field | Correlation is weak from the shipment side, especially through webhooks | More custom state correlation and reporting complexity | Shopify docs and community posts |
| PO-adjacent inbound workflow coverage | No public Purchase Order API | Shopify itself points developers toward workarounds and transfer APIs | Purchase-order-centric inbound orchestration cannot be built cleanly in Shopify today | Community posts and overall workflow analysis |

## Official Shopify Limitations

### 1. Array input limit forces batching

- Shopify states that any input argument accepting an array has a maximum size of `250`.
- A single OMS TO may need multiple Shopify transfers even before any business exception occurs.

Why this matters:

- OMS can treat one transfer order as one business document.
- Shopify may force the same document into multiple transfer batches.
- Every later action then becomes a batch fan-out problem.

### 2. Transfer lines are inventory-item based, not OMS order-item based

- `InventoryTransfer` tracks movement of `InventoryItem` objects between locations.
- OMS TO logic is written around `orderId` and `orderItemSeqId`, with item status flow, cancel quantity, shipped quantity, received quantity, and rejection data.
- Shopify line identity is too coarse to replace OMS order-item identity.

Why this matters:

- OMS can reason about one TO item independently.
- Shopify sees a transfer line in terms of inventory item and quantity.
- Business semantics such as reject reasons and close-fulfillment intent do not map one-to-one.

### 3. Receipt is shipment-centric

- `inventoryShipmentReceive` requires an inventory shipment id and shipment receive line items.
- OMS receipt can allocate received quantity across shipments and can also receive residual or excess quantity directly against the TO item without shipment linkage.
- The foundation TO design explicitly states that receipts are recorded against TO items, not shipments.
- Live testing showed that partial receipt, final receipt, and over-receipt all worked when driven from shipment receive calls.
- Shopify receiving is still narrower than OMS receiving because the control point remains shipment-centric.

Why this matters:

- shipment-backed receiving maps reasonably well
- over-receipt is possible, but only through shipment receive
- receipt-without-shipment does not
- unexpected-item receipt and receiver-side close behavior do not
- OMS must remain the authoritative receipt ledger

### 4. Shipment-side object model is incomplete for transfer correlation

- `InventoryTransfer` includes `shipments`
- The reviewed `InventoryShipment` field list does not include a parent `InventoryTransfer` field

Why this matters:

- the header can point to shipments
- the shipment cannot cleanly point back to the header through the reviewed object shape
- webhook consumers must reconstruct the relationship

### 5. Draft transfer webhook coverage is incomplete

- The documented transfer webhook topics include `add_items`, `cancel`, `complete`, `ready_to_ship`, `remove_items`, and `update_item_quantities`
- There is no documented draft transfer create topic

Why this matters:

- draft transfer creation is not fully event-visible
- integrations that need draft awareness must reconcile or poll
- OMS does not have this visibility gap internally

### 6. Late-stage item removal is limited

- `inventoryTransferRemoveItems` removes only shippable quantities not already associated with shipments
- Live testing showed remove-items works on a `READY_TO_SHIP` transfer before shipment linkage begins
- OMS close-fulfillment can cancel remaining reserved quantity, set `cancelQuantity`, and update status flow even after partial fulfillment has happened
- Shopify line removal is a narrower tool than OMS close-fulfillment

Why this matters:

- OMS can intentionally close a partially fulfilled item
- Shopify can remove the part that is still shippable and not already shipment-linked
- that is not enough to replace OMS fulfillment-close semantics

### 7. Mutation orchestration is heavier than it first appears

- Transfer, shipment, and shipment-receive actions use different access scopes
- Idempotency becomes required for transfer and shipment mutations as of `2026-04`
- GraphQL Admin is query-cost rate limited
- Shopify transfer integration requires more operational plumbing than a simple create/update mirror

Why this matters:

- more scopes to request and maintain
- more idempotency rules to honor
- more batch fan-out and retry complexity
- more cost pressure when reconciliation is needed

### 8. Shopify can mirror shipment execution but not the OMS receiving work queue

- Shopify does provide `inventoryShipmentCreate`, `inventoryShipmentMarkInTransit`, and `inventoryShipmentReceive`.
- The April 11, 2026 gorjana sandbox run executed all three successfully with the updated token.
- Ready-to-ship reduced origin `available` and increased origin `reserved`.
- In-transit released origin `reserved`, reduced origin `on_hand`, and increased destination `incoming`.
- Partial receipt reduced destination `incoming` and increased destination `available` incrementally.
- That is enough to mirror a basic create -> ship -> receive path and its core inventory movements.
- It is not enough to replace OMS receiving behavior where the user works against TO items, not shipment records.

Why this matters:

- OMS receivers can ignore how shipments were split and still receive accurately
- Shopify receivers and integrations are pulled back toward shipment-line-state management
- operational simplicity stays on the OMS side

## Community-Reported Operational Breaking Points

These are not treated as normative API rules. They are treated as operational evidence that the reviewed Shopify transfer flow still has rough edges in real integrations.

| Community observation | What was reported | Why it matters |
| --- | --- | --- |
| No draft transfer creation webhook | In the October 2025 thread, Shopify staff confirmed that there is no webhook for draft transfer creation and that the earliest webhook is ready-to-ship | Draft-state integrations must poll or reconcile |
| Weak shipment-to-transfer linkage | Developers reported that `InventoryShipment` lacks a transfer reference and shipment webhooks do not include transfer id | Harder reporting and downstream state reconstruction |
| Webhook behavior confusion | A December 2025 thread reports subscribing to transfer topics but only seeing `inventory_transfers/cancel`, and seeing it fire when the transfer was marked received | Suggests webhook observability and payload behavior are still immature |
| Transfer API rollout and scope friction | June 2025 threads show transfer API still stabilizing around unstable or release-candidate availability, including scope-access issues later fixed by Shopify | Early adopters faced avoidable integration friction |
| Admin UI inefficiency | Merchant complaints in the Shopify Community describe the new transfer UI as harder to use, with broken scrolling, weak filtering, and bulk transfer creation issues | Operational users handling large catalogs feel the pain before APIs even enter the picture |
| No public Purchase Order API | Shopify staff said purchase orders cannot currently be created via Admin API and there are no endpoints to work with purchase orders directly | Inbound inventory workflows remain fragmented |
| Purchase-order webhook topics not actually usable | January 2025 reports show purchase-order webhook topics present in unstable docs but not actually subscribable; Shopify staff said those topics should not have been displayed because the feature was being reworked | Another example of incomplete workflow surface for inbound inventory operations |

## What OMS Supports That Shopify Does Not

### Explicit flow ownership

- OMS distinguishes between fulfill-only, receive-only, and fulfill-and-receive transfer orders.
- that distinction is operationally important because it tells the business which side of the transfer OMS owns.
- Shopify transfer APIs do not give the same first-class modeling control.

### Approval before execution

- OMS uses separate approval services for store-fulfill and warehouse-fulfill transfer orders.
- approval is not just cosmetic. It changes header status, item statuses, and reservation behavior.
- Shopify ready-to-ship is useful as an execution mirror, but it does not replace OMS approval semantics.

### Richer item-level control

- OMS item flow includes draft item creation, draft item quantity edits, item status flow, cancellation, close-fulfillment, and shipped versus received quantity tracking.
- Shopify transfer lines are too lightweight to carry that full control surface.

### Reject with destination semantics

- OMS reject routes the TO to `REJECTED_ITM_PARKING` and carries rejection reason plus reject-to-facility behavior.
- This is a warehouse operation model, not just a transfer cancel.
- Shopify cancel cannot replace it.

### Receipt behavior that tolerates imperfect shipment history

- OMS can receive against available shipments, split receipts across shipments, over-receive, receive unexpected items, and later reconcile receipts when shipment records arrive later.
- that is substantially more tolerant of real operational messiness than Shopify shipment-only receipt handling.

### Receiver-driven close behavior

- The foundation TO workflow explicitly allows receive-and-close and close-received-item-even-if-partial behavior.
- This lets a receiving team intentionally stop expecting more stock for a TO item.
- Shopify transfer and shipment APIs do not provide the same item-centric close control.

### Reservation management

- OMS approval, cancel, reject, and close-fulfillment all interact with reservation logic.
- Reservation control is part of the TO workflow, not an unrelated side effect.
- Reviewed Shopify transfer APIs do not expose this as a comparable workflow concern.

### Better operational control for store and warehouse apps

- OMS exposes TO creation and approval through OMS APIs and transfer shipment, receipt, reject, and close-fulfillment through Poorti endpoints.
- OMS already has an app boundary aligned to real warehouse and store work.
- Shopify transfer APIs are better suited as a downstream mirror than as the operational backbone for these app workflows.

## Recommended System-Of-Record Position

- OMS should remain the transfer-order system of record.
- Shopify should mirror only the execution states that have a clean transfer or shipment equivalent.
- the safest phase-1 mirror scope is:
  - `ORDER_CREATED` -> draft transfer
  - `ORDER_APPROVED` -> ready-to-ship transfer
  - shipment create -> optional draft shipment mirror
  - shipment ship -> in-transit shipment
  - shipment-backed receipt -> shipment receive
- The following should remain OMS-only truth even if mirrored partially later:
  - `TO_Receive_Only`
  - reject-to-parking
  - close-fulfillment
  - receive-and-close and partial close at receiving time
  - reservation changes
  - unexpected-item receipt and receipt-without-shipment
- Shipment-scoped over-receipt can be mirrored in Shopify, but it should still be interpreted through OMS because OMS owns the TO-item-centric exception workflow.
- Shopify InventoryTransfer is an execution and reporting layer, not the right place to own OMS transfer-order orchestration.

## Suggested Shopify Validation Plan

Use this sequence when you want evidence of what Shopify actually offers:

1. Create a draft transfer in Shopify UI and through GraphQL.
2. Edit quantities and remove items while the transfer is draft.
3. Mark the transfer ready to ship.
4. Create a draft shipment, then add or update shipment items.
5. Mark the shipment in transit.
6. Receive the shipment partially and then fully.
7. Repeat the same flow through the Postman collection so you have API evidence as well as UI evidence.
8. Try the OMS-only or OMS-richer exception cases and record the result:
   - receive without shipment
   - over-receipt beyond shipped quantity
   - unexpected item not already on the transfer
   - receive and close with partial receipt
   - reject to parking facility
   - close fulfillment after partial shipment
9. Capture screenshots, GraphQL responses, webhook payloads, and any missing UI affordance for each case.

The proof you want is not just "Shopify cannot do X". It is:

- where Shopify has a native object and mutation
- where the object exists but loses OMS semantics
- where a workaround is required
- where there is no clean equivalent at all

## References

### Local sources

- `runtime/component/oms/service/co/hotwax/orderledger/order/TransferOrderServices.xml`
- `runtime/component/poorti/service/co/hotwax/poorti/TransferOrderFulfillmentServices.xml`
- `runtime/component/oms/service/oms.rest.xml`
- `runtime/component/poorti/service/poorti.rest.xml`
- `runtime/component/oms/data/TransferOrderSeedData.xml`
- Provided sample CSV analysis: `sqllab_untitled_query_33_20260402T145306.csv`
- https://raw.githubusercontent.com/saastechacademy/foundation/main/project-ideas/fulfillment-center-mgmt/readme.md
- https://raw.githubusercontent.com/saastechacademy/foundation/main/project-ideas/fulfillment-center-mgmt/receiveTransferOrder.md
- https://raw.githubusercontent.com/saastechacademy/foundation/main/project-ideas/fulfillment-center-mgmt/closeTransferOrderItemFulfillment.md
- https://raw.githubusercontent.com/saastechacademy/foundation/main/project-ideas/fulfillment-center-mgmt/rejectTransferOrder.md

### Shopify official docs reviewed on April 10, 2026

- https://shopify.dev/docs/api/admin-graphql/latest/objects/inventorytransfer
- https://shopify.dev/docs/api/admin-graphql/latest/objects/inventoryshipment
- https://shopify.dev/docs/api/admin-graphql/latest/mutations/inventoryTransferCreate
- https://shopify.dev/docs/api/admin-graphql/latest/mutations/inventoryTransferCreateAsReadyToShip
- https://shopify.dev/docs/api/admin-graphql/latest/mutations/inventoryTransferMarkAsReadyToShip
- https://shopify.dev/docs/api/admin-graphql/latest/mutations/inventoryTransferSetItems
- https://shopify.dev/docs/api/admin-graphql/latest/mutations/inventoryTransferRemoveItems
- https://shopify.dev/docs/api/admin-graphql/latest/mutations/inventoryTransferCancel
- https://shopify.dev/docs/api/admin-graphql/latest/mutations/inventoryShipmentCreate
- https://shopify.dev/docs/api/admin-graphql/latest/mutations/inventoryShipmentMarkInTransit
- https://shopify.dev/docs/api/admin-graphql/latest/mutations/inventoryShipmentCreateInTransit
- https://shopify.dev/docs/api/admin-graphql/latest/mutations/inventoryShipmentReceive
- https://shopify.dev/docs/api/usage/limits
- https://shopify.dev/docs/api/admin-graphql/latest/enums/WebhookSubscriptionTopic

### Shopify community sources

- https://community.shopify.dev/t/tracking-of-inventorytransfer-and-inventoryshipment/23275
- https://community.shopify.dev/t/inventory-transfers-webhook-behavior-payloads-and-bugs/26946
- https://community.shopify.dev/t/purchase-orders/2183
- https://community.shopify.dev/t/purchase-orders-api/23300
- https://community.shopify.dev/t/cant-create-a-subscription-to-purchase-orders-create-webhook/6869
- https://community.shopify.com/t/is-the-new-inventory-transfer-interface-less-efficient/47184/2
