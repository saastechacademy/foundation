# Role Definition: Engineering Steward

## 1. Role Purpose

The Engineering Steward is a company-level role responsible for protecting long-term code quality, data integrity, and architectural consistency across all client projects.

The primary objective of this role is to ensure that delivery today does not create hidden technical debt that limits the company’s ability to scale, maintain, and grow enterprise value.

This role exists to reduce dependency on ad-hoc founder intervention in delivery and architecture decisions.

---

## 2. Role Scope

The Engineering Steward owns **HOW** solutions are designed and built at HotWax Systems.

Project teams own **WHAT** is built and **WHEN** it is delivered.

---

## 3. Key Responsibilities

### 3.1 Company Engineering Standards

The Engineering Steward is responsible for defining, maintaining, and enforcing company-wide engineering standards, including:

- Approved Apache OFBiz extension and customization patterns
- Approved data model usage and mutation practices
- Clear definition of what constitutes “production-ready” code

These standards are mandatory for all client projects.

---

### 3.2 Architectural Guardrails

The Engineering Steward defines and enforces architectural guardrails, including:

- Allowed implementation patterns
- Disallowed / forbidden patterns
- Rules for exceptions and deviations

Any deviation from approved patterns must be explicitly reviewed and approved by the Engineering Steward.

---

### 3.3 Mandatory Review Checkpoints

The Engineering Steward must review and approve solutions at the following mandatory checkpoints:

1. **Solution Design Review**
   - Conducted before significant development begins
   - Focuses on data model usage, design approach, and architectural alignment

2. **Pre-Production Readiness Review**
   - Conducted before production deployment
   - Focuses on risk, maintainability, data integrity, and rollback safety

Projects may not proceed to production without approval at these checkpoints.

---

### 3.4 Codebase and Data Health

The Engineering Steward is responsible for:

- Identifying emerging technical debt
- Highlighting fragile or risky customizations
- Ensuring consistency in data state transitions and transactional integrity

The Engineering Steward does not implement fixes directly unless explicitly required; responsibility for remediation remains with the project team.

---

### 3.5 Coaching and Capability Building

The Engineering Steward is expected to:

- Explain architectural decisions and trade-offs to teams
- Guide teams toward approved patterns
- Improve overall engineering maturity across the organization

The role is advisory and authoritative, not operational or delivery-focused.

---

## 4. Authority

The Engineering Steward has the authority to:

- Approve or reject solution designs based on company standards
- Block production deployments that violate defined engineering standards
- Require redesign or remediation of non-compliant implementations

This authority is supported by executive leadership and is non-negotiable.

---

## 5. Explicit Exclusions (Out of Scope)

The Engineering Steward does **not** own:

- Project delivery timelines
- Client communication or account management
- Performance management or HR responsibilities
- Day-to-day development task execution

These exclusions are intentional to prevent role conflict and overload.

---

## 6. Decision and Escalation Process

- The project team proposes a solution approach
- The Engineering Steward reviews and discusses the approach
- The Engineering Steward makes a decision based on defined standards
- In case of unresolved disagreement, the decision is escalated to the CEO
- Once a decision is made, it is final and enforced

---

## 7. Success Metrics

The effectiveness of the Engineering Steward will be evaluated based on:

- Reduction in production issues and post-go-live defects
- Consistency of implementation patterns across projects
- Reduced need for executive intervention in delivery and architecture
- Improved maintainability and onboarding efficiency

---

## 8. Time Allocation Guidelines

- 60–70%: Stewardship, reviews, and standards enforcement
- 30–40%: Coaching, advisory support, and continuous improvement

The Engineering Steward should not be fully allocated to project delivery.

---

## 9. Initial 90-Day Charter

**Month 1**
- Define and document core allowed and forbidden patterns
- Establish mandatory review checkpoints

**Month 2**
- Review active projects and identify recurring anti-patterns
- Publish an initial Engineering Playbook

**Month 3**
- Enforce standards consistently
- Refine guardrails based on real-world feedback

---

## 10. Guiding Principle

> Project teams own delivery outcomes.
> The Engineering Steward owns long-term quality and sustainability.

