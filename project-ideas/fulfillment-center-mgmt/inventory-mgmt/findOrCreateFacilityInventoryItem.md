### **`findOrCreateFacilityInventoryItem` Service**

#### **Purpose**

- Ensure there is **one and only one `InventoryItem`** per combination of **product** and **facility**.
- **Lookup `InventoryItemId`** directly from the `ProductFacility` table.
- Create necessary records (`ProductFacility`, `InventoryItem`) if they do not exist.
- Return the **`InventoryItemId`** for further processing.

---
IN Parameters 
```json
{
  "facilityId": "Facility123",
  "externalFacilityId": "Facility123",
  "productId": "Product456",
  "productIdentType": "SHOPIFY_PROD_SKU",
  "productIdentValue": "00001",
}
```

OUT Parameters

```json
{
  "productId": "P1001",
  "facilityId": "WarehouseA",
  "inventoryItemId": "INV12345"
}
 ```


#### **Responsibilities**

1. **Lookup**:
    - Search for `inventoryItemId` in the `ProductFacility` table using **`productId`** and **`facilityId`**.
    - if `productId` and `facilityId` are null, use `externalFacilityId` and `productIdentType` and `productIdentValue`
    - 
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

Lookup ProductFacility 

```sql
select
pf.inventoryItemId,
gi.Good_Identification_Type_Id,
gi.product_id,
gi.id_value,
fac.external_id,
fac.facility_id

from product_facility pf
join good_Identification gi
on pf.product_id = gi.product_id
and gi.Good_Identification_Type_Id = 'SHOPIFY_PROD_SKU'
join facility fac
on pf.facility_id = fac.facility_id
```



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
