# Inventory Count Session Locking (Code-Aligned)

## 1. Purpose & Scope
`InventoryCountImportLock` provides a lightweight, online-only lock to avoid two devices editing the same counting session (`InventoryCountImport`) at once. After acquiring the lock, counting can continue offline; lock acquisition itself requires connectivity.

---

## 2. Entity Definition (as implemented)
**Entity:** `InventoryCountImportLock`  
**PK:** (`inventoryCountImportId`, `fromDate`)

| Field | Notes |
| --- | --- |
| `inventoryCountImportId` | Session being locked. |
| `fromDate` | When lock was created. |
| `thruDate` | Null or future = active; set to release. |
| `deviceId`, `userId` | Device/user holding the lock. |
| `leaseSeconds`, `lastHeartbeatAt` | Present but not used by current services. |
| `overrideByUserId`, `overrideReason` | Present; not set by current services. |
| `createdByUserLoginId` | Audit of creator. |

**Active lock** (current services): any row for the session with `thruDate` null or in the future (via `date-filter`).

---

## 3. Service Behavior (current)
- **Acquire**: `create#SessionLock` checks for an active lock; if none, inserts a lock row (with `fromDate = now()`, optional `deviceId/userId/thruDate`) and sets the session status to `SESSION_ASSIGNED`. If an active lock exists, it rejects with the existing `userId`.
- **Update/Release**: No dedicated release/renew service. Locks can be updated (REST `update` on `InventoryCountImportLock`) to set `thruDate` or override fields; setting `thruDate` ends the lock.
- **Renewal/heartbeat**: Not implemented; `leaseSeconds`/`lastHeartbeatAt` are unused by services.
- **Override**: Not implemented in services; can be captured by updating the lock row with `overrideByUserId`/`overrideReason`.

---

## 4. Session Lifecycle Alignment
- Lock acquisition sets session status to `SESSION_ASSIGNED`. Other session status changes do not enforce lock presence in code.
- Locks should only be issued when the session can transition to `SESSION_ASSIGNED` or is already in `SESSION_ASSIGNED`; sessions in other states should not accept a new lock.
- One active lock per session is enforced by the service check (`date-filter`); no DB unique index on device/user.

---

## 5. Client Expectations (practical)
- Must be online to acquire a lock. If acquire fails, show who holds the lock (`userId` from response).
- To release, call the lock update endpoint to set `thruDate` (or wait until `thruDate` in the past).
- No server-driven heartbeats or grace; clients should avoid assuming auto-expiry.
- If a lock is stuck, an admin/manager can update the lock to set `thruDate` or override fields to break it.

---

## 6. Gaps vs. desired design (if needed later)
- No lease/heartbeat enforcement; no grace-period renewals.
- No automatic release on submit; requires explicit `thruDate`.
- No override service; override metadata not set by current flows.
- No DB uniqueness on `deviceId`; collision handling is service-level only.
- Structured errors should be returned when a lock cannot be issued (e.g., disallowed session status or existing active lock).
