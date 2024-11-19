### Facility-Related Entities in HotWax Commerce

1.  **`Facility`**

    *   **Purpose:** Represents physical or virtual locations like warehouses, stores, or distribution centers.
    *   **Key Fields:** `facilityId`, `facilityTypeId`, `parentFacilityId`, `facilityName`, `defaultInventoryItemTypeId`.
    *   **Relevance to HC:** This entity is crucial for representing HC's warehouses or fulfillment centers.
        *   The `facilityTypeId` field allows HC to categorize different types of facilities, such as warehouses, stores, or offices.
        *   The `parentFacilityId` field enables HC to model hierarchical relationships between facilities, such as regional warehouses reporting to a central distribution center.

2.  **`FacilityType`**

    *   **Purpose:** Categorizes facilities into types (warehouse, store, office).
    *   **Key Fields:** `facilityTypeId`, `description`.
    *   **Relevance to HC:** HC utilizes this entity to distinguish between different types of facilities for inventory management purposes. For example, different facility types might have different workflows or storage requirements.

3.  **`FacilityParty`**

    *   **Purpose:** Links a facility to a party (person or organization) responsible for it.
    *   **Key Fields:** `facilityId`, `partyId`, `roleTypeId`.
    *   **Relevance to HC:** HC uses this entity to manage contacts and assign responsibilities within facilities. For example, HC tracks the warehouse manager or the contact person for receiving shipments.

4.  **`FacilityLocation`**

    *   **Purpose:** Represents specific locations within a facility (e.g., aisles, bins).
    *   **Key Fields:** `facilityId`, `locationSeqId`, `areaId`, `positionId`.
    *   **Relevance to HC:** HC leverages this entity to manage inventory at a granular level, assigning inventory to specific locations within a facility for efficient picking and packing operations.

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
