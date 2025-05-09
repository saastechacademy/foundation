The HotWax Commerce Shopify connector data model is designed to facilitate the integration and synchronization of data between Shopify and the HotWax Commerce OMS (Order Management System). It comprises several entities and view entities that store and manage configuration settings, product information, order details, and relationships between Shopify and HotWax Commerce entities. Let's explore the key components of this data model:

### **ShopifyConfig and Related Entities**

*   **`ShopifyConfig`**: This entity serves as the central configuration hub for the Shopify connector. It stores essential information such as:
    *   `shopifyConfigId`: A unique identifier for the configuration.
    *   `shopifyConfigName`: A descriptive name for the configuration.
    *   `accessScopeEnumId`: Defines the access scope (permissions) granted to the connector.
    *   `apiVersion`: Specifies the Shopify API version used for communication.
    *   `productStoreId`: The associated product store in HotWax Commerce.
    *   `shopId`: The unique identifier of the Shopify shop.
    *   `webSiteId`: The associated website in HotWax Commerce.
    *   `apiUrl`, `username`, `currentPassword`, `accessToken`, `sharedSecret`: Credentials and API endpoint details for secure communication with Shopify.
    *   `processRefund`: Indicates whether refunds should be processed through the connector.

*   **`ShopifyShop`**: This entity represents a specific Shopify shop, storing details like:
    *   `shopId`: The unique identifier of the shop.
    *   `shopifyShopId`: The corresponding shop ID in Shopify.
    *   `productStoreId`: The associated product store in HotWax Commerce.
    *   `name`, `email`, `phone`, `shopOwner`, `timezone`, `planName`, `domain`, `myshopifyDomain`, `primaryLocationId`, `weightUnit`, `currency`, `countryCode`: General information about the shop.

*   **`ShopifyShopLocation`**: This entity links a Shopify shop to a facility (physical location) in HotWax Commerce, enabling inventory and fulfillment management. It stores:
    *   `shopId`: The associated Shopify shop.
    *   `facilityId`: The linked facility in HotWax Commerce.
    *   `shopifyLocationId`: The corresponding location ID in Shopify.

*   **`ShopifyShopProduct`**: This entity establishes a connection between a Shopify product and its corresponding product in HotWax Commerce. It includes:
    *   `shopId`: The associated Shopify shop.
    *   `productId`: The product ID in HotWax Commerce.
    *   `shopifyProductId`: The corresponding product ID in Shopify.
    *   `shopifyInventoryItemId`: The inventory item ID in Shopify (if applicable).

*   **`ShopifyShopOrder`**: This entity links a Shopify order to its corresponding order in HotWax Commerce, facilitating order synchronization and management. It stores:
    *   `shopId`: The associated Shopify shop.
    *   `orderId`: The order ID in HotWax Commerce.
    *   `shopifyOrderId`: The corresponding order ID in Shopify.

*   **`ShopifyShopCarrierShipment`**: This entity maps Shopify shipping methods to carrier parties and shipment method types in HotWax Commerce, ensuring accurate representation of shipping information.

*   **`ShopifyShopTypeMapping`**: This entity allows for custom mapping of Shopify types (e.g., order statuses, fulfillment statuses) to corresponding types in HotWax Commerce, providing flexibility in data integration.

*   **`ShopifyMetafield`, `ShopifyShopProductMetafield`, `ShopifyProductMetafield`**: These entities handle metadata associated with Shopify products, enabling the storage and management of additional product information beyond standard attributes.

*   **`ShopifyShopScript`**: This entity manages scripts associated with a Shopify shop, including script types, event triggers, and execution details.

### **View Entities for Data Read Operations**

The data model also includes several view entities that simplify data retrieval and aggregation for various use cases:

*   **`ShopifyProductAtp`**: Provides a view of available-to-promise (ATP) inventory for Shopify products across different facilities, considering factors like inventory levels and minimum stock requirements.

*   **`ShopifyShopProductAndMetafield`**: Combines information about Shopify shop products and their associated metadata, facilitating access to extended product information.

*   **`ProductAndShopifyShopProduct`**: Links products in HotWax Commerce to their corresponding Shopify shop products, enabling efficient product data synchronization.

*   **`ShopifyShopProductAndConfig`**: Associates Shopify shop products with their respective Shopify configurations, providing context for product-related operations.

*   **`ShopifyShopProductAndAssoc`**: Retrieves product associations (e.g., bundled products, upsells) for Shopify shop products, enabling the management of product relationships.

*   **`ShopifyConfigAndShopLocation`**: Combines Shopify configurations with their associated shop locations, facilitating access to location-specific settings and data.

*   **`ShopifyShopAndConfig`**: Links Shopify shops to their configurations, providing a unified view of shop-level settings and information.

*   **`ShopifyShopProductView`, `ShopifyShopLocationView`**: Offer simplified views of Shopify shop products and locations, respectively, streamlining data retrieval for common use cases.

*   **`ShopifyShopLocationAndFacility`**: Connects Shopify shop locations to their corresponding facilities in HotWax Commerce, enabling inventory and fulfillment tracking.

*   **`ShopifyShopOrderAndConfig`**: Associates Shopify shop orders with their configurations, providing context for order processing and management.

*   **`ShopifyOrderAndTags`**: Retrieves HotWax Commerce orders along with their associated tags and notes, facilitating order filtering and categorization based on Shopify-specific tags.

*   **`ShopifyProductFacilityView`**: Provides a comprehensive view of product-facility relationships, including inventory levels and facility details, aiding in inventory management and fulfillment decisions.

These view entities play a crucial role in optimizing data access and retrieval for various operations within the Shopify connector, enabling efficient querying and analysis of Shopify-related data within the HotWax Commerce OMS.


## API for Managing ShopifyShop with ShopifyConfig

**Endpoint: Create or Update ShopifyShop with Configuration**

*   URL: /rest/s1/shopify/shops
*   Method: POST
*   Description: Creates or updates a ShopifyShop along with its configuration (ShopifyConfig).

**Request Payload Example:**

```json
{
  "shopId": "10000",
  "shopifyShopId": "6973849727",
  "productStoreId": "STORE",
  "name": "HC Demo",
  "email": "integrations@hotwax.co",
  "phone": "7828341900",
  "shopOwner": "HotWax Commerce Shopify",
  "timezone": "America/New_York",
  "planName": "affiliate",
  "domain": "hc-demo.myshopify.com",
  "myshopifyDomain": "hc-demo.myshopify.com",
  "primaryLocationId": "17715232895",
  "weightUnit": "lb",
  "currency": "USD",
  "countryCode": "US",
  "shopifyConfig": {
    "shopifyConfigId": "10000",
    "shopifyConfigName": "hc-demo",
    "accessScopeEnumId": "SHOP_RW_ACCESS",
    "accessToken": "shpat",
    "apiUrl": "[https://hc-demo.myshopify.com/](https://hc-demo.myshopify.com/)",
    "processRefund": "Y",
    "productStoreId": "STORE",
    "sharedSecret": "04a072",
    "webSiteId": "WEBSTORE"
  }
}
```

**Endpoint: Retrieve ShopifyShop with Configuration**

*   URL: /rest/s1/shopify/shops/{shopId}
*   Method: GET
*   Description: Retrieves a ShopifyShop and its nested configuration (ShopifyConfig).

**Response Example:**

```json
{
  "shopId": "10000",
  "shopifyShopId": "6973849727",
  "productStoreId": "STORE",
  "name": "HC Demo",
  "email": "integrations@hotwax.co",
  "phone": "7828341900",
  "shopOwner": "HotWax Commerce Shopify",
  "timezone": "America/New_York",
  "planName": "affiliate",
  "domain": "hc-demo.myshopify.com",
  "myshopifyDomain": "hc-demo.myshopify.com",
  "primaryLocationId": "17715232895",
  "weightUnit": "lb",
  "currency": "USD",
  "countryCode": "US",
  "shopifyConfig": {
    "shopifyConfigId": "10000",
    "shopifyConfigName": "hc-demo",
    "accessScopeEnumId": "SHOP_RW_ACCESS",
    "accessToken": "shpat",
    "apiUrl": "[https://hc-demo.myshopify.com/](https://hc-demo.myshopify.com/)",
    "processRefund": "Y",
    "productStoreId": "STORE",
    "sharedSecret": "04a072",
    "webSiteId": "WEBSTORE"
  }
}
```
**ShopifyShop with ShopifyConfig, ShopifyShopTypeMapping, ShopifyShopCarrierShipment, and ShopifyShopLocation:**

```json
{
  "shopId": "10000",
  "shopifyShopId": "6973849727",
  "productStoreId": "STORE",
  "name": "HC Demo",
  "email": "integrations@hotwax.co",
  "phone": "7828341900",
  "shopOwner": "HotWax Commerce Shopify",
  "timezone": "America/New_York",
  "planName": "affiliate",
  "domain": "hc-demo.myshopify.com",
  "myshopifyDomain": "hc-demo.myshopify.com",
  "primaryLocationId": "17715232895",
  "weightUnit": "lb",
  "currency": "USD",
  "countryCode": "US",
  "shopifyConfig": {
    "shopifyConfigId": "10000",
    "shopifyConfigName": "hc-demo",
    "accessScopeEnumId": "SHOP_RW_ACCESS",
    "apiVersion": "2024-11",
    "productStoreId": "STORE",
    "shopId": "10000",
    "webSiteId": "WEBSTORE",
    "apiUrl": "https://hc-demo.myshopify.com/",
    "username": "api_user",
    "currentPassword": "secure_password",
    "accessToken": "shpat_1234567890abcdef",
    "sharedSecret": "04a072",
    "processRefund": "Y"
  },
  "shopifyShopTypeMappings": [
    {
      "mappedKey": "afterpay",
      "mappedTypeId": "SHOPIFY_PAYMENT_TYPE",
      "mappedValue": "EXT_SHOP_AFTRPAY"
    },
    {
      "mappedKey": "Loyalty Card",
      "mappedTypeId": "SHOPIFY_PRODUCT_TYPE",
      "mappedValue": "DIGITAL_GOOD"
    },
    {
      "mappedKey": "iphone",
      "mappedTypeId": "SHOPIFY_ORDER_SOURCE",
      "mappedValue": "PHONE_SALES_CHANNEL"
    }
  ],
  "shopifyShopCarrierShipments": [
    {
      "carrierPartyId": "_NA_",
      "shipmentMethodTypeId": "NEXT_DAY",
      "shopifyShippingMethod": "Expedited"
    },
    {
      "carrierPartyId": "FEDEX",
      "shipmentMethodTypeId": "THIRD_DAY",
      "shopifyShippingMethod": "Standard"
    }
  ],
  "shopifyShopLocations": [
    {
      "facilityId": "_NA_",
      "shopifyLocationId": "67890151588"
    },
    {
      "facilityId": "BROADWAY",
      "shopifyLocationId": "67890446500"
    },
    {
      "facilityId": "SALT_LAKE_CITY",
      "shopifyLocationId": "67890184356"
    }
  ]
}
```



## ShopifyShopTypeMapping API Documentation

The ShopifyShopTypeMapping entity manages type mappings (e.g., payment types, product types, order sources) for a Shopify shop. This document defines APIs for creating, updating, retrieving, and deleting ShopifyShopTypeMapping data independently.

## API Design: ShopifyShopTypeMapping

### Endpoint: Create or Update ShopifyShopTypeMapping

*   **URL:** `/rest/s1/shopify/shops/{shopId}/typeMappings`
*   **Method:** `POST`
*   **Description:** Creates or updates a ShopifyShopTypeMapping entry for a Shopify shop.

**Request Payload Example:**

```json
{
  "shopId": "10000",
  "mappedKey": "afterpay",
  "mappedTypeId": "SHOPIFY_PAYMENT_TYPE",
  "mappedValue": "EXT_SHOP_AFTRPAY"
}
```

### Endpoint: Retrieve ShopifyShopTypeMappings for a Shop

*   **URL:** `/rest/s1/shopify/shops/{shopId}/typeMappings`
*   **Method:** `GET`
*   **Description:** Retrieves all ShopifyShopTypeMappings for a specific shop.

**Response Example:**

```json
{
  "shopId": "10000",
  "typeMappings": [
    {
      "mappedKey": "afterpay",
      "mappedTypeId": "SHOPIFY_PAYMENT_TYPE",
      "mappedValue": "EXT_SHOP_AFTRPAY"
    },
    {
      "mappedKey": "Loyalty Card",
      "mappedTypeId": "SHOPIFY_PRODUCT_TYPE",
      "mappedValue": "DIGITAL_GOOD"
    },
    {
      "mappedKey": "iphone",
      "mappedTypeId": "SHOPIFY_ORDER_SOURCE",
      "mappedValue": "PHONE_SALES_CHANNEL"
    }
  ]
}
```

### Endpoint: Retrieve a Specific ShopifyShopTypeMapping

*   **URL:** `/rest/s1/shopify/shops/{shopId}/typeMappings/{mappedKey}`
*   **Method:** `GET`
*   **Description:** Retrieves a specific ShopifyShopTypeMapping by mappedKey for a Shopify shop.

**Response Example:**

```json
{
  "shopId": "10000",
  "mappedKey": "afterpay",
  "mappedTypeId": "SHOPIFY_PAYMENT_TYPE",
  "mappedValue": "EXT_SHOP_AFTRPAY"
}
```

### Endpoint: Delete a ShopifyShopTypeMapping

*   **URL:** `/rest/s1/shopify/shops/{shopId}/typeMappings/{mappedKey}`
*   **Method:** `DELETE`
*   **Description:** Deletes a specific ShopifyShopTypeMapping by mappedKey for a Shopify shop.


## API Specification for Managing ShopifyShopCarrierShipment

### 1. Create or Update ShopifyShopCarrierShipment

*   **URL:** `/rest/s1/shopify/shops/{shopId}/carrierShipments`
*   **Method:** `POST`
*   **Description:** Creates or updates a ShopifyShopCarrierShipment entry for a Shopify shop.

**Request Payload Example:**

```json
{
  "shopId": "10000",
  "carrierPartyId": "_NA_",
  "shipmentMethodTypeId": "NEXT_DAY",
  "shopifyShippingMethod": "Expedited"
}
```

### 2. Retrieve ShopifyShopCarrierShipments for a Shop

*   **URL:** `/rest/s1/shopify/shops/{shopId}/carrierShipments`
*   **Method:** `GET`
*   **Description:** Retrieves all ShopifyShopCarrierShipments for a specific shop.

**Response Example:**

```json
{
  "shopId": "10000",
  "carrierShipments": [
    {
      "carrierPartyId": "_NA_",
      "shipmentMethodTypeId": "NEXT_DAY",
      "shopifyShippingMethod": "Expedited"
    },
    {
      "carrierPartyId": "FEDEX",
      "shipmentMethodTypeId": "THIRD_DAY",
      "shopifyShippingMethod": "Standard"
    }
  ]
}
```

### 3. Retrieve a Specific ShopifyShopCarrierShipment

*   **URL:** `/rest/s1/shopify/shops/{shopId}/carrierShipments/{shopifyShippingMethod}`
*   **Method:** `GET`
*   **Description:** Retrieves a specific ShopifyShopCarrierShipment by shopifyShippingMethod for a Shopify shop.

**Response Example:**

```json
{
  "shopId": "10000",
  "carrierPartyId": "_NA_",
  "shipmentMethodTypeId": "NEXT_DAY",
  "shopifyShippingMethod": "Expedited"
}
```

### 4. Delete a ShopifyShopCarrierShipment

*   **URL:** `/rest/s1/shopify/shops/{shopId}/carrierShipments/{shopifyShippingMethod}`
*   **Method:** `DELETE`
*   **Description:** Deletes a specific ShopifyShopCarrierShipment by shopifyShippingMethod for a Shopify shop.

### **API Documentation for Managing ShopifyShopLocation**

The `ShopifyShopLocation` entity manages the mapping of Shopify locations to facilities in HotWax Commerce, enabling accurate inventory and fulfillment management. This section defines APIs for independently managing ShopifyShopLocation data.

---

### **API Endpoints for ShopifyShopLocation**

#### **1. Create or Update ShopifyShopLocation**

- **Endpoint**: `/rest/s1/shopify/shops/{shopId}/locations`
- **Method**: `POST`
- **Description**: Creates or updates a ShopifyShopLocation entry.

**Request Payload Example**:

```json
{
  "shopId": "10000",
  "facilityId": "BROADWAY",
  "shopifyLocationId": "67890446500"
}
```

---

#### **2. Retrieve ShopifyShopLocations for a Shop**

- **Endpoint**: `/rest/s1/shopify/shops/{shopId}/locations`
- **Method**: `GET`
- **Description**: Retrieves all ShopifyShopLocations for a specific Shopify shop.

**Response Example**:

```json
{
  "shopId": "10000",
  "shopifyShopLocations": [
    {
      "facilityId": "_NA_",
      "shopifyLocationId": "67890151588"
    },
    {
      "facilityId": "BROADWAY",
      "shopifyLocationId": "67890446500"
    },
    {
      "facilityId": "SALT_LAKE_CITY",
      "shopifyLocationId": "67890184356"
    }
  ]
}
```

---

#### **3. Retrieve a Specific ShopifyShopLocation**

- **Endpoint**: `/rest/s1/shopify/shops/{shopId}/locations/{shopifyLocationId}`
- **Method**: `GET`
- **Description**: Retrieves a specific ShopifyShopLocation by `shopifyLocationId` for a Shopify shop.

**Response Example**:

```json
{
  "shopId": "10000",
  "facilityId": "BROADWAY",
  "shopifyLocationId": "67890446500"
}
```

---

#### **4. Delete a ShopifyShopLocation**

- **Endpoint**: `/rest/s1/shopify/shops/{shopId}/locations/{shopifyLocationId}`
- **Method**: `DELETE`
- **Description**: Deletes a specific ShopifyShopLocation by `shopifyLocationId` for a Shopify shop.

---
