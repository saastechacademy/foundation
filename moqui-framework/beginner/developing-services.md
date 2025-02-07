# Assignment: Create a Custom Service in Moqui

## Objectives

This assignment evaluates your ability to:

- Follow Moqui documentation and instructions effectively.
- Define and implement a new service in a custom Moqui component.
- Utilize Moqui’s Service Tools for testing and validation.
- Demonstrate proficiency in Git and GitHub for source code management.
- Follow proper JAVA naming conventions.

## Tasks

### **Step 1: Define a New Service**
1. Inside the `moqui-training` component, create a directory structure to store service definitions.
2. Define a create service for the `MoquiTraining` entity with the following:
   - An input parameter: `trainingName` (String, **required**).
   - Allow any other parameters to be sent optionally.
   - A logic to generate a response string such as `"Training [trainingName] created successfully!"`.
   - Ensure the service is defined using Moqui’s XML schema for services and marks `trainingName` as a required parameter.

### **Step 2: Implement the Service Logic**
1. Create a Groovy file to implement the service logic.
2. The logic should:
   - Validate that `trainingName` is provided and return an error if it is missing.
   - Accept and process any additional parameters sent.
   - Return the response string as defined above.

### **Step 3: Expose the Service as a REST API**
1. In the `services` directory of your component, configure the REST API using a `Service REST API XML` file (e.g., `MoquiTraining.rest.xml`).
2. Define an endpoint for the create service.

### **Step 4: Load Demo Data**
1. Create a file named `TrainingDemoData.xml` in the `data` directory of your `moqui-training` component.
2. Define sample data entries for the `MoquiTraining` entity.
3. Use the Moqui Data Loader to import the data:
   - Run the Moqui application and access the Data Import tool.
   - Import the `TrainingDemoData.xml` file.

### **Step 5: Test the Service in Moqui UI**
1. Run the Moqui application and access the Service Tools section.
2. Execute the create service by providing a value for the `trainingName` parameter.
3. Optionally, pass additional parameters and verify they are handled correctly.
4. Verify that the response matches the expected output.

### **Step 6: Test the REST API**
1. Test the REST API using Postman:
   - Open Postman and create a new POST request.
   - Set the base URL + the rest endpoint. Both can be found in the Swagger documentation.
   - In the **Body** tab, select `raw` and enter a test JSON payload.
   - Click **Send** and verify the API response matches the expected output.


## Deliverables

1. A link to the GitHub repository containing your `moqui-training` component.

## Evaluation Criteria

- The `moqui-training` component is correctly structured.
- The create service is properly defined, implemented, and tested.
- The service logic validates the required parameter `trainingName` and processes additional optional parameters.
- Demo data is correctly loaded using `TrainingDemoData.xml` and visible in Moqui.
- Proper usage of Git and GitHub for version control.
- Clean and readable code adhering to Java naming conventions.
