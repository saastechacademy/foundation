### **`findOrCreateFacilityInventoryItem` Service**

#### **Purpose**

- Ensure there is **one and only one `InventoryItem`** per combination of **product** and **facility**.
- **Lookup `InventoryItemId`** directly from the `ProductFacility` table.
- Create necessary records (`ProductFacility`, `InventoryItem`) if they do not exist.
- Return the **`InventoryItemId`** for further processing.

---

#### **Responsibilities**

1. **Lookup**:
    - Search for `inventoryItemId` in the `ProductFacility` table using **`productId`** and **`facilityId`**.

2. **Create if Missing**:
    - If `ProductFacility` or `InventoryItem` does not exist:
        - **Create `InventoryItem`** if it’s missing.
          - Set the **`inventoryItemId`** in `ProductFacility` entity value.
        - **Store `ProductFacility`**.

3. **Link Records**:
    - Ensure `ProductFacility` has the correct `inventoryItemId` set after creating the `InventoryItem`.

4. **Return**:
    - Always return the `inventoryItemId` (whether found or newly created).

---


#### **Key Design Decisions**

- **Direct Lookup**:
    - Use the `inventoryItemId` in `ProductFacility` for faster and simplified lookup.

- **Single Record Rule**:
    - Ensure exactly **one `InventoryItem`** exists per product-facility combination.

- **Dynamic Creation**:
    - Automatically create `ProductFacility` and `InventoryItem` if missing.

---

#### **Benefits**

1. **Efficiency**:
    - Faster lookup by querying `ProductFacility` directly for `inventoryItemId`.

2. **Consistency**:
    - Ensures accurate and consistent inventory tracking with one `InventoryItem` per product-facility pair.

---

#### **Usage**

- **Inventory Receiving**:
    - When creating an `InventoryItemDetail`, call `findOrCreateFacilityInventoryItem` to get the `inventoryItemId`.

- **Inventory Updates**:
    - Use the `inventoryItemId` returned by this service to update ATP, QOH, or record variances.

---
