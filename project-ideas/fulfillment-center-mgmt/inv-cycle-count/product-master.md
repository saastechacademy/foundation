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

### 2.1 Two‑Entity Cache

The cache is maintained in IndexedDB (Dexie) and consists of two tables:

1. **`products`** – canonical product documents keyed by the composite key `[oms+productId]`. Secondary indexes include `[oms]` and `[oms+updatedAt]` for TTL management.
2. **`productIdents`** – reverse index documents keyed by `[oms+identKey]`. Each record maps an identification (e.g., GTIN, UPC, SKU) to a product ID. When duplicate identifiers are allowed, the schema changes to `[oms+identKey+productId]` with additional indexes to support one‑to‑many mappings.

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

## 4 API Surface

* `init({ oms, staleMs?, fetcher? })`
* `getById(productId, opts?)`
* `findByIdentification({ type, value }, opts?)`
* `prefetch(productIds: string[])`
* `upsertFromApi(docs: any[])`
* `clearTenant(oms?: string)`
* `setStaleMs(ms: number)`

## 5 Behaviour

* **Local‑first:** Serve cached data if present.
* **TTL:** Refresh in background if stale.
* **Deduplication:** Coalesce in‑flight requests.
* **Offline:** Return status `'miss'` if not cached.
* **Error Handling:** Log errors and return best cached result.

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

## 10 


## 11 Integration

* Works with `useOmsSession`.
* Replace legacy store calls with composable methods.

## 12 


## 13 Configuration

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
