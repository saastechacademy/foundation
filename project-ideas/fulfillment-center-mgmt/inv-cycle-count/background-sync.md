# 1) Decide the division of responsibilities

* **App (main thread):** builds compact, idempotent **batches** from local storage (IndexedDB/Dexie) and does `fetch('/maarg/poorti/InventoryCountImport', { method:'POST', body })`.
* **Service Worker:** acts as a **reliable courier** — if the network is down (or flaky), it **queues** those POSTs and **replays** them later. No UI blocking.

> This is the simplest, robust split. Keep the queue in the SW, keep the batching logic in the app.

# 2) Pick your queue strategy

* Use **Workbox Background Sync**. It auto-queues failed POSTs and retries until success.

# 3) iOS reality check (important)

* iOS Safari has limited/spotty **Background Sync**. Plan for **manual flush triggers**:

  * On app **foreground** (`visibilitychange → visible`)
  * On **online** event
  * On SW **startup/activation**

Workbox still helps: it replays queued requests on SW start. Your app should also **poke** the SW to flush on resume.

# 4) Make sync requests idempotent

Your server should accept “same batch twice” safely:

* Include `inventoryCountImportId`, `importItemSeqId`.
* Prefer **absolute counts** per SKU (your chosen model) so the server upserts.
* Treat duplicates as **no-ops** (return 200).

# 5) Choose batching cadence

* From your local store (Dexie), create batches when:

  * **Time** since last push ≥ 15–30 s, or
  * On **resume/online**

Send **one POST per batch**. Let the SW queue/retry.

# 6) Handle auth safely

* Attach auth headers (e.g., `Authorization: Bearer <token>`).
* If a queued request later hits **401** (expired token), decide:

  * Either **drop** with a logged error (and app will resend a fresh batch),
  * Or implement a **token-refresh gate** before replay (more complex).

Keep secrets out of caches; only store what’s needed in the request.

# 7) Minimal SW with Workbox (what it looks like)

# 8) App registration & iOS-friendly flush

# 9) Error & retry thinking

* **5xx / network errors:** SW queue retries with backoff (Workbox handles it).
* **4xx (validation):** your server should tell you what failed; app can correct/resend.
* **Telemetry:** log batch IDs, attempt counts, last error — either in app (Dexie) or via small status endpoint.
