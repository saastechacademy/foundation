# PK Generation — High-Water Mark Strategy

## Scope & Goal

Generate stable primary keys for `InventoryCountImportItem` so the PWA can **create exactly once** and **update thereafter**, even with pauses, resumes, and device switches. Server PK is composite:

* `inventoryCountImportId` (session)
* `importItemSeqId` (per-item sequence within the session)

We will use a **High-Water Mark** allocator.

---

## Rationale (Why High-Water Mark)

* **Offline-first & simple:** No server round-trip needed to mint IDs.
* **Collision-resistant enough:** Works well across pauses/resumes; rare cross-device races are handled by refresh + retry.
* **Gaps are acceptable:** Sequences need not be contiguous. We accept gaps by design.

---

## Core Principles

* **Immutability:** Once assigned, `(inventoryCountImportId, importItemSeqId)` never changes for that logical item.
* **Idempotency:** Sync sends **absolute** quantities; replays are safe.
* **Uniqueness per import:** Each logical item has exactly one `importItemSeqId` in its import.
* **Local natural key:** Maintain a mapping per import from a **natural key** (e.g., `productId + locationSeqId [+ other fields if needed]`) → `importItemSeqId`. Reuse it to avoid duplicate creates.

---

## Data Model (Local PWA)

* Store both:

  * `importItemSeqId` (string, e.g., zero-padded `"000123"` for display),
  * **`importItemSeqNo` (numeric)** for ordering/comparisons.
* Maintain:

  * Per-import **counter**: `nextSeq` (numeric).
  * Per-import **index**: `naturalKey → importItemSeqId`.
* Recommended index: `[inventoryCountImportId + importItemSeqNo]` for fast max/lookups.

---

## Lifecycle & Algorithm

### A) On startup / import open / resume / device switch (Inbound-first)

1. **Pull** all items for `inventoryCountImportId` (or a delta).
2. **Rebuild** local items and the naturalKey→seq index.
3. Compute **High-Water Mark**: `max(importItemSeqNo)` among local (refreshed) items; if none, `0`.
4. Set `nextSeq = highWaterMark + 1`.
   (Gaps remain; that is acceptable.)

> Rule: **Do not create new items before this inbound refresh** on a device that is resuming or switching.

### B) New logical item (during counting)

1. Build the item’s **natural key**.
2. If mapping exists → use existing `importItemSeqId` (update only).
3. If absent → **allocate** current `nextSeq`:

   * Format to `importItemSeqId` (e.g., zero-pad for display),
   * Persist item + mapping,
   * Increment `nextSeq` (atomically with creation).

### C) Updates

* For the same logical item, **never change** the PK; update quantities (absolute) and optional per-item **version/lastEventId**.

### D) Background push

* Send batches with composite PK and absolute quantities.
* Retries are safe (idempotent); server upserts.

---

## Multi-Device & Race Handling

* **Default policy:** Each device **refreshes before creating** new items in an existing import.

* **Rare race scenario:** Two devices resume simultaneously and both choose the same `max+1`.

  * If server returns a PK conflict on create:

    1. Perform **inbound refresh** on the client,
    2. Recompute high-water mark → advance `nextSeq`,
    3. **Allocate a new seq** and retry create.
       (No PK mutation is needed for already-created server rows; this handles only failed creates.)

---

## Server Contract

* **Upsert by composite PK** `(inventoryCountImportId, importItemSeqId)`: create if absent, update if present.
* Accept **absolute** quantities (idempotent).
* Optional: **version gate** per item (`incomingVersion > currentVersion`) to prevent stale overwrites.
* Return clear status on conflicts (so the client can refresh + retry allocation).

---

## Formatting & Validation

* Treat `importItemSeqId` formatting (e.g., zero-padding) as **presentation only**; comparison uses `importItemSeqNo` (numeric).
* Validate client-generated `importItemSeqId` belongs to the correct `inventoryCountImportId`.

---

## Risks & Mitigations

* **Duplicate creates:** Mitigated by naturalKey→seq index and refresh-before-create policy.
* **Gaps in sequence:** **Allowed by design**; no attempt to fill gaps.
* **Crash/resume mid-allocation:** Atomic create+increment ensures consistency; on resume, refresh resets the counter correctly.

---

## Acceptance Criteria

* New items in an import always receive a **unique** `importItemSeqId`.
* Replays of the same batch **do not** create duplicates or regress values.
* Resuming on the same or a different device after refresh **does not** collide with existing IDs.
* PKs remain **immutable** throughout the lifecycle.
* Local counter (`nextSeq`) is always ≥ (server high-water mark + 1) after refresh.

