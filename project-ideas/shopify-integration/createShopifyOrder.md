**Understanding the [Shopify Order Resource](https://shopify.dev/docs/api/admin-rest/2024-07/resources/order#resource-object) JSON**

Think of the order JSON as a comprehensive snapshot of a customer's purchase on your Shopify store. It includes everything from basic details about the order itself to information about the customer, the products they bought, shipping details, payment information, and much more.



**Top-Level Structure**

The top level of the JSON contains essential order attributes:

* `id`:  The unique numerical identifier of the order in Shopify's system.
* `name`:  A human-readable order name (e.g., "#1001").
* `order_number`: A sequential order number (e.g., 1001).
* `created_at`, `updated_at`:  Timestamps indicating when the order was created and last modified.
* `cancelled_at`: The date and time when the order was canceled. Returns null if the order isn't canceled.
* `closed_at`: The date and time (ISO 8601 format) when the order was closed. Returns null if the order isn't closed.
* `financial_status`:  Reflects the payment status of the order (e.g., "paid", "pending", "authorized").
* `fulfillment_status`: Indicates whether the order has been shipped or is still pending (e.g., "fulfilled", "partial").
* `total_price`:  The total amount the customer paid, including taxes and shipping.
* `total_price_set`:  Set of the total amount the customer paid, including taxes and shipping.
* `currency`: The three-letter code (ISO 4217) for the currency used in the order.
* `presentment_currency`: The currency used for the order.
* `customer_locale`: The locale of the customer placing the order.
* `tags`: Tags attached to the order, formatted as a string of comma-separated values. Tags are additional short descriptors, commonly used for filtering and searching

**Nested Objects**

The order JSON includes several nested objects that provide more detailed information:

* **`customer`:** Holds information about the customer who placed the order, including their ID, name, email address, and marketing preferences. This value might be null if the order was created through Shopify POS.
* **`billing_address`, `shipping_address`:** Contain the billing and shipping address details, respectively. Each address has fields like `name`, `address1`, `city`, `province`, `zip`, and `country`.
* **`discount_applications`:** Contain the information about discounts applied to the order. It have fields like `type`, `value`, `description`.
* **`line_items`:** An array listing each product purchased in the order. Each line item includes details like `product_id`, `variant_id`, `quantity`, `price`, and tax information.
* **`shipping_lines`:**  An array of shipping methods chosen for the order, with their associated prices and other details.
* **`tax_lines`:** An array of tax line objects, each of which details the taxes applicable to the order.

**Customer Information**

* **customer:** An object containing the customer's details:
*  'id'
*  'email'
*  'first_name', 'last_name'
*  'state'
*  'email'
*  'phone'
*  'addresses'

**Billing and Shipping Addresses**

*   **billing_address**:  The billing address of the customer.
*   **shipping_address**: The shipping address (if different from billing).

**Line Items**

*   **line_items**: An array of objects representing the products ordered:
    *   'id'
    *   'product_id', 'variant_id'
    *   'title'
    *   'quantity'
    *   'fulfillable_quantity' (The amount available to fulfill)
    *   'fulfillment_status' (Valid values: null, fulfilled, partial, and not_eligible)
    *   'origin_location'
    *   'price', 'total_discount'
    *   'tax_lines' (taxes applied)
    *   'properties' (An array of custom information for the item that has been added to the cart. Often used to provide product customization options)
    *   'discount_allocations'

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


## **Processing in the `createShopifyOrder` Service**

The preprocessing stage is the first step in the integration process. It focuses on preparing the incoming Shopify order data for conversion into a HotWax Commerce order. Here's a breakdown of the key steps:

### Business Requirements for Skip Order 

1. **Order Identification and Duplicate Check**

    *  The duplicate check is crucial for preventing duplicate orders in your HotWax Commerce system, ensuring data consistency and accuracy.

   * **Extract Shopify Order ID:** The service retrieves the Shopify order ID (e.g., "450789469") from the input JSON data using the `order.get("id")` method.

   * **Check for Duplicates:** It then queries the `OrderIdentification` entity in HotWax Commerce to see if an order with this Shopify ID has already been imported.

   * **Skip if Duplicate:** If a matching order is found, the current order is marked as a duplicate and will be skipped to prevent redundant data in the system.

2.  **Filter Orders Based on Tags:**
    *  Extract and clean tags from the order.
Check if the order should be skipped based on tags and configuration.
### Configuration Retrieval and Filtering

The `ShopifyConfig` data is used in the `createShopifyOrder` service to retrieve configuration details necessary for processing the Shopify order. 

1. **Retrieve Shopify Configuration:**
   - The service queries the `ShopifyConfig` entity using the `shopifyConfigId` provided in the context to get the configuration details.
   - This configuration includes the `productStoreId` and `shopId`.

2. **Set Product Store:**
   - The `productStoreId` from the `ShopifyConfig` is used to set the product store for the order.

3. **Filter Orders Based on Tags:**
   - Extract and clean tags from the order.
   - Check if the order should be skipped based on tags and configuration.

#### Pseudocode

- **Retrieve Shopify Configuration:**
   ```java
   GenericValue shopifyConfig = EntityQuery.use(delegator).from("ShopifyConfig").where("shopifyConfigId", shopifyConfigId).queryOne();
   ```

-  **Set Product Store:**
   ```java
   String productStoreId = shopifyConfig.getString("productStoreId");
   ```

**Implementation Detail Design for Skip Order Tags**

a. **Extract Tags from Order:**
   - Retrieve the tags from the `order` map.
   - Clean and process the tags.

b. **Retrieve Skip Tags Configuration:**
   - Fetch the skip tags configuration from the `ShopifyServiceConfig` properties file.

c. **Check Tags Against Configuration:**
   - Compare the tags from the order with the skip tags configuration.
   - If any tag matches the skip tags, set a flag to skip the order.

d. **Skip Order if Necessary:**
   - If the flag is set, skip the order creation process.

#### Code:

```java
// Extract and clean tags from the order
List<String> tags = UtilGenerics.checkList(order.get("tags"));
tags = tags.stream().map(String::trim).collect(Collectors.toList());

// Retrieve skip tags configuration from properties file
String skipOrdersTags = EntityUtilProperties.getPropertyValue("ShopifyServiceConfig", productStoreId + ".skip.order.import.tags", delegator);

List<String> skipTags = Arrays.asList(skipTagsConfig.split(","));

// Check if the order should be skipped based on tags and configuration
boolean skipOrder = tags.stream().map(String::toLowerCase).anyMatch(skipTags::contains);


if (!skipOrder) {
    // Proceed with order creation
} else {
    // Skip the process
}
```
**Key Points and Considerations**

* **Flexibility:** The properties file allows for easy customization of which orders to import based on specific tags. This can be useful for filtering test orders, orders from specific sales channels, or any other order criteria you want to define.

### Configuration Setting used during Order Import 

Here's how `SystemPropery` , `ProductStore` and `ProductStoreSetting` entities are utilized for various configuration accross the order import process.

1. **Determine Default Facility:**
   - The `productStoreId` is used to retrieve the default facility ID from the product store entity when `reserveInventory` is `Y`.


2. **Allow split setting for shipGroups:**
   - The `ProductStore` entity includes a setting that determines whether splitting is allowed. This flag controls whether a ship group can be split during the subsequent fulfillment process.

3. **Auto Approval of Order:**
    - An open order becomes eligible for the fulfillment process only when it is approved. This setting of `ProductStore` allows the order to be automatically approved upon creation.

4. **Bill Information of Order:**
   - Check `ProductStoreSetting` of type - **SAVE_BILL_TO_INF**. If it is **Y** then only save Billing info of customer in Order


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
    *   **Purpose**: Determine the sales channel in HotWax Commerce based on where the order originated in Shopify.

2.  **Customer Classification Mapping:**
    *   `mappedTypeId`: "SHOP_ORD_CUST_CLASS"
    *   `mappedKey`: Tags from the Shopify order.
    *   **Purpose**: Assign a customer classification in HotWax Commerce based on tags applied to the order in Shopify. This could be used for segmentation or reporting.

3.  **Payment Method Mapping:**
    *   `mappedTypeId`: "SHOPIFY_PAYMENT_TYPE"
    *   `mappedKey`: The payment gateway name from the Shopify order (e.g., "shopify_payments", "paypal").
    *   Purpose: Determine the payment method type in HotWax Commerce based on the payment gateway used in Shopify.


### Order Source Processing Logic:
   ```java
   String channelId = ShopifyHelper.getShopifyTypeMappedValue(delegator, shopId, "SHOPIFY_ORDER_SOURCE", (String) order.get("source_name"), "UNKNWN_SALES_CHANNEL");
   ```

### POS Sales Channel

Handle POS orders, assign them a specific shipping method "POS_COMPLETED".

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
### **FacilityId computation Logic**

1.  **Prioritize Shopify Location (If Applicable):** The code first attempts to determine the `facilityId` based on the `location_id` present in the Shopify order, but only if the order is not tagged as "**SENDSALE**". 
    - When locationId is not empty and **isCashSaleOrder** is true then using the `ShopifyHelper.getFacilityId` function, which looks up a mapping between Shopify locations and HotWax Commerce facilities.

2.  **Use Default Facility:** If isCashSaleOrder is not true and the product store has inventory reservation enabled (`reserveInventory` is "Y") *and* a default inventory facility (`inventoryFacilityId`) is specified, then that facility is used as the `facilityId`.

3.  **Fallback to "_NA_" Facility:** If none of the above conditions are met (i.e., no location ID, no location-to-facility mapping, no inventory reservation, or no default facility), the code defaults the `facilityId` to "_NA_". This ensures that the `facilityId` variable always has a value, even if it's a placeholder representing an unallocated order in the HotWax Commerce OMS.

```java
if (UtilValidate.isNotEmpty(locationId)) {
    if (isCashSaleOrder) {
        facilityId = ShopifyHelper.getFacilityId(delegator, shopifyConfigId, locationId);
    } else {
        facilityId = defaultFacilityId;
    }
} else {
    facilityId = "_NA_";
}
```

### Managing Customer Data in the System

This section of code handles the integration of customer data from Shopify into the system. It involves retrieving customer information from the order, checking for existing customers, and creating new customer records if necessary. Here's a breakdown of the logic and purpose behind each part:

1. **Retrieving Customer Data:**
   - The customer data is fetched from the Shopify order using `order.get("customer")`.
   - `UtilGenerics.checkMap(order.get("customer"))` ensures that the data is cast to a `Map<String, Object>`, making it easier to work with.

2. **Handling the Customer External ID:**
   - If the customer data is not empty, the `customerExternalId` is extracted from the Shopify customer ID (`customer.get("id").toString()`).

3. **Checking for Existing Customers:**
   - The system checks if a customer with the same Shopify ID (`SHOPIFY_CUST_ID`) already exists in the `PartyIdentification` entity.
   - If an existing party is found, the `partyId` is added to the `serviceCtx` to associate the order with this customer.

4. **Party Classification:**
   - The system checks if the `PartyClassificationGroup` associated with `channelId` exists. If it does, the customer is classified under this group.
   - This classification helps in organizing customers based on the sales channel or other criteria.
   ```java
    GenericValue partyClassificationGroup = EntityQuery.use(delegator).from("PartyClassificationGroup")
        .where("partyClassificationGroupId", channelId)
        .cache().queryOne();
    if (partyClassificationGroup != null) serviceCtx.put("partyClassifications", UtilMisc.toList(channelId));

5. **Setting Up Party Identifications and Other Data:**
   - The customer's external ID is set as a party identification with the type `SHOPIFY_CUST_ID`.
   - Other essential data, such as the customer's role (`roleTypeId`), first name, last name, status, email, and phone number, are also added to the `serviceCtx`.

6. **Enabling or Disabling the Customer:**
   - The customer's status is checked, and if the status is "disabled" in Shopify, the customer is marked as disabled (`enabled = "N"`).

7. **Creating or Updating the Customer:**
   - The `customerDataSetup` service is called with the prepared `serviceCtx` to create or update the customer in the system.
   - If the service is successful, the `customerPartyId` is retrieved and used for further processing.

8. **Handling Missing Customer Data:**
   - If the customer data is empty, `customerPartyId` is set to `_NA_`, indicating that no valid customer data was found.


### Customer Classification 

HotWax Commerce employs a systematic process to deduce the `customerClassificationId` from a Shopify order. It leverages the `ShopifyShopTypeMapping` entity, which acts as a bridge between Shopify customer tags and their corresponding classifications within the HotWax Commerce system.

#### Process Breakdown

1.  **Retrieve Customer Class Mappings:**
    *   The service begins by fetching a list of `customerClassMappings` from the `ShopifyShopTypeMapping` entity. These mappings are specifically filtered to include only those with the `mappedTypeId` of "SHOP_ORD_CUST_CLASS," indicating their relevance to customer classification.
    *   The `shopId` associated with the Shopify order is also used to ensure that the retrieved mappings are specific to the relevant Shopify shop.

2.  **Check for Tags and Mappings:**
    *   The service then verifies if both the `customerClassMappings` list and the `tags` associated with the Shopify order are not empty. This check is essential to proceed with the mapping process only if relevant data is available.

3.  **Match Tags with Mappings:**
    *   If both tags and mappings exist, the service iterates through the `customerClassMappings` and attempts to find a mapping whose `mappedKey` (representing a Shopify tag) matches any of the tags present in the order.
    *   The matching is performed in a case-insensitive manner using `equalsIgnoreCase`.

4.  **Extract and Set `customerClassificationId`**:
    *   If a matching mapping is found, it signifies that the Shopify order contains a tag that corresponds to a predefined customer classification in HotWax Commerce.
    *   The `mappedValue` from the matching `customerClassEnum` (which represents the HotWax Commerce `customerClassificationId`) is then extracted and placed into the `serviceCtx` map.
    *   This `serviceCtx` is subsequently used when creating the sales order in HotWax Commerce, ensuring that the customer associated with the order is assigned the appropriate classification.

```java
List<GenericValue> customerClassMappings = EntityQuery.use(delegator).from("ShopifyShopTypeMapping").where("shopId", shopId, "mappedTypeId", "SHOP_ORD_CUST_CLASS").cache().queryList();

if (UtilValidate.isNotEmpty(customerClassMappings) && UtilValidate.isNotEmpty(tags)) {
    GenericValue customerClassEnum = customerClassMappings.stream().filter(m ->
        tags.stream().anyMatch(t -> t.equalsIgnoreCase(m.getString("mappedKey")))).findFirst().orElse(null);
    if (customerClassEnum != null) {
        serviceCtx.put("customerClassificationId", customerClassEnum.getString("mappedValue"));
    }
}
```
#### In Conclusion

The process of deducing the `customerClassificationId` in the `createShopifyOrder` service involves retrieving relevant mappings from the `ShopifyShopTypeMapping` entity, comparing the Shopify order tags with these mappings, and extracting the corresponding HotWax Commerce classification ID if a match is found. This enables the system to categorize customers based on their Shopify tags, facilitating targeted marketing, personalized experiences, and streamlined order management within the HotWax Commerce OMS.

### Order Email and Phone Details

#### Overview:
The process involves extracting the phone number and email address from the Shopify order data, validating and formatting these details, and then creating corresponding contactMech in the Hotwax system. The results are stored in the order context for subsequent use.

#### Process Flow:

1. **Extracting and Validating Phone Number:**
   - **Input**: Phone number from the Shopify order (`order.phone`).
   - **Validation**: 
     - The phone number is processed using the **getMapForContactNumber** service. This service validates the format of the phone number and splits it into components such as `countryCode`, `areaCode`, and `contactNumber`.
     - If the phone number is valid and complete, it proceeds to the next step.
   - **Output**: 
     - A telecom number contact mechanism is created in Hotwax using the parsed phone number details.
     - The resulting `contactMechId` for the phone number is captured.

2. **Extracting and Validating Email Address:**
   - **Input**: Email address from the Shopify order (`order.email`).
   - **Validation**:
     - The email address is checked for non-emptiness.
   - **Output**:
     - An email contact mechanism is created in Hotwax, and the corresponding `contactMechId` is obtained.

3. **Mapping Contact Details to the Order:**
   - **Input**:
     - The `contactMechId` for both the phone number and email, if available.
   - **Output**:
     - A map (`orderContacts`) is created, linking the order to its associated contact mechanisms.
     - The phone number is mapped under the key `phone`, and the email under `email`, each holding their respective `contactMechId`.

#### Mapping Summary:

| Shopify Field     | Hotwax Field            | Description                           |
|-------------------|-------------------------|---------------------------------------|
| order.phone     | TelecomNumber.contactMechId | Phone number parsed and stored as telecom contact. |
| order.email     | ContactMech.contactMechId   | Email address stored as email contact. |

### Tracking Numbers, User Attributes, and Order Notes from Shopify to Hotwax

#### Objective:
It extends the process of integrating data from Shopify orders into Hotwax Commerce, focusing on tracking numbers for fulfilled orders, user attributes, and order notes. These elements ensure that critical order information is accurately captured and utilized within the Hotwax system.

#### Overview:
The process involves three key areas:
1. Adding tracking numbers to order tags when an order is fulfilled.
2. Mapping user attributes and note attributes from Shopify to Hotwax.
3. Sanitizing and storing order notes.

### Process Flow:

#### 1. Adding Tracking Numbers to Tags:
- **Condition**: 
  - This step is triggered only if the Shopify order's fulfillment status is `"fulfilled"`.
- **Input**:
  - The `fulfillments` list from the Shopify order, containing details about each fulfillment event.
- **Process**:
  - For each fulfillment event that includes a tracking number, a tag is created and added to the `tagsList`. 
  - The tag is formatted as `"TrackingNo-<TrackingCompany>-<TrackingNumber>"`, combining the tracking company name and the tracking number.
- **Output**:
  - The `tagsList` is updated with tracking information and added to the service context (`serviceCtx`).

#### 2. Mapping Order Attributes to Note Attributes:

*   **`note_attributes`:** Any custom note attributes present in the Shopify order JSON are mapped as individual `OrderAttribute` entities in HotWax Commerce. The `name` and `value` fields from each `note_attributes` entry are directly used as the `attrName` and `attrValue` in the `OrderAttribute` entity.

*   **`note_attributes`:**
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
    - The ID of the staff member who created the order in Shopify is stored as an `OrderAttribute` with the name `shopify_user_id`.
    - This attribute includes a description `"Shopify User Id"`.


#### 3. Sanitizing and Storing Order Notes:
- **Input**: 
  - The `note` field from the Shopify order.
- **Process**:
  - The note is sanitized by removing HTML tags and comments, ensuring that only plain text is stored.
  - The sanitized note is added to the `noteList`.
- **Output**:
  - The `noteList` is added to the service context (`serviceCtx`) if it contains any notes.

### Mapping Summary:

| Shopify Field           | Hotwax Field                  | Description                                                      |
|-------------------------|-------------------------------|------------------------------------------------------------------|
| `fulfillment_status`     | `tagsList`                    | Tracking numbers are added to tags if the order is fulfilled.    |
| `user_id`               | `orderAttributes`             | Maps Shopify User ID as an order attribute.                      |
| `note_attributes`       | `orderAttributes`             | Maps Shopify note attributes, truncating where necessary.        |
| `note`                  | `noteList`                    |       |

### Processing Order Date, Status, and Store Settings from Shopify to Hotwax

#### Objective:
This section of the document outlines the process for mapping and processing order dates, statuses, and store-specific settings from a Shopify order into the Hotwax Commerce system. These steps ensure that the order is correctly timestamped, its status is accurately captured, and store-specific configurations are applied.

#### Overview:
The process involves several key components:
1. Converting and mapping order dates.
2. Handling order status based on Shopify's `created_at`, `cancelled_at`, and `closed_at` fields.
3. Applying store-specific settings, such as automatic approval and allowing split shipments.

### Process Flow:

#### 1. Mapping Order Date:
- **Input**: 
  - The `created_at` field from the Shopify order, representing the order creation date and time.
- **Process**:
  - The `created_at` timestamp is converted into a specific date-time pattern using `CommerceDateTime.getOffsetDateTimeInPattern`.
  - The time zone information is considered during this conversion to ensure accurate date-time representation in the system.
- **Output**:
  - The converted `orderDate` is stored in the service context (`serviceCtx`) under the key `"orderDate"`.

#### 2. Handling Order Status:
- **Input**: 
  - The `cancelled_at`, `closed_at`, and `created_at` fields from the Shopify order.
- **Process**:
  - **Cancelled Orders**:
    - If the `cancelled_at` field is present, the order status is set to `"ORDER_CANCELLED"`.
    - The order status date-time is set to the `cancelled_at` value.
    - The facility ID is set to `"GENERAL_OPS_PARKING"`, indicating that the order should be handled in a specific facility due to its cancellation.
  - **Completed Orders**:
    - If the `closed_at` field is present and the order is not cancelled, the status is set to `"ORDER_COMPLETED"`.
    - The order status date-time is set to the `closed_at` value.
    - Similarly, the facility ID is set to `"GENERAL_OPS_PARKING"`.
  - **Created Orders**:
    - If neither `cancelled_at` nor `closed_at` is present, the order is considered as newly created, and the status is set to `"ORDER_CREATED"`.
    - The order status date-time remains as the `created_at` value.
- **Output**:
  - The `orderStatusDatetime` is stored in `serviceCtx` under the key `"orderStatusDatetime"`.
  - The `statusId` is also added to `serviceCtx` to reflect the current status of the order.

#### 3. Applying Store-Specific Settings:
- **Input**:
  - The `productStore` object containing store-specific settings.
- **Process**:
  - **Automatic Approval**:
    - The `autoApproveOrder` flag is checked from the `productStore`. If it is not null, its value is used to determine if the order should be automatically approved.
  - **Allowing Split Shipments**:
    - The `allowSplit` flag is derived from the `productStore`. If this setting is `"N"`, split shipments are disallowed (`allowSplit = false`); otherwise, they are allowed (`allowSplit = true`).
- **Output**:
  - The `allowSplit` value determines whether the order can be split during fulfillment and is stored in the process context.
  - The `productStoreId` is stored in `serviceCtx` to link the order to its originating store.
  - The currency codes (`currencyCode` and `presentmentCurrencyCode`) and `grandTotal` are also stored in `serviceCtx` to ensure correct financial handling.

### Key Considerations:
- **Date-Time Accuracy**: The order dates are converted with respect to time zones to ensure accurate tracking and processing within the Hotwax system.
- **Store Settings**: Handling store-specific configurations allows for flexible order processing, including options like automatic order approval and split shipments.
- **Order Status Handling**: The system correctly categorizes orders as created, completed, or cancelled, ensuring they are processed accordingly.

### Mapping Summary:

| Shopify Field           | Hotwax Field                  | Description                                                          |
|-------------------------|-------------------------------|----------------------------------------------------------------------|
| created_at            | orderDate                   | Order creation date, converted to the specific format.               |
| cancelled_at          | orderStatusDatetime         | Date when the order was cancelled, if applicable.                    |
| closed_at             | orderStatusDatetime         | Date when the order was completed, if applicable. 
| currency        | currencyCode                | Currency used for the order.                                        
| presentment_currency | presentmentCurrencyCode | Presentment currency code for financial transactions.               |
| order.total_price            | grandTotal                  | The total amount for the order.                                      |

### Managing Order Identifications from Shopify to Hotwax

#### Objective:
This section describes how different order identifications from a Shopify order are captured and mapped into the Hotwax Commerce system. The process ensures that unique identifiers, such as order numbers, names, and external IDs, are accurately stored and associated with the order in the system.

#### Overview:
The system manages three different types of order identifications:
1. Shopify Order Number (`SHOPIFY_ORD_NO`)
2. Shopify Order Name (`SHOPIFY_ORD_NAME`)
3. Shopify Order External ID (`SHOPIFY_ORD_ID`)

These identifiers are stored in a list of maps within the service context (`serviceCtx`), allowing for easy reference and retrieval during order processing.

### Process Flow:

#### 1. Capture Order Number:
- **Input**: 
  - The `order_number` field from the Shopify order.
- **Process**:
  - If `order_number` is present and not empty, it is extracted and converted to a string.
  - A new map is created with `orderIdentificationTypeId` set to `"SHOPIFY_ORD_NO"` and `idValue` set to the extracted order number.
  - This map is added to the `orderIdentifications` list.
- **Output**:
  - The Shopify order number is captured and stored in the identification list.

#### 2. Capture Order Name:
- **Input**: 
  - The `name` field from the Shopify order.
- **Process**:
  - If `name` is present and not empty, it is extracted and converted to a string.
  - A new map is created with `orderIdentificationTypeId` set to `"SHOPIFY_ORD_NAME"` and `idValue` set to the extracted order name.
  - This map is added to the `orderIdentifications` list.
  - The order name is also stored separately in the service context under the key `"orderName"`.
- **Output**:
  - The Shopify order name is captured and stored in the identification list and the service context.

#### 3. Capture Order External ID:
- **Input**: 
  - The `orderExternalId`, which may have been set earlier in the process.
- **Process**:
  - If `orderExternalId` is present and not empty, it is used to create a map with `orderIdentificationTypeId` set to `"SHOPIFY_ORD_ID"` and `idValue` set to the external ID.
  - This map is added to the `orderIdentifications` list.
- **Output**:
  - The Shopify order external ID is captured and stored in the identification list.

### Mapping Summary:

| Shopify Field              | Hotwax Field                   | Description                                                           |
|----------------------------|--------------------------------|-----------------------------------------------------------------------|
| order_number             | orderIdentifications['SHOPIFY_ORD_NO'] | Unique order number assigned by Shopify.                             |
| name                     | orderIdentifications['SHOPIFY_ORD_NAME'] | Order name provided in Shopify, stored for easy reference.           |
| id                        | orderIdentifications['SHOPIFY_ORD_ID'] | External ID associated with the order, used for tracking.            |

### Handling Order Ship Groups from Shopify to Hotwax

#### Objective:
This section details the process of managing order ship groups from Shopify orders and how these groups are structured and stored in Hotwax Commerce. The process includes handling fulfillment locations, grouping line items, and managing fulfilled quantities.

#### Overview:
When processing an order from Shopify, it's crucial to group line items based on specific criteria, such as fulfillment locations, pickup store properties, and other tags configured in the system. This section explains how line items are managed and grouped into ship groups, focusing on the use of properties like `pickupstore`, and configuration settings such as `PRE_SLCTD_FAC_TAG`, `ORD_ITM_PICKUP_FAC`, and `ORD_ITM_SHIP_FAC`.

### Process Flow:

#### 1. Initialize Order Ship Groups:
- **Input**: 
  - An empty list `orderShipGroups` is initialized to hold the grouped line items.
  - A map `shipGroupList` is initialized to store lists of line items grouped by FacilityId.
  - A map `fulfilledItemMap` is initialized to track the fulfilled quantity of each line item by its ID.

#### 2. Handling Fulfillments:
- **Input**: 
  - The `fulfillments` list from the Shopify order.
- **Process**:
  - If the `defaultFacilityId` is empty, iterate over each fulfillment.
  - For each fulfillment with a status of `"success"`, determine the `fulfillmentFacilityId` by converting the `location_id` using `ShopifyHelper`.
  - Group the line items under their corresponding `fulfillmentFacilityId` in the `shipGroupList`.
  - Track the fulfilled quantity of each line item in `fulfilledItemMap` by adding up quantities across fulfillments.
- **Output**:
  - `shipGroupList` now contains lists of line items grouped by `fulfillmentFacilityId`.
  - `fulfilledItemMap` tracks the fulfilled quantity of each line item.

#### 3. Managing Line Items in Ship Groups Using Properties

**Line Item Properties and Grouping:**
Each line item in an order may have associated properties that dictate how it should be processed. The primary property used for grouping in this context is `pickupstore`, which indicates whether the item is intended for store pickup. If an item has this property, it is grouped separately from other items that do not share this characteristic.

- **Pickup Store Grouping:** 
  - When a line item has the `pickupstore` property, it is separated into its own ship group. This ensures that items meant for pickup are handled differently from items that will be shipped to the customer.
  - The system checks if the item has already been fulfilled and adjusts the quantity accordingly before adding it to the pickup ship group.

- **Non-Pickup Items:**
  - Items that do not have the `pickupstore` property are grouped based on their origin location or a pre-selected facility, depending on the configuration settings.

**Using `PRE_SLCTD_FAC_TAG`, `ORD_ITM_PICKUP_FAC`, and `ORD_ITM_SHIP_FAC`:**
To enhance the flexibility of fulfillment processing, the system allows for pre-selection of fulfillment facilities based on tags and specific settings configured in the product store.

- **PRE_SLCTD_FAC_TAG:**
  - **Purpose:** This tag is retrieved from the product store settings and indicates a specific tag that, if present in the order, will trigger the use of pre-configured fulfillment facilities.
  - When the tag is detected in the order, the system checks for line item properties that match settings defined in `ORD_ITM_PICKUP_FAC` and `ORD_ITM_SHIP_FAC`.
  
- **ORD_ITM_PICKUP_FAC and ORD_ITM_SHIP_FAC:**
  - **Purpose:** These settings are specific to the product store and define the criteria for grouping items. They are retrieved from the `ProductStoreSetting` entity and represent the facility assignment for pickup (`ORD_ITM_PICKUP_FAC`) and shipping (`ORD_ITM_SHIP_FAC`).
  - If a line item property matches any of these settings and the order contains the `PRE_SLCTD_FAC_TAG`, the system assigns the item to the corresponding fulfillment facility. For example:
    - **`ORD_ITM_PICKUP_FAC`:** Used to identify and group items that should be fulfilled by a designated pickup facility.
    - **`ORD_ITM_SHIP_FAC`:** Used to identify and group items that should be fulfilled by a designated shipping facility.

**Conclusion:**
The management of line items into ship groups using properties like `pickupstore`, along with the pre-selection feature driven by `PRE_SLCTD_FAC_TAG`, `ORD_ITM_PICKUP_FAC`, and `ORD_ITM_SHIP_FAC`, provides a robust mechanism for customizing how orders are processed. This approach allows for a seamless and efficient fulfillment process, catering to various scenarios such as store pickups and shipments from specific facilities.

### Key Considerations:
- **Grouping by Fulfillment Facility**: The process ensures that line items are grouped under their correct fulfillment facility, which is crucial for accurate order processing.
- **Handling Pickup Store Items**: Special attention is given to line items with the `pickupstore` property to ensure they are processed correctly.
- **Fulfilled Quantities**: The system tracks the fulfilled quantities of line items to manage partial fulfillments and calculate canceled quantities accurately.

### Ship Group: Setting Up "Ship From" and "Ship To" Details

In this section, the code deals with extracting and populating the "ship from" and "ship to" details for the ship group. These details are critical for processing the shipment correctly, ensuring that items are shipped from the correct facility and delivered to the correct destination.

#### 1. **Fetching Facility Contact Information ("Ship From")**
   - The code retrieves contact information for the facility from which the items will be shipped. This includes:
     - **Postal Address**: Identified by `POSTAL_ADDRESS` and `PRIMARY_LOCATION`.
     - **Phone Number**: Identified by `TELECOM_NUMBER` and `PRIMARY_PHONE`.
     - **Email Address**: Identified by `EMAIL_ADDRESS` and `PRIMARY_EMAIL`.
   - Each of these contact mechanisms (`contactMechId`) is retrieved using `WarehouseHelper.getFacilityContactDetail`. If found, they are stored in the respective variables (`facilityAddressContactMechId`, `facilityPhoneContactMechId`, `facilityEmailContactMechId`).

   - These details are then added to a `shipFromMap`:
     - **Postal Address**: Stored under `postalAddress`.
     - **Phone Number**: Stored under `phoneNumber`.
     - **Email Address**: Stored under `email`.
   - The `shipFromMap` is then added to the `shipGroup` under the `shipFrom` key.

#### 2. **Setting Up "Ship To" Details**
   - The `shipToMap` is used to store the destination contact information.
   - **Shipping Address**:
     - The code first checks for the presence of `shipping_address` in the order. If it exists, various address details like `name`, `address1`, `address2`, `city`, `country`, etc., are extracted.
     - **Address Parsing**:
       - If the address line (`address1`) ends with `(R)` or `(B)`, these indicators are used to determine if the address is a `HOME_LOCATION` or `WORK_LOCATION`. The indicators are then stripped from the address.
     - **Country and Province/State Geo IDs**:
       - The country code is mapped to a `countryGeoId` using `BuynowUtil.getCountryGeoIdFromGeoCode`.
       - The province or state is mapped to a `provinceGeoId` using `BuynowUtil.getCountryStateGeo`.
       - If any of these mappings fail, a communication event is logged, and the relevant geo ID is set to `null`.
     - **Geo Point**:
       - If latitude and longitude are present, a `GeoPoint` is created, and its ID (`geoPointId`) is stored in the `shipToMap`.
     - **Postal Address Creation**:
       - A postal address is created using the `createPostalAddress` service. If successful, the contact mechanism ID (`shippingContactMechId`) is stored.

   - **Phone Number**:
     - The phone number associated with the shipping address is extracted. If valid, it is formatted and stored using the `createTelecomNumber` service. The resulting contact mechanism ID is stored in `shipToMap`.

   - **Email Address**:
     - The email address for the shipping contact is extracted and stored using the `createContactMech` service. The resulting ID is used for both shipping and billing contact mechanisms (`shipToEmailContactMechId` and `billToEmailContactMechId`).

   - Finally, the `shipToMap` is populated with:
     - **Postal Address**: Including any additional purposes (e.g., `HOME_LOCATION`).
     - **Phone Number**.
     - **Email Address**.
   - This map is added to the `shipGroup` under the `shipTo` key.

#### 3. **Handling Missing Shipping Information**
   - If `shipping_address` is not present, the code defaults to using the `shipFromMap` (assuming that the shipping address is the same as the shipping origin).
   - If neither `shipFromMap` nor `shipping_address` is available, an error is logged indicating that the shipping information is missing.

This process ensures that both the origin (`shipFrom`) and destination (`shipTo`) details are thoroughly validated and correctly populated, allowing for accurate and efficient order fulfillment.

### Managing Bill To Contacts Details

This code snippet checks a product store setting called `SAVE_BILL_TO_INF` to determine whether billing information should be saved for a customer's order. If the setting is enabled (`"Y"`), it extracts and processes billing address, phone number, and email details from the order and then saves them in the system. Here’s a breakdown of what the code does:

1. **Check Product Store Setting**: 
   - The code uses the `StoreWorker.getProductStoreSetting` method to check if the `SAVE_BILL_TO_INF` setting is enabled (`"Y"`).
   
2. **Extract and Process Billing Information**:
   - **Billing Address**:
     - It retrieves the billing address from the order.
     - Extracts necessary fields like `name`, `address1`, `address2`, `city`, `country`, `postalCode`, etc.
     - Validates and converts country and province codes into their respective geo IDs.
     - If latitude and longitude are present, it creates a geo point in the system.
     - A postal address is then created with the validated data.
   - **Phone Number**:
     - The code retrieves the billing phone number and, if valid, parses it into components like `countryCode`, `areaCode`, and `contactNumber`.
     - It then creates a telecom number record in the system.
   - **Email**:
     - The billing email is not directly retrieved from the order but is instead copied from the shipping email that was previously processed.

3. **Save the Billing Information**:
   - The `postalAddress`, `phoneNumber`, and `email` are saved into the `billToMap`.
   - This `billToMap` is added to the `serviceCtx`, making the billing information available for further processing in the order creation service.

### Order Items

This section of the code is focused on processing and managing ship group items for an order in a system integrated with Shopify. Here's a breakdown of the logic:

1. **Ship Group Items Initialization**:
   - A list named `items` is initialized to store each processed order item as a map.

2. **Iterating Through Ship Group Items**:
   - The code iterates over each item in `shipGroupItems`, extracting relevant information like `variant_id`, `quantity`, and `id`.

3. **Product Identification**:
   - The `variant_id` is used to retrieve the `productId` from the local system. If the product is not found, a new product may be created based on configurations (`allowProductCreate`). This handles the scenario where a product is deleted from Shopify but needs to exist in the local system for order processing or when product is not imported from shopify yet.

4. **Creating Products**:
   - If the product is missing and creation is allowed, the code creates a new product, potentially marking it as a digital good or finished good based on the presence of inventory management for the variant.

5. **Order Item Mapping**:
   - A map (`orderItemMap`) is prepared for each order item, containing details like `quantity`, `unitPrice`, `productId`, and `status`. The status is determined based on whether the item is fulfilled, cancelled, or in any other state.

6. **Item Adjustments**:
   
   Adjustments like discounts and tax lines are processed and added to the `itemAdjustments` list within each `orderItemMap`. This ensures that all financial impacts on the item are recorded accurately.  The `itemAdjustments` data in HotWax Commerce is primarily derived from two sections of the Shopify Order JSON:

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

        
    Finally, all adjustments are added to the `itemAdjustments` list within the `orderItemMap`.

7. **Properties and Attributes**:
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

    *   The code handles special item properties like preorder or backorder statuses, adding relevant attributes to `orderItemAttributes`. Additionally, custom properties from Shopify (like "StorePickupItemProperty") are converted into attributes.

    1. **Extract Properties**:
        - The list of properties (`properties`) is extracted from the item.
        - Property names and values are collected into separate lists (`propertyNames` and `propertyValues`).

    2. **Preorder Check**:
        - The tag used for preorder is fetched via `ShopifyHelper.getShopifyTypeMappedValue(delegator, shopId, "SHOPIFY_PRODUCT_TAG", "ON_PRE_ORDER_PROD")`.
        - Checks if the item has the preorder tag or is categorized as a preorder item.
        - If there's a mismatch between Shopify and the system, a note is added.
        - If it's a preorder item, the `"PreOrderItemProperty"` attribute is added to `orderItemAttributes`.

    3. **Backorder Check**:
        - The tag used for backorder is fetched via `ShopifyHelper.getShopifyTypeMappedValue(delegator, shopId, "SHOPIFY_PRODUCT_TAG", "ON_BACK_ORDER_PROD")`.
        - Checks if the item has the backorder tag or is categorized as a backorder item.
        - If there's a mismatch between Shopify and the system, a note is added.
        - If it's a backorder item, the `"BackOrderItemProperty"` attribute is added to `orderItemAttributes`.

    4. **Store Pickup Check**:
        - Checks if the item is designated for store pickup using a property value fetched from `EntityUtilProperties.getPropertyValue("ShopifyServiceConfig", "storepickup.item.property.name", delegator)`.
        - If so, the `"StorePickupItemProperty"` attribute is added to `orderItemAttributes`.

    5. **General Property Attributes**:
        - For each property, an attribute is created and added to `orderItemAttributes`.

    6. **Attach Attributes**:
        - If any attributes were created, they are attached to the `orderItemMap` under `"orderItemAttributes"`.

8. **Item Associations**:
   - The code checks for item associations, such as exchanges, and links them to the current order item if applicable.


9. **Partial Fulfillment Handling**:
    - If an item is partially fulfilled (i.e., only part of the quantity is delivered), the item is split, and each part is processed separately, with appropriate statuses (`ITEM_COMPLETED`, etc.).

   - **Condition**: If `explodeOrderItems` is `"Y"` and `fulfillment_status` is `"partial"`.
   - **Action**: 
     - Call `CsrOrderHelper.explodeOrderItem(orderItemMap)` to get partially fulfilled items.
     - Compute `fulfilledQty` by subtracting `fulfillable_quantity` from the total quantity.
     - For each partially fulfilled item:
       - Create a copy of `orderItemMap`.
       - Update status to `"ITEM_COMPLETED"` if there is remaining quantity.
       - Adjust `fulfilledQty` and update `itemAdjustments` and `quantity`.
       - Add the updated item map to `items`.

2. **Full Item Addition**:
   - If the above condition is not met, add `orderItemMap` to `items` directly.

3. **Partial Cancellation Handling**:
   - **Condition**: If `refundQuantity` is positive and `remainQty` is positive.
   - **Action**:
     - Create a new map for the cancelled item.
     - Set quantity to `refundQuantity` and status to `"ITEM_CANCELLED"`.
     - Add the map to `items`.


This section ensures that the ship group items are fully processed, handling all potential edge cases like partial fulfillment, missing products, discounts, and tax calculations. It also integrates with Shopify's data structures to map and manage product information, ensuring consistency between systems.




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

