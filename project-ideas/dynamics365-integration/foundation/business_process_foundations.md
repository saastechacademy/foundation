# Dynamics 365 Business Process Foundations

This document captures the generic business-process concepts and system setup assumptions that apply across D365 F&O integration flows.

## 1. Foundational Concepts & System Setup

Before records can be synchronized, the foundational structural context must be established in Dynamics 365.

### 1.1 Multi-Company Structure (dataAreaId) & Legal Entities
- **dataAreaId**: Represents the Legal Entity (Company).
- **System Bucket**: Every table in D365 is partitioned by this "Company Code." It defines the context for all validation and financial posting.
- **Organization Administration**: Legal entities are managed under the Organization Administration module.
- **Validation**: Fields like Customer group, currency, and posting profiles are validated within the specific company context.

- **Reference**: [Organization administration home page](https://learn.microsoft.com/en-us/dynamics365/fin-ops-core/fin-ops/organization-administration/organization-administration-home-page?context=%2Fdynamics365%2Fcontext%2Ffinance)

### 1.2 Architectural Concept: The Party Model
- **Concept**: A Customer is built on top of a **Party** record in the Global Address Book.
- **Types**: Person and Organization are types of Party.
- **Global Scope**: Parties are global across all legal entities, whereas Customers are specific to a `dataAreaId`.

### 1.3 Number Sequences & Identification
Number sequences are used in D365 to generate unique identifiers for entities like Customers and Sales Orders. The generation of identifiers such as `CustomerAccount` is company-specific and controlled by D365 configuration.

- **Reference**: [Number sequences overview](https://learn.microsoft.com/en-us/dynamics365/fin-ops-core/fin-ops/organization-administration/number-sequence-overview?toc=%2Fdynamics365%2Fretail%2Ftoc.json)

#### 1.3.1 Verifying Configuration
To check the sequence in a specific legal entity (for example `USMF`):
1. Navigate to `Accounts receivable > Setup > Accounts receivable parameters > Number sequences tab`.
2. Find the `Customer account` reference to identify the assigned number sequence code.
3. Review:
   - **Scope**: typically **Company**
   - **Manual**:
     - **Yes**: caller must provide the identifier
     - **No**: D365 auto-generates the identifier
   - **Format**: configured numbering pattern

#### 1.3.2 Impact on Integration
The **Manual** flag directly affects API behavior during record creation:

| Manual Setting | API Behavior |
| :--- | :--- |
| **Yes** | Identifier must be provided in the payload. |
| **No** | Identifier is auto-generated; caller-provided values are ignored or rejected. |

> [!IMPORTANT]
> If `Manual = Yes` and the identifier is missing, the API rejects the request.

#### 1.3.3 Recommended Strategy
For a system-of-record style integration, the preferred configuration is:
- **Scope**: Company
- **Manual**: No (auto-generate)
- **Continuous**: No, unless legally required

#### 1.3.4 Dev Environment & Initial Phase
> [!NOTE]
> The current connector implementations may still assume caller-provided identifiers in some flows during exploration and early rollout.
>
> **TODO:** Re-evaluate each flow if the target D365 environments move to auto-generated numbering.
