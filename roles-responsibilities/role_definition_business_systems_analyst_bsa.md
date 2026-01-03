# Role Definition: Business Systems Analyst (BSA)

## 1. Role Purpose
The Business Systems Analyst (BSA) is a **client-facing** role responsible for translating business needs into clear, OFBiz-aligned workflows and verifiable system behavior.

The primary objective is to ensure solutions are:
- correctly modeled in Apache OFBiz workflows and data model,
- documented clearly for developers,
- and provable through data/SQL.

BSA is also the primary growth path into the **PSTO responsibility** (Project System Truth Owner).

---

## 2. Role Scope
The BSA owns **clarity**:
- business workflows and exceptions,
- OFBiz mapping and gaps,
- data mutations and invariants,
- SQL proof strategy,
- and “what correct looks like” for the implemented system.

Project teams own implementation.

Engineering Steward owns standards/guardrails and mandatory reviews.

---

## 3. Key Responsibilities

### 3.1 Client Discovery and Requirement Clarity (Client-facing)
The BSA is responsible for **eliciting, clarifying, and validating** requirements — not just recording them.

- Lead discovery conversations (or co-lead with Sales/PM)
- Ask structured questions to uncover:
  - workflows, exceptions, and edge cases
  - operational constraints (timing, cutoffs, roles, approvals)
  - data ownership (source of truth) and integrations
- Convert “what the client wants” into:
  - explicit workflow steps
  - decision rules
  - clear acceptance criteria
- Validate understanding by playing back:
  - workflow diagrams / step lists
  - “before state → after state” expectations
- Document:
  - assumptions
  - open questions
  - decisions made (with date)

### 3.2 OFBiz Workflow and Data Model Mapping
- Map requirements to OFBiz OOTB workflows and entities
- Identify gaps and propose solution approach (OOTB-first)
- Ensure entity usage is correct and consistent

### 3.3 Solution Design Documentation
Produce documents that developers can implement without guesswork:
- workflow steps (happy path + alternates)
- data state transitions and invariants
- entity-level mutations per step (what changes, where, why)
- service/API responsibilities (names + responsibilities)
- sample before/after data for key workflow steps

### 3.4 SQL Proof and Verification Strategy
- Create and maintain SQL queries to verify behavior and state transitions
- Maintain “stuck state” and reconciliation queries
- Write interpretation notes so others can use SQL reliably

### 3.5 Sprint Support and Delivery Collaboration
- Participate in sprint planning and clarify acceptance criteria
- Validate delivered behavior against design intent (via SQL + workflow checks)
- Keep the design truth updated as scope evolves

### 3.6 Post-Go-Live Supportability
- Contribute to support handoff: “where to look first” + SQL proof pack
- Help stabilize production by explaining behavior via data, not opinions

---

## 4. Client-Facing Operating Model

### 4.1 Meetings the BSA should attend
- Discovery calls (process walkthroughs, requirements validation)
- Design walkthroughs with client stakeholders
- Sprint review / demos (when system behavior needs explanation)
- UAT readiness / go-live prep sessions

### 4.2 What the BSA should NOT own in client interactions
- Pricing, contract terms, commercial negotiation (Sales)
- Commitments on timelines without PM/Delivery alignment
- Scope changes without change-control path

### 4.3 How the BSA protects HotWax in calls
- Turn vague asks into **testable outcomes** (“What must be true in the system after this step?”)
- Confirm exceptions explicitly (“What happens when it fails / partial / out-of-stock?”)
- Anchor discussion in **workflows and data**, not UI preferences
- Capture decisions in writing (“We agreed X, which implies Y system behavior”)
- Avoid committing to timelines; focus on **clarity and correctness**

---

## 5. PSTO Alignment

### 5.1 PSTO is a Responsibility, Not a Job Title
A BSA may be assigned PSTO responsibility on a project once capable.

### 5.2 PSTO-ready indicators
A PSTO-ready BSA can:
- maintain workflow truth docs (steps + data mutations)
- define invariants and state transitions
- maintain embedded SQL proof pack
- enforce “not done until workflow + SQL updated” post go-live
- escalate standards violations to Engineering Steward calmly

---

## 6. Authority
The BSA has authority to:
- insist on clarity in workflows and acceptance criteria
- require that critical behaviors are verifiable through SQL/data
- push back on ambiguous requests until they become actionable

If assigned PSTO responsibility, the person additionally has authority to block “Done” on post-go-live changes until truth + SQL is updated (per PSTO policy).

---

## 7. Explicit Exclusions
The BSA does not own:
- writing production code
- final architectural veto (Engineering Steward)
- production deployment veto (Engineering Steward)
- account ownership and billing (Sales/Account owner)
- day-to-day project administration (PM)

---

## 8. Success Metrics
- Fewer rework cycles caused by unclear requirements
- Developers implement correctly without repeated clarification
- OFBiz mapping quality (OOTB-first, minimal unnecessary customization)
- SQL proof pack exists and is used by support/delivery
- Post-go-live issues become explainable quickly (no mystery behavior)

---

## 9. Guiding Principle (updated)
A BSA doesn’t just *collect* requirements.

A BSA **clarifies, structures, and validates** requirements by converting them into **workflows, data state transitions, and SQL-verifiable outcomes**.

