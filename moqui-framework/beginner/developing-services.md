# Assignment: Create a Custom Person Creation Service in Moqui

## Objective

This assignment evaluates your ability to:

- Define a service for the Person entity  
- Handle entity relationships (Person ↔ Party)  
- Implement validation logic using Groovy  
- Expose the service as a REST API  
- Test the service using Moqui UI and Postman  

---

## [Step 1: Define a New Service](https://moqui.org/m/docs/framework/Quick+Tutorial#CustomCreateService)

Inside the **party** component, create a directory structure to store service definitions.

Define a **create service** for the **Person entity** with the following requirements:

- Input parameters:
  - `partyId` (String, **required**)  
  - `firstName` (String, **required**)  
  - `lastName` (String, **required**)  
- Optional parameter:
  - `dateOfBirth` (Date)  
- Allow any other parameters to be sent optionally  
- Generate a response string such as:  
  **"Person [firstName] [lastName] created successfully!"**
- Ensure the service:
  - Uses **Moqui’s XML schema for services**
  - Marks all required parameters correctly  

---

## [Step 2: Implement the Service Logic](https://moqui.org/m/docs/framework/Quick+Tutorial#GroovyService)

Create a **Groovy file** to implement the service logic.

The logic should:

- Validate that `partyId`, `firstName`, and `lastName` are provided  
- Return an error if any required parameter is missing  
- Verify that a **Party record exists** for the given `partyId`  
- Ensure the Person is created **only if the Party exists**  
- Accept and process any additional parameters  
- Return the response string defined in Step 1  

---

## Step 3: Expose the Service as a REST API

In the **services directory** of the party component, configure the REST API using a **Service REST API XML file** (for example, `Person.rest.xml`).

Ensure that:

- A REST endpoint is defined for the create Person service  
- The endpoint accepts an HTTP **POST** request  

---

## Step 4: Test the Service in Moqui UI

Run the Moqui application and open the **Service Tools** section.

- Execute the create Person service  
- Provide values for:
  - `partyId`  
  - `firstName`  
  - `lastName`  
- Optionally provide `dateOfBirth`  
- Verify that:
  - Validation errors appear when inputs are missing  
  - The service succeeds only when a valid Party exists  
  - The response message matches the expected output  

---

## Step 5: Test the REST API

Test the Person REST API using **Postman**:

1. Create a new **POST** request  
2. Set the **base URL + REST endpoint**  
   - Refer to the **Swagger documentation**  
3. In the **Body** tab:
   - Select **raw**  
   - Enter a JSON payload  
4. Send the request and verify:
   - Correct validation behavior  
   - Proper response message on success  

---

## Expected Outcome

By the end of this assignment, you should have:

- A create service for the **Person entity**  
- Validation enforcing the **Person–Party relationship**  
- A REST API exposed for Person creation  
- Successful execution via **Moqui UI** and **Postman**
