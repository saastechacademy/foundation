# Assignment: Build a Dynamic Customer Finder

**Objective:**  
Using the provided `FindParty.groovy` file as a reference, create a new dynamic query script, `FindCustomer.groovy`, along with a corresponding service (`findCustomer`) and a view-entity (`FindCustomerView`). Additionally, implement `createCustomer` and `updateCustomer` services for managing customer records. The goal is to enable flexible querying of customer data and provide the capability to create and update customer records dynamically.

## Assignment Steps

### Step 1: Analyze the Reference File (`FindParty.groovy`)
- Review the provided `FindParty.groovy` file.
- Identify:
  - Common patterns, such as dynamic condition building using `EntityFind`.
  - How filters like `LIKE` queries and case-insensitivity are implemented.
  - Pagination and metadata handling logic.

### Step 2: Create `FindCustomer.groovy`
1. Create a new Groovy script named `FindCustomer.groovy`.
2. Design the script for customer-specific fields and conditions by adapting the logic from `FindParty.groovy`. Avoid directly reusing the code—focus on optimizing it for clarity and efficiency.
3. Ensure the script meets these requirements:
   - Support the following filters:
     - `emailAddress`
     - `firstName`
     - `lastName`
     - `phoneNumber`
     - `address`
   - Implement sorting based on:
     - `combinedName` (sort by `firstName` and `lastName`).
   - Handle pagination and calculate metadata like page ranges and total counts.
4. Test the script with sample data to ensure the functionality works as expected.

### Step 3: Define the `findCustomer` Service
1. Create a new `PartyServices.xml` file.
2. Add a new service definition for `findCustomer`. Ensure the following:
   - Input parameters cover all the filters in the `FindCustomer.groovy` script.
   - Output parameters include both the list of `customerId` values and pagination metadata.
3. Save and validate the service definition.

### Step 4: Define the `FindCustomerView` Entity
1. Open the `PartyViewEntities.xml` file.
2. Create a new view-entity named `FindCustomerView`. Modify the structure for customer-specific needs.
3. Test this view-entity in isolation to ensure it joins data correctly and returns the expected fields.

### Step 5: Implement `createCustomer` and `updateCustomer` Services
1. Open the `PartyServices.xml` file.
2. Add a new service definition for `createCustomer`. 
   - Use the `findCustomer` service to ensure the customer does not already exist before creating a new record.
   - When creating the `Customer` require only the follow information:
      - `emailAddress`
      - `firstName` and `lastName`
3. Add a service definition for `updateCustomer`. 
   - Use the `findCustomer` service to ensure the customer exists before attempting to update
   - Allow the ability to add/update the customer's address and phone number.
4. Save and validate the service definitions.

### Step 6: Testing and Validation
1. Deploy the updated files (`FindCustomer.groovy`, `PartyServices.xml`, and `PartyViewEntities.xml`) to your Moqui component.
2. Test the `createCustomer` and `updateCustomer` services by:
   - Creating a new customer with valid data.
   - Ensuring duplicate email addresses cannot be created.
   - Updating the customer's data using their `emailId`.
   - Verifying that the phone number and address are updated successfully.
3. Use the `findCustomer` service to confirm that the newly created or updated customer appears in query results.
4. Document any issues encountered and how you resolved them.

## Deliverables
1. A fully functional `FindCustomer.groovy` file.
2. Updated `PartyServices.xml` file with the `findCustomer`, `createCustomer`, and `updateCustomer` service definitions.
3. Updated `PartyViewEntities.xml` file with the `FindCustomerView` entity definition.