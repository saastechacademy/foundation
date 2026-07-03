# D365 Invoice Settlement & Customer Payment Integration

This document covers the full financial lifecycle from sales order creation through payment settlement in D365 Finance & Operations, including what was explored, what is implemented, the identified use cases, and which have been verified end-to-end.

---

## 1. Financial Posting Lifecycle Overview

D365 executes financial closure for a sales order across four sequential posting events. OMS owns the payment capture side; D365 owns the fulfillment and invoicing side.

```
OMS Sales Order
      │
      ▼
D365 Sales Order Created  ←── OMS pushes order (OData / DMF / Recurring Integrations)
      │
      ▼
Packing Slip Posted        ←── D365 marks order delivered; inventory deducted
      │
      ▼
Sales Invoice Posted       ←── D365 creates the AR receivable (open transaction)
      │
      ▼
Payment Journal Posted     ←── OMS pushes payment as Customer Payment Journal
      │
      ▼
Settlement                 ←── Posted payment applied to open invoice(s)
```

**Key constraint**: OMS may push the payment journal before D365 has generated the invoice. D365 handles this by creating an **on-account** open transaction on the customer that gets matched during settlement.

- **Reference**: [Accounts receivable overview](https://learn.microsoft.com/en-us/dynamics365/finance/accounts-receivable/accounts-receivable)

---

## 2. Identified Use Cases

### 2.1 Standard E-Commerce Order (Warehouse Fulfilled)

- Order is fulfilled from a D365-managed warehouse.
- D365 owns picking, packing slip, and invoice posting.

> [!NOTE]
> **TODO**: Verify that invoice posting is fully owned by D365 (not triggered by OMS).
- OMS pushes a customer payment journal after the order is settled in Shopify.
- D365 settles the posted payment against the posted invoice using the shared `SalesOrderNumber` as the matching key.

**Status**: Payment journal creation implemented. Invoice posting is a D365-side OOTB process. Automated settlement not yet implemented.

### 2.2 Store-Fulfilled (OMS Fulfillment) Order

- Physical fulfillment is executed in OMS (store pick-pack-ship).
- OMS updates D365 with the fulfilled warehouse context via the Fulfilled Order Items data package.
- D365 uses the final fulfillment context to post packing slip and invoice.
- OMS pushes customer payment journal after settlement.

**Status**: Fulfilled order items warehouse update implemented. Invoice posting and settlement remain D365-side steps (OOTB or custom batch). Not end-to-end verified.

### 2.3 POS Completed Order

- Order is placed and fulfilled at the store counter in a single transaction; payment is captured immediately via the payment gateway.
- OMS pushes the sales order to D365 (same path as other order types) when the order reaches `COMPLETED` status.
- D365-side automation handles packing slip posting and invoice generation (OOTB batch or custom X++).
- OMS pushes the customer payment journal to D365 after confirming payment settlement in Shopify.
- D365 settles the posted payment against the posted invoice using `SalesOrderNumber` as the matching key.

### 2.4 Mixed Cart Order (Store + Warehouse Lines)

- A single sales order contains lines fulfilled by both D365 (warehouse) and OMS (store).
- OMS pushes the sales order to D365 and updates warehouse context per fulfillment event — warehouse lines via the Brokered Order Items package, store-fulfilled lines via the Fulfilled Order Items package.
- D365 generates **multiple invoices** from the same order as different fulfillment events complete — one per fulfillment wave.
- OMS pushes a customer payment journal after payment is settled in Shopify.
- D365 settles the posted payment against multiple invoices over time using `SalesOrderNumber` as the matching key.

> [!NOTE]
> The identified matching key for all settlement use cases is `SalesOrderNumber`. OMS writes this into `PaymentReference` on the payment journal line. Any future D365 settlement batch or custom settlement logic should be built around that identifier.

---

## 3. Customer Payment Journal Sync

OMS syncs settled payments to D365 as Customer Payment Journals. Two approaches are implemented: **OData** (direct per-journal API calls) and **Data Package** (composite XML import via DMF). Both create unposted journal drafts using journal name `OMSPAY`, one header per sales order.

The field `PaymentReference = d365SalesOrderNumber` written on every journal line is the settlement anchor — it is what the custom `HotWaxAutoPostSettlementService` matches against invoice `SalesId`. If this mapping changes, the settlement service must be updated in sync.

For full implementation details — eligibility view, field mappings for both approaches, idempotency patterns, the DMF processing flow, payload examples, and approach comparison — see **[implementation_plan.md — Customer Payment Integration](./implementation_plan.md#customer-payment-integration)**.

---

## 4. Invoice Posting

### 4.1 D365-Side Process

Invoice posting is triggered inside D365 after the packing slip is posted. This is not directly controlled by OMS.

- **Standard OOTB option**: D365 provides a standard batch job to auto-invoice orders that have been packing-slip updated (under `Accounts receivable > Periodic tasks > Update invoices`).
- **Custom option**: If OOTB batch is insufficient for target automation requirements, custom X++ `SysOperation` logic can be implemented in the `dynamics365-integration` repository.

**Validation TODO**: Confirm in the target D365 environment whether OOTB batch jobs are sufficient to auto-invoice sales orders created via OMS. This depends on D365 AR configuration and whether orders imported through OData/DMF trigger the standard invoice eligibility filter.

### 4.2 Multi-Invoice Scenario

A single sales order can generate multiple invoices due to:
- Partial shipments (D365 posts packing slip per shipment, not per order).
- Mixed cart orders (store-fulfilled vs. warehouse-fulfilled lines post at different times).

**Settlement implication**: The payment journal may be posted before the second or third invoice exists. Settlement must be run iteratively, matching available credit against open invoices using `SalesOrderNumber` as the matching key.

---

## 5. Invoice Settlement

### 5.1 Why OOTB D365 Settlement Is Insufficient

D365 Finance provides two built-in settlement mechanisms. Both settle at the **customer account level**, not the sales order level.

**OOTB Automatic Settlement (`AR Parameters > Settlement > Automatic settlement = Yes`)**
When a payment is posted, D365 automatically scans all open invoices for that customer and settles them in **due-date order** (oldest invoice first — FIFO). It has no concept of "this payment belongs to Sales Order X."

**OOTB Periodic Settlement Batch (`AR > Periodic tasks > Settlement > Periodic settlements`)**
Same customer-level, due-date FIFO logic — just triggered on a schedule instead of at posting time.

**The Failure Scenario**
Consider customer `HW-001` with two orders:

| Order | Invoice amount | Invoice date |
| :--- | :--- | :--- |
| Order A | $100 | Aug 15 |
| Order B | $150 | Sep 1 |

OMS posts a $150 payment for Order B (`PaymentReference = SalesOrderNumber_B`). OOTB auto-settlement ignores `PaymentReference` entirely — it applies the payment to Order A's invoice first (oldest due date), leaving Order A fully settled and Order B partially open. This is the wrong outcome.

The problem is fundamental: OOTB settlement treats all invoices for a customer as a single pool and drains them FIFO. There is no hook to constrain settlement to a specific sales order.

> [!NOTE]
> Test scenario #13 (same customer, two different orders) directly validates that the custom service prevents this failure. See [section 8](#8-settlement-test-scenarios).

- **Reference**: [Automatic settlement and prioritization](https://learn.microsoft.com/en-us/dynamics365/finance/accounts-receivable/automatic-settlement-prioritization)
- **Reference**: [Configure settlement](https://learn.microsoft.com/en-us/dynamics365/finance/cash-bank-management/configure-settlement)

### 5.2 Custom Settlement Service: `HotWaxAutoPostSettlementService`

A custom X++ `SysOperation` batch class was implemented in the `dynamics365-integration` repository to perform order-specific settlement.

**Core Matching Logic**

For each customer with open transactions, the service:
1. Collects open invoices (`CustTrans` where `TransType = Invoice`), reading `SalesId` from each.
2. Collects open payments (`CustTrans` where `TransType = Payment`), reading `PaymReference` from each — the X++ `CustTrans` field name for what the OData API calls `PaymentReference`, which OMS populates with the D365 `SalesOrderNumber`.
3. Settles only pairs where `invoice.SalesId == payment.PaymReference`.

This ensures a payment for Order B is never applied to Order A's invoice, regardless of invoice age.

**X++ API**

The service uses the non-obsolete `CustTrans::settleTransaction` API introduced to prevent database blocking:

```xpp
// Build a unique settlement context per execution
SpecTransExecutionContext specTransExecutionContext =
    SpecTransExecutionContext::newFromSource(custTable);
SpecTransManager specTransManager =
    SpecTransManager::newFromSpec(specTransExecutionContext.parmSpecContext());

// Mark the matched invoice and payment for settlement
// Amount is capped to prevent over-marking in multi-payment scenarios
specTransManager.insert(invoiceCustTrans, ...);
specTransManager.insert(paymentCustTrans, min(paymentRemaining, invoiceRemaining), ...);

// Execute settlement
CustTrans::settleTransaction(
    specTransExecutionContext,
    CustTransSettleTransactionParameters::construct());
```

> The older `CustTrans::settleTransact(custTable)` method is **obsolete**. It uses the customer's `RecId` as the settlement context key, meaning concurrent settlements for the same customer share the same `SpecRecId` and cause database blocking. The replacement `settleTransaction` generates a unique `SpecRecId` per execution, eliminating contention. The service uses `settleTransaction` throughout.
>
> **Reference**: [Settle transactions by using CustTrans::settleTransaction](https://learn.microsoft.com/en-us/dynamics365/fin-ops-core/dev-itpro/financial/settletransact-obsolete)

**Multi-Payment Amount Capping (PR #25 fix)**

When multiple payment journal lines cover a single invoice (e.g. gift card + credit card), each `specTransManager.insert` for a payment line must pass `min(paymentRemaining, invoiceRemaining)` as the amount — not the raw `paymentRemaining`. Without the cap, the last payment's insert uses its full remaining amount even when the invoice balance has already been partially consumed, causing the settlement to over-mark that payment line.

**Contract Parameters (`HotWaxAutoPostSettlementContract`)**

| Parameter | Type | Required | Description |
| :--- | :--- | :--- | :--- |
| `SalesId` | String | No | Restrict settlement to a specific sales order. Useful for targeted re-runs and debugging. |
| `TransDate` | Date | No | Only settle invoices with `TransDate ≤ this date`. Omit to process all open invoices (default). Supports period-end scoping. |

**D365 Setup**

The service runs as a recurring D365 batch job. Access it from the HotWax custom menu extension → **Auto Post Settlement**. Configure the recurrence interval to match the required settlement frequency.

**Status**: Implemented. Scenarios #1–#3, #5, #7, #12, and #13 verified. See [section 8](#8-settlement-test-scenarios) for full test matrix.

### 5.3 Settlement Options — Decision Summary

| Option | Matching scope | Verdict |
| :--- | :--- | :--- |
| OOTB automatic settlement (`AR Parameters`) | Customer account, FIFO by due date | **Rejected** — settles wrong invoices when the same customer has multiple open orders |
| OOTB periodic settlement batch | Customer account, FIFO by due date | **Rejected** — same fundamental limitation |
| Custom `HotWaxAutoPostSettlementService` | Sales order (`PaymReference = SalesId`) | **Selected and implemented** |

### 5.4 POS Order Settlement Flow

POS Completed orders require a tightly automated lifecycle since payment is captured at the point of sale. Steps 1–3 use validated OOTB D365 batch jobs; step 4 uses the custom settlement service.

1. OMS pushes sales order to D365.
2. D365 auto-posts packing slip — OOTB batch (`Sales and marketing > Order shipping > Post packing slip`, filtered by `SalesOrigin = POS`). Validated in issue [#13](https://github.com/hotwax/dynamics365-integration/issues/13).
3. D365 auto-posts invoice — OOTB batch (`AR > Invoices > Batch invoicing > Invoice`, filtered by `SalesOrigin = POS`). Validated in issue [#16](https://github.com/hotwax/dynamics365-integration/issues/16).
4. OMS pushes customer payment journal (OData, unposted draft).
5. D365 posts the payment journal — OOTB AR auto-post batch. Validated.
6. `HotWaxAutoPostSettlementService` runs and settles the posted payment against the posted invoice using `PaymReference = SalesId`.

**Status**: Steps 1–3 validated. Step 6 (settlement service) implemented and verified in isolation. End-to-end POS lifecycle not yet verified as a complete chain.

---

## 6. Exploration Summary

### 6.1 Prepayment vs. Standard On-Account Payment

| Approach | `IsPrepayment` | D365 Behavior | Verdict |
| :--- | :--- | :--- | :--- |
| **Prepayment** | `Yes` | Posts to prepayment GL account; requires tax inclusivity and a dedicated prepayment profile. | **Rejected** for OData path: strict tax/profile validation fails frequently in incomplete environments. |
| **On-account (Standard)** | `No` | Posts to AR account as an open unapplied transaction. Simpler validation, settles against invoice later. | **Selected**. Works reliably via OData in tested D365 setup. |

### 6.2 OOTB Batch vs. Custom X++ for Posting & Settlement

| Step | Approach | Notes |
| :--- | :--- | :--- |
| Packing slip auto-post | OOTB ✓ | Standard D365 batch (`Sales and marketing > Post packing slip`). Validated — see issues #13, #15. |
| Invoice auto-post | OOTB ✓ | Standard D365 batch (`AR > Invoices > Batch invoicing > Invoice`). Validated — see issues #16, #17. |
| Payment journal post | OOTB ✓ | Standard D365 AR auto-post batch. Validated. |
| Settlement | Custom ✓ | OOTB rejected (FIFO by customer, ignores `PaymentReference`). Custom `HotWaxAutoPostSettlementService` implemented — see [section 5.2](#52-custom-settlement-service-hotwaxautopostsettlementservice). |

---

## 7. Key Technical Observations

- **Journal created unposted**: OData creates the payment journal in draft (`IsPosted = No`). Posting is a separate operation. If posting fails (e.g., due to missing bank account mapping), the journal stays unposted and payments appear pending in D365.
- **`PaymentReference` / `PaymReference` is the settlement anchor**: OMS writes `d365SalesOrderNumber` into `PaymentReference` (OData API field name) on every journal line. The custom settlement service (`HotWaxAutoPostSettlementService`) reads this as `PaymReference` — the X++ `CustTrans` field name for the same field — and matches on `PaymReference = SalesId`. If this field mapping is ever changed in OMS, the settlement service must be updated in sync.
- **OOTB settlement cannot be used**: D365 OOTB auto-settlement and periodic settlement both operate at customer account level using FIFO due-date ordering. They have no mechanism to honor `PaymentReference`. See [section 5.1](#51-why-ootb-d365-settlement-is-insufficient) for the full failure scenario.
- **Multiple invoices per order**: A mixed-cart or partially-fulfilled order can produce 2–4 invoices. The custom settlement service handles this iteratively — each posted payment is matched against all open invoices for the same `SalesId` until the payment is exhausted or all invoices are closed.
- **Settlement is D365-internal**: OMS has no direct role in triggering settlement. The custom batch job runs inside D365 on a schedule and operates entirely on D365-side `CustTrans` records.
- **Customer must exist before payment journal**: `AccountDisplayValue` on the journal line resolves to a D365 customer account. If customer sync has not run, the journal POST will fail with a customer-not-found validation error.

---

## 8. Settlement Test Scenarios

These scenarios cover the `HotWaxAutoPostSettlementService` custom X++ settlement job. All scenarios use `PaymentReference = SalesOrderNumber` matching (not OOTB FIFO by customer).

> [!NOTE]
> Scenario #13 is the most critical one — it directly proves that `PaymentReference`-based matching is working and OOTB FIFO is NOT being used. Always run this when validating a new environment or after any changes to the settlement service.

### 8.1 Happy Path — Amount Matches Exactly

| # | Scenario | Result |
| :--- | :--- | :--- |
| 1 | **Single invoice, single payment** — 1 packing slip → 1 invoice, 1 payment method. Both close at $0. | ✓ Verified |
| 2 | **Single invoice, multiple payments** — 1 invoice, 2 payment methods (e.g. gift card + credit card) totaling the exact invoice amount. | ✓ Verified |
| 3 | **Multiple invoices (same order), single payment** — 2 packing slips → 2 invoices, 1 payment method. Payment decrements across both invoices incrementally. | ✓ Verified |
| 4 | **Multiple invoices (same order), multiple payments** — 2 invoices, 2 payment methods. All four close at $0. | Pending |

### 8.2 Amount Mismatch

| # | Scenario | Result |
| :--- | :--- | :--- |
| 5 | **Overpayment** — payment $100, invoice $90. Invoice closes, $10 stays as open customer credit in `CustTransOpen`. Verify the $10 is visible in AR → Customer → Transactions as an open balance. | ✓ Verified — $32.56 credit remained as expected |
| 6 | **Underpayment** — payment $80, invoice $90. Payment closes, invoice stays partially open at $10 remaining. Verify the invoice shows balance $10 in AR transactions. | Pending |

### 8.3 Missing Side (No Match)

| # | Scenario | Result |
| :--- | :--- | :--- |
| 7 | **Invoice exists, no payment journal** — infolog should warn `No matching open payment found for Sales Order X, Invoice Y`. Invoice stays open. No error, batch continues. | ✓ Verified — warning logged, batch continued |
| 8 | **Payment exists, no invoice yet** — payment sits as open credit. Settlement batch finds no invoice to match against, payment is untouched. Verify no crash. | Pending |

### 8.4 Filter Parameter Tests

| # | Scenario | Result |
| :--- | :--- | :--- |
| 9 | **SalesId filter** — run with a specific `SalesId` in the contract dialog. Only that order is settled; all others are untouched. | Pending |
| 10 | **TransDate filter** — set `TransDate` to tomorrow's date. No invoices qualify, settled count = 0. Then set to today or earlier — invoices are picked up. | Pending |
| 11 | **No filters (default)** — empty `SalesId`, empty `TransDate`. All eligible orders processed in one run. | Pending |

### 8.5 Idempotency / Re-run Safety

| # | Scenario | Result |
| :--- | :--- | :--- |
| 12 | **Re-run on already-settled order** — run settlement twice on the same order. Second run finds no open `CustTransOpen` entries for that order, logs nothing, settled count stays at 0 for that order. No double settlement. | ✓ Verified |

### 8.6 Cross-Customer / Cross-Order (Critical)

| # | Scenario | Result |
| :--- | :--- | :--- |
| 13 | **Same customer, two different orders** — customer has Order A ($100) and Order B ($150), each with their own posted invoice and payment journal. Run settlement. Verify Order A's payment settles against Order A's invoice only, and Order B's payment against Order B's. Directly proves `PaymentReference = SalesId` matching is working and OOTB FIFO is NOT being used. | ✓ **Critical — Verified** |
| 14 | **Two different customers** — verify no cross-customer settlement occurs. Each customer's payment only touches their own invoices. | Pending |

### 8.7 Sequence / Timing Tests

| # | Scenario | Result |
| :--- | :--- | :--- |
| 15 | **Settlement runs before payment journal is posted** — `OMSPAY` journal exists but is not yet posted (no `CustTrans` payment entry). Settlement logs warning for that order, skips it. Next run after posting succeeds. | Pending |
| 16 | **Settlement runs before invoice is posted** — payment exists as `CustTrans` but no invoice yet. Payment sits as open credit, nothing is settled. | Pending |

### 8.8 Verification Summary

| # | Scenario | Result |
| :---: | :--- | :---: |
| 1 | Single invoice, single payment | ✓ |
| 2 | Single invoice, multiple payments | ✓ |
| 3 | Multiple invoices, single payment | ✓ |
| 4 | Multiple invoices, multiple payments | Pending |
| 5 | Overpayment — $32.56 credit remains | ✓ |
| 6 | Underpayment | Pending |
| 7 | Invoice exists, no payment — warning logged | ✓ |
| 8 | Payment exists, no invoice yet | Pending |
| 9 | SalesId filter | Pending |
| 10 | TransDate filter | Pending |
| 11 | No filters (default) | Pending |
| 12 | Re-run on already-settled order — no double settlement | ✓ |
| 13 | Same customer, two orders — each payment settles its own invoice only | ✓ **Critical** |
| 14 | Two different customers — no cross-customer settlement | Pending |
| 15 | Settlement before payment journal posted | Pending |
| 16 | Settlement before invoice posted | Pending |

---

## 9. Open Items / TODOs

| Item | Priority | Notes |
| :--- | :--- | :--- |
| Run settlement test scenarios #4, #6, #8–#11, #14–#16 | High | See section 8 for full scenario descriptions and current status. |
| Map `paymentMethodTypeId` to D365 bank account codes | Medium | Currently requires manual mapping. Should be driven by `IntegrationTypeMapping`. |
| Decide on `SalesTaxGroup` mapping | Medium | Currently sent as empty string. Expected D365 value is something like `AVATAX`. |

---

## 10. Official References

- [Accounts receivable overview](https://learn.microsoft.com/en-us/dynamics365/finance/accounts-receivable/accounts-receivable)
- [Customer payment journal](https://learn.microsoft.com/en-us/dynamics365/finance/accounts-receivable/customer-payment-journal)
- [Settlement overview](https://learn.microsoft.com/en-us/dynamics365/finance/cash-bank-management/settlement-overview)
- [Configure settlement (AR Parameters)](https://learn.microsoft.com/en-us/dynamics365/finance/cash-bank-management/configure-settlement)
- [Automatic settlement and prioritization](https://learn.microsoft.com/en-us/dynamics365/finance/accounts-receivable/automatic-settlement-prioritization)
- [Settle transactions by using CustTrans::settleTransaction](https://learn.microsoft.com/en-us/dynamics365/fin-ops-core/dev-itpro/financial/settletransact-obsolete) — why `settleTransact` is obsolete and the `SpecTransExecutionContext` replacement
- [Customer posting profiles](https://learn.microsoft.com/en-us/dynamics365/finance/accounts-receivable/customer-posting-profiles)

---

## 11. Related Docs

- [Business Processes](./business_processes.md) — Section 4 (Customer Payment Management) and Section 5 (Fulfillment & Invoicing).
- [Implementation Plan](./implementation_plan.md) — Customer Payment Integration section and POS Completed Orders Sync section.
- [D365 Return & Exchange Accounting Model](../sales-returns/d365_return_exchange_accounting_model.md) — Settlement behavior for return credit notes.
- [Connector Foundation](../foundation/connector_foundation.md) — OData client, auth, and request handling shared by the payment sync service.
