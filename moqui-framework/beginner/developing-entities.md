# Assignment: Create a Custom Party Entity in Moqui

## Objectives

This assignment evaluates your ability to:

- Follow Moqui documentation and instructions effectively.
- Define a new entity in a custom Moqui component.
- Demonstrate proficiency in Git and GitHub for source code management.
- Utilize the Moqui UI for testing and validation.
- Follow proper JAVA naming conventions.

---

## Tasks

Complete the following tasks to demonstrate your understanding of Moqui and related technologies:

## **Step 1: [Create a New Component](https://moqui.org/m/docs/framework/Quick+Tutorial#CreateaComponent)**
1. Navigate to the `component` folder in the `runtime` directory of `moqui-framework`.
2. Create a new folder named `party` for your custom component.
3. Add configuration files to identify your component:
   - Create a `component.xml` file for your component.
   - Update the main configuration file to recognize your component.

## **Step 2: [Define a New Entity](https://moqui.org/m/docs/framework/Data+and+Resources/Data+Model+Definition)**
Inside the `party` component, create a directory structure to store entity definitions.  
Create the following entities-
### **1. Party**

The Party entity represents any person or organization in the system.

### **Entity Name: Party**

| Attribute Name    | Data Type | Notes |
|-------------------|-----------|-------|
| `partyId`         | id        | Primary Key |
| `partyTypeEnumId` | id        | Enum ID (PERSON, PARTY_GROUP) |
| `createdDate`     | date-time | Optional: when the party was created |

### **Enum Type: PartyType**

Seed Enum Values:
- `PERSON`
- `PARTY_GROUP`


### **2. Person**

Stores additional details for individual persons.

### **Entity Name: Person**

| Attribute Name | Data Type | Notes |
|----------------|-----------|-------|
| `partyId`      | id        | Primary Key, also FK to Party |
| `firstName`    | text      | Person’s first name |
| `lastName`     | text      | Person’s last name |
| `dateOfBirth`  | date      | Optional |

Every Person must also exist in the Party table.


### **3. PartyGroup**

Stores details for companies, organizations, or groups.

### **Entity Name: PartyGroup**

| Attribute Name      | Data Type | Notes |
|---------------------|-----------|-------|
| `partyId`           | id        | Primary Key, also FK to Party |
| `groupName`         | text      | Name of the organization/group |
| `description`       | text      | Optional |


### **4. ContactMech**

Stores various types of contact information (email, phone, address).

### **Entity Name: ContactMech**

| Attribute Name       | Data Type | Notes |
|----------------------|-----------|-------|
| `contactMechId`      | id        | Primary Key |
| `contactMechTypeId`  | id        | Enum ID (EMAIL, TELECOM_NUMBER, POSTAL_ADDRESS) |
| `infoString`         | text      | Stores email ID, phone number, etc. |
| `createdDate`        | date-time | Optional |

### **Enum Type: ContactMechType**

Seed Enum Values:
- `EMAIL`
- `TELECOM_NUMBER`
- `POSTAL_ADDRESS`


### **5. PartyContactMech**

Creates the relationship between Party and ContactMech.

### **Entity Name: PartyContactMech**

| Attribute Name   | Data Type | Notes |
|------------------|-----------|-------|
| `partyId`        | id        | FK to Party |
| `contactMechId`  | id        | FK to ContactMech |
| `fromDate`       | date-time | PK part — when the contact became active |
| `thruDate`       | date-time | Optional — when the contact stopped being active |


> **Primary Key:** partyId + contactMechId + fromDate

This entity allows a Party to have multiple contact methods and a contact method to be linked to multiple parties.


### **6. [Seed Test Data]()**

Create basic sample data for:

- A Party of type PERSON  
- A matching Person record  
- A Party of type PARTY_GROUP  
- A matching PartyGroup record  
- A ContactMech record for email  
- A ContactMech record for phone  
- PartyContactMech link records  

## **Step 3: Test the Entity in Moqui UI**
1. Run the Moqui application and access the Entity Tools section.
2. Verify all the entity is listed and properly defined.
3. Add sample data into the entities using the Data Import tool available in Moqui.

## **Step 4: Version Control**
1. Commit your changes with meaningful commit messages.
2. Push the repository to your GitHub account under a repository named `party`.

## Deliverables

1. A link to the GitHub repository containing your `party` component.

---

## Evaluation Criteria

- The `party` component is correctly structured.
- The entities are properly defined and visible in the Entity Tools section.
- Sample data is successfully added to the entity.
- Proper usage of Git and GitHub for version control.
- Clean and readable code adhering to Java naming conventions.

---
