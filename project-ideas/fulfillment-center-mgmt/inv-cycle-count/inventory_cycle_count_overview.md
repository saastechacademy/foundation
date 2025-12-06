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
