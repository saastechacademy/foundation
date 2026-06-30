# Dynamics 365 Finance & Operations Integration

This repository serves as a central research and design hub for the integration between HotWax OMS and Microsoft Dynamics 365 Finance & Operations (D365 F&O).

## Overview
The goal of this integration is to synchronize critical business data, specifically Customers, Sales Orders and Returns, to enable seamless financial and supply chain operations in Dynamics 365.

## Documentation Flow

### Foundation
1.  **[Business Process Foundations](foundation/business_process_foundations.md)**
    *   Core D365 concepts that apply across all flows: multi-company structure (`dataAreaId`), the Party model, and number sequences.
2.  **[Connector Foundation](foundation/connector_foundation.md)**
    *   OMS-side connector patterns: credentials storage, OAuth token management, OData client, and metadata reference.
3.  **[D365 SysOperation Framework](foundation/d365_sysoperation_framework.md)**
    *   The Microsoft-standard three-class pattern (Contract / Service / Controller) used for all custom D365-side batch and periodic operations, with examples from this integration.

### Sales Orders
1.  **[Business Processes](sales-orders/business_processes.md)**
    *   High-level business flows and requirements for Customer and Order management.
2.  **[Integration Methodologies](sales-orders/integration_methodologies.md)**
    *   Technical research on available D365 integration patterns (OData, DIXF, Business Events).
3.  **[Implementation Plan](sales-orders/implementation_plan.md)**
    *   Specific technical design, sequence flows, and step-by-step roadmap for development.
4.  **[Shipment Export Exploration](sales-orders/shipment_export_exploration.md)**
    *   Exploration notes for outbound shipment synchronization patterns from D365 to OMS.
5.  **[Invoice Settlement & Customer Payment Integration](sales-orders/invoice_settlement.md)**
    *   Full lifecycle from payment journal creation through invoice posting and settlement, including explored approaches, verified behaviors, use cases, and open items.

### Sales Returns
1.  **[Business Processes](sales-returns/business_processes.md)**
    *   D365 return lifecycle (physical return and credit-only paths), disposition codes, OMS return type mapping, and the return/exchange accounting model.
2.  **[Implementation Plan](sales-returns/implementation_plan.md)**
    *   OData approach selection, service architecture, field mappings, arrival journal DMF sync, and phased verification plan.

### Data Packages
1.  **[Data Export Package API](data-package-api/data_export_package_api.md)**
    *   Documentation and APIs for pushing DMF packages to D365.
2.  **[Data Import Package API](data-package-api/data_import_package_api.md)**
    *   Documentation and APIs for polling DMF export packages from D365.
3.  **[Updating Field Mappings in an Existing Data Project](data-package-api/data_project_field_mapping_update.md)**
    *   Step-by-step procedure for updating a D365 data project when a new field is added to a feed, including the correct Load project → Upload file → Regenerate mapping flow.
