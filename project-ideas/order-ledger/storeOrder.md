

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
                            "setShipGroup": "Y" | "N",
                            "attributes": [
                              {
                                "attrName": "description",
                                "attrValue": "Early bird discount"
                              }
                            ]
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
            "attributes": [
               {
                 "attrName": "taxAuthority",
                 "attrValue": "State of California"
               }
             ]
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

