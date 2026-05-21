# Shipment Export from D365 to OMS - Exploration Notes

## Objective
Evaluate outbound shipment integration options from D365 to OMS, with a specific requirement to synchronize only shipment lines fulfilled through D365/WMS flows.

## Requirement Context
- Shipment data needs to include packing slip header, lines, and tracking information.
- OMS-fulfilled lines should be excluded from outbound synchronization.
- A single export run may contain multiple shipments.

## Approaches Explored

### 1. Business Event -> Logic App
- D365 emits a business/data event on shipment-related process completion.
- Logic App receives the event and forwards/transforms data for OMS.
- Result: Validated as technically feasible in POC.

### 2. Business Event -> Azure Service Bus Queue -> Azure Function
- D365 emits event to Service Bus endpoint.
- Azure Function consumes queued messages and performs transformation/routing.
- Result: Validated as technically feasible in POC.

### 3. Custom Flat Entity -> DMF Recurring Export -> Azure Function
- A custom export entity combines:
  - `CustPackingSlipJourBiEntities` (header)
  - `CustPackingSlipTransBiEntities` (line)
  - `PackingSlipTrackingInformation` (tracking/carrier)
- Export runs through DMF recurring integration as tabular output.
- Azure Function polls recurring integration (`dequeue`), processes package rows, groups by shipment key (for example `packingSlipId`), builds OMS nested shipment JSON, then calls `ack`.
- Result: Selected exploration direction for line-level filtering and export-side data shaping.

## Key Technical Observations

### DMF Payload Shape
DMF exports tabular records. Nested shipment JSON (`items[]`) must be assembled in middleware.

### Grouping Responsibility
Grouping is performed in Azure Function (or equivalent middleware), not in DMF entity export output.

### Recurring Integration Behavior
- Recurring jobs run on schedule and produce export packages.
- Middleware must poll dequeue APIs on its own schedule (typically timer-triggered function).
- After successful processing, middleware acknowledges the package to prevent reprocessing.

## Decision Drivers for Final Selection
- Ability to enforce D365/WMS-only line filtering.
- Payload completeness in one extraction model.
- Transformation complexity outside D365.
- Operational reliability (retry, idempotency, backlog handling).
- Long-term maintainability.

## Related References
- GitHub Issue: https://github.com/hotwax/hotwax-d365/issues/51
- Business process reference: [business_processes.md](/Users/gurveenkaur/Documents/Work/git/oms/moqui-framework/runtime/component/foundation/project-ideas/dynamics365-integration/sales-orders/business_processes.md)
- Integration methodology reference: [integration_methodologies.md](/Users/gurveenkaur/Documents/Work/git/oms/moqui-framework/runtime/component/foundation/project-ideas/dynamics365-integration/sales-orders/integration_methodologies.md)
