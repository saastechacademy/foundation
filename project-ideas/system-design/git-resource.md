# Problem Statement: GitHub-Integrated Template Management for Moqui

## Current Situation

We currently use **Freemarker templates** within our **Moqui applications** to generate data outputs in desired formats. These templates are essential for integration pipelines such as the **getOrder API for NetSuite**, which transforms data into a schema that matches NetSuite's requirements. However, we face several challenges related to how these templates are managed and deployed.

---

## Challenges

### 1. Client-Specific Customization
- **NetSuite Integration**:
    - Each client's NetSuite setup varies based on factors like product definitions, organizational structures, inventory management, and fulfillment processes.
    - These variations lead to slight differences in the required data schema, necessitating frequent customization of the output format.
- The pipeline for transforming data must be flexible to accommodate these schema differences.

### 2. Dependency on Moqui Deployment
- Templates are currently managed as part of the Moqui deployment package.
- Any update to a Freemarker or JOLT template requires:
    - **Rebuilding** the Moqui deployment.
    - **Redeploying** the updated instance.
- This process introduces downtime, delays in addressing client-specific requirements, and operational inefficiencies.

### 3. Integration Workflow Complexity
- Data transformation pipelines rely on a combination of:
    - **Freemarker Templates**: For rendering data into specific formats.
    - **JOLT Specifications**: For JSON transformations.
- Managing these template files as part of the application increases operational overhead and reduces agility.

### 4. Limited Support for Runtime Updates
- Currently, it is not possible to update templates dynamically in production without deploying a new instance.
- This limitation slows down issue resolution and customization for production clients.

### 5. Existing Alternatives Evaluated
- **DbResource**: Storing templates in the database adds management complexity and requires custom solutions for audit and version control.
- **JCR Jackrabbit**: A content repository approach adds significant learning overhead, resource requirements, and infrastructure complexity.
- Both solutions are more resource-intensive than desired for our needs.

---

## Goal

We aim to implement a solution that:

1. **Eliminates the Need for Redeployment**:
    - Allows templates to be updated in production without requiring a redeployment of Moqui.
2. **Supports Customization and Agility**:
    - Enables flexible and reliable customization of data output and ingestion pipelines for client-specific needs.
3. **Minimizes Complexity**:
    - Avoids introducing significant overhead in terms of infrastructure, learning curves, or resource consumption.
4. **Provides Audit and Controls**:
    - Ensures templates are versioned, traceable, and securely managed.

---

## Proposed Solution

We propose using **Git as the repository for managing templates**, integrating it with the Moqui platform to:

1. Load templates dynamically from a **named branch** (e.g., `prod`) in the Git repository.
2. Enable the **Production Support Team** to:
    - Edit, test, and promote templates directly within Git workflows.
    - Use Git's native version control and collaboration features to maintain auditability and ensure control over changes.
3. Ensure the **Moqui application** always reads templates from the `prod` branch at runtime, eliminating the need for redeployment.

---

## Advantages of This Approach

### 1. Minimal Learning Path
- Teams already familiar with Git will find it easy to adopt this approach.
- No need to learn new tools or complex infrastructure like JCR.

### 2. Least Resource Intensive
- Leverages existing Git infrastructure, avoiding the need for additional servers or databases.

### 3. Dynamic Updates
- Templates can be updated and tested in real time, improving agility and reducing downtime.

### 4. Audit and Controls
- Git’s version control provides built-in audit logs, branch-based workflows, and traceability for template changes.

---

By implementing this approach, we align with the goals of making our platform agile, scalable, and easy to maintain while supporting the varied requirements of client-specific NetSuite integrations. This strategy minimizes operational inefficiencies and enhances our ability to respond to client needs promptly.