# Shopify Transfer Order Inventory Transfer Mapping

## Purpose

This document maps OMS Transfer Order events to Shopify `InventoryTransfer` and `InventoryShipment` mutations so that OMS behavior can be mirrored on Shopify as closely as possible.

The focus is event mapping, not code structure.

## Executive Summary

OMS creates a Transfer Order for all three TO flow types:

- `TO_Fulfill_Only`
- `TO_Receive_Only`
- `TO_Fulfill_And_Receive`

That includes Warehouse to Store. The difference between the three flows is not whether a TO exists. The difference is what OMS does with that TO after creation.

The practical Shopify mapping is:

- mirror OMS TO creation as Shopify draft transfer creation
- mirror OMS approval as Shopify ready-to-ship transfer state
- mirror OMS shipment creation and ship events only when OMS actually performs those events
- mirror OMS receipt only when Shopify has a shipment context for that receipt

This means:

- Store to Store maps best
- Store to Warehouse maps well for creation and fulfillment-side mirroring
- Warehouse to Store does create a TO in OMS and can be mirrored as a transfer header on Shopify, but receipt mirroring still depends on shipment existence in Shopify

## OMS Model That Drives The Mapping

### TO Flow Types

| OMS flow | Typical route | OMS ownership |
| --- | --- | --- |
| `TO_Fulfill_Only` | Store to Warehouse | OMS owns fulfillment side |
| `TO_Receive_Only` | Warehouse to Store | OMS owns receiving side |
| `TO_Fulfill_And_Receive` | Store to Store | OMS owns both fulfillment and receiving |

### Important correction

Warehouse to Store is still a Transfer Order in OMS.

OMS creates the TO in `ORDER_CREATED` first. The `statusFlowId` then decides which approval path and item-state transitions apply afterward.

For `TO_Receive_Only`:

- the TO is created in OMS
- approval moves items from `ITEM_CREATED` to `ITEM_PENDING_RECEIPT`
- OMS then receives against TO items

So the Shopify mapping should not treat Warehouse to Store as “no TO exists”. The correct statement is:

- a TO exists in OMS
- Shopify can mirror the TO header and approval state
- Shopify cannot fully mirror OMS receiving behavior unless there is a usable shipment context in Shopify

### OMS Lifecycle

| OMS event | OMS service | OMS result |
| --- | --- | --- |
| Create TO | `create#TransferOrder` | Creates Transfer Order in `ORDER_CREATED` with `ITEM_CREATED` lines |
| Update draft item | `update#TransferOrderItem` | Changes draft item quantity while order is still `ORDER_CREATED` |
| Add draft item | `add#TransferOrderItem` | Adds a new draft item while order is still `ORDER_CREATED` |
| Approve store-fulfilled TO | `approve#StoreFulfillTransferOrder` | Moves order to `ORDER_APPROVED`, items to `ITEM_PENDING_FULFILL` |
| Approve warehouse-fulfilled TO | `approve#WhFulfillTransferOrder` | Moves order to `ORDER_APPROVED`, items to `ITEM_PENDING_RECEIPT` |
| Create transfer shipment | `create#TransferOrderShipment` | Creates outbound transfer shipment in OMS |
| Ship transfer shipment | `ship#TransferOrderShipment` | Issues inventory and marks shipment shipped |
| Receive TO | `receive#TransferOrder` | Records receipts against TO items |
| Reject TO | `reject#TransferOrder` | Rejects the full TO before fulfillment starts |
| Close fulfillment | `close#TransferOrderItemFulfillment` | Closes remaining fulfillable quantity |
| Cancel TO | `cancel#TransferOrder` | Cancels TO before shipment or receipt work starts |

## Shopify Model Used For The Mapping

| Shopify object or mutation | Use in the mapping |
| --- | --- |
| `inventoryTransferCreate` | Create draft transfer |
| `inventoryTransferCreateAsReadyToShip` | Create ready-to-ship transfer directly |
| `inventoryTransferMarkAsReadyToShip` | Move draft transfer to ready-to-ship |
| `inventoryTransferSetItems` | Replace transfer line set before shipment execution starts |
| `inventoryTransferRemoveItems` | Remove remaining shippable quantity before shipment linkage blocks it |
| `inventoryTransferCancel` | Cancel transfer before shipment or receipt execution |
| `inventoryShipmentCreate` | Create draft shipment under a transfer |
| `inventoryShipmentCreateInTransit` | Create shipment directly in transit |
| `inventoryShipmentReceive` | Receive shipment line quantities |

## Mapping Principles

### 1. OMS stays the source of truth

Shopify should mirror OMS events. Shopify should not decide the TO business flow.

### 2. Create the Shopify transfer when OMS creates the TO

This applies to all three OMS flow types, including `TO_Receive_Only`.

### 3. Use approval to move Shopify from draft to ready-to-ship

This gives the cleanest header-state parity between OMS and Shopify.

### 4. Only mirror shipment execution when shipment execution exists in OMS

For `TO_Fulfill_Only` and `TO_Fulfill_And_Receive`, OMS shipment events can be mirrored directly.

For `TO_Receive_Only`, OMS may receive without owning the fulfillment-side shipment creation. In that case Shopify shipment requirements become the main gap.

### 5. Receipt is the hardest area to map

OMS receives against TO items.

Shopify receives against shipment line items.

That is the main workflow mismatch.

## Event-To-Mutation Mapping

| OMS event | When it happens in OMS | Shopify mutation or action | Recommended mapping | Notes |
| --- | --- | --- | --- | --- |
| Create TO | `ORDER_CREATED` | `inventoryTransferCreate` | Create draft transfer | Use for `TO_Fulfill_Only`, `TO_Receive_Only`, and `TO_Fulfill_And_Receive` so the Shopify header exists from the same starting point as OMS |
| Update draft item | Draft TO edit | `inventoryTransferSetItems` | Replace full transfer line set | Keep this only before shipment execution starts |
| Add draft item | Draft TO edit | `inventoryTransferSetItems` | Replace full transfer line set | Shopify line identity is inventory-item based, so resend the full desired line set |
| Approve store-fulfilled TO | `approve#StoreFulfillTransferOrder` | `inventoryTransferMarkAsReadyToShip` or `inventoryTransferCreateAsReadyToShip` | Move transfer to ready-to-ship | Mirrors OMS approval for `TO_Fulfill_Only` and `TO_Fulfill_And_Receive` |
| Approve warehouse-fulfilled TO | `approve#WhFulfillTransferOrder` | `inventoryTransferMarkAsReadyToShip` or `inventoryTransferCreateAsReadyToShip` | Move transfer to ready-to-ship | This is the corrected Warehouse to Store mapping. The TO exists in OMS, so the Shopify transfer header should also move to ready-to-ship even though OMS is primarily controlling receipt next |
| Create transfer shipment | `create#TransferOrderShipment` | `inventoryShipmentCreate` | Create draft shipment | Use when OMS explicitly creates the shipment and you want shipment-level parity on Shopify |
| Ship transfer shipment | `ship#TransferOrderShipment` | `inventoryShipmentCreateInTransit` or `inventoryShipmentMarkInTransit` | Move shipment to in-transit | Use `inventoryShipmentCreateInTransit` when no draft shipment mirror is needed |
| Receive TO against shipment-backed quantity | `receive#TransferOrder` | `inventoryShipmentReceive` | Receive shipment line items | Works when Shopify has the shipment and shipment line context |
| Receive TO without shipment reference | `receive#TransferOrder` | No clean equivalent | Keep OMS as truth | OMS can receive against TO items even when shipment linkage is absent; Shopify cannot do that |
| Receive one TO item that was split across multiple shipments | `receive#TransferOrder` | Multiple `inventoryShipmentReceive` calls | Partial equivalent only | OMS can receive once at TO-item level; Shopify requires one receive call per shipment |
| Over-receipt | `receive#TransferOrder` | `inventoryShipmentReceive` | Partial equivalent only | Shopify does allow over-receipt, but only through shipment receive, not as TO-item-only receipt |
| Unexpected item receipt | `receive#TransferOrder` | No clean equivalent | Keep OMS as truth | OMS can receive an item not originally on the TO; Shopify shipment receive cannot |
| Receive and close | `receive#TransferOrder` with close semantics | No clean equivalent | Keep OMS as truth | Shopify receives quantity but does not expose the same receiver-driven close behavior |
| Close fulfillment | `close#TransferOrderItemFulfillment` | `inventoryTransferRemoveItems` at best | Partial equivalent only | Use only before shipment linkage makes the line immutable on Shopify |
| Reject TO | `reject#TransferOrder` | `inventoryTransferCancel` at best | Partial equivalent only | Shopify cancel does not represent reject-to-parking behavior |
| Cancel TO | `cancel#TransferOrder` | `inventoryTransferCancel` | Cancel transfer | Good fit while no shipment or receipt execution has started |

## Flow-Specific Mapping

### `TO_Fulfill_Only` mapped to Shopify

OMS sequence:

1. Create TO
2. Approve store-fulfilled TO
3. Create transfer shipment
4. Ship transfer shipment

Recommended Shopify sequence:

1. `inventoryTransferCreate`
2. `inventoryTransferMarkAsReadyToShip`
3. `inventoryShipmentCreate`
4. `inventoryShipmentMarkInTransit` or `inventoryShipmentCreateInTransit`

Notes:

- this is a strong fit for header and fulfillment-side mirroring
- OMS usually does not need OMS-side receipt completion in this flow
- if the receiving side is external, Shopify receipt does not need to be driven from OMS unless that is required for reporting

### `TO_Receive_Only` mapped to Shopify

OMS sequence:

1. Create TO
2. Approve warehouse-fulfilled TO
3. Receive TO items

Recommended Shopify sequence:

1. `inventoryTransferCreate`
2. `inventoryTransferMarkAsReadyToShip`
3. `inventoryShipmentReceive` only if the shipment already exists in Shopify

Notes:

- this is the corrected Warehouse to Store mapping
- the TO should exist on Shopify because the TO does exist in OMS
- the gap is not TO creation
- the gap is that OMS receipt is TO-item-driven while Shopify receipt is shipment-driven
- if external fulfillment does not create shipment records in Shopify, OMS receipt has no direct Shopify mutation equivalent

### `TO_Fulfill_And_Receive` mapped to Shopify

OMS sequence:

1. Create TO
2. Approve store-fulfilled TO
3. Create transfer shipment
4. Ship transfer shipment
5. Receive TO

Recommended Shopify sequence:

1. `inventoryTransferCreate`
2. `inventoryTransferMarkAsReadyToShip`
3. `inventoryShipmentCreate`
4. `inventoryShipmentMarkInTransit` or `inventoryShipmentCreateInTransit`
5. `inventoryShipmentReceive`

Notes:

- this is the best end-to-end fit
- the main remaining gap is still TO-item-based receiving versus shipment-based receiving

## What Must Be True Before Posting To Shopify

The live tests showed that transfer creation and shipment execution have stricter Shopify preconditions than OMS TO creation.

Before posting a TO line to Shopify, the integration should confirm:

1. the product is mapped to a Shopify inventory item
2. the Shopify inventory item tracks inventory
3. the source facility is mapped to a Shopify location
4. the destination facility is mapped to a Shopify location
5. for shipment execution, the item is already stocked and active at the destination location

Without these checks:

- transfer creation can fail because the inventory item does not track inventory
- shipment creation can fail with destination inventory-state errors even after transfer creation succeeded

## Inventory Behavior To Expect On Shopify

The live tests showed this pattern:

1. Draft transfer creation does not move inventory.
2. Ready-to-ship reduces origin `available` and increases origin `reserved`.
3. In-transit reduces origin `on_hand`, releases origin `reserved`, and increases destination `incoming`.
4. Receipt reduces destination `incoming` and increases destination `available`.

That sequence is close enough to OMS to use Shopify as an execution mirror.

## Large TO Handling

Shopify does not allow one very large OMS TO to be posted as one transfer payload.

The immediate constraint is the mutation array limit:

- one mutation input array can hold at most `250` line items

For the provided TO sample `M111629`:

- distinct products: `1,548`
- required Shopify transfer batches: `7`

So the mapping for a large OMS TO is:

1. keep one OMS TO as the business document
2. split the Shopify mirror into deterministic transfer batches
3. apply later shipment and receipt events batch by batch

## Recommended Posting Sequence

### For a new sync

1. Read the OMS TO.
2. Read `statusFlowId`.
3. Build the Shopify line set from OMS items.
4. Validate location mapping and inventory-item mapping.
5. Split the line set into `250`-line batches if needed.
6. Create Shopify draft transfers for each batch.

### When OMS approves the TO

1. Find all Shopify transfer batches for the TO.
2. Move them to ready-to-ship.

### When OMS ships

1. Find the correct Shopify transfer batch or batches.
2. Create or update the Shopify shipment representation.
3. Move the shipment to in-transit.

### When OMS receives

1. If the receipt can be tied to Shopify shipment lines, call `inventoryShipmentReceive`.
2. If OMS received against TO items without shipment context, do not force a fake Shopify receive.
3. Keep OMS as the receipt truth for that case and record the mismatch explicitly.

## Proposed Manual Sync Contract

This section defines the expected behavior of a future sync service.

### Input

- `orderId`
- optional Shopify remote or shop override
- optional force-resync flag

### Output

- resolved Shopify shop
- total Shopify transfer batches used for the TO
- transfer ids created or reused
- target state reached on Shopify

### Rules

- one OMS TO can map to many Shopify transfers
- the mapping key should be `orderId + batch sequence`
- reruns should be idempotent
- do not partially post a TO when required mappings are missing
- do not try to make Shopify receive events represent OMS receipt behavior that Shopify cannot actually model

## References

- `runtime/component/oms/service/co/hotwax/orderledger/order/TransferOrderServices.xml`
- `runtime/component/poorti/service/co/hotwax/poorti/TransferOrderFulfillmentServices.xml`
- `runtime/component/oms/service/oms.rest.xml`
- `runtime/component/poorti/service/poorti.rest.xml`
- `runtime/component/oms/data/TransferOrderSeedData.xml`
- https://raw.githubusercontent.com/saastechacademy/foundation/main/project-ideas/fulfillment-center-mgmt/readme.md
- https://raw.githubusercontent.com/saastechacademy/foundation/main/project-ideas/fulfillment-center-mgmt/receiveTransferOrder.md
- https://raw.githubusercontent.com/saastechacademy/foundation/main/project-ideas/fulfillment-center-mgmt/closeTransferOrderItemFulfillment.md
- https://raw.githubusercontent.com/saastechacademy/foundation/main/project-ideas/fulfillment-center-mgmt/rejectTransferOrder.md
- https://shopify.dev/docs/api/admin-graphql/latest/objects/inventorytransfer
- https://shopify.dev/docs/api/admin-graphql/latest/objects/inventoryshipment
- https://shopify.dev/docs/api/admin-graphql/latest/mutations/inventoryTransferCreate
- https://shopify.dev/docs/api/admin-graphql/latest/mutations/inventoryTransferCreateAsReadyToShip
- https://shopify.dev/docs/api/admin-graphql/latest/mutations/inventoryTransferMarkAsReadyToShip
- https://shopify.dev/docs/api/admin-graphql/latest/mutations/inventoryTransferSetItems
- https://shopify.dev/docs/api/admin-graphql/latest/mutations/inventoryTransferRemoveItems
- https://shopify.dev/docs/api/admin-graphql/latest/mutations/inventoryTransferCancel
- https://shopify.dev/docs/api/admin-graphql/latest/mutations/inventoryShipmentCreate
- https://shopify.dev/docs/api/admin-graphql/latest/mutations/inventoryShipmentCreateInTransit
- https://shopify.dev/docs/api/admin-graphql/latest/mutations/inventoryShipmentReceive
- https://shopify.dev/docs/api/usage/limits
