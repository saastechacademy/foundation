**1. Introduction**

*   **Purpose:** This document outlines the process of setting up an organization (representing a retailer) in the HotWax Commerce (HC) OMS system, including creating the organization entity and assigning relevant roles.
*   **Scope:** This document covers the basic organization setup using the `Party`, `PartyGroup`, and `PartyRole` entities in Apache OFBiz, along with considerations for HotWax Commerce customizations.

**2. Entities Involved**

*   **`Party`:** Represents the organization as a legal entity.
*   **`PartyGroup`:** Provides additional details about the organization, such as its name and logo.
*   **`PartyRole`:** Assigns roles to the organization, defining its functions and relationships within the system.

**3. Organization Setup Process**

1.  **Create `Party` Record:**
    *   Create a new `Party` record with `partyTypeId` set to "PARTY\_GROUP" to represent the organization.
    *   Assign a unique `partyId` to the organization (e.g., the company's domain name or a custom ID).

2.  **Create `PartyGroup` Record:**
    *   Create a `PartyGroup` record with the same `partyId` as the `Party` record.
    *   Set the `groupName` field to the organization's name.
    *   Optionally, set the `logoImageUrl` field to the URL of the organization's logo.

3.  **Assign `PartyRole` Records:**
    *   Assign relevant roles to the organization using the `PartyRole` entity.
    *   Include the following roles as a starting point:
        *   `INTERNAL_ORGANIZATIO`: Designates the organization as an internal entity within the system.
        *   `BILL_TO_CUSTOMER`: Allows the organization to be billed as a customer.
        *   `SHIP_FROM_VENDOR`: Indicates that the organization can ship products as a vendor.
        *   `VENDOR`: A general vendor role for vendor-related operations.
    *   Consider adding other roles based on the specific needs and functionalities of the organization.

**4. Sample Organization Setup Data**

```xml
<Party partyId="COMPANY" partyTypeId="PARTY_GROUP"/>
<PartyGroup partyId="COMPANY" groupName="Your Company Name" logoImageUrl="/resources/uploads/images/your_company_logo.png"/>
<PartyRole partyId="COMPANY" roleTypeId="INTERNAL_ORGANIZATIO"/>
<PartyRole partyId="COMPANY" roleTypeId="BILL_TO_CUSTOMER"/>
<PartyRole partyId="COMPANY" roleTypeId="SHIP_FROM_VENDOR"/>
<PartyRole partyId="COMPANY" roleTypeId="VENDOR"/>
```

```json
{
  "partyId": "COMPANY",
  "partyTypeId": "PARTY_GROUP",
  "statusId": "PARTY_ENABLED",
  "partyGroup": {
    "groupName": "Your Company Name",
    "logoImageUrl": "/images/your_company_logo.png"
  },
  "partyRoles": [
    { "roleTypeId": "BILL_FROM_VENDOR" },
    { "roleTypeId": "BILL_TO_CUSTOMER" }
  ],
  "contactMechs": [
    {
      "contactMechId": "9000",
      "contactMechTypeId": "POSTAL_ADDRESS",
      "infoString": "2003 Open Blvd, Open City, CA",
      "partyContactMech": {
        "fromDate": "2000-01-01T00:00:00.000Z",
        "allowSolicitation": "Y"
      }
    },
    {
      "contactMechId": "Company",
      "contactMechTypeId": "EMAIL_ADDRESS",
      "infoString": "ofbiztest@example.com",
      "partyContactMech": {
        "fromDate": "2000-01-01T00:00:00.000Z",
        "allowSolicitation": "Y"
      }
    }
  ]
}
```
```xml
<rest-path path="/parties">
    <method name="POST" service="create#Party"/>
</rest-path>
```
**Entity Engine Auto-Save:**
*   Moqui’s entity engine will automatically parse the JSON, create or update the Party, and cascade operations to dependent entities (PartyGroup, PartyRole, ContactMech, etc.).

*   Replace `"Your Company Name"` with the actual name of the organization.
*   Replace `"/resources/uploads/images/your_company_logo.png"` with the actual URL of the organization's logo.

# Updating an Organization

This section explains how to update the details of an existing organization using the Organization Setup API. For example, updating the organization name to **"NotNaked Fashion Inc"**.

---

## API Endpoint

- **URL**: `/rest/parties`
- **Method**: `PUT`
- **Description**: Updates an existing organization by modifying its `PartyGroup` details and any related nested data as needed.

---

## Request Payload

The payload for updating an organization's details must include the `partyId` of the organization you want to update. In this example, we are updating the `groupName` for the `PartyGroup` entity.

### Sample Payload

```json
{
  "partyId": "COMPANY",
  "partyTypeId": "PARTY_GROUP",
  "partyGroup": {
    "groupName": "NotNaked Fashion Inc"
  }
}

```



