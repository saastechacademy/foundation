Recommended reading
https://www.moqui.org/m/docs/mantle/Mantle+Structure+and+UDM/Party

# Introduction to Party Data Model

This document provides an overview of this model, focusing on its core entities - Party, Person, and PartyGroup - and their applications in representing various business relationships. Additionally, we will delve into Party Roles, contact mechanisms, and their purposes. Finally, we provide sample JSON data for a Person as a Customer and a PartyGroup as a Supplier.
Party Data Model Overview

## Entities
1. Party
* Description: Represents any entity that can enter into a relationship. This includes individuals or organizations.
* Key Attribute: partyId.
2. Person
* Description: A specialization of Party, representing individual human beings.
* Key Attribute: partyId.
3. Organization
* Description: Another specialization of Party, representing collective entities such as companies or organizations.
* Key Attributes: partyId.
4. Party Role
* Description: Defines the role of a Party in a specific context.
* Key Attributes: partyid, roleTypeId.
* Examples: Customer, Supplier, Employee.
5. Contact Mechanism
* Description: Defines a means of contacting a party.
* Key Attribute: contactMechId
* Examples: telecomNumber and postalAddress
5. Party Contact Mechanism
* Description: Defines the specific use of a contact mechanism, like billing or shipping.
* Key Attributes: partyId, contactMechId, contactMechPurposeId, fromDate
# Sample JSON Data
1. Person as Customer
```
{
  "Party": {
    "partyId": "CUST123",
    "partyTypeId": "PERSON"
  },
  "Person": {
    "partyId": "CUST123",
    "firstName": "John",
    "lastName": "Doe",
    "birthDate": "1990-01-01"
  },
  "PartyRole": {
    "partyId": "CUST123",
    "roleTypeId": "CUSTOMER"
  },
  "ContactMech": [
    {
      "contactMechId": "PHONE001",
      "contactMechTypeEnumId": "TELECOM_NUMBER",
      "infoString": "555-1234"
    },
    {
      "contactMechId": "ADDR001",
      "contactMechTypeEnumId": "POSTAL_ADDRESS",
      "infoString": "123 Elm Street, Springfield, 12345, USA"
    }
  ],
  "PostalAddress": {
    "contactMechId": "ADDR001",
    "address1": "123 Elm Street",
    "city": "Springfield",
    "postalCode": "12345",
    "countryGeoId": "USA"
  },
  "ContactMechPurpose": [
    {
      "contactMechId": "ADDR001",
      "contactMechTypeEnumId": "BILLING"
    },
    {
      "contactMechId": "ADDR001",
      "contactMechTypeEnumId": "SHIPPING"
    }
  ]
}
```


2. Organization as Supplier
```
{
  "Party": {
    "partyId": "SUPP456",
    "partyTypeId": "ORGANIZATION"
  },
  "Organization": {
    "partyId": "SUPP456",
    "organizationName": "XYZ Supplies Inc.",
    "taxId": "98-7654321"
  },
  "PartyRole": {
    "partyId": "SUPP456",
    "roleTypeId": "SUPPLIER"
  },
  "ContactMech": [
    {
      "contactMechId": "PHONE002",
      "contactMechTypeEnumId": "TELECOM_NUMBER",
      "infoString": "555-6789"
    },
    {
      "contactMechId": "ADDR002",
      "contactMechTypeEnumId": "POSTAL_ADDRESS",
      "infoString": "456 Oak Avenue, Metropolis, 54321, USA"
    }
  ],
  "PostalAddress": {
    "contactMechId": "ADDR002",
    "address1": "456 Oak Avenue",
    "city": "Metropolis",
    "postalCode": "54321",
    "countryGeoId": "USA"
  },
  "ContactMechPurpose": [
    {
      "contactMechId": "ADDR002",
      "contactMechTypeEnumId": "BILLING"
    },
    {
      "contactMechId": "ADDR002",
      "contactMechTypeEnumId": "SHIPPING"
    }
  ]
}
```



