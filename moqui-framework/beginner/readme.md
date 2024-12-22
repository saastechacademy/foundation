## Ordered list of recommended reading and assignments

1. [Getting Started](getting-started.md)
2. [MySQL Database setup](database-setup.md)
3. [Developing Service](developing-services.md)
4. [Writing Services in minilang](writing-services-in-minilang.md)
5. [Developing REST API](developing-rest-api.md)
6. https://github.com/saastechacademy/foundation/blob/main/moqui-framework/beginner/introduction-to-mantle.md
7. https://github.com/saastechacademy/foundation/blob/main/moqui-framework/beginner/introduction-to-system-message.md
8. https://github.com/saastechacademy/foundation/blob/main/moqui-framework/beginner/status.md
9. https://github.com/saastechacademy/foundation/blob/main/moqui-framework/beginner/define-entity-relationships-index.md
10. https://github.com/saastechacademy/foundation/blob/main/moqui-framework/beginner/fulfillment-loc-setup.md


## Resetting IntelliJ IDEA Project Settings for a Moqui Project

**Steps:**

1. **Close the Moqui Project in IntelliJ:**  Make sure the project isn't open in the IDE.
2. **Navigate to Your Project Folder:**  Open your terminal and use the `cd` command to navigate to the main folder of your Moqui project (the one that contains the `gradlew` file).
3. **Delete the `.idea` Folder:** Run the following command in the terminal:
    ```bash
    rm -rf .idea
    ```
    This removes IntelliJ's project-specific settings.
4. **Reopen IntelliJ:**  Launch IntelliJ IDEA.
5. **Open Project as New:**
    * Go to **File -> Open...** and select your Moqui project folder.
    * **Important:** Do NOT use the "Recent Projects" menu option, as this could re-import the old settings.

**Explanation:**

* IntelliJ stores project-specific settings in the hidden `.idea` folder.  Deleting this folder forces the IDE to rebuild its project configuration from scratch when you reopen the project.
* This is useful when you want to clear out any cached settings, resolve configuration issues, or start fresh with a Moqui project. 
