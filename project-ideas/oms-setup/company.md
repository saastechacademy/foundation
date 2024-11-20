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

*   Replace `"Your Company Name"` with the actual name of the organization.
*   Replace `"/resources/uploads/images/your_company_logo.png"` with the actual URL of the organization's logo.

