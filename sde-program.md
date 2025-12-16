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

## Training program outline
* During the training program, you will
    * design application data model as per Universal Data Model design principles, deploy it on [MySQL](https://www.mysql.com/).
    * build server side **[Moqui](https://www.moqui.org)** application as per the SOA design principles.
    * publish REST API
    * Integrate with [Shopify](https://shopify.dev/docs/api/) eCommerce store.


### Module 0: Developing application with Moqui
1. [Getting Started](moqui-framework/beginner/getting-started.md)
2. [MySQL Database Setup](moqui-framework/beginner/database-setup.md)
3. [Developing Entities](moqui-framework/beginner/developing-entities.md)
4. [Developing Screens](moqui-framework/beginner/developing-screens.md)
5. [Developing Forms](moqui-framework/beginner/developing-forms.md)
6. [Developing Services](moqui-framework/beginner/developing-services.md)

### Module 1: Software Development Fundamentals
This training program requires a solid foundation in software development principles. Please review the following refresher resources to ensure you're adequately prepared:

* **[Revision Control (Git)](https://www.scaler.com/topics/git/):**  A working understanding of Git is essential.
* **Databases [SQL](https://www.scaler.com/topics/sql/) and [MySQL](https://www.scaler.com/topics/course/sql-using-mysql-course/):**  Familiarity with SQL and MySQL is crucial.
* **Programming Language [Java](https://www.scaler.com/topics/java/):**  Proficiency in [Java](https://docs.oracle.com/javase/tutorial/) is required.
* **Optional but Recommended:** Basic Web Development (HTML, CSS, JavaScript), REST APIs, and the Moqui Framework.

### Module 2: Know your business domain
* [How HotWax's OMS solve bussiness requirments of NotNaked](https://www.hotwax.co/product/omnichannel-order-management-system/)
* [Experience OMS flow](ubpl/NotNaked/ExperienceOmsFlow.md)

### Module 3: Data Modeling basics
* [What is data modeling?](https://www.ibm.com/topics/data-modeling)
* [Key Definitions](udm/beginner/key_definitions.md)
* [Read Chapter 1](udm/beginner/chapter_1.md) of the book: The Data Model Resource Book, Vol. 1
* [Getting Started](https://ofbiz.apache.org/developers.html)

## [Data Model Resource Book](udm/readme.md)
1. https://www.moqui.org/m/docs/framework/Data+and+Resources/Data+Model+Patterns
2. https://cwiki.apache.org/confluence/display/OFBIZ/General+Entity+Overview
3. https://arpitbhayani.me/blogs/taxonomy-on-sql
4. [UDM Analysis and Design](udm/beginner/udm-analysis-and-design.md) 


### Module 4: Modeling People and Organization
* Read [Chapter 2](udm/readme.md#chapter-2-people-and-organizations) of the book: The Data Model Resource Book, Vol. 1
* [Party](udm/beginner/Party/party.md)
* [Contact Mech](udm/beginner/Party/contact-mech.md)
* [Party Activity](udm/beginner/activity.md#party-data-model)

### Module 5: Modeling Products
* Read [Chapter 3](udm/readme.md#chapter-3-products) of the book: The Data Model Resource Book, Vol. 1
* [Product](udm/beginner/Product/product.md)
* [Product Type](udm/beginner/Product/product-types.md)
* [Product Feature](udm/beginner/Product/product-feature.md)
* [Product Category Type](udm/beginner/Product/product-category-type.md)
* [Product Category](udm/beginner/Product/product-category.md)
* [Facility](udm/beginner/Product/facility.md)

* [Setup Company Product Store and Catalog](udm/beginner/activity.md#setup-up-company-product-store-and-catalog)
* [Inventory Item Storage]

### Module 6: Developing application with [Apache OFBiz](https://ofbiz.apache.org)
* [Developing Application](https://cwiki.apache.org/confluence/display/OFBIZ/OFBiz+Tutorial+-+A+Beginners+Development+Guide+for+Release+18.12+and+Release+22.01) with Apache OFBiz
* [Develop Product Management](ofbiz-framework/intermediate/developing_find_product.md) application
* [Develop Customer Management](ofbiz-framework/intermediate/developing_find_customer.md) application

### Module 7: Order and Shipment Data Modeling
* Universal Data Model, Read **[Chapter 4 and Chapter 5](udm/readme.md#chapter-4-ordering-products)** of the book: The Data Model Resource Book, Vol. 1
* [Order](udm/beginner/Order/order.md)
* [Return](udm/beginner/Order/return.md)
* [Shipment](udm/beginner/Order/shipment.md)
* [Order Activity](udm/beginner/activity.md#order)
* [NotNaked Setup](udm/beginner/activity-notnaked.md) 
* [Develop Order Management](ofbiz-framework/intermediate/developing_find_order.md) application
* [GetOrder](ofbiz-framework/intermediate/activity-get-order-json.md) API 

### Module 8: SQL Assignment
* Get read only access OMS test database.
* [SQL Assignment 1](udm/intermediate/sql-assignment/sql-assignment-1.md)
* [SQL Assignment 2](udm/intermediate/sql-assignment/sql-assignment-2.md)
* [SQL Assignment 3](udm/intermediate/sql-assignment/sql-assignment-3.md)

### Module 9: Detailed Design
1. [Design CDP](udm/beginner/activity-design-cdp.md)
2. [Design PIM](udm/beginner/activity-design-pim.md)
3. [Design OMS](udm/intermediate/data-model-assignment/activity-design-order.md)
4. [Order Fulfillment System](udm/intermediate/data-model-assignment/activity-design-fulfillment.md)

### Module 10: Experience Applications 
* [Launchpad](https://launchpad.hotwax.io/home)
* [User Management](https://launchpad.hotwax.io/login?redirectUrl=https://users-dev.hotwax.io/login)
* [ATP](https://launchpad.hotwax.io/login?isLoggedOut=true&redirectUrl=https://atp.hotwax.io/login)
* [Routing](https://launchpad.hotwax.io/login?isLoggedOut=true&redirectUrl=https://order-routing.hotwax.io/login)
* [Fulfillment](https://launchpad.hotwax.io/login?redirectUrl=https://fulfillment-dev.hotwax.io/login)
* [Receiving](https://launchpad.hotwax.io/login?redirectUrl=https://receiving-dev.hotwax.io/login)
* [Cycle Counting](https://inventorycount-dev.hotwax.io/login)
* [Import](https://import.hotwax.io/purchase-order)
* [Pre-Order Management](https://launchpad.hotwax.io/login?redirectUrl=https://preorder-dev.hotwax.io/login)
* [eCommerce](https://hc-sandbox.myshopify.com/)

## [CS fundamentals](cs-fundamentals) for Engineers

## Resources:

1. https://docs.oracle.com/javase/tutorial/
2. https://dev.java/learn/
3. https://www.oracle.com/java/technologies/jee-tutorials.html
6. https://www.moqui.org/m/docs/framework/Framework+Features
7. https://www.moqui.org/m/docs/framework/IDE+Setup/IntelliJ+IDEA+Setup
8. https://www.youtube.com/watch?v=mxToh2rX7NY
9. https://cwiki.apache.org/confluence/display/OFBIZ/Data+Model+Diagrams
10. https://cwiki.apache.org/confluence/download/attachments/13271792/OFBizDatamodelBook_Combined_20171001.pdf
