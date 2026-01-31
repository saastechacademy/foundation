# SKILLS.md for Apache OFBiz Framework

This document outlines best practices and patterns for developing services in the Apache OFBiz framework. It focuses on day-to-day development choices to ensure maintainable, performant, secure, and consistent code. Practices are derived from official documentation, community resources, and patterns in core components.

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
