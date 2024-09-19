# Introduction to Facility Data Model
This document provides an overview of the Facility model, focusing on its core entities: Facility, FacilityLocation, ProductFacility, and FacilityParty. It also delves into how facilities are structured hierarchically, how products are linked to locations, and how parties are associated with facilities. Finally, we provide sample JSON data for different facilities and their associated roles.

## Facility Data Model Overview
Example: ABC Organization has a warehouse and a store. They allow fulfillment from both locations. John Doe works at the Warehouse.

### Entities
#### 1. Facility
- **Description**: Represents any physical structure, such as a building, unit, room, or land, that can be part of a business operation.
- **Key Attribute**: `facilityId`
- **Example**: Let's create the relevant facilities.
```json
{
  "Facility": [
    {
      "facilityId": "FAC001",
      "facilityTypeEnumId": "WAREHOUSE",
      "facilityName": "Main Warehouse"
    },
    {
      "facilityId": "FAC002",
      "facilityTypeEnumId": "STORE",
      "facilityName": "SoHo Store",
      "parentFacilityId": "FAC001"
    }
  ]
}
```
#### 2. FacilityLocation
- **Description**: A specialization of Facility, representing specific locations within a facility where inventory is stored. This could include areas, aisles, sections, or levels. 
- **Key Attribute**: `facilityId` 
- **Example**: Let's create the relevant facility locations.
```json
{
  "FacilityLocation": [
    {
      "facilityId": "FAC001",
      "locationSeqId": "1",
      "areaId": "AREA1",
      "aisleId": "AISLE1",
      "sectionId": "SEC1",
      "levelId": "LEVEL1",
      "positionId": "POS1"
    },
    {
      "facilityId": "FAC001",
      "locationSeqId": "2",
      "areaId": "AREA1",
      "aisleId": "AISLE1",
      "sectionId": "SEC1",
      "levelId": "LEVEL1",
      "positionId": "POS2"
    },
    {
      "facilityId": "FAC001",
      "locationSeqId": "3",
      "areaId": "AREA1",
      "aisleId": "AISLE1",
      "sectionId": "SEC2",
      "levelId": "LEVEL1",
      "positionId": "POS1"
    }
  ]
}
```

#### 3. ProductFacility
- **Description**: Links products to a specific facility, indicating the minimum stock levels and reorder quantities for automated stock management. 
- **Key Attributes**: `facilityId`, `productId` 
- **Example**: Let's define the product-facility association.
```json
{
  "ProductFacility": [
    {
      "facilityId": "FAC001",
      "productId": "PROD10001"
    },
    {
      "facilityId": "FAC001",
      "productId": "PROD10002"
    },
    {
      "facilityId": "FAC001",
      "productId": "PROD20001"
    }
  ]
}
```

#### 4. ProductFacilityLocation
- **Description**: Links a product to a specific location within a facility, helping to track inventory and manage replenishment for pick/primary or bulk storage. 
- **Key Attributes**: facilityId, productId, locationId 
- **Example**: Let's define the product-facility-location association.
```json
{
  "ProductFacilityLocation": [
    {
      "productId": "PROD10001",
      "facilityId": "FAC001",
      "locationSeqId": "1"
    },
    {
      "productId": "PROD10002",
      "facilityId": "FAC001",
      "locationSeqId": "2"
    },
    {
      "productId": "PROD20001",
      "facilityId": "FAC001",
      "locationSeqId": "3"
    }
  ]
}
```

#### 5. FacilityParty
- **Description**: Associates a party (e.g., a person or an organization) with a facility in a specific role, such as manager, owner, or tenant. 
- **Key Attributes**: `facilityId`, `partyId`, `roleTypeId` 
- **Example**: John Doe is an employee at the facility, lets create the relationship.
```json
{
  "FacilityParty" {
    "facilityId": "FAC001",
    "partyId": "PER123",
    "roleTypeId": "EMPLOYEE"
  }
}
```

#### 6. FacilityGroup
- **Description**: Represents a group of facilities, used to organize facilities for management, pricing, or other purposes. Facility groups can be hierarchical, with parent-child relationships between groups.
- **Key Attributes**: `facilityGroupId`, `facilityGroupTypeEnumId`, `parentGroupId`
- **Example**: Let's define a facility group that includes facilties that are open for fulfillment requests.
```json
{
  "FacilityGroup": {
    "facilityGroupId": "GRP001",
    "facilityGroupTypeEnumId": "FULFILLMENT",
  }
}
```

#### 7. FacilityGroupMember
- **Description**: Associates a warehouse facility with a facility group, allowing the warehouse to be categorized under a specific group for easier management or pricing. 
- **Key Attributes**: `facilityGroupId`, `facilityId`, `fromDate` 
- **Example**: ABC organization allows fulfillment at both of their facilites, lets create the relationships.

```json
{
  "FacilityGroupMember": [
    {
      "facilityGroupId": "GRP001",
      "facilityId": "FAC001"
    },
    {
      "facilityGroupId": "GRP001",
      "facilityId": "FAC002"
    }
  ]
}
```

#### 8. FacilityContactMech
- **Description**: Associates a facility with a contact mechanism, such as a postal address, phone number, email, or web address. This is used to record how the facility can be contacted for various purposes, such as correspondence, shipments, or general inquiries.
- **Key Attributes**: `facilityId`, `contactMechId`, `contactMechPurposeTypeId`, `fromDate`
Example: Let's define the relevant contact information for both facilities.
```json
{
  "FacilityContactMech": [
    {
      "facilityId": "FAC001",
      "contactMechId": "10002",
      "contactMechPurposeTypeId": "SHIPPING_LOCATION",
      "fromDate": "2000-01-01"
    },
    {
      "facilityId": "FAC001",
      "contactMechId": "10000",
      "contactMechPurposeTypeId": "PRIMARY_PHONE",
      "fromDate": "2000-01-01"
    },
    {
      "facilityId": "FAC002",
      "contactMechId": "10004",
      "contactMechPurposeTypeId": "PRIMARY_LOCATION",
      "fromDate": "2000-01-01"
    }
  ]
}















### Introduction to Apache OFBiz and Facility Data Model

Apache OFBiz (Open For Business) is an extensive open-source ERP (enterprise resource planning) system. The Facility data model within OFBiz plays a crucial role in managing physical locations such as warehouses, retail stores, and manufacturing units. This model is designed to efficiently oversee operations, inventory, and logistics, making it essential for effective supply chain and inventory management.

### Types of Facilities and Their Purposes

#### 1. Warehouses
   - **Purpose**: Central to storage and distribution, key for inventory management and logistical efficiency.

#### 2. Retail Stores
   - **Purpose**: Points of sale and customer interaction, important for product display and direct sales.

#### 3. Manufacturing Units
   - **Purpose**: Focus on production, transforming raw materials into finished products, often including machinery and production lines.

### Locations within a Facility

The Facility model in OFBiz includes various internal locations like zones, racks, and bins, which help in:

- **Inventory Management**: Ensuring accurate tracking of goods within a facility.
- **Space Optimization**: Effective utilization of space through strategic goods placement.
- **Resource Optimization**: Efficient allocation of resources based on the location of goods.

### Facility Owner Modeling

In OFBiz, the Facility Owner is represented within the Party data model, linking facility management with broader business processes.

### Contact Mechanisms and FacilityContactMech Purpose

#### ContactMech and FacilityContactMech Entities
OFBiz uses the `ContactMech` entity to manage different types of contact information. The `FacilityContactMech` entity links a facility with its respective contact mechanisms, ensuring a structured approach to managing contact details. This linkage is essential for operational efficiency and accurate information management.

#### PostalAddress and TelecomNumber Entities
   - **Postal Addresses**: Store detailed postal information for facilities, critical for shipping, legal compliance, and communication.
   - **Phone Numbers**: Linked to facilities for essential communication, customer service, and emergency responses.

### Sample JSON Data

```json
{
  "Facility": {
    "facilityId": "Warehouse123",
    "facilityTypeId": "Warehouse",
    "ownerPartyId": "CompanyABC"
  },
  "FacilityContactMech": [
    {
      "facilityId": "Warehouse123",
      "contactMechId": "CM1001",
      "fromDate": "2024-01-01"
    },
    {
      "facilityId": "Warehouse123",
      "contactMechId": "CM9001",
      "fromDate": "2024-01-01"
    }
  ],
  "ContactMech": [
    {
      "contactMechId": "CM1001",
      "contactMechTypeId": "POSTAL_ADDRESS"
    },
    {
      "contactMechId": "CM9001",
      "contactMechTypeId": "TELECOM_NUMBER"
    }
  ],
  "PostalAddress": {
    "contactMechId": "CM1001",
    "address1": "123 Business Ave",
    "city": "Business City",
    "postalCode": "12345",
    "countryGeoId": "USA"
  },
  "TelecomNumber": {
    "contactMechId": "CM9001",
    "contactNumber": "+1-123-456-7890"
  }
}
```

This JSON data correctly mirrors the integrated approach of the OFBiz data model, displaying how the Facility entity is connected with `FacilityContactMech`, which in turn links to `ContactMech`, `PostalAddress`, and `TelecomNumber` entities. This structure highlights the systematic and organized way in which OFBiz manages facility-related contact information.