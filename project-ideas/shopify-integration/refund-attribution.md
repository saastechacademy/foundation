# Optimized Refund Attribution Algorithm

## Overview

This algorithm solves the problem of attributing Shopify refund transactions to either **Cancellations** or **Returns**. It utilizes a "Sieve" approach—solving absolute certainties first to reduce the search space—and then uses a "Forward-Checking Backtracking" method to resolve any remaining ambiguity.

## 1. Absolute Attribution (Pre-Algorithm)

Before entering the logic engine, specific data points can "lock" a refund into a status, reducing the computational load.

1. Restock Type: If the Shopify restock type is explicitly "Cancel."  
2. Linked Transactions: If the refund has a return record linked in the GraphQl response it must be a return.  
3. Source App: Refunds created by specific apps (e.g., Loop Returns) are automatically attributed as Returns.  
4. OMS Database State:  
* If the database shows all items for an order are in **Approved** status, any refund must be a **Cancellation**.  
* If all items are in **Completed** status, any refund must be a **Return**.

## 2. Data Structure Setup

To keep the algorithm performant ($O(n \\times p)$), we track state using two primary objects:

### The Target State (remainingNeeds)

A map of products and their outstanding requirements derived from comparing Shopify unfulfilled quantities vs. OMS approved quantities.  

```json
{  
  "PROD_01": { "cancel": 1, "return": 2 },  
  "PROD_02": { "cancel": 1, "return": 1 }  
}
```

### The Refund Manifest (refunds)

An array of objects representing each payload to be solved.  

```json
[  
  { "id": "REF_1", "items": [{ "id": "PROD_01", "qty": 1 }], "status": null },  
  { "id": "REF_2", "items": [{ "id": "PROD_01", "qty": 1 }, { "id": "PROD_02", "qty": 1 }], "status": null }  
]
```

## 3. The Execution Flow

### Phase A: Pre-Processing (Impact Sorting)

Sort the refunds to prioritize "Big Rocks."

* Primary Sort: Prioritize refunds that result in the most "0"s (zeroing out a status for an item).  
* Secondary Sort: Largest total quantity.  
* Tie-breaker: Most distinct order items (highest complexity).  
* Benefit: This triggers a chain reaction (butterfly effect) where one solved refund forces the status of several others.

### Phase B: The Deduction Sieve (Iterative)

Run a loop through unassigned refunds and apply these rules until no more assignments can be made. This phase handles **forced logic**—assignments that *must* be true.

1. Rule: Capacity Overflow (Overstuffing)  
   * Check: Does this refund have a quantity of Product X that is **greater than** the total remainingNeeds for a status?  
   * Action: If Refund Qty \> Return Needed, then status **must** be Cancellation.

### Phase C: Recursive Solve with Forward Checking (Resolving Ambiguity)

If the sieve leaves unassigned refunds, it indicates **Ambiguity** (multiple valid mathematical paths). The algorithm enters "Backtracking" mode with a "Look-Ahead" guard to pick a path and verify it.

1. Select: Pick the most impactful unassigned refund (from Phase A).  
2. Hypothesize: Temporarily assign it as a status (e.g., Cancellation).  
3. Forward Check (The Optimizer):  
   * Immediately scan all *remaining* unassigned refunds.  
   * If any future refund is now "impossible" (e.g., its items cannot fit into the remaining Cancel OR Return buckets), the current hypothesis is a **bad assignment**. **Reject it immediately.**  
4. Recurse: If the Forward Check passes, repeat Phase C for the next refund.  
5. Backtrack: If a conflict is found later, try the opposite status. If both fail, step back to the previous decision and switch it.

## 4. Complexity & Performance

| Metric | Complexity | Why it works for HotWax |
| :---- | :---- | :---- |
| **Time (Avg)** | $O(n \\times p)$ | Most Shopify refunds for customers like **Steve Madden** will be solved in Phase B. |
| **Safety** | $O(1)$ | Every assignment validates that quantities don't go negative, preventing data corruption. |
| **Pruning** | High | Forward checking stops the algorithm from pursuing invalid logic paths early. |

## 5. Decision Validation

Whenever a refund assignment results in a status reaching 0 remaining actionable items, the algorithm performs a final check:

* Verification: Ensure that the remaining total refund quantity across all unassigned refunds matches the remaining actionable quantity on the item.  
* Failure Protocol: If the quantities do not match, the attribution is marked incorrect, and the algorithm initiates the backtracking sequence.