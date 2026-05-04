# Shopify Transfer Order Scenarios To Run

## Purpose

This document defines the Transfer Order scenarios that should be run on Shopify to prove what Shopify offers, what maps cleanly from OMS, what only maps partially, and what cannot be done cleanly at all.

The wording and scenario structure below intentionally follow the foundation Transfer Order design notes so that OMS and Shopify can be compared in the same language.

### Scopes required

- `read_inventory`
- `write_inventory`
- `read_locations`
- `read_inventory_transfers`
- `write_inventory_transfers`
- `read_inventory_shipments`
- `write_inventory_shipments`
- `read_inventory_shipments_received_items`
- `write_inventory_shipments_received_items`

## Run These Scenarios

Run the scenarios through both Shopify API and Shopify UI.

### UI path

- Use Shopify Admin transfer screens to verify what an end user can do without custom orchestration.
- Use UI evidence for:
  - screen flow
  - edit affordances
  - missing actions
  - operational usability

## Test Data Preparation

### Test-data sets

1. Small happy-path set:
   - 2 SKUs
   - positive inventory at origin
   - clean one-transfer path
2. Medium edit-path set:
   - 3 to 5 SKUs
   - one item later increased
   - one item later removed
3. Large batching set:
   - one OMS TO with high line count
   - ideal if based on the Maarg TO sample already discussed

## Scenario Execution Order

Run the scenarios in this order so the evidence is easy to interpret.

1. Pre-flight data validation
2. Create Transfer Order scenarios
3. Approve Transfer Order scenarios
4. Fulfil Transfer Order scenarios
5. Receive Transfer Order scenarios
6. Close Transfer Order Fulfillment scenarios
7. Reject Transfer Order scenarios
8. Large TO batching scenario
9. Gap-proof summary

## Pre-Flight Data Validation

### Scenario P1: Confirm Shopify locations and inventory items exist

Foundation-style intent:

- validate that the locations and products required for the Transfer Order exist in Shopify before attempting the workflow

How to run:

- Query Shopify locations.
- Query Shopify inventory items by SKU.
- Map Maarg TO products to Shopify inventory items.

Expected result:

- locations can be read.
- inventory items can be read.

Evidence to capture:

- location ids and names
- SKU to inventory-item-id mapping

## Transfer Orders Will Facilitate Movement Of Inventory Between Locations, The Scenarios Being

### Scenario T1: TOs where Fulfillment location is managed by OMS and Receiving location is managed by third party e.g. Store to Warehouse

- OMS controls outbound fulfillment
- OMS does not need OMS-side receipt completion

Steps to test on Shopify:

1. Create a draft transfer.
2. Edit draft items.
3. Mark the transfer ready to ship.
4. Create shipment and mark it in transit.

Shopify result classification:

- transfer create and ready-to-ship are persisted

Proof to capture:

- draft transfer can be created
- ready-to-ship can be reached
- transfer line editing works before shipment starts
- inventory reservation starts at ready-to-ship

### Scenario T2: TOs where Fulfillment location is managed by third party and Receiving location is managed by OMS e.g. Warehouse to Store

- fulfillment is external
- OMS primarily controls approval-to-receipt

How to test on Shopify:

1. Attempt to represent the receive-only business flow without creating a normal Shopify-authored transfer and shipment path.
2. Attempt to receive inventory in a way that matches OMS receive-only behavior.

Proof to capture:

- Shopify transfer model expects a transfer and shipment context rather than OMS receive-only orchestration
- receipt operations are shipment-based, not TO-item-based

### Scenario T3: TOs where both Fulfillment and Receiving locations are managed by OMS e.g. Store to Store

- OMS controls both ship and receive

How to test on Shopify:

1. Create draft transfer.
2. Edit draft items.
3. Mark ready to ship.
4. Create draft shipment.
5. Mark shipment in transit.
6. Receive shipment.

Proof to capture:

- basic transfer execution can be mirrored
- receiver-side item semantics still do not map fully

## Create Transfer Order

### Scenario C1: Create Transfer Order

- Use the API to create Transfer Order builds on createOrder.

How to run on Shopify:

- Run `Create Draft Transfer` from the Postman collection.

Expected Shopify result:

- supported now with current token

Proof to capture:

- transfer id
- status
- reference name
- line items count

### Scenario C2: Update draft item quantity

- draft TO items can be edited before approval

How to run on Shopify:

- Run `Set Transfer Items` while the transfer is still draft.

Expected Shopify result:

- supported before shipment starts

Proof to capture:

- quantity change succeeds before ready-to-ship
- quantity change can still succeed after ready-to-ship if shipment has not started
- same change becomes constrained after shipment linkage starts

### Scenario C3: Add draft item

- draft TO can be updated with additional items before approval

How to run on Shopify:

- Re-run `Set Transfer Items` with the full intended item set.

Expected Shopify result:

- supported before shipment starts

Proof to capture:

- Shopify does not add an OMS order item identity, only inventory-item line identity

## Approve Transfer Order

### Scenario A1: Approve Transfer Order for `TO_Fulfill_Only`

- `ITEM_CREATED` moves to `ITEM_PENDING_FULFILL` when approving the TO

How to run on Shopify:

- Run `Mark Transfer Ready To Ship` or `Create Ready To Ship Transfer`.

Expected Shopify result:

- clean transfer-state equivalent

Proof to capture:

- draft to ready transition exists
- no OMS-style approval semantics are stored beyond transfer status

### Scenario A2: Approve Transfer Order for `TO_Receive_Only`

- `ITEM_CREATED` moves to `ITEM_PENDING_RECEIPT` when approving the TO

How to run on Shopify:

- Attempt to model the same flow without using a normal create-and-ship transfer authoring path.

Expected Shopify result:

- no clean equivalent

Proof to capture:

- no first-class receive-only transfer authoring semantics

### Scenario A3: Approve Transfer Order for `TO_Fulfill_And_Receive`

- `ITEM_CREATED` moves to `ITEM_PENDING_FULFILL` when approving the TO

How to run on Shopify:

- Same as `TO_Fulfill_Only` approval, then continue to shipment and receipt.

Expected Shopify result:

- partial overall fit

Proof to capture:

- approval exists as ready-to-ship
- later receiving semantics diverge from OMS

## Fulfil Transfer Order

### Scenario F1: Create OutTransferShipment

- An inventory storage location will create the OutTransferShipment for a transfer order.

How to run on Shopify:

- Run `Create Draft Shipment`.

Proof to capture:

- shipment create succeeds
- inventory does not change at shipment-draft creation
- compare whether Shopify draft shipment is operationally rich enough versus OMS shipment create

### Scenario F2: Ship OutTransferShipment

Foundation-style intent:

- The Transfer Shipment created will be shipped by adding tracking details.

How to run on Shopify:

1. Run `Set Shipment Tracking`.
2. Run `Mark Shipment In Transit`.
3. Or use `Create Shipment In Transit`.

Proof to capture:

- origin reserved quantity is released at in-transit
- origin on-hand quantity decreases at in-transit
- destination incoming quantity increases at in-transit

## Receive Transfer Order

### Scenario R1: Partial Receipt

- Only a portion of the TO Item quantity is received.
- The remaining quantity stays open for future receipts.

How to run on Shopify:

- Receive less than the shipped quantity for one shipment line item.

Expected Shopify result:
- partial equivalent because the remaining open quantity is tracked shipment-line-wise, not TO-item-wise

Proof to capture:

- partial receive succeeds against a shipment line item
- destination `incoming` decreases only by the received quantity
- destination `available` and `on_hand` increase only by the received quantity
- remaining open quantity is tracked on the shipment line, not as an OMS TO-item receive queue

### Scenario R2: Multiple Shipments for Same Item

- An item is shipped in multiple fulfillments.
- The full quantity can be received at once, even if it was split across shipments.

How to run on Shopify:

1. Create two shipments for the same transfer item.
2. Attempt one receiving action that behaves like OMS TO-item receipt.
3. Then receive the two shipments separately.

Proof to capture:

- OMS lets the user receive once at TO-item level and internally split
- Shopify expects receipt against shipment line items
- one transfer can hold multiple shipments
- Shopify requires separate receive calls for each shipment

### Scenario R3: Receiving New Product (Not in TO)

- A product not listed in the original TO arrives with the shipment.
- The system allows its receipt, marking it as an unexpected item without an `orderItemSeqId`.

How to run on Shopify:

- Attempt to receive an item that is not already on the shipment line set.

Proof to capture:

- inability to receive arbitrary unexpected product through shipment receive flow

### Scenario R4: Receive TO Item and Close

Foundation-style intent:

- Item is fully received, and the system marks it as closed.
- No further receipts will be accepted for that item.

How to run on Shopify:

- Fully receive one shipment line item.

Expected Shopify result:

- supported as shipment completion
- partial equivalent, not an OMS TO-item close action

Proof to capture:

- compare shipment completion with OMS TO-item closure semantics

### Scenario R5: Close Received TO Item (Even if Partial)

- The receiver can choose to close a TO Item manually, even if the full quantity has not been received.

How to run on Shopify:

- Attempt to partially receive and then explicitly stop expecting more quantity for that item.

Expected Shopify result:

- no clean equivalent

Proof to capture:

- no receiver-side item close control matching OMS

### Scenario R6: Receiving Against TO Items, Not Shipments

- Receipts are recorded against TO Items, not individual shipments.

How to run on Shopify:

- Attempt to perform receiving without driving the interaction from shipment ids and shipment line ids.

Expected Shopify result:

- no clean equivalent

Proof to capture:

- Shopify receive API requires shipment and shipment line references

### Scenario R7: Handling Over-Receipts

- If the quantity received exceeds the sum of all known shipments, the extra quantity is recorded directly against the TO Item.

How to run on Shopify:

- Attempt to receive more than the total shipped quantity for the same item.

Expected Shopify result:

- partial equivalent
- supported only through shipment receive, not as OMS TO-item-only receipt

Proof to capture:

- Shopify accepts receive quantity greater than shipment line quantity
- transfer `receivedQuantity` can exceed transfer `totalQuantity`
- destination inventory increases by the over-received quantity
- OMS allows over-receipt with TO-item-only linkage
- Shopify receive remains shipment-scoped

## Close Transfer Order Fulfillment

### Scenario CF1: Close Transfer Order Item Fulfillment

- give an option in the Fulfillment app to close the fulfillment of the item
- this could happen if the end-user wants to close the fulfillment after partially fulfilling the order items

How to run on Shopify:

- Attempt to remove or otherwise close the residual quantity after partial shipment activity.

Expected Shopify result:

- partial at best

Proof to capture:

- Shopify `inventoryTransferRemoveItems` only handles shippable quantity not already linked to shipments
- OMS close-fulfillment is stronger

## Reject Transfer Order

### Scenario J1: Reject Transfer Order

- the TO can only be rejected if fulfilment has not been started
- the complete TO will be rejected
- the Transfer Order will be moved to `REJECTED_ITM_PARKING`
- the reservations will be cancelled

How to run on Shopify:

- Cancel a transfer before shipment work starts.

Expected Shopify result:

- partial equivalent only

Proof to capture:

- Shopify cancel exists
- Shopify does not model reject-to-facility, reject reason routing, or reservation cancellation semantics

## Large Transfer Order Scenario

### Scenario L1: Large TO needs batching

How to run on Shopify:

- Take one large OMS TO from Maarg.
- Count the distinct products to be posted to Shopify.
- Attempt to create the transfer payload or split it deterministically.

Expected Shopify result:

- line arrays are limited to `250`

Proof to capture:

- one OMS TO may require multiple Shopify transfers
- this changes orchestration, retry, and reconciliation behavior

## How To Record Proof

For each scenario, capture all of the following:

1. OMS wording being tested
2. Shopify GraphQL query or mutation used
3. Request body
4. Response body
5. Notes on operational impact

These can be run now:

- P1 Confirm Shopify locations and inventory items exist
- T1 transfer create and ready-to-ship portion
- T3 transfer create, draft edit, ready-to-ship, shipment, and receipt portion
- C1 Create Transfer Order
- C2 Update draft item quantity
- C3 Add draft item
- A1 Approve Transfer Order for `TO_Fulfill_Only`
- A3 Approve Transfer Order for `TO_Fulfill_And_Receive`
- F1 Create OutTransferShipment
- F2 Ship OutTransferShipment
- R1 Partial Receipt
- R2 Multiple Shipments for Same Item
- R4 Receive TO Item and Close
- R7 Handling Over-Receipts
- J1 transfer-cancel portion before shipment work starts
- L1 Large TO batching proof