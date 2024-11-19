### User Setup Process in Apache OFBiz

In OFBiz, setting up a user involves creating and linking several entities:

1.  **`Party`:** Represents a person, organization, or group.
2.  **`Person`:** Stores personal details if the party is a person.
3.  **`PartyRole`:** Assigns roles to the party (e.g., "EMPLOYEE," "CUSTOMER").
4.  **`UserLogin`:** Stores login credentials (username, password).
5.  **`UserPreference`:** Stores user-specific preferences (optional).
6.  **`SecurityGroup`:** Defines a group of users with common permissions.
7.  **`SecurityGroupPermission`:** Grants permissions to a security group.

### Detailed Design Document: User Management Module for HotWax Commerce

**1. Introduction**

*   **Purpose:** This document outlines the design for a user management module in HotWax Commerce to manage store associate accounts, including their contact details, login credentials, and permissions.
*   **Scope:** The module will cover creating, updating, and potentially deactivating store associate accounts. It will also handle assigning roles and permissions to these users.

**2. Entities Involved**

*   **`Party`:** Represents the store associate.
*   **`Person`:** Stores the associate's personal details (name, contact information, etc.).
*   **`PartyRole`:** Assigns the "EMPLOYEE" or "STORE_ASSOCIATE" role to the party.
*   **`UserLogin`:** Stores the associate's login credentials (username, password).
*   **`SecurityGroup`:** Defines security groups for store associates (e.g., "SALES_ASSOCIATE," "MANAGER").
*   **`SecurityGroupPermission`:** Grants permissions to security groups (e.g., "VIEW_ORDERS," "PROCESS_RETURNS").

**3. Module Functionality**

*   **Create a New Store Associate:**
    1.  Create a new `Party` record with `partyTypeId` as "PERSON."
    2.  Create a corresponding `Person` record with the associate's details.
    3.  Assign the "EMPLOYEE" or "STORE_ASSOCIATE" role to the party using `PartyRole`.
    4.  Create a `UserLogin` record for the associate, setting the `partyId` and generating a unique `userLoginId`.
    5.  Assign the associate to appropriate security groups based on their role and responsibilities.

*   **Update Store Associate Details:**
    1.  Allow updating the `Person` record to modify contact details or other personal information.
    2.  Enable updating the `UserLogin` record to change the password or other login-related settings.
    3.  Provide functionality to modify security group assignments.

*   **Deactivate a Store Associate:**
    *   Implement a mechanism to deactivate a user account, potentially by setting a `thruDate` on the `UserLogin` record or using a status field.


**4. Example**

Creating a new store associate named "John Doe":

1.  Create a `Party` record with `partyId` "JOHN\_DOE" and `partyTypeId` "PERSON."
2.  Create a `Person` record with `partyId` "JOHN\_DOE," `firstName` "John," `lastName` "Doe," and other contact details.
3.  Create a `PartyRole` record with `partyId` "JOHN\_DOE" and `roleTypeId` "EMPLOYEE."
4.  Create a `UserLogin` record with `userLoginId` "johndoe" (or similar), `partyId` "JOHN\_DOE," and a secure password.
5.  Assign "JOHN\_DOE" to the "SALES\_ASSOCIATE" security group, granting permissions like "VIEW\_ORDERS" and "PROCESS\_SALES."
