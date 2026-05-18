# Implement Return, Exchange, and Settlement Logic in D365

### Overview
This document tracks the implementation of Return and Exchange modeling and transaction settlement in Dynamics 365 (D365) integrated with OMS. The goal is to accurately map OMS return/exchange logic to D365's financial transactions to ensure clean accounting and auto-settlement, guided by D365 accounting principles.

### Core D365 Accounting Principles
To maintain clean accounting, our settlement logic strictly adheres to D365's transaction signs:
* **Invoices:** Positive amount `+` (Customer owes money)
* **Credit Notes (Return Invoices):** Negative amount `-` (Company owes customer)
* **Payments:** Negative amount `-` (Customer pays money)
* **Refunds:** Positive amount `+` (Company pays money)

Settlement must always match **positive transactions against negative transactions**. Payment journals should **only** be created when actual money moves.

### Implementation Approach

#### Case 1: Same Value Exchange (e.g., $100 item for a $100 item)
No actual cash movement occurs. The settlement strictly matches the new invoice against the return credit.
* **Return Order / RMA:** Generates a Credit Note (`-100`)
* **Exchange Order:** Generates a Sales Invoice (`+100`)
* **Settlement:** `-100` (Credit Note) ↔ `+100` (Invoice) = `0`
* **Note:** No payment journal is required. 

#### Case 2: Exchange with Higher Value (e.g., $100 item for a $150 item)
Customer pays the difference. We post a payment journal representing the extra money collected.
* **Return Order / RMA:** Generates a Credit Note (`-100`)
* **Exchange Order:** Generates a Sales Invoice (`+150`)
* **Additional Payment:** Logs a Customer Payment (`-50`)
* **Settlement:** `-150` (Credit + Payment) ↔ `+150` (Invoice) = `0`

#### Case 3: Exchange with Lower Value (e.g., $100 item for a $70 item)
The customer is owed the difference ($30). Depending on business rules, we can hold this as store credit or issue an immediate refund.
* **Return Order / RMA:** Generates a Credit Note (`-100`)
* **Exchange Order:** Generates a Sales Invoice (`+70`)
* **Resolution (Two Supported Options):**
   * **Option A (Store Credit/Open Balance):** No refund is processed. Settlement happens between the `-100` credit note and `+70` invoice. The remaining `-30` sits cleanly on the customer account as an open credit. 
   * **Option B (Immediate Refund):** A refund is paid out, creating a Refund Journal (`+30`). Settlement happens across all three documents: `-100` (Credit Note) ↔ `+70` (Invoice) + `+30` (Refund) = `0`. 

### Key Integration Guidelines
* **Minimize Payment Journals:** Only initiate payment journals when hard cash or actual transactions take place. Do not create conceptual "positive balance" payments for returns.
* **OMS to D365 Mapping:** OMS exchange-credit logic should neatly map out to D365's Credit Note, Sales Invoice, Settlement actions, and strictly necessary Payment models.
