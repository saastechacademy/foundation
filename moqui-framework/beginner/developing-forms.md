# Assignment: Create a Custom Form in Moqui

## Objectives

This assignment evaluates your ability to:

- Follow Moqui documentation and instructions effectively.
- Define and implement a form in a custom Moqui screen.
- Utilize Moqui’s sub-screen and form widgets.
- Demonstrate proficiency in Git and GitHub for source code management.
- Follow proper naming conventions and Moqui design patterns.

---

## Tasks

Complete the following tasks to demonstrate your understanding of Moqui and related technologies:

### [**Step 1: Add a Create Form for party entity**](https://moqui.org/m/docs/framework/Quick+Tutorial#AddaCreateForm)
1. Add a transition to the `PartyScreen.xml` file, and call the create service for `party` entity.
    - Set the default response to `default response`.
2. Add a `container-dialog` element to include a create form within the `PartyScreen.xml` screen.
2. Define a `form-single` element inside the dialog with the following:
   - Use the `auto-fields-entity` element with `field-type="edit"` to create input fields.
   - Add a `transition` element to handle the form submission.
   - Ensure all other elements to create a party, like `name` are properly defined.

### **Step 2: Test the Forms in Moqui UI**
1. Run the Moqui application and access the `PartyScreen` sub-screen via the configured URL.
2. Test the create form by adding new records and verifying they appear in the search results.


## Evaluation Criteria

- The sub-screen is properly defined and integrated into the `PartyScreen.xml` screen.
- The search form and create form are functional and meet the requirements.
- The forms interact correctly with the `Party` entity.
- Proper usage of Git and GitHub for version control.
- Clean and readable code adhering to Moqui standards.
