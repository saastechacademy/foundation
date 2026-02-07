# SKILLS.md for Apache OFBiz Framework

This document outlines best practices and patterns for developing services in the Apache OFBiz framework. It focuses on day-to-day development choices to ensure maintainable, performant, secure, and consistent code. Practices are derived from official documentation, community resources, and patterns in core components.

## Prompt(copy/paste)
```markdown
You are an AI coding assistant. Create `ofbiz/SKILLS.md` with Apache OFBiz service best practices and patterns. Use ASCII text. The file must be concise, structured with headings (#, ##, ###), and focused on day-to-day development choices for maintainable, performant, secure, and consistent code.

Required inputs and references:
- Component dependencies: each component's ofbiz-component.xml
- Scan the Order, Accounting, and Party component services (and related core components) to infer additional skills and concrete examples (e.g., order creation flows, invoice services, party/contact patterns, use of entity-auto, ECAs for status changes, scheduled jobs).

Use the MiniLang XML actions tags list provided below (include a dedicated section in SKILLS.md with grouped categories and common tags).

Mandatory content to include:
1. Allowed vocabulary for service names: Use consistent verbs from codebase (create, update, delete, find, get, calculate, process, approve, cancel, etc.); avoid new verbs. Use domain nouns from entities in CamelCase. Format: verbEntityName (e.g., createOrder, updateInvoice); fully qualified when needed (e.g., order.createOrder). Emphasize unique names to prevent conflicts.
2. Debug log instructions: Use structured formats like [Entity] [Context] - [Action/Outcome/Issue] with allowed phrases (not found, missing required field, invalid field, not allowed, already in state, not eligible, missing data, external call failed, no data, partial result, skipped, operation succeeded). Use Debug.logInfo/Debug.logError from org.apache.ofbiz.base.util.Debug; log levels convey severity; always include primary keys/identifiers and state.
3. Component dependency rules: Service calls must only reference services/entities from components declared in ofbiz-component.xml via <depends-on>; add dependencies explicitly before cross-component calls; core engines are implicit.
4. Prefer MiniLang/XML (engine="simple") over Java/Groovy for simple services; use Java/Groovy (engine="java" or "groovy") only for complex/performance-critical logic; allow <script> for inline code when needed.
5. Run `ant build` or `gradle build` after writing/changing a service to validate XML schemas and compile.
6. Always create seed data with upgrade data in data/ or demo/ directories; ensure scripts are idempotent.
7. Add upgrade steps and document changes in release notes, UPGRADE.md, or similar wherever upgrade data is added.
8. Add code comments or Javadocs when logic is complex.
9. Entity cache best practices: Use use-cache="true" (or .cache() in EntityQuery) by default for reads on configuration/infrequent-change data; clear caches explicitly after updates (delegator.clearCacheLine or <clear-cache-line>).
10. Use existing view-entities where possible; create new view-entities in entitymodel.xml when they simplify joins, grouping, or reporting.
11. Use Jackson (via UtilObject or ObjectMapper) for JSON read/write; avoid JsonSlurper or JsonBuilder in Groovy.
12. Use java.sql.Timestamp for DB interactions; prefer java.time.LocalDateTime or ZonedDateTime with UtilDateTime helpers for calculations, formatting, and time-zone handling.
13. Prefer Groovy closures over multiple iterates when it improves clarity (e.g., .findAll { ... }, .collect { ... }, .find { ... } for filter/search/sort).
14. Always use date filters (e.g., <date-filter> in MiniLang or .filterByDate() in EntityQuery) for entities with fromDate/thruDate.
15. If Java/Groovy is more efficient, use a <script> tag in XML services or full Java/Groovy implementation.
16. Service definitions must include: unique name (required), engine (required), parameters (<attribute> with name/type/mode/optional), location/invoke where applicable, export (for remote access), auth (default true), permissions via <permission-service>, transaction controls (use-transaction, require-new-transaction, transaction-timeout).
17. Use ECAs (Event-Condition-Action via <service-eca>) for cross-cutting concerns like logging, notifications, status transitions, or post-commit actions.
18. Error handling: Use ServiceUtil.returnError("message") or returnSuccess(); check !ServiceUtil.isSuccess(result) on dispatcher.runSync calls; log errors and propagate; handle exceptions in code.
19. Transactions: Explicitly set use-transaction, require-new-transaction="true" for independent work (e.g., loops), and transaction-timeout for long ops; use for data changes.
20. Concurrency: Use semaphore (none/wait/fail) for critical sections; async invocation (call-service-asynch or dispatcher.runAsync) for long-running/background tasks.
21. Optimization: Avoid inner loops/queries on large sets; pre-process into Maps/Sets for O(1) lookups; use view-entities over multiple fetches.
22. Security: Set auth="true" by default; use <permission-service> for sensitive ops; follow base permission naming (e.g., uppercased prefix).
23. Testing: Define unit tests with JUnit; integration tests in testdef/; test services via Service Engine or automated runners.

Include the MiniLang XML tags list in a dedicated section, grouped by category (e.g., Control Flow, Entity Operations, Calls, Conditions, Logging, etc.), using common/recommended tags from the reference.

The output must be a single `SKILLS.md` file with clear sections (e.g., ## Service Naming Best Practices, ## Entity Query and Cache, ## Service Result & Logic Patterns, etc.) and bullet lists. Cover all mandatory items above. Include any additional best practices deduced from Order, Accounting, Party, and related components (examples: use-iterator for large result sets in Order services, service call error handling with ServiceUtil, transaction timeouts, semaphores for concurrency-sensitive flows, SQL templates with FreeMarker in sql/ directories, entity-auto for simple CRUD services, service groups/interfaces for orchestration, ECAs for event-driven logic like status changes/email triggers, job scheduling for background tasks via dispatcher.schedule, pagination with viewIndex/viewSize, internationalization with UtilProperties, etc.).
```

---
name: ofbiz-service-patterns
description: Battle-tested guidelines and patterns for writing clean, performant, maintainable, and secure services in Apache OFBiz. Covers service definition, MiniLang vs Java/Groovy, EntityQuery, transactions, error handling, caching, ECAs, performance, and security.
version: 1.3
framework: Apache OFBiz
scope: 
  - service engine
  - entity engine
  - component development
  - ECA & scheduled jobs
triggers:
  - ofbiz service
  - minilang best practices
  - entityquery pattern
  - serviceutil error handling
  - ofbiz transaction timeout
  - ofbiz eca
  - ofbiz job scheduling
  - ofbiz view-entity
created: 2025-07
updated: 2026-01-31
status: active
dependencies:
  - ofbiz-core (trunk / stable branch)
  - util packages: org.apache.ofbiz.base.util.*, org.apache.ofbiz.service.*
author: G0V1NDK
---

# OFBiz Service Best Practices & Patterns

## When to Use This Skill
Apply this document when you are:
- Defining a new service (always start with services.xml)
- Implementing or refactoring business logic in Order, Accounting, Party, Product, etc.
- Debugging slow services, transaction deadlocks, cache misses, or permission issues
- Writing ECAs, scheduled jobs, or cross-component integrations
- Optimizing batch jobs or high-volume data operations

**Core Principles (memorize these)**
- MiniLang first → Java/Groovy only when necessary
- Service definition before implementation
- Always validate: `gradle build` / `ant build`
- Prefer declarative patterns (entity-auto, view-entities, ECAs)
- Structure = definition → implementation → error handling → test

## 1. Service Definition Rules (services.xml)

- **Naming Convention**
  - Format: `verbEntityName` (examples: `createOrder`, `updateInvoice`, `calculateTaxForOrder`, `processPaymentCapture`)
  - Verbs (stick to existing): create, update, delete, find, get, process, approve, cancel, calculate, post, void, generate, send
  - Nouns: CamelCase entity or domain concept (Order, Invoice, Shipment, Party, Product)
  - Fully qualify when ambiguous: `order.createOrder`, `accounting.postInvoice`

- **Mandatory / Highly Recommended Attributes**
  ```xml
  <service name="createSalesOrder" engine="simple" auth="true">
      <description>Create a new sales order</description>
      <attribute name="partyId" type="String" mode="in" required="true"/>
      <attribute name="productStoreId" type="String" mode="in" required="true"/>
      <attribute name="orderItems" type="List" mode="in" required="true"/>
      <attribute name="orderId" type="String" mode="out"/>
      <permission-service service="genericPermissionCheck"/>
      <transaction use-transaction="true" transaction-timeout="300"/>
  </service>
  ```
  - `name` – unique across the instance
  - `engine` – "simple" (MiniLang) preferred
  - `auth="true"` – default for most services
  - `<attribute>` – define every input/output (name, type, mode, optional/required)
  - `<permission-service>` or security-group for protected actions
  - Transaction settings: `use-transaction`, `require-new-transaction`, `transaction-timeout`

- **Export** — only `export="true"` if needed for SOAP/REST/remote engine access

## 2. Implementation Strategy

- **MiniLang (engine="simple")** — default choice for 70-80% of services
- **Java / Groovy** — use when:
  - Complex date/JSON/string logic
  - Performance-critical loops or calculations
  - Heavy integration (external APIs, file processing)
- **Inline <script>** — short Groovy/Java blocks only; always comment

### MiniLang Common Tags (cheat sheet)

**Control Flow**
- `<if>`, `<else>`, `<while>`, `<iterate>`, `<break>`, `<continue>`, `<return>`

**Entity Operations**
- `<entity-one>`, `<entity-and>`, `<find-by-and>`, `<find-list>`, `<make-value>`, `<create-value>`, `<store-value>`, `<remove-value>`
- `<date-filter field-name="fromDate" />`
- `<use-iterator/>` — large result sets

**Service Calls**
- `<call-service name="..." />`
- `<call-service-async ... />`

**Conditions & Logging**
- `<condition-expr>`, `<and>`, `<or>`, `<compare>`
- `<log level="info" message="..."/>`
- `<check-errors/>`, `<fail-message/>`

## 3. EntityQuery Patterns (Java/Groovy Services)

```java
// Preferred single-chain pattern
List<EntityCondition> conds = UtilMisc.toList(
    EntityCondition.makeCondition("orderId", orderId),
    EntityCondition.makeCondition("statusId", EntityOperator.IN, approvedStatuses)
);
EntityQuery.use(delegator)
    .from("OrderHeader")
    .where(conds)
    .cache()                    // for config / semi-static data
    .orderBy("-entryDate")
    .queryList();

// PK lookup (always prefer queryOne)
GenericValue order = EntityQuery.use(delegator)
    .from("OrderHeader")
    .where("orderId", orderId)
    .cache()
    .queryOne();
```

**Rules**
- `.queryOne()` > `.queryFirst()` for PK lookups
- `.cache()` on configuration, rules, profiles
- Build queries in single chains: e.g., `EntityQuery.use(delegator).from(...).where(conds).queryList()`; no splitting.
- Never split query building across lines unless conditionally building conds list
- Large sets → paginate with `viewIndex`, `viewSize` or use-iterator in MiniLang
- Enable `use-iterator="true"` for large sets.
- Prepare `List<EntityCondition>` with `UtilMisc.toList(...)`; avoid `new ArrayList<>()`.
- Note: `.where(List<EntityCondition>)` auto-ANDs conditions.
- For cached entities, default `use-cache="true"` for reads.
- Use `findOne` or `findList` with `limit=1` for singles.
- Apply date filters on `fromDate/thruDate` via `<date-filter>` or conditions.
- Reuse view-entities; add fields to views instead of separate queries.

## 4. Error & Result Handling (Mandatory Pattern)

```java
Map<String, Object> ctx = UtilMisc.toMap("orderId", orderId, ...);
Map<String, Object> result = dispatcher.runSync("loadOrder", ctx);

if (!ServiceUtil.isSuccess(result)) {
    String errMsg = ServiceUtil.getErrorMessage(result);
    Debug.logError(errMsg, MODULE);
    return ServiceUtil.returnError(errMsg);
}

// Non-error case with info
if (UtilValidate.isEmpty(results)) {
    return ServiceUtil.returnSuccess("No matching record found for " + key);
}
```

## 5. Transactions & Concurrency

- Long-running → `transaction-timeout="600"`
- Loop items independent → `require-new-transaction="true"`
- Critical sections → use `semaphore="wait"` or `EntityLocker`
- Background → `dispatcher.runAsync(...)` or scheduled job

## 6. Performance & Optimization Quick Wins

- No EntityQuery inside loops → preload Maps/Sets
- `private static final` for constants, field lists
- Avoid deep copies unless necessary
- Prefer view-entities for combined fields; avoid multiple fetches.
- Use `Objects.equals()` for simple checks before complex conditions.
- Paginate large sets (e.g., Order services) with `viewIndex/viewSize`.

## 7. Security & ECAs

- `auth="true"` default
- Use `<permission-service>` or OFBiz permission model
- ECAs for: status transitions, post-commit logging, email triggers, audit

## 8. Seed Data, Upgrades & Validation

- Idempotent seed/demo XML
- Document upgrades → UPGRADE.md or release notes
- Always run `ant build` / `gradle build` after service changes
- Seed in `data/` (e.g., `seed-data.xml`); include upgrade paths.
- Add upgrade data in `demo/`; document in release notes/`UPGRADE.md`.

## 9. Testing Expectations

- JUnit for Java/Groovy logic
- Integration tests in `testdef/services.xml`
- Manual validation via Service Engine web interface

## 10. Service Result & Logic Patterns
- For sync calls (`dispatcher.runSync`), check `!ServiceUtil.isSuccess(result)`; log errors and return via `ServiceUtil.returnError()`.
- For boolean statuses: Set flags (e.g., `isSuccess`) to true/false; return `ServiceUtil.returnSuccess("Message")` on non-matches with flag false.

## 11. JSON Handling
- Use Jackson via `UtilObject` for serialize/deserialize.
- Avoid JsonSlurper/JsonBuilder; use `UtilMisc.fromJson/toJson`.

## 12. Date/Time Handling
- Use `Timestamp` for DB; `LocalDateTime`/`ZonedDateTime` for calcs.
- Leverage `UtilDateTime` for zones, formats, comparisons.
- Factor in user time zones from `UserLogin`/context.

## 13. Groovy Collections and Iterations
- Use closures for clarity: e.g., `list.findAll { it.status == 'ACTIVE' }`.
- Chain operations; avoid multiple iterations.
- Fall back to MiniLang `<iterate>` for simple XML loops.

## Real-World Patterns from Core Components

- Order: entity-auto + ECA chain for status flow
- Accounting: transaction-timeout + semaphore on GL posting
- Party: view-entities for contact + address combined fetch
- Jobs: `dispatcher.schedule(...)`, UPPER_SNAKE_CASE names

