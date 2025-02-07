# The study of UDM

The study of UDM is guided by ideas discussed in the book **Data Model Resource Book** by Len Silverston and our experience with it in Apache OFBiz.

Required reading: The first five chapters of [Data Model book](https://www.amazon.com/Data-Model-Resource-Book-Vol/dp/0471380237).

## Chapter 1: Introduction

[Chapter 1 Notes](beginner/chapter_1.md)

Chapter 1 lays the groundwork for why universal data models exist and how they can streamline database design. By emphasizing abstraction, standardization, and reusability, Len Silverston introduces a methodology that helps organizations build robust, scalable data architectures. The chapter underscores the importance of tailoring universal models to each organization’s nuanced requirements while still leveraging the time-saving advantages of a pre-built foundation.

### **Questions**

1. **Purpose & Benefits**  
Why are universal data models considered beneficial for organizations, and in what ways do they accelerate database design?

2. **Conceptual vs. Logical vs. Physical**  
What distinguishes the conceptual, logical, and physical levels of data modeling, and why is this distinction important for implementing universal models?

3. **Reusability & Patterns**  
How do recurring entities and patterns (like Party, Location, Product) enable reusability across diverse industries or domains?

4. **Abstraction**  
What is abstraction in the context of universal data models, and how does it help in handling a wide range of business scenarios?

5. **Normalization**  
Why is normalization emphasized in universal data models, and how does it help maintain data integrity in large-scale systems?

6. **Challenges in Adoption**  
What are the primary challenges organizations face when customizing universal data models for their specific requirements?

7. **Core Entities**  
Which core entities does Chapter 1 highlight as central to a universal approach, and how are they commonly extended for different business contexts?

8. **Methodology & Steps**  
What are the key steps in deriving a universal data model, and how do iterative reviews and domain validation fit into the process?

9. **Governance & Documentation**  
Why is strong governance and thorough documentation vital for maintaining and evolving universal data models over time?

10. **Iterative Refinement**  
How does the principle of iterative refinement prevent data model stagnation and ensure the models remain relevant to evolving business needs?

## Chapter 2: People and Organizations

**Prerequisite:** **Prepare a dataset based on the following prompts:**

- What are the attributes or characteristics of the people (students and college staff) and organizations (university/college, its departments) involved in college education?
- What relationships exist between various people, between various organizations, and between people and organizations?
- What are the addresses, phone numbers, and other contact mechanisms of people and organizations, and how can they be contacted?
- What types of communication or contacts have occurred between various parties, and what is necessary to effectively follow up on these communications?

**Activity:**
 
- Read chapter 2 of the Universal Data Model book.
- [Party](beginner/Party/party.md)
- [Contact Mechanism](beginner/Party/contact-mech.md)
- [Customer Management API](/moqui-framework/intermediate/developing-find-customer.md)


---

## Chapter 3: Products

**Prerequisite:** **Prepare a dataset based on the following prompts:**

- Visit your online shopping account history.
- Prepare a list of products.
- Add pricing and category details for each product.
- Lookup product bundles on Amazon and take note of the bundle product name and the names of products included in the bundle.
  - Example: [Kodak Instant Camera Bundle](https://www.amazon.in/KODAK-Instant-Camera-Printer-inches/dp/B08HCPRN88/)
  - Example: [Remarkable Starter Bundle](https://www.amazon.in/Remarkable-Starter-Bundle-Original-Built/dp/B08HDL3XJR/)

**Activity:**

- Read chapter 3 of the Universal Data Model book.
- [Product](beginner/Product/product.md)
- [Product Feature](beginner/Product/product-feature.md)
- [Category](beginner/Product/product-category.md)
- [Product Associations](beginner/Product/product-assoc.md)

---

## Chapter 4: Ordering Products

**Prerequisite:** **Prepare a dataset based on the following prompts:**
- Visit your online shopping account history.
- Prepare a list of your online orders.
- Download your online orders and store them as JSON formatted file. 
  - If JSON download is not available from the online store then manually create JSON file of each online order.

**Activity:**
- Read chapter 4 of the Universal Data Model book.
- [Order](beginner/Order/order.md)

---

## Chapter 5: Shipments

**Prerequisite:** **Prepare a dataset based on the following prompts:**
- Visit your online shopping account history.
- Prepare a list of your online order shipment notifications.
  - You may have emails from the merchant notifing you that your order is shipped.
- Prepare JSON formatted data for each shipment you have received. Make sure you capture the key data points like items shipped in the shipment, tracking number, shipping carrier, shipping date, estimated delivery date, and shipment status

**Activity:**

- Read chapter 5 of the Universal Data Model book.
- [Shipment](beginner/shipment.md)

---

## **Key Definitions**

1. **Entity**  
- A fundamental “thing” or object of interest in a data model (e.g., person, product, location). It can represent a physical object, concept, or event that requires data storage.

2. **Attribute**  
- A characteristic or property of an entity (e.g., name, address, date of birth). Attributes describe each instance of an entity in more detail.

3. **Relationship**  
- A logical connection between entities (e.g., a customer *purchases* a product). It defines how entities interact or are associated, often including cardinalities (one-to-many, many-to-many).

4. **Normalization**  
- A systematic approach to organizing data in a database. It aims to reduce redundancy and improve integrity by splitting large tables into smaller, interrelated tables with clear relationships.

5. **Abstraction**  
- The process of capturing the essential, generalized characteristics of a concept or entity while hiding specific details. In universal data models, it allows for creating generic entities (e.g., *Party*) that can be extended to represent multiple roles (customer, employee, vendor, etc.).

6. **Conceptual vs. Logical vs. Physical Models**  
- **Conceptual**: High-level representation of business concepts and relationships, independent of technology.  
- **Logical**: More detailed structure specifying attributes, entity relationships, and normalization rules, but still technology-agnostic.  
- **Physical**: Implementation-specific design reflecting how data is physically stored, including table schemas, column types, and indexes.

7. **Reusability & Patterns**  
- A design principle encouraging generic, pre-defined structures applicable across multiple projects. Universal data models leverage common entities and relationships to save time and maintain consistency.

8. **Core Entities (e.g., Party, Product, Location)**  
- High-level, frequently used entities that serve as templates in many industries. They can be customized to suit particular operational, regulatory, or organizational needs.

9. **Governance**  
- The process of defining rules, policies, and responsibilities to ensure uniform use, upkeep, and evolution of data models across an organization.

10. **Iterative Refinement**  
- An approach that involves regularly reviewing, testing, and updating a data model as needs change. This ensures models remain relevant and accurate over time.

## Complete the Following Activities

#### UDM Basics

1. [Party Activity](https://github.com/saastechacademy/foundation/blob/main/udm/beginner/activity.md#party-data-model)
2. [Setup Company Product Store and Catalog](https://github.com/saastechacademy/foundation/blob/main/udm/beginner/activity.md#setup-up-company-product-store-and-catalog)
3. [Order Activity](https://github.com/saastechacademy/foundation/blob/main/udm/beginner/activity.md#order)

---

#### UDM Intermediate

1[Design OMS](intermediate/data-model-assignment/activity-design-order.md)

---

#### SQL Intermediate

1. [SQL Assignment 1](intermediate/sql-assignment/sql-assignment-1.md)
2. [SQL Assignment 2](intermediate/sql-assignment/sql-assignment-2.md)
3. [SQL Assignment 3](intermediate/sql-assignment/sql-assignment-3.md)

