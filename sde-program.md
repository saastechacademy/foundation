# What?
Learn building business automation software.

Build skills in following categories
*  Software Development
*  System Design
*  Business processes
*  Data Modeling
*  Process engineering

## How?
This training program uses a learn-by-doing approach. You'll gain practical experience by developing a software solution for **[NotNaked](ubpl/NotNaked/Introduction.md)**, a direct-to-consumer fashion brand.

## Prerequisites: Software Development Fundamentals
This training program requires a solid foundation in software development principles. Please review the following refresher resources to ensure you're adequately prepared:

* **[Revision Control (Git)](https://www.scaler.com/topics/git/):**  A working understanding of Git is essential.
* **Databases [SQL](https://www.scaler.com/topics/sql/) and [MySQL](https://www.scaler.com/topics/course/sql-using-mysql-course/):**  Familiarity with SQL and MySQL is crucial.
* **Programming Language [Java](https://www.scaler.com/topics/java/):**  Proficiency in Java is required.
* **Optional but Recommended:** Basic Web Development (HTML, CSS, JavaScript), REST APIs, and the Moqui Framework.

## Training program outline
* You are assigned project to develop software for **[NotNaked](ubpl/NotNaked/Introduction.md)**. NotNaked is a D2C fashion brand.
* During the training program, you will
    * design application data model as per Universal Data Model design principles, deploy it on [MySQL](https://www.mysql.com/).
    * build server side **[Moqui](https://www.moqui.org)** application as per the SOA design principles.
    * publish REST API
    * Integrate with [Shopify](https://shopify.dev/docs/api/) eCommerce store.

### Module 1: Data Modeling basics
*  [What is data modeling?](https://www.ibm.com/topics/data-modeling)
*  Universal Data Model, Read **[First three chapters](udm/readme.md)** of the book: The Data Model Resource Book, Vol. 1

### Module 2: Order and Shipment Data Modeling
* Universal Data Model, Read **[Chapter 4 and Chapter 5](udm/readme.md#chapter-4-ordering-products)** of the book: The Data Model Resource Book, Vol. 1

### Module 3: Developing application with [Apache OFBiz](https://ofbiz.apache.org)
* [Getting Started](https://ofbiz.apache.org/developers.html)
* [Party Activity](udm/beginner/activity.md#party-data-model)
* [Setup Company Product Store and Catalog](udm/beginner/activity.md#setup-up-company-product-store-and-catalog)
* [Order Activity](udm/beginner/activity.md#order)
* [Developing Application](https://cwiki.apache.org/confluence/display/OFBIZ/OFBiz+Tutorial+-+A+Beginners+Development+Guide+for+Release+18.12+and+Release+22.01) with Apache OFBiz 

### Module 4: SQL Assignment
* Get read only access OMS test database.
* [SQL Assignment 1](udm/intermediate/sql-assignment/sql-assignment-1.md)
* [SQL Assignment 2](udm/intermediate/sql-assignment/sql-assignment-2.md)
* [SQL Assignment 3](udm/intermediate/sql-assignment/sql-assignment-3.md)

### Module 5: Detailed Design
1. [Design CDP](udm/beginner/activity-design-cdp.md)
2. [Design PIM](udm/beginner/activity-design-pim.md)
3. [Design OMS](udm/intermediate/data-model-assignment/activity-design-order.md)
4. [Order Fulfillment System](udm/intermediate/data-model-assignment/activity-design-fulfillment.md)


### Module 6: Official Documentation and Application Usage
* https://docs.hotwax.co/documents/v/documents-1
* [Internal Usage Guidelines](https://docs.hotwax.co/everything#shopify)
* [Launchpad](https://launchpad.hotwax.io/home)
* [User Management](https://launchpad.hotwax.io/login?redirectUrl=https://users-dev.hotwax.io/login)
* [Job Manager App (Job Management+Job Workflows)](https://docs.hotwax.co/documents/v/retail-operations/workflow/job-manager)
* [Facility Management](https://facilities.hotwax.io/tabs/find-facilities)
* [ATP](https://launchpad.hotwax.io/login?isLoggedOut=true&redirectUrl=https://atp.hotwax.io/login)
* [Routing](https://launchpad.hotwax.io/login?isLoggedOut=true&redirectUrl=https://order-routing.hotwax.io/login)
* [Fulfillment](https://launchpad.hotwax.io/login?redirectUrl=https://fulfillment-dev.hotwax.io/login)
* [Picking](https://picking-dev.hotwax.io/)
* [BOPIS Fulfillment](https://bopis-dev.hotwax.io/)
* [Receiving](https://launchpad.hotwax.io/login?redirectUrl=https://receiving-dev.hotwax.io/login)
* [Cycle Counting](https://inventorycount-dev.hotwax.io/login)
* [Import](https://import.hotwax.io/purchase-order)
* [Pre-Order Management](https://launchpad.hotwax.io/login?redirectUrl=https://preorder-dev.hotwax.io/login)
* [Apply Safety Stock](https://docs.hotwax.co/documents/v/retail-operations/inventory/safety-stock)
* [Create Draft Orders](https://docs.google.com/document/d/1ucpl4w0bt_EPL8jS1KCENKwS2FuPvMlGbMBrZmCNg40/edit?usp=sharing)
* [Product Store Configurations](https://docs.hotwax.co/documents/v/system-admins/product-store/product-store)
* [Training activity](https://docs.google.com/document/d/1ceDBoj3MeHvJFoCOK3WvZFBxNCc7T_xS1iZaMZxqaF8/edit?tab=t.0#heading=h.y8japeeqpuci)
* [OMS](https://dev-oms.hotwax.io/commerce/control/main)
* [Shopify Backend Login](https://admin.shopify.com/store/hc-sandbox/orders)
* [eCommerce](https://hc-sandbox.myshopify.com/)

## Resources:

1. https://github.com/saastechacademy/foundation/tree/main/moqui-framework/beginner
2. https://cwiki.apache.org/confluence/display/OFBIZ/OFBiz+Tutorial+-+A+Beginners+Development+Guide+for+Release+18.12+and+Release+22.01
3. https://www.moqui.org/m/docs/framework/Framework+Features
4. https://www.moqui.org/m/docs/framework/IDE+Setup/IntelliJ+IDEA+Setup
5. https://www.youtube.com/watch?v=mxToh2rX7NY
6. https://cwiki.apache.org/confluence/display/OFBIZ/Data+Model+Diagrams
7. https://cwiki.apache.org/confluence/download/attachments/13271792/OFBizDatamodelBook_Combined_20171001.pdf
8. https://www.amazon.com/Data-Model-Resource-Book-Vol/dp/0471380237
