
**Workflow**

1.  **Input:** The function receives a `context` object containing the Shopify order data in JSON format, along with other contextual information like the userLogin and locale.

2.  **Order Identification:** It first checks if the order already exists in HotWax Commerce by looking for a matching Shopify order ID. If the order exists, it skips further processing.

3.  **Data Extraction and Mapping:** The code extracts essential details from the Shopify order JSON, such as:
    *   Order ID, creation date, customer information, billing/shipping addresses
    *   Line items (products ordered), quantities, prices, discounts, taxes
    *   Fulfillment details, notes, tags, and other relevant attributes

    It then maps these Shopify fields to the corresponding fields and entities in the Order data model.

4.  **Customer Handling:** If the customer associated with the Shopify order doesn't exist in HotWax Commerce, the code creates a new customer record.

5.  **Order Creation:** The function constructs a `serviceCtx` map, which is essentially a collection of parameters required by the HotWax Commerce `createSalesOrder` service. This map includes:
    *   Customer information
    *   Order date, status, and totals
    *   Order items with their details
    *   Shipping and billing information
    *   Order adjustments (discounts, taxes, etc.)

6.  **Service Call:** Finally, it invokes the `createSalesOrder` service using the `serviceCtx` map. If successful, the service returns the newly created order ID in HotWax Commerce.

**Additional Functionality**

*   **Order Identification:** The code uses various identification types (Shopify order number, name, ID) to link the Shopify order to its HotWax counterpart.
*   **Order Status Handling:** It determines the appropriate order status in HotWax based on the Shopify order's state (created, canceled, closed).
*   **Order Adjustments:** It handles discounts, taxes, and tips as order adjustments.

**Key Considerations**

*   **Extensibility:** The code is structured in a way that allows for customization and extension. You can modify the data mapping logic, add more error handling, or integrate with other HotWax Commerce services as needed.
*   **Shopify API Dependency:** The function relies heavily on the structure of the Shopify Order API JSON response. Any changes in the API might require adjustments to the code.



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


## createSalesOrder ##

The `createSalesOrder` service in HotWax Commerce is a complex service that handles the creation of a new sales order. It takes a map called `orderEntryMap` as input, which contains all the necessary information to create the order. Let's break down the key parameters within this map:

1.  **order:** This is a nested map that contains the bulk of the order details. It includes:
    *   **channel:** The sales channel through which the order was placed (e.g., "web," "Shopify").
    *   **webSiteId:** The ID of the website associated with the order.
    *   **customerId:** The ID of the customer placing the order.
    *   **orderContacts:** A map containing contact information (email, phone) for the order.
    *   **tags:** A list of tags associated with the order.
    *   **orderDate:** The date and time the order was placed.
    *   **statusId:** The initial status of the order (e.g., "ORDER\_CREATED").
    *   **orderStatusDatetime:** The date and time the order reached its initial status.
    *   **productStoreId:** The ID of the product store where the order was placed.
    *   **currencyCode:** The currency used for the order.
    *   **presentmentCurrencyCode:** The currency used to display prices to the customer.
    *   **grandTotal:** The total amount of the order.
    *   **orderIdentifications:** A list of maps, each containing an identification type (e.g., "SHOPIFY\_ORD\_ID") and its corresponding value.
    *   **orderAttributes:** A list of maps, each containing an attribute name, value, and optional description for the order.
    *   **shipGroup:** A list of maps, each representing a shipment group within the order. Each ship group map contains:
        *   **facilityId:** The ID of the facility from which the items will be shipped.
        *   **shipFrom:** A map with contact information for the shipping origin.
        *   **shipTo:** A map with contact information for the shipping destination.
        *   **shipmentMethodTypeId:** The type of shipping method (e.g., "STANDARD").
        *   **carrierPartyId:** The ID of the carrier responsible for shipping.
        *   **items:** A list of maps, each representing a line item within the ship group. Each line item map contains:
            *   **productId:** The ID of the product.
            *   **quantity:** The quantity ordered.
            *   **unitPrice:** The price per unit.
            *   **itemAdjustments:** A list of maps, each representing an adjustment (discount, tax) to the item.
    *   **orderAdjustments:** A list of maps, each representing an adjustment (discount, tax) to the entire order.
    *   **billTo:** A map with contact information for the billing address.
    *   **billFrom:** A map with contact information for the billing origin.
    *   **locale:** The locale associated with the order.
    *   **originFacilityId:** The ID of the facility where the order originated.

2.  **userLogin:** A `GenericValue` representing the user who initiated the service call. This is used for authentication and authorization purposes within the `createSalesOrder` service.

The `createSalesOrder` service processes this `orderEntryMap` to create the sales order, its associated items, adjustments, and any other necessary records in the HotWax Commerce database. It also handles tasks like inventory reservation, tax calculation, and order status updates.

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

**Lists and Maps to organize data and call storeOrder**

The `createSalesOrder` function prepares several lists and maps to organize data before it's used to create a sales order in HotWax Commerce. 





## createSalesOrder API Documentation (Expanded)

### Overview

This service is a core component of the HotWax Commerce platform, responsible for creating new sales orders. It integrates with various modules (including the Shopify integration) and handles complex order creation logic, including data validation, entity creation, and related business processes.

### Endpoint

```
POST /service/createSalesOrder
```

### Request Body


### Response Body

Upon successful order creation, the service returns a JSON object:

```json
{
  "orderId": "string"
}
```

*   `orderId`: The ID of the newly created order in HotWax Commerce.

### Error Responses

In case of errors, the service returns an appropriate HTTP status code along with a JSON object describing the error:

```json
{
  "errorMessage": "string",
  "errorDetails": "string" 
}
```

### Additional Considerations

*   **Data Validation:** The service performs strict validation on the input data. Ensure that all required fields are present and correctly formatted.
*   **Customer Creation:** If the `customerId` is not found, the service attempts to create a new customer based on the provided information.
*   **Asynchronous Tasks:** Some tasks, like checking product components and order payment processing, are executed asynchronously after the initial order creation.
*   **Extensibility:** The service is designed to be extensible. You can add custom logic or modify existing behavior using HotWax Commerce's customization mechanisms.



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

    You are absolutely right. The sample JSON I provided earlier was not correctly aligned with the data element naming conventions used in the HotWax Commerce `createSalesOrder` service. I apologize for the oversight.

**Sample JSON passed to `createSalesOrder`** API

```json
{
  "order": {
    "productStoreId": "YOUR_PRODUCT_STORE_ID", // Replace with your actual product store ID
    "externalId": "450789469",                // Shopify Order ID
    "orderName": "#1001",                     // Shopify Order Name
    "orderTypeId": "SALES_ORDER",
    "channel": "WEB_SALES_CHANNEL",           // Assuming web order based on browser_ip
    "webSiteId": "YOUR_WEBSITE_ID",           // Replace with your actual website ID
    "customerExternalId": "207119551",        // Shopify Customer ID
    "firstName": "Bob",                       // From Shopify customer object
    "lastName": "Norman",                     // From Shopify customer object
    "orderDate": "2008-01-10 11:00:00",       // Shopify created_at (converted to local time)
    "currencyCode": "USD",                    // From Shopify order
    "presentmentCurrencyCode": "CAD",         // From Shopify order
    "originFacilityId": "YOUR_FACILITY_ID",   // Replace with actual facility ID or "_NA_" if unknown
    "grandTotal": "409.94",                   // From Shopify order
    "orderContacts": {
      "email": {
        "id": "CONTACT_MECH_ID_FOR_EMAIL"    // Replace with actual contact mech ID
      },
      "phone": {
        "id": "CONTACT_MECH_ID_FOR_PHONE"    // Replace with actual contact mech ID
      }
    },
    "shipGroup": [
      {
        "facilityId": "YOUR_FACILITY_ID",
        "maySplit": "N",
        "shipByDate": "2008-01-15 11:00:00",  // Example date, adjust as needed
        "shipmentMethodTypeId": "STANDARD",
        "carrierPartyId": "YOUR_CARRIER_PARTY_ID",
        "shipFrom": {
          "postalAddress": {
            "id": "CONTACT_MECH_ID_FOR_WAREHOUSE_ADDRESS" // Replace with actual contact mech ID
          }
        },
        "shipTo": {
          "postalAddress": {
            "id": "CONTACT_MECH_ID_FOR_SHIPPING_ADDRESS" // Replace with actual contact mech ID
          }
        },
        "items": [
          {
            "productId": "YOUR_PRODUCT_ID1",  // Replace with actual product ID
            "quantity": 1,
            "unitPrice": "199.99",            // From Shopify line_items
            "itemAdjustments": [
              {
                "type": "SALES_TAX",
                "amount": "25.81",             // From Shopify line_items.tax_lines
                "sourcePercentage": "0.13"     // From Shopify line_items.tax_lines
              },
              {
                "type": "PROMOTION_ADJUSTMENT",
                "amount": "-5.00",             // From Shopify line_items.discount_allocations
                "sourceReferenceId": "SUMMERSALE" // Assuming discount code from discount_allocations
              }
            ],
            "orderItemAttributes": [
              {
                "attrName": "custom engraving",
                "attrValue": "Happy Birthday Mom!"
              }
            ]
          }
        ]
      }
    ],
    "orderAdjustments": [
      {
        "type": "SHIPPING_CHARGES",
        "amount": "4.00"                     // From Shopify shipping_lines
      }
    ],
    "orderPaymentPref": [
      {
        "paymentMethodTypeId": "EXT_COD",     // Assuming Cash on Delivery based on payment_gateway_names
        "maxAmount": "409.94",
        "statusId": "PAYMENT_NOT_RECEIVED"   // Assuming not paid yet
      }
    ],
    "billTo": {
      "postalAddress": {
        "id": "CONTACT_MECH_ID_FOR_BILLING_ADDRESS" // Replace with actual contact mech ID
      }
    }
  },
  "userLogin": {
    "userLoginId": "admin",
    "currentPassword": "password123"
  }
}
```

**Key Changes and Considerations:**

*   **Field Names:** The field names in the JSON now match the parameters expected by the `createSalesOrder` service in the HotWax Commerce code.
*   **Data Types:** Values have been converted to the appropriate data types (e.g., strings, decimals) as per the service's requirements.
*   **Placeholders:** Placeholders like `YOUR_PRODUCT_STORE_ID`, `YOUR_WEBSITE_ID`, `YOUR_FACILITY_ID`, `YOUR_CARRIER_PARTY_ID`, and contact mechanism IDs need to be replaced with actual values from your HotWax Commerce system.
*   **Assumptions:**
    *   The `channel` is set to "WEB\_SALES\_CHANNEL" based on the presence of `browser_ip` in the Shopify order.
    *   The `paymentMethodTypeId` is set to "EXT\_COD" (Cash on Delivery) based on the `payment_gateway_names` in the Shopify order.
    *   The `statusId` for `orderPaymentPref` is set to "PAYMENT\_NOT\_RECEIVED" assuming the order is not yet paid.
    *   The `shipByDate` is an example date and should be adjusted as needed.

