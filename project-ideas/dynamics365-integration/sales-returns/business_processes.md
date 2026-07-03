# D365 Sales Returns — Business Processes

This document covers the standard Dynamics 365 Finance & Operations return process, the D365 entities and batch classes available for integration, OMS return type classification, and the accounting model for returns and exchanges.

For technical implementation details, service flows, and field mappings see [implementation_plan.md](./implementation_plan.md).

---

## 1. D365 Return Order Fundamentals

A return order in D365 is **a sales order with `OrderType = Returned order`**. It lives in `Accounts receivable > Orders > All sales orders` alongside regular orders — there is no separate return module. The RMA number is an alternate key assigned to the return order from a number sequence configured in AR parameters.

### 1.1 Two Process Types

| Type | Description | When to Use |
| :--- | :--- | :--- |
| **Physical Return** | Customer sends goods back; D365 tracks receipt, inspection, and inventory re-entry | Goods must be physically received before credit is issued |
| **Credit Only** | Credit is issued without requiring physical return | Trust-based returns, defective goods not worth shipping back, low-cost items |

---

## 2. Physical Return Lifecycle

The full step-by-step process for a physical return in D365:

```
1. Create Return Order (header + lines)
        ↓
2. Arrival Registration (goods received at warehouse)
        ↓
3. Assign Disposition Code
        ↓
4. Post Packing Slip (commits disposition to inventory)
        ↓
5. Generate Invoice → Credit Note (financial closing)
        ↓
6. Create Refund Payment Journal (if cash refund issued)
        ↓
7. Settle (credit note + refund journal against original invoice)
```

> **Note:** D365 also supports an optional Quarantine Order step between arrival and disposition assignment, where items are held for inspection before being accepted into inventory. This is not part of the OMS integration flow.

### 2.1 Create Return Order

The OMS initiates return order creation in D365 at the `RETURN_REQUESTED` stage — one return order per OMS return. The return header and lines are created via OData using `ReturnOrderHeadersV2` and `ReturnOrderLinesV2`.

D365 auto-generates an **RMA number** from the AR number sequence on header creation and assigns it back to the return order record — the OMS reads and stores this as `D365_RMA_NUM` for reference throughout the lifecycle. Both `D365_RTN_ORD_NUM` (the D365 Return Order Number) and `D365_RMA_NUM` are stored on the standard OMS `ReturnIdentification` entity, mirroring how `D365_SLS_ORD_NUM` is stored on `OrderIdentification` for sales orders. No export or polling step is needed to get these values back into OMS — since return order creation uses OData (not DMF), both numbers are already returned synchronously in the same POST response.

For the full OData field mapping and payload structure, see [implementation_plan.md](./implementation_plan.md).

### 2.2 Arrival at Warehouse (Arrival Journal)

Before inventory can be received, arrival must be registered via an **Item Arrival Journal**.

- The OMS creates arrival journals via the D365 DMF **"Item arrival journals V2" composite entity** — header and lines are submitted as a single XML document in a ZIP package via `/api/connector/enqueue/{activityId}`; D365 auto-generates the journal number internally
- The individual OData entities `ItemArrivalJournalHeadersV2` and `ItemArrivalJournalLinesV2` are confirmed available but are not used in the OMS integration — the OData path has a sequencing constraint where the journal number is auto-generated on header creation and must be known for each subsequent line POST; the DMF composite entity avoids this entirely
- Posting the arrival journal is handled by the custom D365 batch class **`HotWaxAutoPostArrivalJournalService`**, which wraps `WMSJournalCheckPostReception` and picks up **all unposted Reception journals matching a configured `JournalNameId`** (the OOTB `WMSJournalCheckPostReception` only posts one selected journal at a time; this custom class is what enables bulk auto-posting)
- Quarantine can be enabled during arrival if inspection is required — quarantined items cannot have a disposition code assigned until the quarantine order is completed

#### Journal Name: `OMSArr`

Arrival journals from OMS use a dedicated journal name, **`OMSArr`** ("OMS Arrival Journal"), rather than the D365 default (`WArr`).

**Why:** `WArr` is also the *default* journal name for Item Arrival in this D365 environment (Inventory management → Setup → Journal names → Warehouse management). Since it's a default, any native or manual arrival journal posting that doesn't explicitly pick a different journal name — a warehouse worker registering a return receipt manually, for example — would also land under `WArr`, and `HotWaxAutoPostArrivalJournalService` would then auto-post those too, even though they were never created by OMS. This is the same reasoning behind splitting `OMSPAY`/`OMSRFND` for payments: a shared/default journal name can't reliably isolate OMS-originated records from everything else in the system that might use the same name.

`OMSArr` is deliberately **not** set as a default anywhere, so it's only ever used when OMS explicitly specifies it. **Check picking location** is left off on this journal name — that setting controls whether D365 auto-assigns a storage bin/location on posting, which only matters for advanced/license-plate-controlled warehouses. Since OMS-driven return arrivals mostly target POS/store facilities (basic inventory management, not WMS-controlled locations), leaving it off matches Microsoft's documented guidance for basic-warehousing scenarios.

> **Known gap:** OMS currently queues an arrival journal for *any* return that's synced and not cancelled, regardless of return status. This is correct for POS returns (goods are already physically back by the time OMS syncs them), but not yet correct for online returns — those sync to D365 at `RETURN_REQUESTED`, *before* the item physically arrives, so queuing the arrival journal at that point would tell D365 inventory has arrived before it actually has. Not yet fixed — needs gating on an actual physical-receipt signal (e.g. `ShipmentReceipt`) for online returns specifically. Separately, returns destined for D365-managed warehouses (not OMS/WMS-managed facilities) should be excluded from this flow entirely, since D365's own native receiving process would create its own arrival journal — this exclusion is also not yet implemented.

### 2.3 Disposition Codes

D365 separates two concepts:
- **Disposition actions** — six predefined behaviors built into D365 that control financial treatment, inventory fate, and whether a replacement order is auto-created
- **Disposition codes** — user-defined codes (e.g. `CREDIT`, `SCRAP`, `EXCHANGE`) configured in AR parameters, each mapped to one of the six actions; the warehouse assigns a code during arrival registration

The six standard disposition actions:

| Disposition Action | Customer Credited? | Inventory | Replacement Order |
| :--- | :---: | :--- | :---: |
| **Credit only** | Yes | No physical return — no inventory movement | No |
| **Credit** | Yes | Item returned to stock | No |
| **Replace and credit** | Yes | Item returned to stock | Yes (auto-created at packing slip posting) |
| **Replace and scrap** | Yes | Item scrapped, loss posted to ledger | Yes (auto-created at packing slip posting) |
| **Scrap** | Yes | Item scrapped, loss posted to ledger | No |
| **Return to customer** | No | Item returned to customer after inspection | No |

> **Credit only** is the most important disposition for integration: it allows skipping the arrival and packing slip steps entirely and going directly to invoice/credit note. This is the correct disposition for POS completed returns and online returns where the item will not be physically tracked back into D365 inventory.

> **Exchange orders and replacement orders:** The "Replace and credit" and "Replace and scrap" actions auto-create a D365 replacement sales order at packing slip posting. Since OMS exchange orders are synced to D365 as normal sales orders via the standard sales order sync, care must be taken to avoid creating duplicate D365 sales orders for the same exchange — the disposition mapping for exchange returns should use **Credit** (not Replace and credit) so that the OMS-driven exchange order is the single source of truth.

> **TODO:** Confirm D365 behavior when "Replace and credit" or "Replace and scrap" disposition is used — specifically: what data does the auto-created replacement sales order contain (item, quantity, price), can it be suppressed or skipped, and whether using **Credit** disposition instead is safe for the exchange flow where OMS owns the replacement order creation.

### 2.4 Post Packing Slip

The packing slip is the **physical update** — it commits the disposition action to inventory. It is the return equivalent of the outbound packing slip on a sales order.

- Can only be posted for lines in **Registered** status (arrival registered)
- When posted, replacement sales orders are auto-created for disposition codes that require them
- Items marked **Scrap** have their inventory loss posted to the ledger at this point
- For **Credit only** disposition: lines go directly to **Received** status without needing an arrival journal or packing slip — this is the shortcut path

The D365 batch class **`SalesFormLetter_Invoice`** handles both packing slip posting and invoice generation for return orders.

### 2.5 Generate Invoice → Credit Note

The credit note is generated from the **Sales order** page (not the Return order page) — return orders are sales orders with `OrderType = Returned order`, so invoicing is done in the same place.

- The return order line must be in **Received** status for invoicing to proceed
- The posted credit note has a **negative amount** (company owes the customer)
- **Credit correction option:** using Storno (negative corrections) is available but not recommended for standard returns

> **Important:** The credit note alone does **not** complete the financial cycle. Settlement against the original invoice (and refund journal if cash was returned) must still be processed.

### 2.6 Credit Only Lifecycle (Shortcut)

For returns where no physical goods movement is needed:

```
1. Create Return Order (disposition = Credit only)
        ↓
2. Generate Invoice → Credit Note   ← lines are immediately in Received status
        ↓
3. Create Refund Payment Journal (if applicable)
        ↓
4. Settle
```

No arrival journal. No packing slip. This is the intended path for **POS completed returns**.

### 2.7 Automating Packing Slip & Invoice Posting for Completed Returns

D365 batch jobs handle packing slip and invoice posting natively — OMS never calls a service to trigger either. But the batch job's own **query/select parameters** need a way to identify which return orders are ready, and D365 return orders don't have a native channel/origin field the way sales orders do.

> This section covers POS returns that go through arrival registration and packing slip posting (standard `Credit` disposition, physical restock) — not the `Credit only` shortcut path in Section 2.6, which skips packing slip entirely.

#### The Missing Field: `ReturnOrderOriginCode`

Sales orders use `SalesOrderOriginCode` to tag the channel (POS/Ecom), and this is the standard filter used by the sales order packing slip batch job. `ReturnOrderHeadersV2` has no equivalent field.

We raised this on the D365 community forum ([thread](https://community.dynamics.com/forums/thread/details/?threadid=a9f3ec12-8674-f111-ab0f-6045bddc3c65)) and confirmed: return orders live in the same underlying `SalesTable` as sales orders, so the origin field (`SalesOriginId`) already exists — it's just not exposed on `ReturnOrderHeadersV2`. The fix is a D365 data entity extension exposing it as a new field, `ReturnOrderOriginCode`, mapped directly from `SalesTable.SalesOriginId`.

We initially considered repurposing `CustomerReturnReasonCode` (a reason-code field) as a channel tag instead, but rejected it — it's semantically wrong (a reason code isn't a channel), and it would have blocked the still-pending real reason-code mapping (`D365_RTN_REASON`).

OMS populates this field via a dedicated `D365_RTN_CHNL` IntegrationTypeMapping (`POS_RTN_CHANNEL → POS`, `ECOM_RTN_CHANNEL → Ecom`) — kept separate from the sales order `D365_SALES_CHNL` mapping even though the target values overlap, for the same reason `OMSPAY`/`OMSRFND` are separate: independent evolution of order-channel vs. return-channel mapping.

#### Batch Job: Packing Slip for POS Completed Returns

A dedicated batch job, `HotWax Post POS Returns Packing Slip`, posts packing slips for POS-completed returns using:

| Query Parameter | Value |
| :--- | :--- |
| Sales Order Return Status | `Open` |
| Sales Order Order Type | `Returned Order` |
| Sales Order Origin | `POS` |
| Sales Order Lines Return Status | `Registered` |

This mirrors the sales order POS packing slip job pattern, filtered to return orders instead.

#### Batch Job: Invoice Posting for Completed Returns

Unlike packing slip posting (split by channel), invoice posting uses a **single converged job** regardless of channel — mirroring the sales order invoice posting pattern, where by the time a line reaches `Delivered`/`Received` it no longer matters which path got it there:

| Query Parameter | Value |
| :--- | :--- |
| Sales Order Return Status | `Open`, `Delivered` |
| Sales Order Order Type | `Returned Order` |
| Sales Order Lines Return Status | `Received` |

**Why the header status includes both `Open` and `Delivered`:** a return order can have lines that reach `Received` at different times, so the header may still read `Open` while some lines have already completed — the line-level `Received` status is the real gating condition, not the header.

**Verified working end-to-end in D365.**

---

## 3. Refund Payment Journal

When cash was actually returned to the customer (via payment gateway, store cash, etc.), a Customer Payment Journal must be created in D365 to record the refund.

- Uses the same `CustomerPaymentJournalHeaders` + `CustomerPaymentJournalLines` entities (and the equivalent DMF composite entity) as payment capture
- Journal name is **`OMSRFND`**, separate from `OMSPAY` (see [implementation_plan.md](./implementation_plan.md) Section 5 for the OMS-side implementation and Section 8 Phase 5 for D365 setup)
- The amount sign is **positive** (`DebitAmount`, company pays customer) — opposite of the payment journal for sales orders (`CreditAmount`)
- `PaymentReference` is set to the D365 Return Order Number — this is how the settlement service matches the refund to the credit note
- **One journal header per return, one line per original payment method (OPP)** — if a customer paid via two different methods and both are refunded, both refunds go under the same journal header as two separate lines, each tagged with `PaymentId = orderPaymentPreferenceId` (mirrors the sales order payment sync pattern for split payments)
- Journal posting is handled by D365 batch class **`LedgerJournalMultiPost`** (multi-threaded, picks up multiple journals)

> Payment journals should only be created when actual money moves. Do not create refund journals for exchange scenarios where the credit note is simply offset against a new invoice.

### 3.1 Idempotency

To prevent resending the same refund twice, OMS reuses `OrderPaymentPreference.finAccountId` — a standard OFBiz field — as an "already synced" marker, stamped with the DMF submission's execution ID after a successful import. This mirrors how the NetSuite integration for the same OMS reuses this exact field to store its own Credit Memo ID once an OPP is settled.

A separate time-based window (`fromDate`/last-run-time, same pattern used for sales order payment sync) is also applied, but only to bound how much history gets rescanned on each run — it is not what prevents duplicates. `finAccountId` being unset is what actually determines eligibility, so a failed submission naturally stays eligible for the next run regardless of the time window.

> **Known limitation:** `finAccountId` currently stores the DMF **execution ID**, not D365's actual `JournalBatchNumber` — the DMF import is asynchronous, so the import trigger call doesn't return the batch number synchronously. Getting the real batch number would require an additional poll/check step after the import completes. Not yet built — the execution ID is sufficient for idempotency, and this gap would likely disappear anyway if refund journal creation is later moved to an OData-based approach (which returns the batch number synchronously, same as sales order payment sync already does).

---

## 4. Settlement

Settlement matches the credit note (negative) and refund journal (positive) against the original invoice (positive) so all open transactions net to zero on the customer account.

- OOTB D365 settlement (FIFO by due date) should not be used — it settles at customer account level and cannot honor order-specific matching
- The existing custom **`HotWaxAutoPostSettlementService`** must be extended to handle credit note + refund journal settlement using `SalesId == PaymReference` matching
- For exchanges, the credit note and new sales invoice settle against each other (see Section 7)

---

## 5. D365 Entities and Batch Classes — Reference

### OData Entities Available for Integration

| Entity | Purpose | Step |
| :--- | :--- | :--- |
| `ReturnOrderHeadersV2` | Create return order header (incl. `ReturnOrderOriginCode` extension) | Step 1 |
| `ReturnOrderLinesV2` | Create return order lines | Step 1 |
| `ItemArrivalJournalHeadersV2` | Create arrival journal header | Step 2 — OData (not used in OMS integration; see DMF composite entity below) |
| `ItemArrivalJournalLinesV2` | Create arrival journal lines | Step 2 — OData (not used in OMS integration; see DMF composite entity below) |
| DMF: `Item arrival journals V2` | Create header + lines atomically | Step 2 — **Used in OMS integration**; submitted as ZIP via Queue Connector (`/api/connector/enqueue/{activityId}`), journal name `OMSArr` |
| `CustomerPaymentJournalHeaders` / `Lines` | Create refund payment journal (OData) | Step 7 — not used; see DMF composite entity below |
| DMF: Customer Payment Journal composite | Create refund payment journal header + lines atomically | Step 7 — **Used in OMS integration**; journal name `OMSRFND` |

### D365 Batch Classes for Posting

| Batch Class | Purpose | Notes |
| :--- | :--- | :--- |
| `HotWaxAutoPostArrivalJournalService` | Post item arrival journals | Custom class wrapping `WMSJournalCheckPostReception`; picks up all unposted Reception journals matching `JournalNameId = OMSArr`. The OOTB `WMSJournalCheckPostReception` alone only posts one selected journal at a time |
| `SalesFormLetter_Invoice` | Post packing slip and generate credit note for return orders | Same batch class as sales order invoicing; select-parameter query determines scope (see Section 2.7) |
| `LedgerJournalMultiPost` | Post payment journals (including refund journals) | Multi-threaded, picks up multiple journals by journal name |

---

## 6. OMS Return Types → D365 Process Mapping

The OMS generates returns in two primary categories that map to different D365 process paths.

### 6.1 Completed Return (POS / Already Done in OMS)

Goods are already back (at store counter or confirmed received), refund already issued via payment gateway. D365 has no prior knowledge.

**D365 process:** Credit only path
- Create return order with `Credit only` disposition
- Skip arrival journal and packing slip (lines are immediately Received)
- D365 batch generates credit note
- OMS creates refund journal in D365 (if cash refund was issued)
- Settlement

### 6.2 In-Progress Return (Online RMA Lifecycle)

Customer initiated a return, has an RMA, goods are in transit or awaiting inspection. D365 must know about this **early** so the warehouse can receive goods against the correct return order.

**D365 process:** Physical return path
- Create return order early (at `RETURN_REQUESTED` in OMS) with `Credit` disposition
- D365 warehouse registers arrival when goods arrive
- Post packing slip after inspection
- D365 batch generates credit note
- OMS creates refund journal when refund is confirmed
- Settlement

### 6.3 Exchange

Customer returns Item A and receives Item B.

- Return order → credit note (negative)
- New sales order → invoice (positive)
- Settlement between credit note and new invoice (see Section 7 Accounting Model)
- Additional payment journal or refund journal only if there is a net difference

---

## 7. Return and Exchange Accounting Model

### 7.1 Core D365 Accounting Principles

To maintain clean accounting, settlement logic must strictly adhere to D365 transaction signs:

| Transaction | Sign | Meaning |
| :--- | :---: | :--- |
| Invoice | `+` | Customer owes money |
| Credit Note (Return Invoice) | `-` | Company owes customer |
| Payment | `-` | Customer pays money |
| Refund | `+` | Company pays money back |

Settlement must always match **positive transactions against negative transactions**. Payment journals should **only** be created when actual money moves.

The original sales order invoice and the customer's payment for that order are **already settled and closed** before any return begins. The return lifecycle creates a fresh set of open transactions.

---

### 7.2 Pure Return (No Exchange)

Customer returns an item and expects a refund or store credit. No replacement item is ordered.

**Transaction timeline:**

| Step | D365 Document | Sign | State |
| :--- | :--- | :---: | :--- |
| Original sale — invoiced | Sales Order Invoice | `+100` | Open |
| Original sale — customer pays | Customer Payment Journal | `-100` | — |
| Original sale settled | — | `0` | **Closed** |
| Return Order synced (OMS → D365 via OData) | Return Order | — | — |
| Return invoiced by D365 batch | Credit Note | `-100` | Open |

Two outcomes depending on whether cash moves:

**Option A — Store Credit:** The `-100` credit note is left open on the customer account. No refund journal is created. The customer can apply the credit to a future purchase.

**Option B — Cash Refund:** OMS creates a Refund Payment Journal (`+100`) in D365 using journal name `OMSRFND` (a dedicated journal separate from `OMSPAY` used for sales order incoming payments — see [implementation_plan.md](./implementation_plan.md) Section 5 for D365 setup details).
- Settlement: Credit Note `-100` ↔ Refund Journal `+100` = `0` — both closed.

---

### 7.3 Case 1: Same Value Exchange ($100 item for $100 item)

Customer returns a $100 item and receives a $100 item in return. No cash moves in either direction.

**Transaction timeline:**

| Step | D365 Document | Sign | State |
| :--- | :--- | :---: | :--- |
| Original sale settled | — | `0` | **Closed** |
| Return Order synced (OMS → D365) | Return Order | — | — |
| Return invoiced by D365 batch | Credit Note | `-100` | Open |
| Exchange Sales Order synced (OMS → D365 as regular sales order) | Sales Order | — | — |
| Exchange Order invoiced by D365 batch | Sales Order Invoice | `+100` | Open |

No cash moves. Settlement: Credit Note `-100` ↔ Exchange Invoice `+100` = `0` — both closed.

**OMS responsibility:** The exchange order must be synced to D365 and `D365_SLS_ORD_NUM` stored in OMS before the settlement service can run. The settlement service pairs the credit note to the exchange invoice using the return order number → exchange order number linkage maintained in OMS.

---

### 7.4 Case 2: Exchange with Higher Value ($100 item for $150 item)

Customer returns a $100 item and receives a $150 item. Customer must pay the $50 difference.

**Transaction timeline:**

| Step | D365 Document | Sign | State |
| :--- | :--- | :---: | :--- |
| Original sale settled | — | `0` | **Closed** |
| Return invoiced by D365 batch | Credit Note | `-100` | Open |
| Exchange Order invoiced by D365 batch | Sales Order Invoice | `+150` | Open |
| Customer pays $50 difference | Customer Payment Journal (OMS creates) | `-50` | — |

Settlement: Credit Note `-100` + Payment `-50` ↔ Exchange Invoice `+150` = `0` — all closed.

**OMS responsibility:** OMS creates the $50 payment journal in D365 only after the customer's payment is confirmed via the payment gateway. `PaymReference` on the journal line must be set to the exchange order's D365 sales order number so the settlement service can match it to the correct invoice.

> **Open question:** Should OMS create the payment journal at exchange order placement time or only after explicit payment gateway confirmation? This timing must be decided before implementation.

---

### 7.5 Case 3: Exchange with Lower Value ($100 item for $70 item)

Customer returns a $100 item and receives a $70 item. The company owes the customer $30.

**Transaction timeline:**

| Step | D365 Document | Sign | State |
| :--- | :--- | :---: | :--- |
| Original sale settled | — | `0` | **Closed** |
| Return invoiced by D365 batch | Credit Note | `-100` | Open |
| Exchange Order invoiced by D365 batch | Sales Order Invoice | `+70` | Open |
| Net after pairing | — | `-30` | Open — company owes customer |

Two options for the remaining $30:

| Option | D365 Action | Outcome |
| :--- | :--- | :--- |
| **Store Credit** | No refund journal — leave open | `-30` remains on customer account as open credit for a future purchase |
| **Cash Refund** | OMS creates Refund Journal (`+30`) | Settlement: Credit Note `-100` ↔ Exchange Invoice `+70` + Refund `+30` = `0` — all closed |

**OMS responsibility:** OMS must determine at exchange order creation time whether to issue a cash refund or apply store credit, and create the refund journal accordingly. This decision is driven by OMS business logic — D365 does not make this determination.

---

### 7.6 Settlement Service Design Requirements

The custom `HotWaxAutoPostSettlementService` (D365-side X++) is responsible for closing all open return and exchange transactions in the correct order-specific groupings.

#### Why OOTB Settlement Fails

D365's out-of-the-box auto-settlement operates at the **customer account level, FIFO by due date**. It has no awareness of which credit note belongs to which return, or which exchange invoice it should be matched against. In accounts with multiple open transactions, it will match incorrectly — settling a credit note against an unrelated open invoice on the same customer account.

#### Matching Strategy

The settlement service must match by **order reference, not by date**:

- `SalesId` on the credit note — the D365 return order number
- `PaymReference` on payment/refund journal lines — set by OMS to the D365 sales order number of the corresponding exchange order or the return order number for pure refunds

#### Per-Scenario Settlement Logic

| Scenario | Transactions to Settle | Match Key |
| :--- | :--- | :--- |
| Pure Return — Store Credit | Leave credit note open | n/a |
| Pure Return — Cash Refund | Credit Note `-100` ↔ Refund Journal `+100` | `returnOrderNumber` |
| Same Value Exchange | Credit Note `-100` ↔ Exchange Invoice `+100` | `returnOrderNumber` → `exchangeOrderNumber` |
| Higher Value Exchange | Credit Note `-100` + Payment `-50` ↔ Exchange Invoice `+150` | `returnOrderNumber` → `exchangeOrderNumber` |
| Lower Value — Store Credit | Credit Note `-100` ↔ Exchange Invoice `+70`, leave `-30` open | `returnOrderNumber` → `exchangeOrderNumber` |
| Lower Value — Cash Refund | Credit Note `-100` ↔ Exchange Invoice `+70` + Refund `+30` | `returnOrderNumber` → `exchangeOrderNumber` |

#### Open Questions Before Implementation

- **Exchange order linkage:** How does the settlement service know which exchange order corresponds to a given return? OMS must store the `returnId` → `exchangeOrderId` relationship and ensure `D365_SLS_ORD_NUM` is populated on the exchange order before settlement runs.
- **Trigger mechanism:** Is the settlement service triggered by an event (e.g. after credit note posting) or run as a periodic batch? Event-driven is preferable to reduce settlement lag but requires an integration point from D365 invoice posting back to the service.
- **Higher value exchange — payment journal timing:** Who confirms the customer has paid the $50 difference and triggers the OMS payment journal creation? This must be resolved before the Case 2 flow can be implemented end-to-end.

---

## 8. Manual Return Creation in D365 (Testing Reference)

When creating a return order directly in D365 — useful for manual testing or one-off scenarios outside the OMS integration flow:

1. Navigate to **Accounts receivable > Orders > All sales orders**
2. Select **New** and set `Order type = Returned order`
3. Set the `Customer account`, receiving `Site / Warehouse`, and `Return reason code`
4. For lines, use **Find sales order** to reference the original invoiced sales order line — this ensures the return is valued at the original cost price and quantity is validated against what was sold

> **Best practice:** Always use **Find sales order** when the original invoice is known. It guarantees exact reversal of the original transaction (correct discount, cost price, and quantity ceiling) and prevents over-returning.

---

## 9. Future Direction: Event-Driven Lifecycle Orchestration

The return lifecycle today is implemented as several independent pieces — a DataFeed for return order creation, separate ServiceJob sweeps for arrival journals and refund payment journals. A NetSuite integration built for the same OMS (`gorjana-maarg`) uses a different architecture worth considering here: a single idempotent orchestrator script, triggered by a DataFeed watching *three* entities (`ReturnHeader`, `ShipmentReceipt`, `ReturnItemResponse`) instead of just the return header. Each lifecycle step (RMA, item receipt, credit memo/refund) independently checks its own precondition against current state before acting, so the same script can be safely re-invoked by any of the three triggers — a refund created *after* the return already exists simply causes the next invocation to pick up where the last one left off, rather than requiring the return and its refund to be known at the same time.

This is not yet started for the D365 integration, but is being considered as the direction for consolidating return lifecycle sync once settlement and exchange order work is further along.
