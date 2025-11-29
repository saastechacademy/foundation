# ProductMaster Composable Specification

## 1 Introduction

The ProductMaster composable is being designed for the HotWax Commerce family of Progressive Web Apps (PWAs). Its purpose is to provide a **reusable, offline‑first cache of product master data** so that PWAs can render product details and perform identification/scanning look‑ups quickly and reliably. The composable acts as the **canonical source of product master data** in the client, abstracting away network calls and providing reactive access to product information.

### 1.1 Goals

* **Local‑first reads:** Primary reads come from a local cache to optimise speed and offline resilience.
* **Background refresh:** Cached records are refreshed in the background when stale.
* **Multi‑tenant isolation:** Data is keyed by Order Management System (OMS) tenant so that caches from different tenants do not overlap.
* **Reactive updates:** Consumers access product objects via Vue refs that update automatically when the cache refreshes.
* **Simple integration:** Provide a clear API to initialise, read by product ID or identification, prefetch batches and manage TTL.

### 1.2 Scope

The composable covers **reading and searching product master data** and **selective caching**. It supports scan lookups, batch prefetch, TTL/refresh, and handling of duplicate identifiers. 

## 2 Architecture

### 2.1 Three-Entity Cache

The cache is maintained in IndexedDB (Dexie) and consists of three tables:

1. **`products`** – canonical product documents keyed by `productId`.  
   This table stores normalised product master data (name, internalName, image, identifications, etc.) along with an `updatedAt` timestamp for TTL management.

2. **`productIdentification`** – reverse index documents keyed by an internal identifier key.  
   Each record maps an identification (e.g., GTIN, UPC, SKU) to a `productId` and is used for fast “scan → product” lookups.

3. **`productInventory`** – inventory snapshots keyed by the composite `[productId+facilityId]`.  
   This table stores **per-facility inventory** for a product, notably:
   * `availableToPromiseTotal`
   * `quantityOnHandTotal`
   * `updatedAt` (ms epoch, used for inventory TTL)

This separation allows:

* Efficient lookups by product ID (`products`)
* Efficient lookups by identification (`productIdentification`)
* Efficient retrieval of per-facility ATP/QOH (`productInventory`) without re-hitting OMS every time.

This separation allows efficient lookups by product ID and by identification key without denormalising the product document.

### 2.2 OMS Session Dependency

The composable couples directly to HotWax Commerce APIs but defers to the `useOmsSession` composable for authentication and base URL management:

* The current OMS tenant identifier (`oms`).
* Base URLs and bearer tokens for API/REST calls.
* Axios client factories via `makeApiClient()` (Bearer) and `makeRestClient()` (API Key).


### 2.3 Fetch Logic

The ProductMaster composable owns its network I/O. Fetch logic is baked into the composable, but API→domain mapping is isolated into a small internal function (`mapApiDocToProduct`) for maintainability and testing. Consumers do not need to wire a separate service.


## 3 Data Model

### 3.1 Product Fields

* `productId`
* `productName`
* `parentProductName`
* `internalName`
* `mainImageUrl`
* `goodIdentifications`

### 3.2 Normalisation

* `identifications: { type, value }[]`
* `identKeys: string[]` as `TYPE/value`
* `updatedAt: number` (ms epoch)

### 3.3 Dexie Schema

* `products`: \[oms+productId], \[oms], \[oms+updatedAt]
* `productIdents`: \[oms+identKey] (or \[oms+identKey+productId] when duplicates allowed)
* `productInventory`: `[productId+facilityId]` (compound primary key), `productId`, `facilityId`, `updatedAt`

### 3.4 Inventory Snapshot (ProductInventory)

The `productInventory` table represents a **time-bounded snapshot** of stock for a given `productId` at a given `facilityId`.

Fields:

* `productId: string`
* `facilityId: string`
* `availableToPromiseTotal: number` – current ATP for this product at this facility.
* `quantityOnHandTotal: number` – current QOH for this product at this facility.
* `updatedAt: number` – ms epoch when this snapshot was last refreshed.

This table is populated:

* From bulk item responses (e.g. session `/items` APIs), via a helper that upserts multiple entries at once.
* On demand, by calling a REST endpoint (`ProductFacilityAndInventoryItem` data document) when a product/facility pair is missing or stale.

## 4 API Surface
Product-level APIs:

* `init({ staleMs?, duplicateIdentifiers?, retentionPolicy? })`
* `getById(productId, opts?)`
* `findByIdentification(value: string)`
* `getByIdentificationFromSolr(value: string)`
* `prefetch(productIds: string[])`
* `upsertFromApi(docs: any[])`
* `clearCache()`
* `setStaleMs(ms: number)`
* `liveProduct(productId)`

Inventory-level APIs:

* `upsertInventoryFromSessionItems(items: any[])`  
  Takes a list of session/line items (containing `productId`, `facilityId`, `availableToPromiseTotal`, `quantityOnHandTotal`) and upserts them into `productInventory`.

* `getProductInventory(productId: string, facilityId: string, opts?: { forceRefresh?: boolean })`  
  Returns the inventory snapshot for a given product + facility, refreshing from OMS when missing or stale.

* `getProductQoh(productId: string, facilityId: string)`  
  Convenience wrapper that returns only `quantityOnHandTotal` for a given product + facility.

* `setInventoryStaleMs(ms: number)`  
  Configures TTL for inventory snapshots (default ~1 hour).

## 5 Behaviour

* **Local‑first:** Serve cached data if present.
* **TTL:** Refresh in background if stale.
* **Deduplication:** Coalesce in‑flight requests.
* **Offline:** Return status `'miss'` if not cached.
* **Error Handling:** Log errors and return best cached result.
  
### 5.1 Inventory Snapshots

* **Local-first:**  
  Inventory reads (`getProductInventory`, `getProductQoh`) first check the `productInventory` table.

* **Inventory TTL:**  
  Each entry in `productInventory` has its own TTL (`inventoryStaleMs`, default ~1h).  
  If a snapshot is missing or older than the TTL (or `forceRefresh` is requested), the composable:
  1. Calls the OMS `ProductFacilityAndInventoryItem` data document for that `productId` + `facilityId`.
  2. Upserts the new snapshot into IndexedDB.
  3. Returns the freshest available value.

* **Bulk seeding:**  
  When bulk item APIs (such as session `/items`) already provide `availableToPromiseTotal` and `quantityOnHandTotal`, `upsertInventoryFromSessionItems()` seeds `productInventory` without additional network calls.

## 6 Multi‑Tenancy

* All keys include `oms`.
* Cold cache on OMS switch.
* Optional purge on logout.

## 7 Reactivity

* Vue refs update when data refreshed.
* Optionally use Dexie live queries.

## 8 Performance

* Compound indexes for O(1) lookups.
* Optional LRU eviction.

## 9 Security

* Tokens not stored in Dexie.
* Cache only non‑sensitive metadata.
* Explicit purge on logout if required.

## 10 Integration

* Works with `useOmsSession`.
* Replace legacy store calls with composable methods.

## 11 Configuration

* `staleMs` (default 24h).
* `batchSize` (default 250).
* `duplicateIdentifiers` flag.
* `retentionPolicy`: `'keep' | 'purgeOnLogout'`.

## Example Usage

```ts
const session = useOmsSession();
const pm = useProductMaster();
pm.init({ oms: session.oms });

const { product, status } = pm.findByIdentification(scannedValue);
```
