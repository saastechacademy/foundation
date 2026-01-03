# Role Definition: Project System Truth Owner (PSTO)

## 1. Role Purpose
The Project System Truth Owner (PSTO) is a **project-level responsibility** responsible for protecting the **long-term explainability, data correctness, and supportability** of a client’s implemented solution **after go-live**.

The primary objective of this responsibility is to ensure that the system remains:
- explainable to new engineers months later,
- supportable without heroic debugging,
- and verifiable through data/SQL evidence.

This responsibility exists to prevent post-go-live entropy where projects become “their own world” and long-term maintenance becomes costly.

---

## 2. What PSTO Is (and is not)
- **PSTO is not a job title.** It is a responsibility assigned to a person on a project.
- PSTO can be held by a **Business Systems Analyst (preferred)**, or another qualified project role as assigned by Delivery.
- PSTO **does not write production code**.

---

## 3. Assignment Rules

### 3.1 When PSTO is assigned
PSTO is assigned **at MVP contract signing (end of discovery)**.

**Gate:** Sprint planning for MVP may not begin until PSTO is assigned.

### 3.2 Who assigns PSTO
PSTO is assigned by the **Delivery Manager**.

### 3.3 One PSTO vs Two PSTOs
- Default: **One PSTO per project**
- For large projects: **Two PSTOs**, split by **business domain** with clear boundaries:
  - **PSTO – Order Domain**
  - **PSTO – Fulfillment Domain**

**Attendance rule:** If two PSTOs are assigned, **both PSTOs must attend both mandatory checkpoints** (Solution Design Review + Pre-Production Readiness Review).

---

## 4. Key Responsibilities

### 4.1 System Truth Documentation
Maintain the authoritative “Workflow Truth Doc” for the client system including:
- workflow steps and alternate flows,
- entities and data mutations per step,
- status/state transitions,
- invariants (“must always be true” rules),
- failure modes and where-to-look-first guidance.

### 4.2 Embedded SQL Proof Pack (Mandatory)
For each major workflow step, maintain **embedded SQL queries** that:
- prove expected data mutations occurred,
- detect stuck states,
- reconcile inconsistencies,
- explain system behavior in production.

If it cannot be verified with SQL, it is not “system truth.”

### 4.3 Change Control After Go-Live
Ensure post-go-live changes do not break system truth.

**Definition of Done rule (mandatory):** Any post–go-live change is not “Done” until PSTO updates:
1) workflow steps + data mutation map, and
2) embedded SQL proof pack
(on the same Confluence workflow truth page).

### 4.4 Support Handoff Readiness
Own the post-go-live handoff to support:
- key workflows and data state references,
- core SQL queries and interpretation notes,
- known failure modes and safe recovery actions.

### 4.5 Participation in Mandatory Checkpoints
PSTO must participate in:
- **Solution Design Review**
- **Pre-Production Readiness Review**

These checkpoints are governed by the Engineering Steward.

---

## 5. Authority
The PSTO has the authority to:
- define the authoritative workflow truth for the client system,
- require documentation/SQL proof updates before closing post-go-live changes,
- block “Done” status for changes that lack updated truth + proof.

For standards conflicts or architectural disputes, PSTO escalates to Engineering Steward.

---

## 6. Explicit Exclusions (Out of Scope)
The PSTO does not own:
- writing production code (Java/minilang/etc.)
- client relationship ownership or account management
- billing, commercial negotiations, or upsell
- engineering performance management / HR
- sprint velocity commitments (though PSTO influences priorities via correctness and risk)

---

## 7. Decision and Escalation Process
1. Project team proposes change / implementation approach
2. PSTO ensures workflow truth + SQL proof exists/updated
3. If approach violates standards or introduces risky patterns → escalate to Engineering Steward
4. Engineering Steward decides based on company standards and can block production readiness
5. If unresolved disagreement → escalate to CEO (per Engineering Steward governance)

---

## 8. Success Metrics
The PSTO effectiveness is evaluated based on:
- reduction in post-go-live confusion (“why is it doing this?”)
- faster support resolution due to available SQL proof and invariants
- fewer recurring “stuck” states and unknown data corruption
- completeness and freshness of Workflow Truth Docs (including embedded SQL) for the client system
- smooth onboarding of new engineers into the client project without tribal knowledge dependency

---

## 9. Time Allocation Guidelines
Guideline for a typical active project:
- 40–60%: workflow truth, SQL proof, and change-control updates
- 20–30%: coordination with delivery + clarifications
- 10–20%: support handoff readiness and production stabilization

PSTO should not be fully allocated to delivery task execution.

---

## 10. Guiding Principle
Project teams build the solution.

The PSTO ensures the solution remains **explainable, verifiable, and supportable** after go-live.

