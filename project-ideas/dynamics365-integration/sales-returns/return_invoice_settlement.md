# D365 Return & Exchange Settlement Integration

This document covers the financial settlement lifecycle for returns and exchanges in D365 Finance & Operations — the custom settlement service, the test-data-creation scripts built to verify it, real build-time technical discoveries, and the current verification status. It mirrors [`sales-orders/invoice_settlement.md`](../sales-orders/invoice_settlement.md), which covers the equivalent lifecycle for plain sales orders.

---

## 1. Financial Posting Lifecycle Overview

A return or exchange produces up to four separate D365-side financial transactions that must be settled together, not independently:

```
Return Order Created
      │
      ▼
Arrival Journal Posted        ←── item physically received, disposition applied
      │
      ▼
Credit Note Posted            ←── negative-signed Invoice-type CustTrans (the settlement anchor)
      │
      ├──► Refund Journal Posted        ←── cash back to the customer (pure refund, or exchange shortfall)
      │
      └──► Exchange Order Invoice Posted ←── a same/higher/lower-value replacement order
                  │
                  └──► Difference Payment Journal Posted  ←── customer pays the gap (higher-value exchange only)
      │
      ▼
Settlement                     ←── credit note netted against whichever of the above legs exist
```

**Key constraint**: unlike a plain sales order (one invoice, one payment), a single return can have zero, one, or two counterpart transactions depending on the outcome (store credit, cash refund, same-value exchange, higher/lower-value exchange), and a customer can have several of these open simultaneously across different returns.

---

## 2. Why OOTB D365 Settlement Is Insufficient

Same fundamental limitation already documented for sales order settlement (see [`sales-orders/invoice_settlement.md`](../sales-orders/invoice_settlement.md) Section 5.1): both OOTB mechanisms — **Automatic settlement** (`AR Parameters > Settlement`) and the **Periodic settlement batch** — operate at the **customer account level using FIFO by due date**. Neither has any concept of "this credit note belongs to return X" or "this invoice is the exchange order for return X."

    This is worse for returns than for plain sales orders: a single customer can easily have an open credit note, an open refund journal, and an open exchange invoice all sitting on their account at once. FIFO-by-date settlement would happily net the wrong pair together — for example, applying an unrelated customer's older refund credit against a completely different return's invoice — silently producing correct-looking dollar totals with the wrong underlying transactions closed.

- **Reference:** [Settlement overview](https://learn.microsoft.com/en-us/dynamics365/finance/cash-bank-management/settlement-overview)
- **Reference:** [Automatic settlement and prioritization](https://learn.microsoft.com/en-us/dynamics365/finance/accounts-receivable/automatic-settlement-prioritization)

---

## 3. D365 Settlement Is Not Limited to Invoice-Against-Payment

Before designing around it, it's worth being explicit that D365's settlement engine is not restricted to "one invoice + one payment." Microsoft's own documentation describes settlement generically as **"the process of settling an invoice against a payment or credit note,"** and separately documents a **Replacement order / "Apply credit"** flow (Commerce call center) where an even exchange is explicitly settled by **manually settling the credit note against the replacement order's invoice** — invoice-to-invoice, no payment involved at all.

Mechanically this isn't a special case: a credit note is simply a negative-signed Invoice-type `CustTrans` record. The `CustTrans::settleTransaction` API (the same non-obsolete "mark-and-settle" API `HotWaxAutoPostSettlementService` already uses via `SpecTransExecutionContext`/`SpecTransManager`) marks arbitrary `CustTrans` records for settlement regardless of type — invoice, credit note, or payment — and nets them. So "settle a return's credit note against a brand-new exchange order's invoice" requires no new D365-side API or capability; it's the exact same primitive already in use, applied to a different pair of transactions.

- **Reference:** [Settle a partial customer payment that has discounts on credit notes](https://learn.microsoft.com/en-us/dynamics365/finance/accounts-receivable/settle-partial-payment-discounts-credit-notes) — includes a worked "Settle a credit note with an invoice" example
- **Reference:** [Refund payment processing in call centers — Replacement orders](https://learn.microsoft.com/en-us/dynamics365/commerce/call-center-refund-payments#replacement-orders)

---

## 4. Custom Settlement Service: `HotWaxAutoPostReturnSettlementService`

**Status: ✅ Implemented.** PR [hotwax/dynamics365-integration#36](https://github.com/hotwax/dynamics365-integration/pull/36) (closes issue [#35](https://github.com/hotwax/dynamics365-integration/issues/35)).

### 4.1 Why the sales-order settlement service can't be reused as-is

`HotWaxAutoPostSettlementService` (Section 5.2 of [`sales-orders/invoice_settlement.md`](../sales-orders/invoice_settlement.md)) is hardcoded around assumptions that don't hold for returns:

- It only collects invoices where `AmountCur > 0` — a return's credit note is negative and would never be picked up.
- Its only matching path is `payment.PaymReference == invoice.CustInvoiceJour.SalesId` — there is no path for matching one invoice-type `CustTrans` against another invoice-type `CustTrans` (needed for the exchange scenarios), since `PaymReference` only exists on payment/refund **journal lines**, never on an invoice or credit note itself.

So this is a **new, separate service**, structurally modeled on `HotWaxAutoPostSettlementService` — same `SpecTransExecutionContext`/`SpecTransManager`/`CustTrans::settleTransaction` pattern — rather than bolting negative-amount and invoice-to-invoice branches onto the sales-order-specific service.

### 4.2 The missing link: finding an exchange order's invoice

`PaymReference` doesn't help find the **exchange order's invoice** for the "same value exchange" case, where no journal is created at all. Something has to carry the return↔exchange relationship onto the exchange order itself.

The fix reuses the pattern already implemented for a structurally identical problem — linking a *return* order back to its *original* sales order — one hop later: when OMS syncs the **exchange order** to D365, it stamps `CustomerRequisitionNumber = d365ReturnOrderNumber` (the linked return's D365 SalesId).

> [!IMPORTANT]
> **Field name changes between tables.** The value survives header → invoice, but the *field name* does not: `SalesTable.PurchOrderFormNum` becomes `CustInvoiceJour.PurchaseOrder` after posting (displayName "Requisition", confirmed via Microsoft's CDM schema for `Transaction/CustInvoiceJour`). All settlement-service joins use `CustInvoiceJour.PurchaseOrder`; the OMS-side sync code (setting `CustomerRequisitionNumber`/`PurchOrderFormNum` on `SalesTable`) uses the `SalesTable` field name.
>
> **The field is also a frozen snapshot, not a live reference.** `CustInvoiceJour.PurchaseOrder` is copied from `SalesTable.PurchOrderFormNum` *at the moment of invoicing* and never updates afterward. Editing `PurchOrderFormNum` on an already-invoiced exchange order has **no effect** on the settlement match — the posted invoice still carries whatever value existed when it was posted. Hit this directly during verification: an exchange order was invoiced with a stale return order number, and editing the field after the fact did not fix the settlement lookup. The correct fix is always a fresh exchange order with the right `CustomerRequisitionNumber` from the start, matching how a real posted invoice can't be retroactively corrected in production either.

`CustomerRequisitionNumber`/`PurchOrderFormNum`/`PurchaseOrder` is a real, native D365 field (customer's PO number) being repurposed for this cross-reference — a deliberate field-reuse tradeoff, not a purpose-built field. See Section 8 for the associated risk.

### 4.3 Matching strategy — discover, then mark

For each return with an open credit note, the service runs a **discovery pass** (read-only) before marking anything, then a **marking pass** that hands D365's `SpecTransManager` only amounts already known to sum to exactly zero:

| # | Lookup | Match Key | Covers |
| :--- | :--- | :--- | :--- |
| 1 | Open credit note | `CustInvoiceJour.SalesId = <return's D365 order number>`, `AmountCur < 0` | Every scenario — this is the anchor |
| 2 | Refund payment journal(s) | `PaymReference = SalesId` from step 1 | Pure cash refund **and** the lower-value exchange's leftover cash-back remainder |
| 3 | Exchange order invoice | `CustInvoiceJour.PurchaseOrder = SalesId` from step 1, `AmountCur > 0` | Same-value, higher-value, and lower-value exchange (whenever an exchange order exists) |
| 4 | Difference payment journal | `PaymReference = SalesId` from step 3 (the exchange order's own SalesId) | Higher-value exchange only — the customer's payment for the price difference, riding the existing `OMSPAY` payment flow unmodified |

**Why a discovery pass, not mark-as-you-go.** Every group of transactions handed to `SpecTransManager` in one `settleTransaction` call must sum to exactly zero — that's the actual contract of the API, not D365 being lenient about an imbalance. The service totals up what's genuinely available (refund + exchange invoice) *before* deciding how much of the credit note to mark, then caps the **credit note itself** down to `min(creditNoteOpen, totalAvailable)` when the available counterpart is smaller.

**Higher-value exchange needs an extra safeguard.** Marking a partial settlement (credit note fully closed against only part of a larger exchange invoice) *before* the difference payment exists would close the credit note — the service's only anchor, since step 1 only ever looks at *open* credit notes — while leaving the exchange invoice's real remaining gap with nothing that could ever find it again on a later run. Since a higher-value exchange always requires the customer to pay the difference, the service **waits**: if the exchange invoice found is larger than the credit note, it checks whether the difference payment is *already* present covering the full gap. If not, it skips that return entirely for this run — nothing is marked, nothing is orphaned.

Whatever isn't found at a given step is simply not marked — no special-casing needed:

| Scenario | Transactions Marked | Steps Used |
| :--- | :--- | :--- |
| Pure Return — Store Credit | Credit note only (left open) | 1 |
| Pure Return — Cash Refund | Credit note + Refund journal | 1, 2 |
| Same Value Exchange | Credit note + Exchange invoice | 1, 3 |
| Higher Value Exchange | Credit note + Exchange invoice + Difference payment | 1, 3, 4 |
| Lower Value — Store Credit | Credit note + Exchange invoice (remainder left open) | 1, 3 |
| Lower Value — Cash Refund | Credit note + Exchange invoice + Refund journal | 1, 2, 3 |

### 4.4 Trigger mechanism

A periodic batch, consistent with every existing D365-side job in this integration (`HotWaxAutoPostSettlementService`, `HotWaxAutoPostArrivalJournalService`) — no new D365-to-OMS or OMS-to-D365 callback path required.

### 4.5 `HotWaxAutoPostSettlementService` must exclude exchange orders

Since an exchange order is a plain Sales Order in D365 with no marker other than `CustInvoiceJour.PurchaseOrder` being populated, the existing, already-in-production `HotWaxAutoPostSettlementService` (sales-order settlement) would independently pick up an exchange order's invoice and any payment matching `PaymReference == SalesId` — including the higher-value exchange's difference payment, which intentionally reuses that exact key so it can ride the existing `OMSPAY` flow unmodified. Without an exclusion, two independent batch jobs could race to settle the same invoice/payment pair.

**Fix**: `HotWaxAutoPostSettlementService`'s invoice-eligibility join now also requires `custInvoiceJour.PurchaseOrder == ""` (blank), so it only ever processes genuine sales orders.

> [!CAUTION]
> **Field-reuse risk, deliberately deferred.** If this environment ever has *legitimate, non-exchange* sales orders that populate `PurchaseOrder`/`PurchOrderFormNum`/`CustomerRequisitionNumber` for its native purpose, this exclusion would wrongly skip them from `HotWaxAutoPostSettlementService` too — and `HotWaxAutoPostReturnSettlementService` wouldn't pick them up either. Treated as a separate concern to resolve later rather than a blocker.

### 4.6 Contract parameters (`HotWaxAutoPostReturnSettlementContract`)

| Parameter | Type | Required | Description |
| :--- | :--- | :--- | :--- |
| `SalesId` | String | No | Restrict settlement to a specific return order. |
| `FromDate` | Date | No | Only settle credit notes with `TransDate ≥ this date`. Omit to process all open credit notes. |

**D365 Setup**: runs as a recurring D365 batch job — **HotWax Automated Return & Exchange Settlement**, under **System Administration → Periodic**.

---

## 5. Test Data Creation Scripts

Verifying this service against real D365 data required real return orders, exchange orders, payments, and refunds — clicking through the D365 UI for every scenario was too slow to iterate on. A set of test-utility X++ scripts were built in the `dynamics365-integration` repo (branch `feature/return-exchange-settlement-service`) specifically to make this fast and repeatable. All live under **System Administration → Periodic**, alongside the real automated jobs.

| Script | Purpose |
| :--- | :--- |
| `HotWaxTestSalesOrdersPos` | Creates and fully invoices a POS-origin sales order (`SalesTable`/`SalesLine`, packing slip, invoice) in one action. An optional `CustomerRequisitionNumber` parameter doubles it as the exchange-order creator — pass the return order's SalesId to create it as that return's exchange order. |
| `HotWaxTestReturnOrdersPos` | Creates a POS-origin return order referencing an already-invoiced sales order (the standard "Find sales order" mechanism), sets `Credit` disposition, then creates and posts its arrival journal (`WMSJournalTable`/`WMSJournalTrans`, Reception type) so the return line moves from "Expected" to "Registered", then posts packing slip and invoice (the credit note) — the full return lifecycle in one action. |
| `HotWaxTestPaymentJournalService` | Creates and posts a real Customer Payment journal (`JournalName = "OMSPAY"`) via `LedgerJournalTable`/`LedgerJournalTrans` + `LedgerJournalCheckPost`. Used for a same-value exchange's not needed, but for the higher-value exchange's difference payment (point `SalesId` at the exchange order's own SalesId). |
| `HotWaxTestRefundPaymentJournalService` | Mirrors the payment script but posts a **debit** line (`AmountCurDebit`, `JournalName = "OMSRFND"`) instead of a credit line — a refund increases what the customer is owed (positive `CustTrans.AmountCur`), the opposite of a payment. Used for pure refunds and a lower-value exchange's cash-back remainder. |

Each of these evolved through real build-and-test cycles against a live D365 dev environment — see Section 6 for the specific technical discoveries made along the way.

---

## 6. Key Technical Observations

Discoveries made only through real X++ build-and-test cycles against a live D365 environment, not documented anywhere prior to this integration effort:

- **`LedgerJournalTable.NumberSequenceTable`, not `VoucherSeries`.** `VoucherSeries` is only the OData/UI display name for this field — the actual AOT field is `NumberSequenceTable` (an `int64` RecId). Generating a journal line's `Voucher` requires `NumberSeq::newGetVoucherFromId(ledgerJournalTable.NumberSequenceTable).voucher()`, not `newGetVoucherFromCode` (which expects a string code, not a RecId) — a journal line's `Voucher` is not auto-assigned on insert; omitting this causes posting/validation to fail with "Voucher not specified".
- **`LedgerJournalTrans.TransactionType` is required for Settle Transactions visibility, not just posting.** Without it set to `LedgerTransType::Payment`, the resulting `CustTrans` posts successfully and shows in the general Customer Transactions list, but is silently excluded from the "Settle open transactions" UI form.
- **`Approved` and `Approver` are both required for Settle Transactions visibility** — `Approved` alone was confirmed insufficient. `Approver`'s underlying EDT (`HcmApprover`) and the `HcmWorker` class are both unresolvable at compile time in this project (the HCM module isn't referenced), including when writing a runtime-resolved value directly to the field — the compiler still resolves the field's declared type at the assignment site regardless of the RHS. Worked around via fully dynamic field access on both the read side (`tableName2Id`/`fieldName2Id`/`DictTable` to look up a worker by `PersonnelNumber`) and the write side (`ledgerJournalTrans.(fieldName2Id(tableNum(LedgerJournalTrans), "Approver")) = ...`), which bypasses compile-time type resolution entirely.
- **A journal created outside the interactive UI needs `parmAutoBlock(true)` to post.** A journal created directly via OData/Postman (or our own X++) fails the standard D365 "Post journal" batch action with "Journal X is not locked by system" — a real session normally acquires this lock implicitly. `WMSJournalCheckPostReception`/`LedgerJournalCheckPost` both need this flag set explicitly when the journal wasn't created interactively.
- **The return line's own `InventTransId`, not `InventTransIdReturn`, links the arrival journal.** `SalesLine.InventTransIdReturn` points back to the *original* invoice's transaction; the arrival journal line needs the *return* line's own, freshly-generated `InventTransId`. Confirmed by comparing a real return order line's `ReturnInventoryLotId` (matches the arrival journal's `ReferenceInventoryLotId`) against its `ReturningInventoryLotId` (does not match) via OData.
- **`initFromSalesTable()` called after `initFromCustInvoiceTrans()` resets `SalesPrice` back to 0.** When creating a return line via the "Find sales order" mechanism, `initFromCustInvoiceTrans()` correctly pulls the price from the original invoice line, but the immediately-following `initFromSalesTable()` re-initializes the line from the header's context and clobbers it. Fixed by re-asserting `SalesPrice` explicitly after both init calls run.

---

## 7. Settlement Test Scenarios

All scenarios run against `HotWaxAutoPostReturnSettlementService` using the test-data-creation scripts in Section 5, mirroring the checklist in PR [#36](https://github.com/hotwax/dynamics365-integration/pull/36).

| # | Scenario | Result |
| :--- | :--- | :---: |
| 1 | **Same-value exchange** — credit note + exchange invoice net to 0 | ✓ Verified |
| 2 | **Higher-value exchange** — credit note + exchange invoice + difference payment net to 0 (tested: credit note -150, exchange invoice +200, diff payment -50) | ✓ Verified |
| 3 | **Lower-value exchange, cash refund** — credit note + exchange invoice + refund journal net to 0 | ✓ Verified |
| 4 | **Lower-value exchange, store credit** — credit note + exchange invoice settle, correct remainder stays open | Pending |
| 5 | **Pure refund** — credit note + refund journal net to 0 | ✓ Verified |
| 6 | **Pure store credit** — nothing marked, credit note stays open (logged as expected, not a warning) | Pending |
| 7 | **Re-run on an already-settled return** — no double settlement | ✓ Verified |
| 8 | **`SalesId` filter param** behaves as expected | ✓ Verified |
| 9 | **`FromDate` filter param** behaves as expected | ✓ Verified |

**Scenario #2 note**: first attempt reported "0 processed" because the exchange order's invoice had already been posted with `CustomerRequisitionNumber` pointing at a stale/earlier return order number — see the frozen-snapshot caution in Section 4.2. Fixed by creating a fresh exchange order with the correct return order SalesId from the start.

---

## 8. Open Items / TODOs

| Item | Priority | Notes |
| :--- | :--- | :--- |
| Verify scenario #4 (lower-value exchange, store credit) | High | See Section 7. |
| Verify scenario #6 (pure store credit) | High | See Section 7. |
| Field-reuse risk on `CustomerRequisitionNumber`/`PurchaseOrder` | Medium | See the caution callout in Section 4.5 — deferred, not a blocker today. |
| `Approver` hardcoded to personnel number `"000020"` in the test payment/refund scripts | Low | A known simplification for settlement-testing-only utilities, not resolved to whoever runs the script. Acceptable since these scripts don't represent real financial data. |

---

## 9. Official References

- [Settlement overview](https://learn.microsoft.com/en-us/dynamics365/finance/cash-bank-management/settlement-overview)
- [Automatic settlement and prioritization](https://learn.microsoft.com/en-us/dynamics365/finance/accounts-receivable/automatic-settlement-prioritization)
- [Settle a partial customer payment that has discounts on credit notes](https://learn.microsoft.com/en-us/dynamics365/finance/accounts-receivable/settle-partial-payment-discounts-credit-notes)
- [Refund payment processing in call centers — Replacement orders](https://learn.microsoft.com/en-us/dynamics365/commerce/call-center-refund-payments#replacement-orders)
- [Settle transactions by using CustTrans::settleTransaction](https://learn.microsoft.com/en-us/dynamics365/fin-ops-core/dev-itpro/financial/settletransact-obsolete)

---

## 10. Related Docs

- [Implementation Plan](./implementation_plan.md) — Section 8 for the return sync lifecycle this settlement service sits downstream of.
- [Business Processes](./business_processes.md) — Section 7 for the per-scenario return/exchange business logic this service implements.
- [Sales Orders — Invoice Settlement](../sales-orders/invoice_settlement.md) — the equivalent settlement doc for plain sales orders, which this document mirrors.
