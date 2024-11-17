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


## Solution Design: GitHub-Integrated Template Management for Moqui

### Overview

This solution uses GitHub as a central repository for managing and versioning templates, while Moqui dynamically loads these templates from a specific branch (`prod`). This approach offers several benefits:

*   **Runtime Updates:**  Modify templates in production without redeploying Moqui.

*   **Simplified Customization:**  Easily manage client-specific template customizations.

*   **Version Control and Audit:** Leverage Git's inherent version control, audit trails, and collaboration features.

### Key Components

1.  **GitHub Repository for Templates**

    *   **Repository Structure:**

        ```
        templates/
          jolt/
            example1.jolt
            example2.jolt
          freemarker/
            reportTemplate.ftl
            emailTemplate.ftl
        README.md  # Describes template usage and structure
        ```

    *   **Repository Branching Strategy:**

        *   `prod` Branch: Stores production-ready templates.

        *   Feature Branches: Used for editing and testing new templates before merging into `prod`.

    *   **Advantages:**

        *   Simplified collaboration using pull requests.

        *   Built-in version control and rollback.

        *   Branching for testing and experimentation.

2.  **Moqui Service for Template Fetching**

    *   **Service Workflow:**

        1.  Input: Template URI (name).

        2.  Cache Check: Look for the template in Moqui's cache.

        3.  GitHub API Call (if not cached):

            *   Fetch the template from the `prod` branch using the GitHub REST API.

            *   Example Endpoint: `GET https://api.github.com/repos/{owner}/{repo}/contents/templates/{templateName}?ref=prod`

        4.  Decoding and Storage:

            *   Decode the Base64 content from the API response.

            *   Cache the template for future use.

        5.  Output: Return the template content.

    *   **Implementation Example (Groovy):**

        ```groovy
        import org.apache.commons.codec.binary.Base64
        import groovy.json.JsonSlurper
        
        def fetchTemplateFromGitHub(Map context) {
          String templateName = context.templateName
          String owner = "your-github-owner"
          String repo = "your-repo-name"
          String branch = "prod"
        
          String apiUrl = "https://api.github.com/repos/${owner}/${repo}/contents/templates/${templateName}?ref=${branch}"
          def cache = ec.cache.getCache("GitHubTemplates")
        
          // Check cache
          String cachedTemplate = cache.get(apiUrl)
          if (cachedTemplate) return [status: "success", content: cachedTemplate]
        
          try {
            URL url = new URL(apiUrl)
            HttpURLConnection connection = (HttpURLConnection) url.openConnection()
            connection.setRequestMethod("GET")
            connection.setRequestProperty("Authorization", "Bearer YOUR_GITHUB_TOKEN")
            connection.setRequestProperty("Accept", "application/vnd.github.v3+json")
        
            if (connection.responseCode == 200) {
              def response = new JsonSlurper().parse(connection.inputStream)
              String decodedContent = new String(Base64.decodeBase64(response.content), "UTF-8")
              cache.put(apiUrl, decodedContent)
              return [status: "success", content: decodedContent]
            } else {
              return [status: "error", message: "Failed to fetch template: ${connection.responseMessage}"]
            }
          } catch (Exception e) {
            return [status: "error", message: "Exception: ${e.message}"]
          }
        }
        ```

3.  **Caching Strategy**

    *   Cache Key: The GitHub API URL.

    *   Cache Invalidation: Time-based expiration or manual invalidation upon detecting changes in GitHub.

    *   Benefits:

        *   Reduces API calls.

        *   Improves performance and mitigates downtime.

4.  **Security**

    *   Use GitHub Access Tokens (PATs) for API authentication.

    *   Securely store tokens in environment variables or Moqui's Remote configuration.

    *   Restrict GitHub repository access to authorized personnel.

5.  **Template Validation**

    *   Validate templates (JOLT specs and Freemarker templates) using automated tools before pushing to production.

    *   Integrate validation scripts into your CI/CD pipeline.

    *   **Example GitHub Actions Workflow:**

        ```yaml
        name: Validate Templates
        
        on: push
        jobs:
          lint:
            runs-on: ubuntu-latest
            steps:
              - uses: actions/checkout@v3
              - name: Validate JOLT Specs
                run: jolt-linter templates/jolt/*.jolt
              - name: Validate Freemarker Templates
                run: freemarker-linter templates/freemarker/*.ftl
        ```

6.  **Error Handling and Observability**

    *   **Error Handling:**

        *   Provide informative error messages (e.g., template not found, API call failures).

        *   Log all errors for traceability.

    *   **Observability:**

        *   Create a dashboard in Moqui to monitor template usage, fetch failures, and cache status.

### High-Level Architecture

```
[GitHub Repository]
  |
  |---> GitHub REST API (prod branch)
        |
        |---> [Moqui Service]
              |
              |---> Cache Lookup (Fetch or Use Cached Template)
              |
              |---> Application Pipeline
                    |
                    |---> JOLT Transformations
                    |
                    |---> Freemarker Rendering
```

### Advantages

*   Runtime template updates without Moqui redeployment.

*   Built-in audit and traceability via GitHub.

*   Scalability for new templates and schema customizations.

*   Performance enhancement through caching.

*   Ease of use with familiar Git workflows.

### Future Enhancements

*   Branch-based testing using staging or feature branches.

*   A Moqui admin interface for template management (view details, refresh cache).

*   Enhanced validation with robust linting and schema validation tools.

*   CI/CD integration to automate template promotion.


