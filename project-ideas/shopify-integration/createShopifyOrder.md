#createShopifyOrder


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

5. **Order Processing Logic:**
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

