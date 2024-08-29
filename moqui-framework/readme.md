HotWax Certified Moqui App Developer

Why?
In this repo, We want manage all training material and activites to practice the skills.


TODO: Common training element for all roles.
I am sure we have training document on  "Writing commit log". 
We want to make it part of our training.

What is considered as managed skill?
Skill set is a graph. Right? Fundamental skills are at leaf level or closer to leaf level. Then developer builds skills that depend on other skills. 

Something is managed skills if it can be defined as a node on skillset tree.

As we design our training program it's important that we manage the effort. 
To keep the trainee interest, we have to offer something at the end, it also helps/forces to define finish line. 
To define finish line, we have to define domain of the skill.

Our training program should,  Help developer to learn it and we should have Assignment to test the skill. The learning process has two parts,
-- Online tutorial
-- Experience, write real life tasks. 
-- Start with Why

Like Data Document, SystemMessageRemote feature of Moqui (we need to call this by appropriate name) is other skills that might qualify for Independently managed moqui platform skill

The SDE should also, study limited set of relevant Design Patterns.  
Case study
1) Controller servlet
2) Entity Facade 
3) IOC

The SDE should study limited set of JEE 
1) JTA
2) JAAS
3) JMX
4) JPA
5) ..

### Dynamic programming and DSL
### Case study
### Use of Groovy and XML in Moqui.

### Data Document, DataFeedDocument
### SystemMessage
### Security, Authentication and Authorization
### Artifact Aware Authorization
### Multi Instance setup and management
### Two phase Commit, Distributed transactions

### Data Model Patterns

https://www.moqui.org/m/docs/framework/Data+and+Resources/Data+Model+Patterns
Case studies
-- Order data model
-- Inventory data model


### StatusFlow 
Modeling and use scenarios.
* https://www.moqui.org/m/docs/apps/Marble+ERP+User+Guide/Statuses+and+Types
* http://localhost:8080/qapps/tools/Entity/DataEdit/EntityDetail?selectedEntity=moqui.basic.StatusFlow

### Case study
-- Order fulfillment, 
-- Shopify <--> HC <--> WMS

Moqui tasks Interns

Shipping Gateway, A unified API OMS for integration with logistics providers. 
Email Gateway, A Unified API for email
DataDocument to exporting Shipping Method, Payment Method, Customer Classification, SalesChannel, ShopifyShop configuration

InventoryManagement API for Fulfillment application. 
* https://docs.hotwax.co/integration-resources-1/v/hotwax-commerce/apis/inventory
* https://github.com/hotwax/fulfillment

Fulfillment process API to manage execution of Picking, Packing, Shipping the shipment.
* https://docs.hotwax.co/integration-resources-1/v/hotwax-commerce/apis/fulfillment
* https://github.com/hotwax/fulfillment/wiki/Requirements-and-Outline

OrderImport and Query API for Fulfillment application. 
* https://github.com/hotwax/fulfillment/wiki/Importing-Order-Feed


IOC and Moqui Execution Context



Focused study of Database / data persistence layer / entity engine in Moqui. 

Code study, document and present 

That code responsible for initializing database connection with MySQL. 

Initializing embeded database.  

Reading entity model 
Creating or modifying tables in database.

Reading view entity model and initializing the view for query. Keeping track of all views at runtime.

Use of iterator. The moqui code making it available for it. Part of Jdbc driver responsible for this feature. Database cursor.

Basics of transaction management. Interface in moqui , jdbc and MySQL


* https://arpitbhayani.me/blogs/taxonomy-on-sql
* https://www.moqui.org/m/docs/framework/Data+and+Resources/Data+Model+Patterns
* https://arpitbhayani.me/blogs/atomicity


