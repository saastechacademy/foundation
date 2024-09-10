# Hotwax API Documentation: `create#SalesOrder`

## Introduction

The `create#SalesOrder` API is a versatile service designed to facilitate the seamless creation of sales orders in Hotwax from third-party e-commerce platforms such as Shopify. This API allows external systems to push order data into Hotwax, where it undergoes validation, default handling, and transformation before being stored as a complete order.

The API ensures that all prerequisite entities, such as customers, products, shipping details, and payments, are correctly associated with the order. If required data is missing, the service can either generate new records (e.g., for customers or contact mechanisms) or return errors when critical information is invalid or incomplete. Additionally, the service performs background checks to set default values for certain fields, allowing for smoother integration with minimal input effort.

By using this API, third-party platforms can automate the creation of orders in Hotwax, providing a streamlined workflow that reduces manual intervention and improves the accuracy of data exchange between systems.

## 1. Service Overview

### 1.1 Purpose
The `create#SalesOrder` service is an independent API that can be invoked from any external system. It creates an order in Hotwax using the provided data, ensuring all necessary entities are correctly prepared.

### 1.2 Workflow
The service performs several key steps:
- Validates input data for completeness and correctness.
- Checks for missing data and sets default values where applicable.
- Prepares input data and links entities required for order creation.
- Calls the `createOrder` service with the processed data to complete order creation.

---

## 2. Prerequisite Data

### 2.1 Required Data for `create#SalesOrder`
The following data points must exist to successfully create an order:

1. **productStoreId** – Links the order to a specific product store.
2. **salesChannelEnumId** – Identifies the source of the order (e.g., e-commerce platform).
3. **facilityId** or **externalId** – For ship group identification.
4. **carrierPartyId** – The shipping carrier's party ID.
5. **shipmentMethodTypeId** – Must be associated with the given carrierPartyId.
6. **productId** or **SKU** – Identifies the product being ordered.
7. **orderAdjustmentTypeId** – For handling order adjustments (e.g., discounts, shipping).
8. **paymentMethodTypeId** – Specifies the type of payment (e.g., credit card, external gateway).
9. **statusId** – Represents the status of the order (e.g., ORDER_CREATED).
10. **enumId** – Used for order identification and classification.

---

## 3. API Input Structure

### 3.1 Request Body Format

<details>
<summary>With contact mech present in the data</summary>
<br>

```json
{
  "order": {
    "orderName": "#499999",
    "orderDate": "2024-07-25T04:07:49.956",
    "originFacilityId": "",
    "orderStatusDatetime": "2024-07-25T04:07:49.956",
    "externalId": "00001",
    "channel": "WEB_SALES_CHANNEL",
    "priority": "2",
    "currencyCode": "USD",
    "presentmentCurrencyCode": "USD",
    "productStoreId": "STORE",
    "grandTotal": "1556",
    "webSiteId": "WEBSTORE",
    "status": "ORDER_CREATED",
    "firstName": "deepak",
    "lastName": "gupta",
    "customerId": "100743",
    "customerExternalId": "",
    "customerIdentificationType": "",
    "customerIdentificationValue": "",
    "customerClassificationId": "",
    "note": "",
    "tags": "",
    "orderContacts": {
      "email": {
        "id": "100055"
      }
    },
    "identifications": [
      {
        "idType": "SHOPIFY_ORD_NAME",
        "idValue": "2345678876545"
      },
      {
        "idType": "SHOPIFY_ORD_ID",
        "idValue": "4444992255"
      }
    ],
    "billTo": {
      "postalAddress": {
        "id": "100057"
      },
      "email": {
        "id": "100055"
      },
      "telecomNumber": {
        "id": "100056"
      }
    },
    "orderAttributes": [
      {
        "attrName": "item",
        "attrValue": "testing attribute"
      }
    ],
    "orderPaymentPref": [
      {
        "paymentMethodType": "EXT_SHOP_OTHR_GTWAY",
        "maxAmount": "25000",
        "statusId": "PAYMENT_AUTHORIZED",
        "paymentMode": "",
        "cardName": "",
        "manualRefNum": "45545454545454"
      }
    ],
    "orderAdjustments": [
      {
        "type": "SHIPPING_CHARGES",
        "amount": "500",
        "exemptAmount": "2.5",
        "sourcePercentage": "5",
        "comments": "",
        "attributes": [
          {
            "attrName": "taxAuthority",
            "attrValue": "State of California",
            "attrDescription": "state tax"
          }
        ]
      },
      {
        "type": "SHIPPING_SALES_TAX",
        "amount": "50",
        "exemptAmount": "2.5",
        "sourcePercentage": "5",
        "comments": ""
      }
    ],
    "shipGroups": [
      {
        "facilityId": "NEW_ERA_HARAJUKU",
        "externalId": "",
        "maySplit": "Y",
        "shipBy": "2018-03-14 08:37:57.000",
        "shipAfter": "2018-03-14 08:37:57.000",
        "shipmentMethodTypeId": "STOREPICKUP",
        "carrierPartyId": "_NA_",
        "trackingNumber": "888888888888",
        "shipTo": {
          "postalAddress": {
            "id": "100057",
            "additionalPurpose": "HOME_LOCATION"
          },
          "email": {
            "id": "100055"
          },
          "telecomNumber": {
            "id": "100056"
          }
        },
        "items": [
          {
            "itemExternalId": "100097001712202",
            "productId": "10022",
            "sku": "",
            "description": "",
            "statusId": "ITEM_CREATED",
            "quantity": 4,
            "unitListPrice": 1370,
            "unitPrice": 500,
            "orderItemAttributes": [
              {
                "attrName": "_pickupstore",
                "attrValue": "NEW_ERA_HARAJUKU"
              },
              {
                "attrName": "newwAttr",
                "attrValue": "sss"
              }
            ],
            "orderItemAdjustments": [
              {
                "type": "PROMOTION_ADJUSTMENT",
                "amount": 207,
                "setShipGroup": "Y",
                "exemptAmount": 2.5,
                "sourcePercentage": 5,
                "comments": "IDK",
                "attributes": [
                  {
                    "attrName": "description",
                    "attrValue": "Early bird discount"
                  },
                  {
                    "attrName": "adjjjj",
                    "attrValue": "Early bird discount"
                  }
                ]
              },
              {
                "type": "SALES_TAX",
                "amount": 599,
                "setShipGroup": "Y",
                "exemptAmount": 2.5,
                "sourcePercentage": 5,
                "comments": "NOOO"
              }
            ]
          }
        ]
      }
    ]
  }
}
```
</details>


<details>
<summary>Another sample json when contact mech id are not present and we will create contact mechs.</summary>
<br>

```json
{
    "order": {
        "orderName": "#499999",
    "orderDate": "2024-07-25T04:07:49.956",
    "originFacilityId": "",
    "orderStatusDatetime": "2024-07-25T04:07:49.956",
    "externalId": "00001",
    "channel": "WEB_SALES_CHANNEL",
    "priority": "2",
    "currencyCode": "USD",
    "presentmentCurrencyCode": "USD",
    "productStoreId": "STORE",
    "status": "ORDER_CREATED",
    "grandTotal": "1556",
    "webSiteId": "WEBSTORE",
    "firstName": "deepak",
    "lastName": "gupta",
    "customerId": "100743",
    "customerExternalId": "",
    "customerIdentificationType": "",
    "customerIdentificationValue": "",
    "customerClassificationId": "",
    "note": "",
    "tags": "",
        "orderContacts": {
            "email": {
                "emailString": "deepak.gupta@mail.com"
            }
        },
        "identifications": [
            {
                "idType": "SHOPIFY_ORD_NAME",
                "idValue": "2345678876545"
            },
            {
                "idType": "SHOPIFY_ORD_ID",
                "idValue": "454545454544"
            }
        ],
        "billTo": {
            "postalAddress": {
                "name": "John Doe",
                "address1": "Vijay Naga, 78",
                "address2": "Indore, MP",
                "city": "Indore",
                "postalCode": "452001",
                "countryCode": "IN",
                "stateProvinceGeoCode": "MP",
                "latitude": 37.1169719,
                "longitude": 138.2592022
            },
            "email": {
                "emailString": "deepak.gupta@mail.com"
            },
            "telecomNumber": {
                "areaCode": "+91",
                "contactNumber": "7845127845"
            }
        },
        "orderAttributes": [
            {
                "attrName": "item",
                "attrValue": "testing attribute",
                "attrDescription": ""
            }
        ],
        "orderPaymentPref": [
            {
                "paymentMethodType": "EXT_SHOP_OTHR_GTWAY",
                "maxAmount": "25000",
                "statusId": "PAYMENT_AUTHORIZED",
                "paymentMode": "",
                "cardName": "",
                "manualRefNum": "45545454545454"
            }
        ],
        "orderAdjustments": [
            {
                "type": "SHIPPING_CHARGES",
                "amount": "500",
                "exemptAmount": "2.5",
                "sourcePercentage": "5",
                "comments": "",
                "attributes": [
                    {
                        "attrName": "taxAuthority",
                        "attrValue": "State of California",
                        "attrDescription": "state tax"
                    }
                ]
            },
            {
                "type": "SHIPPING_SALES_TAX",
                "amount": "50",
                "exemptAmount": "2.5",
                "sourcePercentage": "5",
                "comments": ""
            }
        ],
        "shipGroups": [
            {
                "facilityId": "NEW_ERA_HARAJUKU",
                "externalId": "",
                "maySplit": "Y",
                "shipBy": "2018-03-14 08:37:57.000",
                "shipAfter": "2018-03-14 08:37:57.000",
                "shipmentMethodTypeId": "STOREPICKUP",
                "carrierPartyId": "_NA_",
                "trackingNumber": "8888888888",
                "shipTo": {
                    "postalAddress": {
                        "name": "John Doe",
                        "address1": "Vijay Naga, 78",
                        "address2": "Indore, MP",
                        "city": "Indore",
                        "postalCode": "452001",
                        "countryCode": "IN",
                        "stateProvinceGeoCode": "MP",
                        "latitude": 37.1169719,
                        "longitude": 138.2592022,
                        "additionalPurpose": "HOME_LOCATION"
                    },
                    "email": {
                        "emailString": "deepak.gupta@mail.com"
                    },
                    "telecomNumber": {
                        "areaCode": "+91",
                        "contactNumber": "7845127845"
                    }
                },
                "items": [
                    {
                        "itemExternalId": "100097001712202",
                        "productId": "10022",
                        "sku": "BLACK_BELL_BOTTOM_S",
                        "description": "",
                        "statusId": "ITEM_CREATED",
                        "idValue": "",
                        "idType": "",
                        "quantity": 1,
                        "unitListPrice": 1370,
                        "unitPrice": 500,
                        "orderItemAttributes": [
                            {
                                "attrName": "_pickupstore",
                                "attrValue": "NEW_ERA_HARAJUKU"
                            }
                        ],
                        "orderItemAdjustments": [
                            {
                                "orderAdjustmentTypeId": "PROMOTION_ADJUSTMENT",
                                "amount": "200",
                                "setShipGroup": "Y",
                                "exemptAmount": "2.5",
                                "sourcePercentage": "5",
                                "comments": "IDK",
                                "attributes": [
                                    {
                                        "attrName": "description",
                                        "attrValue": "Early bird discount"
                                    }
                                ]
                            }
                        ]
                    }
                ]
            }
        ]
    }
}
```
</details>


---

## 4. Key Functionalities

### 4.1 Customer Management
- **Existing Customers**: If the customer is already in the system, provide either the `customerId` or `customerExternalId`.
- **New Customers**: If no `customerId` or `customerExternalId` is provided but the `firstName` field is populated, a new customer party will be created with appropriate roles, such as CUSTOMER and PLACING_CUSTOMER.

### 4.2 Contact Mechanism (billTo and shipTo)
- For `billTo` and `shipTo` addresses, if an existing `contactMech` ID is provided, the system will validate whether the ID exists. If the ID does not exist, an error is returned.
- If no `contactMechId` is provided, new `contactMech` records will be created for both billing and shipping addresses.

### 4.3 Duplicate Order Checks
- To prevent duplicate order creation, the API checks for existing orders based on specific identifiers (e.g., `externalId`). This helps avoid processing the same order more than once, further reducing system load.

---

## 5. Additional Considerations

### 5.1 Error Handling

The `create#SalesOrder` API performs rigorous validation to ensure that all required fields are provided and valid. When critical data is missing or invalid, the API returns error messages detailing the specific issue. This helps users quickly identify and correct any missing information before attempting to create the order again.

#### Common Error Scenarios:
- **Missing `productStoreId`**: If the product store ID is not provided, an error is returned since it is required to link the order with the correct store.
- **Missing `paymentMethodTypeId`**: If the payment method type is absent, the service cannot complete the payment preference setup, resulting in an error.
- **Missing `orderAdjustmentTypeId`**: If the adjustment type for order and item is absent, the service cannot complete the ajdustment setup, resulting in an error.
- **Invalid `contactMechId`**: If an ID is provided for billing or shipping contact mechanisms but does not exist in the system, an error is generated to indicate that the reference is invalid.

These error messages follow a standard format, making it easy for external systems to handle and respond to them efficiently.

---

### 5.2 Default Values

The API automatically sets default values for certain fields when they are not explicitly provided in the input data. This reduces the burden on external systems and ensures the order creation process runs smoothly without requiring extensive inputs.

#### Default Values:
- **Order Type**: There is no need to provide order type, the API defaults to `"SALES_ORDER"`, ensuring that the order is correctly categorized within the system.
- **Sales Channel**: If no sales channel information is included, the API sets a default value of `"UNKNWN_SALES_CHANNEL"`. This allows the order to be processed without identifying the source but can be updated later as needed.
- **Status**: When status is missing in input json. API sets a default value of `"ORDER_CREATED"` and `ITEM_CREATED`.

By handling these defaults, the API ensures that orders can be created even when non-essential data is missing, maintaining flexibility in the integration process.

---

### 5.3 Performance Tips

To optimize performance and reduce unnecessary database lookups, the `create#SalesOrder` API employs caching mechanisms for frequently used data. This helps to speed up the order creation process, especially when handling multiple orders in quick succession.

#### Performance Enhancements:
- **Caching of Database Values**: The API caches commonly accessed data such as `Facility`, `ProductStore`, `UOM`, `Party`, `ShipmentMethodType`, `Enumeration` and other enitities values. This minimizes repeated database hits and improves the overall responsiveness of the API.

By leveraging caching and preventing duplicates, the API ensures efficient use of resources while maintaining data integrity and minimizing the chance of redundant records.

---

