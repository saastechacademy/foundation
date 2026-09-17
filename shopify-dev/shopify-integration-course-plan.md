# Shopify Integration Training Module

Welcome to the Shopify Integration module! This module is designed as part of the Software Development Engineer (SDE) training program. Through a hands-on, learn-by-doing approach, you will understand the architecture, trade-offs, authentication mechanisms, and integration patterns required to build robust Shopify applications and integrations.

## Training program outline

During the training program, you will:
- Evaluate different Shopify integration options and articulate their trade-offs.
- Understand and implement Shopify's authentication models (OAuth2, Session Tokens, JWT).
- Design and build a scalable integration layer bridging Shopify with an external system.
- Create proper Architecture Decision Records (ADRs).
- Develop comprehensive User Acceptance Testing (UAT) plans for integrations.

**Module 1: Introduction to Shopify Integration & Architecture**
1. [Understanding Integration Types](#1-understanding-integration-types)
2. [API Surface Choices](#2-api-surface-choices)
3. [Event-Driven vs. Polling](#3-event-driven-vs-polling)
4. [Activity: Architecture Discovery & ADR Creation](#4-activity-architecture-discovery--adr-creation)

**Module 2: Authentication & Authorization Deep Dive**
1. [Shopify OAuth2 Flow](#1-shopify-oauth2-flow)
2. [Token Types](#2-token-types)
3. [Identity Integration](#3-identity-integration)
4. [Activity: Postman Authentication Walkthrough](#4-activity-postman-authentication-walkthrough)

**Module 3: Designing the Integration Layer**
1. [Data Sync Strategies](#1-data-sync-strategies)
2. [Event Handling](#2-event-handling)
3. [Error Handling & Resiliency](#3-error-handling--resiliency)
4. [Activity: Integration Flow Design](#4-activity-integration-flow-design)

**Module 4: Execution, Testing, and UAT**
1. [Project Phases](#1-project-phases)
2. [Unit and Integration Testing](#2-unit-and-integration-testing)
3. [User Acceptance Testing (UAT)](#3-user-acceptance-testing-uat)
4. [Activity: UAT Plan and Execution](#4-activity-uat-plan-and-execution)

**Module 5: Operational Concerns & Polish (Optional)**
1. [UI/UX Standards](#1-uiux-standards)
2. [Data Modeling](#2-data-modeling)
3. [Observability](#3-observability)
4. [Activity: Dashboard Implementation](#4-activity-dashboard-implementation)

---

## Module 1: Introduction to Shopify Integration & Architecture

### 1. Understanding Integration Types
- Public vs. Custom vs. Private/Internal apps. 
- Embedded vs. Standalone apps.
- Shopify App Bridge and Polaris UI overview.

### 2. API Surface Choices
- Admin API (REST vs. GraphQL) vs. Storefront API.
- Evaluating latency, complexity, and rate-limit constraints across API options.

### 3. Event-Driven vs. Polling
- Webhooks vs. Scheduled jobs.

### 4. Activity: Architecture Discovery & ADR Creation
1. **Define the Integration:** Write a short design document specifying what kind of Shopify integration you are building and why.
2. **Trade-off Analysis:** Create a comparison table for REST Admin API vs. GraphQL Admin API based on your specific use case.
3. **ADR Submission:** Write an Architecture Decision Record (ADR) detailing your choice between building an Embedded app vs. a Standalone app.

---

## Module 2: Authentication & Authorization Deep Dive

### 1. Shopify OAuth2 Flow
- The Authorization Code flow for apps.
- App installation callbacks and handshakes.
- Scopes and permissions (Principle of Least Privilege).

### 2. Token Types
- Offline (permanent) tokens vs. Session tokens (JWT).
- JWT structure and validation within the Shopify ecosystem.

### 3. Identity Integration
- SSO, SAML, and when to use them versus Shopify's native authentication.

### 4. Activity: Postman Authentication Walkthrough
1. **OAuth Flow Implementation:** Implement a mock OAuth callback endpoint that exchanges an authorization code for an access token.
2. **Postman Collection:** Create a Postman collection that:
   - Contains the `/oauth/authorize` URL.
   - Executes the `/oauth/access_token` request.
   - Makes an Admin API call (e.g., fetching shop details) using the acquired token.
3. **Negative Testing:** Document API responses for unauthorized calls (missing token, invalid scope, expired token) and outline how your app handles them.

---

## Module 3: Designing the Integration Layer

### 1. Data Sync Strategies
- Unidirectional vs. Bidirectional synchronization. 
- Entity mapping (Orders, Products, Inventory).

### 2. Event Handling
- Webhooks setup, HMAC verification, idempotency, and retry mechanisms.
- Security best practices: Webhook cryptographic validation.

### 3. Error Handling & Resiliency
- Managing rate limits (HTTP 429) and exponential backoff strategies.
- Background worker architectures for high-volume data sync.

### 4. Activity: Integration Flow Design
1. **Sequence Diagram:** Create a sequence diagram mapping out an end-to-end flow (e.g., "Order created in Shopify -> Webhook -> Integration Layer -> External ERP updated").
2. **Webhook HMAC Implementation:** Write a code snippet or middleware that verifies the HMAC signature of an incoming Shopify webhook payload.
3. **Negotiables vs. Non-Negotiables:** Document your project's non-negotiable security constraints (e.g., HMAC verification, secure token storage) versus negotiable technical choices.

---

## Module 4: Execution, Testing, and UAT

### 1. Project Phases
- Discovery -> PoC -> Build -> Testing -> Launch.

### 2. Unit and Integration Testing
- Mocking API clients and testing data mappers.

### 3. User Acceptance Testing (UAT)
- End-to-end verification and environment staging.
- Simulating edge cases (app uninstalls/reinstalls).
- Session expiration and token refresh handling.

### 4. Activity: UAT Plan and Execution
1. **Dev Store Setup:** Create a Shopify Developer store and generate a starter app using the Shopify CLI.
2. **UAT Checklist Creation:** Create a detailed UAT checklist covering:
   - **Installation Flow:** Scopes validation, smooth app loading in the Admin portal.
   - **Auth Edge Cases:** Reinstalling after uninstall, behavior upon session expiry.
   - **Core Business Flow:** Verifying product creation or order fulfillment sync delays between systems.
   - **Resiliency:** Simulating a rate limit response and verifying backoff logic kicks in.
3. **Execution Evidence:** Submit markdown documentation containing logs and screenshots as evidence of successful UAT execution.

---

## Module 5: Operational Concerns & Polish (Optional)

### 1. UI/UX Standards
- Utilizing the Polaris design system and adhering to "Built for Shopify" standards.

### 2. Data Modeling
- Using Metafields vs. local database storage for custom attributes.

### 3. Observability
- Logging, monitoring API failures, and tracking webhook processing times.

### 4. Activity: Dashboard Implementation
1. **Admin UI:** If building an embedded app, create a simple homepage using Polaris React components that displays:
   - Current connection status ("Connected to Shop X").
   - Last synchronization status and timestamp.
   - Recent error logs (if any).

---

## Repository Structure Guideline

For this module, learners should structure their project repository as follows to ensure a clean, reviewable submission:

```text
shopify-integration-module/
  README.md                     # High-level overview & how to run the project
  docs/
    01-architecture-options.md  # API choices, embedded vs standalone discussion
    02-auth-and-security.md     # OAuth2, JWT flows, and security guidelines
    03-integration-layer.md     # Sequence diagrams, data mapping, rate limits
    04-testing-and-uat.md       # Test cases, UAT scenarios, and execution logs
  adr/
    ADR-001-api-surface.md      # Record of API decision
    ADR-002-app-form-factor.md  # Record of embedded vs standalone decision
  postman/
    ShopifyIntegration.postman_collection.json # Exported Postman collection
  app/
    backend/                    # Your app server (OAuth, webhooks, API logic)
    frontend/                   # Admin-embedded UI (Polaris components)
```
