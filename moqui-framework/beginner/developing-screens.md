# Assignment: Create a Custom Screen in Moqui

## Objectives

This assignment evaluates your ability to:

- Follow Moqui documentation and instructions effectively.
- Define and implement a new screen in a custom Moqui component.
- Demonstrate proficiency in Git and GitHub for source code management.
- Utilize the Moqui UI for testing and validation.
- Follow proper JAVA naming conventions.

## Tasks

### **Step 1: [Define a New Screen](https://moqui.org/m/docs/framework/Quick+Tutorial#AddaScreen)**
1. Inside the `party` component, create a directory structure to store screen definitions.
2. Define a screen named `PartyScreen.xml` that includes the following:
   - A title for the screen.
   - [The screen must show a list/table of all Party records](https://moqui.org/m/docs/framework/Quick+Tutorial#FindScreenwithAutomaticFindForm).
   - Ensure the screen follows Moqui's schema standards.

### **Step 2: [Mount the Screen](https://moqui.org/m/docs/framework/Quick+Tutorial#MountasaSubscreen)**
1. Update the Moqui configuration file to mount your screen at a specific URL path (e.g., `/partyScreen`).
2. Ensure the path is unique and accessible through the Moqui web application.

### **Step 3: Test the Screen in Moqui UI**
1. Run the Moqui application and access the newly mounted screen using the configured URL path.
2. Verify that the screen displays correctly and the HTML widgets are rendered as expected.

### **Step 4: Version Control**
1. Initialize a Git repository in the `party` directory.
2. Commit your changes with meaningful commit messages.
3. Push the repository to your GitHub account under a repository named `party`.

## Deliverables

1. A link to the GitHub repository containing your `party` component.

## Evaluation Criteria

- The `party` component is correctly structured.
- The `partyScreen` is properly defined and accessible in the Moqui application.
- The screen displays correctly with the intended content and layout.
- Proper usage of Git and GitHub for version control.
- Clean and readable code adhering to Java naming conventions.
