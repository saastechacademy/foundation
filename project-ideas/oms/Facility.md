### Facility-Related Entities in HotWax Commerce

1.  **`Facility`**

The `Facility` entity in HotWax Commerce represents a physical or virtual location, such as a warehouse, store, or distribution center. It stores essential information about the facility's operations, contact details, and inventory management capabilities.

**Key Fields**

*   `facilityId`: (Primary Key) The unique ID of the facility.
*   `facilityTypeId`: The type of facility (e.g., warehouse, store, office).
*   `parentFacilityId`: The ID of the parent facility in a hierarchical structure (if applicable).
*   `facilityName`: The name of the facility.
*   `defaultInventoryItemTypeId`: The default type of inventory item managed in this facility (e.g., serialized, non-serialized).
*   `openTime`: (HotWax Extension) The daily opening time of the facility.
*   `closeTime`: (HotWax Extension) The daily closing time of the facility.
*   `facilityTimeZone`: (HotWax Extension) The time zone in which the facility operates.
*   `maximumOrderLimit`: (HotWax Extension) The maximum number of orders that can be processed or fulfilled by the facility within a specific time period.
*   `postalCode`: (HotWax Extension) The postal code of the facility's location.

**Purpose and Usage**

The `Facility` entity is central to HotWax Commerce's OMS and inventory management capabilities. It allows businesses to:

*   **Model their physical locations:** Represent their warehouses, stores, and other operational locations within the system.
*   **Categorize facilities:** Group facilities by type to manage different operational needs.
*   **Track operating hours:** Store information about the facility's opening and closing times.
*   **Manage capacity:** Define limits on the number of orders a facility can handle.
*   **Track location:** Store the postal code for logistical purposes.
*   **Manage inventory:** Associate inventory items with specific facilities and track stock levels.
*   **Fulfill orders:** Determine which facilities can fulfill customer orders based on product availability and other factors.

2.  **`FacilityType`**

    *   **Purpose:** Categorizes facilities into types (warehouse, store, office).
    *   **Key Fields:** `facilityTypeId`, `description`.
    *   **Relevance to HC:** HC utilizes this entity to distinguish between different types of facilities for inventory management purposes. For example, different facility types might have different workflows or storage requirements.

3.  **`FacilityParty`**

    *   **Purpose:** Links a facility to a party (person or organization) responsible for it.
    *   **Key Fields:** `facilityId`, `partyId`, `roleTypeId`.
    *   **Relevance to HC:** HC uses this entity to manage contacts and assign responsibilities within facilities. For example, HC tracks the warehouse manager or the contact person for receiving shipments.

4.  **`FacilityLocation`**

The `FacilityLocation` entity in HotWax Commerce represents a specific location or zone within a facility. This could be an aisle, bin, shelf, or receiving area. It allows for detailed tracking and management of inventory at a granular level.

**Key Fields**

*   `facilityId`: The ID of the facility where the location is situated. This field is a primary key, meaning it's a unique identifier for the facility.
*   `locationSeqId`: A unique identifier for the location within the facility. This field is also a primary key, ensuring each location within a facility has a unique ID.
*   `areaId`: Represents a sub-area within the facility. This could be used to group related locations, such as all the bins in a particular aisle or all the shelves in a specific room.
*   `positionId`: Specifies the position of the location within a sub-area. This could be used to further pinpoint the location, such as the exact position of a bin on a shelf.
*   `isLocked`: This field, a HotWax Commerce extension, indicates whether the location is currently locked for reservations. This can be useful for preventing inventory from being reserved at a location that's undergoing maintenance or an inventory count.
*   `lastCountDate`: Another HotWax Commerce extension, this field stores the date of the last inventory count at this location. This helps track when physical inventory checks were performed.
*   `nextCountDate`: This HotWax extension stores the date of the next scheduled inventory count at this location. This helps plan and schedule future inventory counts.

**Relationships**

*   The `FacilityLocation` entity has a many-to-one relationship with the `Facility` entity. This means that many locations can belong to one facility.

**Purpose and Usage**

The `FacilityLocation` entity is important for HotWax Commerce because it enables the system to:

*   **Organize inventory:** Define and manage specific locations within a facility to track inventory more precisely.
*   **Control reservations:** Lock locations to prevent reservations during stocktaking or maintenance.
*   **Schedule inventory counts:** Track and schedule regular inventory counts at different locations.
*   **Optimize picking and packing:** Facilitate efficient picking and packing operations by assigning inventory to specific locations.


5.  **`FacilityGroup`**

    *   **Purpose:** Groups facilities into categories (e.g., regional groups).
    *   **Key Fields:** `facilityGroupId`, `facilityGroupTypeId`.
    *   **Relevance to HC:** HC utilizes this entity to manage groups of facilities, such as grouping warehouses by region or function, which is useful for reporting and logistical operations.

6.  **`FacilityGroupType`**

    *   **Purpose:** Defines types of facility groups.
    *   **Key Fields:** `facilityGroupTypeId`, `description`.
    *   **Relevance to HC:** HC uses this entity in conjunction with `FacilityGroup` to define types of facility groups, like "Region," "Warehouse Type," or "Function."

7.  **`FacilityGroupRollup`**

    *   **Purpose:** Manages hierarchical relationships between facility groups.
    *   **Key Fields:** `facilityGroupId`, `parentFacilityGroupId`, `fromDate`, `thruDate`.
    *   **Relevance to HC:** HC utilizes this entity to create a tree-like structure of facility groups, where one group might be a sub-group of another.

8.  **`FacilityGroupMember`**

    *   **Purpose:** Links facilities to facility groups.
    *   **Key Fields:** `facilityId`, `facilityGroupId`, `fromDate`, `thruDate`.
    *   **Relevance to HC:** HC uses this entity to establish the many-to-many relationship between facilities and facility groups.

9.  **`FacilityContactMech`**

    *   **Purpose:** Associates contact mechanisms (phone, email) with facilities.
    *   **Key Fields:** `facilityId`, `contactMechId`.
    *   **Relevance to HC:** HC uses this entity to manage facility contact information, integrating it with communication or notification systems within the OMS.

10. **`FacilityContactMechPurpose`**

    *   **Purpose:** Specifies the purpose of a contact mechanism (billing, shipping).
    *   **Key Fields:** `facilityId`, `contactMechId`, `contactMechPurposeTypeId`.
    *   **Relevance to HC:** HC utilizes this entity to distinguish between different contact purposes for a facility, such as having separate contacts for billing inquiries and shipping-related communications.

11. **`FacilityCarrierShipment`**

    *   **Purpose:** Links facilities to carrier shipments.
    *   **Key Fields:** `facilityId`, `carrierPartyId`, `shipmentMethodTypeId`.
    *   **Relevance to HC:** HC uses this entity to manage shipping operations and carrier information related to facilities, tracking which carriers operate from which facilities and their preferred shipping methods.

12. **`FacilityCalendar`**

    *   **Purpose:** Manages calendars for facility operations (working hours, events).
    *   **Key Fields:** `facilityId`, `facilityCalendarId`.
    *   **Relevance to HC:** HC leverages this entity for advanced OMS features like scheduling and tracking facility operating hours, which is relevant for planning shipments and managing workforce schedules.

13. **`FacilityCalendarType`**

    *   **Purpose:** Categorizes facility calendars.
    *   **Key Fields:** `facilityCalendarTypeId`, `description`.
    *   **Relevance to HC:** HC uses this entity to categorize facility calendars into different types, such as holidays, maintenance schedules, or special events.

14. **`ProductFacility`**

The `ProductFacility` entity in HotWax Commerce links products to the facilities where they are stored or handled. It manages various aspects of product-specific inventory control and fulfillment options within each facility.

**Key Fields**

*   `productId`: (Primary Key) The ID of the product.
*   `facilityId`: (Primary Key) The ID of the facility.
*   `minimumStock`: The minimum stock level to maintain for this product at this facility.
*   `reorderQuantity`: The quantity to reorder when the stock level falls below the minimum.
*   `allowPickup`: (HotWax Extension) Indicates whether customers are allowed to pick up orders for this product at this facility.
*   `salesVelocity`: (HotWax Extension) Represents the sales velocity of the product at this facility, which can be useful for demand forecasting and inventory planning.
*   `requirementMethodEnumId`: (HotWax Extension) Specifies the method used to determine inventory requirements for this product at this facility. This might involve different calculation methods or algorithms for forecasting demand and managing stock levels.
*   `computedLastInventoryCount`: (HotWax Extension) Stores the computed last inventory count of the product at this facility. This is calculated as `availableToPromiseTotal - minimumStock`, but if `availableToPromiseTotal` is less than or equal to `minimumStock`, it's set to 0.
*   `allowBrokering`: (HotWax Extension) Indicates whether brokering is allowed for this product at this facility. This means that if the product is unavailable at this facility, the system can attempt to source it from other facilities or suppliers.

**Relationships**

*   Many-to-many between `Product` and `Facility`.

You're right! I can be more confident in my description now that we've established the purpose and usage of the `FacilityIdentification` entity.

Here's the rewritten description with a more assertive tone:

5**`FacilityIdentification`**

The `FacilityIdentification` entity in HotWax Commerce associates various identification values with a facility. This includes different types of identifiers such as internal IDs, external IDs, government-issued IDs, or any other relevant identification number.

**Key Fields**

*   `facilityIdenTypeId` (id, Primary Key):  Links to an enumeration that defines the type of identification (e.g., "Internal ID," "Government ID," "External System ID").
*   `facilityId` (id, Primary Key): The ID of the facility.
*   `idValue` (id-long): The actual identification value.
*   `fromDate` (date-time, Primary Key): The starting date and time when this identification is valid.
*   `thruDate` (date-time): The ending date and time when this identification is valid.

**Relationships**

*   One-to-one with `Enumeration` (linked through `facilityIdenTypeId`).
*   One-to-one with `Facility`.

**Detailed Description**

The `FacilityIdentification` entity provides HotWax Commerce with the flexibility to manage multiple identification values for each facility. This is essential for several reasons:

*   **Integration with external systems:** HotWax Commerce uses this entity to store external IDs alongside the internal `facilityId`, enabling seamless integration with other systems that may use different facility identifiers.
*   **Tracking different types of IDs:**  HotWax Commerce tracks various types of identification numbers for a facility, such as government-issued permits, tax IDs, or internal tracking numbers, using this entity.
*   **Managing ID changes over time:** If a facility's identification changes (e.g., due to a merger, acquisition, or re-registration), this entity maintains a history of IDs and their validity periods.

**Example**

A facility might have the following IDs:

*   Internal ERP ID: "FAC-123"
*   Shopify-issued number: "GOV-456"
*   ID used in an external warehouse management system: "WMS-789"

HotWax Commerce stores these IDs in the `FacilityIdentification` entity as follows:

| facilityIdenTypeId  | facilityId | idValue     | fromDate  | thruDate  |
|---------------------|------------|-------------|-----------|-----------|
| FACILITY\_ERPID     | FAC-123    | FAC-123     | 2023-01-01 | null      |
| FACILITY\_SHOPIFYID | FAC-123    | SHOPIFY-456 | 2023-01-01 | null      |
| FACILITY\_EXTERNAL  | FAC-123    | WMS-789     | 2023-01-01 | null      |


**Purpose and Usage**

The `ProductFacility` entity plays a vital role in HotWax Commerce's inventory management and order fulfillment processes. It allows businesses to:

*   **Set inventory policies:** Define minimum stock levels and reorder quantities for each product at different facilities.
*   **Control fulfillment options:** Manage whether products can be picked up from specific facilities.
*   **Track sales velocity:** Monitor the sales performance of products at each facility.
*   **Determine inventory requirements:** Utilize different methods for calculating and forecasting inventory needs.
*   **Manage excess inventory:** Track the amount of inventory exceeding the minimum stock level.
*   **Enable brokering:** Allow products to be sourced from alternative locations if unavailable at the primary facility.


15. **`ProductFacilityLocation`**

    *   **Purpose:** Links products to specific locations within a facility.
    *   **Key Fields:** `productId`, `facilityId`, `locationSeqId`.
    *   **Relevance to HC:** HC uses this entity to manage product stock at specific locations within a facility, enabling precise inventory tracking.
