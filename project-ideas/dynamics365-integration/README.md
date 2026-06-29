# Dynamics 365 Finance & Operations Integration

This repository serves as a central research and design hub for the integration between HotWax OMS and Microsoft Dynamics 365 Finance & Operations (D365 F&O).

## Overview
The goal of this integration is to synchronize critical business data, specifically Customers, Sales Orders and Returns, to enable seamless financial and supply chain operations in Dynamics 365.

## Documentation Flow

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
1.  **[D365 Return & Exchange Accounting Model](sales-returns/d365_return_exchange_accounting_model.md)**
    *   Conceptual model for how return, exchange, and settlement scenarios are modeled in D365 using accounting principles.
2.  **[OMS to D365 Return Sync — Implementation Plan](sales-returns/oms_to_d365_return_sync_implementation_plan.md)**
    *   Technical implementation plan for syncing completed returns from OMS to D365, covering entity design, data feed configuration, service wrappers, and field mappings.

### Data Packages
1.  **[Data Export Package API](data-package-api/data_export_package_api.md)**
    *   Documentation and APIs for pushing DMF packages to D365.
2.  **[Data Import Package API](data-package-api/data_import_package_api.md)**
    *   Documentation and APIs for polling DMF export packages from D365.
3.  **[Updating Field Mappings in an Existing Data Project](data-package-api/data_project_field_mapping_update.md)**
    *   Step-by-step procedure for updating a D365 data project when a new field is added to a feed, including the correct Load project → Upload file → Regenerate mapping flow.
