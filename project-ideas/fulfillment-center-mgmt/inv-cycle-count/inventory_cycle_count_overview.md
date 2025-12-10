# Inventory Cycle Count — Why, What, and How (Combined)

## Why This Tool
- System QOH drifts from reality (shrink, mis-slots, unposted moves); finance/audit needs explainable adjustments.
- Operations need targeted recounts to reduce order rejections and protect high-risk SKUs.
- Teams need an approach that works across backends (Shopify, NetSuite, OMS) without becoming the inventory system of record.

## What It Does (High Level)
- Plans count runs, executes counting sessions, reconciles counted vs system, and produces adjustment proposals for external systems.
- Focuses on accuracy, repeatability, and auditability; never owns product master or official on-hand.

## Scope & Responsibilities
- **Planning & setup**: runs, facilities/zones/locations/item sets, config rules.
- **Execution**: sessions per user/device, scan/manual capture, recounts/partials, multi-user operations, single active session per user.
- **Reconciliation**: fetch system on-hand, compare counted vs system, flag/threshold variances.
- **Adjustment proposals**: generate/emit/track accepted/rejected/failed.
- **Audit & reporting**: who/what/where/when, full history, KPIs within the count domain.

## In Scope / Out of Scope
- **In**: planning, execution, reconciliation, proposals, audit/reporting.
- **Out**: product master management; acting as inventory SoR; orders/ATP/fulfillment; authentication/identity (relies on external identity).

## Business Stories (Why/When)
- **Annual Hard Count**: finance/audit-driven, full-store run; manager assigns areas; staff log counts (`InventoryCountImport`/`Item`); review and submit to HQ; handles “not-found with on-hand.”
- **Directed Cycle Count**: signal-driven (rejections, high variance/risk SKUs); targeted areas/items; focused recount; manager review and submit.
- Hard counts set the baseline; directed counts sustain accuracy between hard counts.

## Execution Scenarios (How People Use It)
- **Single device**: start session, scan, background sync, submit.
- **Pause/resume same device**: refresh from server, reconcile local, continue.
- **Pause/resume different device**: inbound refresh first to rebuild local state, then continue without duplicate creates.
- **Single active session per user**: one session at a time per user; all scans/syncs target that session.

## Variance Decisions & Posting
- Every variance needs reason/outcome for explainability and audit.
- When applied: `InventoryVarDcsnRsn` (decision) → `InventoryItemVariance` (line delta) → `PhysicalInventory` (batch) → `InventoryItemDetail` (ledger diff) → `InventoryItem` (book balance).
- Reporting/export: WorkEffort-scoped via `InventoryVarDcsnRsn`, join to `InventoryItemVariance` (composite key `inventoryItemId` + `physicalInventoryId`) and `PhysicalInventory` for applied variances.

## Time Zone Handling
- Planners specify count windows in facility-local time; system stores computed UTC (`startAtUtc`, `dueAtUtc`); changing facility TZ recalculates from local intent.

## Non-Functional Expectations (Store PWA)
- Offline-first; scans never lost; immediate capture with timestamp/product/device/session.
- Performance priority on scan capture; background aggregation/sync defers if it would impact capture; retries ensure eventual consistency.
- Usability: scan field always ready; optimized for fast, repetitive scanning.

## Integrations & Deployment Model
- Works with Shopify, NetSuite, HotWax OMS, and custom backends via adapters; emits adjustment proposals back.
- Designed as a pluggable engine alongside existing systems; not the inventory system of record.

## Summary
- Tool provides accurate, auditable counts: hard counts for baseline, directed counts for continuous accuracy.
- Keeps decisions explainable, sessions controlled (one active per user), and data portable across backends. 

## User Experience Stories – Inventory Cycle Count


These stories describe the activities people perform when using the cycle‑count system. 


### Planning Cycle counts for store network

The planner obtains the standard cycle‑count upload template and fills each row with the product identifier, facility identifier, count name, start date and due date. The planner specifies how each column in the file corresponds to the system’s data fields and saves that specification for reuse. The planner submits the upload for processing. The planner returns to the list of assigned counts and sees the newly created entries with their facilities and dates.


### Changing store preferences (Manager)

The manager chooses which product identifiers should appear first and which should appear second in reports and counts. The manager requires associates to record counts by scanning barcodes rather than typing quantities and specifies the expected barcode format. The manager decides whether associates will see the book quantity on hand during counts and saves that preference for the store.

### Recording counts manually in a Hard Count (Store associate)

During a hard count, the store associate identifies items that cannot be scanned. The associate searches for each item by name or identifier and selects it from the search results. The associate enters the counted quantity for each selected item and adds it to the session. The associate repeats this process for each unscannable item. When working on a directed count, the associate notes that unrequested items cannot be added manually and leaves them for the manager to review later.

### Exporting completed counts (Manager)

After closing a cycle count, the manager selects a date range and facility to generate an export. The manager requests the export and waits for the system to prepare a file. The manager reviews the export history list and notes when each export has been generated. When the file becomes available, the manager downloads it and shares it with other departments.

### Finding and sorting cycle counts (Planner or manager)

When there are many counts across multiple stores, the planner or manager searches by keyword to locate a specific count. The planner filters the list by count type, status and facility to narrow the results. The planner applies a facility filter to focus on certain locations. Each count entry shows the facility, type, created date, due date and status. When reviewing items within a count, the planner sorts the product list alphabetically or by variance to see the largest differences first.

### Managing uncounted items in a hard count (Manager)

After all sessions of a hard count are complete, the manager reviews the items that no associate counted. The manager selects these uncounted items and creates a new session so that another associate can handle them or accept zero as counted value. This ensures that every item in the count scope is physically checked before the count is closed.

### Reviewing undirected and unmatched items in a directed count (Manager)

While reviewing a directed count, the manager examines three categories of items: requested items that remain uncounted, extra items scanned by associates that were not requested, and barcodes that could not be matched to a product. The manager confirms which extra items should be included in the variance and discards the rest. For each unmatched barcode, the manager matches it to the correct product by searching and selecting the item. The manager then decides, for each variance, whether to apply it or skip it, based on the difference between the counted quantity and the book quantity.

### Final review and decision on inventory variances (Manager)

The inventory manager (or other authorised reviewer) receives a list of products with variances. The manager compares the counted quantity with the system quantity for each product.

- For each variance, the manager decides whether to apply an adjustment or skip it
- The manager records a reason for the decision, choosing from structured reasons such as ANNUAL_COUNT_ADJUSTMENT, MANAGER_OVERRIDE, PARTIAL_SCOPE_POST or CORRECTION_AFTER_REVIEW
- When the manager chooses to apply a variance, the system records this decision and creates a variance record that adjusts the inventory; when the manager chooses to skip, the decision is still recorded but no adjustment is made
- The manager repeats this process for all products and submits the final review. The system then updates inventory records accordingly and logs who made the decisions and when.



