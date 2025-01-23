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

### **Step 1: Create a Sub-Screen**
1. Navigate to the `component` folder in the `runtime` directory of `moqui-framework`.
2. Add the `FindMoquiTraining` sub-screen to the `MoquiTrainingScreen.xml` screen under the `<subscreens>` element, ensuring it is configured as the default sub-screen.

### **Step 2: Define the Sub-Screen Structure**
1. Create a file named `FindMoquiTraining.xml` in the `screen` directory of your component.
2. Define the sub-screen with the following structure:
   - A search form for finding records.
   - A form-list to display the results of the search.
   - Use the `entity-find` action to query the `MoquiTraining` entity.

### **Step 3: Configure the Search Form**
1. Inside the `<widgets>` element, add a `form-list` widget to display the search results.
2. Properly configure the following attributes in `form-list`:
    - `name`
    - `list`
    - `header-dialog`
    - `skip-form`
3. Use the `auto-fields-entity` element to automatically generate fields for the `MoquiTraining` entity.
4. Properly configure the following attributes in `auto-fields-entity`:
    - `entity-name`
    - `field-type`


### **Step 4: Add a Create Form**
1. Add a transition to the `FindMoquiTraining.xml` file, and call the create service for `moqui-training`.
    - Set the default response to `default response`.
2. Add a `container-dialog` element to include a create form within the `MoquiTraining` screen.
2. Define a `form-single` element inside the dialog with the following:
   - Use the `auto-fields-entity` element with `field-type="edit"` to create input fields.
   - Add a `transition` element to handle the form submission.
   - Ensure all other elements, like `name` are properly defined.
 
### **Step 5: Test the Forms in Moqui UI**
1. Run the Moqui application and access the `FindMoquiTraining` sub-screen via the configured URL.
2. Verify that the search form displays and returns results from the `moquiTraining` entity.
3. Test the create form by adding new records and verifying they appear in the search results.

## Deliverables

1. A link to the GitHub repository containing your `moqui-training` component.

## Evaluation Criteria

- The sub-screen is properly defined and integrated into the `MoquiTrainingScreen.xml` screen.
- The search form and create form are functional and meet the requirements.
- The forms interact correctly with the `MoquiTraining` entity.
- Proper usage of Git and GitHub for version control.
- Clean and readable code adhering to Moqui standards.
