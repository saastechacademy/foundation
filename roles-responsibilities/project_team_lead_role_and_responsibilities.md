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

### 7) AI in development enablement
- Run one weekly team session on use of AI in development.
- Get team members to share how they used AI during the week, what worked, what failed, and what they learned.
- Lead the discussion so the team learns from each other’s experience.
- At the end of the session, document a few best practices the team agrees to follow.
- Also define 1 or 2 experiments the team will try in the next week.
- In the next session, review what happened and decide what to continue, change, or stop.

### 8) Team culture and work discipline
- Build a culture of punctuality, focus, and full productive workdays.
- Ensure the team follows office schedule expectations and avoids “late start” normalization.
- When performance is weak, first verify fundamentals: attendance, consistency, communication, planning discipline.

### 9) Communication and storytelling (twice monthly minimum)
At the end of each sprint (at least twice a month), communicate the “life of the team/project”:
- Achievements and learnings
- Major client problems solved (business process / UX / operations)
- Challenges and how they were addressed
- Customer reality: operational stories, constraints, insights

Share this with:
- Account/PM (if present)
- Marketing team (for newsletter and content roadmap inputs)

---

## Time allocation model (OFBiz is treated as a second project)

In addition to owning a client project, Team Leads are expected to treat **Apache OFBiz community contribution** as a focused, timeboxed “second project.” This strengthens individual expertise.

**Recommended weekly allocation (guideline):**

* **50% Primary client project:** delivery governance, key decisions, design/reviews, risk management, client technical leadership
* **25% OFBiz:** community outputs (answers/docs/patches/write-ups) planned on a small backlog
* **25% Enablement:** mentoring juniors, improving team standards, running weekly AI-in-development sessions, and capturing best practices and experiments

---

## Required Leadership Outputs
The Team Lead must maintain a small set of visible working outputs that show planning, review, coaching, and improvement are happening regularly.

### 1) Sprint Planning and Tracking
- Keep a sprint plan for every sprint.
- List the work items the team committed to deliver in that sprint.
- For each item, record owner, status, and blocker, if any.
- Mark items that are at risk of missing the sprint.
- Review and update the sprint plan during the sprint.

**Minimum fields:**
- work item
- owner
- status
- blocker
- risk

### 2) Project Risk Management
- Keep a project risk log and update it every week.
- Add new risks as soon as they are identified.
- For each risk, record impact, action, owner, and status.
- Review open risks every week and update actions and status.
- Escalate risks early if they may affect scope, timeline, or quality.

**Minimum fields:**
- risk
- impact
- action
- owner
- status

### 3) Design Notes for Important Changes
- Write design notes before development starts for important changes.
- Use design notes for workflow changes, data model changes, integration changes, and other non-trivial work.
- Keep the design note simple and focused on the change being made.
- Review the design note with the team when the change affects multiple people or modules.
- Update the design note if the approach changes during implementation.

**Minimum fields:**
- problem
- proposed approach
- affected workflow or modules
- affected data or entities
- key decisions or assumptions

### 4) Pull Request Review
- Review pull requests for important changes before they are merged.
- Give clear review comments when code needs correction, simplification, or better design.
- Check that the change matches the agreed approach and does not create unnecessary technical debt.
- Check that verification and test thinking are included where needed.
- Do not approve changes that are unclear, risky, or poorly understood.

**Review should check:**
- correctness
- design
- readability
- testability
- alignment with team standards

### 5) Junior Developer Coaching
- Keep short coaching notes for each junior developer.
- Update the notes regularly based on code reviews, design discussions, and delivery work.
- Record the junior’s current growth area, recent feedback, and next improvement step.
- Use the notes to track whether the junior is becoming more independent over time.
- Review progress with the junior regularly.

**Minimum fields:**
- junior name
- current growth area
- recent feedback
- next step

### 6) Post-release Review
- Write a short post-release review after major releases.
- Record what was released, what went well, and what problems were seen.
- Capture follow-up actions needed to fix issues or improve future releases.
- Share the review with the team when the release has important learnings.
- Use the review to improve release quality and team practices.

**Minimum fields:**
- release or change
- what went well
- issues seen
- follow-up action

### 7) Monthly Team Improvement
- Choose 1 or 2 team improvement actions each month.
- Write down why each improvement was chosen.
- Assign an owner for each improvement action.
- Review progress during the month.
- At month end, mark each action as completed, continued, or dropped.

**Minimum fields:**
- improvement action
- reason
- owner
- status

---

## What the Team Lead is evaluated on
- Predictable delivery and client outcomes
- Quality: defects, rework, support stability
- Design discipline: quality of design artifacts and clarity of thinking
- Team capability growth, especially junior productivity
- Execution culture: discipline, accountability, operational maturity
- Clear communication and leadership behaviors
