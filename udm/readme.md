### The study of UDM

The study of UDM is guided by ideas discussed in the book **Data Model Resource Book** by Len Silverston and our experience with it in Apache OFBiz.

[Book Link: Data Model Resource Book, Volume 1](https://www.amazon.com/Data-Model-Resource-Book-Vol/dp/0471380237)

## Required reading: The first five chapters of [Data Model book](https://www.amazon.com/Data-Model-Resource-Book-Vol/dp/0471380237).

#### Chapter 1: Introduction

**Key Takeaways:**

- What Is the Intent of This Book and These Models?
- Conventions and Standards Used in This Book
- Naming Conventions for an Entity
- Role of Entity with the Suffix `TYPE` in their Name
- Subtypes and Supertypes: Subtypes Represent Possible Classifications
- Non-Mutually Exclusive Sets of Subtypes
- Conventions Used in Attribute Naming
- Intersection or Association Entities to Handle Many-to-Many Relationships (also known as associative or cross-reference entities)
- [Data Model Patterns](https://www.moqui.org/m/docs/framework/Data+and+Resources/Data+Model+Patterns)
- [General Entity Overview](https://cwiki.apache.org/confluence/display/OFBIZ/General+Entity+Overview)
- [Design a Taxonomy](https://arpitbhayani.me/blogs/taxonomy-on-sql)

---

#### Chapter 2: People and Organizations

**Prerequisite:** **Prepare a dataset based on the following prompts:**

- What are the attributes or characteristics of the people (students and college staff) and organizations (university/college, its departments) involved in college education?
- What relationships exist between various people, between various organizations, and between people and organizations?
- What are the addresses, phone numbers, and other contact mechanisms of people and organizations, and how can they be contacted?
- What types of communication or contacts have occurred between various parties, and what is necessary to effectively follow up on these communications?

**Activity:**

- [Party](beginner/party.md)

---

#### Chapter 3: Products

**Prerequisite:** **Prepare a dataset based on the following prompts:**

- Visit your online shopping account history.
- Prepare a list of products.
- Add pricing and category details for each product.
- Lookup product bundles on Amazon and take note of the bundle product name and the names of products included in the bundle.
  - Example: [Kodak Instant Camera Bundle](https://www.amazon.in/KODAK-Instant-Camera-Printer-inches/dp/B08HCPRN88/)
  - Example: [Remarkable Starter Bundle](https://www.amazon.in/Remarkable-Starter-Bundle-Original-Built/dp/B08HDL3XJR/)

**Activity:**

- [Product](beginner/product.md)
- [Product Feature](beginner/product-feature.md)
- [Category](beginner/product-category.md)
- [Product Associations](beginner/product-assoc.md)

---

#### Chapter 4: Ordering Products

**Activity:**

- [Order](beginner/order.md)

---

#### Chapter 5: Shipments

**Activity:**

- [Shipment](beginner/shipment.md)

---

### Complete the Following Activities

#### UDM Basics

1. [Party Data Model](https://github.com/saastechacademy/foundation/blob/main/udm/beginner/party.md)
2. [Contact Mechanism](https://github.com/saastechacademy/foundation/blob/main/udm/beginner/contact-mech.md)
3. [Party Activity](https://github.com/saastechacademy/foundation/blob/main/udm/beginner/activity.md#party-data-model)
4. [Product Associations](https://github.com/saastechacademy/foundation/blob/main/udm/beginner/product-assoc.md)
5. [Product Types](https://github.com/saastechacademy/foundation/blob/main/udm/beginner/product-types.md)
6. [Product Feature](https://github.com/saastechacademy/foundation/blob/main/udm/beginner/product-feature.md)
7. [Product Category Explained](https://github.com/saastechacademy/foundation/blob/main/udm/beginner/product-category-explained.md)
8. [Setup Company Product Store and Catalog](https://github.com/saastechacademy/foundation/blob/main/udm/beginner/activity.md#setup-up-company-product-store-and-catalog)
9. [Order](https://github.com/saastechacademy/foundation/blob/main/udm/beginner/order.md)
10. [Order Activity](https://github.com/saastechacademy/foundation/blob/main/udm/beginner/activity.md#order)
11. [Shipment](https://github.com/saastechacademy/foundation/blob/main/udm/beginner/shipment.md)

---

#### UDM Intermediate

1. [Design CDP](intermediate/data-model-assignment/activity-design-cdp.md)
2. [Design PIM](intermediate/data-model-assignment/activity-design-pim.md)
3. [Design OMS](intermediate/data-model-assignment/activity-design-order.md)

---

#### SQL Intermediate

1. [SQL Assignment 1](intermediate/sql-assignment/sql-assignment-1.md)
2. [SQL Assignment 2](intermediate/sql-assignment/sql-assignment-2.md)
3. [SQL Assignment 3](intermediate/sql-assignment/sql-assignment-3.md)

