# Inventory Count — Offline-First Sync & Keying Design

## 1. Purpose & Scope

This document defines the design for executing inventory counts in the PWA, with **offline-first guarantees**, **no missed scans**, and **idempotent synchronization** with the backend (Moqui framework). It captures both business requirements and technical design principles.

---

## 2. Core Principles

* **Offline-First**: Scans are captured locally first; network is optional.
* **Scan Reliability**: Each scan is atomic, persisted immediately; no scans are lost.
* **Immutability**: Once created, records (`InventoryCountImportItem`) are never mutated.
* **Idempotency**: All sync operations can be retried safely without duplication.
* **Natural Keying**: Records are uniquely identified by `(inventoryCountImportId, importItemSeqId)`.
* **High-Water Mark PK Generation**: Next `importItemSeqId` is always `max(existing) + 1`. Gaps are allowed; no re-sequencing.
* **Absolute Counts**: App pushes absolute counts per scan, not deltas.

---

## 3. Scenarios

### 3.1 Single Device, Online or Offline

* Staff scans items using the iPad + wireless scanner.
* Each scan instantly creates a local `InventoryCountImportItem` row.
* Background task aggregates counts by SKU and pushes to server.

### 3.2 Resuming a Session

* On resume, the app pulls the server state for the import.
* Local state is rebuilt using high-water mark.
* New scans continue with correct sequencing.

---

## 4. Lifecycle & Algorithms

### Inbound Refresh

* Triggered on startup, resume, or device switch.
* Pulls server state for the import.
* Rebuilds local index and high-water mark.

### Create / Update Logic

* **Create**: Each scan → new row with `importItemSeqId = max + 1`.
* **Update**: No in-place mutation; new rows only.

### Push Logic

* Background task syncs local rows to server.
* Server upserts rows by `(inventoryCountImportId, importItemSeqId)`.
* Sync retries until success.

---

## 5. Multi-Device Handling

* **Refresh-before-create** ensures local PKs don’t conflict.
* **Collisions**: If duplicate detected, retry after pulling server max.

---

## 6. Server Contract (Moqui)

* Accepts upsert by `(inventoryCountImportId, importItemSeqId)`.
* Treats each row as immutable evidence of a scan.
* Supports absolute counts, not deltas.

---

## 7. Non-Functional Requirements (NFRs)

* **No Missed Scans**: Each scan persisted locally before any background processing.
* **Offline-First**: Works without connectivity; guarantees eventual sync.
* **Performance Priority**: Scanning always takes precedence over aggregation/sync.
* **Background Sync**: Aggregation and server push are low-priority background tasks.
* **Data Integrity**: Records include timestamps, product identifiers, device/session metadata.
* **Usability**: Scan field always in focus; associates can scan rapidly without extra taps.

---

## 8. Acceptance Criteria

* PWA works offline; scans never lost.
* Scans persisted instantly on device.
* Background sync retries until server acknowledges.
* Multi-device collisions are resolved via refresh + retry.
* Reports and reconciliations use only approved sessions.

---
