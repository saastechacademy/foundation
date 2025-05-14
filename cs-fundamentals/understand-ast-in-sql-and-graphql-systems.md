---

### 📚 **Understand AST in SQL and GraphQL Systems**

---

### 🎯 **Objective**  
Study how **Abstract Syntax Trees (AST)** are used to represent and process queries in **SQL** and **GraphQL** systems. Understand how queries are modeled, analyzed, and transformed into output like SQL strings or API request/responses.

---

### 📌 **Tasks**

1. **Study AST Basics**
   - Read about what an Abstract Syntax Tree is.
   - Compare **Parse Tree vs AST**.
   - Note how AST is used in compilers, SQL engines (like JOOQ, Hibernate), and GraphQL engines.

2. **Draw AST by Hand**
   - For a SQL query:
     ```sql
     SELECT name, email FROM user WHERE id = 1;
     ```
   - For a GraphQL query:
     ```graphql
     {
       user(id: 1) {
         name
         email
       }
     }
     ```
   - Show the tree structure (nodes like `Select`, `Field`, `Condition`, `Entity`).

3. **Model a Simple AST in Code**
   - Define Java (or Python) classes for AST nodes:
     ```java
     class Query { String entity; List<Field> fields; Condition where; }
     class Field { String name; }
     class Condition { String field, operator, value; }
     ```

4. **Walk the AST**
   - Write code that prints or renders SQL from the AST:
     ```sql
     SELECT name, email FROM user WHERE id = 1;
     ```
   - Bonus: simulate JSON output for the GraphQL structure.

---

### 🧠 **Key Concepts to Learn**
- What is AST, and why compilers and query engines use it
- How SQL and GraphQL are both parsed into ASTs
- Why AST makes systems extensible and database-agnostic
- Role of AST in query optimization and code generation

---

### ✅ **Deliverables**
- Diagram of ASTs (hand-drawn or in a tool)
- Code for basic AST model and rendering logic
- A short write-up (half page) on:
  - What you learned about AST
  - How it’s different in SQL vs GraphQL

---
