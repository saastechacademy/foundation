# **SuiteScript**

Learn how HotWax Commerce uses SuiteScript 2.x to integrate with NetSuite through scheduled automation, Map/Reduce processing, modular APIs, and secure file exchange.

NetSuite’s **SuiteScript 2.x** is a modern, JavaScript-based scripting framework that enables developers to customize and automate NetSuite. It provides both **server-side** and **client-side** capabilities, and its modular design gives granular access to records, searches, files, tasks, workflows, and external services.

HotWax Commerce relies specifically on SuiteScript **server-side automation** to support large-scale, resilient, batch-based integration with NetSuite.

---

# **Why SuiteScript Matters in HotWax Commerce Integration**

SuiteScript powers all core NetSuite ↔ HotWax integrations. It enables:

### ✔ Automated scheduled exports

Used for inventory, items, sales orders, transfers, and other business objects.

### ✔ Large-scale data handling

Made possible through Map/Reduce scripts, which automatically handle parallelization and slicing.

### ✔ Data transformation

SuiteScript can convert NetSuite records into HotWax-compatible CSV/JSON formats before transferring files to SFTP.

### ✔ File generation and secure file exchange

SuiteScript can write files to the NetSuite File Cabinet and upload/download files via external SFTP using NetSuite’s **N/sftp** module.

### ✔ Reliable batch processing

Batch jobs avoid real-time API limitations, governance constraints, and high-volume performance bottlenecks.

---

# **Types of SuiteScript Used in Our Integration**

Although NetSuite supports multiple script types (Client Scripts, User Events, RESTlets, Suitelets, Scheduled Scripts, Map/Reduce Scripts), HotWax Commerce relies primarily on the following:

---

## **1. Scheduled Scripts**

Scheduled Scripts run at predefined intervals or on demand.

### **Use Cases**

* Exporting moderate-size datasets
* File generation
* Kicking off CSVImport tasks
* Housekeeping jobs
* Uploading files from the File Cabinet to SFTP

### **Key limitations (from official SuiteScript governance)**

* Max **10,000 governance units** per execution
* Max **1-hour runtime** (hard limit)

Because of these constraints, Scheduled Scripts are not suitable for processing very large datasets.

---

## **2. Map/Reduce Scripts**

Map/Reduce (M/R) scripts are designed to handle **very large datasets** efficiently.

### **Why Map/Reduce is preferred**

* Automatically manages parallelization
* Breaks workloads into small slices
* Re-runs failed slices safely
* Avoids governance unit exhaustion
* Highly scalable for millions of records

### **Use Cases**

* Large product exports
* Large inventory exports
* Bulk imports of CSV data
* Processing high volume NetSuite records

Map/Reduce is the backbone of HotWax’s NetSuite integration strategy.

---

# **SuiteScript Modules Used in Integration**

SuiteScript 2.x uses a modular architecture. The following modules form the core of HotWax Commerce’s integration scripts.

---

## **1. N/task Module**

Used for:

* Creating and submitting **CSVImportTask**
* Triggering **SearchTask** for fast exports
* Scheduling scripts programmatically

This module is essential for handling bulk record imports into NetSuite.

---

## **2. N/record Module**

Used when importing data types not supported by the CSV Import Engine.

* Create/update NetSuite records
* Supports synchronous or scripted inserts
* Subject to strict governance limits

Only used when necessary because it cannot efficiently process large datasets.

---

## **3. N/search Module**

Core module for reading NetSuite records.

Used to:

* Execute Saved Searches
* Retrieve record fields and joins
* Provide input data for Map/Reduce

Every export flow (products, inventory, sales orders, transfers, POs) uses N/search.

---

## **4. N/file Module**

Used for:

* Creating CSV/JSON files
* Storing files in the NetSuite File Cabinet
* Reading existing files from the File Cabinet

⚠️ **Note:**
N/file **cannot** read or write directly to external SFTP locations.
(Official docs confirm this.)

To work with external SFTP, use **N/sftp**.

---

## **5. N/sftp Module** *(Missing in original documentation — added for accuracy)*

Required for secure file transfer.

Supports:

* Uploading export files to external SFTP servers
* Downloading import files from external SFTP servers
* Key-based authentication
* Encrypted file transfer

This is a critical module for HotWax’s integration because file-based sync relies on SFTP.

---

# **Summary**

HotWax Commerce’s NetSuite integration is built on a strongly structured SuiteScript 2.x foundation. It uses:

* **Scheduled Scripts** → for lightweight batch jobs
* **Map/Reduce Scripts** → for heavy, high-volume processing
* **N/task**, **N/record**, **N/search**, **N/file**, and **N/sftp** → for data operations, transformation, file management, and secure transfer

Together, these tools ensure **fast, scalable, resilient** integration between NetSuite and HotWax Commerce.
