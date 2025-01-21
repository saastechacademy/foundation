# Assignment: Create Custom Moqui Component

## Objectives

This assignment evaluates your ability to:

- Follow documentation and instructions effectively.
- Utilize Moqui official documentation.
- Properly set up your IDE.
- Create a custom Moqui component.
- Define a new entity in the custom component.
- Demonstrate proficiency in Git and GitHub for source code management.
- Navigate the Moqui UI.
- Read and understand logs.
- Follow proper JAVA naming conventions.

## Tasks

Complete the following tasks to demonstrate your understanding of Moqui and related technologies:

1. Set up the Moqui Framework on your local machine.
2. Verify that the Moqui application runs successfully.
3. Configure `xsd` files for Entity Definition, Service Definition, and Service REST API XML schema locations in your IDE. [IDE Setup Guide](https://www.moqui.org/m/docs/framework/IDE+Setup/IntelliJ+IDEA+Setup) 
4. Create a `moqui-training` repository inside the `component` folder under `runtime` in `moqui-framework`.
5. Add configuration files (`component.xml`, `MoquiConf.xml`) with a basic template to identify your repository as a Moqui component.
6. Define a new entity named `MoquiTraining` with the following attributes and data types:
   - `trainingId` (Primary Key)
   - `trainingName` (String)
   - `trainingDate` (Date)
   - `trainingPrice` (Decimal)
   - `trainingDuration` (Integer - number of hours)
7. Run the Moqui application.
8. Confirm that the `MoquiTraining` entity is listed in the Entity Tools section of the Moqui UI.
9. Add data into the `MoquiTraining` entity using the Moqui UI. [Data Import in Moqui](http://localhost:8080/vapps/tools/Entity/DataImport)
10. Push the `moqui-training` component code to the `moqui-training` repository on GitHub.

## Getting Started with Moqui

### Prerequisites

- [Introduction to Moqui Framework](https://www.moqui.org/m/docs/framework/Introduction)
- [Git Installation Guide](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
- Install JDK 11:
  - [JDK 11](https://jdk.java.net/java-se-ri/11-MR3)
  - [OpenJDK](https://adoptium.net/temurin/archive/?version=11)
  - Verify Java installation with:
    ```bash
    java -version
    ```
- [Intellij IDE installation.](https://www.jetbrains.com/idea/download/?section=mac) 
- Familiarity with navigating file directories using the terminal (Linux/Mac).
- Active GitHub account with a repository named `moqui-training` for assignment submissions.

## Setup Moqui for Application Development

1. Open a terminal.
2. Create a folder named `sandbox`:
   ```bash
   mkdir ~/sandbox
   cd ~/sandbox
   ```
3. Clone the Moqui Framework repository:
   ```bash
   git clone -b master https://github.com/moqui/moqui-framework.git
   ```
4. Navigate to the `moqui-framework` directory and initialize the runtime component:
   ```bash
   cd moqui-framework
   ./gradlew getRuntime
   ```
5. Run the Moqui application:
   ```bash
   ./gradlew load run
   ```
   **Note:** Ignore any ElasticSearch connection warnings/errors.

Refer to the [official documentation](https://www.moqui.org/m/docs/framework/Run+and+Deploy) for further details.


## Additional Resources

- [Introduction to Moqui](https://www.youtube.com/watch?v=Q2ZM4BcVoCg)
- Video Tutorials:
  - [Video 1](https://www.youtube.com/watch?v=d_ZiTjzZ-Qs&list=PL6JSOz3-TrFSMiuGounNRnje-JQDi8l8g&index=2&t=3s)
  - [Video 2](https://www.youtube.com/watch?v=rvi9_ELXDHc&list=PL6JSOz3-TrFSMiuGounNRnje-JQDi8l8g&index=10&t=3s)
  - [Video 3](https://www.youtube.com/watch?v=BEhQH0lVW08&list=PL6JSOz3-TrFSMiuGounNRnje-JQDi8l8g&index=15&t=1s)
- [Complete Playlist](https://www.youtube.com/playlist?list=PL6JSOz3-TrFSBQFDVSyjuZ49BUENd4bH6)
- [Creating an Entity](https://www.moqui.org/m/docs/framework/Quick+Tutorial#MyFirstEntity)
- [Add Some Data](https://www.moqui.org/m/docs/framework/Quick+Tutorial#AddSomeData)


## Best Practices

- [Java Package Naming Guidelines](https://docs.oracle.com/javase/tutorial/java/package/namingpkgs.html)