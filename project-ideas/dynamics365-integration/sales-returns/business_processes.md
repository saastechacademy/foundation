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
3. Optional: Quarantine Order (inspection)
        ↓
4. Assign Disposition Code
        ↓
5. Post Packing Slip (commits disposition to inventory)
        ↓
6. Generate Invoice → Credit Note (financial closing)
        ↓
7. Create Refund Payment Journal (if cash refund issued)
        ↓
8. Settle (credit note + refund journal against original invoice)
```

### 2.1 Create Return Order

**Header fields:**

| Field | Description |
| :--- | :--- |
| `CustomerAccount` | Must reference an existing customer |
| `Site / Warehouse` | Receiving site and warehouse |
| `RMANumber` | Auto-assigned from AR number sequence |
| `ReturnReasonCode` | Customer's reason for return (user-defined) |
| `Deadline` | Last date item can be returned (defaults to current date + validity period from AR parameters) |

**Line creation options:**
- Manually enter item, quantity, price
- Use **Find sales order** to reference the original invoiced sales order line — this ensures the return is valued at the original cost price and quantity is validated against what was sold

> **Best practice:** Always use **Find sales order** when the original invoice is known. This ensures exact reversal of the original transaction (correct discount and cost price) and prevents over-returning.

### 2.2 Arrival at Warehouse (Arrival Journal)

Before inventory can be received, arrival must be registered via an **Item Arrival Journal**.

- Created via `ItemArrivalJournalHeadersV2` + `ItemArrivalJournalLinesV2` OData entities (confirmed available)
- Posting the arrival journal is handled by the D365 batch class **`WMSJournalCheckPostReception`**
- **Important limitation:** `WMSJournalCheckPostReception` posts **one selected journal at a time** — it is not a query-based batch that auto-picks up all unposted arrival journals. For bulk auto-posting, the class must be extended to multi-threaded behavior (like `LedgerJournalMultiPost`)
- Quarantine can be enabled during arrival if inspection is required — quarantined items cannot have a disposition code assigned until the quarantine order is completed

### 2.3 Disposition Codes

The disposition code is assigned during arrival registration and controls three things simultaneously: financial treatment, inventory fate, and whether a replacement order is auto-created.

| Disposition | Customer Credited? | Inventory | Replacement Order |
| :--- | :---: | :--- | :---: |
| **Credit only** | Yes | No physical return — no inventory movement | No |
| **Credit** | Yes | Item returned to stock | No |
| **Replace and credit** | Yes | Item returned to stock | Yes (auto-created at packing slip) |
| **Replace and scrap** | Yes | Item scrapped, loss posted to ledger | Yes (auto-created at packing slip) |
| **Scrap** | Yes | Item scrapped, loss posted to ledger | No |
| **Return to customer** | No | Item sent back to customer after inspection | No |

> **Credit only** is the most important disposition for integration: it allows skipping the arrival and packing slip steps entirely and going directly to invoice/credit note. This is the correct disposition for POS completed returns and online returns where the item will not be physically tracked back into D365 inventory.

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

---

## 3. Refund Payment Journal

When cash was actually returned to the customer (via payment gateway, store cash, etc.), a Customer Payment Journal must be created in D365 to record the refund.

- Uses the same `CustomerPaymentJournalHeaders` + `CustomerPaymentJournalLines` entities as payment capture
- The amount sign is **positive** (company pays customer) — opposite of the payment journal for sales orders
- `PaymentReference` should reference the original D365 Sales Order Number — this is how the settlement service matches the refund to the original transaction
- Journal posting is handled by D365 batch class **`LedgerJournalMultiPost`** (multi-threaded, picks up multiple journals)

> Payment journals should only be created when actual money moves. Do not create refund journals for exchange scenarios where the credit note is simply offset against a new invoice.

---

## 4. Settlement

Settlement matches the credit note (negative) and refund journal (positive) against the original invoice (positive) so all open transactions net to zero on the customer account.

- OOTB D365 settlement (FIFO by due date) should not be used — it settles at customer account level and cannot honor order-specific matching
- The existing custom **`HotWaxAutoPostSettlementService`** must be extended to handle credit note + refund journal settlement using `SalesId == PaymReference` matching
- For exchanges, the credit note and new sales invoice settle against each other (see Section 6)

---

## 5. D365 Entities and Batch Classes — Reference

### OData Entities Available for Integration

| Entity | Purpose | Step |
| :--- | :--- | :--- |
| `ReturnOrderHeadersV2` | Create return order header | Step 1 |
| `ReturnOrderLinesV2` | Create return order lines | Step 1 |
| `ItemArrivalJournalHeadersV2` | Create arrival journal header | Step 2 |
| `ItemArrivalJournalLinesV2` | Create arrival journal lines | Step 2 |
| `CustomerPaymentJournalHeaders` | Create refund payment journal header | Step 7 |
| `CustomerPaymentJournalLines` | Create refund payment journal lines | Step 7 |

### D365 Batch Classes for Posting

| Batch Class | Purpose | Notes |
| :--- | :--- | :--- |
| `WMSJournalCheckPostReception` | Post item arrival journals | Per-journal, single-threaded; extend for bulk |
| `SalesFormLetter_Invoice` | Post packing slip and generate credit note | Covers both posting steps |
| `LedgerJournalMultiPost` | Post payment journals (including refund journals) | Multi-threaded, picks up multiple journals |

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
- Settlement between credit note and new invoice (see Section 6 Accounting Model)
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

### 7.2 Case 1: Same Value Exchange ($100 item for $100 item)

No actual cash movement occurs.

- Return Order → Credit Note (`-100`)
- Exchange Order → Invoice (`+100`)
- **Settlement:** `-100` ↔ `+100` = `0`
- **No payment journal required**

### 7.3 Case 2: Exchange with Higher Value ($100 item for $150 item)

Customer pays the difference.

- Return Order → Credit Note (`-100`)
- Exchange Order → Invoice (`+150`)
- Additional Payment Journal → Customer Payment (`-50`)
- **Settlement:** `-150` (Credit + Payment) ↔ `+150` (Invoice) = `0`

### 7.4 Case 3: Exchange with Lower Value ($100 item for $70 item)

Company owes the customer the difference.

- Return Order → Credit Note (`-100`)
- Exchange Order → Invoice (`+70`)

Two options:

| Option | Mechanism | Outcome |
| :--- | :--- | :--- |
| **Store Credit** | No refund — leave open balance | `-30` sits on customer account as open credit |
| **Immediate Refund** | Refund Journal (`+30`) | Settlement: `-100` ↔ `+70` + `+30` = `0` |

### 7.5 Key Integration Guidelines

- Only initiate payment/refund journals when hard cash actually moves
- For same-value exchanges, settlement between credit note and new invoice is sufficient — no journal needed
- The OMS exchange logic (credit/refund decision) must be translated into the correct D365 journal creation decision before syncing
