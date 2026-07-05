# Adding a New Email Gateway to UniMail

This guide walks through integrating a new email provider into UniMail. The integration pattern is consistent across all providers — you implement two things (a service and a template), then register one database record.

---

## The Pattern

UniMail's routing layer (`CommunicationServices`) delegates to provider implementations through a database-configured service name. To add a new provider, you need to:

1. Implement the service interface
2. Create the FreeMarker request template(s)
3. Register the provider in `CommGatewayConfig`
4. Create a `CommGatewayAuth` record for each tenant using it

No changes to the routing layer (`CommunicationServices.xml`) are needed.

---

## Step 1 — Implement the Service

Create `service/co/hotwax/communication/{provider}/{ProviderName}Services.xml`. At minimum, implement `send#EmailCommunication`. Implement `create#WorkflowEvent`, `create#EmailFlow`, and `get#EmailFlow` only if your provider supports them.

### Required Implementations

1. **Send Email Service (Required)**
   - **Implements:** `co.hotwax.unigate.ApiInterfaceServices.send#EmailCommunication`
   - **Detailed Design:** See [sendEmailCommunication](./services/send-email-communication.md)
   - **Responsibility:** Load auth credentials from `CommGatewayAuth`, render the FreeMarker template, call the provider API to dispatch the email, and return the response.

2. **Create Email Flow (Optional)**
   - **Implements:** `co.hotwax.unigate.ApiInterfaceServices.create#EmailFlow`
   - **Detailed Design:** See [createEmailFlow](./services/create-email-flow.md)
   - **Responsibility:** Provision an automated email flow in the provider's system.

3. **Get Email Flow (Optional)**
   - **Implements:** `co.hotwax.unigate.ApiInterfaceServices.get#EmailFlow`
   - **Detailed Design:** See [getEmailFlow](./services/get-email-flow.md)
   - **Responsibility:** Retrieve an existing automated email flow from the provider to check its status.

4. **Create Workflow Event (Optional)**
   - **Implements:** `co.hotwax.unigate.ApiInterfaceServices.create#WorkflowEvent`
   - **Detailed Design:** See [createWorkflowEvent](./services/create-workflow-event.md)
   - **Responsibility:** Push a custom event to trigger workflows/automations in the provider's system (e.g., Klaviyo events).

**Key things to match from existing providers:**

- Always load `CommGatewayAuth` via `commGatewayAuthId` (passed in context by the router)
- The `response` and `requestBody` out-parameters are defined in the interface — populate both
- Use `commGatewayAuth.baseUrl` for the endpoint base — never hardcode URLs
- Use `commGatewayAuth.authHeaderName` + `commGatewayAuth.publicKey` / `apiKey` for auth — these are what the tenant configures

---

## Step 2 — Create the FreeMarker Template

Create `template/{provider}/SendEmailTemplate.ftl`. The template receives the full service context, including `messageData`, `emailAddress`, `emailType`, and `subject`.

```freemarker
<#-- template/{provider}/SendEmailTemplate.ftl -->
<@compress single_line=true>
{
    "to": "${emailAddress!}",
    "subject": "${subject!}",
    "template_id": "${emailType!}",
    "personalizations": [{
        "to": [{"email": "${emailAddress!}"}],
        "dynamic_template_data": {
            "firstName": "${messageData.firstName!}",
            "orderId": "${messageData.orderId!}",
            "items": [
            <#list messageData.items![] as item>
                {
                    "name": "${item.productName!}",
                    "qty": ${item.quantity!0},
                    "price": ${item.unitPrice!0}
                }<#sep>,</#sep>
            </#list>
            ]
        }
    }]
}
</@compress>
```

Look at `template/mayur/SendBOPISEmailTemplate.ftl` for a complete real-world example of how `messageData` fields are accessed.

---

## Step 3 — Register in CommGatewayConfig

Insert a `CommGatewayConfig` record. This is typically done via seed data or the admin UI:

```xml
<!-- In your component's data/SeedData.xml or via admin UI -->
<co.hotwax.unigate.CommGatewayConfig
    commGatewayConfigId="MY_PROVIDER"
    description="My Email Provider"
    sendEmailServiceName="co.hotwax.communication.myprovider.MyProviderServices.send#EmailCommunication"
    createEventServiceName=""
    createFlowServiceName=""
    getFlowServiceName=""/>
```

Or as SQL if seeding directly:

```sql
INSERT INTO COMM_GATEWAY_CONFIG (
    COMM_GATEWAY_CONFIG_ID, DESCRIPTION, SEND_EMAIL_SERVICE_NAME
) VALUES (
    'MY_PROVIDER',
    'My Email Provider',
    'co.hotwax.communication.myprovider.MyProviderServices.send#EmailCommunication'
);
```

Only populate the service name fields for operations you actually implement. Leave the rest null — the routing layer checks for null before calling.

---

## Step 4 — Create CommGatewayAuth for the Tenant

Each tenant using this provider needs a `CommGatewayAuth` record:

```json
POST /rest/s1/unigate/commGatewayAuth
{
  "tenantPartyId": "TENANT_001",
  "commGatewayConfigId": "MY_PROVIDER",
  "authTypeEnumId": "ApiKeyHeader",
  "baseUrl": "https://api.myprovider.com",
  "authHeaderName": "X-Api-Key",
  "apiKey": "tenant-api-key-here",
  "modeEnumId": "Production",
  "description": "Tenant 001 - My Provider production"
}
```

The returned `commGatewayAuthId` is what the tenant will pass in the `commGatewayAuthId` field of their API calls.

---

## Provider Checklist

Before considering an integration complete:

- [ ] Service implements `co.hotwax.unigate.ApiInterfaceServices.send#EmailCommunication`
- [ ] Service reads `commGatewayAuth.baseUrl` and does not hardcode any URLs
- [ ] Auth header is driven by `commGatewayAuth.authHeaderName` / `apiKey` / `publicKey`
- [ ] FreeMarker template renders valid JSON for the provider
- [ ] `CommGatewayConfig` record created with correct service name
- [ ] At least one `CommGatewayAuth` provisioned for a test tenant
- [ ] End-to-end test: call `send#EmailCommunication` via the REST API and verify the provider receives the payload

---

## Related Documents

- [UniMail README](./README.md) — how routing and the existing Mayur integration work
- [CommGatewayAuth entity](../entity/CommGatewayAuth.md) — full field reference for auth config
- [ApiInterfaceServices](../../service/co/hotwax/unigate/ApiInterfaceServices.xml) — the interface contract your service must implement
