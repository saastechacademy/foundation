## Work Plan: graphql-java Evaluation for Shopify Order Queries

### Goals
- Learn and evaluate graphql-java for schema-backed query building (no server execution).
- Deliver a facade class that constructs Shopify GraphQL queries safely.
- Decide if graphql-java is a good fit for our purposes.
- Provide syntax sugar that feels like Moqui Entity Engine DSL, while staying true to graphql-java AST classes and validation flow.
- Favor a David E. Jones–style approach: metadata-driven, schema-first, and pragmatic simplicity.

### Scope and Constraints
- Use the Shopify Admin GraphQL schema subset in `shopify-order-subset.graphqls`.
- Build GraphQL queries programmatically (avoid string concatenation where possible).
- Validate queries against the schema before sending.
- No GraphQL server, data fetchers, or code generation.
- Use Java package name `co.hotwax.graphql`.

### Design Principles
- Stay close to graphql-java: use its AST (`graphql.language.*`) as the internal model, and validate with graphql-java.
- Add Moqui-style syntax sugar for ergonomics, but keep it as a thin layer that only builds AST nodes.
- Keep query construction structured and schema-backed; avoid raw strings except for final serialization.

### Plan (Phased)
1) Setup and Baseline
   - Add a minimal Java project layout (src/main/java, src/test/java).

2) Schema Loading and Introspection
   - Load SDL into a GraphQLSchema.

3) Query Builder Core
   - Define a minimal query builder that builds a query AST.
   - Model a Moqui-inspired API:
     - `Entity`-like entry point: `GraphqlEntity("Order")` or `GraphqlQuery.from("orders")`.
     - `value`-like container for selections (graphql-java AST selection set).
     - `condition`-like filters mapped to Shopify `query` argument (search syntax).
   - Support arguments: `first`, `after`, `sortKey`, `reverse`, `query`.
   - Support selection sets via graphql-java AST (`Field`, `SelectionSet`).
   - Serialize the AST to a GraphQL query string.

4) Facade Class
   - Provide a facade that accepts:
     - order search string
     - page size
     - cursor
     - selection set built from graphql-java AST
   - Output:
     - query string
     - variables map
     - validation errors (if any)
   - Keep the facade ergonomics similar to Moqui query patterns while mapping to GraphQL semantics.

5) Evaluation and Decision
   - Compare ergonomics vs. string-based query building and Moqui-style expectations.
   - Check maintainability with schema changes.
   - Document final recommendation.

6) Tests
   - Valid query build (minimal).
   - Valid query build (OMS subset).
   - Invalid field selection (expect validation error).
   - Invalid argument type (expect validation error).
