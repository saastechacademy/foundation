**Understanding the [Shopify Order Resource](https://shopify.dev/docs/api/admin-rest/2024-07/resources/order#resource-object) JSON**

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



The `ShopifyConfig` data is used in the `createShopifyOrder` service to retrieve configuration details necessary for processing the Shopify order. Here's a step-by-step explanation of how `ShopifyConfig` data is utilized:

1. **Retrieve Shopify Configuration:**
   - The service queries the `ShopifyConfig` entity using the `shopifyConfigId` provided in the context to get the configuration details.
   - This configuration includes the `productStoreId` and `shopId`.

2. **Set Product Store:**
   - The `productStoreId` from the `ShopifyConfig` is used to set the product store for the order.

3. **Filter Orders Based on Tags:**
   - The service checks if the order should be skipped based on tags and configuration settings from `ShopifyConfig`.

4. **Determine Facility Details:**
   - The `productStoreId` is used to retrieve the default facility ID from the product store configuration.

5. **Order Processing Logic:**
   - The `shopId` from the `ShopifyConfig` is used to map the Shopify order source to a channel ID.

### Pseudocode

1. **Retrieve Shopify Configuration:**
   ```java
   GenericValue shopifyConfig = EntityQuery.use(delegator).from("ShopifyConfig").where("shopifyConfigId", shopifyConfigId).queryOne();
   ```

2. **Set Product Store:**
   ```java
   String productStoreId = shopifyConfig.getString("productStoreId");
   ```

3. **Filter Orders Based on Tags:**
   ```java
   String skipOrdersTags = EntityUtilProperties.getPropertyValue("ShopifyServiceConfig", productStoreId + ".skip.order.import.tags", delegator);
   ```

4. **Determine Facility Details:**
   ```java
   GenericValue productStore = ProductStoreWorker.getProductStore(productStoreId, delegator);
   String defaultFacilityId = productStore.getString("inventoryFacilityId");
   ```

5. **Order Source Processing Logic:**
   ```java
   String channelId = ShopifyHelper.getShopifyTypeMappedValue(delegator, shopId, "SHOPIFY_ORDER_SOURCE", (String) order.get("source_name"), "UNKNWN_SALES_CHANNEL");
   ```


### Explanation of Code to Get Customer Locale Details

1. **Retrieve Customer Locale:**
   - The code checks if the `order` map contains a non-empty value for the key `customer_locale`.
   - If it does, it retrieves the `customer_locale` value and stores it in the `customerLocale` variable.
   - It then creates a `Locale` object using the `Locale.forLanguageTag` method, which converts the `customerLocale` string to a `Locale` object.
   - The `Locale` object is then converted to a string representation and stored in the `baseLocale` variable.
   - Finally, the `baseLocale` is put into the `serviceCtx` map with the key `locale`.

### Code
```java
// Get customer locale details
if (UtilValidate.isNotEmpty(order.get("customer_locale"))) {
    String customerLocale = (String) order.get("customer_locale");
    String baseLocale = new Locale(Locale.forLanguageTag(customerLocale).getLanguage(), "").toString();
    serviceCtx.put("locale", baseLocale);
}
```

### How Locale is Used in Ofbiz Framework

1. **Locale Initialization:**
   - The `Locale` object is initialized from the `serviceCtx` map using the key `locale`.

2. **Locale-Specific Data Conversion:**
   - The `Locale` object is used to convert data types, such as converting the `total_price` from the order to a `BigDecimal`.

3. **Service Context:**
   - The `Locale` object is added to the `serviceCtx` map, which is then used in subsequent service calls to ensure locale-specific data handling.

### Code Example
```java
// Initialize Locale from service context
Locale locale = (Locale) context.get("locale");

// Use Locale for data conversion
BigDecimal grandTotal = (BigDecimal) ObjectType.simpleTypeConvert(order.get("total_price"), "BigDecimal", null, locale);

// Add Locale to service context for subsequent service calls
serviceCtx.put("locale", locale);
```


### Business Requirements for Skip Order 

1. **Check for Existing Order:**
   - Query the `OrderIdentification` entity to see if an order with the same Shopify Order ID already exists. If it exists, skip the process.

2. **Filter Orders Based on Tags:**
   - Extract and clean tags from the order.
   - Check if the order should be skipped based on tags and configuration.

### Implementation Detail Design for Skip Order Tags

#### Pseudocode:

1. **Extract Tags from Order:**
   - Retrieve the tags from the `order` map.
   - Clean and process the tags.

2. **Retrieve Skip Tags Configuration:**
   - Fetch the skip tags configuration from the `ShopifyServiceConfig` properties file.

3. **Check Tags Against Configuration:**
   - Compare the tags from the order with the skip tags configuration.
   - If any tag matches the skip tags, set a flag to skip the order.

4. **Skip Order if Necessary:**
   - If the flag is set, skip the order creation process.

#### Code:

```java
// Extract and clean tags from the order
List<String> tags = UtilGenerics.checkList(order.get("tags"));
tags = tags.stream().map(String::trim).collect(Collectors.toList());

// Retrieve skip tags configuration from properties file
String skipTagsConfig = EntityUtilProperties.getPropertyValue("ShopifyServiceConfig", "skip.order.tags", delegator);
List<String> skipTags = Arrays.asList(skipTagsConfig.split(","));

// Check if the order should be skipped based on tags and configuration
boolean skipOrder = tags.stream().map(String::toLowerCase).anyMatch(skipTags::contains);


if (!skipOrder) {
    // Proceed with order creation
} else {
    // Skip the process
}
```

### Summary

- **Extract Tags from Order:** The tags are extracted from the `order` map and cleaned by trimming any whitespace.
- **Retrieve Skip Tags Configuration:** The skip tags configuration is fetched from the `ShopifyServiceConfig` properties file using the key `skip.order.tags`.
- **Check Tags Against Configuration:** The tags from the order are compared with the skip tags configuration. If any tag matches the skip tags, the `skipOrder` flag is set to `true`, and the order creation process is skipped.


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

**Explanation of the facilityId computation Logic**

1.  **Prioritize Shopify Location (If Applicable):** The code first attempts to determine the `facilityId` based on the `location_id` present in the Shopify order, but only if the order is not tagged as "SENDSALE". This is done using the `ShopifyHelper.getFacilityId` function, which looks up a mapping between Shopify locations and HotWax Commerce facilities.

2.  **Check Inventory Reservation Setting:** If the Shopify order doesn't have a `location_id`, or it's tagged as "SENDSALE", or no mapping is found, the code then checks the `reserveInventory` flag of the associated product store.

3.  **Use Default Facility:** If the product store has inventory reservation enabled (`reserveInventory` is "Y") *and* a default inventory facility (`inventoryFacilityId`) is specified, then that facility is used as the `facilityId`.

4.  **Fallback to "_NA_" Facility:** If none of the above conditions are met (i.e., no location ID, no location-to-facility mapping, no inventory reservation, or no default facility), the code defaults the `facilityId` to "_NA_". This ensures that the `facilityId` variable always has a value, even if it's a placeholder representing an unallocated order in the HotWax Commerce OMS.


The following HotWax Commerce internal services are called from the `createShopifyOrder` function:

1.  `customerDataSetup`
2.  `createTelecomNumber`
3.  `createContactMech`
4.  `createCommunicationEvent`
5.  `createSalesOrder`
6.  `checkAndAddProductComponents` (run asynchronously)
7.  `createShopifyShopOrder` (run asynchronously)
8.  `getPaidTransactionsAndCreateOrderPayment` (run asynchronously)
9.  `createOrderPaymentPreference` (may be called depending on order status)
10. `createCommunicationEventOrder` (run asynchronously, if applicable)

**Adjustments**  

The `itemAdjustments` data in HotWax Commerce is primarily derived from two sections of the Shopify Order JSON:

1.  **discount\_allocations:** This section within each line item details the discounts applied to that specific product. The code iterates through these allocations, extracts the discount amount and any associated discount code, and creates `EXT_PROMO_ADJUSTMENT` entries in `itemAdjustments`.

2.  **tax\_lines:** This section within each line item provides information about the taxes applied to the product. The code extracts the tax title, price, and rate, and creates `SALES_TAX` entries in `itemAdjustments`.

**Mapping**

| Shopify Order Field (within line\_items) | HotWax Commerce Field (in itemAdjustments) |
| :--------------------------------------- | :----------------------------------------- |
| discount\_allocations.amount             | amount (negated)                           |
| discount\_allocations.discount\_application\_index | Used to look up the discount code in `discounts` map |
| tax\_lines.title                         | comments                                   |
| tax\_lines.price                         | amount                                     |
| tax\_lines.rate                          | sourcePercentage                           |





****Shopify Order API** Analyze its key components and how they might map to the HotWax Commerce `createSalesOrder` API.

**Core Order Details**

*   `id`: (450789469) The unique identifier for this order within Shopify. This would typically be mapped to the `externalId` field in the HotWax `createSalesOrder` API.
*   `name`: ("#1001") The human-readable order name in Shopify. This could be mapped to the `orderName` field in HotWax.
*   `order_number`: (1001) The sequential order number within the Shopify store. This could potentially be used as another identifier in HotWax, perhaps in the `orderAttributes` list.
*   `created_at`, `updated_at`, `processed_at`: These timestamps indicate when the order was created, last updated, and processed in Shopify. The `created_at` value could be mapped to the `orderDate` field in HotWax.
*   `financial_status`: ("authorized") This indicates the financial state of the order. It would likely be mapped to the `statusId` field in HotWax, potentially with some translation between Shopify's statuses and HotWax's statuses.
*   `fulfillment_status`: ("partial") This shows the fulfillment status of the order. It could be used to determine the initial value of the `statusId` field in HotWax.
*   `currency`: ("USD") The currency used for the order in Shopify. This would be mapped to the `currencyCode` field in HotWax.
*   `presentment_currency`: ("CAD") The currency used to display prices to the customer in Shopify. This would be mapped to the `presentmentCurrencyCode` field in HotWax.
*   `total_price`, `subtotal_price`, `total_tax`: These fields represent the total price, subtotal, and total tax of the order in Shopify. They would be mapped to the `grandTotal`, a calculated subtotal (derived from line items), and a calculated total tax (derived from tax lines) in HotWax, respectively.

**Customer Information**

*   `customer`: This object contains detailed customer information:
    *   `id`: (207119551) The customer's unique identifier in Shopify. This would be mapped to the `customerExternalId` field in HotWax.
    *   `email`: ("bob.norman@mail.example.com") The customer's email address. This could be used to create or link a customer record in HotWax.
    *   `first_name`, `last_name`: The customer's first and last name. These would be used to create or link a customer record in HotWax.
    *   `phone`: ("+13125551212") The customer's phone number. This could be used to create a contact mechanism in HotWax.

**Addresses**

*   `billing_address`, `shipping_address`: These objects contain the billing and shipping addresses, respectively. The relevant fields (e.g., `address1`, `city`, `zip`, `country_code`) would be used to create `PostalAddress` contact mechanisms in HotWax.


**Example: Customer Handling**

In the Shopify integration code (`createShopifyOrder`), you'll find this line:

```java
result = dispatcher.runSync("customerDataSetup", serviceCtx);
```

This line calls the `customerDataSetup` service to either create a new customer in HotWax Commerce (if the customer doesn't exist) or retrieve the existing customer's ID. The `customerId` is then included in the `serviceCtx` map passed to `createSalesOrder`.

In the `createSalesOrder` function, you'll see that the `customerId` is used to associate the order with the correct customer record:

```java
storeOrderCtx.put("partyId", customerId);
storeOrderCtx.put("billToCustomerPartyId", customerId);
storeOrderCtx.put("shipToCustomerPartyId", customerId);
```

**Line Items**

*   `line_items`: This array contains objects representing each product in the order:
    *   `id`: (669751112) The unique identifier for the line item in Shopify.
    *   `product_id`: (7513594) The ID of the product in Shopify. This would need to be mapped to the corresponding product ID in HotWax.
    *   `variant_id`: (4264112) The ID of the product variant in Shopify.
    *   `title`: ("IPod Nano - Pink") The title of the product.
    *   `quantity`: (1) The quantity ordered.
    *   `price`: ("199.99") The price per unit. This would be mapped to the `unitPrice` field in HotWax.
    *   `sku`: ("IPOD-342-N") The SKU of the product. This could be used to identify the product in HotWax.
    *   `grams`: (500) The weight of the item in grams.
    *   `tax_lines`: This array contains information about taxes applied to the item. This would be used to create `OrderAdjustment` entries in HotWax.
    *   `total_discount`: ("5.00") The total discount applied to the item. This would be used to create `OrderAdjustment` entries in HotWax.

**Other Fields**

*   `discount_codes`: This array contains information about discount codes applied to the order. This would be used to create `OrderAdjustment` entries in HotWax.
*   `shipping_lines`: This array contains information about shipping methods and costs. This would be used to populate the `shipGroup` list in HotWax.
*   `tax_lines`: This array contains information about taxes applied to the entire order. This would be used to create `OrderAdjustment` entries in HotWax.
*   `total_discounts`: ("0.00") The total discount applied to the order.
*   `total_weight`: (300) The total weight of the order in grams.
*   `note`: ("Customer changed their mind.") Notes added to the order. This could be mapped to the `note` field in HotWax.
*   `tags`: ("imported, vip") Tags associated with the order. These could be mapped to the `tags` field in HotWax.


**"POS sales channel"**

```java
boolean isCashSaleOrder = (UtilValidate.isEmpty(order.get("shipping_lines")) && "POS_SALES_CHANNEL".equals(channelId) && "fulfilled".equals(order.get("fulfillment_status")));
```

This condition checks if:

1.  The order has no shipping lines (`order.get("shipping_lines")` is empty).
2.  The `channelId` (derived from the `source_name`) is "POS\_SALES\_CHANNEL."
3.  The `fulfillment_status` is "fulfilled."

If all these conditions are true, the variable `isCashSaleOrder` is set to `true`, indicating a potential POS order.

The code then uses this `isCashSaleOrder` flag to set the `shipmentMethodTypeId` to "POS\_COMPLETED":

```java
if (isCashSaleOrder) {
    shipmentMethodTypeId = "POS_COMPLETED";
}
```

This suggests that the code is prepared to handle POS orders and assign them a specific shipping method. However, it doesn't explicitly map the sales channel to "POS\_SALES\_CHANNEL" as you mentioned.

To fully implement the desired logic, you would need to modify the code to:

1.  Explicitly map the sales channel to "POS\_SALES\_CHANNEL" when `isCashSaleOrder` is true.
2.  Ensure that "POS\_COMPLETED" is the correct shipping method ID for your "pos completed" shipping method in HotWax Commerce.

The Shopify Order attributes that are mapped to `OrderItemAttributes` in HotWax Commerce, according to the provided code, are:

*   **`properties`:** Custom properties associated with line items in the Shopify order are mapped as `OrderItemAttribute` entities in HotWax Commerce. The `name` and `value` fields from each `properties` entry are used as the `attrName` and `attrValue` in the `OrderItemAttribute` entity.
*   **Pre-order and Backorder Tags:** If a product in the Shopify order is tagged as "ON\_PRE\_ORDER\_PROD" or "ON\_BACK\_ORDER\_PROD," this information is stored in an `OrderItemAttribute` with the name "PreOrderItemProperty" or "BackOrderItemProperty" respectively.
*   **Store Pickup Property:** If a line item in the Shopify order has a property indicating store pickup, this information is stored in an `OrderItemAttribute` with the name "StorePickupItemProperty."

The Shopify Order data elements that map to `OrderItemAttributes` in HotWax Commerce are:

*   **`properties`:** Custom properties associated with line items in the Shopify order.
*   **Pre-order and Backorder Tags:** Tags indicating if a product is on pre-order ("ON\_PRE\_ORDER\_PROD") or backorder ("ON\_BACK\_ORDER\_PROD").
*   **Store Pickup Property:** A property indicating if a line item is for store pickup.

Based on the provided code (`createShopifyOrder.txt`) and the Shopify Order API documentation, the following Shopify order data is mapped to `OrderAttribute` in HotWax Commerce:

*   **`note_attributes`:** Any custom note attributes present in the Shopify order JSON are mapped as individual `OrderAttribute` entities in HotWax Commerce. The `name` and `value` fields from each `note_attributes` entry are directly used as the `attrName` and `attrValue` in the `OrderAttribute` entity.
*   **`user_id`:** The ID of the staff member who created the order in Shopify is stored as an `OrderAttribute` with the name `shopify_user_id`.

Based on the provided code (`createShopifyOrder.txt`) and the Shopify Order API documentation, the following Shopify order attributes are mapped to `OrderAttribute` or `OrderItemAttribute` in HotWax Commerce:

### Order Attributes:

*   **`note_attributes`:**
    *   Any custom note attributes present in the Shopify order JSON are mapped as individual `OrderAttribute` entities in HotWax Commerce.
    *   The `name` and `value` fields from each `note_attributes` entry are directly used as the `attrName` and `attrValue` in the `OrderAttribute` entity.
    *   Example from sample JSON:
        ```json
        "note_attributes": [
            {
              "name": "custom name",
              "value": "custom value"
            }
          ]
        ```
        This would be stored as an `OrderAttribute` with `attrName` = "custom name" and `attrValue` = "custom value."

*   **`user_id`:**
    *   The ID of the staff member who created the order in Shopify is stored as an `OrderAttribute` with the name `shopify_user_id`.

### Order Item Attributes:

*   **`properties`:**
    *   Custom properties associated with line items in the Shopify order are mapped as `OrderItemAttribute` entities in HotWax Commerce.
    *   The `name` and `value` fields from each `properties` entry are used as the `attrName` and `attrValue` in the `OrderItemAttribute` entity.
    *   Example from sample JSON:
        ```json
        "properties": [
            {
              "name": "custom engraving",
              "value": "Happy Birthday Mom!"
            }
          ]
        ```
        This would be stored as an `OrderItemAttribute` with `attrName` = "custom engraving" and `attrValue` = "Happy Birthday Mom!"

*   **Pre-order and Backorder Tags:**
    *   If a product in the Shopify order is tagged as "ON\_PRE\_ORDER\_PROD" or "ON\_BACK\_ORDER\_PROD," this information is stored in an `OrderItemAttribute` with the name "PreOrderItemProperty" or "BackOrderItemProperty" respectively.

*   **Store Pickup Property:**
    *   If a line item in the Shopify order has a property indicating store pickup, this information is stored in an `OrderItemAttribute` with the name "StorePickupItemProperty."
