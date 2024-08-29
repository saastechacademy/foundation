## Introduction to Writing Services in Minilang

This guide focuses on writing services in Moqui's Minilang, a domain-specific language designed for simplifying business logic.

### Service Wrappers and Examples

* **Service Wrappers:** Moqui provides convenient service wrappers to interact with various entities and operations.
* **Examples:**
   * `entity-find`: Find entity records based on criteria.
   * `entity-auto`: Automate common entity actions (create, update, delete).
   * `service-call`: Invoke other services within your logic.

### Additional Concepts

* **Return Errors:** Handle and report errors gracefully within your services.
* **Log Statements:** Use logging to record useful information during service execution.
* **Passing Parameters:**
   * **Context:** The service context provides access to variables and objects.
   * **Additional Parameters:** You can pass extra parameters alongside the context.
   * **Custom Map:** Organize parameters using a map for clarity.
   * **List Parameters:** Services can accept list-type input parameters.

### Framework Setup for Development

(Same steps as in previous guides, so omitted for brevity)

## Assignment

### Tasks

1. **Fetch MoquiTraining Records:**
   * Create a new service to fetch records from the `MoquiTraining` entity.
   * Allow filtering by `trainingName` or `trainingId`.
   * Return a list of records containing only `trainingId`, `trainingName`, and `trainingDate`.

2. **Create/Update MoquiTraining Records:**
   * Implement a service to create or update records in the `MoquiTraining` entity.
   * Check for existing records using `trainingName` or `trainingId`.
   * Update if a record exists; create a new one otherwise.
   * Validate input:
       * `trainingName` is mandatory.
       * `trainingDate` format is "MM/dd".
   * Return the `trainingId`.

3. **Run Service and Verify:**

   * Test the new services to ensure they create, update, and retrieve records correctly.

### Assignment Submission

Push your new service implementations to the "moqui-training" repository on GitHub.

### Resources

1. https://www.youtube.com/watch?v=gAeYvAU9S2Y
2. https://www.youtube.com/watch?v=5dJbW2MCiqU&list=PL6JSOz3-TrFSMiuGounNRnje-JQDi8l8g&index=11&t=1094s
3. https://www.youtube.com/watch?v=sWvbrgHuPUQ&list=PL6JSOz3-TrFSMiuGounNRnje-JQDi8l8g&index=12&t=2s
