**Order data model of Apache OFBiz, HotWax Commerce**

*   OrderHeader
*   OrderItem
*   OrderItemShipGroup
*   OrderItemShipGroupAssoc
*   OrderContactMech
*   OrderAdjustment
*   OrderPaymentPreference
*   OrderAttribute
*   OrderItemAttribute
*   OrderItemAssoc


The `OrderAttribute` and `OrderItemAttribute` are used to store additional information associated with orders and order items, respectively. These entities provide a flexible way to capture extra data that doesn't fit into the standard fields of the `OrderHeader` and `OrderItem` entities.

**OrderAttribute**

*   **Purpose:** Stores attributes related to the entire order.
*   **Example:** In the code, `OrderAttribute` is used to store the `shopify_user_id`, which is the ID of the staff member who created the order in Shopify.

**OrderItemAttribute**

*   **Purpose:** Stores attributes specific to individual line items within an order.
*   **Example:** The code uses `OrderItemAttribute` to store properties associated with line items, such as custom engravings or other product customizations. It also stores information about whether an item is a pre-order or backorder item.

**How They Are Used**

1.  **Data Extraction:** The code extracts relevant attributes from the Shopify order JSON.
2.  **Attribute Creation:** It creates `OrderAttribute` or `OrderItemAttribute` entities (depending on the type of attribute) and populates them with the extracted data.
3.  **Association:** The attributes are associated with the corresponding order or order item using the `orderId` and `orderItemSeqId` fields.

**Why This is Important**

*   **Flexibility:**  Allows storing arbitrary data that might be important for business processes or reporting.
*   **Extensibility:** Provides a way to extend the data model without modifying the core `OrderHeader` and `OrderItem` entities.
*   **Data Preservation:** Ensures that important details from the Shopify order are not lost during the import process.

The following Shopify order data is mapped to `OrderAttribute` or `OrderItemAttribute` in HotWax Commerce:

1.  **Order Level:**
    *   `shopify_user_id`: The ID of the staff member who created the order in Shopify. This is stored as an `OrderAttribute`.
    *   `note_attributes`: Any custom note attributes added to the order in Shopify. These are stored as `OrderAttribute` entities, with the attribute name and value taken directly from the Shopify data.

2.  **Order Item Level:**
    *   `properties`: Custom properties associated with line items in Shopify, such as "custom engraving" or other product customizations. These are stored as `OrderItemAttribute` entities.
    *   Pre-order and backorder tags: If a product is tagged as "ON\_PRE\_ORDER\_PROD" or "ON\_BACK\_ORDER\_PROD" in Shopify, this information is stored in `OrderItemAttribute` to indicate that the item is a pre-order or backorder.
    *   Store pickup property: If a line item has a property indicating store pickup, this is also stored in `OrderItemAttribute`.


## **storeOrderCtx**

These data objects are then stored in the `storeOrderCtx` map, which is passed as input to the `storeOrder` service. Here's a breakdown of the key data objects:

1.  **Lists:**
    *   `orderItemShipGroupInfo`: Stores information about the shipping groups associated with the order, including the facility ID, shipping dates, carrier, and other details.
    *   `orderItems`: Contains the individual line items of the order, with details like product ID, quantity, price, and adjustments.
    *   `orderContactMechList`: Holds contact mechanisms (email addresses, phone numbers, postal addresses) related to the order.
    *   `orderAdjustmentList`: Stores adjustments applied to the order, such as discounts, taxes, and shipping charges.
    *   `orderAdjustmentAttrList`: Contains additional attributes for order adjustments, providing extra information about the adjustments.
    *   `orderPaymentPrefList`: Stores payment preferences for the order, including payment method type, status, and maximum amount.
    *   `orderAttributeList`: Contains additional attributes for the order itself, allowing for custom data storage.
    *   `orderItemAttributes`: Stores attributes specific to individual order items, such as custom engravings or other product customizations.
    *   `orderItemAssociations`:  Captures associations between order items, which can be used for linking items in kit products or bundled products.

2.  **Maps:**
    *   `storeOrderCtx`: This is the main map that consolidates all the prepared data. It includes the lists mentioned above, along with other essential order details like customer ID, order date, status, and totals. This map is the final input to the `storeOrder` service.

**Purpose**

These lists and maps serve to structure and organize the order data in a way that is compatible with the HotWax Commerce data model and the requirements of the `storeOrder` service. By separating the data into different lists and maps, the code improves readability and maintainability. It also makes it easier to pass the data to the `storeOrder` service, which expects a specific format for its input.

```
Sample order json
```


**1. orderContactMechs (List<GenericValue>)**

*   **Purpose:** Stores contact mechanisms associated with the order (e.g., email, phone, billing address, shipping address).
*   **Data Elements:**
    *   `contactMechId`: The ID of the contact mechanism.
    *   `contactMechPurposeTypeId`: The purpose of the contact mechanism (e.g., "ORDER\_EMAIL," "BILLING\_LOCATION," "SHIPPING\_LOCATION").

**2. orderItems (List<GenericValue>)**

*   **Purpose:** Stores the individual line items (products) within the order.
*   `orderItemTypeId`: The type of order item (e.g., "PRODUCT\_ORDER\_ITEM").
*   `productId`: The ID of the product.
*   `quantity`: The quantity ordered.
*   `unitPrice`: The price per unit.
*   `unitListPrice`: The list price per unit (if different from the actual price).
*   `itemDescription`: A description of the item.
*   `statusId`: The status of the item (e.g., "ITEM\_CREATED," "ITEM\_APPROVED").
*   `prodCatalogId`: The ID of the product catalog the item belongs to.
*   `orderItemSeqId`: A unique sequence ID for the item within the order.
*   `externalId`: The external ID of the item (e.g., from Shopify).
*   `shipGroupSeqId`: The ID of the shipping group the item belongs to.
*   `itemAdjustments`: A list of adjustments (discounts, taxes) applied to the item.
*   `orderItemAttributes`: A list of additional attributes for the item.
*   `orderItemAssociations`: A list of associations with other order items (e.g., for kits or bundles).

**3. orderItemShipGroupInfo (List<GenericValue>)**

*   **Purpose:** Stores information about shipping groups within the order.
*   **Data Elements:**
    *   `shipGroupSeqId`: A unique sequence ID for the shipping group.
    *   `orderId`: The ID of the order.
    *   `contactMechId`: The ID of the contact mechanism for the shipping address.
    *   `shipmentMethodTypeId`: The type of shipment method (e.g., "STANDARD").
    *   `carrierPartyId`: The ID of the carrier responsible for shipping.
    *   `facilityId`: The ID of the facility from which the items will be shipped.
    *   `telecomContactMechId`: The ID of the contact mechanism for the shipping phone number.
    *   `maySplit`: Whether the shipment can be split into multiple packages ("Y" or "N").
    *   `shipByDate`: The date by which the shipment should be sent.
    *   `shipAfterDate`: The earliest date the shipment can be sent.
    *   `trackingNumber`: The tracking number for the shipment.
    *   `isGift`: Whether the shipment is a gift ("Y" or "N").

**4. orderAdjustmentList (List<GenericValue>)**

*   **Purpose:** Stores adjustments (e.g., discounts, taxes, shipping charges) applied to the order.
*   **Data Elements:**
    *   `orderAdjustmentId`: A unique ID for the adjustment.
    *   `orderAdjustmentTypeId`: The type of adjustment (e.g., "SALES\_TAX," "PROMOTION\_ADJUSTMENT").
    *   `orderItemSeqId`: The sequence ID of the order item the adjustment applies to (or "\_NA\_" if it applies to the whole order).
    *   `shipGroupSeqId`: The sequence ID of the shipping group the adjustment applies to (or "\_NA\_" if it applies to the whole order).
    *   `amount`: The amount of the adjustment.
    *   `sourcePercentage`: The percentage used to calculate the adjustment (for percentage-based adjustments).
    *   `comments`: Comments or notes about the adjustment.
    *   `description`: A description of the adjustment.
    *   `exemptAmount`: The amount of the adjustment that is exempt from tax.

**5. orderPaymentPrefList (List<GenericValue>)**

*   **Purpose:** Stores payment preferences for the order.
*   **Data Elements:**
    *   `paymentMethodTypeId`: The type of payment method (e.g., "CREDIT\_CARD," "GIFT\_CARD").
    *   `maxAmount`: The maximum amount that can be charged using this payment method.
    *   `statusId`: The status of the payment preference (e.g., "PAYMENT\_NOT\_RECEIVED," "PAYMENT\_AUTHORIZED").
    *   `paymentMode`: The mode of payment.
    *   `cardName`: The name on the card (for credit card payments).
    *   `securityCode`: The security code of the card (for credit card payments).
    *   `manualAuthCode`: Manual authorization code (if applicable).
    *   `manualRefNum`: Manual reference number (if applicable).
    *   `requestId`: Request ID (if applicable).
    *   `applicationIdentifier`: Application identifier (if applicable).

**6. orderItemAttributes (List<GenericValue>)**

*   **Purpose:** Stores additional attributes for individual order items.
*   **Data Elements:**
    *   `orderItemSeqId`: The sequence ID of the order item.
    *   `attrName`: The name of the attribute.
    *   `attrValue`: The value of the attribute.
    *   `attrDescription`: A description of the attribute.

**7. orderAttributeList (List<GenericValue>)**

*   **Purpose:** Stores additional attributes for the entire order.
*   **Data Elements:**
    *   `attrName`: The name of the attribute.
    *   `attrValue`: The value of the attribute.
    *   `attrDescription`: A description of the attribute.

**8. orderAdjustmentAttrList (List<GenericValue>)**

*   **Purpose:** Stores additional attributes for order adjustments.
*   **Data Elements:**
    *   `orderAdjustmentId`: The ID of the order adjustment.
    *   `attrName`: The name of the attribute.
    *   `attrValue`: The value of the attribute.

**9. orderItemAssociations (List<GenericValue>)**

*   **Purpose:** Stores associations between order items (e.g., for kits or bundles).
*   **Data Elements:**
    *   `orderId`: The ID of the order.
    *   `orderItemSeqId`: The sequence ID of the order item.
    *   `shipGroupSeqId`: The sequence ID of the shipping group.
    *   `toOrderId`: The ID of the associated order (if applicable).
    *   `toOrderItemSeqId`: The sequence ID of the associated order item (if applicable).
    *   `toShipGroupSeqId`: The sequence ID of the associated shipping group (if applicable).
    *   `orderItemAssocTypeId`: The type of association (e.g., "PRODUCT\_COMPONENT").
    *   `quantity`: The quantity of the associated item.

**10. orderAdditionalPartyRoleMap (Map)**

*   **Purpose:** Stores additional party roles associated with the order.
*   **Data Elements:**
    *   Keys: Role type IDs (e.g., "SALES\_REP").
    *   Values: Party IDs associated with the role.

**a detailed specification**

**1. orderContacts (Map<String, Object>)**

*   **Purpose:** Captures contact information associated with the order.
*   **Structure:**
    *   `email` (Map<String, String>):
        *   `id`: The ID of the contact mechanism representing the customer's email address.
    *   `phone` (Map<String, String>):
        *   `id`: The ID of the contact mechanism representing the customer's phone number.

**2. orderIdentifications (List<Map<String, String>>)**

*   **Purpose:** Stores unique identifiers for the order from external systems (in this case, Shopify).
*   **Structure:**
    *   Each map in the list represents a single identification:
        *   `orderIdentificationTypeId`: The type of identification (e.g., "SHOPIFY\_ORD\_ID," "SHOPIFY\_ORD\_NO," "SHOPIFY\_ORD\_NAME").
        *   `idValue`: The actual identification value from Shopify.

**3. orderAttributes (List<Map<String, String>>)**

*   **Purpose:** Holds additional attributes or metadata about the order.
*   **Structure:**
    *   Each map in the list represents an attribute:
        *   `attrName`: The name of the attribute.
        *   `attrValue`: The value of the attribute.
        *   `attrDescription`: (Optional) A description of the attribute.

**4. shipGroup (List<Map<String, Object>>)**

*   **Purpose:** Represents groups of items to be shipped together within the order.
*   **Structure:**
    *   Each map in the list represents a ship group:
        *   `facilityId`: The ID of the facility from which the items will be shipped.
        *   `externalId`: The external ID of the facility (e.g., from Shopify).
        *   `maySplit`: Whether the shipment can be split into multiple packages ("Y" or "N").
        *   `shipByDate`: The date by which the shipment should be sent.
        *   `shipAfterDate`: The earliest date the shipment can be sent.
        *   `carrierPartyId`: The ID of the carrier responsible for shipping.
        *   `trackingNumber`: The tracking number for the shipment.
        *   `isGift`: Whether the shipment is a gift ("Y" or "N").
        *   `shipmentMethodTypeId`: The type of shipment method (e.g., "STANDARD").
        *   `shipFrom` (Map<String, Object>): Contact information for the shipping origin.
            *   `postalAddress` (Map<String, String>):
                *   `id`: The ID of the postal address contact mechanism.
            *   `phoneNumber` (Map<String, String>):
                *   `id`: The ID of the phone number contact mechanism.
            *   `email` (Map<String, String>):
                *   `id`: The ID of the email address contact mechanism.
        *   `shipTo` (Map<String, Object>): Contact information for the shipping destination.
            *   `postalAddress` (Map<String, String>):
                *   `id`: The ID of the postal address contact mechanism.
                *   `additionalPurpose`: (Optional) Additional purpose of the address (e.g., "HOME\_LOCATION," "WORK\_LOCATION").
            *   `phoneNumber` (Map<String, String>):
                *   `id`: The ID of the phone number contact mechanism.
            *   `email` (Map<String, String>):
                *   `id`: The ID of the email address contact mechanism.
        *   `items` (List<Map<String, Object>>): The line items within the ship group.
            *   See the description of `orderItems` for the structure of each item map.

**5. orderAdjustments (List<Map<String, Object>>)**

*   **Purpose:** Stores adjustments (discounts, taxes, etc.) applied to the order.
*   **Structure:**
    *   Each map in the list represents an adjustment:
        *   `type`: The type of adjustment (e.g., "SALES\_TAX," "PROMOTION\_ADJUSTMENT").
        *   `amount`: The amount of the adjustment.
        *   `exemptAmount`: The amount of the adjustment that is exempt from tax.
        *   `sourcePercentage`: The percentage used to calculate the adjustment (for percentage-based adjustments).
        *   `comments`: Comments or notes about the adjustment.
        *   `adj_attr_name`: (Optional) The name of an additional attribute for the adjustment.
        *   `adj_attr_value`: (Optional) The value of an additional attribute for the adjustment.

**6. orderPaymentPrefList (List<Map<String, Object>>)**

*   **Purpose:** Stores payment preferences for the order.
*   **Structure:**
    *   Each map in the list represents a payment preference:
        *   `paymentMethodTypeId`: The type of payment method (e.g., "CREDIT\_CARD," "GIFT\_CARD").
        *   `maxAmount`: The maximum amount that can be charged using this payment method.
        *   `statusId`: The status of the payment preference (e.g., "PAYMENT\_NOT\_RECEIVED," "PAYMENT\_AUTHORIZED").
        *   `paymentMode`: The mode of payment.
        *   `cardName`: The name on the card (for credit card payments).
        *   `securityCode`: The security code of the card (for credit card payments).
        *   `manualAuthCode`: Manual authorization code (if applicable).
        *   `manualRefNum`: Manual reference number (if applicable).
        *   `requestId`: Request ID (if applicable).
        *   `applicationIdentifier`: Application identifier (if applicable).

**7. orderItemAttributes (List<Map<String, Object>>)**

*   **Purpose:** Stores additional attributes for individual order items.
*   **Structure:**
    *   Each map in the list represents an attribute:
        *   `orderItemSeqId`: The sequence ID of the order item.
        *   `attrName`: The name of the attribute.
        *   `attrValue`: The value of the attribute.
        *   `attrDescription`: (Optional) A description of the attribute.

**8. orderAttributeList (List<GenericValue>)**

*   **Purpose:** Stores additional attributes for the entire order.
*   **Structure:**
    *   Each `GenericValue` in the list represents an attribute (same structure as `orderItemAttributes`).

**9. orderAdjustmentAttrList (List<GenericValue>)**

*   **Purpose:** Stores additional attributes for order adjustments.
*   **Structure:**
    *   Each `GenericValue` in the list represents an attribute:
        *   `orderAdjustmentId`: The ID of the order adjustment.
        *   `attrName`: The name of the attribute.
        *   `attrValue`: The value of the attribute.

**10. orderItemAssociations (List<GenericValue>)**

*   **Purpose:** Stores associations between order items (e.g., for kits or bundles).
*   **Structure:**
    *   Each `GenericValue` in the list represents an association:
        *   `orderId`: The ID of the order.
        *   `orderItemSeqId`: The sequence ID of the order item.
        *   `shipGroupSeqId`: The sequence ID of the shipping group.
        *   `toOrderId`: The ID of the associated order (if applicable).
        *   `toOrderItemSeqId`: The sequence ID of the associated order item (if applicable).
        *   `toShipGroupSeqId`: The sequence ID of the associated shipping group (if applicable).
        *   `orderItemAssocTypeId`: The type of association (e.g., "PRODUCT\_COMPONENT").
        *   `quantity`: The quantity of the associated item.

**11. orderAdditionalPartyRoleMap (Map)**

*   **Purpose:**  Associates additional parties (beyond the customer and vendor) with the order in specific roles.
*   **Structure:**
    *   Keys: Role type IDs (e.g., "SALES\_REP," "GIFT\_GIVER").
    *   Values: Party IDs associated with the role.


**Entity mapping**

1.  **Order Identification:**
    *   The specification mentions `orderIdentifications` as a list of maps, but the code actually handles individual identification fields like `externalId` and `transactionId` directly, not within a nested list.
    *   The specification could be clarified to indicate that `externalId` and `transactionId` are used for order identification, not the `orderIdentifications` list.

2.  **Order Attributes:**
    *   The specification correctly describes `orderAttributes` as a list of maps containing attribute details.
    *   The code implementation aligns with this, using the `orderAttributes` list to create `OrderAttribute` entities.

3.  **Ship Groups:**
    *   The specification accurately outlines the structure of the `shipGroup` list and its nested elements.
    *   The code implementation closely follows this structure, extracting data from the `shipGroup` list to create `OrderItemShipGroup` and `OrderItemShipGroupAssoc` entities.

4.  **Order Adjustments:**
    *   The specification correctly describes `orderAdjustments` as a list of maps containing adjustment details.
    *   The code implementation aligns with this, using the `orderAdjustments` list to create `OrderAdjustment` entities.

5.  **Order Payment Preferences:**
    *   The specification accurately describes `orderPaymentPrefList` as a list of maps containing payment preference details.
    *   The code implementation aligns with this, using the `orderPaymentPrefList` to create `OrderPaymentPreference` entities.

6.  **Order Item Attributes:**
    *   The specification correctly describes `orderItemAttributes` as a list of maps containing attribute details.
    *   The code implementation aligns with this, using the `orderItemAttributes` list to create `OrderItemAttribute` entities.

7.  **Additional Party Roles:**
    *   The specification mentions `orderAdditionalPartyRoleMap` as a map of role type IDs to party IDs.
    *   The code implementation directly uses this map when creating the order, so the specification is accurate.


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

The service expects a JSON payload in the following format:

```json
{
  "order": {
    // Order Details
    "externalId": "string", 
    "orderName": "string",
    "orderTypeId": "SALES_ORDER" | "PURCHASE_ORDER" | (others), 
    "channel": "UNKNWN_SALES_CHANNEL" | "WEB_SALES_CHANNEL" | (others),
    "webSiteId": "string",
    "productStoreId": "string", 
    "customerExternalId": "string",
    "customerId": "string",
    "firstName": "string",
    "lastName": "string",
    "orderDate": "datetime (yyyy-MM-dd HH:mm:ss)",
    "expireDate": "datetime (yyyy-MM-dd HH:mm:ss)", 
    "orderStatusDatetime": "datetime (yyyy-MM-dd HH:mm:ss)",
    "currencyCode": "string",
    "presentmentCurrencyCode": "string",
    "originFacilityId": "string",
    "originExternalFacilityId": "string",
    "priority": "integer",
    "transactionId": "string",
    "customerClassificationId": "string",
    "email": "string",
    "phone": "string",
    "grandTotal": "decimal",

    // Nested Objects (see detailed descriptions below)
    "orderContacts": {
        "email": {
            "id": "string" 
        },
        "phone": {
            "id": "string" 
        }
    },
    "shipGroup": [
        {
            "facilityId": "string",
            "externalId": "string",
            "maySplit": "Y" | "N",
            "shipByDate": "datetime (yyyy-MM-dd HH:mm:ss)",
            "shipAfterDate": "datetime (yyyy-MM-dd HH:mm:ss)",
            "carrierPartyId": "string",
            "trackingNumber": "string",
            "shipmentMethodTypeId": "string",
            "orderFacilityId": "string",
            "shipFrom": {
                "postalAddress": {
                    "id": "string",
                    "name": "string",
                    "country": "string",
                    "state": "string",
                    "city": "string",
                    "zip": "string"
                },
                "phoneNumber": {
                    "id": "string",
                    "contactNumber": "string"
                },
                "email": {
                    "id": "string",
                    "infoString": "string"
                }
            },
            "shipTo": {
                "postalAddress": {
                    "id": "string",
                    "additionalPurpose": "HOME_LOCATION" | "WORK_LOCATION" | (others)
                },
                "phoneNumber": {
                    "id": "string",
                    "contactNumber": "string"
                },
                "email": {
                    "id": "string",
                    "infoString": "string"
                }
            },
            "items": [
                {
                    "productId": "string",
                    "sku": "string",
                    "idType": "string",
                    "idValue": "string",
                    "status": "ITEM_CREATED" | "ITEM_APPROVED" | (others),
                    "description": "string",
                    "autoCancelDate": "datetime (yyyy-MM-dd HH:mm:ss)",
                    "dontCancelSetDate": "datetime (yyyy-MM-dd HH:mm:ss)",
                    "quantity": "decimal",
                    "unitListPrice": "decimal",
                    "unitPrice": "decimal",
                    "taxCode": "string",
                    "itemAdjustments": [
                        {
                            "type": "SALES_TAX" | "PROMOTION_ADJUSTMENT" | (others),
                            "amount": "decimal",
                            "exemptAmount": "decimal",
                            "sourcePercentage": "decimal",
                            "comments": "string",
                            "adj_attr_name": "string",
                            "adj_attr_value": "string",
                            "setShipGroup": "Y" | "N"
                        }
                    ],
                    "orderItemAttributes": [
                        {
                            "attrName": "string",
                            "attrValue": "string",
                            "attrDescription": "string"
                        }
                    ],
                    "orderItemAssociations": [
                        {
                            "toOrderId": "string",
                            "toOrderExternalId": "string",
                            "toOrderItemSeqId": "string",
                            "toShipGroupSeqId": "string",
                            "orderItemAssocTypeId": "string",
                            "quantity": "decimal"
                        }
                    ]
                }
            ]
        }
    ],
    "orderAdjustments": [
        {
            "type": "SALES_TAX" | "PROMOTION_ADJUSTMENT" | (others),
            "amount": "decimal",
            "exemptAmount": "decimal",
            "sourcePercentage": "decimal",
            "comments": "string",
            "adj_attr_name": "string",
            "adj_attr_value": "string"
        }
    ],
    "orderPaymentPref": [
        {
            "paymentMethodTypeId": "CREDIT_CARD" | "GIFT_CARD" | (others),
            "maxAmount": "decimal",
            "statusId": "PAYMENT_NOT_RECEIVED" | "PAYMENT_AUTHORIZED" | (others),
            "paymentMode": "string",
            "cardName": "string",
            "code": "string",
            "manualAuthCode": "string",
            "manualRefNum": "string",
            "requestId": "string",
            "applicationIdentifier": "string"
        }
    ],
    "billTo": {
        "postalAddress": {
            "id": "string",
            "name": "string",
            "country": "string",
            "state": "string",
            "city": "string",
            "zip": "string"
        },
        "phoneNumber": {
            "id": "string",
            "contactNumber": "string"
        },
        "email": {
            "id": "string",
            "externalId": "string",
            "infoString": "string"
        }
    },
    "orderAdditionalPartyRoleMap": {
        "roleTypeId": "partyId" 
    }
  },
  "userLogin": {
    "userLoginId": "string",
    "currentPassword": "string" 
  }
}
```

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

