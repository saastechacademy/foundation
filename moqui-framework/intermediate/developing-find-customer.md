# Assignment: Build a Dynamic Customer Finder

**Objective:**  
You will be designing a "Find Customer" view screen to simplify customer management. The retailer requires that the customer's primary email address serve as the unique identifier for each customer.

You will define a structured approach for managing customer information, implement services for customer creation and updates, and establish relationships between customers and contact mechanisms. This will involve working with entities, services, and events within the OFBiz framework.  
Assignment Steps

### Step 1: Analyze the Reference File (`FindParty.groovy`)
- Review the provided `FindParty.groovy` file.
- Identify:
  - Common patterns, such as dynamic condition building using `EntityFind`.
  - How filters like `LIKE` queries and case-insensitivity are implemented.
  - Pagination and metadata handling logic.

### Step 2: Define the `FindCustomerView` Entity
1. Create a new `PartyViewEntities.xml` file.
2. Create a new view-entity named `FindCustomerView`. Modify the structure for customer-specific needs.
3. Test this view-entity in isolation to ensure it joins data correctly and returns the expected fields.

### Step 3: Define the `findCustomer` Service
1. Create a new `PartyServices.xml` file.
2. Add a new service definition for `findCustomer`. Ensure the following:
   - Input parameters cover all the filters in the `FindCustomer.groovy` script.
   - Output parameters include both the list of `partyId` values and pagination metadata.
3. Save and validate the service definition.

### Step 4: Create `FindCustomer.groovy`
1. Create a new Groovy script named `FindCustomer.groovy`.
2. Design the script for customer-specific fields and conditions by adapting the logic from `FindParty.groovy`. Avoid directly reusing the code—focus on optimizing it for clarity and efficiency.
3. Ensure the script meets these requirements:
   - Support the following filters:
     - `emailAddress`
     - `firstName`
     - `lastName`
     - `contactNumber`
     - `postalAddress`
   - Implement sorting based on:
     - `combinedName` (sort by `firstName` and `lastName`).
   - Uses the above defined `FindCustomerView` entity.
   - Handle pagination and calculate metadata like page ranges and total counts.
4. Test the script with sample data to ensure the functionality works as expected.

### Step 5: Implement `createCustomer` and `updateCustomer` Services
1. Open the `PartyServices.xml` file.
2. Add a new service definition for `createCustomer`. 
   - Use the `findCustomer` service to ensure the customer does not already exist before creating a new record.
   - When creating the `Customer` input only the follow information:
      - `emailAddress`
      - `firstName` and `lastName`
3. Add a service definition for `updateCustomer`. 
   - Input parameters:
      - `emailAddress` (required)
      - `postalAddress`
      - `phoneNumber`
   - Use the `findCustomer` service to ensure the customer exists before attempting to update.
   - Allow the ability to add/update the customer's postal address and phone number.
4. Save and validate the service definitions.

### Step 6: Testing and Validation
1. Deploy the updated files (`FindCustomer.groovy`, `PartyServices.xml`, and `PartyViewEntities.xml`) to your Moqui component.
2. Test the `createCustomer` and `updateCustomer` services by:
   - Creating a new customer with valid data.
   - Ensuring duplicate email addresses cannot be created.
   - Updating the customer's data using their `emailAddress`.
   - Verifying that the phone number and address are updated successfully.
3. Use the `findCustomer` service to confirm that the newly created or updated customer appears in query results.
4. Document any issues encountered and how you resolved them.

## Deliverables
1. A fully functional `FindCustomer.groovy` file.
2. `PartyServices.xml` file with the `findCustomer`, `createCustomer`, and `updateCustomer` service definitions.
3. `PartyViewEntities.xml` file with the `FindCustomerView` entity definition.