---
name: moqui-service-development
description: Best practices for developing Moqui framework services including naming conventions, structured logging, XML vs Groovy implementation, entity operations, transactions, and component organization. Use when writing or modifying Moqui services, entities, screens, or component structure.
license: Apache-2.0
metadata:
  framework: Moqui
  version: "3.0"
  domain: enterprise-application-development
---

# Moqui Service Development Best Practices

This skill provides comprehensive guidelines for day-to-day Moqui service development, covering naming conventions, logging standards, component structure, and implementation patterns.

## Quick Reference

### Service Naming Pattern
- Use existing verbs: `consume`, `send`, `process`, `poll`, `queue`, `generate`, `run`, `create`, `update`, `delete`, `get`, `find`
- Format: `verb#Noun` (e.g., `create#OrderItem`, `run#OrderRoutingGroup`)
- Service jobs: `UPPER_SNAKE_CASE` with domain (e.g., `ORDER_ROUTING_GROUP`)

### Structured Logging Format
```
[Entity] [Context] - [Action/Outcome/Issue]
```
Example: `Order [${orderId}] not found; cannot continue.`

### Implementation Priority
1. **Prefer XML Minilang** for standard logic (declarative, maintainable)
2. **Use Groovy `<script>`** only for complex logic, performance-critical operations, or advanced collections

### Component Directory Structure
- `entity/` - Define schema first; never in services/screens
- `service/` - Business logic with `<actions>`; define parameters before implementation
- `screen/` - UI definitions; keep logic-free, delegate to services
- `src/` - Compiled Java/Groovy for complex algorithms or external integrations
- `data/` - Seed and demo data; separate by type
- `component.xml` - Declare all dependencies

## Core Principles

### 1. Service Naming

**Allowed Verbs** (use existing, don't invent):
- `consume` - Process incoming messages/webhooks/feeds
- `send` - Transmit to external systems/queues
- `process` - Intermediate processing/decisions
- `poll` - Check external systems periodically
- `queue` - Place messages for later processing
- `generate` - Create files/reports from data
- `run` - Execute processing sequences
- Standard CRUD: `create`, `update`, `delete`, `store`, `get`, `find`
- Domain-specific: `clean`, `migrate`, `reconcile`, `sync`, `void`, `retry`

**Service Jobs**:
- jobName: `UPPER_SNAKE_CASE` (e.g., `INVENTORY_COUNT_IMPORT`)
- serviceName: Fully qualified (e.g., `co.hotwax.order.routing.OrderRoutingServices.run#OrderRoutingGroup`)
- Use `ServiceJobParameter` for required inputs
- Create Product/ProductCategoryMember data for UI visibility

### 2. Structured Logging

**Allowed Phrases**:
- `not found`, `missing required <field>`, `invalid <field>`
- `not allowed`, `already <state>`, `not eligible`
- `missing <data>`, `allocation failed`, `reservation failed`
- `external call failed`, `no data`, `empty input`
- `partial result`, `moved to queue`, `skipped`
- `operation succeeded` (only when needed)

**Guidelines**:
- Include entity + primary keys
- Use present tense; be concise
- Let log level convey severity (no `[Error]` prefixes)
- Add duration for timing-sensitive flows

### 3. XML Actions Tags

**Entity Operations**: `<entity-find-one>`, `<entity-find>`, `<entity-find-count>`, `<entity-find-related-one>`, `<entity-find-related>`, `<entity-create>`, `<entity-update>`, `<entity-delete>`

**Control Flow**: `<if>`, `<else-if>`, `<else>`, `<while>`, `<iterate>`, `<break>`, `<continue>`, `<return>`

**Conditions**: `<econdition>`, `<econditions>`, `<date-filter>`, `<or>`, `<and>`, `<not>`, `<compare>`

**Environment**: `<set>`, `<filter-map-list>`, `<order-map-list>`, `<use-iterator>`

**Other**: `<service-call>`, `<script>`, `<log>`, `<message>`, `<check-errors>`

### 4. Critical Patterns

**Large Result Sets**:
```xml
<entity-find entity-name="OrderItem" list="orderItems">
    <use-iterator/>
</entity-find>
<iterate list="orderItems" entry="orderItem">
    <!-- Process each -->
</iterate>
```

**Date Filtering** (always use with fromDate/thruDate):
```xml
<entity-find entity-name="ProductStoreFacility" list="facilities">
    <econdition field-name="productStoreId" from="productStoreId"/>
    <date-filter/>
</entity-find>
```

**Transaction Timeout**:
```xml
<service verb="run" noun="OrderRoutingGroup" transaction-timeout="36000">
```

**Force New Transaction** (for per-record work in loops):
```xml
<iterate list="items" entry="item">
    <service-call name="process#Item" transaction="force-new" ignore-error="true"/>
</iterate>
```

**Error Handling**:
```groovy
try {
    def result = ec.service.sync().name("some.service").call()
} catch (Throwable e) {
    ec.logger.error("Error: ${e.getMessage()}")
}
if (ec.message.hasError()) {
    ec.message.clearAll()
}
```

### 5. Entity Best Practices

- Cached entities: use `cache="true"` for reads
- Single rows: `<entity-find-one>`
- Large sets: `<use-iterator/>`
- Date ranges: `<date-filter/>`
- Prefer existing view-entities; create new ones for repeated joins
- Use `select-field` to limit returned fields

### 6. Advanced Patterns

**Groovy Collections** (prefer over multiple iterates when clear):
```groovy
def unfillableItems = orderItems.findAll { !brokeredIds.contains(it.orderItemSeqId) }
def facilityIds = locations.collect { it.facilityId } as Set
```

**SQL Templates** (for complex queries):
```groovy
def templateLoc = "component://order-routing/sql/Query.sql.ftl"
Writer writer = new StringWriter()
ec.resourceFacade.template(templateLoc, writer)
try (eli = ec.entityFacade.sqlFind(writer.toString(), null, "EntityName", fieldList)) {
    while ((nextValue = eli.next()) != null) {
        // Process
    }
}
```

**JSON Handling** (use Jackson, not JsonSlurper):
```groovy
import com.fasterxml.jackson.databind.ObjectMapper
ObjectMapper mapper = new ObjectMapper()
def jsonString = mapper.writeValueAsString(dataMap)
```

**Date/Time** (use ZonedDateTime):
```groovy
import java.time.ZonedDateTime
import java.time.format.DateTimeFormatter

def autoCancelDate = ZonedDateTime.now()
    .plusDays(days as Long)
    .format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss.SSS"))
```

## Workflow Checklist

Before committing:
- [ ] Service name uses allowed verb + domain noun (PascalCase)
- [ ] Log messages follow structured format
- [ ] Component dependencies declared in `component.xml`
- [ ] XML actions preferred; Groovy only when needed
- [ ] Transaction timeout set for long-running services
- [ ] `transaction="force-new"` for per-record loops
- [ ] Error handling logs and clears messages
- [ ] Cached entities use `cache="true"`
- [ ] `<date-filter/>` on fromDate/thruDate entities
- [ ] `<use-iterator/>` for large result sets
- [ ] Jackson for JSON (not JsonSlurper)
- [ ] ZonedDateTime for date/time
- [ ] Seed + upgrade data in UpcomingRelease
- [ ] Upgrade steps documented
- [ ] Comments for complex logic
- [ ] `./gradlew build` passes

## Component Structure

```
component-name/
├── entity/              # Schema definitions (define first)
│   ├── Entities.xml
│   └── ViewEntities.xml
├── service/             # Business logic (parameters → implementation)
│   └── co/hotwax/
│       └── Services.xml
├── screen/              # UI (logic-free, delegate to services)
│   └── ScreenName.xml
├── src/                 # Compiled code (complex algorithms only)
│   └── main/groovy/
├── data/                # Seed/demo data (separate by type)
│   ├── TypeData.xml
│   └── UpcomingRelease/
│       ├── SeedData.xml
│       └── UpgradeData.xml
└── component.xml        # Dependencies
```

## Additional Resources

For detailed examples and edge cases, see:
- Service naming verbs: consume, send, process, poll, queue, generate patterns
- Structured message phrases: complete allowed vocabulary
- XML actions reference: full tag list with examples
- Transaction patterns: semaphores, timeouts, error handling
- Entity operations: view-entities, SQL templates, caching strategies

## Build Validation

Always run after changes:
```bash
cd /path/to/moqui-framework
./gradlew build
```

Fix all failures before committing.
