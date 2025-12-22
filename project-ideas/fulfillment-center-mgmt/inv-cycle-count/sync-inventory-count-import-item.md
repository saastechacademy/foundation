# Inventory Count — Offline-First Sync & Keying Design

## 1. Purpose & Scope

This document defines the design for executing inventory counts in the PWA, with **offline-first guarantees**, **no missed scans**, and **idempotent synchronization** with the backend (Moqui framework). It captures both business requirements and technical design principles.

---

## 2. Core Principles

* **Offline-First**: Scans are captured locally first; network is optional.
* **Scan Reliability**: Each scan is atomic, persisted immediately; no scans are lost.
* **Natural Keying**: Records are uniquely identified by `uuid`.
* **Absolute Counts**: The final values pushed to the server are absolute quantities per item, not per-scan deltas. Individual scans stay local as ScanEvent entries.
---

## 3. Scenarios

### 3.1 Single Device, Online or Offline

* Staff scans items using the iPad + wireless scanner.
* Each scan instantly creates a local `ScanEvent` row.
* Background task aggregates counts by SKU and pushes to server.

### 3.2 Resuming a Session

* On resume, the app pulls server-side session items.
* Local state is rebuilt via storeInventoryCountItems(), which normalizes items, upserts them into inventoryCountRecords, sets lastSyncedAt = lastUpdatedStamp so first aggregation skips already-synced rows.
* New scans continue with correct ordering.

---

## 4. Lifecycle & Algorithms

### Inbound Refresh

* Triggered on startup, resume, or device switch.
* Pulls server state for the import.
* Rebuilds local index and high-water mark.

### Create / Update Logic

* **Create**: Every scan creates a new append-only `ScanEvent` record with timestamp, quantity, and identifier.
* **Update**: No in-place mutation; new rows only.

### Push Logic

* Background task syncs local rows to server.
* Server upser  ts rows by `(inventoryCountImportId, importItemSeqId)`.
* Sync retries until success.

---

## 5. Multi-Device Handling
* **Session-Level Locking**: Multi-device conflicts are prevented by explicit locks:
    * **getSessionLock**
    * **lockSession**
    * **releaseSession**
* Only one device can actively count the session.
* **Refresh-before-write**: When a different device resumes, local state is overwritten/updated via storeInventoryCountItems before scanning begins.
* **PK Collisions**: Avoided because:
    * ScanEvent entries use Dexie auto-PK.
    * Aggregated `inventoryCountRecords` use client-side uuid.
* **Refresh-before-create** ensures local PKs don’t conflict.

---

## 6. Server Contract (Moqui)

* Accepts upsert by `(inventoryCountImportId, importItemSeqId)`.
* Treats each row as immutable evidence of a scan.
* Supports absolute counts, not deltas.

---

## 7. Non-Functional Requirements (NFRs)

* **No Missed Scans**: Each scan persisted before any aggregation.
* **Offline-First**: Works without connectivity; guarantees eventual sync.
* **Performance Priority**: Scanning always takes precedence over aggregation/sync.
* **Background Sync**: Aggregation and server push are low-priority background tasks and won't overlap.
* **Data Integrity**: 
    * **ScanEvent** keeps raw scan history (append-only).
    * **inventoryCountRecords** include uuid, timestamps, isRequested, identifiers, facility, sync markers (lastSyncedAt, aggApplied).
* **Session Concurrency**: Device-level lock enforced through lock APIs.
* **Usability**: Scan field always in focus; associates can scan rapidly without extra taps.

---

## 8. Acceptance Criteria

* PWA works offline; scans never lost.
* Scans persisted instantly on device.
* Live queries reflect counted/uncounted/undirected/unmatched buckets instantly.
* Background sync retries until server acknowledges.
* Multi-device collisions are resolved via refresh + retry.
* Session-level lock prevents multi-device conflicts.
* Reset + rebuild on resume always yields accurate local state.
* Reports and reconciliations use only approved sessions.

---
