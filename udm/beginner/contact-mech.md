# Introduction to Contact Mechanism Model

This document provides an overview of this model, focusing on its core entities - ContactMech and ContactMechPurpose - and their application in representing various communication methods. Additionally, we will delve into how to define the entities. Finally, we provide sample JSON data for ContactMech.

## Contact Mechanism Model Overview

Example John Doe works as an employee at ABC Organization, where he is also a customer. John Doe has a work TelecomNumeber, work PostalAddress, home PostalAddress, and work emailAddress. ABC Organization has a TelecomNumber and PostalAddress.

# Entities

## ContactMech
* Description: This describes the means of contacting a party. While there are various types, only two entities have additional fields: `postalAddress` and `telecomNumber`. Remaining types use the `contactMech.infoString` field.

* Key Attribute: `contactMechId`

### 1. TelecomNumber Table
- **Relationship with ContactMech:** This table is related to `ContactMech` and specifically stores telephone numbers.
- **Fields:** 
  - `contactMechId`
  - `countryCode`
  - `areaCode`
  - `contactNumber`
  - etc.
- **Usage:** 
  - Used to store detailed telephone contact information.
  - The `contactMechId` field links it to the `ContactMech` table.

---

### 2. PostalAddress Table
- **Relationship with ContactMech:** This table stores the postal address information and is linked to the `ContactMech` table.
- **Fields:**
  - `contactMechId`
  - `toName`
  - `attnName`
  - `address1`
  - `address2`
  - `city`
  - `postalCode`
  - etc.

```
{
  "ContactMech": [
    {

    }
  ]
}
```



Sample Data in JSON Format

```
{
  "ContactMech": [
    {
      "contactMechId": "10000",
      "contactMechTypeEnumId": "TELECOM_NUMBER",
      "TelecomNumber": {
        "countryCode": "1",
        "areaCode": "123",
        "contactNumber": "4567890"
      }
    },
    {
      "contactMechId": "10001",
      "contactMechTypeEnumId": "EMAIL_ADDRESS",
      "infoString": "example@email.com"
    },
    {
      "contactMechId": "10002",
      "contactMechTypeEnumId": "POSTAL_ADDRESS",
      "PostalAddress": {
        "toName": "John Doe",
        "attnName": "Office",
        "address1": "123 Main St",
        "address2": "Suite 100",
        "city": "Metropolis",
        "postalCode": "12345"
      }
    }
  ]
}

```