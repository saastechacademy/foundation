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

*   **`DataManagerLog` (extended)**: This extended entity logs data management operations related to the Shopify connector, including the associated Shopify configuration and remote file paths.

*   **`JobSandbox` (extended)**: This extended entity associates scheduled jobs with specific Shopify shops, enabling task automation and management within the context of the Shopify integration.

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
