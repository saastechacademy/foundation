Recommended reading
https://www.moqui.org/m/docs/mantle/Mantle+Structure+and+UDM/Party

### This assignment tests your ability to Model:

1. Organization
2. Person
3. Party (organizations or people)
4. Party roles (i.e., customers, suppliers, internal organizations)
5. Postal address information (postal addresses and geographic boundaries)
6. Party contact mechanism—telecommunications numbers and electronic addresses
7. Party contact mechanism
8. Apply Subtypes and Supertypes concepts in data modeling
9. Apply Intersection or Association Entity concepts
10. Data Classifications 


### Tasks
1. Setup custom component, "relationshipmgr" 
2. Setup Party and related entities defined in this document.
3. Build UI using Forms and Screens 
4. Demonstrate use of your application to manage sample data from you experience, e.g Collage, departments, students, teaching staff. 
5. Add Party Contact Mechanism and related entities in your codebase (PartyContactMech and related entites are not defined in this document).
6. Prepare sample Contact Mechanism data from your real life experience.
7. Use your application to manage your contacts.

# Introduction to Party Data Model

This document provides an overview of this model, focusing on its core entities - Party, Person, Organization and PartyRole - and their applications in representing various business relationships. Additionally, we will delve into how to define Parties and their Roles. Finally, we provide sample JSON data for a Person and Organization in various Roles.
## Party Data Model Overview

Example: John Doe works as an employee at ABC Organization, where he is also a customer.

### Entities
#### 1. Party
- **Description**: Represents any entity that can enter into a relationship. This includes `PERSON` or `ORGANIZATION`.
- **Key Attribute**: `partyId`
- **Example**: Lets create the relevant parties.
```json
{
  "Party": [
    {
      "partyId": "PER123",
      "partyTypeId": "PERSON"
    },
    {
      "partyId": "ORG456",
      "partyTypeId": "ORGANIZATION"
    }
  ]
}
```
#### 2. Person
- **Description**: A specialization of `Party`, representing individual human beings.
- **Key Attribute**: `partyId`
- **Example**: Lets create the relevent person.
```json
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
- **Description**: Another specialization of `Party`, representing collective entities such as companies or organizations.
- **Key Attributes**: `partyId`.
- **Example**: Lets create the relevant organization.
```json
{
  "Organization": {
    "partyID": "ORG456",
    "organizationName": "ABC"
  }
}
```
#### 4. Party Role
- **Description**: Defines the role of a `Party` in a specific context.
- **Key Attributes**: `partyid`, `roleTypeId`
- **Examples**: Lets define the relevant roles for the parties.
```json
{
  "PartyRole": [
    {
      "partyId": "PER123",
      "roleTypeId": "CUSTOMER"    
    },
    {
      "partyId": "PER123",
      "roleTypeId": "EMPLOYEE"    
    },
    {
      "partyId": "ORG456",
      "roleTypeId": "EMPLOYER"    
    }
  ]
}
```
## Complete JSONs
### 1. Person as Customer
```json
{
  "Party": {
    "partyId": "PER123",
    "partyTypeId": "PERSON",
    "Person": {
      "firstName": "John",
      "lastName": "Doe",
      "birthDate": "1990-01-01"
    },
    "PartyRole": [
      {
        "roleTypeId": "CUSTOMER"
      },
      {
        "roleTypeId": "EMPLOYEE"    
      }
    ]
  }
}
```
### 2. Organization as Employer
```json
{
  "Party": {
    "partyId": "ORG456",
    "partyTypeId": "ORGANIZATION",
    "Organization": {
      "organizationName": "ABC"
    },
    "PartyRole": {
      "roleTypeId": "EMPLOYER"
    }
  }
}
```