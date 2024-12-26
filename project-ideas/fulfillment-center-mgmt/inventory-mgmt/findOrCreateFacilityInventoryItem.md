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
  pf.*,
  gi.Good_Identification_Type_Id,
  gi.id_value,
  fac.external_id
from product_facility pf
  JOIN (
    SELECT 
      product_id,
      id_value,
      Good_Identification_Type_Id
    FROM good_Identification
    WHERE 
      Good_Identification_Type_Id = 'SHOPIFY_PROD_SKU'
      AND (thru_date IS NULL OR thru_date > NOW())
    ORDER BY from_date DESC
      LIMIT 1
  ) gi 
  join facility fac 
    on pf.facility_id = fac.facility_id
  join facility_type ft 
    on fac.facility_type_id = ft.facility_type_id
where 
  ft.parent_type_id != 'VIRTUAL_FACILITY'
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


## Additional Notes:
* Create a view  "ProductFacilityInventoryItem" on InventoryItem and ProductFacility 
  * where ProductFacilityInventoryItem.lastInventoryCount is InventoryItem.availableToPromiseTotal, 
  * ProductFacilityInventoryItem.computedInventoryCount is =  (InventoryItem.availableToPromiseTotal - ProductFacility.minimumStock).

