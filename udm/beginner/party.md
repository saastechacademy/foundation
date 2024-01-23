Recommeded reading
https://www.moqui.org/m/docs/mantle/Mantle+Structure+and+UDM/Party

Introduction to Party Data Model

This document provides an overview of this model, focusing on its core entities - Party, Person, and PartyGroup - and their applications in representing various business relationships. Additionally, we will delve into Party Roles, contact mechanisms, and their purposes. Finally, we provide sample JSON data for a Person as a Customer and a PartyGroup as a Supplier.
Party Data Model Overview

Entities
1. Party
* Description: Represents any entity that can enter into a relationship. This includes individuals, groups, or organizations.
* Key Attributes: Unique identifier (partyId).
  
2. Person
* Description: A specialization of Party, representing individual human beings.
* Key Attributes: Inherits partyId, plus attributes like firstName, lastName, birthDate.
* Relationship with Party: Person is subentity of Party entity. Every Person is a Party, but with additional attributes specific to individuals. 

3. PartyGroup
* Description: Another specialization of Party, representing collective entities such as companies or organizations.
* Key Attributes: Inherits partyId, plus attributes like groupName, taxId.
* Relationship with Party: Every PartyGroup is a Party, but with attributes specific to groups.
  
4. Party Roles
* Function: Defines the role of a Party in a specific context.
* Examples: Customer, Supplier, Employee.
* Key Attributes: partyId and roleTypeId (Unique identifier of roleType entity).
* Relationship with Party: A single party can have multiple roles.
* Assignment: A Party is assigned a Role through the PartyRole entity, linking the Party to its function within the business ecosystem.

5. Party Relationships
* Description: A relationship is defined by two parties and their respective roles.
* Function: To maintain the unique information about each relationship of party to each other.
* Key Attributes: partyId and roleTypeId of both parties and relationshipTypeId.

5. Contact Mechanism
* Function: Contact Mech entity stores access mechanism from parties.
* Types: Includes email address (EmailAddress), phone numbers (TelecomNumber) and postal addresses (PostalAddress).
* Key Attributes: Unique identifier (contactMechId).

6. Party Contact Mechanism
* Linking to Party: Achieved via the ContactMech entity, which associates a contact mechanism with a Party through a unique contactMechId.
* Key Attributes: partyId, contactMechId and fromDate.

7. Party Contact Mechanism Purposes
* Function: Defines the specific use of a contact mechanism, like billing or shipping.
* Implementation: Utilizes the ContactMechPurposeType entity, linking a PartyContactMech to a purposeTypeId such as BILLING or SHIPPING.

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
      "contactMechTypeId": "TELECOM_NUMBER"
    },
    {
      "contactMechId": "ADDR001",
      "contactMechTypeId": "POSTAL_ADDRESS"
    }
  ],
  "PostalAddress": {
    "contactMechId": "ADDR001",
    "address1": "123 Elm Street",
    "city": "Springfield",
    "postalCode": "12345",
    "countryGeoId": "USA"
  },
  “TelecomNumber”:{
    "contactMechId": "PHONE001",
    "countryCode": "1",
    "areaCode": "555",
    "contactNumber": "4536-9712"
  },
  "PartyContactMech”: [
    {
     "partyId": "CUST123",
     "contactMechId": "PHONE001",
     “fromDate”:”2024-01-22 00:00:00”
    },
    {
     "partyId": "CUST123",
     "contactMechId": "ADDR001",
     “fromDate”:”2024-01-22 00:00:00”
    }
  ],
  "PartyContactMechPurpose": [
    {
      "partyId": "CUST123",
      "contactMechId": "ADDR001",
      "contactMechPurposeTypeId": "BILLING_LOCATION",
      “fromDate”:”2024-01-22 00:00:00”
    },
    {
      "partyId": "CUST123",
      "contactMechId": "ADDR001",
      "contactMechPurposeTypeId": "SHIPPING_LOCATION",
      “fromDate”:”2024-01-22 00:00:00”
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
    "groupName": "XYZ Supplies Inc."
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
  “TelecomNumber”:{
      "contactMechId": "PHONE002",
      "countryCode": "1",
      "areaCode": "555",
      "contactNumber": "4536-9712"
  },
  "PartyContactMech”:[
    {
     "partyId": "SUPP456",
     "contactMechId": "PHONE002",
     “fromDate”:”2024-01-22 00:00:00”
    },
    {
     "partyId": "SUPP456",
     "contactMechId": "ADDR002",
     “fromDate”:”2024-01-22 00:00:00”
    }
  ],
"PartyContactMechPurpose": [
  {
    "partyId": "SUPP456",
    "contactMechId": "ADDR002",
    "contactMechPurposeTypeId": "BILLING_LOCATION",
    “fromDate”:”2024-01-22 00:00:00”
  },
  {
    "partyId": "SUPP456",
    "contactMechId": "ADDR002",
    "contactMechPurposeTypeId": "SHIPPING_LOCATION",
    “fromDate”:”2024-01-22 00:00:00”
  }
]
}
```



