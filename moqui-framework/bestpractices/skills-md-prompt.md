# Prompt to generate SKILLS.md for Moqui Framework

## Purpose
Use this document to generate a high-impact `SKILLS.md` for the Moqui framework. It includes a ready-to-use prompt and the full list of best practices that must appear in the output.

## Prompt (copy/paste)
```
You are an AI coding assistant. Create `moqui-framework/SKILLS.md` with Moqui service best practices and patterns. Use ASCII text. The file must be concise, structured with headings, and focused on day-to-day development choices.

Required inputs and references:
- Service naming best practices: https://github.com/Chinmay2107/foundation-saastechacademy/blob/main/moqui-framework/bestpractices/service-naming.md
- Structured log messages: `runtime/component/poorti/docs/structured-messages.md`
- Component dependencies: each component's `component.xml`
- Scan the OrderRouting component services and other services to infer additional skills and concrete examples.
- Use the XML actions XSD tags list provided below (include it in SKILLS.md).

Mandatory content to include:
1. Allowed vocabulary for service names (verbs and nouns) and service jobs.
2. Debug log instructions (structured log messages rules).
3. Component dependency rules (service calls must align with `component.xml` depends-on).
4. Prefer XML Minilang over Groovy; use XSD tags list; allow `script` only when needed.
5. Run `./gradlew build` after writing/changing a service.
6. Always create seed data with upgrade data in UpcomingRelease.
7. Add upgrade steps wherever upgrade data is added.
8. Add code comments when logic is complex.
9. Entity cache best practices: cached entities should default to `cache="true"` for reads.
10. Use existing view-entities where possible; create new view-entities when needed.
11. Use Jackson mapper for JSON read/write; avoid JsonSlurper.
12. Use `ZonedDateTime` for date/time conversion based on existing services.
13. Prefer Groovy closures over multiple iterates when it improves clarity (filter/search/sort).
14. Always use `date-filter` for entities with `fromDate`/`thruDate`.
15. If Groovy is more efficient, use a `script` tag in the XML service.
16. NetSuite SuiteCloud: validate `deploy.xml` registration for new files.
17. Log statement guidelines (levels, sensitivity, noise).

The output must be a single `SKILLS.md` file with clear sections and bullet lists, covering all items above. Include any additional best practices deduced from OrderRouting and related services (examples: use-iterator for large result sets, service call error handling, transaction timeouts, semaphores, SQL templates with FTL, etc).
```

## Best practices inventory (must appear in SKILLS.md)

### Service naming
- Use existing verbs already in the codebase; do not invent ad-hoc verbs.
- Use domain nouns from entity/model names in PascalCase.
- Service name shape: `verb#Noun` or fully qualified `package.ServiceName.verb#Noun`.
- Service jobs:
  - `ServiceJob.jobName` in UPPER_SNAKE with domain and qualifier.
  - `serviceName` must be fully qualified.
  - Use `ServiceJobParameter` for required inputs.
  - Create Product and ProductCategoryMember data for jobs that must appear in UI.

### Logging (structured messages)
- Format: `[Entity] [Context] - [Action/Outcome/Issue]`.
- Use allowed phrases (not found, missing required <field>, invalid <field>, not allowed, already <state>, not eligible, missing <data>, external call failed, no data, partial result, skipped, operation succeeded).
- Log level conveys severity; do not prefix with [Error].
- Always include primary identifiers and state.
- Log levels: Error (system failure), Warn (business rule failure/expected issue), Info (success path/milestone).
- Avoid logging sensitive data (PII, credentials).
- Ensure error logs provide context (entity ID, action being attempted).

### Component dependencies
- Service calls must only reference components listed in `component.xml` (plus core framework components).
- If a service depends on another component, add `depends-on` first.

### NetSuite SuiteCloud Deployment
- Rule: If a new file is created (Script, XML, etc.), it MUST be registered in `deploy.xml`.
- Rule: If missing in `deploy.xml`, flag as an error.
- Rule: Suggest the required `<path>` entry for `deploy.xml` when missing.

### Service implementation (XML vs Groovy)
- Prefer Minilang/XML actions over Groovy for services.
- Use `<script>` only for complex or performance-critical logic.
- Keep script blocks focused with short explanatory comments.

### XML actions tags (services.xml)
- Root: `<actions>`, `<condition>`
- Call: `<service-call>`, `<script>`
- Environment: `<set>`, `<order-map-list>`, `<filter-map-list>`, `<date-filter>`
- Entity find: `<entity-find-one>`, `<entity-find>`, `<entity-find-count>`, `<entity-find-related-one>`, `<entity-find-related>`, `<search-form-inputs>`, `<econdition>`, `<econditions>`, `<econdition-object>`, `<having-econditions>`, `<select-field>`, `<order-by>`, `<limit-range>`, `<limit-view>`, `<use-iterator>`, `<field-map>`
- Entity value/misc: `<entity-data>`, `<entity-make-value>`, `<entity-create>`, `<entity-update>`, `<entity-delete>`, `<entity-delete-related>`, `<entity-delete-by-condition>`, `<entity-set>`, `<entity-sequenced-id-primary>`, `<entity-sequenced-id-secondary>`
- Control: `<break>`, `<continue>`, `<iterate>`, `<message>`, `<check-errors>`, `<return>`, `<assert>`
- Conditions: `<if>`, `<while>`, `<then>`, `<else-if>`, `<else>`, `<or>`, `<and>`, `<not>`, `<compare>`, `<expression>`
- Other: `<log>`
- Note: XSD allows additional elements via `xs:any`, but prefer explicit tags above.

### Transactions and error handling
- Use `transaction-timeout` for long-running services.
- Use `transaction="force-new"` for per-record work inside large loops.
- If `ignore-error="true"` is used, log errors and clear messages after handling.
- Use semaphores for concurrency-sensitive flows.

### Entity query and cache
- If an entity is cached, default to `cache="true"` for reads.
- Use `entity-find-one` for single rows and `limit="1"` when appropriate.
- Use `use-iterator` for large result sets.
- Always use `<date-filter/>` on entities with `fromDate`/`thruDate`.
- Prefer existing view-entities; create new ones when they simplify joins.

### SQL templates and view-entities
- Put complex SQL in `component://<component>/sql/*.sql.ftl`.
- Use `ec.resourceFacade.template(...)` with `ec.entityFacade.sqlFind(...)` and a mapped entity.
- Avoid logging raw SQL in production.

### JSON handling
- Use Jackson (`ContextJavaUtil.jacksonMapper` or `ObjectMapper`).
- Do not use JsonSlurper for new work.

### Date/time handling
- Use `java.time.ZonedDateTime` for date/time conversion and calculations.

### Groovy collections
- Prefer Groovy closures over multiple iterates when it improves clarity:
  - `.findAll { ... }`, `.find { ... }`, `.collect { ... }`, `.sort { ... }`, `.every { ... }`
- Keep one-liners readable; fall back to `iterate` if complex.

### Seed data and upgrades
- Add seed data and upgrade data together (UpcomingRelease).
- Document upgrade steps in `upgrade/UpcomingRelease/UpgradeSteps.md` and explain what changed.

### Build validation
- After writing or changing a service, run `./gradlew build` and fix failures.
