# Shopify Query Variation Notes

This document explains the **GraphQL concepts** and the **graphql-java AST classes** used to build Shopify queries in this project. 
It is meant as a quick map of what nodes are created when you build a query or mutation.

---

## 1) Core GraphQL concepts

### Operation
- **Query** vs **Mutation**
- Named operations (`query OrdersMinimal`, `mutation OrderUpdateNote`)

### Fields and Selection Sets
- Each field is a node in the AST
- Nested objects and connections are represented as nested selection sets

### Arguments and Variables
- Arguments are values attached to fields (e.g., `orders(first: $first)`)
- Variables are defined at the operation level and referenced by name

### Connections (Pagination)
- Shopify uses `edges { node { ... } }` + `pageInfo`
- Pagination arguments (`first`, `after`, `last`, `before`) appear as field arguments

### Polymorphism
- Interfaces and unions require **inline fragments**
- `__typename` is commonly selected alongside fragments

### Fragments
- **Fragment definitions** (`fragment Money on MoneyV2`) define reusable selections
- **Fragment spreads** (`...Money`) reuse those definitions

### Input Objects
- Mutations often accept input objects (`input: $input`)
- Inline input objects are represented in the AST as object values

### Aliases
- Field aliasing allows multiple similar selections in one request
- Example: `mf1: metafields(...)`, `mf2: metafields(...)`

### Bulk Operations
- `bulkOperationRunQuery` / `bulkOperationRunMutation` take a **string** containing a full GraphQL document
- This string is a literal value in the outer mutation

---

## 2) graphql-java AST classes used

### Document and Operation
- `Document` — top-level container for operations and fragments
- `OperationDefinition` — query or mutation, with name and variable definitions

### Selections
- `Field` — a field selection
- `SelectionSet` — list of selections under a field or fragment

### Arguments and Values
- `Argument` — field argument name + value
- `VariableReference` — `$var` usage in arguments
- `VariableDefinition` — variable declaration (`$first: Int!`)
- `TypeName` — type names used in variables or fragments
- `NonNullType` — wraps a type to mark it non-null (`Int!`)
- `ListType` — wraps a type for lists (`[String!]!`)

### Value nodes (literals)
- `StringValue` — string literal
- `IntValue` — integer literal (BigInteger)
- `BooleanValue` — boolean literal
- `EnumValue` — enum literal (e.g., `CREATED_AT`, `JSON`)
- `ObjectValue` — inline input object literal
- `ObjectField` — field inside an inline object literal

### Polymorphism and fragments
- `InlineFragment` — `... on Type { ... }`
- `FragmentDefinition` — named fragment definition
- `FragmentSpread` — `...FragmentName`

---

## 3) Common AST patterns in this project

### Minimal query (Orders)
- `OperationDefinition` (QUERY)
- `VariableDefinition` for `first`, `after`
- `Field` `orders` with arguments
- `SelectionSet` with `edges/node` and `pageInfo`

### Nested connection (lineItems/refunds)
- `Field` inside `node` with its own `SelectionSet`
- Additional `VariableDefinition` for nested `first`

### Inline fragment (discountApplication)
- `InlineFragment` on `DiscountCodeApplication`
- `__typename` field alongside fragment

### Fragment-based reuse
- `FragmentDefinition` for Money/OrderCore
- `FragmentSpread` inside `node` selections

### Bulk operation
- `bulkOperationRunQuery` / `bulkOperationRunMutation` field
- Argument value uses `StringValue` containing the full query/mutation text

### Webhook mutation with inline input object
- `ObjectValue` representing `webhookSubscription: { ... }`
- `EnumValue` for `format: JSON`

---

## 4) Practical mapping (concept → class)

- Field selection → `Field`
- Nested selections → `SelectionSet`
- Field arguments → `Argument`
- `$var` usage → `VariableReference`
- `$var: Type` → `VariableDefinition` + `TypeName` + `NonNullType`/`ListType`
- Inline fragment → `InlineFragment` + `TypeName`
- Named fragment → `FragmentDefinition` + `FragmentSpread`
- Inline input object → `ObjectValue` + `ObjectField`
- Enum literal → `EnumValue`
- Mutation vs query → `OperationDefinition.Operation.MUTATION` or `.QUERY`

---

This file is intended as a quick reference while writing new query builders. 

---

## 5) Scenario-by-scenario notes (1–18) 

This contains a summary of the AST nodes created for each scenario listed in `SHOPIFY_QUERY_VARIATIONS.md`. 
It is meant as a quick reference while writing new query builders. 
Each entry below summarizes what the builder creates and which AST nodes matter most.

### 1) Orders minimal fields with pagination
- Variables: `$first: Int!`, `$after: String`
- Core nodes: `OperationDefinition` (QUERY), `Field` orders, `SelectionSet` edges/node/pageInfo

### 2) Orders wide fields via schema expansion
- Variables: `$first`, `$after`, `$query`, nested connection `*First` vars
- Core nodes: `SelectionSet` built programmatically from schema; connection sub-selections

### 3) Orders with lineItems nested pagination
- Variables: `$first`, `$after`, `$lineItemsFirst`
- Core nodes: nested `Field` lineItems with its own `SelectionSet` and `pageInfo`

### 4) Orders with inline fragment in shippingLines
- Variables: `$first`, `$after`
- Core nodes: `InlineFragment` on `DiscountCodeApplication`, `__typename` field

### 5) Orders with filter query argument
- Variables: `$first`, `$after`, `$query`
- Core nodes: `Argument` with `VariableReference` for `query`; `EnumValue` for `sortKey`

### 6) Orders sorted with enums and reverse
- Variables: `$first`, `$sortKey: OrderSortKeys!`, `$reverse: Boolean`
- Core nodes: `EnumValue` or variable for `sortKey`, boolean variable for `reverse`

### 7) Orders with multiple nested connections
- Variables: `$first`, `$after`, `$liFirst`, `$refundFirst`
- Core nodes: multiple sibling nested `Field` selections under the same `node`

### 8) Fragment-based reuse
- Variables: `$first`, `$after`
- Core nodes: `FragmentDefinition` + `FragmentSpread` for `Money` and `OrderCore`

### 9) Orders with multiple inline fragments on discountApplications
- Variables: `$first`, `$after`
- Core nodes: multiple `InlineFragment` nodes under `discountApplication`

### 10) Update order note (Mutation)
- Variables: `$input: OrderInput!`
- Core nodes: `OperationDefinition` (MUTATION), input `VariableDefinition`

### 11) Add tags to an order (Mutation)
- Variables: `$id: ID!`, `$tags: [String!]!`
- Core nodes: `InlineFragment` on `Order` under `node`

### 12) Bulk operation run query (Mutation with query string)
- Variables: none in outer mutation
- Core nodes: `StringValue` containing an embedded GraphQL query

### 13) Bulk operation run mutation (Mutation with mutation string)
- Variables: none in outer mutation
- Core nodes: `StringValue` containing an embedded mutation + `stagedUploadPath`

### 14) Staged upload create (List input object mutation)
- Variables: `$input: [StagedUploadInput!]!`
- Core nodes: `ListType` + `NonNullType` in `VariableDefinition`

### 15) Polymorphic node fetch (node(id:))
- Variables: `$id: ID!`
- Core nodes: `InlineFragment` on `BulkOperation`

### 16) Metafields by namespace with aliasing
- Variables: `$id`, `$namespace` (order metafields) and `$query` (variant metafields)
- Core nodes: `Field` alias via `alias(...)` for `mf1`/`mf2`

### 17) Webhook subscription create (variable args)
- Variables: `$topic: WebhookSubscriptionTopic!`, `$callbackUrl: String!`
- Core nodes: `ObjectValue` + `ObjectField` for inline input object, `EnumValue` for `format`

### 18) Webhook subscription query (union endpoint)
- Variables: none
- Core nodes: `InlineFragment` on `WebhookHttpEndpoint`, `__typename` field
