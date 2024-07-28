**Understanding the Shopify Order Resource JSON**

Think of the order JSON as a comprehensive snapshot of a customer's purchase on your Shopify store. It includes everything from basic details about the order itself to information about the customer, the products they bought, shipping details, payment information, and much more.

**Top-Level Structure**

The top level of the JSON contains essential order attributes:

* `id`:  The unique numerical identifier of the order in Shopify's system.
* `name`:  A human-readable order name (e.g., "#1001").
* `order_number`: A sequential order number (e.g., 1001).
* `created_at`, `updated_at`:  Timestamps indicating when the order was created and last modified.
* `financial_status`:  Reflects the payment status of the order (e.g., "paid", "pending", "authorized").
* `fulfillment_status`: Indicates whether the order has been shipped or is still pending (e.g., "fulfilled", "partial").
* `total_price`:  The total amount the customer paid, including taxes and shipping.
* `total_price_set`:  Set of the total amount the customer paid, including taxes and shipping.
* `currency`: The three-letter code (ISO 4217) for the currency used in the order.
* `presentment_currency`: The currency used for the order.
* `customer_locale`: The locale of the customer placing the order.
* `current_total_price_set`:  Set of the current total price.

**Nested Objects**

The order JSON includes several nested objects that provide more detailed information:

* **`customer`:** Holds information about the customer who placed the order, including their ID, name, email address, and marketing preferences.
* **`billing_address`, `shipping_address`:** Contain the billing and shipping address details, respectively. Each address has fields like `name`, `address1`, `city`, `province`, `zip`, and `country`.
* **`line_items`:** An array listing each product purchased in the order. Each line item includes details like `product_id`, `variant_id`, `quantity`, `price`, and tax information.
* **`shipping_lines`:**  An array of shipping methods chosen for the order, with their associated prices and other details.
* **`tax_lines`:** An array of tax line objects, each of which details the taxes applicable to the order.

**Customer Information**

* **customer:** An object containing the customer's details:
*  'id'
*  'email'
*  'first_name', 'last_name'
*  'accepts_marketing'
*  'addresses' (an array of addresses)

**Billing and Shipping Addresses**

*   `billing_address`:  The billing address of the customer.
*   `shipping_address`: The shipping address (if different from billing).

**Line Items**

*   `line_items`: An array of objects representing the products ordered:
    *   `id`
    *   `product_id`, `variant_id`
    *   `title`
    *   `quantity`, `fulfillable_quantity`
    *   `price`, `total_discount` 
    *   `sku`
    *   `grams` (weight)
    *   `tax_lines` (taxes applied)
    *   `properties` (custom attributes like engraving)

**Other Important Fields**

*   `discount_codes`: Codes applied to the order for discounts.
*   `shipping_lines`:  Details of shipping methods and costs.
*   `tax_lines`: Taxes applied to the order.
*   `fulfillments`: An array tracking the fulfillment process of items in the order.
*   `refunds`: An array of any refunds issued.
*   `note`: Notes added to the order by the merchant.
*   `note_attributes`: Key-value pairs for structured notes.
*   `tags`: Tags associated with the order.
*   `test`: A boolean indicating if the order is a test order.


**Preprocessing in the `createShopifyOrder` Service**

The preprocessing stage is the first step in the integration process. It focuses on preparing the incoming Shopify order data for conversion into a HotWax Commerce order. Here's a breakdown of the key steps:

1. **Order Identification and Duplicate Check**

   * **Extract Shopify Order ID:** The service retrieves the Shopify order ID (e.g., "450789469") from the input JSON data using the `order.get("id")` method.
   * **Check for Duplicates:** It then queries the `OrderIdentification` entity in HotWax Commerce to see if an order with this Shopify ID has already been imported.
   * **Skip if Duplicate:** If a matching order is found, the current order is marked as a duplicate and will be skipped to prevent redundant data in the system.

2. **Configuration Retrieval and Filtering**

   * **Fetch Shopify Config:** The service retrieves the configuration for the specific Shopify store integration using the `shopifyConfigId` passed as an input parameter.
   * **Get Product Store ID:** From the `ShopifyConfig` entity, the service extracts the `productStoreId`, which is used in the next step.
   * **Load Properties:** The service reads the `ShopifyServiceConfig` properties file and looks up the property named `<productStoreId>.skip.order.import.tags`. This property value is expected to be a comma-separated list of tags.
   * **Tag-Based Filtering:** The service then compares the tags associated with the Shopify order to the tags in the `skip.order.import.tags` list. If a match is found, the order is marked as skipped and won't be imported.

**Key Points and Considerations**

* **Flexibility:** The `ShopifyServiceConfig` properties file allows for easy customization of which orders to import based on specific tags. This can be useful for filtering test orders, orders from specific sales channels, or any other order criteria you want to define.
* **Data Integrity:** The duplicate check is crucial for preventing duplicate orders in your HotWax Commerce system, ensuring data consistency and accuracy.

**Understanding `ShopifyHelper.getShopifyTypeMappedValue`**

This helper function seems designed to bridge the gap between Shopify's data model and HotWax Commerce's data model. It takes the following arguments:

1.  `delegator`: The OfBiz delegator for database operations.
2.  `shopId`: The ID of the Shopify shop.
3.  `mappedTypeId`: A string indicating the type of mapping being performed (e.g., "SHOPIFY_ORDER_SOURCE", "SHOP_ORD_CUST_CLASS", "SHOPIFY_PAYMENT_TYPE").
4.  `mappedKey`: The value from the Shopify order that needs to be mapped.
5.  `defaultValue`: A default value to return if no mapping is found.

The function  queries a database table (`ShopifyShopTypeMapping`) to find a corresponding `mappedValue` in HotWax Commerce for the given `mappedKey` and `mappedTypeId`. If no mapping exists, it returns the `defaultValue`.

**Scenarios in `createShopifyOrder`**

1.  **Sales Channel Mapping:**
    *   `mappedTypeId`: "SHOPIFY_ORDER_SOURCE"
    *   `mappedKey`: The value of the `source_name` field in the Shopify order (e.g., "web", "pos", "mobile_app").
    *   Purpose: Determine the sales channel in HotWax Commerce based on where the order originated in Shopify.

2.  **Customer Classification Mapping:**
    *   `mappedTypeId`: "SHOP_ORD_CUST_CLASS"
    *   `mappedKey`: Tags from the Shopify order.
    *   Purpose: Assign a customer classification in HotWax Commerce based on tags applied to the order in Shopify. This could be used for segmentation or reporting.

3.  **Payment Method Mapping:**
    *   `mappedTypeId`: "SHOPIFY_PAYMENT_TYPE"
    *   `mappedKey`: The payment gateway name from the Shopify order (e.g., "shopify_payments", "paypal").
    *   Purpose: Determine the payment method type in HotWax Commerce based on the payment gateway used in Shopify.

In the `createShopifyOrder` service, the `ShopifyHelper` class is utilized in the following additional scenarios:

1.  **Product and Variant Mapping:**
    *   The `ShopifyHelper.getProductId` function is used to retrieve the HotWax Commerce product ID corresponding to a Shopify variant ID. This is essential for associating order line items with the correct products in the HotWax system.
    *   If the product ID is not found and product creation is allowed, the service creates a new product in HotWax Commerce and associates it with the Shopify variant ID using `createShopifyShopProduct`.

2.  **Facility Mapping:**
    *   The `ShopifyHelper.getFacilityId` function is used to determine the HotWax Commerce facility ID based on the Shopify location ID where the order was fulfilled. This helps in managing inventory and fulfillment processes.

3.  **Pre-Order and Backorder Tag Mapping:**
    *   The `ShopifyHelper.getShopifyTypeMappedValue` function is used with `mappedTypeId` "SHOPIFY_PRODUCT_TAG" to retrieve the tags used in Shopify to indicate pre-order or backorder products. These tags are then used to determine if an order item should be marked as a pre-order or backorder in HotWax Commerce.


**Understanding use of SHOPIFY_PRODUCT_TAG**

**Purpose**
In this context, Shopify tags should be considered as indicators of pre-order or backorder products in HotWax Commerce.

**Parameters**

*   `mappedTypeId`: "SHOPIFY_PRODUCT_TAG"
    *   This tells the function to look for mappings related to product tags in the `ShopifyShopTypeMapping` table.
*   `mappedKey`: "ON_PRE_ORDER_PROD" or "ON_BACK_ORDER_PROD"
    *   These are the specific Shopify product tags you're interested in. 

**Logic**

1.  **Mapping Lookup:** The `getShopifyTypeMappedValue` function queries the `ShopifyShopTypeMapping` table. It searches for rows where:
    *   `mappedTypeId` is "SHOPIFY_PRODUCT_TAG"
    *   `mappedKey` is either "ON_PRE_ORDER_PROD" or "ON_BACK_ORDER_PROD"

2.  **Tag Retrieval:**  If matching rows are found, the function returns the corresponding `mappedValue` for each tag. These `mappedValue` strings are the tags that HotWax Commerce recognizes as indicating pre-order or backorder status.

3.  **Order Item Status:** The retrieved tags are then used to determine the availability status of the order items in HotWax Commerce.

    *   If a line item's product in Shopify has a tag that matches the mapped pre-order tag, the corresponding order item in HotWax Commerce is marked as a pre-order.
    *   Similarly, if a line item's product has a tag matching the mapped backorder tag, the HotWax Commerce order item is marked as a backorder.

**Example**

Let's say your `ShopifyShopTypeMapping` table has these entries:

| shopId   | mappedTypeId        | mappedKey            | mappedValue             |
| -------- | ------------------- | -------------------- | ----------------------- |
| "your-shop-id" | "SHOPIFY_PRODUCT_TAG" | "ON_PRE_ORDER_PROD" | "PreOrder"             |
| "your-shop-id" | "SHOPIFY_PRODUCT_TAG" | "ON_BACK_ORDER_PROD"  | "BackOrder"   |

In this scenario:

*   If a Shopify product has the tag "ON_PRE_ORDER_PROD", the corresponding HotWax Commerce order item will be marked as a pre-order.
*   If a Shopify product has the tag "ON_BACK_ORDER_PROD", the HotWax Commerce order item will be marked as a backorder.

