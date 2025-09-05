**Inventory Count Composable Design Summary**

This document captures all requirements, decisions, and schema designs discussed for implementing a Vue composable to manage offline-first inventory count operations in HotWax PWA apps.

---

### 🔹 Core Use Case

* Field staff scan SKUs during store inventory counting.
* Each person gets a unique **InventoryCountImport (importId)** session.
* SKU counts are captured rapidly and aggregated locally.
* A background process syncs data from device to server.
* Server-side storage is in `InventoryCountImportItem` under the `InventoryCountImport` session.

---

### 🔹 Composable Responsibilities (Moved Below for Clarity)

* Named `useInventoryCountImport()`.

* Manages session-level state (`InventoryCountImport`).

* Tracks and aggregates scanned SKU counts (`InventoryCountImportItem`).

* Persists data locally using Dexie (IndexedDB wrapper).

* Handles background sync and network batching.

* Resolves internal `productId` via the `useProductMaster()` composable using the scanned `sku`.

* Exposes API to Vue components to scan, track, and sync data.

---

### 🔹 Server-Side Model

* `InventoryCountImport`: one per counting session.
* `InventoryCountImportItem`: one per unique SKU+session.
* Data posted from PWA updates/creates items.
* `productId` is required on server.

---

### 🔹 Local Database Schema (Dexie)

The local IndexedDB schema is composed of three tables to support fast scan capture, offline storage, and reliable sync:

* `ScanEvent`: append-only log of each scan.
* `InventoryCountImportItem`: aggregated total counts per SKU per session.
* `InventoryCountImport`: metadata about the current counting session.

These tables together support high-frequency scanning, safe background updates, and delta-based syncing to the server.

#### 1. `scanEvents` (WAL / Write-Ahead Log)

| Field           | Description                                                 |
| --------------- | ----------------------------------------------------------- |
| `scanId`        | Unique ID (ULID)                                            |
| `oms`           | Tenant OMS                                                  |
| `importId`      | Count session ID                                            |
| `locationSeqId` | Shelf/zone scanned                                          |
| `sku`           | Product ID                                                  |
| `qty`           | Quantity scanned                                            |
| `createdAt`     | Timestamp of scan                                           |
| `aggApplied`    | Was scan aggregated into `InventoryCountImportItem`? (bool) |

* Append-only.
* Never deleted.
* No aggregation or scan history loss.

#### 2. `InventoryCountImportItem` (Aggregated Counts)

| Field               | Description                                          |
| ------------------- | ---------------------------------------------------- |
| `oms`               | Tenant OMS                                           |
| `importId`          | Count session ID                                     |
| `sku`               | Product ID (scanned identifier)                      |
| `productId`         | HotWax OMS internal productId                        |
| `productIdentifier` | Stores the original scanned SKU                      |
| `locationSeqId`     | Shelf/zone (optional if not needed per-item)         |
| `qty`               | Total count from all scans                           |
| `lastScanAt`        | Timestamp of latest scan for this SKU                |
| `syncedQty`         | Quantity that has been successfully synced to server |
| `lastSyncedAt`      | Timestamp of last successful sync                    |
| `lastSyncedBatchId` | ID of batch that last pushed this SKU                |

* Fast lookup by SKU.
* Used to populate count screens.
* Drives delta-based or absolute push to server.
* The `productId` is resolved using `useProductMaster()` composable during `aggregateScanEvents()` and stored for reliable server sync.

#### 3. `InventoryCountImport` (Sessions)

| Field        | Description                               |
| ------------ | ----------------------------------------- |
| `importId`   | ID for InventoryCountImport session       |
| `createdAt`  | Session start time                        |
| `status`     | Local session state (e.g., active/closed) |
| `facilityId` | Store/warehouse being counted             |

---

### 🔹 Scan Capture Flow

This flow uses two key tables:

1. Call `recordScan({ importId, sku, qty, locationSeqId })`

2. Generates a new scan event in `scanEvents`.

3. UI reads from `InventoryCountImportItem` table for display.

4. Background job aggregates un-applied scans into `InventoryCountImportItem`.

5. Scans are not blocked by aggregation.

---

### 🔹 `aggregateScanEvents()` Background Aggregation Process

* Runs continuously or on a timer.
* Reads `scanEvents` with `aggApplied: false`
* For each scan event:

    * Within a Dexie transaction:

        * If the SKU is not yet present in `InventoryCountImportItem`:

            * Use `useProductMaster().resolveSku(sku)` to retrieve the `productId`
            * Insert new `InventoryCountImportItem` with `productIdentifier = sku` and `productId = resolved productId`
        * If already present, update qty.
        * Set `aggApplied = true` on the scan event
* Uses composable-level flag `syncStatus === 'pushing'` to avoid race condition with sync.

---

### 🔹 `pushPendingItems()` Sync to Server Flow

1. Background process looks for items with `qty > syncedQty`.
2. Forms a **snapshot** of the current count (per SKU):

   ```ts
   batchBaseQty[sku] = qty;
   ```
3. Constructs batch payload:

    * Option A: `{ sku, importId, targetQty, idempotencyKey }`
    * Option B: `{ sku, importId, deltaQty, idempotencyKey }`
4. On success:

    * Updates `syncedQty = batchBaseQty[sku]`
    * Updates `lastSyncedAt`, `lastSyncedBatchId`

> ❌ **ScanEvents are never deleted — they serve as permanent WAL history.**

---

### 🔹 Composable Design & State

#### 🔸 State Attributes

* `syncStatus: 'idle' | 'pushing'`

    * Used to block sync concurrency.

* No need to pause aggregation during push.

    * Use batch snapshot to separate sync timeline.

---

### 🔹 Dexie Transactions

* Dexie supports reliable multi-table transactions.
* WAL insert + `InventoryCountImportItem` update done in transaction.
* Sync commits after successful POST.

---

### 🔹 Summary

* WAL ensures fast, durable writes for high-speed scan.
* Aggregation and sync happen in background.
* `productId` resolution via `useProductMaster()` ensures server compatibility.
* Clear snapshot boundaries ensure consistency.
* Server reflects accurate count per import session.
* Composable `useInventoryCountImport()` manages full lifecycle and batching.

