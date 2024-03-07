https://confluence.hotwaxmedia.com/display/IMPL/Data+Model+Exercises

## Party Data Model 

### Activity - 1

Do the following first from partymgr:

    Create a person by name Mark Tailor.
    Assign Customer role to created person.
    Change name of the person to Mark K Tailor.
    Add email address to customer profile.
    Add Billing phone to customer profile.
    Add Shipping phone to customer profile.
    Add Shipping Address to customer profile.
    Add Billing Address to customer profile.
    Make billing and shipping address same.
    Change the purpose of billing address to General correspondence address.
    Delete(Expire) email address and create new.
    Delete(Expire) billing address and add new.
    Delete(Expire) shipping address and add new.

### Activity - 2

Do the following from webtools and see the effect of changes made on party profile page:

    Create a person by name John Liston.
    Assign Customer role to created person.
    Change name of the person to John D Liston.
    Add email address to customer profile.
    Add Billing phone to customer profile.
    Add Shipping phone to customer profile.
    Add Shipping Address to customer profile.
    Add Billing Address to customer profile.
    Make billing and shipping address same.
    Change the purpose of billing address to General correspondence address.
    Delete(Expire) email address and create new.
    Delete(Expire) billing address and add new.
    Delete(Expire) shipping address and add new.

### Activity - 3

Do the following from party manager and then from webtools with observation from party profile page for effects of changes:

    Create a person by name John Hays.
    Assign Customer role to created person.
    Change name of the person to John B Hays.
    Add email address to customer profile.
    Add Billing phone to customer profile.
    Add Shipping phone to customer profile.
    Add Shipping phone to customer profile.
    Add Shipping Address to customer profile.
    Add Billing Address to customer profile.
    Make billing and shipping address same.
    Change the purpose of billing address to General correspondence address.
    Create credit cart for this customer.
    Add userlogin for the created party in the system.
    Assign a security group for accessing partymgr application to the created userLogin.
    Check access for created user login to partymgr application.
    Delete(Expire) email address and create new.
    Delete(Expire) billing address and add new.
    Delete(Expire) shipping address and add new.



### Activity - 4

Do the following from party manager and then from webtools with observation from party profile page for effects of changes:

    Create a person by name David Zeneski.
    Assign Customer role to created person.
    Change the name of the person to David R Zeneski.
    Add email address to customer profile.
    Add Billing phone to customer profile.
    Add Shipping phone to customer profile.
    Add Shipping Address to customer profile.
    Add Billing Address to customer profile.
    Make billing and shipping address same.
    Change the purpose of billing address to General correspondence address.
    Create credit cart for this customer.
    Add two userlogins for the created party in the system.
    Assign a security group for accessing ordermgr to first user and partymgr to second user.
    Check access for both userlogin to ordermgr and partymgr application.
    Delete(Expire) email address and create new.
    Delete(Expire) billing address and add new.
    Delete(Expire) shipping address and add new.


## Setup up Company, Product store and Catalog:

### Activity - 1

1. **Company Information**
   - Company ID: COMPANY
   - Company Name: Default Company
   - Company Logo URL: /resources/uploads/images/company_logo.png

### Activity - 2

2. **Company Roles**
   - Roles for COMPANY: 
     - Bill From Vendor
     - Ship From Vendor
     - Bill To Customer
     - Internal Organization
     - Supplier Agent
     - Supplier
     - Vendor

### Activity - 3

3. **Product Store Group**
   - Store Group Name: Company Store Group
   - Description: Company Store Group
   - Store Group ID: STORE_GROUP

### Activity - 4

4. **Product Store**
   - Store ID: STORE
   - Store Name: Demo Store
   - Group: Company Store Group (STORE_GROUP)
   - Company Name: Company
   - Store Attributes: 
     - Primary Store Group ID: STORE_GROUP
     - Inventory Policy: Non-reserving
     - Locale: English (US)
     - Currency: USD
     - Sales Channel: Web Sales
     - Invoice and Order Approval: Automatic

### Activity - 5
Reset local OFBiz database. 
Repeat activity 1 thru 4, use webtools to create data. Observe the Company, Company Roles, Product Store Group, Product Store using OFBiz admin screens.

### Activity - 6
Reset local OFBiz database. 
Repeat activity 1 thru 4, prepare data as xml file and load data using webtools. Observe the Company, Company Roles, Product Store Group, Product Store using OFBiz admin screens.


## Catalog:

### Activity - 1


Shoes Catalog

Categories:

    Browse Root
    – Men
    — MSports
    — MFormal
    — MParty
    – Women
    — WSports
    — WFormal
    — WParty
    – Children
    Promotion

### Activity - 2 

**Features:**

***Size***

    – 7, 8, 9, 10, 11
***Color***

    – Red, Black, White, Brown

***Products:***

    – Virtual Products
    — Men > MSports
    ---- MS-1 with Color: White, Brown Size: 7, 8, 9, 10
    ---- MS-2 with Color: Red, Black Size: 7, 10
    — Men > MFormal
    ---- MF-1 with Color: Red, Black Size: 7, 10
    ---- MF-2 with Color: White, Brown Size: 7, 8, 9, 10
    — Men > MParty
    ---- MP-1 with Color: White, Brown Size: 7, 8, 9, 10
    ---- MP-2 with Color: Red, Black Size: 7, 8, 9, 10

    — Women > WSports
    ---- WS-1 with Color: White, Brown Size: 7, 8, 9
    ---- WS-2 with Color: Red, Black Size: 7, 8
    — Women > WFormal
    ---- WF-1 with Color: White, Brown Size: 7, 8, 9
    ---- WF-2 with Color: Red, Black Size: 7, 8, 9
    — Women > WParty
    ---- WP-1 with Color: White, Brown Size: 7, 8
    ---- WP-2 with Color: Red, Black Size: 7, 8

    – Children
    — C-1 with Color: White, Brown Size: 2, 3, 4, 5
    — C-2 with Color: Red, Black Size: 2, 3, 5

### Activity - 3

– Promotion

    — MS-1 with Color: White, Brown Size: 7, 8, 9, 10
    — MF-2 with Color: White, Brown Size: 7, 8, 9, 10
    — MP-1 with Color: White, Brown Size: 7, 8, 9, 10
    — WS-1 with Color: White, Brown Size: 7, 8, 9
    — WF-1 with Color: White, Brown Size: 7, 8, 9
    — WP-1 with Color: White, Brown Size: 7, 8
    — C-1 with Color: White, Brown Size: 2, 3, 4, 5
    — C-2 with Color: Red, Black Size: 2, 3, 5

### Activity - 4
Reset local OFBiz database. 
Repeat activity 1 thru 3, use webtools to create data. Observe the Catalog, Categories, Features, Products, Promotion using OFBiz admin screens.

### Activity - 5
Reset local OFBiz database. 
Repeat activity 1 thru 3, prepare data as xml file and load data using webtools. Observe the Catalog, Categories, Features, Products, Promotion using OFBiz admin screens.

## Order 

### Activity 1
Create new order

    Order Id: HWMDEMO1000
    Order Status: Created
    Order Items: any two products from catalog.
    Order Items Status: Created
    Customer Name: Mark Tailor
    Shipping Address:
    HotWax Media Inc.
    136 S MAIN ST #A200
    Salt Lake City, UT, USA
    Zip: 84101
    Phone: 877.736.4080
    Email Address: mark.tailor@hotwaxmedia.com
    Shipping Method: UPS Ground
    Billing Method: Credit Card - Visa 4111 1111 1111 1111
    Billing Address:
    HotWax Media Inc.
    136 S MAIN ST #A200
    Salt Lake City, UT, USA
    Zip: 84101
    Phone: 877.736.4080

### Activity 2
Create new order, and then approve the order

    Order Id: HWMDEMO1001
    Order Status: Approved
    Order Items: any two products from catalog.
    Order Items Status: Approved
    Customer Name: Mark Tailor
    Shipping Address:
    HotWax Media Inc.
    136 S MAIN ST #A200
    Salt Lake City, UT,USA
    Zip: 84101
    Phone: 877.736.4080
    Email Address: mark.tailor@hotwaxmedia.com
    Shipping Method: UPS Ground
    Billing Method: Credit Card - Discover
    Billing Address:
    HotWax Media Inc.
    136 S MAIN ST #A200
    Salt Lake City, UT, USA
    Zip: 84101
    Phone: 877.736.4080

### Activity 3
Cancel an order item


    Order Id: HWMDEMO1001
    Order Status: Cancelled
    Order Items: any two products from catalog.
    Order Items Status: Cancelled
    Customer Name: Mark Tailor
    Shipping Address:
    HotWax Media Inc.
    136 S MAIN ST #A200
    Salt Lake City, UT, USA
    Zip: 84101
    Phone: 877.736.4080
    Email Address: mark.tailor@hotwaxmedia.com
    Shipping Method: FEDEX Ground
    Billing Method: COD
    Billing Address:
    HotWax Media Inc.
    136 S MAIN ST #A200
    Salt Lake City, UT, USA
    Zip: 84101
    Phone: 877.736.4080

### Activity 4
Fulfill order and move the order to completed status.

    Order Id: HWMDEMO1001
    Order Status: Completed
    Order Items: any two products from catalog.
    Order Items Status: Completed
    Customer Name: Mark Tailor
    Shipping Address:
    HotWax Media Inc.
    307 W 200 S
    Suite 4003
    Salt Lake City, UT
    Zip: 84101
    Phone: 888.405.2667
    Email Address: mark.tailor@hotwaxmedia.com
    Shipping Method: UPS Ground
    Billing Method: Credit Card - AMEX
    Billing Address:
    HotWax Media Inc.
    307 W 200 S
    Suite 4003
    Salt Lake City, UT
    Zip: 84101
    Phone: 888.405.2667

    OrderShipment:

    shipmentId: HwmDemo1000


### Activity - 5
Reset local OFBiz database. 
Repeat activity 1 thru 4, use webtools to create data. Observe the created, approved, order with cancelled items, shipment and completed order on OFBiz admin screens.

### Activity - 6
Reset local OFBiz database. 
Repeat activity 1 thru 4, prepare data as xml file and load data using webtools. Observe the created, approved, order with cancelled items, shipment and completed order OFBiz admin screens.
