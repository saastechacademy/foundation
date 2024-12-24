# Assignment: Create custom Moqui component

### This assignment tests your ability to:

* Read documentation and follow instructions.
* Create a new custom Moqui component.
* Add a new entity definition in the component.
* Working knowledge of git and ability to use Github for managing sourcecode.

### Tasks
Learn Moqui and related technologies to complete following tasks.
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


## Getting started with Moqui

### Prerequisites

* [GIT](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
* [JDK 11](https://jdk.java.net/java-se-ri/11-MR3) or compatible JDK distribution.  
* To check your Java version use following command:
  ```bash
  java -version
  ```
* Ability to navigate file directories on your machine using the terminal window (Linux/Mac).
* Active GitHub account. Create a new repository named "moqui-training." This will be used for Moqui assignment submissions.

### Tutorial
* [Introduction to Moqui](https://www.youtube.com/watch?v=Q2ZM4BcVoCg)

### Setup Moqui for application development

1. Open a terminal window.
2. Create folder on your computer, name is "sandbox".
3. Navigate to `~/sandbox`.
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

[Official documentation](https://www.moqui.org/m/docs/framework/Run+and+Deploy).

### IDE Setup

[Set up the moqui in IntelliJ IDE](https://www.moqui.org/m/docs/framework/IDE+Setup/IntelliJ+IDEA+Setup)


### Additional Resources 
1. https://www.youtube.com/watch?v=d_ZiTjzZ-Qs&list=PL6JSOz3-TrFSMiuGounNRnje-JQDi8l8g&index=2&t=3s
2. https://www.youtube.com/watch?v=rvi9_ELXDHc&list=PL6JSOz3-TrFSMiuGounNRnje-JQDi8l8g&index=10&t=3s
3. https://www.youtube.com/watch?v=BEhQH0lVW08&list=PL6JSOz3-TrFSMiuGounNRnje-JQDi8l8g&index=15&t=1s

### The Playlist
1. https://www.youtube.com/playlist?list=PL6JSOz3-TrFSBQFDVSyjuZ49BUENd4bH6
