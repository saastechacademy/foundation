Recommeded reading
https://www.moqui.org/m/docs/mantle/Mantle+Structure+and+UDM/Party

Introduction to Party Data Model

This document provides an overview of this model, focusing on its core entities - Party, Person, and PartyGroup - and their applications in representing various business relationships. Additionally, we will delve into Party Roles, contact mechanisms, and their purposes. Finally, we provide sample JSON data for a Person as a Customer and a PartyGroup as a Supplier.
Party Data Model Overview

Entities
1. Party
Description: Represents any entity that can enter into a relationship. This includes individuals, groups, or organizations.
* Key Attributes: Unique identifier (partyId).
2. Person
* Description: A specialization of Party, representing individual human beings.
* Key Attributes: Inherits partyId, plus attributes like firstName, lastName, birthDate.
* Relationship with Party: Every Person is a Party, but with additional attributes specific to individuals.
3. PartyGroup
* Description: Another specialization of Party, representing collective entities such as companies or organizations.
* Key Attributes: Inherits partyId, plus attributes like groupName, taxId.
* Relationship with Party: Every PartyGroup is a Party, but with attributes specific to groups.
4. Party Roles
* Function: Defines the role of a Party in a specific context.
* Examples: Customer, Supplier, Employee.
* Assignment: A Party is assigned a Role through the PartyRole entity, linking the Party to its function within the business ecosystem.
5. Contact Mechanisms and Purposes
Adding Contact Mechanisms
* Types: Includes phone numbers (TelecomNumber) and postal addresses (PostalAddress).
* Linking to Party: Achieved via the ContactMech entity, which associates a contact mechanism with a Party through a unique contactMechId.
Assigning Purposes to Contact Mechanisms
* Function: Defines the specific use of a contact mechanism, like billing or shipping.
* Implementation: Utilizes the ContactMechPurpose entity, linking a contactMechId to a purpose such as BILLING or SHIPPING.
Sample JSON Data
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
      "contactMechTypeId": "TELECOM_NUMBER",
      "infoString": "555-1234"
    },
    {
      "contactMechId": "ADDR001",
      "contactMechTypeId": "POSTAL_ADDRESS",
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
      "contactMechPurposeTypeId": "BILLING"
    },
    {
      "contactMechId": "ADDR001",
      "contactMechPurposeTypeId": "SHIPPING"
    }
  ]
}
```


2. PartyGroup as Supplier
```
{
  "Party": {
    "partyId": "SUPP456",
    "partyTypeId": "PARTY_GROUP"
  },
  "PartyGroup": {
    "partyId": "SUPP456",
    "groupName": "XYZ Supplies Inc.",
  },
  "PartyRole": {
    "partyId": "SUPP456",
    "roleTypeId": "SUPPLIER"
  },
  "ContactMech": [
    {
      "contactMechId": "PHONE002",
      "contactMechTypeId": "TELECOM_NUMBER",
      "infoString": "555-6789"
    },
    {
      "contactMechId": "ADDR002",
      "contactMechTypeId": "POSTAL_ADDRESS",
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
      "contactMechPurposeTypeId": "BILLING"
    },
    {
      "contactMechId": "ADDR002",
      "contactMechPurposeTypeId": "SHIPPING"
    }
  ]
}
```



