### Product Store and Related Entities in HotWax Commerce

This document provides a comprehensive overview of the `ProductStore` entity and its related entities in HotWax Commerce (HC), highlighting the specific customizations and extensions implemented in HC compared to the standard Apache OFBiz framework. It serves as a guide for developers working on the Order Management System (OMS) and inventory management modules.

### 1. `ProductStore` Entity

The `ProductStore` entity represents a store or sales channel where products are sold. This could be a physical store, an online store, or any other channel. It's a central entity for managing various aspects of a retail organization's operations, including sales channels, order fulfillment, inventory management, and customer communication.

**Key Fields**

*   **Standard OFBiz Fields**
    *   `productStoreId` (Primary Key): Unique identifier for the store.
    *   `storeName`: The name of the store.
    *   `companyName`: The name of the company operating the store.
    *   `title`: Title displayed on the storefront.
    *   `subtitle`: Subtitle displayed on the storefront.
    *   `payToPartyId`: Party (entity) receiving payments.
    *   `isDemoStore`: Flag for demo stores.
    *   `visualThemeId`: Storefront's visual theme.

*   **HotWax Commerce Extensions**
    *   `catalogUrlMountPoint`: URL mount point for the product catalog.
    *   `restockingFeePercentage`: Percentage charged for returns.
    *   `capturePmntsOnOrdApproval`: Flag for capturing payments on order approval.
    *   `termTypeId`: ID of the term type for orders (e.g., payment terms).
    *   `autoSetFacility`: Flag for automatically selecting the nearest fulfillment facility.
    *   `enableExternalPromotion`: Flag for enabling external promotions.
    *   `daysToReturn`: Allowed return period in days.
    *   `restockingFeeFixed`: Fixed fee charged for restocking returns.
    *   `autoAcceptReturn`: Flag for automatically accepting returns.
    *   `externalId`: External ID for integration with other systems.
    *   `allowSplit`: Flag for allowing order splitting into multiple shipments.
    *   `storeDomain`: Domain name associated with the store.
    *   `productIdentifierEnumId`: ID of the enumeration defining the product identifier used (e.g., SKU, UPC).
    *   `enablePreOrderAutoReleasing`: Flag for automatically releasing pre-orders.
    *   `enableBrokering`: Flag for enabling brokering (sourcing products from other locations if unavailable).
    *   `storeLogoImageUrl`: URL of the store's logo image.

**Relationships**

*   One-to-many with `ProductStoreCatalog`, `ProductStoreFacility`, `ProductStorePaymentSetting`, `ProductStorePromoAppl`, `ProductStoreRole`, `ProductStoreShipmentMeth`, and `ProductStoreFacilityGroup`.
*   One-to-one with `WebSite`.
*   One-to-one with `Enumeration` (for the product identifier).

**Purpose and Usage**

The `ProductStore` entity is central to managing sales channels and order fulfillment in HotWax Commerce. It allows businesses to:

*   Define store-specific settings and policies.
*   Control branding elements.
*   Manage product catalogs.
*   Configure fulfillment options.
*   Enable promotions and discounts.
*   Set up user roles and permissions.
*   Integrate with external systems.

### 2. Related and Custom Entities

*   **`ProductStoreCatalog`**
    *   Purpose: Links a `ProductStore` to catalogs containing product categories and products.
    *   HC Customization: `sequenceNum`: A sequence number for ordering the catalogs associated with a store.
*   **`ProductStoreFacility`**
    *   Purpose: Associates a `ProductStore` with fulfillment facilities (warehouses, stores).
*   **`ProductStoreGroup`**
    *   Purpose: Groups multiple `ProductStore` entities into categories (e.g., by region, brand).
*   **`ProductStorePaymentSetting`**
    *   Purpose: Defines payment settings for the store (e.g., supported methods, gateways).
*   **`ProductStorePromoAppl`**
    *   Purpose: Links promotions and discounts to the store.
*   **`ProductStoreRole`**
    *   Purpose: Defines roles and permissions for users within the store (e.g., customer, administrator).
*   **`ProductStoreShipmentMeth`**
    *   Purpose: Specifies available shipping methods for the store.
    *   HC Customization: `sequenceNum`: A sequence number for ordering the shipping methods available for a store.
*   **`WebSite`:** Links the store to a website.
*   **`ProductStoreEmailSetting`**
    *   Purpose: Stores email configuration and content for a specific product store.
    *   Key Fields: `productStoreId`, `emailType`, `bodyScreenLocation`, `xslfoAttachScreenLocation`, `fromAddress`, `ccAddress`, `bccAddress`, `subject`, `contentType`, `templateContentId`, `plainTextContentId`.
    *   Relationships: One-to-one with `ProductStore` and `Content`.
*   **`ProductStoreSetting`**
    *   Purpose: Allows storing various settings and configurations for each product store.
    *   Key Fields: `productStoreId`, `settingTypeEnumId`, `fromDate`, `thruDate`, `settingValue`.
    *   Relationships: One-to-one with `Enumeration` and `ProductStore`.
*   **`ProductStoreFacilityGroup`**
    *   Purpose: Associates a product store with one or more facility groups.
    *   Key Fields: `productStoreId`, `facilityGroupId`, `fromDate`, `thruDate`, `sequenceNumber`.
    *   Relationships: One-to-one with `ProductStore` and `FacilityGroup`.

### 4. Entities Extended in HotWax Commerce

*   **`ProductFacility`**
    *   Purpose: Links products to facilities, managing inventory control and fulfillment options.
    *   Key Fields: `productId`, `facilityId`, `minimumStock`, `reorderQuantity`, `allowPickup`, `salesVelocity`, `requirementMethodEnumId`, `computedLastInventoryCount`, `allowBrokering`.
    *   Relationships: Many-to-many between `Product` and `Facility`.
*   **`FacilityLocation`**
    *   Purpose: Represents specific locations within a facility for detailed inventory tracking.
    *   Key Fields: `facilityId`, `locationSeqId`, `areaId`, `positionId`, `isLocked`, `lastCountDate`, `nextCountDate`.
    *   Relationships: Many-to-one with `Facility`.
*   **`Facility`**
    *   Purpose: Represents a physical or virtual location (warehouse, store).
    *   Key Fields: `facilityId`, `facilityTypeId`, `parentFacilityId`, `facilityName`, `defaultInventoryItemTypeId`, `openTime`, `closeTime`, `facilityTimeZone`, `maximumOrderLimit`, `postalCode`.
    *   Relationships: Has many `FacilityParty`, `FacilityLocation`, `FacilityContactMech`, `FacilityCalendar`, `ProductFacility`.

### 5. Custom Entities in HotWax Commerce

*   **`FacilityIdentification`**
    *   Purpose: Associates various identification values with a facility.
    *   Key Fields: `facilityIdenTypeId`, `facilityId`, `idValue`, `fromDate`, `thruDate`.
    *   Relationships: One-to-one with `Enumeration` and `Facility`.


### 6. ProductStore REST API

*   **Endpoint**
    *   : /rest/productStores
    *   Method: POST
    *   Description: Creates and configures a new ProductStore with all related data such as settings, facility groups, and catalog associations.
*   **Request Payload**

```json
{
  "productStoreId": "STORE",
  "storeName": "Demo Store",
  "primaryStoreGroupId": "STORE_GROUP",
  "companyName": "Company",
  "defaultCurrencyUomId": "USD",
  "catalogUrlMountPoint": "products",
  "autoSetFacility": "Y",
  "enableExternalPromotion": "Y",
  "storeSettings": [
    {
      "settingTypeEnumId": "RATE_SHOPPING",
      "fromDate": "2001-01-01T12:00:00.000Z",
      "settingValue": "Y"
    }
  ],
  "facilityGroups": [
    {
      "facilityGroupId": "WAREHOUSE_GROUP",
      "fromDate": "2023-01-01T00:00:00.000Z"
    }
  ]
}
```