# Team Organization — Delivery Pod Model

## Purpose
Define how we staff and run project teams so we can:
- Deliver predictable outcomes for clients
- Protect engineering quality
- Build continuity on long-running accounts
- Ramp junior developers into productive engineers

---

## Standard commercial unit
- **1 FTE = 160 hours/month**
- Typical project contracts are expressed in **FTE** (ex: 3 FTE = 480 hours/month)

---

## Core team structure: Delivery Pod
A **Delivery Pod** is the default unit of execution for most projects.

### Roles in a Delivery Pod
- **Project Team Lead** (also SA/Solution Architect)
- **2 Senior Developers**
- **2 Junior Developers**

### Why we use a pod model
- Separates *implementation throughput* from *design/governance leadership* (both client-value; measured differently)
- Creates space for design discipline, code review, testing, and mentoring
- Builds bench strength for future projects

---

## Recommended staffing for a 3-FTE project
**Contract:** 3 FTE (480 hours/month)

**Staffing (default):**
- **1 Team Lead**
- **2 Senior Developers**
- **2 Junior Developers**

> Note: This structure gives enough senior bandwidth to maintain quality while building junior capability and continuity.

---

## Billing policies

### Team Lead billable work policy (what is billable vs not)
A significant portion of Team Lead work (design, governance, reviews) is **client value** and is typically **billable**. To avoid confusion, classify lead time as follows.

**A) Billable (client value, expected)**
- Requirement clarification and solutioning workshops
- Detailed design documents (UML, ERD, data state changes)
- OFBiz OOTB fit-gap analysis and technical decision making
- Architecture and integration design (contracts, idempotency, retries, reconciliation)
- Code reviews and design reviews that prevent defects and rework
- Test strategy definition and sign-off
- Production issue triage, RCA, and prevention plan

**B) Conditionally billable (depends on contract/client)**
- Sprint planning ceremonies and delivery governance
- Status reporting and client coordination

**C) Not billable**
- Internal HR/mentoring discussions unrelated to project deliverables
- Generic training not tied to project deliverables
- Internal process building unrelated to client outcomes

### Typical Lead allocation (guideline)
- **Inception (first ~8 weeks):** Lead spends more time on analysis + design and may be **~50% billable**.
- **Execution (after inception):** Lead remains actively involved through design governance and reviews, typically **~25–35% billable** depending on project needs.

### Junior ramp expectation (guideline)
- Juniors are expected to become reliably productive through bounded ownership, strict PR reviews, verification SQL, and test coverage.
- Team Leads are accountable for making juniors productive within 6 months (see "Junior productivity standard").

---

## Team composition guidelines
This document defines the **default** pod as **1 Lead + 2 Senior + 2 Junior**.

When projects need a different mix, the Team Lead and Account/PM should explicitly document the rationale (risk, timeline, production load, domain complexity) and how quality will be protected.

### Guardrails
- Juniors should not be sole owners of critical workflows in the first 6 months.
- Senior coverage is required for data integrity and workflow correctness.

---

## Inception Pack (required deliverable)
Every project starts with an **Inception Pack** owned by the Team Lead. Structure is consistent; depth is flexible.

Required sections:
- Scope + In/Out + top risks
- Workflow UML (main + alternate paths)
- ERD (OOTB vs custom entities)
- Data state changes with sample data
- Verification/reconciliation SQL playbook
- Service/API responsibilities + mapping to workflow steps
- NFRs + test strategy
- Team execution rules (PR discipline, Definition of Done)

---

## Project types (for flexibility)
Most projects fit one of these:

### Type A: OFBiz workflow customization
- Emphasis: workflows, state transitions, regression risk

### Type B: Integrations (Shopify/ERP/POS/Carrier)
- Emphasis: contracts, idempotency, retries, reconciliation, operational readiness

---

## Junior productivity standard
The Team Lead is responsible for making each junior **productive within 6 months**.

Productive means the junior can independently deliver a bounded change with:
- Workflow understanding
- Correct data mutations
- Verification SQL
- Test cases / regression awareness
- Minimal rework by seniors

---

## Cadence and reporting (lightweight)

### Weekly (pod-level)
- Delivery status: planned vs done
- Risks + dependencies
- Support load (if applicable)

### Bi-weekly (capability growth)
- Junior progress: shipped items + domain/workflow learned
- Quality signals: rework/defects found, improvements made

### Twice monthly (story capture)
- Achievements, challenges, learnings, customer impact
- Shared with Account/PM and Marketing

---

## Principles
- We sell outcomes, not hours.
- We invest intentionally in training and continuity.
- Design-first work reduces rework and improves predictability.

