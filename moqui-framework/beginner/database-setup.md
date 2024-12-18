## Introduction

This guide focuses on setting up a database, loading data, and creating a custom Moqui component.

### Database Setup and Data Load

Install MySQL version 8.0.32 or higher.

#### Framework Setup for Development

Follow [getting started guide](getting-started.md)

## Assignment

### Tasks

#### 1. Database Setup

* **Add JDBC Driver:** Add the MySQL JDBC driver dependency to your custom component's `build.gradle` file:

* MySQL Connector/J 8.0.32

* **Create Database:** Create a database named `moqui` (with UTF-8 character set) using the following command:
   ```sql
   CREATE DATABASE moqui CHARACTER SET utf8;
   ```
* **Update Configuration:**
   * **Development:**  Modify `runtime/conf/MoquiDevConf.xml` with your MySQL database name, username, and password:

   ```xml
   <default-property name="entity_ds_db_conf" value="mysql"/>
   <default-property name="entity_ds_host" value="127.0.0.1"/>
   <default-property name="entity_ds_database" value="moqui"/>
   <default-property name="entity_ds_user" value="moqui"/>
   <default-property name="entity_ds_password" value="moqui"/>
   ```
   *Note: For additional guidance, watch this video: [https://youtu.be/i4JUYTGiKSE](https://youtu.be/i4JUYTGiKSE)*

#### 2. Prepare Demo Data (for `MoquiTraining` entity)

Create sample data files in XML, JSON, and CSV formats for your `MoquiTraining` entity.

#### 3. Data Load

1. Navigate to the `moqui-framework` directory.
2. Run the following command to load the data:
   ```bash
   ./gradlew load
   ```
3. Verify the data in the Moqui UI's Entity Tools and your database.

### Assignment Submission

Push the newly added data files from your custom component to your "moqui-training" repository on GitHub.

### Resources 
1. https://www.youtube.com/watch?v=i4JUYTGiKSE&list=PL6JSOz3-TrFSMiuGounNRnje-JQDi8l8g&index=7&t=332s
2. https://www.youtube.com/watch?v=wzakiTwXGEo&list=PL6JSOz3-TrFSMiuGounNRnje-JQDi8l8g&index=14&t=159s
3. https://www.youtube.com/watch?v=i2g6X_huUUg&list=PL6JSOz3-TrFSMiuGounNRnje-JQDi8l8g&index=24
4. https://www.youtube.com/watch?v=b-2Wu4CC1hg

### This assignment tests your ability to:

* What is gradle?
* Install MySQL 
* What is CHARACTER SET utf8? 
  * Why this setting? 
  * How does it change the MySQL behavior? 
  * What other character sets are available?
* What is JDBC Driver? 
  * Explain `Class.forName(“oracle.jdbc.driver.OracleDriver”);`
  * What is the IP address of your laptop at this moment? 
  * What is significance of entity_ds_host in `<default-property name="entity_ds_host" value="127.0.0.1"/>`?
  * Explain `127.0.0.1` and `localhost`
* Discuss, How CSV data is loaded in the database by Moqui framework?


