# D365 SysOperation Framework

This document explains the SysOperation Framework — the Microsoft-standard pattern used to build all custom D365-side batch and periodic operations in this integration.

- **Official Reference**: [SysOperation Framework Overview](https://learn.microsoft.com/en-us/dynamicsax-2012/developer/sysoperation-framework-overview)

---

## What It Is

The SysOperation Framework is Microsoft's recommended approach for creating batch and periodic operations in D365 F&O. It replaced the older `RunBase` framework and is the standard pattern across both standard D365 application code and custom extensions.

It is used whenever a D365-side operation needs to:
- Accept user-configurable parameters
- Run interactively (with a dialog) or as a scheduled batch job without code changes
- Process records in bulk with transaction safety and error reporting

---

## The Three-Class Structure

Every SysOperation operation is built from three classes with clearly separated responsibilities.

### Contract (`@DataContractAttribute`)

The serializable parameter bag. Each field is annotated with `@DataMemberAttribute`, which tells the framework to include it in the dialog and serialize it for batch transport.

Two things follow from this:
- **The dialog is auto-generated** — D365 builds the user input dialog directly from the contract fields. No separate UI code is needed.
- **Parameters must be serializable** — because when a job is sent to the batch server, the contract is serialized and reconstructed on a different thread. Primitive types (`int`, `str`, `boolean`) and D365 extended data types satisfy this automatically.

### Service

A plain X++ class containing the business logic. It receives the contract as a method parameter and does the work. There is no required base class — it is just a regular class.

Because the service has no framework coupling, it can be:
- Called directly from other X++ code without going through a dialog
- Tested in isolation
- Replaced or extended without touching the controller or contract

### Controller (`SysOperationServiceController`)

The orchestrator. It extends `SysOperationServiceController` and in its constructor declares which service class and method to call. It handles:
- Displaying the dialog to the user
- Setting execution mode: `Synchronous` (runs immediately, blocking) or `Asynchronous` / `Scheduled` (routes to the batch server)
- The `main(Args _args)` static method, which is what menu items and batch job configurations call as the entry point

---

## Implemented Operations in This Integration

| Operation | Service Class | Default Parameters | What it does |
| :--- | :--- | :--- | :--- |
| Auto-post arrival journals | `HotWaxAutoPostArrivalJournalService` | `JournalNameId = RTN_ARR`, `MaxJournals = 50` | Queries unposted Reception (`WMSJournalType::Reception`) journals matching the configured journal name and posts each one using `WMSJournalCheckPostReception`. Commits per journal; reports total success and failure counts. |
| Auto-post settlement | `HotWaxAutoPostSettlementService` | — | Matches and settles posted customer payments against posted invoices using `SalesOrderNumber` as the key (via `PaymReference = SalesId`). Implements the custom settlement logic required because D365 OOTB settlement uses FIFO by customer and ignores the payment reference field. |
| Test payment journal | `HotWaxTestPaymentJournalService` | — | Test and debug utility for customer payment journal posting. Not used in production flows. |

> [!NOTE]
> All three operations are accessible from **System Administration → Periodic** in the D365 UI, registered via the `SystemAdministration.HotWaxD365Integration.xml` menu extension.

---

## Related Docs

- [connector_foundation.md](./connector_foundation.md) — OMS-side connector patterns: credentials, token management, and OData client.
- [business_process_foundations.md](./business_process_foundations.md) — D365 foundational concepts: multi-company structure, the Party model, and number sequences.
- [dynamics365-integration architecture.md](../../../../dynamics365-integration/docs/architecture.md) — High-level overview of all D365-side architectural patterns including model isolation and OData entity usage.
