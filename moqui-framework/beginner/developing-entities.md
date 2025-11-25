# Assignment: Create a Custom Entity in Moqui

## Objectives

This assignment evaluates your ability to:

- Follow Moqui documentation and instructions effectively.
- Define a new entity in a custom Moqui component.
- Demonstrate proficiency in Git and GitHub for source code management.
- Utilize the Moqui UI for testing and validation.
- Follow proper JAVA naming conventions.

---

## Tasks

Complete the following tasks to demonstrate your understanding of Moqui and related technologies:

### **Step 1: Create a New Component**
1. Navigate to the `component` folder in the `runtime` directory of `moqui-framework`.
2. Create a new folder named `moqui-training` for your custom component.
3. Add configuration files to identify your component:
   - Create a `component.xml` file for your component.
   - Update the main configuration file to recognize your component.

### **Step 2: Define a New Entity**
1. Inside the `moqui-training` component, create a directory structure to store entity definitions.
2. Define an entity named `MoquiTraining` with the following attributes and their data types:
   - `trainingId` (Primary Key)
   - `trainingName` (String)
   - `trainingDate` (Date)
   - `trainingPrice` (Decimal)
   - `trainingDuration` (Integer - number of hours)
3. Ensure the entity definition follows Moqui's schema standards.

### **Step 3: Test the Entity in Moqui UI**
1. Run the Moqui application and access the Entity Tools section.
2. Verify that the `MoquiTraining` entity is listed and properly defined.
3. Add sample data into the `MoquiTraining` entity using the Data Import tool available in Moqui.

### **Step 4: Version Control**
1. Commit your changes with meaningful commit messages.
2. Push the repository to your GitHub account under a repository named `moqui-training`.

---

## Deliverables

1. A link to the GitHub repository containing your `moqui-training` component.

---

## Evaluation Criteria

- The `moqui-training` component is correctly structured.
- The `MoquiTraining` entity is properly defined and visible in the Entity Tools section.
- Sample data is successfully added to the entity.
- Proper usage of Git and GitHub for version control.
- Clean and readable code adhering to Java naming conventions.

---