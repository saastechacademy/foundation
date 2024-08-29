## Moqui Introduction

### Prerequisites

* You must have GIT installed on your computer. Go to [https://git-scm.com/book/en/v2/Getting-Started-Installing-Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) to see installation instructions.
* The Java version should be Java 8. Check your Java version with the command:
  ```bash
  java -version
  ```
* You should know how to navigate file directories on your machine using the terminal window (Linux/Mac).
* You must have a GitHub account. Create a new repository named "moqui-training." This will be used for Moqui assignment submissions.
* Link the "moqui-training" repository with `training@hotwaxsystems.com`.

### Introduction

* Go to [https://www.moqui.org/docs/framework/Introduction](https://www.moqui.org/docs/framework/Introduction) to understand the Moqui Framework.
* Go to [https://www.moqui.org/m/docs/framework/Run+and+Deploy](https://www.moqui.org/m/docs/framework/Run+and+Deploy) for detailed installation and setup instructions. The "Framework Setup for Development" section also provides easy steps.
* Watch the Introduction to Moqui video: [Introduction to Moqui](https://www.youtube.com/watch?v=Q2ZM4BcVoCg)

### Framework Setup for Development

1. Open a terminal window.
2. Navigate to `~/sandbox` (or create your development directory).
3. Clone the Moqui framework repository:
   ```bash
   git clone -b master https://github.com/moqui/moqui-framework.git
   ```
4. Navigate to the `moqui-framework` directory and add the runtime component:
   ```bash
   cd moqui-framework
   ./gradlew getRuntime
   ```
5. Run the application:
   ```bash
   ./gradlew run
   ```
   **Note:** Ignore ElasticSearch connection warnings/errors for now.

### IDE Setup

Follow the link to set up the `moqui-framework` project in your IDE: [https://www.moqui.org/m/docs/framework/IDE+Setup/IntelliJ+IDEA+Setup](https://www.moqui.org/m/docs/framework/IDE+Setup/IntelliJ+IDEA+Setup)

## Assignment

### Problem Statement

Create your custom Moqui component.

### This assignment tests your ability to:

* Create a new custom Moqui component.
* Add a new entity definition in the component.

### Tasks

1. Configure the Moqui Framework on your local machine.
2. Verify that the application is up and running.
3. Configure the `xsd` files for Entity Definition, Service Definition, and Service REST API XML schema locations in your IDE.
4. Clone the "moqui-training" repository into the `component` folder under `runtime` in `moqui-framework`.
5. Add the configuration files (`component.xml`, `MoquiConf.xml`) with a basic template to identify your repository as a Moqui component.
6. Add a new entity definition named `MoquiTraining` with the following attributes and data types:
   * `trainingId` (Primary Key)
   * `trainingName` (String)
   * `trainingDate` (Date)
   * `trainingPrice` (Decimal)
   * `trainingDuration` (Integer - number of hours)
7. Run Moqui.
8. Verify that the new `MoquiTraining` entity is visible in the Entity Tools list in the Moqui UI.
9. Push the `moqui-training` component code to the `moqui-training` repository.


### Resources 
1. https://www.youtube.com/watch?v=d_ZiTjzZ-Qs&list=PL6JSOz3-TrFSMiuGounNRnje-JQDi8l8g&index=2&t=3s
2. https://www.youtube.com/watch?v=rvi9_ELXDHc&list=PL6JSOz3-TrFSMiuGounNRnje-JQDi8l8g&index=10&t=3s
3. https://www.youtube.com/watch?v=BEhQH0lVW08&list=PL6JSOz3-TrFSMiuGounNRnje-JQDi8l8g&index=15&t=1s

### The Playlist
1. https://www.youtube.com/playlist?list=PL6JSOz3-TrFSBQFDVSyjuZ49BUENd4bH6
