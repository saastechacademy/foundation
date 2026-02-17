# Assignment — **Node.js & V8 Deep Dive (Study + Hands-on)**

**Goal (one line):**
Demonstrate deep, practical knowledge of **Node.js** and the **V8** engine by producing a short study of critical capabilities and by implementing four small experiments that prove you understand how Node/V8 behavior affects server/framework design.

---

## Deliverables (what to submit)

A Git repository containing:

1. **study.md** (≈ 2 pages) — a concise technical write-up that includes:

    * **Critical capabilities of Node.js** (bullet points, 1–2 sentences each). Cover event loop/libuv, microtasks vs macrotasks, streams & backpressure, HTTP internals, worker threads/cluster, child processes, Buffer & binary I/O, native addons (N-API), module systems (CJS/ESM), `async_hooks`, and process/runtime APIs.
    * **V8 essentials:** Ignition/Turbofan JIT pipeline, generational GC, isolates & contexts, snapshots/code cache, and how JIT & GC affect warm-up vs steady state.
    * **Edge vs Node differences**: fetch handler model, missing OS APIs, strict limits and implications for portability.
    * **Mapping runtime facts → design decisions**: short notes on how runtime facts influence router/middleware design, cold start, allocations, etc.
    * **Required short answer (≤ 250 words):** *Why V8 and not “directly on the OS”?* — succinctly explain why we need a JS engine and the consequences for portability & cold starts.

2. **experiments/** — four small experiments, each in its own folder, with runnable scripts, a short README, and minimal tests or scripts to reproduce output:

    * **A: eventloop/** — `eventloop.js` showing ordering of `process.nextTick`, `Promise.then`, `setTimeout(...,0)`, `setImmediate`, and sync logs. Include explanation of the observed order and a short note on implications for framework authors.
    * **B: backpressure/** — `backpressure-server.js` (HTTP server streaming many MBs) and `slow-client.js` (consumes slowly). Demonstrate that the server respects backpressure and memory usage remains bounded. Include instructions and a short script that measures `process.memoryUsage()`.
    * **C: worker/** — `worker-fib.js` (offload CPU-heavy task to Worker threads) and a small benchmark comparing main-thread vs worker offload while serving a `/ping` endpoint. Show responsiveness metrics.
    * **D: gc/** — `gc-demo.js` that repeatedly allocates objects, reports `process.memoryUsage()` and `v8.getHeapStatistics()`, and (optionally) calls `global.gc()` with `--expose-gc`. Include observations and explanation of generational GC effects and design guidance.

3. **README.md** — top-level README with:

    * Node version required (recommend Node 16+ or LTS) and any flags (e.g., `--expose-gc`, `--trace-gc`).
    * How to run each experiment and reproduce the tests/outputs.
    * Short summary of your five concrete recommendations for building a high-performance Node web framework, each tied to evidence from your experiments.
