# OFBiz Data Model and UI Interaction Assignment

This assignment is designed to help you become familiar with the Apache OFBiz data model by interacting with both the user interface (UI) and the backend (via webtools and XML data loading). Follow each section’s steps carefully. If you have any questions, please reach out to your supervisor.

> **Important Links:**
> - **Party Manager Screen:** [Party Manager](https://localhost:8443/partymgr/control/findparty) 
> - **Product Store Screen:** [Product Store Manager](https://localhost:8443/catalog/control/FindProductStore)
> - **Catalog Screen:** [Catalog Manager](https://localhost:8443/catalog/control/FindCatalog)
> - **Order Screen:** [Order Manager](https://localhost:8443/ordermgr/control/orderentry)

## Part 1: Party Data Model

In OFBiz, a “party” can be a person or an organization. You will create several person records, assign customer roles, update details, and modify related contact information. There are four activities.

### Activity 1 – Party Manager (Mark Tailor)
Use the Party Manager Screen to execute the following steps.
1. **Create and Update a Person**
   - Log in to the Party Manager.
   - **Create a Person:** Create a person with the name **“Mark Tailor.”**
   - **Assign a Role:** Assign the **Customer** role to this person.
   - **Update Name:** Change the name from **“Mark Tailor”** to **“Mark K Tailor.”**
2. **Add Contact Information to Customer Profile**
   - Add an **email address**.
   - Add a **billing phone**.
   - Add a **shipping phone**.
   - Add a **shipping address**.
   - Add a **billing address**.
3. **Synchronize and Modify Addresses**
   - Set the billing and shipping addresses to be the same.
   - Change the purpose of the billing address to **“General correspondence address.”**
4. **Modify Contact Records**
   - Delete (or mark as expired) the existing email address and add a new one.
   - Delete (or mark as expired) the existing billing address and add a new one.
   - Delete (or mark as expired) the existing shipping address and add a new one.

### Activity 2 – Webtools (John Liston)
Repeat the steps in **Activity 1** using the Webtools interface:
1. **Create a Person:**
   - Create a person named **“John Liston.”**
   - Assign the **Customer** role.
   - Update the name to **“John D Liston.”**
2. **Add/Update Contact Information:**
   - Add an email address, billing phone, shipping phone, shipping address, and billing address.
   - Set billing and shipping addresses to be the same.
   - Change the billing address purpose to **“General correspondence address.”**
   - Delete and recreate the email address, billing address, and shipping address as specified.
3. **Observation:**  
   - After making changes, review the party profile page to verify that your updates are correctly reflected.

### Activity 3 – Combined Approach (John Hays)
1. **Using Party Manager:**
   - Create a person named **“John Hays.”**
   - Assign the **Customer** role.
   - Update the name to **“John B Hays.”**
   - Add an email address, billing phone, and two shipping phone numbers.
   - Add a shipping address and a billing address.
   - Set the billing and shipping addresses to be the same.
   - Change the billing address purpose to **“General correspondence address.”**
   - **Additional:** Create a credit card record for this customer.
2. **Using Webtools:**
   - Add a user login for the newly created party.
   - Assign a security group that grants access to the Party Manager application.
   - Verify that the new user login has access to the Party Manager.
3. **Final Updates:**
   - Delete and recreate the email address.
   - Delete and add new billing and shipping addresses.
4. **Observation:**  
   - Check the party profile page in both the Party Manager and Webtools to ensure the updates appear correctly.

### Activity 4 – Combined Approach (David Zeneski)
1. **Using Party Manager:**
   - Create a person named **“David Zeneski.”**
   - Assign the **Customer** role.
   - Update the name to **“David R Zeneski.”**
   - Add an email address, billing phone, shipping phone, shipping address, and billing address.
   - Set the billing and shipping addresses to be the same.
   - Change the billing address purpose to **“General correspondence address.”**
   - **Additional:** Create a credit card record.
2. **Using Webtools:**
   - Add **two** user logins for this party.
   - Assign one user login to a security group for **Order Manager** access.
   - Assign the other user login to a security group for **Party Manager** access.
   - Verify that each user login has the correct access permissions.
3. **Final Updates:**
   - Delete and recreate the email address.
   - Delete and add new billing and shipping addresses.
4. **Observation:**  
   - Review the party profile page to confirm that all changes and access settings are correct.

## Part 2: Company, Product Store, and Catalog Setup

In this part, you will create and configure the company information, roles, product store group, and product store. You will then use both the UI and XML methods to load the data.

### Activity 1 – Company Information
Use the product store manager screen to execute the following steps. 
1. **Create a Company:**  
   - **Company ID:** `COMPANY`
   - **Company Name:** `Default Company`
   - **Company Logo URL:** `/resources/uploads/images/company_logo.png`

### Activity 2 – Company Roles
1. **Assign Roles to the Company:**  
   - Roles to add:
     - Bill From Vendor
     - Ship From Vendor
     - Bill To Customer
     - Internal Organization
     - Supplier Agent
     - Supplier
     - Vendor

### Activity 3 – Product Store Group
1. **Create a Product Store Group:**  
   - **Store Group Name:** `Company Store Group`
   - **Description:** `Company Store Group`
   - **Store Group ID:** `STORE_GROUP`

### Activity 4 – Product Store
1. **Create a Product Store:**  
   - **Store ID:** `STORE`
   - **Store Name:** `Demo Store`
   - **Group:** `Company Store Group` (use `STORE_GROUP`)
   - **Company Name:** `Company`
   - **Store Attributes:**  
     - Primary Store Group ID: `STORE_GROUP`
     - Inventory Policy: `Non-reserving`
     - Locale: `English (US)`
     - Currency: `USD`
     - Sales Channel: `Web Sales`
     - Invoice and Order Approval: `Automatic`
2. **Observation:**  
   - Verify your Product Store data by visiting the Product Store screen.
### Activity 5 – Reset and Create via Webtools
1. **Reset the local OFBiz database.**
2. Repeat **Activities 1-4** using the Webtools interface.
3. **Observation:**  
   - Use the OFBiz admin screens to verify that the Company, Company Roles, Product Store Group, and Product Store are correctly created.

### Activity 6 – XML Data Load
1. **Reset the local OFBiz database.**
2. Prepare the data (from Activities 1-4) as an XML file.
3. Load the XML file using Webtools.
4. **Observation:**  
   - Confirm via the admin screens that all data (Company, Roles, Product Store Group, and Product Store) is properly loaded.

## Part 3: Catalog Setup and Management

In this section, you will create a catalog, define categories, features, products, and promotions. You will then verify the data using both UI and XML load methods.

### Activity 1 – Create Shoes Catalog
1. **Create the Catalog:**  
   - Name your catalog **“Shoes Catalog.”**
2. **Define Categories:**  
   - **Browse Root**
     - **Men**
       - MSports
       - MFormal
       - MParty
     - **Women**
       - WSports
       - WFormal
       - WParty
     - **Children**
     - **Promotion**
3. **Observation:**  
   - Verify your Catalog creation by visiting the Catalog screen at:  
     [https://localhost:8443/catalog/control/FindCatalog](https://localhost:8443/catalog/control/FindCatalog)

### Activity 2 – Define Features and Products
1. **Features:**
   - **Size:** 7, 8, 9, 10, 11
   - **Color:** Red, Black, White, Brown
2. **Products:**
   - **Virtual Products**
     - Under **Men > MSports:**
       - **MS-1:** Colors - White, Brown; Sizes - 7, 8, 9, 10
       - **MS-2:** Colors - Red, Black; Sizes - 7, 10
     - Under **Men > MFormal:**
       - **MF-1:** Colors - Red, Black; Sizes - 7, 10
       - **MF-2:** Colors - White, Brown; Sizes - 7, 8, 9, 10
     - Under **Men > MParty:**
       - **MP-1:** Colors - White, Brown; Sizes - 7, 8, 9, 10
       - **MP-2:** Colors - Red, Black; Sizes - 7, 8, 9, 10
     - Under **Women > WSports:**
       - **WS-1:** Colors - White, Brown; Sizes - 7, 8, 9
       - **WS-2:** Colors - Red, Black; Sizes - 7, 8
     - Under **Women > WFormal:**
       - **WF-1:** Colors - White, Brown; Sizes - 7, 8, 9
       - **WF-2:** Colors - Red, Black; Sizes - 7, 8, 9
     - Under **Women > WParty:**
       - **WP-1:** Colors - White, Brown; Sizes - 7, 8
       - **WP-2:** Colors - Red, Black; Sizes - 7, 8
     - Under **Children:**
       - **C-1:** Colors - White, Brown; Sizes - 2, 3, 4, 5
       - **C-2:** Colors - Red, Black; Sizes - 2, 3, 5

### Activity 3 – Create Promotion
1. **Promotion Products:**  
   Create a promotion that includes the following products:
   - MS-1 (White, Brown; Sizes 7, 8, 9, 10)
   - MF-2 (White, Brown; Sizes 7, 8, 9, 10)
   - MP-1 (White, Brown; Sizes 7, 8, 9, 10)
   - WS-1 (White, Brown; Sizes 7, 8, 9)
   - WF-1 (White, Brown; Sizes 7, 8, 9)
   - WP-1 (White, Brown; Sizes 7, 8)
   - C-1 (White, Brown; Sizes 2, 3, 4, 5)
   - C-2 (Red, Black; Sizes 2, 3, 5)

### Activity 4 – Create via Webtools
1. **Reset the local OFBiz database.**
2. Repeat **Activities 1-3** using the Webtools interface.
3. **Observation:**  
   - Use the Catalog screen ([https://localhost:8443/catalog/control/FindCatalog](https://localhost:8443/catalog/control/FindCatalog)) and other admin screens to verify that the Catalog, Categories, Features, Products, and Promotions are set up correctly.

### Activity 5 – XML Data Load for Catalog
1. **Reset the local OFBiz database.**
2. Prepare the catalog data (from Activities 1-3) as an XML file.
3. Load the XML data using Webtools.
4. **Observation:**  
   - Verify via the admin screens that the catalog and its associated data are correctly imported.

## Part 4: Order Processing

In this final section, you will work with orders—creating orders, approving them, canceling items, and fulfilling shipments. This activity will help you understand the order lifecycle in OFBiz.

### Activity 1 – Create a New Order
Use the order manager screen to execute the following tasks.
1. **Order Details:**
   - **Order ID:** `HWMDEMO1000`
   - **Order Status:** Created
   - **Order Items:** Select any two products from your catalog.
   - **Order Items Status:** Created
   - **Customer:** Mark Tailor
2. **Shipping Details:**
   - **Shipping Address:**
     ```
     HotWax Media Inc.
     136 S MAIN ST #A200
     Salt Lake City, UT, USA
     Zip: 84101
     Phone: 877.736.4080
     Email: mark.tailor@hotwaxmedia.com
     ```
   - **Shipping Method:** UPS Ground
3. **Billing Details:**
   - **Billing Method:** Credit Card - Visa (e.g., 4111 1111 1111 1111)
   - **Billing Address:** Same as the shipping address

### Activity 2 – Create and Approve an Order
1. **Order Details:**
   - **Order ID:** `HWMDEMO1001`
   - **Order Status:** Approved
   - **Order Items:** Select any two products from your catalog.
   - **Order Items Status:** Approved
   - **Customer:** Mark Tailor
2. **Shipping Details:**
   - **Shipping Address:**
     ```
     HotWax Media Inc.
     136 S MAIN ST #A200
     Salt Lake City, UT, USA
     Zip: 84101
     Phone: 877.736.4080
     Email: mark.tailor@hotwaxmedia.com
     ```
   - **Shipping Method:** UPS Ground
3. **Billing Details:**
   - **Billing Method:** Credit Card - Discover
   - **Billing Address:** Same as the shipping address

### Activity 3 – Cancel an Order Item
1. **Update the Order:** (Order ID: `HWMDEMO1001`)
   - **Order Status:** Cancelled
   - **Order Items Status:** Cancelled
   - **Shipping Method:** FEDEX Ground
   - **Billing Method:** COD
   - Ensure that the customer details and addresses remain as specified.

### Activity 4 – Fulfill and Complete an Order
1. **Update the Order:** (Order ID: `HWMDEMO1001`)
   - **Order Status:** Completed
   - **Order Items Status:** Completed
2. **Update Customer Details:**
   - **Customer:** Mark Tailor
   - **Shipping Address:**
     ```
     HotWax Media Inc.
     307 W 200 S
     Suite 4003
     Salt Lake City, UT
     Zip: 84101
     Phone: 888.405.2667
     Email: mark.tailor@hotwaxmedia.com
     ```
   - **Shipping Method:** UPS Ground
   - **Billing Method:** Credit Card - AMEX
   - **Billing Address:**
     ```
     HotWax Media Inc.
     307 W 200 S
     Suite 4003
     Salt Lake City, UT
     Zip: 84101
     Phone: 888.405.2667
     ```
3. **Order Shipment:**
   - Create a shipment record with:
     - **Shipment ID:** `HwmDemo1000`

### Activity 5 – Webtools Order Processing
1. **Reset the local OFBiz database.**
2. Repeat **Activities 1-4** using the Webtools interface.
3. **Observation:**  
   - Verify the created order, approved order, order with cancelled items, shipment, and completed order using the OFBiz admin screens.

### Activity 6 – XML Data Load for Orders
1. **Reset the local OFBiz database.**
2. Prepare the order data (from Activities 1-4) as an XML file.
3. Load the XML file using Webtools.
4. **Observation:**  
   - Confirm that all order-related data (including shipments) is correctly reflected in the admin screens.