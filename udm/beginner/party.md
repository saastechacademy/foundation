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
* Description: A specialization of Party. PERSON entity stores a particular person's information, independent of his or her jobs or roles.  
* Key Attributes: Inherits partyId, plus attributes like firstName, lastName, birthDate,etc
* Relationship with Party: Every Person is a Party, but with additional attributes specific to individuals.
  
3. PartyGroup
* Description: Another specialization of Party, representing collective entities such as companies or organizations.
* Key Attributes: Inherits partyId, plus attributes like groupName, taxId.
* Relationship with Party: Every PartyGroup is a Party, but with attributes specific to groups.

4. Party Classification
* Parties are classified into various categories using the entity PARTY CLASSIFICATION, which stores each category into which parties may belong.
* Party classifications are used to classify parties by industry/SIC/NAICS, size, revenue, minority/EEOC, etc. 
* EXAMPLE: Income_Classification, Minority_Classification, organization_classification and person_classification, etc.
   
5. Party Roles
* Defines: The party role entity defines how a party acts or what roles the party plays in the context of the enterprise's environment.
* A role can be associated with a party using the PartyRole entity.
* Key Attributes: partyId, roleTypeId.
* Examples: Customer, Supplier, Employee,Organization_Role, Person_Role, etc.

6. Party Relationship
* Defines: A relationship is defined by the two parties and their respective roles.
* Key attributes: partyIdTo, partyIdFrom, roleTypeIdFrom, roleTypeIdTo, fromDate.(from date and thru date in order to
show when the relationship started and optionally when (and if) it ended).
  
7. Contact Mechanisms and Purposes
Adding Contact Mechanisms:
* A contact mechanism is a means of contacting a party. The primary entity is ContactMech 
* Types: Includes mail, fax, email, with field infoString while types two have entities with additional fields i.e. PostalAddress and TelecomNumber.
* The ContactMech,PostalAddress and TelecomNumber shares same primary key field so they have a one-to-one relationship.
* Linking to Party: The PartyContactMech entity is used to associate a ContactMech with a Party.
  
Assigning Purposes to Contact Mechanisms
* Function: Defines the specific purpose of a contact mechanism, like billing or shipping. Each contact mechanism for each party may have many purposes.
* ContactMechPurpose entity is introduce to specfy the purpose for the particular contact mechanism such as BILLING_ADDRESS, SHIPPING_ADDRESS,BILLING_PHONE,SHIPPING_PHONE.


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
    "taxId": "98-7654321"
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



