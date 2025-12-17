# Directed Cycle Count — Manager Needs for Splitting Work

## 1. Visibility of the Directed List
- A single screen that shows the **entire directed list of SKUs**:  
  - Which SKUs are already seeded.  
  - Which have been assigned to which associate.  
  - Which remain unassigned.  
- Ability to filter by:  
  - SKU, category, brand.  
  - Location (if facility locations are tracked).  
  - Assignment status (Unassigned, Assigned, Completed).  

---

## 2. Assignment Tools
When splitting work, the manager needs easy ways to **group SKUs** and assign them:  
- **Manual Selection**: Tick checkboxes next to SKUs and assign to Associate A, then repeat for Associate B.  
- **Auto-Split by Count**: “Assign 30 SKUs to Associate A and the rest to Associate B.”  
- **Auto-Split by Attribute** (if location or category data exists):  
  - Split by **facility location/aisle** (“Associate A handles Zone 1, Associate B handles Zone 2”).  
  - Split by **brand/category** (“All Nike SKUs go to Associate A”).  

---

## 3. Reassignment
- If one associate cannot finish, manager can **reassign pending SKUs** to another associate.  
- The system should:  
  - Copy/move unscanned items into another `InventoryCountImport`.  
  - Keep an audit log: “Originally assigned to User X, reassigned to User Y at hh:mm.”  

---

## 4. Progress Tracking
Manager wants real-time answers to:  
- How many SKUs each associate has scanned so far.  
- How many SKUs are still pending (per associate and overall).  
- Which SKUs are delayed or untouched.  
- Who has unexpected scans (extras not in the list).  

---

## 5. Reconciliation Support
At the end, the manager needs a clear view:  
- Per-associate results.  
- Roll-up view across all associates for the same directed count.  
- **Missing SKUs** flagged, regardless of which associate had them.  
- **Unexpected SKUs** grouped by associate for follow-up.  

---

## 6. Audit & Control
The system should maintain:  
- A log of assignments, reassignments, and completions.  
- Which SKUs were **requested but uncounted**.  
- Which SKUs were **unexpectedly scanned** and by whom.  
- Ability to **close** the work effort only when manager approves reconciliation.  

---

# What the Store Manager will Expect from Us
1. **UI Tools** to:
   - See the full list of requested SKUs.  
   - Split work between associates easily (manual and auto options).  
   - Reassign work mid-way without losing data.  

2. **System Support** to:
   - Ensure no SKU is left unassigned.  
   - Track progress per associate and overall.  
   - Handle extra scans without confusion.  
   - Roll everything back up into one reconciliation report.  

