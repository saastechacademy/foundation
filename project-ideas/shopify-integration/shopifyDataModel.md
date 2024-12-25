# Introduction to Shopify Shop Data Model

This document provides an overview of the **HotWax Commerce Shopify connector data model**, focusing on its core and extended entities. The data model is designed to facilitate the integration and synchronization of data between **Shopify** and the **HotWax Commerce OMS** (Order Management System). It includes entities for managing configuration settings, product information, order details, shipping/carrier mappings, metafield data, and logs. It also comprises several **view entities** for read-only operations that simplify data retrieval.

---

## Example Scenario

Consider **Acme Brand**, which sells products via Shopify. They have two configurations (one for the U.S. store, one for the CA store). Both configurations refer to the same underlying product store in HotWax Commerce, and both share certain Shopify shop details (owner info, domain, etc.). By leveraging this **Shopify Shop** data model, Acme Brand can seamlessly manage products, orders, inventory, and more.

---

## Entities

### 1. ShopifyConfig

**Description**:  
Serves as the central configuration hub for the **Shopify connector**, storing essential information for secure communication with Shopify and controlling certain operational behaviors.

**Key Attributes**:  
- **shopifyConfigId**  
- **shopifyConfigName**  
- **accessScopeEnumId** (permissions granted to the connector)  
- **apiVersion** (Shopify API version used)  
- **productStoreId** (associated product store in HotWax Commerce)  
- **shopId** (unique identifier of the associated Shopify shop in HotWax Commerce)  
- **webSiteId** (associated website in HotWax Commerce)  
- **apiUrl**, **username**, **currentPassword**, **accessToken**, **sharedSecret**  
- **processRefund** (indicates whether refunds should be processed via the connector)

**Sample JSON**:qas1w2

```json
{
  "ShopifyConfig": [
    {
      "shopifyConfigId": "SCFG001",
      "shopifyConfigName": "US Shopify Config",
      "accessScopeEnumId": "SCOPED_ACCESS",
      "apiVersion": "2023-07",
      "productStoreId": "STORE001",
      "shopId": "SHOP001",
      "webSiteId": "WEB001",
      "apiUrl": "https://acme-us.myshopify.com/admin/api/2023-07",
      "username": "acmeconnector",
      "currentPassword": "secret",
      "accessToken": "shpat_abcd1234",
      "sharedSecret": "shpss_xyz1234",
      "processRefund": "Y"
    }
  ]
}
```

---

### 2. ShopifyShop

**Description**:  
Represents a specific **Shopify shop**, storing overall shop details (domain, currency, etc.) and linking to a **product store** in HotWax Commerce.

**Key Attributes**:  
- **shopId** (primary key in HotWax Commerce)  
- **shopifyShopId** (corresponding ID in Shopify)  
- **productStoreId** (associated product store in HotWax Commerce)  
- **name**, **email**, **phone**, **shopOwner**  
- **timezone**, **planName**, **domain**, **myshopifyDomain**  
- **primaryLocationId**, **weightUnit**, **currency**, **countryCode**

**Sample JSON**:

```json
{
  "ShopifyShop": [
    {
      "shopId": "SHOP001",
      "shopifyShopId": "123456789",
      "productStoreId": "STORE001",
      "name": "Acme US",
      "email": "support@acme-us.com",
      "phone": "+1-999-999-9999",
      "shopOwner": "Jane Doe",
      "timezone": "America/New_York",
      "planName": "Basic Shopify",
      "domain": "acme-us.com",
      "myshopifyDomain": "acme-us.myshopify.com",
      "primaryLocationId": "LOC001-US",
      "weightUnit": "lb",
      "currency": "USD",
      "countryCode": "US"
    }
  ]
}
```

---

### 3. ShopifyShopLocation

**Description**:  
Links a **Shopify shop** to a **facility** (physical location) in HotWax Commerce, enabling inventory and fulfillment management across different Shopify locations.

**Key Attributes**:  
- **shopId** (foreign key to **ShopifyShop**)  
- **facilityId** (linked facility in HotWax Commerce)  
- **shopifyLocationId** (location ID in Shopify)

**Sample JSON**:

```json
{
  "ShopifyShopLocation": [
    {
      "shopId": "SHOP001",
      "facilityId": "FAC001",
      "shopifyLocationId": "LOC001-US"
    },
    {
      "shopId": "SHOP001",
      "facilityId": "FAC002",
      "shopifyLocationId": "LOC002-US"
    }
  ]
}
```

---

### 4. ShopifyShopProduct

**Description**:  
Maps a **Shopify product** to its corresponding product in HotWax Commerce. This is crucial for synchronizing product data, inventory updates, and order-related product details.

**Key Attributes**:  
- **shopId** (foreign key to **ShopifyShop**)  
- **productId** (product in HotWax Commerce)  
- **shopifyProductId** (product ID in Shopify)  
- **shopifyInventoryItemId** (inventory item ID in Shopify, if applicable)

**Sample JSON**:

```json
{
  "ShopifyShopProduct": [
    {
      "shopId": "SHOP001",
      "productId": "PROD10001",
      "shopifyProductId": "shpProd10001",
      "shopifyInventoryItemId": "invItem10001"
    },
    {
      "shopId": "SHOP001",
      "productId": "PROD10002",
      "shopifyProductId": "shpProd10002",
      "shopifyInventoryItemId": "invItem10002"
    }
  ]
}
```

---

### 5. ShopifyShopOrder

**Description**:  
Connects a **Shopify order** to its corresponding **order** in HotWax Commerce. Facilitates order synchronization, status updates, and fulfillment operations.

**Key Attributes**:  
- **shopId** (foreign key to **ShopifyShop**)  
- **orderId** (HotWax Commerce order ID)  
- **shopifyOrderId** (Shopify order ID)

**Sample JSON**:

```json
{
  "ShopifyShopOrder": [
    {
      "shopId": "SHOP001",
      "orderId": "ORD1001",
      "shopifyOrderId": "1001-US"
    },
    {
      "shopId": "SHOP001",
      "orderId": "ORD1002",
      "shopifyOrderId": "1002-US"
    }
  ]
}
```

---

### 6. ShopifyShopCarrierShipment

**Description**:  
Maps shipping methods from **Shopify** (e.g., “standard_us”) to local **carrier parties** and **shipment method types** in HotWax Commerce, ensuring consistent shipping representation.

**Key Attributes**:  
- **shopId** (foreign key to **ShopifyShop**)  
- **carrierPartyId** (local carrier reference)  
- **shipmentTypeId** (type of shipment, e.g., “STANDARD”)  
- **shopifyShippingMethodId** (remote shipping method in Shopify)

**Sample JSON**:

```json
{
  "ShopifyShopCarrierShipment": [
    {
      "shopId": "SHOP001",
      "carrierPartyId": "CARR001",
      "shipmentTypeId": "STANDARD",
      "shopifyShippingMethodId": "standard_us"
    },
    {
      "shopId": "SHOP001",
      "carrierPartyId": "CARR002",
      "shipmentTypeId": "EXPRESS",
      "shopifyShippingMethodId": "express_us"
    }
  ]
}
```

---

### 7. ShopifyShopTypeMapping

**Description**:  
Provides a flexible way to map **Shopify types** (e.g., fulfillment status, payment status) to **HotWax Commerce** types or enums. This ensures data consistency across platforms.

**Key Attributes**:  
- **shopId** (foreign key to **ShopifyShop**)  
- **localEnumId**  
- **remoteEnumId**  
- **enumType** (e.g., “PAYMENT_METHOD”, “WEIGHT_UNIT”, etc.)

**Sample JSON**:

```json
{
  "ShopifyShopTypeMapping": [
    {
      "shopId": "SHOP001",
      "localEnumId": "PAYMENT_CC",
      "remoteEnumId": "credit_card",
      "enumType": "PAYMENT_METHOD"
    },
    {
      "shopId": "SHOP001",
      "localEnumId": "UNIT_LB",
      "remoteEnumId": "lb",
      "enumType": "WEIGHT_UNIT"
    }
  ]
}
```

---

### 8. ShopifyMetafield, ShopifyShopProductMetafield, ShopifyProductMetafield

**Description**:  
These entities handle **Shopify metafields** at different levels—**shop**, **product**, and **order**—allowing merchants to store custom data (e.g., “gift wrap option,” “custom dimensions”).

- **ShopifyMetafield**: Shop-level metadata  
- **ShopifyShopProductMetafield** (or **ShopifyProductMetafield**): Product-level metadata

**Example**:

```json
{
  "ShopifyMetafield": [
    {
      "shopId": "SHOP001",
      "namespace": "custom",
      "key": "gift_wrap_option",
      "value": "true"
    }
  ],
  "ShopifyShopProductMetafield": [
    {
      "shopId": "SHOP001",
      "productId": "PROD10001",
      "namespace": "specs",
      "key": "color",
      "value": "blue"
    }
  ]
}
```

---

### 9. ShopifyShopScript

**Description**:  
Manages **Shopify scripts** associated with a shop, storing script details, types, event triggers, and execution schedules. Enables advanced customization or automation within the Shopify environment.

**Key Attributes**:  
- **shopId**  
- **scriptTypeEnumId**  
- **eventTriggerEnumId**  
- **scriptContent**

No sample JSON provided here for brevity, but it generally captures the code or references to the script.

---

### 10. DataManagerLog (extended)

**Description**:  
Extended entity that records **data management operations** related to the Shopify connector, including references to:

- **shopifyConfigId**  
- **filePath** / **remoteFilePath** (if reading files from Shopify or exporting to Shopify)  
- **operationTypeEnumId** (indicating import, export, synchronization, etc.)

This log helps track the data flow and debug any synchronization issues that may arise.

---

### 11. JobSandbox (extended)

**Description**:  
Extended entity that associates **scheduled jobs** with specific **Shopify shops** or **ShopifyConfig** records. This enables:

- Automatic or scheduled tasks (e.g., daily product sync).  
- Identification of which Shopify shop a given job targets.

---

## View Entities for Data Read Operations

In addition to the **main entities**, the Shopify connector includes a variety of **view entities** to optimize data access, reporting, and complex queries. These view entities offer read-only aggregation and simplified structures for common operational needs:

1. **ShopifyProductAtp**  
   - Provides “available-to-promise” (ATP) inventory for Shopify products across different facilities.

2. **ShopifyShopProductAndMetafield**  
   - Combines Shopify shop product data with associated metafields, enabling streamlined access to extended product info.

3. **ProductAndShopifyShopProduct**  
   - Links HotWax Commerce products to their **ShopifyShopProduct** entries, simplifying product synchronization.

4. **ShopifyShopProductAndConfig**  
   - Associates **ShopifyShopProduct** records with their **ShopifyConfig**, giving context for product configuration.

5. **ShopifyShopProductAndAssoc**  
   - Retrieves product associations (e.g., bundles, upsells) for Shopify shop products.

6. **ShopifyConfigAndShopLocation**  
   - Combines **ShopifyConfig** with **ShopifyShopLocation** for location-specific settings and data.

7. **ShopifyShopAndConfig**  
   - Links **ShopifyShop** entities to their **ShopifyConfig** records, providing an integrated view of shop-level settings.

8. **ShopifyShopProductView**, **ShopifyShopLocationView**  
   - Offer simplified “views” of **ShopifyShopProduct** and **ShopifyShopLocation** data, respectively.

9. **ShopifyShopLocationAndFacility**  
   - Connects **ShopifyShopLocation** to the corresponding **Facility** in HotWax Commerce for inventory and fulfillment tracking.

10. **ShopifyShopOrderAndConfig**  
    - Associates **ShopifyShopOrder** records with their respective **ShopifyConfig**, aiding order processing tasks.

11. **ShopifyOrderAndTags**  
    - Retrieves orders along with Shopify tags/notes, enabling advanced filtering or categorization.

12. **ShopifyProductFacilityView**  
    - Provides a comprehensive view of **product-facility** relationships, inventory levels, and facility details, facilitating inventory management and fulfillment decisions.

These **view entities** significantly improve **performance** and **ease of data retrieval** by flattening or combining data from multiple tables. This helps ensure that both routine operations (e.g., product sync) and advanced analytics (e.g., sales forecasting, capacity planning) can be done efficiently.

---

## Putting It All Together

Below is a simplified JSON snippet demonstrating how these entities might coexist for **Acme Brand**, focusing on the central ones:

```json
{
  "ShopifyShop": [
    {
      "shopId": "SHOP001",
      "shopifyShopId": "123456789",
      "productStoreId": "STORE001",
      "name": "Acme US",
      "domain": "acme-us.com",
      "myshopifyDomain": "acme-us.myshopify.com",
      "currency": "USD",
      "countryCode": "US"
    }
  ],
  "ShopifyConfig": [
    {
      "shopifyConfigId": "SCFG001",
      "shopifyConfigName": "US Shopify Config",
      "shopId": "SHOP001",
      "accessToken": "shpat_abcd1234",
      "apiVersion": "2023-07",
      "productStoreId": "STORE001",
      "processRefund": "Y"
    }
  ],
  "ShopifyShopProduct": [
    {
      "shopId": "SHOP001",
      "productId": "PROD10001",
      "shopifyProductId": "shpProd10001",
      "shopifyInventoryItemId": "invItem10001"
    }
  ],
  "ShopifyShopOrder": [
    {
      "shopId": "SHOP001",
      "orderId": "ORD1001",
      "shopifyOrderId": "1001-US"
    }
  ],
  "ShopifyShopLocation": [
    {
      "shopId": "SHOP001",
      "facilityId": "FAC001",
      "shopifyLocationId": "LOC001-US"
    }
  ]
}
```

---

## Conclusion

The **HotWax Commerce Shopify connector data model** enables comprehensive, flexible integration between Shopify and the HotWax Commerce OMS. By leveraging these entities and **view entities**, you can:

1. **Centrally manage** multiple Shopify configurations and shops.
2. **Synchronize** product data, orders, inventory, and shipping details.
3. **Extend** the integration with custom metafields, scripts, and enumerations.
4. **Monitor** operations via extended logging and scheduling capabilities.

This data model ensures a unified approach to **Shopify-OMS** integration, preparing your system to handle evolving business needs and multiple e-commerce channels under a common framework.
```