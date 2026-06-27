# Moqui Service & SQL‑Rendering Assignment

> **Builds on:** [SQL Assignment 1](./sql-assignment-1.md), [SQL Assignment 2](./sql-assignment-2.md), [SQL Assignment 3](./sql-assignment-3.md)
>
> **Level:** Intermediate → Advanced. You should already be comfortable writing SQL against the UDM schema and reading Moqui XML.

## Why this assignment exists

In the SQL assignments you wrote raw SQL by hand. In a real OMS you almost never hand‑write SQL — you describe *what* you want to the **entity engine**, and the framework renders the SQL for you, for whatever database is configured. This assignment takes the same business questions and makes you build them **through the entity engine**, then makes you prove you understand what the engine does under the hood by recovering **the exact SQL it would run, before it runs**.

By the end you will be able to answer, with evidence, three questions a senior engineer is expected to answer cold:

1. *What object does the entity engine build when I describe a query?*
2. *How is that object turned into a SQL string?*
3. *Can I see that SQL before it touches the database — and why would I want to?*

## Learning objectives

- Translate a business problem into a Moqui **service** backed by the entity engine (not raw SQL).
- Describe the **object model** of a query in the Moqui entity engine.
- **Render the SQL** a query will execute **before** it executes — without cheating.
- Explain **how** the entity engine transforms a query object into a SQL string.

---

## Part 0 — Set up Maarg with demo data

1. Stand up a Maarg instance (the `moqui-framework` root is your working directory for everything below).
2. Load the full demo dataset:
   ```bash
   ./gradlew load        # full dev install: every reader type, once
   ./gradlew run
   ```
3. Confirm the data model is present. Using the entity tools (or a quick throwaway query), verify you can read from `Party`, `Product`, `OrderHeader`, `OrderItem`, `ReturnHeader`, `InventoryItem`, and `Facility`. If those return rows, your environment is ready.

> If you cannot get rows from those entities, **stop and fix your environment first.** Every later part assumes a loaded, queryable database.

---

## Part 1 — Write the SQL (from Assignments 1–3)

For **every** query in SQL Assignments 1, 2, and 3, write and validate the raw SQL against your demo database. This is your *reference answer* — you will check the engine‑rendered SQL against it later.

Keep each query's SQL; you will submit it.

---

## Part 2 — One service per query

Write **one Moqui service per query** — one service for each query in Assignment 1, one for each in Assignment 2, and one for each in Assignment 3.

Rules:

- The service must produce its result **through the entity engine** — i.e. by building a query object with `ec.entity.find(...)` (conditions, fields, order‑by, etc.).
- You may **not** hand‑write the SQL and run it through `ec.entity.sqlFind(...)`. The whole point is to let the engine render SQL *for* you.
- **Naming:** `get#A1Q01NewCustomers`, `get#A1Q02ActivePhysicalProducts`, … (assignment number, query number, short noun). Keep it consistent.
- Each service declares its `out-parameters` (the field list the business problem asks for) and returns the rows.

> ⚠️ **A design constraint you must discover for yourself in Part 4 will affect how you write these services.** Read Part 4 before you finalize the *implementation style* of your services. (Hint: a query written one way gives you a handle on the query *object*; written another way, the object is hidden from you.)

Deliver: one service definition file per assignment (or one per query — your choice), plus a short `README` mapping **query number → service name**.

---

## Part 3 — Explain the query object model

Pick any one of your services. Get a reference to the query object your service builds (the thing `ec.entity.find(...)` returns) and **document its object model** in the Moqui entity engine.

Your write‑up must answer:

- What **interface** does `ec.entity.find("…")` return, and what **concrete class** implements it? Where does that class live?
- What does that object **hold**? Enumerate its parts: the entity it targets, the conditions, the fields to select, ordering, paging, caching, distinct, for‑update.
- How is a **single condition** represented as an object versus a **group** of conditions (an `AND`/`OR` of many)? Name the classes.
- Where does the **field/column metadata** for the target entity live? (When the engine needs to know that field `entryDate` maps to column `ENTRY_DATE` of table `PARTY`, what object does it ask?)
- For a query that **joins** (a view‑entity), what represents each joined member and the join itself?

Draw the object graph (a simple boxes‑and‑arrows diagram is fine) and reference the actual class/file names from the framework source.

**Guiding questions (no answers provided):**
- If you call `.condition("statusId", "ORDER_COMPLETED")` and then `.condition("orderDate", greaterThan, someDate)`, how many condition objects exist, and how are they combined?
- Is the query object reusable after it runs? Can you modify and re‑run it?

---

## Part 4 — Print the SQL **before** it hits the database

This is the heart of the assignment.

**Requirement:** For at least one service per assignment, emit the **exact SQL string** the query will execute, **and the parameter values** that go with it, **before any execution touches the database.** Print it to the log (or return it as an out‑parameter).

**Hard constraint — the obvious method is banned:**

> ❌ You may **not** use `EntityFind.getQueryTextList()`.

Before you do anything else, investigate **why** it is banned. Read where that list gets populated in the framework source. Write one or two sentences explaining *exactly* when it is filled — and therefore why it cannot satisfy "before it hits the database."

**Then find the real path. Guided hints (in order — try each before reading the next):**

1. The entity engine does not write SQL by hand either. Somewhere in `org.moqui.impl.entity` there is a class whose entire job is to **build the SQL for a find**. Find it. Its name describes what it does.
2. Read `EntityFindBase` and follow what happens when a find is actually run (look for the methods that the `list()` / `iterator()` / `one()` calls funnel into). There is a precise **sequence** of steps that assemble the `SELECT`, the `FROM`, the `WHERE`, the `ORDER BY`.
3. In that sequence, **exactly one step touches the database.** Every step before it only appends to a string buffer. Identify that one step. Everything before it is "free" and runs without a query.
4. The builder needs a few **inputs** to do its work (the entity definition, the combined where‑condition, the list of fields). Are those inputs reachable from your query object and its entity definition through **public** methods? (You verified part of the object model in Part 3 — use it.)
5. Assemble the SQL the same way the engine does, but **stop before the one step that executes.** Read the assembled string back out.

**Prove it never executed.** Your evidence can be anything convincing, e.g.: point your service at an intentionally heavy query, emit the SQL, and show the service returns/logs the SQL with **zero rows fetched** and no query time recorded; or instrument and show the execute path was never entered.

Deliver: for each demonstrated query, the **rendered SQL + parameter values**, captured **before** execution, with your banned‑method explanation.

---

## Part 5 — Explain how the SQL rendering runs

Write a short technical note (a page is plenty) explaining **how the query object becomes a SQL string.** Walk the path you discovered in Part 4 and answer:

- Which method kicks off rendering, and what is the **order** of the pieces (`SELECT` fields → `FROM` → `WHERE` → `GROUP BY` → `ORDER BY` → limit/offset)?
- For a **view‑entity** (a join), how is the `FROM` clause with its joins produced? What is a "member entity" and how does a member become a `JOIN`?
- How is a **condition object** turned into a `WHERE` fragment? Where do the `?` placeholders come from, and **how are the parameter values bound** to them?
- Where does **database‑specific** SQL come from (e.g. `LIMIT/OFFSET` differences, function names)? What configuration drives it?
- Why is rendering separated from execution at all? (Tie this back to *why* you'd ever want the SQL before it runs — think cost, safety, debugging, governance.)

---

## What to submit

For each assignment (1, 2, 3):

| # | Deliverable |
|---|---|
| 1 | The validated **raw SQL** for every query |
| 2 | **One service per query** + a `README` mapping query → service name |
| 3 | A **query object‑model** write‑up with a diagram and real class/file references |
| 4 | **Rendered SQL + params, captured before execution**, for the demonstrated queries, plus your `getQueryTextList()` ban explanation |
| 5 | The **"how rendering runs"** technical note |

You are graded as much on **understanding** (Parts 3 & 5) as on working code (Parts 2 & 4). A service that returns correct rows but whose author cannot explain the object model or the rendering path is an incomplete submission.

---

## Ground rules

- No raw SQL execution (`sqlFind`) — the engine renders SQL, not you.
- No `getQueryTextList()` for Part 4.
- Cite the **actual** framework source you relied on (class names, files). "I read it somewhere" is not a citation.
- If a business problem is ambiguous, state your interpretation and proceed — just be explicit.
