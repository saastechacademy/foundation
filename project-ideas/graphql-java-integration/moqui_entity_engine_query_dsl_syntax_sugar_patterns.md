## Stay close to GraphQL + graphql-java)

Use graphql-java’s own AST classes (graphql.language.*) as your internal model (Document / OperationDefinition / Field / SelectionSet / Argument / Value).

Add Groovy DSL syntax sugar that only builds those AST nodes (no parallel POJO model).

Render using AstPrinter and validate using ParseAndValidate against a GraphQLSchema built from your local Shopify SDL.



## Moqui Entity Engine – Query DSL Syntax Sugar Patterns

This document summarizes the key **syntax sugar features** of the Moqui Entity Engine Groovy DSL and explains *why they matter*. These patterns serve as a strong reference model for designing other query-building libraries (for example, a GraphQL query builder) that feel natural in the Moqui ecosystem.

---

## 1. `ec.entity.find()` — Structured Entry Point

### Example
```groovy
ec.entity.find("OrderHeader")
```

### What it replaces
Raw SQL statements such as:
```sql
SELECT * FROM ORDER_HEADER
```

### Why this matters
- Query starts from a **schema-defined entity**, not a string
- Forces structured interaction from the first step
- Entity name is validated against the entity model

---

## 2. `.condition()` — Declarative Filtering

### Example
```groovy
ec.entity.find("OrderHeader")
  .condition("statusId", "ORDER_COMPLETED")
```

### What it replaces
SQL `WHERE` clause fragments embedded in strings

### Why this matters
- Conditions are expressed as **data**, not text
- Field names are validated against entity definitions
- Prevents syntax and injection errors

---

## 3. `.conditionDate()` — Domain-Specific Query Sugar

### Example
```groovy
ec.entity.find("ProductPrice")
  .conditionDate("fromDate", "thruDate", ec.user.nowTimestamp)
```

### What it replaces
Manual date-range conditions written repeatedly

### Why this matters
- Encodes a **reusable business pattern**
- Eliminates boilerplate and subtle bugs
- Improves readability and intent

---

## 4. `.selectField()` / `.selectFields()` — Explicit Projection

### Example
```groovy
ec.entity.find("OrderHeader")
  .selectFields("orderId", "statusId", "orderDate")
```

### What it replaces
`SELECT *` or manually written column lists

### Why this matters
- Data shape is explicit
- Improves performance and clarity
- Encourages intentional data access

---

## 5. `.orderBy()` — Declarative Sorting

### Example
```groovy
ec.entity.find("OrderHeader")
  .orderBy("orderDate DESC")
```

### What it replaces
Hard-coded SQL `ORDER BY` clauses

### Why this matters
- Sorting intent is clear
- Keeps SQL syntax out of business logic
- Composes naturally with other query steps

---

## 6. `.one()` / `.list()` — Intent-Revealing Execution

### Examples
```groovy
order = ec.entity.find("OrderHeader")
  .condition("orderId", orderId)
  .one()
```

```groovy
orders = ec.entity.find("OrderHeader")
  .condition("statusId", "ORDER_COMPLETED")
  .list()
```

### Why this matters
- Caller explicitly states expected cardinality
- Reduces ambiguity and runtime errors
- Clean separation between query construction and execution

---

## 7. `.useCache()` — Orthogonal Concerns via Chaining

### Example
```groovy
ec.entity.find("Product")
  .useCache(true)
  .list()
```

### Why this matters
- Cross-cutting concerns don’t pollute query logic
- Keeps API composable and readable
- Allows tuning without restructuring queries

---

## 8. Fluent Chaining — Query as Data, Not Text

### Example
```groovy
ec.entity.find("OrderHeader")
  .condition("statusId", "ORDER_COMPLETED")
  .selectFields("orderId", "orderDate")
  .orderBy("orderDate DESC")
  .list()
```

### Key insight
This is **not SQL** — it is a **query plan expressed as structured data**, which Moqui later renders into SQL.

### Why this matters
- Queries are composable and inspectable
- Rendering happens only at the final step
- Strong separation between *what* is requested and *how* it is executed

---

## Core Design Takeaways

Moqui’s Entity Engine DSL succeeds because:

1. The **schema is authoritative and external** (entity XML)
2. Queries are built as **structured data**
3. Rendering to SQL happens **only at execution time**
4. Common patterns receive **first-class syntax sugar**
5. Java/Groovy collections are preferred over rigid POJOs

These same principles can be applied to other domains (such as GraphQL query construction) while staying consistent with the Moqui philosophy.

