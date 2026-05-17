# Unit Testing External Integrations

When Moqui applications interact with external systems such as Shopify, D365, or NetSuite, testing the integration layer can quickly become challenging.

If unit tests execute real HTTP calls to external systems, the tests tend to become:
* **Slow:** Network latency significantly increases execution time.
* **Fragile:** TTest execution depends on external sandbox availability, network stability, and valid credentials.
* **Stateful:** External test data, authentication tokens, and API-side cleanup must be managed carefully between runs.

To avoid these problems, a common architectural approach is to separate the integration into independently testable layers. This pattern is referred to as **Separate and Validate**.

---

## The "Separate and Validate" Strategy

A common anti-pattern in external integrations is building one large service that:

1. Reads data from the database
2. Applies business logic and transformations
3. Builds the external payload
4. Sends the HTTP request
5. Handles the response

Combining all responsibilities into a single service makes testing difficult and tightly couples business logic with transport logic.

A more maintainable approach is to separate the integration into two distinct layers.

### 1. The "Thinking" Part (The Payload Builder)
The first layer is responsible for:

- Reading and validating data from Moqui entities or services
- Applying business rules and mappings
- Transforming the data into the exact `Map`, `JSON`, or `XML` structure expected by the external system

This layer should stop before making any HTTP call and simply return the generated payload.

* **Testing Approach:**
  This layer is an ideal candidate for a **Service Integration Test**.
  1. Load controlled seed data into the database during `setupSpec()`
  2. Call the Payload Builder service using `ec.service.sync()`.
  3. Assert that the generated payload matches the expected schema and values
  4. In the `cleanup()` block, clean up any records written during execution so the test remains repeatable

  *Benefits:* 
    - Fast execution
    - Deterministic results 
    - No network dependency 
    - CI-friendly test execution 
    - High confidence in transformation and mapping logic

### 2. The "Doing" Part (The HTTP Client)
The second layer is responsible only for transport concerns:

- Sending the HTTP request
- Receiving the external response
- Returning success or failure details

This layer should remain intentionally thin and contain minimal business logic.

* **Testing Approach:**
  - In most cases, this layer is not heavily unit tested with Spock. Since the service primarily acts as a transport wrapper around `ec.resource.restClient()` or similar HTTP utilities, mocking the transport layer provides limited value. 
  - Instead, this layer is usually validated through:
    - Automated integration tests
    - Postman/Newman suites
    - Sandbox environment testing
    - External E2E validation flows
    
  *Benefits:*
    - Keeps Spock tests focused on deterministic business logic
    - Avoids brittle HTTP mocks
    - Reduces dependency on external systems during CI execution
    - Simplifies long-term maintenance of the integration layer

---

## The Testing Pyramid for OMS + External Integrations

The testing pyramid helps clarify where each type of test belongs and how much coverage each layer should provide.

```
           /\
          /  \
         / E2E \             Postman / Newman against live D365, Shopify, etc.
        /  Tests \           Slow, stateful, requires live credentials.
       /----------\          Write few, run on-demand or nightly.
      /            \
     /   Service    \        Spock tests against Moqui with seeded data.
    / Integration    \       Fast, deterministic, runs in CI. ← PRIMARY FOCUS
   /    Tests         \      Primary focus for external integration logic.
  /--------------------\
 /                      \
/      Unit Tests        \   PPure Groovy/Java helper or worker method tests.
/  (Mapping / Utilities)  \  Extremely fast, no DB or external system required.
/--------------------------- \
```

**For the OMS specifically:**
- **Unit tests** are best for pure helper, worker, mapping, calculation, filtering, and formatting methods, such as methods in `D365MappingWorker.groovy`.
- **Service integration tests** are the primary focus for Moqui-based integration logic. These tests use Spock, controlled seed data, the real Moqui framework, and a real database transaction. They are best suited for payload builders, view entities, complex entity queries, and service-level business rules.
- **E2E / external integration tests** validate the complete flow against real external systems such as D365, Shopify, or NetSuite. These tests usually live in the `oms-test` repository and are executed through Postman/Newman or similar automation.

---

## What Is a "Service Integration Test"?

A **Service Integration Test** (also referred to as a Component Test or In-Process Integration Test) verifies that multiple Moqui framework components work together correctly within the same execution flow.

These tests typically exercise combinations of:
- Services 
- Entities 
- View entities 
- Database queries and transactions 
- Framework behavior inside the ExecutionContext

A Service Integration Test runs against a real or embedded database and uses the actual Moqui framework runtime, but stops before making external network calls.

This type of test sits between isolated unit tests and full end-to-end integration tests.


| Test Type                           | Scope                                                  | Uses Real Database? | Makes External Network Calls? |
| :---------------------------------- | :----------------------------------------------------- | :-----------------: | :---------------------------: |
| **Unit Test**                       | Single helper or method in isolation                   |          No         |               No              |
| **Service Integration Test**        | Services, entities, view entities, and DB interactions |         Yes         |               No              |
| **E2E / External Integration Test** | Full application flow including external APIs          |         Yes         |              Yes              |


Moqui is particularly well suited for Service Integration Tests because:

- The ExecutionContext can be started quickly
- Database transactions are easy to manage within tests
- Test data can be inserted directly through the entity facade
- Services and entity operations can be executed in-process without network overhead

As a result, Service Integration Tests provide a strong balance between execution speed, realism, and confidence in the business logic.

---

## Why "Seeded Test Data" Is Not a Weakness

A common concern when writing Service Integration Tests is whether manually seeded test data can make tests unreliable or misleading.

In practice, controlled seeded data is a strength, not a weakness.

1. **Deterministic Execution:** A
   - Tests built on controlled, known data produce the same result across local development environments, CI pipelines, and repeated executions.
   - By contrast, tests that depend on real production-like data are often unpredictable, difficult to reproduce, and sensitive to unrelated system changes.

2. **Living Documentation of Data Requirements:** 
   - The test setup becomes executable documentation of the service’s required data relationships and dependencies.
   - For example, if an `OrderIdentification` record requires a corresponding `Enumeration` record because of a foreign-key constraint, that dependency becomes explicitly encoded in the test fixture. Future developers do not need to rediscover the same requirement through debugging.

3. **Clearer Failure Isolation:** 
   - Controlled test data helps isolate the source of failures more effectively.
     - If the service logic is incorrect, the test exposes a logic issue.
     - If the seeded data is incomplete or invalid, the test exposes a setup or dependency issue.
   - Both outcomes are valuable because they identify different categories of problems.

4. **The Real Risk: Over-Specific Assertions:**
   - The primary risk with seeded test data is usually not the data itself, but overly rigid assertions.
   - Tests should generally validate semantic correctness rather than insignificant formatting details.
   - For example:
     - Prefer assertions such as:
       - `payload.contains("ITEMNUMBER")`
       - `response.orderId == "TEST_ORDER"`
     - Avoid unnecessary assertions tied to:
       - XML attribute ordering
       - Whitespace formatting
       - Quote style differences
       - Non-functional serialization details
   - Unless the exact output format is intentionally part of the contract, tests should focus on business meaning rather than textual representation.

---

## Real-World Example: D365 Sales Order Sync

The `D365OrderServicesTests.groovy` in the `hotwax-d365` component is a canonical example of this pattern in the OMS codebase.

### What it tests
The service `co.hotwax.d365.D365OrderServices.generate#SalesOrdersDataPackagePayload` reads eligible orders from the `D365EligibleSalesOrdersDMF` view entity, transforms them into a D365-compatible XML payload, and returns the result — **without making any HTTP call to D365**.

### Test structure

```groovy
class D365OrderServicesTests extends Specification {

    @Shared ExecutionContext ec

    def setupSpec() {
        ec = Moqui.getExecutionContext()
        ec.artifactExecution.disableAuthz()

        // Load ALL required seed data inline.
        // This block is the living "data contract" for the service.
        ec.entity.makeDataLoader().xmlText("""<?xml version="1.0" encoding="UTF-8"?>
<entity-facade-xml type="seed">
    <!-- Enumeration type required by OrderIdentification FK -->
    <moqui.basic.EnumerationType enumTypeId="ORDER_IDENT" description="Order Identification Type"/>
    <moqui.basic.Enumeration enumId="SHOPIFY_ORD_ID" enumTypeId="ORDER_IDENT" description="Shopify Order ID"/>

    <!-- GoodIdentificationType required by GoodIdentification FK -->
    <org.apache.ofbiz.product.product.GoodIdentificationType goodIdentificationTypeId="SHOPIFY_PROD_ID" description="Shopify Product ID"/>

    <!-- ProductStore must have an externalId — the view entity exposes it as dataAreaId -->
    <org.apache.ofbiz.product.store.ProductStore productStoreId="STORE_1" storeName="Test Store"
        defaultCurrencyUomId="USD" externalId="USMF"/>

    <!-- The order, its identification (Shopify ID), and its items -->
    <org.apache.ofbiz.order.order.OrderHeader orderId="TestOrder1" orderTypeId="SALES_ORDER"
        statusId="ORDER_APPROVED" productStoreId="STORE_1" salesChannelEnumId="WEB_SALES_CHANNEL" currencyUom="USD"/>
    <co.hotwax.order.OrderIdentification orderId="TestOrder1"
        orderIdentificationTypeId="SHOPIFY_ORD_ID" idValue="SHP_12345" fromDate="2023-01-01 00:00:00"/>
    <org.apache.ofbiz.order.order.OrderItem orderId="TestOrder1" orderItemSeqId="00001"
        productId="PROD_1_VAR" quantity="2" unitPrice="15.00" statusId="ITEM_APPROVED"/>
    <!-- ... additional supporting records ... -->
</entity-facade-xml>""").load()
    }

    def setup() {
        ec.artifactExecution.disableAuthz()
        ec.transaction.begin(null)
    }

    def cleanup() {
        // Delete records written by the service under test so the order
        // remains eligible (SOSIH.orderId IS NULL) on every subsequent run.
        ec.entity.find("co.hotwax.d365.order.D365SalesOrderImportHistory")
                .condition("orderId", "TestOrder1").deleteAll()
        ec.artifactExecution.enableAuthz()
        ec.transaction.commit()
    }

    def "test generate SalesOrdersDataPackagePayload"() {
        when:
        def result = ec.service.sync()
            .name("co.hotwax.d365.D365OrderServices.generate#SalesOrdersDataPackagePayload")
            .parameters([systemMessageRemoteId: "SMR_TEST_1", orderId: "TestOrder1",
                         cachedCustomersIn: ["TestCustomer1": "HW-10000"]])
            .call()

        then:
        result.hasOrders == true
        result.dataXmlStr.contains("ITEMNUMBER")
        result.dataXmlStr.contains("SHP_PROD_123")   // Shopify product ID resolved correctly
        result.dataXmlStr.contains("ORDEREDSALESQUANTITY")
        result.zipBytes != null
    }
}
```

### Why This Test Is Effective

| Quality              | Explanation                                                        |
| :------------------- | :----------------------------------------------------------------- |
| **Fast**             | No external HTTP calls are executed                                |
| **Deterministic**    | Seeded data produces repeatable output                             |
| **CI-friendly**      | No external credentials or sandbox dependencies                    |
| **Realistic**        | Exercises real services, entities, view entities, and XML builders |
| **Repeatable**       | Cleanup logic resets order eligibility after execution             |
| **Self-documenting** | Seed data explicitly captures required FK relationships            |


### Important Lessons from Building the Test

The test uncovered several issues that could otherwise appear only during live D365 synchronization.

1. **Missing `Enumeration` records:** `OrderIdentification.orderIdentificationTypeId` is a FK to `moqui.basic.Enumeration`. Without seeding `SHOPIFY_ORD_ID`, the row silently failed to insert, causing the view entity join to return nothing.
2. **Missing `GoodIdentificationType`:** `GoodIdentification` requires a parent type record — the Shopify product ID lookup would have returned null in production if this was absent.
3. **Import history persistence:** The service writes a `D365SalesOrderImportHistory` record on success. Without explicitly deleting it in `cleanup()`, the second test run would find no eligible orders (the view entity filters out orders that already have a history record).
4. **XML quote style:** The Groovy XML builder emits single-quoted attributes (`'value'`). A baseline comparison file must match this exactly, or the comparison will always fail despite correct data.

All of these were caught by the test — not by a real D365 sync run.

* **Key Takeaway**
The most valuable aspect of this test is that it validates the actual business transformation logic while remaining:
- offline 
- deterministic 
- repeatable 
- fast enough for CI execution

The test exercises real framework behavior without depending on live D365 connectivity.

---

## Comparing with the Baseline XML Pattern

For services that produce structured document output (XML, JSON), you can extend the service integration test with a **baseline comparison**:

1. Run the service once and capture the output.
2. Save it as a baseline file in `src/test/resources/`.
3. In the test, generate the output and compare it to the baseline (after normalizing insignificant whitespace).

```groovy
def "test build SalesOrdersCompositeXml with baseline"() {
    given:
    def ordersToPackage = [[ header: [...], lines: [[...]], charges: [[...]] ]]

    when:
    def result = ec.service.sync()
        .name("co.hotwax.d365.D365OrderServices.build#SalesOrdersCompositeXml")
        .parameters([ordersToPackage: ordersToPackage])
        .call()

    then:
    String expectedXml = ec.resource.getLocationText(
        "component://hotwax-d365/src/test/resources/SalesOrdersCompositeV4_Baseline.xml", false)

    // Normalize whitespace between tags only — do not normalize quotes or self-closing spacing,
    // as those reflect the actual output of the XML builder.
    def normalize = { String xml -> xml.replaceAll(/>\s+</, '><').trim() }
    normalize(result.dataXmlStr) == normalize(expectedXml)
}
```

> **Important:** The baseline file must match the *actual* output of the service exactly — including single vs. double quotes and spacing before `/>`. Update the baseline whenever the service's output format intentionally changes.

---

## Summary of Benefits

By separating the payload generation from the HTTP transport and testing the generation layer with seeded data:

1. **High Test Coverage:** You get >90% test coverage on the most difficult and error-prone part of the integration: the business logic and data formatting.
2. **Fast & Reliable:** The Spock tests stay incredibly fast and can run completely offline in CI/CD pipelines.
3. **Living Documentation:** The test's seed data block explicitly documents every entity relationship the service depends on.
4. **Simplicity:** You avoid the headache of trying to mock `ec.resource.restClient()` or introducing heavy third-party mocking libraries into the Moqui test suite.

---

## Scaling to Multiple Order Scenarios

A single test class can cover many distinct business scenarios by following one simple rule:

> **`setupSpec()` owns shared invariant data. Each test method owns only what makes its scenario unique.**

### Structural Pattern

```
setupSpec()
│
├── Load SHARED seed data once:
│   Products, ProductStore, Geo, Enumeration types, Customer,
│   Facility, ShipmentMethodType — everything all scenarios need.
│
├── def "web order without freight charges"()
│   ├── Insert TestOrderNoCharge (no OrderAdjustment)
│   ├── Call service
│   ├── Compare against SalesOrdersCompositeV4_WebNoCharge_Baseline.xml
│   └── cleanup() → delete history record for TestOrderNoCharge
│
├── def "web order with freight charges"()
│   ├── Insert TestOrderWithFreight + OrderAdjustment (SHIPPING_CHARGES)
│   ├── Call service
│   ├── Compare against SalesOrdersCompositeV4_WebWithFreight_Baseline.xml
│   └── cleanup() → delete history + adjustment for TestOrderWithFreight
│
├── def "POS completed order"()
│   ├── Insert TestOrderPOS with salesChannelEnumId="POS_SALES_CHANNEL"
│   ├── Call service
│   ├── Compare against SalesOrdersCompositeV4_POS_Baseline.xml
│   └── cleanup() → delete history for TestOrderPOS
│
└── cleanupSpec() → ec.destroy()
```

### Recommended Test Scenarios for D365 Sales Order Sync

| Scenario | What differs in seed data | Key assertion |
|:---|:---|:---|
| Web order, no freight | No `OrderAdjustment` | `FIXEDCHARGEAMOUNT='0'` in charge node |
| Web order with freight | `OrderAdjustment` with `orderAdjustmentTypeId="SHIPPING_CHARGES"` | `FIXEDCHARGEAMOUNT='10.0'` |
| POS order | `salesChannelEnumId="POS_SALES_CHANNEL"` + `IntegrationTypeMapping` for `D365_SALES_CHNL` | `SALESORDERORIGINCODE='POS'` |
| Mix-cart order | Two `OrderItemShipGroup` with different `shipmentMethodTypeId` | Correct `DELIVERYMODECODE` for mixed methods |
| Order with size & color | `ProductFeature` records of type `SIZE` and `COLOR` on the variant | `PRODUCTSIZEID` and `PRODUCTCOLORID` present in line |
| Order missing Shopify product ID | No `GoodIdentification` for parent product | `ITEMNUMBER=''` — service warns but does not fail |
| Multi-line order | Multiple `OrderItem` records on the same order | All lines present in output XML |
| Order with line discount | `OrderItemAdjustment` records on line items | `LINEDISCOUNTAMOUNT` reflects discount correctly |

### Corresponding Baseline File Layout

```
src/test/
├── groovy/co/hotwax/d365/
│   └── D365OrderServicesTests.groovy
└── resources/
    ├── SalesOrdersCompositeV4_WebNoCharge_Baseline.xml
    ├── SalesOrdersCompositeV4_WebWithFreight_Baseline.xml
    ├── SalesOrdersCompositeV4_POS_Baseline.xml
    ├── SalesOrdersCompositeV4_MixCart_Baseline.xml
    ├── SalesOrdersCompositeV4_WithSizeColor_Baseline.xml
    └── SalesOrdersCompositeV4_MultiLine_Baseline.xml
```

### How to Generate a Baseline File

Never hand-write a baseline file — always derive it from the real service output:

1. Write the test with its scenario-specific seed data.
2. Add a temporary `println result.dataXmlStr` in the `then:` block.
3. Run the test once and capture the printed output.
4. Visually verify the XML looks correct for that scenario.
5. Save it verbatim as the baseline file in `src/test/resources/`.
6. Replace `println` with the baseline comparison assertion:

```groovy
String expectedXml = ec.resource.getLocationText(
    "component://hotwax-d365/src/test/resources/SalesOrdersCompositeV4_<Scenario>_Baseline.xml", false)
def normalize = { String xml -> xml.replaceAll(/>\s+</, '><').trim() }
normalize(result.dataXmlStr) == normalize(expectedXml)
```

> **When to update a baseline:** Only when the service's output format *intentionally* changes (e.g., a new field is added to the D365 schema). An unexpected baseline mismatch is a signal that the service logic changed unintentionally — treat it as a bug, not a test to fix.

---

## Evolved SOP: Base Class + Shared Fixtures

The first working test (`D365OrderServicesTests`) embeds all seed data inline in `setupSpec()`. This is valid and was the right approach to get the first test working. However, as the number of scenarios grows, this pattern leads to:

- Every new test class copy-pasting the same FK chain from scratch
- Developers spending hours rediscovering the same FK dependencies
- Large, hard-to-read `setupSpec()` blocks that mix infrastructure with scenario data

The **evolved pattern** introduces three layers of separation:

```
src/test/
├── resources/
│   └── fixtures/
│       ├── CommonEntities_Fixture.xml      ← Geo, UOM, Status, RoleType, Enumeration types
│       ├── D365TestConfig_Fixture.xml      ← SystemMessageType, Facility, ProductStore, ShipmentMethod
│       └── OrderTestCatalog_Fixture.xml    ← Party, Products, ContactMech
└── groovy/co/hotwax/d365/
    ├── D365BaseIntegrationTest.groovy      ← Abstract base: loads fixtures, manages transactions
    ├── D365OrderServicesTests.groovy       ← Original first test — kept as-is for reference
    └── D365OrderScenariosTests.groovy      ← New scenario tests extending the base class
```

### The Three Fixture Files

| File | Contains | Why separate? |
|:---|:---|:---|
| `CommonEntities_Fixture.xml` | Type data: Geo, UOM, Status, RoleType, EnumerationTypes, GoodIdentificationType, OrderAdjustmentType | Truly invariant — never changes between scenarios. FK parents for everything. |
| `D365TestConfig_Fixture.xml` | D365 SystemMessage config, Facility, FacilityGroup, ShipmentMethodType, ProductStore | D365-specific infrastructure. Reusable across all D365 test classes. |
| `OrderTestCatalog_Fixture.xml` | Party, Products (parent+variant+Shopify ID), ContactMech/PostalAddress | The "test catalog" — shared reusable entities that scenarios reference by ID. |

### The Base Class (`D365BaseIntegrationTest`)

```groovy
abstract class D365BaseIntegrationTest extends Specification {

    @Shared ExecutionContext ec

    def setupSpec() {
        ec = Moqui.getExecutionContext()
        ec.artifactExecution.disableAuthz()
        loadSharedFixtures()           // ← loads all three fixture files
    }

    def cleanupSpec() { ec.destroy() }

    def setup()   { ec.artifactExecution.disableAuthz(); ec.transaction.begin(null) }
    def cleanup() { ec.artifactExecution.enableAuthz();  ec.transaction.commit()    }

    protected void loadSharedFixtures() { /* loads 3 fixture XMLs */ }

    // Shared helpers available to all subclasses:
    protected void createBaseOrder(String orderId, String salesChannelEnumId, String shopifyOrderId) { ... }
    protected void deleteOrderData(String orderId) { ... }  // deletes in correct reverse-FK order
}
```

### The Scenario Test Class (`D365OrderScenariosTests`)

Each test method follows this exact pattern:

```groovy
class D365OrderScenariosTests extends D365BaseIntegrationTest {

    def "scenario name describes the business case"() {
        given: "Scenario-specific records only — shared data already in fixtures"
        createBaseOrder("TEST_SCENARIO_1", "WEB_SALES_CHANNEL", "SHP_WEB_001")
        ec.entity.makeValue("org.apache.ofbiz.order.order.OrderItem")
            .setAll([orderId: "TEST_SCENARIO_1", orderItemSeqId: "00001", ...])
            .createOrUpdate()
        // Add only what makes THIS scenario unique (e.g., OrderAdjustment for freight)

        when:
        def result = ec.service.sync()
            .name("co.hotwax.d365.D365OrderServices.generate#SalesOrdersDataPackagePayload")
            .parameters([systemMessageRemoteId: "SMR_TEST_1", orderId: "TEST_SCENARIO_1",
                         cachedCustomersIn: ["TestCustomer1": "HW-10000"]])
            .call()

        then: "Assert ONLY the behavior specific to this scenario"
        result.hasOrders == true
        result.dataXmlStr.contains("FIXEDCHARGEAMOUNT")  // scenario-specific assertion

        cleanup: "Delete all records created by this test in reverse-FK order"
        deleteOrderData("TEST_SCENARIO_1")
    }
}
```

### Implemented Scenarios in `D365OrderScenariosTests`

| Test method | What it validates |
|:---|:---|
| `web order with no freight charges has zero FIXEDCHARGEAMOUNT` | Charge node always present; amount is 0 when no adjustment exists |
| `web order with freight charges has non-zero FIXEDCHARGEAMOUNT` | SHIPPING_CHARGES adjustment drives the charge amount correctly |
| `multi-line order produces one SALESORDERLINEV2ENTITY per item` | All lines appear in XML, not just the first |
| `order with missing Shopify product ID produces empty ITEMNUMBER without failing` | Graceful degradation — warn but don't crash |

### Key Design Decisions

**Why keep `D365OrderServicesTests` unchanged?**
It documents the journey — the first working test, the FK pitfalls discovered, and the inline approach. It serves as a reference and contrasts clearly with the evolved pattern.

**Why `cleanup:` blocks instead of global `cleanup()`?**
The Spock `cleanup:` block within a test method runs before the global `cleanup()`. This allows each test to delete its own scenario-specific records, while the global `cleanup()` handles only the transaction commit. This is cleaner than a global cleanup that must know about every scenario's data.

**Why `cachedCustomersIn` in tests?**
The service calls `D365CustomerServices.sync#Customer` via live OData if a customer isn't cached. Passing `cachedCustomersIn` short-circuits this HTTP call, keeping tests fast and offline. This is an intentional design hook in the service for testability.

**Why `createOrUpdate` instead of `create`?**
Fixtures use `type="seed"` semantics — `createOrUpdate` is idempotent. If the same test runs twice without a clean database reset, the fixture data simply updates in place rather than failing with a duplicate key error.

---

## REST API Contract Testing with `ec.screen.makeTest()`

### What Is It and Why Does It Exist?

The `ec.service.sync()` approach tests the **service layer** — it calls business logic directly, bypassing the HTTP framework entirely. This is sufficient for testing most business rules, but it misses an entire class of bugs.

`ec.screen.makeTest()` simulates a **real HTTP request** through Moqui's screen and REST framework entirely in-process (no server port, no network). It exercises:

```
URL Path → Route Matching → Authentication Check → Path Param Binding
        → Service Dispatch → Response Serialization → JSON Output
```

This is the pattern used by `mantle-usl/src/test/groovy/RestApiTests.groovy` — the canonical reference implementation in the Moqui ecosystem.

### The Two Approaches Side by Side

| Capability                                     | `ec.service.sync()` | `ec.screen.makeTest()` |
| :--------------------------------------------- | :-----------------: | :--------------------: |
| Service business logic validation              |          ✅          |     ✅ (indirectly)     |
| REST route definition validation (`.rest.xml`) |          ❌          |            ✅           |
| URL path parameter binding (`{orderId}`)       |          ❌          |            ✅           |
| JSON response serialization and field names    |          ❌          |            ✅           |
| Authentication and authorization enforcement   |          ❌          |            ✅           |
| HTTP-level error propagation                   |          ❌          |            ✅           |
| Execution speed                                |      Very fast      |    Fast (in-process)   |
| Test setup complexity                          |         Low         |       Low–Medium       |


> **Rule of thumb:** Use `ec.service.sync()` to prove the *business logic* is correct. Use `ec.screen.makeTest()` to prove the *HTTP contract* is correct (the route exists, the path param binds, the response shape is what the API consumer expects).

### Screen Path Format (Critical)

From the canonical `RestApiTests.groovy`:

```groovy
// Step 1: Create the ScreenTest with base path "rest" (always just "rest")
screenTest = ec.screen.makeTest().baseScreenPath("rest")

// Step 2: render() uses the format  "s1/<rest-resource-name>/<sub-path>"
// For mantle-usl:  s1/mantle/orders/55800
// For OMS (oms.rest.xml has root name="oms"):  s1/oms/transferOrders/{orderId}

ScreenTestRender str = screenTest.render("s1/oms/transferOrders/${orderId}", null, "get")
```

The `s1` prefix is Moqui's REST API version namespace. The resource name (`oms`) comes directly from the `.rest.xml` root element `name="oms"`.

### Working Example: `GET /oms/transferOrders/{orderId}`

The endpoint at `oms.rest.xml:605–608` is an excellent candidate because:
1. It has a **URL path parameter** (`{orderId}`) that must be correctly bound — only `makeTest()` verifies this
2. It returns a **complex JSON structure** (`order`, `items[]`, `shipGroups[]`) — the shape can drift without being caught by service tests
3. It is actively consumed by Poorti (Fulfillment App) and mobile clients — the contract matters

**Reference implementation:** For a detailed code breakdown of this pattern, see the [REST API Testing with ScreenTest](as-is-analysis.md#3-rest-api-testing-with-screentest) section in the As-Is Analysis documentation.


### Why Seed Data is Different Here vs. D365 Service Tests

In `D365OrderScenariosTests`, the data goes through the full `create#SalesOrder` service chain (FK dependencies, facility, store, etc.). Here we **intentionally bypass** service validation and insert entity records directly via `ec.entity.makeValue()`.

This is the correct approach for REST contract tests because:
- The **route test** is not concerned with whether the order is business-valid
- Minimal records (OrderHeader + OrderItem + OrderItemShipGroup + OrderItemShipGroupAssoc) are sufficient for `get#TransferOrder` to return a valid response
- Simpler setup → test is faster and less brittle to unrelated data changes

### When to Choose Each Approach

| Situation | Use |
|:---|:---|
| Testing business logic, calculations, payload transformations | `ec.service.sync()` |
| Testing a complex service that calls other services | `ec.service.sync()` |
| Testing that the REST route is defined correctly | `ec.screen.makeTest()` |
| Testing that `{orderId}` in the URL binds to the service parameter | `ec.screen.makeTest()` |
| Testing the JSON response shape / field names | `ec.screen.makeTest()` |
| Testing that an unauthenticated request is rejected | `ec.screen.makeTest()` |
| Quick smoke test that an API endpoint "works end to end" | `ec.screen.makeTest()` |
