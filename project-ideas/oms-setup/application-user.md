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



| Function Name in PWA | Use Case | Server Side API Endpoint | Parameters | Data Elements Received |
|---|---|---|---|---|
| fetchUsers | Retrieves a list of users | performFind | viewIndex, viewSize, partyId, partyId_op, firstName, firstName_op, lastName, lastName_op, lastName_ic, userName, userName_op, userName_ic, userLoginId, userLoginId_op, userLoginId_ic, enabled, enabled_op, hasLoggedOut, hasLoggedOut_op, lastLoginTime, lastLoginTime_op, lastLoginTime_ic, lastLogoutTime, lastLogoutTime_op, lastLogoutTime_ic, passwordHint, passwordHint_op, passwordHint_ic, requirePasswordChange, requirePasswordChange_op, externalAuthId, externalAuthId_op, entityName, noConditionFind | count, docs |
| fetchUserGroups | Retrieves a list of user groups | performFind | viewIndex, viewSize, partyId, partyId_op, userGroupId, userGroupId_op, userGroupId_ic, entityName, noConditionFind | count, docs |
| updateUserLogin | Updates an existing user login | updateUserLogin | userLoginId, currentPassword, newPassword, newPasswordVerify, requirePasswordChange | status, message |
| createUserLogin | Creates a new user login | createUserLogin | userLoginId, partyId, enabled, password, passwordVerify, requirePasswordChange, externalAuthId | status, message | 
| deleteUser | Deletes a user login | deleteUserLogin | userLoginId | status, message |
| updatePerson | Updates information about a person | updatePerson | partyId, firstName, lastName | status, message |
| createPerson | Creates a new person record | createPerson | firstName, lastName | status, message |
| fetchUserLogin | Retrieves details for a specific user login | performFind | userLoginId, userLoginId_op, entityName, noConditionFind, fieldList | count, docs |
| fetchUserLoginSecurityGroups | Retrieves security groups associated with a user login | performFind | userLoginId, groupId, groupId_op, entityName, noConditionFind, fromDate, fromDate_op | count, docs |
| addUserGroup | Adds a user to a security group | addUserLoginToSecurityGroup | userLoginId, groupId, fromDate | status, message |
| removeUserGroup | Removes a user from a security group | removeUserLoginFromSecurityGroup | userLoginId, groupId, fromDate | status, message |
| hasPermissions | Checks if a user has specific permissions | hasPermissions | permissionIds, userLoginId |  status (indicating whether the user has the permissions) |
| getUserPermissions | Gets all permissions for a user | getUserPermissions | userLoginId | list of permissions |
| getUserPermissionGroups | Gets all permission groups for a user | getUserPermissionGroups | userLoginId | list of permission groups |
| addUserPermissionGroup | Adds a user to a permission group | addUserPermissionGroup | userLoginId, groupId | status |
| removeUserPermissionGroup | Removes a user from a permission group | removeUserPermissionGroup | userLoginId, groupId | status |


