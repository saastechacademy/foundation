# 🩺 Cycle Count Application Diagnostics  
This document describes how the **PWA Diagnostics Composable (`useDiagnostics`)** and the **Backend Diagnostic Service (`check#CycleCount`)** work together to provide a complete view of the Cycle Count application's health.

Both layers validate different portions of the system and together ensure that the app, backend, search index, session locking, and data documents are all configured and functioning correctly.

---

# 1) Frontend Diagnostics — `useDiagnostics`
The `useDiagnostics` composable runs **client-side checks** to ensure the local app environment is healthy and ready for offline-first operation.

## What It Checks

### **Local Database**
- Opens IndexedDB/Dexie.
- Validates tables (`products`, `productInventory`, `scanEvents`, etc.) exist.

### **Device Identification**
- Confirms persistent unique device ID in `userProfileStore`.

### **Local Product Cache**
- Checks number of cached product records.

### **Search Index Reachability (Solr)**
- Performs a minimal product query via `useProductMaster`.
- Verifies:
  - Solr is reachable
  - Query parsing
  - Network access

### **Scan Event Parsing**
- Ensures `scanEvents` Dexie table is present.

### **Worker Availability (Background Sync + Heartbeat)**
- Calls worker `aggregate()` to ensure:
  - Worker is initialized
  - Worker can handle tasks
  - Heartbeat/lock stream is responsive

### **Barcode Identification Preference**
- Ensures a valid barcode identifier is configured (UPC/EAN/GTIN/SKU).

### **Product Display Identifier**
- Confirms the chosen UI identifier exists (SKU/internalName/etc.).

### **Cycle Count Status Descriptions**
- Confirms session + run statuses are loaded from backend.

### **User Permissions**
- Ensures permission list is loaded in `userProfileStore`.

### **Product & Facility Inventory Stream**
- Verifies `productInventory` table is populated.

---

# 2) Backend Diagnostics — Service: `check#CycleCount`
The backend service validates **server-side configuration** and guarantees required metadata exists.

## What It Checks

### **Cycle Count Status Configuration**
- All cycle count statuses are present under `CYCLE_CNT_STATUS`.

### **WorkEffort Status Flow**
- Ensures transitions for run-level workflow:
  - CREATED → IN_PRGS → CMPLTD → CLOSED
  - Cancel transitions

### **Session Status Flow**
- Ensures transitions for session-level workflow:
  - CREATED → ASSIGNED → SUBMITTED → APPROVED
  - VOID paths

### **Session Lock Data Document**
- Ensures `InventoryCountImportLock` data document exists for:
  - Device locking
  - Heartbeat
  - Override

### **Product/Facility/Inventory Data Document**
- Ensures `ProductFacilityAndInventoryItem` exists for:
  - QOH loading
  - Variance view
  - Offline inventory presentation

---

# 3) Combined Health Model — App + Backend

Running both diagnostics gives visibility across **all layers**:

| Check Area | Frontend (useDiagnostics) | Backend (check#CycleCount) | Combined Benefit |
|------------|---------------------------|-----------------------------|------------------|
| **Local DB** | Dexie open test | — | Confirms offline capability |
| **Device ID** | Ensures unique device | — | Required for session locking |
| **Product Cache** | Local product count | ProductFacility DataDoc | Confirms product flow |
| **Search Index** | Solr ping | — | Verifies search availability |
| **Session Locking** | Worker heartbeat | Lock DataDoc exists | Ensures locking works end-to-end |
| **Statuses** | Status descriptions loaded | StatusItems + flows exist | Guarantees UI + server alignment |
| **Permissions** | Client permissions loaded | — | Confirms role correctness |
| **Variance Data** | Variance enums loaded | — | Ensures counts can be approved |
| **Run/Session Workflow** | — | Status flows configured | Prevents server-side workflow failures |

---

# 4) Unified Use Case: Full System Diagnosis

By combining both diagnostics, the app can detect:

- Solr reachable **but** DataDocument missing → _search OK, QOH/variance broken_.  
- Worker healthy **but** Dexie fails → _cannot aggregate or sync_.  
- UI shows statuses **but** backend flow isn't configured → _user sees options that server rejects_.  
- Product cache OK **but** backend doc missing → _inventory stream unavailable_.  

This dramatically reduces time spent debugging environment issues.

---
<img width="1470" height="723" alt="Screenshot 2025-12-14 at 7 20 36 PM" src="https://github.com/user-attachments/assets/e2edfeff-cf1a-4ec9-bb19-57e77a4d98ed" />
