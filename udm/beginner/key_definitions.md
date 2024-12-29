# **Key Definitions**

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