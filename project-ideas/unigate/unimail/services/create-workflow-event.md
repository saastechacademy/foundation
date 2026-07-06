# `create#WorkflowEvent`

This service interface pushes an event to a provider's automation/workflow system (e.g., triggering a flow in Klaviyo) rather than sending a direct transactional email.

## Interface Definition

**Implements:** `co.hotwax.unigate.ApiInterfaceServices.create#WorkflowEvent`

### Input Parameters

| Parameter | Type | Required | Description |
|---|---|---|---|
| `commGatewayAuthId` | String | Yes | Identifier for the `CommGatewayAuth` record that stores credentials. |
| `emailType` | String | Yes | The event type being triggered. |
| `subject` | String | Yes | The subject or name of the event. |
| `emailAddress` | String | Yes | The recipient/customer's email address associated with the event. |

*Note: Additional contextual data is typically passed or appended based on the provider's specific implementation requirements.*

## Implementation Responsibility

1. **Load Credentials:** Fetch the `CommGatewayAuth` record.
2. **API Call:** Call the provider's event ingestion or workflow trigger API using the provided details.
3. **Error Handling:** Log and handle any provider-specific errors.
