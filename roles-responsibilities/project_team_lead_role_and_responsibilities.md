# Project Team Lead — Role & Responsibilities

## Role purpose
A Project Team Lead is accountable for **predictable delivery**, **high engineering quality**, and **team capability-building** on a client project built on Apache OFBiz (workflow customization and/or integrations).

The Team Lead ensures the team delivers outcomes while steadily raising:
- Apache OFBiz mastery
- Supply Chain / OMS domain understanding
- Design discipline
- Engineering standards
- Junior developer productivity

---

## Core accountabilities

### 1) Client delivery ownership
- Own project outcomes: scope, timelines, risks, and delivery predictability.
- Ensure work delivered each sprint adds measurable value for the customer.
- Manage trade-offs (speed vs quality) without accumulating unmanaged technical debt.
- Escalate early when requirements, dependencies, or risks threaten delivery.

### 2) Inception phase leadership (first 8 weeks)
During project start, the Team Lead operates as **System Analyst + Solution Architect** (and may bill during this phase per project policy).

**Deliverable: Inception Pack** (flexible depth; standard structure)
- Scope + In/Out + top risks
- Workflow UML (main + alternate paths)
- ERD (OOTB vs custom entities)
- Data state changes with sample data
- Verification / reconciliation SQL playbook
- Service/API responsibilities + mapping to workflow steps
- Non-functional requirements (NFRs) + test strategy
- Team execution rules (PR discipline, Definition of Done)

**Success definition:** After inception, implementation becomes predictable and verifiable.

### 3) Design-first engineering discipline
For all non-trivial work, enforce “design before code”:
- UML workflow + ERD + data state thinking
- Clear mapping: workflow step → service → data mutation
- Verification SQL and test cases are part of “done”

The Team Lead ensures the team can **explain and defend** the design (not just implement it).

### 4) Quality and code stewardship
- Enforce coding best practices and maintainable patterns.
- Ensure strong PR reviews (correctness, readability, native OFBiz style).
- Prevent “wrap-and-patch” development that degrades the codebase.
- Ensure adequate tests and regression coverage for workflow-sensitive changes.
- Maintain operational readiness: logging, error handling, consistency, idempotency where relevant.

### 5) OFBiz + domain mastery development
The Team Lead ensures the team strengthens:
- OOTB OFBiz codebase understanding
- OOTB business workflows (Order-to-Cash, Procure-to-Pay)
- Inventory, Fulfillment, Shipping, Receiving, Transfers, ATP/Brokering concepts (as relevant to the project)

The Team Lead models “OFBiz expertise” by explaining the **why** behind patterns and decisions.

### 6) Junior developer productivity (mandatory ownership)
Because teams include junior developers, the Team Lead owns the responsibility to make each junior **productive within 6 months on the job**.

**Productive means a junior can independently deliver a bounded change with:**
- Workflow understanding
- Correct data mutations
- Verification SQL
- Test cases / regression awareness
- Minimal rework by seniors

The Team Lead provides:
- A ramp plan
- Scoped ownership boundaries
- Structured reviews and coaching
- Weekly visibility on junior progress

### 7) Team culture and work discipline
- Build a culture of punctuality, focus, and full productive workdays.
- Ensure the team follows office schedule expectations and avoids “late start” normalization.
- When performance is weak, first verify fundamentals: attendance, consistency, communication, planning discipline.

### 8) Communication and storytelling (twice monthly minimum)
At the end of each sprint (at least twice a month), communicate the “life of the team/project”:
- Achievements and learnings
- Major client problems solved (business process / UX / operations)
- Challenges and how they were addressed
- Customer reality: operational stories, constraints, insights

Share this with:
- Account/PM (if present)
- Marketing team (for newsletter and content roadmap inputs)

---

## What the Team Lead is evaluated on
- Predictable delivery and client outcomes
- Quality: defects, rework, support stability
- Design discipline: quality of design artifacts and clarity of thinking
- Team capability growth, especially junior productivity
- Execution culture: discipline, accountability, operational maturity
- Clear communication and leadership behaviors

