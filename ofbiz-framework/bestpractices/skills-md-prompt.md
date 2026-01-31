# SKILLS.md for Apache OFBiz Framework

This document outlines best practices and patterns for developing services in the Apache OFBiz framework. It focuses on day-to-day development choices to ensure maintainable, performant, secure, and consistent code. Practices are derived from official documentation, community resources, and patterns in core components.

## Prompt(copy/paste)
```md
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

## Workflow & Process
- **Definition First Policy**: Always define the service in `servicedef/services.xml` first, specifying inputs/outputs. Seek user/peer approval before implementing in Java/Groovy to align on interfaces.
- **Atomic Change Policy**: For refactors or optimizations, make one logical change at a time. Test and verify each before proceeding to minimize regressions.

## Service Naming Best Practices
- Use consistent verbs from the codebase (e.g., create, update, delete, find, get, calculate, process). Avoid new verbs; reference established ones in `org.apache.ofbiz.service` or components.
- Use domain nouns from entity names in CamelCase (e.g., Party, Order, Product).
- Service name format: `verbEntityName` (e.g., `createParty`) or fully qualified (e.g., `party.createParty`).
- For scheduled services (jobs):
  - Job names in UPPER_SNAKE_CASE with domain and qualifier (e.g., `ORDER_PROCESSING_JOB`).
  - Use fully qualified `serviceName` in definitions.
  - Define required parameters in `servicedef/services.xml`.
  - For UI-visible jobs, seed associated entities like Product or Category.

## Logging (Structured Messages)
- Format: `[Entity] [Context] - [Action/Outcome/Issue]`.
- Allowed phrases: not found, missing required field, invalid field, not allowed, already in state, not eligible, missing data, external call failed, no data, partial result, skipped, operation succeeded.
- Log levels indicate severity (e.g., INFO for success, ERROR for failures); avoid [Error] prefixes.
- Include primary keys, identifiers, and state for traceability.
- Use `Debug.logInfo()` or equivalents from `org.apache.ofbiz.base.util.Debug`.

## Component Dependencies
- Call services/entities only from components in `ofbiz-component.xml` via `<depends-on>`.
- Add dependencies before cross-component calls.
- Core components (e.g., entity, service engines) are implicit.
- Ensure `component-load.xml` orders loading for plugins/custom components.

## Service Implementation (MiniLang/XML vs Java/Groovy)
- Prefer MiniLang/XML for simple services in `servicedef/services.xml` for declarativity.
- Use Java/Groovy only for complex/performance-critical logic (e.g., via `engine="java"` or `engine="groovy"`).
- In XML, use `<script>` for inline Groovy/Java; keep concise with comments.
- Define with `engine="simple"` for MiniLang.

## XML Actions Tags (services.xml - MiniLang)
- Root: `<actions>`, `<condition>`
- Call: `<call-service>`, `<script>`
- Environment: `<set>`, `<map-processor>`, `<field-map>`, `<order-by>`, `<filter-list-by-and>`, `<date-filter>`
- Entity find: `<entity-one>`, `<entity-and>`, `<entity-condition>`, `<entity-condition-list>`, `<find-by-primary-key>`, `<find-by-and>`, `<find-list>`, `<count-by-and>`, `<related-one>`, `<related>`, `<select-fields>`, `<order-by>`, `<limit-range>`, `<use-iterator>`
- Entity value/misc: `<make-value>`, `<create-value>`, `<store-value>`, `<remove-value>`, `<remove-by-and>`, `<sequenced-id-to-env>`, `<clear-cache-line>`
- Control: `<iterate>`, `<if>`, `<else>`, `<while>`, `<break>`, `<continue>`, `<return>`, `<assert>`, `<check-errors>`
- Conditions: `<condition-expr>`, `<condition-list>`, `<and>`, `<or>`, `<not>`, `<compare>`, `<compare-field>`
- Logging/Other: `<log>`, `<fail-message>`, `<set-error-code>`
- Note: Prefer these tags; custom extensions discouraged for standards.

## Transactions and Error Handling
- Set `transaction-timeout` for long operations.
- Use `require-new-transaction="true"` for independent loop transactions.
- Handle errors with `<check-errors>`; if ignoring, log and clear messages.
- Use semaphores/locks (e.g., `EntityLocker`) for concurrency.
- In Java/Groovy, wrap calls in try-catch; return via `ServiceUtil.returnError()`.

## Entity Query and Cache
- For PK lookups, use `.queryOne()` over `.queryFirst()` for safety.
- Use `.cache()` for infrequent changes (e.g., config like `PickProfileCondition`).
- Prepare `List<EntityCondition>` with `UtilMisc.toList(...)`; avoid `new ArrayList<>()`.
- Build queries in single chains: e.g., `EntityQuery.use(delegator).from(...).where(conds).queryList()`; no splitting.
- Note: `.where(List<EntityCondition>)` auto-ANDs conditions.
- For cached entities, default `use-cache="true"` for reads.
- Use `findOne` or `findList` with `limit=1` for singles.
- Enable `use-iterator="true"` for large sets.
- Apply date filters on `fromDate/thruDate` via `<date-filter>` or conditions.
- Reuse view-entities; add fields to views instead of separate queries.
- Clear caches post-update with `<clear-cache-line>` or `delegator.clearCacheLine()`.

## Service Result & Logic Patterns
- For sync calls (`dispatcher.runSync`), check `!ServiceUtil.isSuccess(result)`; log errors and return via `ServiceUtil.returnError()`.
- For boolean statuses: Set flags (e.g., `isSuccess`) to true/false; return `ServiceUtil.returnSuccess("Message")` on non-matches with flag false.

## SQL Templates and View-Entities
- Place complex SQL in `.ftl` under `component/sql/`; render with FreeMarker.
- Use `delegator.findBySql()` or `EntityQuery` for customs; map to entities.
- Use prepared statements; avoid raw SQL embeds.
- Disable/minimize SQL logging in production.

## JSON Handling
- Use Jackson via `UtilObject` for serialize/deserialize.
- Avoid JsonSlurper/JsonBuilder; use `UtilMisc.fromJson/toJson`.

## Date/Time Handling
- Use `Timestamp` for DB; `LocalDateTime`/`ZonedDateTime` for calcs.
- Leverage `UtilDateTime` for zones, formats, comparisons.
- Factor in user time zones from `UserLogin`/context.

## Groovy Collections and Iterations
- Use closures for clarity: e.g., `list.findAll { it.status == 'ACTIVE' }`.
- Chain operations; avoid multiple iterations.
- Fall back to MiniLang `<iterate>` for simple XML loops.

## Optimization & Performance
- Avoid inner loops with queries; pre-process into Maps/Sets for O(1) lookups.
- Define statics as `private static final` (e.g., field lists, date offsets).
- Prefer view-entities for combined fields; avoid multiple fetches.
- Use `Objects.equals()` for simple checks before complex conditions.
- Paginate large sets (e.g., Order services) with `viewIndex/viewSize`.
- Monitor with `Perfmon`; optimize hotspots.

## Seed Data and Upgrades
- Seed in `data/` (e.g., `seed-data.xml`); include upgrade paths.
- Add upgrade data in `demo/`; document in release notes/`UPGRADE.md`.
- Use `ofbizsetup`/Ant for loading; ensure idempotency.
- Test with `ant load-demo`.

## Build Validation and Testing
- Run `ant build` or `gradle build` post-changes; fix XML/compilation errors.
- Test via Service Engine or JUnit in `testdef/`.
- Add Javadocs/comments for complex logic.

## Additional Best Practices from OFBiz Components
- Use `ServiceUtil` for returns (e.g., `returnSuccess()`, `returnError()`).
- Secure with `secas` for authorization.
- Handle i18n with `UtilProperties`/bundles.
- Use `HttpClient`/wrappers for external calls; no direct HTTP.
- Follow data model diagrams (e.g., Party relationships).
- For customs, use plugins to avoid core mods.
