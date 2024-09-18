Recommended reading
https://www.moqui.org/m/docs/mantle/Mantle+Structure+and+UDM/Party

# Introduction to Party Data Model

This document provides an overview of this model, focusing on its core entities - Party, Person, and PartyGroup - and their applications in representing various business relationships. Additionally, we will delve into Party Roles, contact mechanisms, and their purposes. Finally, we provide sample JSON data for a Person as a Customer and a PartyGroup as a Supplier.
## Party Data Model Overview

Example: John Doe works as an employee at ABC Organization, where he is also a customer.

### Entities
#### 1. Party
* Description: Represents any entity that can enter into a relationship. This includes individuals or organizations.
* Key Attribute: partyId.
* Example: Lets create the relevant parties.
```
{
  "Party": [
    {
      "partyId": "PER123",
      "partyTypeId": "PERSON"
    }
    {
      "partyId": "ORG456",
      "partyTypeId": "ORGANIZATION"
    }
  ]
}
```
#### 2. Person
* Description: A specialization of Party, representing individual human beings.
* Key Attribute: partyId.
* Example: Lets create the relevent person.
```
{
  "Person": {
    "partyId": "PER123",
    "firstName": "John",
    "lastName": "Doe",
    "birthDate": "1990-01-01"
  }
}
```
#### 3. Organization
* Description: Another specialization of Party, representing collective entities such as companies or organizations.
* Key Attributes: partyId.
* Example: Lets create the relevant organization.
```
{
  "Organization": {
    "partyID": "ORG456",
    "organizationName": "ABC"
  }
}
```
#### 4. Party Role
* Description: Defines the role of a Party in a specific context.
* Key Attributes: partyid, roleTypeId.
* Examples: Lets define the relevant roles for the parties.
```
{
  "PartyRole": [
    {
      "partyId": "PER123",
      "roleTypeId": "CUSTOMER"    
    }
    {
      "partyId": "PER123",
      "roleTypeId": "EMPLOYEE"    
    }
    {
      "partyId": "ORG456",
      "roleTypeId": "EMPLOYER"    
    }
  ]
}
```
## Sample JSON Data
### 1. Person as Customer
```
{
  "Party": {
    "partyId": "PER123",
    "partyTypeId": "PERSON",
    "Person": {
      "partyId": "PER123",
      "firstName": "John",
      "lastName": "Doe",
      "birthDate": "1990-01-01"
    },
    "PartyRole": [
      {
        "partyId": "PER123",
        "roleTypeId": "CUSTOMER"
      },
      {
        "partyId": "PER123",
        "roleTypeId": "EMPLOYEE"    
      }
    ]
  }
}
```
### 2. Organization as Employer
```
{
  "Party": {
    "partyId": "ORG456",
    "partyTypeId": "ORGANIZATION"
    "Organization": {
      "partyId": "ORG456",
      "organizationName": "ABC",
      "taxId": "98-7654321"
    },
    "PartyRole": {
      "partyId": "ORG456",
      "roleTypeId": "EMPLOYER"
    }
  }
}
```



