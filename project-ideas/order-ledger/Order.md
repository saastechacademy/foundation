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


**OrderItem table with extension:**

*   `orderId`
*   `orderItemSeqId`
*   `externalId`
*   `orderItemTypeId`
*   `orderItemGroupSeqId`
*   `isItemGroupPrimary`
*   `fromInventoryItemId`
*   `budgetId`
*   `budgetItemSeqId`
*   `productId`
*   `supplierProductId`
*   `prodCatalogId`
*   `productCategoryId`
*   `isPromo`
*   `quoteId`
*   `quoteItemSeqId`
*   `shoppingListId`
*   `shoppingListItemSeqId`
*   `subscriptionId`
*   `deploymentId`
*   `quantity`
*   `cancelQuantity`
*   `selectedAmount`
*   `unitPrice`
*   `unitListPrice`
*   `isModifiedPrice`
*   `recurringFreqUomId`
*   `itemDescription`
*   `comments`
*   `correspondingPoId`
*   `statusId`
*   `syncStatusId`
*   `estimatedShipDate`
*   `estimatedDeliveryDate`
*   `autoCancelDate`
*   `dontCancelSetDate`
*   `dontCancelSetUserLogin`
*   `shipBeforeDate`
*   `shipAfterDate`
*   `reserveAfterDate`
*   `cancelBackOrderDate`
*   `overrideGlAccountId`
*   `salesOpportunityId`
*   `changeByUserLoginId`
*   `lastModifiedDate`
*   `lastModifiedByUserLogin`
*   `itemRecurringSeqId`
*   `unitRecurringPrice`
*   `unitAverageCost`
*   `averageCost`
*   `shipGroupSeqId`
*   `returnTillDate`
*   `promisedDatetime`
*   `shipmentId`
*   `isNewProduct`
*   `availableToPromise`
*   `requestedDeliveryDate`
*   `requestedDeliveryTime`
*   `requestedShipMethTypeId`
*   `deliveryWindow`
*   `taxCode`

**Core Apache OFBiz OrderItem Entity**

The `OrderItem` entity in Apache OFBiz represents individual items within a customer order. It captures essential details about each item:

*   **orderId (id):** The ID of the order to which this item belongs.
*   **orderItemSeqId (id):** A unique sequence ID for the item within the order (e.g., "00001").
*   **productId (id):** The ID of the product being ordered.
*   **quantity (fixed-point):** The quantity of the product ordered.
*   **unitPrice (currency-precise):** The price per unit of the product.
*   **statusId (id):** The current status of the order item (e.g., "ITEM\_CREATED," "ITEM\_APPROVED," "ITEM\_COMPLETED").
*   **...and other fields:** The entity includes several other fields for capturing additional details like descriptions, comments, and dates.

**HotWax Commerce OMS Customizations**

*   **`shipGroupSeqId` (id):** This field has been added to directly associate each `OrderItem` with a specific `OrderItemShipGroup`. This establishes a one-to-one relationship between these entities, ensuring that each order item belongs to only one shipment group.

*   **Additional Fields:**
    *   **`requestedDeliveryDate` (date):** The date requested for delivery by the customer.
    *   **`requestedDeliveryTime` (time):** The time requested for delivery by the customer.
    *   **`requestedShipMethTypeId` (id):** The ID of the shipping method requested by the customer.
    *   **`deliveryWindow` (floating-point):** Might represent a delivery window in hours or days.

**Key Takeaways:**

*   **Direct Ship Group Association:** The `shipGroupSeqId` field streamlines the association between order items and ship groups, simplifying queries and logic related to fulfillment.
*   **Enhanced Order Item Details:** The additional fields provide richer information about the order item, including delivery preferences, availability.

**Dynamic extensions to Order Datamodel**

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

