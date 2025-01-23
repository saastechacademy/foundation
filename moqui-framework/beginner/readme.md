# Recommended Reading and Assignments

1. [Getting Started](getting-started.md)
2. [MySQL Database Setup](database-setup.md)
3. [Developing Screens](developing-screens.md)
4. [Developing Entities](developing-entities.md)
5. [Developing Forms](developing-forms.md)
6. [Developing Services](developing-services.md)

8. [Developing REST APIs](developing-rest-api.md)

# Resetting IntelliJ IDEA Project Settings for a Moqui Project

## Steps:

1. **Close the Moqui Project in IntelliJ:** Ensure the project is not open in the IDE.

2. **Navigate to the Project Folder:** Open a terminal and use the `cd` command to navigate to the root folder of your Moqui project (the folder containing the `gradlew` file).

3. **Delete the `.idea` Folder:** Run the following command to remove IntelliJ's project-specific settings:
   ```bash
   rm -rf .idea
   ```

4. **Reopen IntelliJ IDEA:** Start IntelliJ IDEA.

5. **Open the Project as New:**
   - Navigate to **File -> Open...** and select your Moqui project folder.
   - **Important:** Avoid using the "Recent Projects" option to prevent re-importing old settings.

## Explanation:

- IntelliJ IDEA stores project-specific settings in the hidden `.idea` folder. Deleting this folder forces the IDE to recreate the project configuration when reopening the project.
- This process is effective for resolving configuration issues, clearing cached settings, or starting fresh with a Moqui project.