## Introduction to Moqui Services

Moqui services are the fundamental building blocks of logic within Moqui applications. They handle various operations like data retrieval, updates, and complex business processes.

### Key Concepts

* **Execution Context:** The central environment for executing Moqui artifacts (screens, services, etc.). It holds state and provides access to framework tools.
* **Service Definition:** Defines the service's name, parameters, and attributes (e.g., location, authentication).
* **Service Implementation:** Contains the actual logic of the service, written in Groovy or Java.
* **Calling Services:** Services can be invoked from other services, screens, or scripts.

## Assignment

### Tasks

#### 1. Create an Entity-Auto Service

* **Goal:** Create a service that automatically generates records in the `MoquiTraining` entity.
* **Implementation:**
    * Use the `entity-auto` service type.
    * Define input parameters for all non-primary key fields of `MoquiTraining`.
    * Include validations:
        * `trainingName` is mandatory.
        * `trainingDate` format should be "MM/dd/yyyy".
        * Add other necessary validations.
    * Ensure the service returns the generated `trainingId`.

#### 2. Implement Services

* **Default Type:** Implement a service with the default type to create `MoquiTraining` records.
* **Groovy Script:** Implement a service with logic written in a Groovy script to create data.

#### 3. Prepare Data File

* **CSV File:** Create a CSV file to input data into the entity using the new services.

#### 4. Data Load and Verification

* **Load Data:** Execute the data load process (e.g., using Gradle tasks) to populate the entity from the CSV file.
* **Verify Results:** 
    * Ensure records are correctly created in the database.
    * Test the service implementations directly (e.g., through the Moqui UI or API calls) to ensure they function as expected.

### Assignment Submission

Push all new service implementations and the CSV data file to your "moqui-training" repository on GitHub.

**Additional Notes**

* **Entity-Auto Services:**  These services streamline common entity operations like create, update, and delete.
* **Validation:** Thorough input validation is essential to maintain data integrity.
* **Flexibility:** Moqui provides multiple ways to implement service logic (Groovy, Java, or other custom methods) to suit your preferences.
* **Testing:** Always thoroughly test your services to ensure they meet your application's requirements.

### Resources
1. https://www.youtube.com/watch?v=EpEt9ndJUWA&list=PL6JSOz3-TrFSMiuGounNRnje-JQDi8l8g&index=5&t=1s
2. https://www.youtube.com/watch?v=6kFwPlPk92c

