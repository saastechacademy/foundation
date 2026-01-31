# MOQUI SERVICE DEVELOPMENT SKILLS

## SERVICE NAMING

### Allowed Verbs
Use existing verbs from the codebase; do not invent new ones.

- **consume**: Process incoming messages/data from external sources or triggers (webhooks, feeds)
  - Extract, validate, transform data; trigger next workflow step
  - Example: consume#FulfillmentFeed, consume#BulkOperationsFinishWebhookPayload

- **send**: Transmit data/requests to external systems or queues
  - Prepare payload, handle auth/communication, update message status
  - Example: send#ShopifyFulfillmentSystemMessage, send#OrderUpdatedAtToQueue

- **process**: Perform intermediate processing or decision-making
  - Analyze/transform data, make workflow decisions
  - Example: process#BulkOperationResult

- **poll**: Periodically check external systems or queues for new data/events
  - Initiate requests, trigger processing based on received data
  - Example: poll#BulkOperationResult, poll_SystemMessageSftp_OMSFulfillmentFeed

- **queue**: Place messages into a queue for later processing
  - Create SystemMessage records with status SmsgProduced
  - Example: queue#SystemMessage, queue#BulkQuerySystemMessage

- **generate**: Create data files or reports based on existing data
  - Retrieve data, format into specific file format, store or send
  - Example: generate#OrderMetafieldsFeed, generate#ShopifyFulfillmentAckFeed

- **run**: Execute/initiate processing sequences
  - Example: run#OrderRoutingGroup, run#PickProfile

- **create**, **update**, **delete**, **store**: Standard CRUD operations
- **get**, **find**: Retrieve data
- **clean**: Remove old/stale records
- **migrate**: Data migration operations
- **reconcile**: Reconcile data between systems
- **sync**: Synchronize data
- **void**, **retry**: Specific business actions

### Service Name Format
- Pattern: `verb#Noun` or fully qualified `package.ServiceName.verb#Noun`
- Use domain nouns from entity/model names in PascalCase
- Example: `create#OrderItem`, `co.hotwax.order.routing.OrderRoutingServices.run#OrderRoutingGroup`

### Service Jobs
- **jobName**: UPPER_SNAKE_CASE with domain and qualifier
  - Example: ORDER_ROUTING_GROUP, INVENTORY_COUNT_IMPORT
- **serviceName**: Must be fully qualified
  - Example: `co.hotwax.order.routing.OrderRoutingServices.run#OrderRoutingGroup`
- Use ServiceJobParameter for required inputs
  - Example: `<service-call name="create#moqui.service.job.ServiceJobParameter" in-map="[jobName: jobName, parameterName: 'routingGroupId', parameterValue: routingGroupId]"/>`
- Create Product and ProductCategoryMember data for jobs that must appear in UI

---

## STRUCTURED LOG MESSAGES

### Format
`[Entity] [Context] - [Action/Outcome/Issue]`

- **Entity**: Domain object (Order, Shipment, Inventory, Facility, SystemMessage, Session)
- **Context**: Key identifiers/state (orderId, shipmentId, facilityId, status)
- **Action/Outcome/Issue**: Use allowed phrases below; present tense, plain language

### Allowed Phrases
- `not found` - Missing entity/key
  - Example: `Shipment [${shipmentId}] not found; cannot continue.`
- `missing required <field>` - Input absent
  - Example: `Missing required productId for item; cannot add to count.`
- `invalid <field>` - Bad value/format/state
  - Example: `Invalid status ${statusId} for transition.`
- `not allowed` - Blocked by rule
  - Example: `Reassignment from facility ${fromFacilityId} to ${facilityId} not allowed.`
- `already <state>` - Idempotent/duplicate
  - Example: `Shipment [${shipmentId}] already shipped; receive is not allowed.`
- `not eligible` - Fails eligibility
  - Example: `Order [${orderId}] not eligible for brokering.`
- `missing <data>` - Absent upstream data
  - Example: `SystemMessage [${systemMessageId}] missing CSV data; import aborted.`
- `allocation failed` / `reservation failed` - Explicit for fulfillment
  - Example: `Facility allocation failed for Order [${orderId}]; external call failed: ${errorMessage}.`
- `external call failed` - API/integration
  - Example: `Carrier API call failed for Shipment [${shipmentId}]: ${errorMessage}.`
- `no data` / `empty input`
  - Example: `No items provided; itemList is empty.`
- `partial result` / `moved to queue`
  - Example: `Partial allocation; unfillable items moved to Queue [${queueId}].`
- `skipped` - Intentional
  - Example: `Rate shop skipped for ProductStore [${productStoreId}]: no carrier config.`
- `operation succeeded` - Only when needed
  - Example: `Shipment [${shipmentId}] updated successfully.`

### Guidelines
- Include entity + primary keys; expected vs actual state when relevant
- Be concise and specific; use present tense
- Let log level convey severity (info/warn/error); do NOT add [Error] prefixes
- For timing-sensitive flows, include duration if useful: `Process [...] completed in ${elapsedMs} ms.`

---

## COMPONENT DEPENDENCIES

- Service calls must only reference components listed in component.xml depends-on (plus core framework components)
- If a service depends on another component, add depends-on first
- Example:
  ```xml
  <component name="order-routing" version="1.11.3">
      <depends-on name="maarg-util"/>
      <depends-on name="oms" version="v1.1.0"/>
  </component>
  ```

---

## COMPONENT WORKFLOW & DIRECTORY STRUCTURE

### entity/ (Data Model)
- **Read** here to understand the schema
- **Write** new `<entity>` and `<view-entity>` definitions here
- Define schema **first**. Never put entity definitions inside services or screens
- Example structure:
  ```
  entity/
    OrderEntities.xml
    OrderViewEntities.xml
    InventoryEntities.xml
  ```

### service/ (Business Logic & API)
- **Write** Service Definitions (.xml)
- Use inline `<actions>` for standard logic (CRUD, orchestration)
- Follow "Definition First" — define `in-parameters` and `out-parameters` before writing any implementation logic
- Example structure:
  ```
  service/
    co/hotwax/order/
      OrderServices.xml
      OrderRoutingServices.xml
  ```

### screen/ (User Interface)
- **Write** Screen and Form definitions (.xml)
- Keep screens logic-free. Delegate all processing to services immediately
- Example structure:
  ```
  screen/
    Orders/
      OrderList.xml
      OrderDetail.xml
  ```

### src/ (Complex Implementation)
- **Write** compiled Java/Groovy classes here
- Use strictly for:
  - Algorithmic logic
  - Heavy data processing
  - External API integrations that are too complex for XML Actions
- Example structure:
  ```
  src/
    main/groovy/co/hotwax/order/
      OrderProcessor.groovy
    main/java/co/hotwax/integration/
      ExternalApiClient.java
  ```

### data/ (System Data)
- **Write** `Seed` (Types, Enums) and `Demo` data here
- Separate data by type (`TypeData.xml`, `DemoData.xml`) rather than one giant file
- Example structure:
  ```
  data/
    TypeData.xml
    SeedData.xml
    DemoData.xml
    UpcomingRelease/
      SeedData.xml
      UpgradeData.xml
  ```

### component.xml (Dependencies)
- **Write** new `<depends-on>` entries here if you use resources from another component
- Example:
  ```xml
  <component name="order-routing" version="1.11.3">
      <depends-on name="maarg-util"/>
      <depends-on name="oms" version="v1.1.0"/>
  </component>
  ```

---

## SERVICE IMPLEMENTATION: XML vs GROOVY

### Prefer XML Minilang
- Use XML actions (Minilang) over Groovy for services
- XML is declarative, easier to maintain, and framework-optimized

### Use Groovy `<script>` Only When Needed
- Complex logic that is cumbersome in XML
- Performance-critical operations
- Advanced collection manipulation
- Keep script blocks focused with short explanatory comments

### Example: XML First
```xml
<entity-find-one entity-name="OrderItem" value-field="orderItem"/>
<if condition="!orderItem">
    <return error="true" message="Order item not found for ${orderItemSeqId}"/>
</if>
<set field="totalAmount" from="orderItem.quantity * orderItem.unitPrice"/>
```

### Example: Groovy When Appropriate
```xml
<script><![CDATA[
    // Calculate complex allocation based on multiple factors
    def facilityAllocation = suggestedFulfillmentLocations.groupBy { it.facilityId }
        .collectEntries { facilityId, items ->
            def totalQty = items.sum { it.itemQty }
            [facilityId, [items: items, totalQty: totalQty]]
        }
]]></script>
```

---

## XML ACTIONS TAGS (services.xml)

### Root
- `<actions>`, `<condition>`

### Call
- `<service-call>`, `<script>`

### Environment
- `<set>`, `<order-map-list>`, `<filter-map-list>`, `<date-filter>`

### Entity Find
- `<entity-find-one>`, `<entity-find>`, `<entity-find-count>`
- `<entity-find-related-one>`, `<entity-find-related>`
- `<search-form-inputs>`, `<econdition>`, `<econditions>`, `<econdition-object>`
- `<having-econditions>`, `<select-field>`, `<order-by>`
- `<limit-range>`, `<limit-view>`, `<use-iterator>`, `<field-map>`

### Entity Value/Misc
- `<entity-data>`, `<entity-make-value>`, `<entity-create>`, `<entity-update>`, `<entity-delete>`
- `<entity-delete-related>`, `<entity-delete-by-condition>`, `<entity-set>`
- `<entity-sequenced-id-primary>`, `<entity-sequenced-id-secondary>`

### Control
- `<break>`, `<continue>`, `<iterate>`, `<message>`, `<check-errors>`, `<return>`, `<assert>`

### Conditions
- `<if>`, `<while>`, `<then>`, `<else-if>`, `<else>`
- `<or>`, `<and>`, `<not>`, `<compare>`, `<expression>`

### Other
- `<log>`

**Note**: XSD allows additional elements via xs:any, but prefer explicit tags above.

---

## TRANSACTIONS AND ERROR HANDLING

### Transaction Timeout
- Use `transaction-timeout` for long-running services (in seconds)
- Example: `<service verb="run" noun="OrderRoutingGroup" transaction-timeout="36000">`
- Common values: 120 (2 min), 600 (10 min), 3600 (1 hr), 7200 (2 hr), 36000 (10 hr)

### Force New Transaction
- Use `transaction="force-new"` for per-record work inside large loops
- Example:
  ```xml
  <iterate list="routingRuns" entry="routingRun">
      <service-call name="delete#co.hotwax.order.routing.OrderRoutingRun" 
                    in-map="[routingRunId:routingRun.routingRunId]" 
                    transaction="force-new" ignore-error="true"/>
  </iterate>
  ```

### Error Handling
- If `ignore-error="true"` is used, log errors and clear messages after handling
- Example:
  ```xml
  <script><![CDATA[
      try {
          def result = ec.service.sync().name("some.service").call()
      } catch (Throwable e) {
          ec.logger.error("Error: ${e.getMessage()}")
      }
      if (ec.message.hasError()) {
          hasError = "Y"
          routingResult = ec.message.getErrorsString()
      }
      ec.message.clearAll()
  ]]></script>
  ```

### Semaphores
- Use semaphores for concurrency-sensitive flows
- Example:
  ```xml
  <service verb="run" noun="OrderRoutingGroup" 
           semaphore="wait" semaphore-parameter="productStoreId" 
           semaphore-timeout="3600" semaphore-sleep="60" 
           semaphore-ignore="7200" semaphore-name="OrderRoutingGroup">
  ```

---

## ENTITY QUERY AND CACHE

### Cached Entities
- If an entity is cached, default to `cache="true"` for reads
- Example: `<entity-find-one entity-name="OrderRoutingRule" value-field="routingRule" cache="true"/>`

### Single Row Queries
- Use `entity-find-one` for single rows
- Use `limit="1"` when appropriate for entity-find

### Large Result Sets
- Use `<use-iterator/>` for large result sets to avoid loading all records into memory
- Example:
  ```xml
  <entity-find entity-name="OrderItem" list="orderItems">
      <use-iterator/>
  </entity-find>
  <iterate list="orderItems" entry="orderItem">
      <!-- Process each item -->
  </iterate>
  ```

### Date Filtering
- Always use `<date-filter/>` on entities with fromDate/thruDate
- Example:
  ```xml
  <entity-find entity-name="ProductStoreFacility" list="facilities">
      <econdition field-name="productStoreId" from="productStoreId"/>
      <date-filter/>
  </entity-find>
  ```

### View Entities
- Prefer existing view-entities over complex joins
- Create new view-entities when they simplify repeated joins
- Example:
  ```xml
  <view-entity entity-name="OrderItemDetail" package="co.hotwax.order">
      <member-entity entity-alias="OI" entity-name="OrderItem"/>
      <member-entity entity-alias="OH" entity-name="OrderHeader" join-from-alias="OI">
          <key-map field-name="orderId"/>
      </member-entity>
      <alias-all entity-alias="OI"/>
      <alias entity-alias="OH" name="orderDate"/>
  </view-entity>
  ```

---

## SQL TEMPLATES AND VIEW-ENTITIES

### Complex SQL
- Put complex SQL in `component://<component>/sql/*.sql.ftl`
- Use `ec.resourceFacade.template(...)` with `ec.entityFacade.sqlFind(...)`
- Map results to an entity for field mapping
- Example:
  ```xml
  <script><![CDATA[
      def templateLoc = "component://order-routing/sql/EligibleOrdersQuery.sql.ftl"
      Writer writer = new StringWriter()
      ec.resourceFacade.template(templateLoc, writer)
      def fieldList = ['orderId', 'shipGroupSeqId']
      try (eli = ec.entityFacade.sqlFind(writer.toString(), null, "co.hotwax.order.OrderItemsQueue", fieldList)) {
          EntityValue nextValue
          while ((nextValue = (EntityValue) eli.next()) != null) {
              // Process result
          }
      }
  ]]></script>
  ```

### Avoid Logging Raw SQL in Production
- Comment out or remove SQL logging statements before production

---

## JSON HANDLING

### Use Jackson
- Use Jackson (ContextJavaUtil.jacksonMapper or ObjectMapper)
- Do NOT use JsonSlurper for new work
- Example:
  ```groovy
  import com.fasterxml.jackson.databind.ObjectMapper
  ObjectMapper mapper = new ObjectMapper()
  def jsonString = mapper.writeValueAsString(dataMap)
  def dataMap = mapper.readValue(jsonString, Map.class)
  ```

---

## DATE/TIME HANDLING

### Use java.time.ZonedDateTime
- Use `java.time.ZonedDateTime` for date/time conversion and calculations
- Example:
  ```groovy
  import java.time.ZonedDateTime
  import java.time.format.DateTimeFormatter
  
  def promisedDatetime = ZonedDateTime.now()
      .plusDays(filterCondition.fieldValue as Long)
      .with(java.time.LocalTime.MAX)
      .format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss.SSS"))
  
  def autoCancelDate = ZonedDateTime.now()
      .plusDays(actionMap.get('ORA_AUTO_CANCEL_DAYS') as Long)
      .format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss.SSS"))
  ```

---

## GROOVY COLLECTIONS

### Prefer Groovy Closures
- Prefer Groovy closures over multiple iterates when it improves clarity
- Use: `.findAll { ... }`, `.find { ... }`, `.collect { ... }`, `.sort { ... }`, `.every { ... }`
- Keep one-liners readable; fall back to iterate if complex
- Example:
  ```groovy
  // Good: Groovy closure
  def unfillableItems = orderItems.findAll { !brokeredItemsSeqIds.contains(it.orderItemSeqId) }
  
  // Good: Groovy closure with transformation
  def facilityIds = suggestedFulfillmentLocations.collect { it.facilityId } as Set
  
  // Fall back to iterate if logic is complex
  <iterate list="orderItems" entry="orderItem">
      <if condition="complexCondition">
          <!-- Complex logic here -->
      </if>
  </iterate>
  ```

---

## SEED DATA AND UPGRADES

### Add Seed Data and Upgrade Data Together
- Always create seed data with upgrade data in UpcomingRelease
- Path: `data/UpcomingRelease/SeedData.xml`, `data/UpcomingRelease/UpgradeData.xml`

### Document Upgrade Steps
- Add upgrade steps in `upgrade/UpcomingRelease/UpgradeSteps.md`
- Explain what changed, why, and any manual steps required
- Example:
  ```markdown
  ## v1.2.0 Upgrade Steps
  
  ### New Service Job for Order Routing
  - Added ORDER_ROUTING_GROUP job to run brokering automatically
  - Configure cron expression in ServiceJob entity
  - Add ServiceJobParameter for routingGroupId and productStoreId
  ```

---

## BUILD VALIDATION

### Run Build After Changes
- After writing or changing a service, run `./gradlew build`
- Fix all build failures before committing
- Example:
  ```bash
  cd /path/to/moqui-framework
  ./gradlew build
  ```

---

## CODE COMMENTS

### Add Comments for Complex Logic
- Add code comments when logic is complex or non-obvious
- Explain WHY, not WHAT
- Example:
  ```xml
  <script><![CDATA[
      // Calling service in script with ignore-error="true" because there is no direct way
      // to identify if the service returned an error at the OrderRoutingRun level
      try {
          def result = ec.service.sync().name("some.service").call()
      } catch (Throwable e) {
          ec.logger.error("Error: ${e.getMessage()}")
      }
  ]]></script>
  ```

---

## ADDITIONAL BEST PRACTICES

### Service Call Patterns
- Use `ec.service.sync().name("...").parameters([...]).call()` for programmatic calls
- Use `requireNewTransaction(true)` when needed
- Use `transactionTimeout(120)` for specific timeout
- Example:
  ```groovy
  def result = ec.service.sync()
      .name("co.hotwax.order.routing.OrderRoutingServices.run#OrderRoutingRule")
      .parameters([routingRuleId: routingRule.routingRuleId, orderId: orderId])
      .requireNewTransaction(true)
      .call()
  ```

### Entity Operations
- Use `entity-find-related-one` for single related entity
- Use `entity-find-related` for multiple related entities
- Use `entity-sequenced-id-primary` or `entity-sequenced-id-secondary` for auto-generated IDs

### Performance
- Use `select-field` to limit fields returned in entity-find
- Use `limit-range` or `limit-view` for pagination
- Use `use-iterator` for large result sets
- Cache frequently accessed entities

### Security
- Use `authenticate="anonymous-all"` only for scheduled jobs or public APIs
- Default is `authenticate="true"` for user authentication
- Use `authorize-skip="true"` cautiously

---

## SUMMARY CHECKLIST

Before committing a service:
- [ ] Service name uses allowed verb and domain noun in PascalCase
- [ ] Log messages follow structured format with allowed phrases
- [ ] Component dependencies are declared in component.xml
- [ ] Prefer XML actions over Groovy; use script only when needed
- [ ] Transaction timeout set for long-running services
- [ ] Use transaction="force-new" for per-record work in loops
- [ ] Error handling with ignore-error logs and clears messages
- [ ] Cached entities use cache="true" for reads
- [ ] date-filter used on entities with fromDate/thruDate
- [ ] use-iterator used for large result sets
- [ ] Prefer existing view-entities; create new ones when needed
- [ ] Use Jackson for JSON; avoid JsonSlurper
- [ ] Use ZonedDateTime for date/time operations
- [ ] Groovy closures used for simple collection operations
- [ ] Seed data and upgrade data added together in UpcomingRelease
- [ ] Upgrade steps documented in UpgradeSteps.md
- [ ] Code comments added for complex logic
- [ ] ./gradlew build runs successfully
