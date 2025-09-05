# Business Stories Leading to Cycle Counts

This document captures the **two primary business stories** that motivate and shape the cycle count process in retail operations. These scenarios form the foundation for our cycle count project.

---

## **Story 1: Annual Hard Count**

### Context
- At the end of the fiscal year, retailers must conduct a **full physical inventory count** to close their books accurately.
- This process is typically mandated by finance and audit requirements.

### Workflow
1. The **Head of Retail** schedules a count run for each store (`WorkEffort` of type `INVENTORY_COUNT_RUN`).
2. The **Store Manager** organizes the team to perform the count within a limited time window (e.g., Dec 31–Jan 2).
3. Each staff member is assigned a physical area (sales floor, backroom, etc.) to ensure coverage and avoid double counting.
4. Staff perform a full count of their assigned area, logging counts in `InventoryCountImport` and `InventoryCountImportItem`.
5. The Store Manager reviews all sessions, confirms accuracy, and submits results to HQ.

### Outcome
- Provides a complete snapshot of physical inventory across all stores at year-end.
- Enables reconciliation with book inventory for financial reporting.
- Establishes a baseline for future cycle counts and variances.

---

## **Story 2: Directed Cycle Count**

### Context
- Outside of year-end, **directed cycle counts** are performed to validate inventory accuracy in targeted situations.
- These are often triggered by operational signals such as:
  - Frequent rejections during order fulfillment.
  - High variance in stock movements (transfers, returns).
  - Products flagged as high-value or high-risk (e.g., shrinkage-prone).

### Workflow
1. HQ or the system schedules a **Directed Count** as a `WorkEffort`.
2. The **Store Manager** assigns staff to recount specific products or areas identified as problematic.
3. Staff perform a focused count of only those items/areas, recording counts in `InventoryCountImport` and `InventoryCountImportItem`.
4. Results are reviewed by the Store Manager and submitted to HQ.

### Outcome
- Improves inventory accuracy by addressing specific problem areas.
- Provides explainability for operational issues (e.g., why orders were rejected).
- Reduces shrinkage and improves trust in inventory data without requiring a full hard count.

---

## **Summary**
- **Annual Hard Counts**: Broad, mandatory, finance-driven events ensuring end-of-year accuracy.
- **Directed Cycle Counts**: Targeted, operationally driven checks that improve accuracy continuously.

Both stories complement each other: the hard count establishes a baseline, while directed counts maintain accuracy throughout the year.

---

# Non-Functional Requirements for Cycle Count PWA (Store Associate Scanning)

### 1. **Offline-First**

* The application must function reliably without network connectivity.
* All scans must be captured and stored locally on the device until connectivity is available.
* Data persistence must guarantee zero data loss across app crashes, reloads, or device restarts.

### 2. **Scan Reliability**

* Every barcode scan must be recorded immediately and without delay.
* The system must guarantee **no missed scans**, even when scanning at maximum practical speed with a wireless barcode scanner.
* Each scan event should be atomic: once captured, it is safely persisted before any other processing occurs.

### 3. **Performance Priority**

* The highest priority is **capturing scan events**.
* Secondary operations (e.g., aggregating scans by SKU, background synchronization with server) must never degrade scanning performance.
* The scan input must always remain in focus to minimize associate interruptions.

### 4. **Background Processing**

* Tasks such as aggregating counts and syncing data to the backend (Moqui services) are **low-priority**.
* These tasks must execute in the background and defer automatically if they risk impacting scan capture.
* Background retries must ensure eventual consistency with the server once connectivity is available.

### 5. **Data Integrity**

* Scans must be persisted with timestamp, product identifier, and device/session metadata.
* Counts are based on raw scan events; aggregations are computed later for display or reporting.

### 6. **Usability**

* The scan field should always be ready to accept input (no manual refocus required).
* The interface must be optimized for **fast repetitive scanning** with minimal interaction from the associate.

---
