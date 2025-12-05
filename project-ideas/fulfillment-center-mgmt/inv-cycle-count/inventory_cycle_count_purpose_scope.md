# **Inventory Cycle Count Microservice — Purpose, Scope & Responsibilities**

## **Purpose**
The **Inventory Cycle Count microservice** provides an independent, pluggable engine for planning, executing, and reconciling physical inventory counts across stores and warehouses.

It relies on external systems—such as **Shopify**, **NetSuite**, and **HotWax Commerce OMS**—for product master data and official on-hand quantities. After counts are performed, the service analyzes discrepancies and emits **inventory adjustment proposals** back to those systems.

This microservice **never acts as the inventory system of record**. Instead, it focuses on making the counting process accurate, repeatable, auditable, and reusable across multiple backends.

---

## **Scope**

### **In Scope**
The microservice is responsible for the following functional areas:

### **1. Count Planning & Setup**
- Creating and managing cycle count runs (e.g., weekly, monthly, annual, ad-hoc).
- Defining facilities, zones, locations, and item sets to be included.
- Supporting configuration rules and parameters for different types of counts.

### **2. Count Execution**
- Creating individual user or device sessions for executing a count.
- Capturing scanned or manually entered quantities per item and location.
- Supporting recounts, partial sessions, and multi-user count operations.

### **3. Reconciliation**
- Fetching system on-hand quantities from Shopify, NetSuite, HotWax Commerce OMS, or other inventory systems.
- Comparing counted quantities against official system quantities.
- Calculating variances at item/location level.
- Applying rules and thresholds to flag variances for review.

### **4. Adjustment Proposals**
- Generating proposed adjustments (increase/decrease) per item and location.
- Emitting these proposals to external systems through APIs or event streams.
- Tracking adjustment status (pending, accepted, rejected, failed).

### **5. Auditability & Reporting**
- Recording who counted what, where, and when.
- Maintaining a full history of sessions, variances, and decisions.
- Generating KPIs and audit logs within the cycle count domain.

---

## **Out of Scope**
The microservice **explicitly does not** perform the following:

### **1. Product Master Data Management**
- Does not maintain SKU definitions, descriptions, categories, or costs.

### **2. Inventory System of Record**
- Does not own or update official on-hand inventory quantities.
- Does not apply adjustments directly inside Shopify, NetSuite, or OMS systems.

### **3. Order & Supply Chain Processing**
- Does not manage sales orders, purchase orders, shipments, transfers, or returns.
- Does not calculate ATP or availability.

### **4. Authentication & Identity Management**
- Does not manage user accounts or global permissions.
- May store local roles (e.g., session approver), but relies on external identity systems.

---

## **Service Boundary Summary**
> **The Inventory Cycle Count microservice plans, executes, and reconciles physical counts, using product and inventory information from external systems like Shopify, NetSuite, and HotWax Commerce OMS, and emits adjustment proposals back to those systems. It never acts as the inventory system of record.**

---

## **Intended Integrations**
The service is designed to integrate cleanly with multiple backend systems via adapters:
- **Shopify** – product master, inventory levels, adjustment APIs.
- **NetSuite** – items, locations, on-hand quantities, inventory adjustments.
- **HotWax Commerce OMS** – unified commerce inventory, ATP feeds, adjustments.
- **Custom Inventory Systems** – pluggable adapter model supports extension.


