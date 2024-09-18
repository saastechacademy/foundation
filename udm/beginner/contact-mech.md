# Introduction to Contact Mechanism Model

This document provides an overview of this model, focusing on its core entities - ContactMech and ContactMechPurpose - and their application in representing various communication methods. Additionally, we will delve into how to define the entities. Finally, we provide sample JSON data for ContactMech.

## Contact Mechanism Model Overview

Example: John Doe works as an employee at ABC Organization, where he is also a customer. John Doe has a work Telecom Number, work Postal Address, home Postal Address, and work Email Address. ABC Organization has a Telecom Number and Postal Address.

### Entities

#### 1. ContactMech
- **Description**: This describes the means of contacting a party. While there are various types, only two entities have additional fields: `postalAddress` and `telecomNumber`. Remaining types use the `contactMech.infoString` field.

- **Key Attribute**: `contactMechId`

- **TelecomNumber Table**
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

- **PostalAddress Table**
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
  - **Usage:**
    - Stores detailed information about postal addresses.
    - The `contactMechId` field serves as the link to the `ContactMech` table.

- **Example**: Lets create the relevant contactMechs.
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
    },
    {
      "contactMechId": "10003",
      "contactMechTypeEnumId": "POSTAL_ADDRESS",
      "PostalAddress": {
        "toName": "John Doe",
        "attnName": "Home",
        "address1": "123 Local St",
        "city": "Metropolis",
        "postalCode": "12345"
      }
    }
  ]
}

```

#### 2. ContactMechPurpose
- **Description**: Defines the purpose of a `ContactMech` in a specific context.
- **Key Attributes**: `contactMechPurposeId`
- **Examples**: Lets define the relevant purposes for the contactMechs.
```
{
  "ContactMechPurpose": [
    {
      "contactMechPurposeId": "WORK"
    },
    {
      "contactMechPurposeId": "HOME"
    },
    {
      "contactMechPurposeId": "OFFICE"
    }
  ]
}
```

#### 3. PartyContactMech
- **Description**: Used to associate a `Party` with a `ContactMech`.
- **Key Attributes**: `partyId`, `contactMechId`, `contactMechPurposeId`, `fromDate`
- **Examples**: Lets define the associations between Party and ContactMech.
```
{
  "PartyContactMech": [
    {
      "partyId": "PER123"
      "contactMechId": "10000"
      "contactMechPurposeId": "WORK"
      "fromDate": "2010-01-01"
    },
    {
      "partyId": "PER123"
      "contactMechId": "10001"
      "contactMechPurposeId": "WORK"
      "fromDate": "2010-01-01"
    },
    {
      "partyId": "PER123"
      "contactMechId":"10002"
      "contactMechPurposeId": "WORK"
      "fromDate": "2010-01-01"
    },
    {
      "partyId":"PER123"
      "contactMechId": "10003"
      "contactMechPurposeId": "HOME"
      "fromDate": "2005-01-01"
    },
    {
      "partyId": "ORG456"
      "contactMechId": "10000"
      "contactMechPurposeId": "OFFICE"
      "fromDate": "2010-01-01"
    },
    {
      "partyId": "ORG456"
      "contactMechId": "10002"
      "contactMechPurposeId": "OFFICE"
      "fromDate": "2000-01-01"
    }
  ]
}
```