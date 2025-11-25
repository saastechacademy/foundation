# Assignment: Configure Moqui to Use MySQL Database for Application Development

This assignment evaluates your ability to:

- Work with Gradle.
- Install and configure MySQL.
- Understand and use CHARACTER SET utf8:
  - Why is this setting used?
  - How does it impact MySQL behavior?
  - What other character sets are available?
- Understand JDBC Driver:
  - Explain `Class.forName("oracle.jdbc.driver.OracleDriver");`
  - What is the IP address of your laptop at this moment?
  - What is the significance of `entity_ds_host` in `<default-property name="entity_ds_host" value="127.0.0.1"/>`?
  - Explain `127.0.0.1` and `localhost`.

## Tasks

### 1. Install MySQL
- Install MySQL version 8.0.32 or higher.
- Run the `mysql_secure_installation` command to secure your MySQL installation:
  ```bash
  mysql_secure_installation
  ```
- During the process, you will be prompted with the following questions:
  1. **Set the root password?**
     - Recommended: Yes. Enter a strong password for the root user.
  2. **Remove anonymous users?**
     - Recommended: Yes. This disables anonymous access to the database.
  3. **Disallow root login remotely?**
     - Recommended: Yes. This prevents unauthorized remote access to the root account.
  4. **Remove test database and access to it?**
     - Recommended: Yes. This removes the default test database to enhance security.
  5. **Reload privilege tables now?**
     - Recommended: Yes. This applies the changes immediately.
- Ensure the MySQL service is running and accessible.

### 2. Add JDBC Driver
- Download and install the MySQL JDBC driver (MySQL Connector/J 8.0.32) from [this link](https://dev.mysql.com/downloads/connector/j/).
- Add the driver to your Moqui setup:
  - Place the driver JAR file in the `runtime/lib` directory.

### 3. Create a Database
- Create a database named `moqui` with the UTF-8 character set. Use the following SQL command:
  ```sql
  CREATE DATABASE moqui CHARACTER SET utf8;
  ```
- Create a user named `moqui` with all permissions:
  ```sql
  CREATE USER 'moqui'@'localhost' IDENTIFIED BY '@12345abC';

  GRANT ALL PRIVILEGES ON moqui.* TO 'moqui'@'localhost';

  FLUSH PRIVILEGES;
  ```
- Verify the database creation and user permissions using MySQL Workbench or the MySQL CLI.
- Verify the database creation using MySQL Workbench or the MySQL CLI.

### 4. Update Configuration
1. Modify `runtime/conf/MoquiDevConf.xml` with your database details as `default-property`:

   - Identify the database configuration name based on the MySQL version installed on your system. All possible database configurations available with Moqui can be found in the MoquiActualConf.xml file under the database-list section.
   - Specify the host for local connections
   - Define the database name you created (e.g., moqui) 
   - Provide the username and password for the database user.

### 5. Load Data
1. Navigate to the `moqui-framework` directory in your terminal.
2. Run the following command to load the data:
   ```bash
   ./gradlew load
   ```
3. Verify that the data has been loaded successfully:
   - Check the Moqui UI under [**System Dashboard**](http://localhost:8080/vapps/system/dashboard).

## Additional Information

### CHARACTER SET utf8
- **Why use UTF-8?** It ensures support for a wide range of characters, enabling internationalization.
- **Impact on MySQL:** It allows storage and retrieval of Unicode data, ensuring compatibility with diverse languages.
- **Other Character Sets:** Available options include `latin1`, `utf8mb4` (supports full Unicode), and more. Use `utf8mb4` for complete Unicode compatibility.

### JDBC Driver
- **Purpose:** Establishes a connection between Java applications and a database.
- **Example:**
  ```java
  Class.forName("oracle.jdbc.driver.OracleDriver");
  ```
  This dynamically loads the JDBC driver class into memory.

### IP Address and Hostname
- **IP Address of Your Laptop:** Use `ipconfig` (Windows) or `ifconfig`/`ip a` (Linux/Mac) to find your current IP address.
- **Significance of `entity_ds_host`:** Specifies the database host. `127.0.0.1` refers to the local machine.
- **Difference between `127.0.0.1` and `localhost`:** Both refer to the local machine, but `localhost` resolves to an IP address (usually `127.0.0.1`) via DNS.

## Assignment Submission
1. Push the newly created data files and configuration changes to your `moqui-training` repository on GitHub.
2. Ensure the repository includes:
   - Updated `MoquiDevConf.xml` with database configurations.
   - A README file explaining your setup process.

### Helpful Resources
1. [Database Configuration in Moqui (Video)](https://youtu.be/i4JUYTGiKSE)
2. [MySQL JDBC Documentation](https://dev.mysql.com/doc/connector-j/8.0/en/)
3. [Moqui Framework Documentation](https://www.moqui.org)