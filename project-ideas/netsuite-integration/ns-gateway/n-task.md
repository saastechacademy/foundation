# **N/Task Module**

The **N/task** module in SuiteScript 2.x allows developers to create and submit tasks that run asynchronously within NetSuite’s task queue. These tasks are ideal for high-volume operations such as importing CSV files, exporting data using Saved Searches, or initiating Map/Reduce scripts.

Task-based execution improves performance and avoids governance limits by offloading heavy work to NetSuite’s background processing engine.

---

# **CSVImportTask**

`CSVImportTask` enables asynchronous import of CSV files into NetSuite using saved Import Maps configured through the Import Assistant.

### **Key capabilities**

* Efficiently imports CSV files without blocking script execution.
* Uses the Import Assistant’s **saved mappings** (`importMapId`) to map CSV columns to NetSuite fields.
* Runs fully asynchronously in NetSuite’s task queue.

### **Important facts (official NetSuite limits)**

* CSV import jobs have a **25,000-row limit per CSV file**.
* Only record types supported by the CSV Import Assistant can be imported.
  (Examples of unsupported types include Item Receipt, Item Fulfillment, some transaction children.)

### **Why CSVImportTask matters in HotWax Commerce**

CSVImportTask is used for:

* Importing Sales Orders into NetSuite
* Importing Transfer Orders
* Importing inventory adjustments
* Bulk updates where CSV import is supported and more efficient than N/record

---

# **SearchTask**

`SearchTask` executes a Saved Search asynchronously and writes the results to a CSV file in the NetSuite File Cabinet.

### **Key capabilities**

* Extremely fast export of large datasets (hundreds of thousands to millions of rows).
* Executes using a Saved Search ID (`savedSearchId`).
* Automatically generates a CSV file in the File Cabinet for further processing.
* Avoids governance limits associated with N/search or Map/Reduce fetch loops.

### **Ideal for**

* High-volume data exports (inventory, sales orders, POs, transfers).
* Situations where Map/Reduce overhead is unnecessary.
* Scheduled or recurring file-based integrations.

### **Notes**

* Output format is always CSV.
* Some complex joins are not supported and must be simplified in the Saved Search definition.

---

# **Other Task Types (Supported by NetSuite but not used in our integration)**

For completeness and accuracy, the Task module also provides:

* **MapReduceScriptTask** — starts a Map/Reduce script.
* **WorkflowTriggerTask** — triggers a workflow.
* **RecordActionTask** — performs async record operations.

HotWax Commerce uses only `CSVImportTask` and `SearchTask` extensively for NetSuite integration.
