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
```