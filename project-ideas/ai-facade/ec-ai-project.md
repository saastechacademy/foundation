# ec.ai — AI Facade for Moqui Framework

## Executive Summary

This project adds native AI capability to the Moqui Framework by implementing
`ec.ai` — a first-class facade following the same architecture pattern as
`ec.elastic`, `ec.cache`, and `ec.entity`. Any Groovy service, screen action,
or scheduled job in a Moqui-based application can now call a large language
model with a single line:

```groovy
String response = ec.ai.getDefault().generate(messages)
```

or receive structured, schema-validated output:

```groovy
Map result = ec.ai.getDefault().generateStructured(messages, schema)
```

The implementation uses LangChain4j 1.8.0 as the provider SDK, supports
OpenAI and any OpenAI-compatible endpoint, and is fully configurable via
Moqui's standard `MoquiConf.xml` / environment variable mechanism — with no
code changes required to switch providers or models.

---

## Moqui's Extensible Architecture

Moqui is designed for extension. The mechanism is the facade pattern on
`ExecutionContext`. Every major capability in the framework — caching,
entity access, service invocation, search — is exposed as a named facade
on `ec`:

| Facade | Access | Purpose |
|---|---|---|
| `ec.cache` | `CacheFacade` | Distributed caching |
| `ec.entity` | `EntityFacade` | Database access |
| `ec.service` | `ServiceFacade` | Service invocation |
| `ec.elastic` | `ElasticFacade` | Elasticsearch/OpenSearch |
| `ec.ai` | `AiFacade` | **AI/LLM — added in this project** |

Each facade follows the same lifecycle: a singleton instance is created and
held by `ExecutionContextFactoryImpl` (ECFI) at framework startup, wired into
each per-thread `ExecutionContextImpl`, and exposed via the
`ExecutionContext` public interface.

`ec.elastic` is the clearest reference implementation for `ec.ai`. It manages
named client connections configured in XML, initializes them at startup, and
exposes them by name. `ec.ai` follows this pattern exactly — `ec.elastic`'s
`<cluster>` element is the direct analog of `ec.ai`'s `<model-config>`.

This architecture means `ec.ai` is not an add-on or plugin — it is a
framework-level capability available everywhere Moqui runs, without imports,
without component dependencies, without service calls.

---

## What Was Delivered

### New framework capability — `ec.ai`

**Two methods on every execution context:**

```groovy
// Free text response
String summary = ec.ai.getDefault().generate([
    [role: "system", content: "You are a concise assistant."],
    [role: "user",   content: "Summarize this order: ${orderText}"]
])

// Structured Map response — schema enforced at API level
Map result = ec.ai.getDefault().generateStructured(messages, [
    status:    [type: "string"],
    amount:    [type: "number"],
    lineItems: [type: "array", items: [
        productId: [type: "string"],
        qty:       [type: "integer"]
    ]]
])
```

**Multiple named providers:** Configure as many `<model-config>` entries as
needed and reference them by name:

```groovy
ec.ai.getConfig("gpt4o").generate(messages)      // high accuracy
ec.ai.getConfig("gpt4o-mini").generate(messages) // high throughput
```

**JSON Schema vocabulary for structured output:** Types are `string`, `number`,
`integer`, `boolean`, `array`, `object` — standard, provider-agnostic, no Java
class names.

**Wire-level DEBUG logging:** Every call logs a correlation ID, provider, model,
messages, schema (if any), and full response — designed for enterprise debugging.

**Fail-fast validation:** `getDefault()` and `getConfig(name)` throw
`IllegalStateException` with a clear actionable message if credentials are
missing — no silent failures or cryptic provider errors.

### Configuration

In `MoquiConf.xml` or as environment variables:

```xml
<default-property name="ai_provider"  value="openai"/>
<default-property name="ai_model"     value="gpt-4o-mini"/>
<default-property name="ai_base_url"  value=""/>
<default-property name="ai_api_key"   value="sk-..." is-secret="true"/>
<default-property name="ai_timeout"   value="60"/>
<default-property name="ai_pool_max"  value="10"/>
```

The `<ai-facade>` block in `MoquiDefaultConf.xml`:

```xml
<ai-facade default-config="default">
    <model-config name="default"
                  provider="${ai_provider}"
                  model="${ai_model}"
                  base-url="${ai_base_url}"
                  api-key="${ai_api_key}"
                  timeout="${ai_timeout}"
                  pool-max="${ai_pool_max}"/>
</ai-facade>
```

---

## Technical Architecture

### Three-layer registration (following `ec.elastic`)

```
ExecutionContextFactoryImpl  (singleton — one per JVM)
  └── aiFacade: AiFacadeImpl
        └── clientByName: Map<String, AiClientImpl>

ExecutionContextImpl  (per thread)
  └── aiFacade  ←  ecfi.aiFacade   [delegation, no copy]

ExecutionContext  (public interface)
  └── getAi()  →  ec.ai
```

### Key design decisions

**`<model-config>` element name**
Parallel to `<datasource>` in `entity-facade`. The element describes
a named connection; `provider` is an attribute naming the LLM company —
same pattern as `database-conf-name` naming the DB vendor.

**LangChain4j as the SDK**
Direct HTTP was considered (matching `ec.elastic`'s approach) but rejected
because the roadmap includes agents, tools, RAG, and embeddings. LangChain4j
provides these capabilities without rebuilding them. The cost is a dependency;
the benefit is a production-tested, actively maintained provider abstraction.

**JSON Schema vocabulary for `generateStructured`**
The schema passed to `generateStructured` uses `string`, `number`, `integer`,
`boolean`, `array`, `object` — not Java class names. This is provider-agnostic
and familiar to any developer who has worked with JSON Schema or OpenAPI.
The impl converts this to the native JSON Schema format required by the
model API, enforcing output shape at the API level (Mechanism 3 — not prompt
injection, not JSON mode only).

**`TYPE_BUILDERS` map pattern in schema conversion**
Instead of a switch statement keyed on type strings, a static immutable
`Map<String, Closure<JsonSchemaElement>>` is used. Adding a new type requires
one line. No switch editing.

**Fail-fast at call time, not startup**
If `ai_api_key` is not configured, Moqui starts normally. The error is thrown
at the point of `ec.ai.getDefault()` with a message that names the exact
property to set and where to set it. This is consistent with how Moqui handles
other optional facades.

### Files changed

| Status | File |
|---|---|
| **New** | `framework/src/main/java/org/moqui/context/AiFacade.java` |
| **New** | `framework/src/main/groovy/org/moqui/impl/context/AiFacadeImpl.groovy` |
| **New** | `framework/src/test/groovy/AiFacadeTests.groovy` |
| **New** | `framework/README.md` |
| Modified | `framework/src/main/resources/MoquiDefaultConf.xml` |
| Modified | `framework/src/main/java/org/moqui/context/ExecutionContext.java` |
| Modified | `framework/src/main/java/org/moqui/context/ExecutionContextFactory.java` |
| Modified | `framework/src/main/groovy/org/moqui/impl/context/ExecutionContextImpl.java` |
| Modified | `framework/src/main/groovy/org/moqui/impl/context/ExecutionContextFactoryImpl.groovy` |
| Modified | `framework/build.gradle` |

---

## Project Plan and Execution

### Six steps

| Step | Deliverable | Status |
|---|---|---|
| 1 | `MoquiDefaultConf.xml` — config properties and `<ai-facade>` block | ✅ Done |
| 2 | `AiFacade.java` — public interface | ✅ Done |
| 3 | `AiFacadeImpl.groovy` — LangChain4j implementation | ✅ Done |
| 4 | Wiring into `ExecutionContext` and `ExecutionContextFactory` | ✅ Done |
| 5 | `AiFacadeTests.groovy` — smoke tests | ✅ Done |
| 6 | README and `generateStructured` test case | ✅ Done |

Step 3 was broken into three sub-tasks (3a: dependencies, 3b: outer class
skeleton, 3c: inner class with full implementation) after early proposals
produced duplicate methods and incorrect schema conversion logic. Breaking
large tasks into smaller, reviewable units caught more errors.

### Notable decisions made during execution

- **Naming** — `<model-config>` chosen over `<provider>`, `<ai-service>`,
  `<ai-gateway>`, `<llm-config>` for consistency with Moqui's `<datasource>`
  pattern and to avoid collision with LangChain4j's `AIService` class.
- **Java 21** — Upstream `moqui/moqui-framework` targets Java 21.
  A fresh fork (`patelanil/moqui-framework`) was used rather than the
  team's JDK 11 fork, enabling LangChain4j 1.8.0.
- **`ResponseFormatType.JSON` not `JSON_SCHEMA`** — discovered at compile
  time. LangChain4j 1.8.0's enum has `TEXT` and `JSON` only; `JSON_SCHEMA`
  does not exist. Fixed immediately by the compile step.
- **`ExecutionContextFactory.java` also needs `getAi()`** — discovered when
  the ECFI `@Override` failed to compile. `ec.elastic` is declared on both
  `ExecutionContext` and `ExecutionContextFactory`; `ec.ai` must match.

### GitHub references

| Resource | URL |
|---|---|
| Code branch | `patelanil/moqui-framework` — `feature/ec-ai-facade` |
| Issue tracker | `hotwax/moqui-ai` |
| Issue #1 — Overall plan | `https://github.com/hotwax/moqui-ai/issues/1` |
| Issue #2 — Interface | `https://github.com/hotwax/moqui-ai/issues/2` |
| Issue #3 — Implementation | `https://github.com/hotwax/moqui-ai/issues/3` |
| Issue #4 — Wiring | `https://github.com/hotwax/moqui-ai/issues/4` |
| Issue #5 — Smoke test | `https://github.com/hotwax/moqui-ai/issues/5` |
| Issue #6 — README + structured test | `https://github.com/hotwax/moqui-ai/issues/6` |

---

## Possibilities in HotWax Commerce OMS

HotWax Commerce's order routing engine is built on three core concepts:
**Runs** (scheduled brokering jobs), **Routings** (order batch pathways),
and **Rules** (recursive inventory allocation filters). The engine is
configurable but rule-based — it selects the optimal fulfillment location
based on criteria like proximity, inventory levels, capacity, and shipping
method.

`ec.ai` opens a new layer: the ability to bring language understanding,
pattern recognition, and reasoning into the order management workflow —
alongside the existing rule engine, not replacing it.

### Intelligent order approval

Today, orders are auto-approved based on predefined criteria. With `ec.ai`,
orders that fall outside standard criteria — flagged for fraud risk, unusual
shipping addresses, high-value anomalies — could be analyzed by an LLM before
approval decisions are made, with a structured risk assessment returned for
automated or human-in-the-loop review.

### Routing rule explanation and diagnostics

The order routing engine can silently move orders through Unfillable Parking
or reject them to the next rule. A Moqui service could use `ec.ai` to generate
a human-readable explanation of why a specific order was routed the way it was
— useful for CSR teams handling customer escalations about delayed or split
orders.

### Dynamic routing configuration suggestions

During peak events (holiday sales, flash sales), retailers manually adjust
brokering runs and routing rules. `ec.ai` could analyze historical order
volume, current inventory distribution across facilities, and upcoming
promotional calendars to suggest optimal brokering run frequencies, batch
priorities, and facility group configurations — returned as structured output
directly consumable by the routing configuration services.

### Unfillable order triage

Orders parked in Unfillable Parking today wait for a scheduled job or manual
intervention. `ec.ai` could analyze the order details, current inventory
positions across all facilities, incoming purchase orders, and customer loyalty
status to suggest the best next action — hold, reroute, offer alternative
product, or escalate to CSR — as structured output with a confidence score.

### Brokering exception handling

When a fulfillment location rejects an order (out of stock, damaged inventory),
the current flow reroutes automatically. `ec.ai` could generate a structured
summary of rejection patterns across locations and time periods, helping
operations teams identify systemic inventory accuracy issues or capacity
misconfigurations before they affect SLA performance.

### Promise date intelligence

HotWax Commerce calculates Available-to-Promise inventory and provides
delivery estimates. With `ec.ai`, natural language queries about delivery
windows — from internal tools or customer-facing chat — could be answered
by combining ATP data with carrier performance history and current routing
configurations, returned as structured output for display.

---

*For the development workflow, prompt architecture, and Claude Code usage
guide, see `claude-code-workflow.md`.*
