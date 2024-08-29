## Introduction

This guide focuses on setting up a database, loading data, and creating a custom Moqui component.

### Database Setup and Data Load

Moqui can be configured to use various databases. In this example, we'll set up MySQL.

#### Framework Setup for Development

1. **Open a Terminal:** Launch your terminal application.
2. **Sandbox Directory:** Navigate to your development directory (e.g., `~/sandbox`).
3. **Clone Repository:** Clone the Moqui framework:
   ```bash
   git clone -b master https://github.com/moqui/moqui-framework.git
   ```
4. **Add Runtime:**
   ```bash
   cd moqui-framework
   ./gradlew getRuntime
   ```
5. **Clone Required Components:** Navigate to the `moqui-framework/runtime/component` directory and clone the necessary components:
   ```bash
   git clone -b master https://github.com/moqui/mantle-usl.git
   git clone -b master https://github.com/moqui/mantle-udm.git
   ```

### Prerequisites

* **Java 8:** Ensure you have Java 8 installed. Check your version with: `java -version`
* **MySQL 5.7.x:**  Make sure you have MySQL 5.7.x installed. Check your version with: `mysql -version`

## Assignment

### Tasks

#### 1. Database Setup

* **Add JDBC Driver:** Add the MySQL JDBC driver dependency to your custom component's `build.gradle` file:
  ```
  runtime 'mysql:mysql-connector-java:5.1.47'
  ```
  You can download a sample `build.gradle` file for reference and add the dependency.
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



