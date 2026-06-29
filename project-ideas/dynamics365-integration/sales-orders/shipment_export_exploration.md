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

## POC Implementation Details (Custom Flat Entity)
A proof of concept (POC) was completed to implement the custom flat export entity (`OmsPackingSlipExportEntity`) using a view-backed data entity approach in D365 SCM.

### D365 SCM Implementation Steps:
1. **Query Prototyping (`OmsPackingSlipExportQuery`)**:
   - Modeled and validated required joins and filtering using an AOT query.
   - Hierarchy:
     ```text
     CustPackingSlipTrans (Root)
      ├─ CustPackingSlipJour
      ├─ SalesLine
      │   └─ InventDim
      └─ SalesPackingSlipTrackingInformation
     ```
   - Filter enforced: `SalesLine.HcFulfillmentType = WMS` to exclude OMS-fulfilled lines.
2. **Flattened Custom View (`OmsPackingSlipExportView`)**:
   - Replicated the query's datasource and join structure into a read-only View.
   - Selected specific fields mapped from the joined datasources:
     * `PackingSlipId`, `SalesId`, `InventoryLotId` (InventTransId), `Quantity`, `ShipmentMethod`, `ExternalFacilityId`, `HcFulfillmentType`, and `TrackingNumber`.
3. **Data Entity Creation Workaround (`OmsPackingSlipExportEntity`)**:
   - Created the entity using the wizard pointing to `CustTable` first (as views cannot be selected directly in the wizard).
   - Replaced primary datasource with `OmsPackingSlipExportView`.
   - Updated the Entity Key to use `PackingSlipId`, `SalesId`, and `InventoryLotId` for stable row identification.
   - Map-linked fields, regenerated the staging table (`OmsPackingSlipExportStaging`), and updated staging `TitleField` properties to resolve diagnostic errors.
4. **Validation**:
   - Verified functionality by running a CSV-based Export Data Project in Data Management. The export successfully filtered and exported only lines fulfilled through WMS.

For full step-by-step implementation notes, see the [GitHub Issue](https://github.com/hotwax/dynamics365-integration/issues/23).

## Moqui / OMS Integration Specifications

This section defines the components in the `hotwax-d365` connector to schedule, pull, parse, and process the exported packing slip flat files from D365.

### D365 / OMS Integration Components
- **System Message Type**: `D365_EXP_PACKING_SLIPS`
- **Queue Job**: `d365_QueuePackingSlipsExport`
- **Poll Job**: `d365_ExportPackingSlipsPoll`
- **D365 Definition Group**: `HotWax_Export_Packing_Slips`
- **D365 Package Name**: `OmsPackingSlipExportEntity`
- **Target CSV Filename**: `Oms packing slip export entity.csv`
- **DataManager Configuration**: `D365_IMP_PACKING_SLIPS`
- **Processing Service**: `co.hotwax.d365.D365ShipmentServices.storeAndCreate#D365OutboundShipments`

### Processing Flow
1. **Triggering**: The queue job `d365_QueuePackingSlipsExport` triggers `D365DataPackageServices.queue#ExportDataPackage` which sets up a `SystemMessage` record.
2. **Execution**: The `send#ExportDataPackage` service issues a request to D365 `ExportToPackage` for the `HotWax_Export_Packing_Slips` group.
3. **Polling**: The `d365_ExportPackingSlipsPoll` service monitors the job status until completion.
4. **Ingestion**: Upon completion, the checker downloads the export package, extracts the CSV, and initiates the `D365_IMP_PACKING_SLIPS` DataManager parsing flow.
5. **Consumption**: Tabular rows are passed to `storeAndCreate#D365OutboundShipments` for processing.

### Exported Fields & Mappings

| D365 CSV Field | Moqui/OMS Mapping & Target |
| :--- | :--- |
| `PACKINGSLIPID` | Custom external shipment identifier / shipment reference |
| `SALESID` | Maps to `orderId` via `OrderIdentification` (Type: `D365_SLS_ORD_NUM`) |
| `INVENTORYLOTID` | D365 Sales line identifier; resolves back to `orderItemSeqId` |
| `QUANTITY` | Quantity shipped |
| `SHIPMENTMETHOD` | Maps to `shipmentMethodTypeId` via `IntegrationTypeMapping(D365_SHP_MTHD)` |
| `EXTERNALFACILITYID` | Warehouse code; maps to OMS `facilityId` via external ID mapping |
| `TRACKINGNUMBER` | Tracking number applied to package routing segment |

---

## Next Steps to Consume D365 Export in Moqui

To complete the implementation of Option 3, the following Moqui/OMS-side development steps are required:

### 1. Register Integration Metadata
- Create a new `SystemMessageType` database record for `D365_EXP_PACKING_SLIPS`.
- Define schedule parameters for `d365_QueuePackingSlipsExport` and `d365_ExportPackingSlipsPoll` cron configurations.

### 2. Implement the Parsing Handler Service

To process the flat lines from the CSV and construct the hierarchical shipments, we will use a direct in-memory bulk list processing pattern. This is highly efficient and clean since change tracking is enabled, ensuring sync files remain small.

- **DataManager Config**: Configure `D365_IMP_PACKING_SLIPS` to load the entire parsed CSV into memory as a list of maps and pass it directly to `co.hotwax.d365.D365ShipmentServices.storeAndCreate#D365OutboundShipments`.
- **Processing Logic**:
  1. **Read Dataset**: Access the dataset list of row maps in memory.
  2. **Group and Aggregate**: Loop over the list of flat rows and group them in memory by `PACKINGSLIPID` + `SALESID` to construct hierarchical nested shipment maps:
     ```json
     {
       "packingSlipId": "SPK-001",
       "orderId": "SO001",
       "trackingNumber": "123456",
       "shipmentMethod": "STANDARD",
       "facilityId": "13",
       "lines": [
         { "inventoryLotId": "479494", "quantity": 1.0 },
         { "inventoryLotId": "479495", "quantity": 2.0 }
       ]
     }
     ```
  3. **Reconcile Identifiers**:
     - Resolve the original OMS `orderId` by querying `OrderIdentification` matching `idValue = SALESID` and `orderIdentificationTypeId = 'D365_SLS_ORD_NUM'`.
     - For each line, resolve the OMS `orderItemSeqId` using the stored line attributes matching `INVENTORYLOTID`.
  4. **Invoke Shipment Creation APIs**:
     - Check if a shipment with this external identifier (`PACKINGSLIPID`) already exists to ensure idempotency.
     - If new, programmatically invoke:
       * `create#Shipment` to generate the Shipment header (setting `shipmentType` as Outgoing Sales Shipment, `originFacilityId = EXTERNALFACILITYID`).
       * Add package route segments utilizing the mapped `SHIPMENTMETHOD` and `TRACKINGNUMBER`.
       * Add shipment items mapped to resolved order items.
       * Complete the shipment in Moqui, which will automatically update the status of the respective `OrderItem` records and decrement physical inventory where applicable.




## Related References
- D365 Integration Issue: [hotwax/dynamics365-integration#23](https://github.com/hotwax/dynamics365-integration/issues/23)
- Exploration Issue: [hotwax/hotwax-d365#51](https://github.com/hotwax/hotwax-d365/issues/51)
- Business process reference: [business_processes.md](business_processes.md)
- Integration methodology reference: [integration_methodologies.md](integration_methodologies.md)

