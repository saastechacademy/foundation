
###  The study of UDM is guided by ideas discussed in the book Data Model Resource Book, by Len Serverston and our experience with it in Apache OFBiz.

https://www.amazon.com/Data-Model-Resource-Book-Vol/dp/0471380237

The first 5 chapters foundational business concepts that we experience when building / implementing business automation solution in any domain including, 

* Chapter 1. Introduction: 
-   **Key takeaways**
  - What Is the Intent of This Book and These Models?
  - Conventions and Standards Used in This Book
  - The naming conventions for an entity
  - Role of Entity with the suffix TYPE is added to their name
  - Subtypes and Supertypes, subtypes represent possible classifications
  - Non-Mutually Exclusive Sets of Subtypes
  - Conventions Used in Attribute Naming
  - Intersection or Association Entities to Handle Many-to-Many Relationships, aka associative entities or cross-reference entities.
  - [Data Model Patterns](https://www.moqui.org/m/docs/framework/Data+and+Resources/Data+Model+Patterns)
  - [General Entity Overview](https://cwiki.apache.org/confluence/display/OFBIZ/General+Entity+Overview)
  - [Design a Taxonomy](https://arpitbhayani.me/blogs/taxonomy-on-sql)

* Chapter 2. People and Organizations
  - **Prerequisite** Prepare dataset based on following prompts. 
    - What are the attributes or characteristics of the people (students and college staff) and organizations (University / Collage, its departments) that are involved in the course of college education? 
    - What relationships exist between various people, between various organizations, and between people and organizations? ••; 
    - What are the addresses, phone numbers, and other contact mechanisms of people and organizations, and how can they be contacted? 
    - What types of communication or contacts have occurred between various parties, and what is necessary to effectively follow up on these communications?
  - [Party](beginner/party.md)
  - 
* Chapter 3. Products 
  - **Prerequisite** Prepare dataset based on following prompts.
    - Visit your online shopping account history.
    - Prepare list of products 
    - Add pricing, category details for each product.
    - Lookup product bundles on Amazon, take a note of Bundle product name and the names of products included in the bundle. 
      - https://www.amazon.in/KODAK-Instant-Camera-Printer-inches/dp/B08HCPRN88/
      - https://www.amazon.in/Remarkable-Starter-Bundle-Original-Built/dp/B08HDL3XJR/
    - [Product](beginner/product.md)
    - [Product Feature](beginner/product-feature.md)
    - [Category](beginner/product-category.md)
    - [Product Associations](beginner/product-assoc.md)
* Chapter 4. Ordering Products

* Chapter 5. Shipments 

### Complete following activities

## UDM Basics
1. https://github.com/saastechacademy/foundation/blob/main/udm/beginner/party.md
2. https://github.com/saastechacademy/foundation/blob/main/udm/beginner/contact-mech.md
3. https://github.com/saastechacademy/foundation/blob/main/udm/beginner/activity.md#party-data-model
4. https://github.com/saastechacademy/foundation/blob/main/udm/beginner/product-assoc.md
5. https://github.com/saastechacademy/foundation/blob/main/udm/beginner/product-types.md
6. https://github.com/saastechacademy/foundation/blob/main/udm/beginner/product-feature.md
7. https://github.com/saastechacademy/foundation/blob/main/udm/beginner/product-category-explained.md
8. https://github.com/saastechacademy/foundation/blob/main/udm/beginner/activity.md#setup-up-company-product-store-and-catalog
9. https://github.com/saastechacademy/foundation/blob/main/udm/beginner/order.md
10. https://github.com/saastechacademy/foundation/blob/main/udm/beginner/activity.md#order
11. https://github.com/saastechacademy/foundation/blob/main/udm/beginner/shipment.md

## UDM Intermediate
1.  [Design CDP](intermediate/data-model-assignment/activity-design-cdp.md)
2.  [Design PIM](intermediate/data-model-assignment/activity-design-pim.md)
3.  [Design OMS](intermediate/data-model-assignment/activity-design-order.md)

## SQL Intermediate
1.  [SQL 1](intermediate/sql-assignment/sql-assignment-1.md)
1.  [SQL 1](intermediate/sql-assignment/sql-assignment-2.md)
1.  [SQL 1](intermediate/sql-assignment/sql-assignment-3.md)

