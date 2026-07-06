# `create#EmailFlow`

This service interface provisions an automated email flow (like a campaign or automated journey) in the provider's system (e.g., Klaviyo).

## Interface Definition

**Implements:** `co.hotwax.unigate.ApiInterfaceServices.create#EmailFlow`

### Input Parameters

| Parameter | Type | Required | Description |
|---|---|---|---|
| `commGatewayAuthId` | String | Yes | Identifier for the `CommGatewayAuth` record that stores credentials. |
| `emailType` | String | Yes | The type of email/event triggering the flow. |
| `subject` | String | Yes | The subject line for emails within the flow. |
| `fromAddress` | String | Yes | The sender's email address. |
| `fromLabel` | String | No | The sender's display name. |
| `htmlTemplate` | String | No | The HTML template body. |
| `textTemplate` | String | No | The plaintext template body. |

### Output Parameters

| Parameter | Type | Required | Description |
|---|---|---|---|
| `flowId` | String | No | The provider's generated identifier for the created flow. |
| `message` | String | No | Status or error message from the provider. |

## Implementation Responsibility

1. **Load Credentials:** Fetch the `CommGatewayAuth` record.
2. **Transform:** Map the input parameters into the provider's flow/campaign creation schema.
3. **API Call:** Invoke the provider's flow creation endpoint.
4. **Return:** Extract and return the provider's `flowId`.
