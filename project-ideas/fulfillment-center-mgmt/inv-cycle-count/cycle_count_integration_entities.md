# **Integration Entities for Inventory Cycle Count Microservice (OFBiz / HotWax Commerce)**

This document defines all **integration entities** that participate in data exchange between the **Inventory Cycle Count microservice** and the **OFBiz / HotWax Commerce** platform. These entities act as the canonical identifiers and authoritative records for products, inventory, facilities, and reconciliation processes.

The microservice **does not own these entities**. It only references their IDs while maintaining its own operational data model. For entities owned by the microservice, see `entities-and-workflows.md`.

---

# ## **1. Product & Identification Entities**

## **1.1 Product**
**Role:** The canonical product master record.

The microservice uses `productId` extensively to:
- Identify counted items
- Aggregate variance results
- Express adjustment proposals

**Referenced by:**
- CountLine
- InventorySnapshot
- InventoryVariance

**Key OFBiz attributes:**
- `productId`
- `productTypeId`
- `internalName`
- `brandName`

The microservice may cache limited fields (e.g., `internalName`) for UI purposes but does **not** maintain product data.

---

## **1.2 GoodIdentification**
**Role:** Maps barcodes, SKUs, and external identifiers to `productId`.

Used in the microservice to resolve:
- Scanned barcode → productId
- Manual entry → productId

**Referenced by:**
- CountLine creation workflows

**Key OFBiz attributes:**
- `goodIdentificationTypeId` (e.g., GTIN, UPC, SKU)
- `idValue`
- `productId`

The microservice may maintain an in-memory or cached lookup for fast scanning experiences.

---

# ## **2. Inventory & Stock Entities**

## **2.1 InventoryItem**
**Role:** The **inventory master record** in OFBiz/HotWax.

This entity represents on-hand stock, lot/serial tracking, and location-sensitive details.

In the microservice, `InventoryItem` acts as:
- The authoritative source for **system inventory quantities**
- The reference anchor for **snapshots**, **variances**, and **adjustments**

**Key OFBiz attributes:**
- `inventoryItemId`
- `productId`
- `facilityId`
- `locationSeqId`
- `quantityOnHandTotal`
- `availableToPromiseTotal`
- `lotId`, `serialNumber` (if applicable)

The microservice does **not write** to `InventoryItem` directly.

---

# ## **3. Facility & Location Entities**

## **3.1 Facility**
**Role:** Represents stores, warehouses, and fulfillment centers.

Every cycle count session takes place in a specific facility.

**Referenced by:**
- CountRun
- CountSession
- CountLine

**Key OFBiz attributes:**
- `facilityId`
- `facilityTypeId`
- `facilityName`
- `ownerPartyId`

The microservice uses `facilityId` to scope count planning and reconciliation.

---

## **3.2 FacilityLocation**
**Role:** Represents bins, shelves, sub-locations within a facility.

Used to support **location-aware** cycle counts.

**Referenced by:**
- CountLine

**Key OFBiz attributes:**
- `facilityId`
- `locationSeqId`
- `areaId`, `aisleId`, `sectionId`, `levelId`, `positionId` (for granularity)

The microservice will store `locationSeqId` or `facilityLocationId`, depending on integration.

---

# ## **4. Party & User Entities**

## **4.1 Party / UserLogin**
**Role:** Identifies staff performing cycle counts.

**Referenced in:**
- CountSession (`userId` / `partyId`)
- Variance approvals

**Key OFBiz attributes:**
- `partyId`
- `userLoginId`
- `partyTypeId`

The microservice references identity but does **not** manage authentication.

---

# ## **5. Reconciliation Entities**

## **5.1 PhysicalInventory**
**Role:** Represents an **official physical inventory event** in OFBiz.

Often used during full-store or high-impact cycle counts.

**Typical uses:**
- Anchors ERP-level reconciliation
- Links multiple `InventoryItemVariance` records

**Referenced by the microservice as:**
- External event ID for finalized `CountRun`

**Key OFBiz attributes:**
- `physicalInventoryId`
- `physicalInventoryDate`
- `facilityId`
- `partyId` (operator)

In the microservice:
- `CountRun` may map to `physicalInventoryId` (not always required)
- Only created for approved/finalized counts, if configured

---

## **5.2 InventoryItemVariance**
**Role:** The canonical OFBiz record for **book vs physical quantity differences**.

This is the main entity created when the microservice reports an approved variance.

**It represents:**
- The exact difference between counted quantity and system quantity
- A formal record used by ERP processes for adjustments and accounting

**Referenced by:**
- AdjustmentProposal (from microservice → OFBiz)

**Key OFBiz attributes:**
- `inventoryItemVarianceId`
- `inventoryItemId`
- `physicalInventoryId`
- `varianceReasonId`
- `quantityOnHandVar`
- `availableToPromiseVar`

In the microservice:
- Variance decisions map directly to `InventoryItemVariance` records.
- Posting these records is part of the integration layer.

---

# ## **6. Summary Table**

| OFBiz / HotWax Entity | Purpose in Integration | Microservice Usage |
|------------------------|------------------------|---------------------|
| **Product** | Product master | Used on CountLine, Variance, Snapshot |
| **GoodIdentification** | Barcode/SKU mapping | Scan resolution → productId |
| **InventoryItem** | Inventory master | Basis for snapshots, variances, adjustments |
| **Facility** | Store/DC | Scopes runs, sessions, variances |
| **FacilityLocation** | Bin-level location | Location-aware counting |
| **Party / UserLogin** | User identity | CountSession ownership |
| **PhysicalInventory** | Official physical count event | Optional mapping from CountRun |
| **InventoryItemVariance** | Per-item variance record | Created from VarianceDecision |

---

# ## **7. How These Entities Fit the Microservice Boundary**

The microservice references **Product, Facility, FacilityLocation, InventoryItem**, etc., but:
- It does **not** own or maintain these records.
- It stores only **external IDs**.
- It generates reconciliation data that becomes `InventoryItemVariance` in OFBiz.

This clean boundary ensures:
- The microservice stays portable across Shopify, NetSuite, HotWax OMS, OFBiz.
- OFBiz/OMS remain the **system of record** for products & inventory.
- The microservice focuses solely on **counting, variance computation, and adjustment proposals**.
