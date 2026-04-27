# Dynamics 365 Finance & Operations Integration

This repository serves as a central research and design hub for the integration between HotWax OMS and Microsoft Dynamics 365 Finance & Operations (D365 F&O).

## Overview
The goal of this integration is to synchronize critical business data, specifically Customers and Sales Orders, to enable seamless financial and supply chain operations.

## Documentation Flow

### Sales Orders
1.  **[Business Processes](sales-orders/business_processes.md)**
    *   High-level business flows and requirements for Customer and Order management.
2.  **[Integration Methodologies](sales-orders/integration_methodologies.md)**
    *   Technical research on available D365 integration patterns (OData, DIXF, Business Events).
3.  **[Implementation Plan](sales-orders/implementation_plan.md)**
    *   Specific technical design, sequence flows, and step-by-step roadmap for development.

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
