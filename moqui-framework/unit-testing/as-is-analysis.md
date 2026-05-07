# Unit Testing in Moqui

Moqui often sits somewhere between traditional unit testing and integration testing. Because most framework operations — such as entity access, service execution, transactions, authentication, and screen rendering — are tightly connected to the `ExecutionContext (EC)`, creating isolated mocks for all of these layers can become complex and difficult to maintain.

Instead of heavily mocking the framework, the common and practical approach in Moqui is to run tests against the real framework in-process. Moqui can boot the ExecutionContext quickly, execute logic inside a temporary database transaction, and cleanly roll back all changes after the test completes. This makes tests both fast and reliable while still exercising the actual services, entities, and framework behavior used in production.

As a result, many Moqui tests are best described as fast in-process integration tests rather than strictly isolated unit tests. The focus is less on mocking infrastructure and more on validating real business logic against controlled, deterministic test data.

> **Simple Analogy:**
> In many frameworks, developers isolate a small piece of code and replace everything around it with mocks or fake objects.
> In Moqui, the framework itself is lightweight enough that it is often easier and more valuable to spin up a real temporary environment, execute the actual logic, verify the result, and then roll everything back so the next test starts clean.

## Test Type Classification
In Moqui, the term unit test is often used broadly. However, not all Moqui tests are pure isolated unit tests. To keep the terminology clear, we can classify tests as follows:

1. Pure unit tests: Tests for helper or worker methods that do not require the ExecutionContext, database access, services, or framework setup.
2. Moqui unit-style tests: Fast Spock tests that use the real `ExecutionContext` and run inside a database transaction, usually rolling back or cleaning up after each test.
3. Service integration tests: Tests that validate services working together with entities, view-entities, and database records. These tests use the real Moqui framework but stop before making any external network call.
4. REST contract tests: Tests that use ec.screen.makeTest() to verify REST routes, path parameters, authentication behavior, status codes, and response shape.
5. E2E / external integration tests: Full-flow tests that interact with external systems such as Shopify, D365, NetSuite, or other third-party services. These are usually handled through Postman/Newman or a separate integration test suite, like `oms-test` repo.

## What Artifacts are Best to Test with Moqui Spock Tests?

If we consider “unit tests” in Moqui to mean **fast, in-process tests executed via Spock**, the best return comes from testing artifacts that are small, deterministic, and easy to set up.

1. **Utility / Worker Methods**
    - Pure Java or Groovy helper methods are the easiest and fastest artifacts to test.
    - Examples include:
      - Mapping methods 
      - Date or amount calculations 
      - Data formatting helpers 
      - Filtering or selection logic 
      - Parser or validator methods
    - **Why:** These methods usually do not require the ExecutionContext, database records, or service calls and can be tested purely in memory (often without even booting the `ExecutionContext`), making them lightning fast. You can pass inputs directly, assert the output, and keep the test very simple.

2. **Custom Services (Business Logic & Calculations)**
   - Custom services are strong candidates when they contain business rules, calculations, validations, or data transformation logic. 
   - **Why:** You can start a database transaction, insert controlled test data, call the service using `ec.service.sync()`, assert the returned output or database state, and then clean up or roll back the transaction.

3. **View Entities & Complex Queries**
   - View entities and complex `entity-find` queries are good candidates when they involve joins, filters, conditions, or derived fields.
   - **Why:** You can create specific edge-case records in the `setup()` method and query them immediately. This ensures your view entities aren't missing relations or causing Cartesian products.

4. **REST Contract Tests with ec.screen.makeTest()**
   - REST endpoints should be tested when the API contract matters, especially for endpoints consumed by external apps or other systems.
   - **Why:** Using `ec.screen.makeTest()` allows you to hit REST endpoints in-memory without the overhead of network calls.
   - **Deep Dive: What `makeTest()` actually does:**
     - **Virtual Request Lifecycle:** It initializes a `ScreenTest` object that simulates a full HTTP request within the JVM. It doesn't open a socket; it calls the `ScreenFacade` directly.
     - **Bypasses Infrastructure:** It skips the Servlet container (Tomcat/Jetty), filters, and the network layer, making it extremely fast.
     - **Context Awareness:** It preserves the `ExecutionContext`. If you `loginUser()` before calling `makeTest()`, the "virtual request" will be authenticated as that user.
     - **Response Object (`ScreenTestRender`):** Instead of a raw stream, it returns a structured object containing:
       - `output`: The response body (JSON, HTML, etc.).
       - `statusCode`: The HTTP status code set by the transition or service.
       - `errorMessages`: Any errors added to the `ec.message` facade during execution.
       - `contentType`: The response type (e.g., `application/json`).

5. **External Integration / E2E Flows**
   - Heavy end-to-end flows, scheduled jobs, and real third-party integrations such as Shopify, D365, or NetSuite should usually not be tested as Spock unit-style tests.
   - **Why:** These tests are slower, stateful, and depend on external credentials, network availability, and sandbox stability. They are better suited for the `oms-test` repository using Postman/Newman or another E2E testing approach.


> **Rule of thumb::** Use Spock tests for logic, data transformation, entity behavior, and REST contracts. Use E2E tests for real external system communication.

---

## External Integration Testing Rule
For integrations with external systems such as D365, Shopify, or NetSuite, avoid testing the complete HTTP synchronization flow directly inside Spock tests. External API calls make tests slower, less reliable, and dependent on network access, credentials, and sandbox availability.

Instead, split the integration into two clear responsibilities:

1. **Payload Builder / Thinking Part**
   - This layer is responsible for:
     - Reading data from Moqui entities or services 
     - Applying business rules and mappings 
     - Transforming the data into the exact JSON/XML structure expected by the external system

   - This is the ideal layer to test with Spock.
   - **How to test it:**
     - Seed controlled test data 
     - Call the service using ec.service.sync()
     - Assert the generated payload structure and values 
     - Roll back or clean up the transaction after the test

   - These tests are fast, deterministic, and work well in CI pipelines.

2. **HTTP Client / Doing Part**
   - This layer should remain thin and focused only on:
     - Sending the HTTP request
     - Handling the transport-level response
     - Returning success/failure information
   - Because this layer contains little business logic, it is usually not worth heavily mocking or unit testing inside Spock.
   - Instead, validate the real HTTP flow through:
     - Postman/Newman suites
     - Sandbox integration tests
     - External E2E automation

> **Rule of thumb::** Test data transformation and business rules inside Moqui Spock tests. Test real network communication separately through external integration or E2E tests.

This approach keeps Moqui tests fast, reliable, repeatable, and CI-friendly while still giving confidence that the external integration works correctly end to end.

---

## Examples of OOTB Moqui Tests

The following table maps existing OOTB Moqui test files to their category, isolation level, and the core Moqui patterns they demonstrate. Studying these files provides a strong foundation for writing your own tests.

| File | Category | Isolation Level | Demonstrated Patterns |
| :--- | :--- | :--- | :--- |
| **`MessageFacadeTests.groovy`** | Framework Utilities | **In-memory Unit** | Pure memory testing on `ec.message`. Fast, requires no DB setup. State is cleared via `clearAll()` in cleanup. |
| **`ResourceFacadeTests.groovy`** | Framework Utilities | **In-memory Unit** | Heavily utilizes Spock's `@Unroll` data-driven tables (`where:` blocks) to test classpath/file resources and Groovy evaluation. |
| **`ServiceCrudImplicit.groovy`** | Service API | **Tx-Wrapped Integration** | Tests implicit entity services (`create#...`, `update#...`). Disables AuthZ in `setup()`. Wraps calls in DB transactions to keep state clean. |
| **`EntityFindTests.groovy`** | Entity / Cache API | **Tx-Wrapped Integration** | Begins a Tx in `setup()`, commits in `cleanup()`. Demonstrates testing complex query conditions (`EntityCondition`), and cache invalidation. |
| **`SystemScreenRenderTests.groovy`** | UI / Screen Render | **In-process Integration** | Uses `ec.screen.makeTest()`. Demonstrates explicit user login (`ec.user.loginUser()`) and asserts rendered text output or absence of errors. |
| **`RestApiTests.groovy`** | REST API | **In-process Integration** | Uses `ScreenTest` to hit REST endpoints internally without external HTTP clients. Excellent for rapid API contract testing. |
| **`OrderToCashBasicFlow.groovy`** | E2E Business Flow | **Broad Integration** | Stabilizes sequential IDs for reproducibility using `tempSetSequencedIdPrimary()`. Validates large resulting data states using `DataLoader.xmlText(...).check()`. |

---

## Examples of As-Is Patterns in Moqui

To illustrate the concepts discussed above, let's look at real examples from the Moqui framework's own test suite.

### 1. The Tx-Wrapped Integration Setup
This pattern demonstrates how Moqui spins up the real `ExecutionContext`, begins a transaction, and sets up a clean state for testing without complex mocking.

**Reference:** `framework/src/test/groovy/EntityFindTests.groovy`

```groovy
class EntityFindTests extends Specification {
    @Shared
    ExecutionContext ec
    @Shared
    Timestamp timestamp

    def setupSpec() {
        // init the framework, get the ec
        ec = Moqui.getExecutionContext()
        timestamp = ec.user.nowTimestamp
    }

    def cleanupSpec() {
        ec.destroy()
    }

    def setup() {
        // Disable authorization for the test
        ec.artifactExecution.disableAuthz()
        // Begin a database transaction
        ec.transaction.begin(null)
        // Create a real dummy record in the in-memory database
        ec.entity.makeValue("moqui.test.TestEntity").setAll([testId:"EXTST1", testIndicator:null,
                testLong:"", testMedium:"Test Name",
                testNumberInteger:4321, testDateTime:timestamp]).createOrUpdate()
    }

    def cleanup() {
        // Clean up the dummy data
        ec.entity.makeValue("moqui.test.TestEntity").set("testId", "EXTST1").delete()
        // Re-enable authorization
        ec.artifactExecution.enableAuthz()
        // Commit (or rollback) the transaction to isolate tests
        ec.transaction.commit()
    }
}
```

### 2. Data-Driven Edge Case Testing with `@Unroll`
Once the environment is set up with a transaction and dummy data, Moqui relies heavily on Spock's `@Unroll` pattern to elegantly test multiple scenarios (like different inputs or operators) against the real framework logic.

**Reference:** `framework/src/test/groovy/EntityFindTests.groovy`

```groovy
    @Unroll
    def "find TestEntity by operator condition (#fieldName #operator #value)"() {
        expect:
        // Hit the actual Moqui Entity Facade against the in-memory DB
        EntityValue testEntity = ec.entity.find("moqui.test.TestEntity").condition(fieldName, operator, value).one()
        testEntity != null
        testEntity.testId == "EXTST1"

        where:
        // A clear, tabular way to feed multiple scenarios into the test above
        fieldName | operator | value
        "testId" | EntityCondition.BETWEEN | ["EXTST0", "EXTST2"]
        "testId" | EntityCondition.EQUALS | "EXTST1"
        "testId" | EntityCondition.IN | ["EXTST1"]
        "testId" | EntityCondition.LIKE | "%XTST%"
    }
```

### 3. REST API Testing with `ScreenTest`
This pattern shows how to use `makeTest()` to validate REST API contracts. This is the fastest way to ensure your API returns the correct JSON structure.

**Reference:** `runtime/component/hotwax-d365/src/test/groovy/co/hotwax/d365/TransferOrderRestApiTests.groovy`

```groovy
class TransferOrderRestApiTests extends Specification {
    @Shared ExecutionContext ec
    @Shared ScreenTest screenTest

    def setupSpec() {
        ec = Moqui.getExecutionContext()
        // 1. Login a user to simulate an authenticated request
        ec.user.loginUser("hotwax.user", "hotwax@123")
        // 2. Initialize the ScreenTest harness pointing to the REST root
        screenTest = ec.screen.makeTest().baseScreenPath("rest")
    }

    def "GET transferOrders/{orderId} returns success for valid order"() {
        when: "We call the REST endpoint"
        // Simulate: GET /rest/s1/oms/transferOrders/TEST_ORDER
        ScreenTestRender str = screenTest.render("s1/oms/transferOrders/TEST_ORDER", null, "get")
        Map response = new JsonSlurper().parseText(str.output) as Map

        then: "The response is successful and contains valid data"
        !str.errorMessages
        str.statusCode == 200
        response.order != null
        response.order.orderId == "TEST_ORDER"
    }
}
```

### 4. Pure Business Logic Utility Methods
These tests are for methods that perform calculations or transformations based solely on their input parameters. They are "Pure Functions" and are the fastest tests in the system because they require no database.

**Reference:** `co.hotwax.d365.D365MappingWorker.getShipmentMethodTypeId`

```groovy
class D365MappingWorkerTests extends Specification {
    @Unroll
    def "getShipmentMethodTypeId selects correct method (isMixCart=#isMixCartOrder)"() {
        expect:
        // We pass 'null' or a dummy EC because the logic only inspects 'orderItems'
        D365MappingWorker.getShipmentMethodTypeId(null, isMixCartOrder, orderItems) == expectedResult

        where:
        isMixCartOrder | orderItems | expectedResult
        "Y"            | [[shipmentMethodTypeId: 'STOREPICKUP'], [shipmentMethodTypeId: 'GROUND']] | 'GROUND'
        "N"            | [[shipmentMethodTypeId: 'STOREPICKUP'], [shipmentMethodTypeId: 'GROUND']] | 'STOREPICKUP'
    }
}
```

### 5. Data-Access Utility Methods
Some helper methods act as wrappers for common entity lookups or aggregations. These require a database transaction and dummy data.

**Reference:** `co.hotwax.d365.D365MappingWorker.getItemDiscountAmount`

```groovy
    def "getItemDiscountAmount returns absolute value for adjustments"() {
        given:
        // Setup state in the DB using the Tx-wrapped pattern
        ec.entity.makeValue("org.apache.ofbiz.order.order.OrderAdjustment")
            .setAll([orderAdjustmentId: "ADJ_1", orderId: "ORD1", orderItemSeqId: "01", amount: -15.5]).create()

        when:
        BigDecimal discount = D365MappingWorker.getItemDiscountAmount(ec, "ORD1", "01")

        then:
        discount == 15.5
    }
```

---

## Full Real-World Example: `D365MappingWorkerTests`

This class demonstrates how to combine different testing patterns in a single file, inheriting the transaction lifecycle from a base integration test class.

**File Path:** `runtime/component/hotwax-d365/src/test/groovy/co/hotwax/d365/D365MappingWorkerTests.groovy`

```groovy
package co.hotwax.d365

import spock.lang.Unroll

/**
 * Unit tests for D365MappingWorker helper methods.
 * Demonstrates both pure-logic testing and Tx-wrapped integration testing for helpers.
 */
class D365MappingWorkerTests extends D365BaseIntegrationTest {

    /**
     * Case Study: Pure Logic Testing
     * Method only processes input list, skipping specific types for mixed carts.
     */
    @Unroll
    def "getShipmentMethodTypeId selects correct method (isMixCart=#isMixCartOrder, expected=#expectedResult)"() {
        expect:
        D365MappingWorker.getShipmentMethodTypeId(ec, isMixCartOrder, orderItems) == expectedResult

        where:
        isMixCartOrder | orderItems | expectedResult
        "Y"            | [[shipmentMethodTypeId: 'STOREPICKUP'], [shipmentMethodTypeId: 'GROUND']] | 'GROUND'
        "Y"            | [[shipmentMethodTypeId: 'POS_COMPLETED'], [shipmentMethodTypeId: 'EXPRESS']] | 'EXPRESS'
        "Y"            | [[shipmentMethodTypeId: 'STOREPICKUP'], [shipmentMethodTypeId: 'POS_COMPLETED']] | 'STOREPICKUP'
        "N"            | [[shipmentMethodTypeId: 'STOREPICKUP'], [shipmentMethodTypeId: 'GROUND']] | 'STOREPICKUP'
    }

    /**
     * Case Study: Data-Access Integration Testing
     * Method queries OrderAdjustment entity and performs arithmetic.
     */
    def "getItemDiscountAmount returns absolute positive value for adjustments"() {
        given:
        String orderId = "TEST_ADJ_ORD"
        String itemSeqId = "01"
        
        // Create temporary data in the current transaction
        ec.entity.makeValue("org.apache.ofbiz.order.order.OrderHeader")
            .setAll([orderId: orderId, orderTypeId: "SALES_ORDER", statusId: "ORDER_APPROVED"]).create()
        
        ec.entity.makeValue("org.apache.ofbiz.order.order.OrderAdjustment")
            .setAll([orderAdjustmentId: "ADJ_1", orderId: orderId, orderItemSeqId: itemSeqId, 
                     orderAdjustmentTypeId: "EXT_PROMO_ADJUSTMENT", amount: -15.555]).create()

        when:
        BigDecimal discount = D365MappingWorker.getItemDiscountAmount(ec, orderId, itemSeqId)

        then:
        // Verifies rounding logic: -15.555 -> 15.555 -> 15.56
        discount == 15.56

        cleanup:
        ec.entity.find("org.apache.ofbiz.order.order.OrderAdjustment").condition("orderId", orderId).deleteAll()
        ec.entity.find("org.apache.ofbiz.order.order.OrderHeader").condition("orderId", orderId).deleteAll()
    }

    /**
     * Case Study: Integration Mapping Lookup
     * Verifies that the helper correctly fetches mapping values from the database.
     */
    def "getIntegrationTypeMappingValue returns correctly mapped value"() {
        given:
        String typeId = "TEST_TYPE"
        String key = "SOURCE_KEY"
        String value = "MAPPED_VALUE"
        
        ec.entity.makeValue("co.hotwax.integration.IntegrationTypeMapping")
            .setAll([integrationMappingId: "TEST_MAPPING_1", integrationTypeId: typeId, mappingKey: key, mappingValue: value]).create()

        expect:
        D365MappingWorker.getIntegrationTypeMappingValue(ec, typeId, key) == value
        D365MappingWorker.getIntegrationTypeMappingValue(ec, typeId, "NON_EXISTENT_KEY") == null

        cleanup:
        ec.entity.find("co.hotwax.integration.IntegrationTypeMapping")
            .condition("integrationTypeId", typeId).deleteAll()
    }
}
```

---

## Case Study: Identifying and Resolving a Service Crash

Unit tests are most valuable when they uncover hidden bugs that only occur in specific edge cases.

**Scenario:** A developer wrote a test to ensure that requesting a non-existent `orderId` returns an empty object instead of crashing.

**Failing Test Code:**
```groovy
    def "GET transferOrders/{orderId} returns empty order when orderId does not exist"() {
        when: "We call the REST endpoint with a non-existent orderId"
        ScreenTestRender str = screenTest.render("s1/oms/transferOrders/NONEXISTENT-ID", null, "get")
        // The test crashed here with IllegalArgumentException because str.output was null
        Map response = new JsonSlurper().parseText(str.output) as Map

        then:
        response.order.orderId == null
    }
```

**Root Cause:** The underlying service was fetching an `orderHeader` entity but didn't check if it was null before calling `.getPlainValueMap()`. This caused a `NullPointerException` (NPE), which Moqui caught and turned into an error response, resulting in a `null` output for the `ScreenTestRender`.

**Resolution:**
1.  **Service Fix:** Wrapped the service logic in a null check:
    ```xml
    <entity-find-one entity-name="OrderHeader" value-field="orderHeader"/>
    <if condition="orderHeader != null">
        <!-- NPE Prevention: Only process if the order exists -->
        <set field="order" from="orderHeader.getPlainValueMap(0)"/>
        <!-- ... rest of logic ... -->
    </if>
    <else>
        <!-- Graceful handling: return empty results instead of crashing -->
        <log level="warn" message="Transfer Order not found for orderId ${orderId}"/>
        <set field="order" from="[:]"/>
    </else>
    ```
2.  **Test Result:** After fixing the service, the test passed, and the API became robust against missing data.

---

## Writing Your First Test

When you eventually start writing unit tests for your custom code in the OMS:
1. Create a `src/test/groovy` directory in your specific components (e.g., `hotwax-d365` or `poorti`).
2. Rely heavily on the **Tx-Wrapped Integration** pattern: begin a transaction in `setup()`, insert test data, run your service, assert the result, and let the transaction roll back in `cleanup()`. This gives you the speed of a unit test with the confidence of a real database.

---

## How to Run the Tests

To run tests in Moqui using Gradle, use the `test` task.

### Run all default tests
```bash
./gradlew test
```

### Run a specific suite class
```bash
./gradlew test --tests MoquiSuite
```

### Run `hotwax-d365` component tests
```bash
./gradlew :runtime:component:hotwax-d365:test
```

### Run only `D365MappingWorkerTests`
```bash
./gradlew :runtime:component:hotwax-d365:test --tests co.hotwax.d365.D365MappingWorkerTests
```

### If Gradle says `UP-TO-DATE`
Sometimes the command above appears to "not run tests" because Gradle skips the task when inputs and outputs are unchanged.

Force execution with:
```bash
./gradlew :runtime:component:hotwax-d365:test --tests co.hotwax.d365.D365MappingWorkerTests --rerun-tasks
```

Or clean old test outputs first:
```bash
./gradlew :runtime:component:hotwax-d365:cleanTest :runtime:component:hotwax-d365:test --tests co.hotwax.d365.D365MappingWorkerTests
```

### Verifying Test Execution
If the build is successful but you aren't sure if your tests actually ran, check the generated XML or HTML reports.

1. **XML Results:** `runtime/component/<component-name>/build/test-results/test/TEST-<class-name>.xml`
2. **HTML Report:** `runtime/component/<component-name>/build/reports/tests/test/index.html`

Open the XML file and check the `tests` attribute in the `<testsuite>` tag. If it's `0`, no tests were executed.

> Note: In framework-level tests, `framework/build.gradle` may include only suite classes (for example `*MoquiSuite`). In that case, class-level runs can be filtered out unless that include pattern is adjusted.

---

## The Role of the Suite Class

In Moqui, having a Suite class is a best practice and the default way tests are executed. 

### Why is a Suite class built?
Moqui is a comprehensive framework. Booting up its `ExecutionContext`—which initializes the in-memory database, loads entity definitions, caching, screens, and the service facade—takes a few seconds.

If Gradle discovered and ran every single test class (`*Tests.class`) individually, it might repeatedly boot the framework, run one test class, shut it down, and boot it again. This would make running a large test suite incredibly slow and could cause test data conflicts if the database state isn't managed cleanly.

### How it helps run the tests
To solve this, Moqui delegates the responsibility to a Suite class:
1. **Boot Once:** The Suite class initializes the Moqui framework exactly once at the very beginning.
2. **Execute All:** It registers and runs all the individual test classes one by one within that single, already-running context.
3. **Shutdown Once:** After all tests finish, the Suite class safely shuts down the framework and destroys the temporary database.

This ensures test execution remains extremely fast and stable by performing the heavy lifting of framework initialization only once.
