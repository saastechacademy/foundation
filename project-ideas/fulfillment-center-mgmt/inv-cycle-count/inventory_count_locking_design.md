# Inventory Count Session Locking Design

## 1. Purpose & Scope
This document defines the detailed design for **InventoryCountImportLock**, an entity and associated workflow that manages online-only locking of inventory count sessions (`InventoryCountImport`). Locks ensure that only one user/device can actively count on a session at a time, while still honoring the application's **offline-first counting** principle *after* lock acquisition.

---

## 2. Design Objectives
- **Control**: Prevent multiple associates from modifying the same counting session simultaneously.
- **Auditability**: Track which user/device held a lock and when.
- **Reliability**: Ensure no lock remains permanently stuck; allow graceful recovery.
- **Compatibility**: Integrate smoothly with the session lifecycle (`CREATED → IN_PROGRESS → SUBMITTED → APPROVED`).
- **Online-only enforcement**: Lock acquisition requires connectivity.

---

## 3. Entity Definition
**Entity Name:** `InventoryCountImportLock`

| Field | Type | PK | Description |
|-------|------|----|--------------|
| `inventoryCountImportId` | id | ✅ | The session being locked. |
| `fromDate` | datetime | ✅ | When the lock was acquired. |
| `thruDate` | datetime |  | When the lock was explicitly released or expired. |
| `deviceId` | id |  | Identifier of the device holding the lock. |
| `userId` | id |  | User who acquired the lock. |
| `leaseSeconds` | numeric |  | Duration of the active lease (e.g., 300s). |
| `lastHeartbeatAt` | datetime |  | Last renewal time. |
| `overrideByUserId` | id |  | If forcibly released, who did it. |
| `overrideReason` | text-short |  | Reason for override (optional). |

**Active lock predicate:**
```
WHERE thruDate IS NULL OR thruDate > now()
AND now() < (fromDate + leaseSeconds seconds)
```

---

## 4. Session Lifecycle Integration

| Session Status            | Transition Rule | Lock Requirement |
|---------------------------|-----------------|------------------|
| `CREATED → ASSIGNED`      | Allowed only when a valid active lock exists for this session, owned by the acting user/device. | ✅ Required |
| `ASSIGNED → SUBMITTED` | Allowed only by current lock holder. Optionally auto-release lock on submit. | ✅ Required |
| `SUBMITTED → APPROVED`    | Store manager approval; lock not required. | ❌ Not required |
| `VOID`                    | Allowed from CREATED, ASSIGNED, or SUBMITTED, but not APPROVED. | ❌ Not required |

**Counting operations** (adding scan events) are allowed only while the session is `ASSIGNED` **and** an active lock is held or within grace.

---

## 5. Lock Lifecycle

### 5.1 Acquisition
- Must be online.
- Server validates: no active lock for this `inventoryCountImportId`.
- If valid → create new row with `fromDate = now()`, `leaseSeconds` (default 300), `deviceId`, and `userId`.
- If active lock exists → reject with details (who/device, since when).

### 5.2 Renewal (Heartbeat)
- Client sends periodic heartbeats (e.g., every 60–90s) to extend lock.
- Server updates `lastHeartbeatAt` and optionally recalculates expiry (`fromDate + leaseSeconds`).

### 5.3 Grace Period Handling
- Grace window (e.g., 5 min) beyond expiry allows the **last lock holder** to renew if no new lock was acquired.
- If renewal request arrives within grace and no conflicting active lock exists → extend lease.
- If another lock exists → reject renewal.

### 5.4 Release
- Triggered when:
  - Session transitions to `SUBMITTED` (auto-release optional).
  - User explicitly ends counting.
  - Lease naturally expires and grace passes.
- Server sets `thruDate = now()`.

### 5.5 Override (Break Glass)
- Store manager or admin can forcibly end a lock:
  - Server sets `thruDate = now()`, `overrideByUserId`, and optional `overrideReason`.
  - Previous lock holder loses counting privileges immediately.

---

## 6. Services & Contracts

### 6.1 `createSessionLock`
**Input:** `inventoryCountImportId`, `deviceId`, `userId`, `leaseSeconds?`
**Output:** Success with lock details (fromDate, expiry), or failure with conflicting lock info.

**Behavior:**
- Checks for active lock; if none, creates a new one.
- Enforces transactional integrity (no race between check and insert).

### 6.2 `renewSessionLock`
**Input:** `inventoryCountImportId`, `deviceId`, `userId`
**Output:** New expiry timestamp.

**Behavior:**
- Validates caller is same user/device as active lock holder.
- Updates `lastHeartbeatAt` and extends expiry.

### 6.3 `releaseSessionLock`
**Input:** `inventoryCountImportId`, `deviceId`, `userId`
**Behavior:** Marks `thruDate = now()`.

---

## 7. Client Behavior

### 7.1 Before Counting
1. Ensure online connectivity.
2. Call `createSessionLock`.
3. On success → transition session to `ASSIGNED`.
4. Enable scan UI.

### 7.2 During Counting
- Continue scanning even if temporary network loss.
- Queue heartbeats if offline; send on reconnect if within grace.
- If renewal fails (lock lost) → halt new scans; prompt user.

### 7.3 On Submission
- Call `releaseSessionLock` (if auto-release not configured).
- Transition session to `SUBMITTED`.

---

## 8. Contention Handling
- **On acquire failure**: Inform user who holds the lock and since when.
- **On renewal conflict**: Stop scanning; prompt for manager override or new session creation.
- **On override**: Lock holder’s app receives update via background sync; scanning is disabled immediately.

---

## 9. Security & Validation
- Validate user authentication before every create/renew/release.
- Trust only server-side time (`now()`).
- Enforce one active lock per session at DB level using transactional check or partial unique index.

---

## 10. Audit & Observability
- Keep full lock history (do not delete old locks).
- Track:
  - Lock durations and renewals.
  - Forced overrides.
  - Grace expiries vs explicit releases.
- Provide admin view of current active locks.

---

## 11. Example Timeline
| Time | Action | Result |
|------|---------|---------|
| 10:00 | User A acquires lock | New record created (`fromDate=10:00`, `lease=5m`) |
| 10:04 | Renewal | Heartbeat extends lease to 10:09 |
| 10:08 | Device offline | Lease still valid (grace starts 10:10) |
| 10:13 | User A reconnects | Renewal within grace → success |
| 10:20 | Manager overrides | `thruDate=10:20`, override metadata recorded |
| 10:21 | User B acquires lock | New lock row created |

---
