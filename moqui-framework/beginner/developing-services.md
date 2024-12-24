# Assignment: Developing Service

### This assignment tests your ability to:

1. Discuss the service type `entity-auto`:
    - Is the name of the entity you defined in Moqui the same as the entity name in MySQL?
    - What did you observe, and why?
    - If MySQL works with SQL but you did not write SQL, does this mean MySQL with Moqui doesn’t require SQL?
    - Discuss differences between ORM and JDBC ([Reference](https://www.geeksforgeeks.org/hibernate-difference-between-orm-and-jdbc/)).

2. Explain Groovy:
    - How is it similar to and different from Java?

3. Explore APIs:
    - What is a RESTful API?
    - What is JsonRPC, and how does it differ from REST APIs?

## Tasks

### Task 1: Create an Entity-Auto Service

- **Goal:** Generate records in the `MoquiTraining` entity automatically.
- **Steps:**
    - Use `entity-auto` service type.
    - Define input parameters for all non-primary key fields of `MoquiTraining`.
    - Include validations:
        - `trainingName` is mandatory.
        - `trainingDate` must follow `MM/dd/yyyy` format.
    - Ensure the service returns the `trainingId`.

### Task 2: Implement Services

- **Default Type:** Create a service with the default type to generate `MoquiTraining` records.
- **Groovy Script:** Write a Groovy service for logic and data creation.

### Task 3: Prepare Data File

- **CSV File:** Create a CSV file to input data into the entity.

### Task 4: Load and Verify Data

- **Load Data:** Populate the entity from the CSV file using Gradle tasks or equivalent.
- **Verify:**
    - Check if records are created in the database.
    - Test services directly via Moqui UI or API calls.

## Submission Instructions

- Commit and push the service implementations and CSV file to the `moqui-training` repository on GitHub.

---

## Tutorial

Moqui services are the backbone of application logic, enabling data management, updates, and workflows.

1. [Moqui Training Video 3](https://www.youtube.com/watch?v=6kFwPlPk92c)
2. [Moqui Training Video 4](https://www.youtube.com/watch?v=EpEt9ndJUWA&list=PL6JSOz3-TrFSMiuGounNRnje-JQDi8l8g&index=5&t=1s)


### Key Concepts

- **Execution Context:** Provides a runtime environment for Moqui artifacts and framework tools.
- **Service Definition:** Specifies the service name, parameters, and attributes.
- **Service Implementation:** Contains service logic written in Groovy or Java.
- **Service Invocation:** Call services from other services, screens, or scripts.

### Entity-Auto Services

Entity-auto services simplify operations like create, update, and delete.

### Validation and Testing

- Input validation ensures data integrity.
- Test rigorously to meet functional and performance requirements.

