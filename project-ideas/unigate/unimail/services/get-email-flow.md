# `get#EmailFlow`

This service interface retrieves an existing automated email flow from the provider's system to check its status or existence.

## Interface Definition

**Implements:** `co.hotwax.unigate.ApiInterfaceServices.get#EmailFlow`

### Input Parameters

| Parameter | Type | Required | Description |
|---|---|---|---|
| `commGatewayAuthId` | String | Yes | Identifier for the `CommGatewayAuth` record that stores credentials. |
| `subject` | String | Yes | The subject line or name of the flow to search for. |

### Output Parameters

| Parameter | Type | Required | Description |
|---|---|---|---|
| `flowId` | String | No | The provider's identifier for the flow, if found. |

## Implementation Responsibility

1. **Load Credentials:** Fetch the `CommGatewayAuth` record.
2. **API Call:** Query the provider's API for flows matching the provided `subject`/name.
3. **Return:** If a match is found, return the provider's `flowId`.
