# D365 Sales Orders Integration Implementation Plan

This document outlines the technical design and implementation steps for integrating HotWax OMS with Microsoft Dynamics 365 Finance & Operations (D365 F&O).

## 1. Technical Architecture
- Sales-order integration uses the generic D365 connector foundation documented in [connector_foundation.md](/Users/gurveenkaur/Documents/Work/git/oms/moqui-framework/runtime/component/foundation/project-ideas/dynamics365-integration/foundation/connector_foundation.md).
- **Sales-order specific interfaces**:
    - OData v4 (REST) for direct entity-based sync
    - Data Management Framework (DMF) / Data Package API for composite package import

---

## Technical Reference: OData Metadata
| Term | Meaning |
| :--- | :--- |
| **EntitySet** | The URL collection or endpoint (e.g., `CustomersV3`). |
| **EntityType** | The schema definition and structure of the data object (e.g., `CustomerV3`). |
| **Key** | Defines the Primary Key fields (e.g., `dataAreaId`, `CustomerAccount`). |
| **Nullable="false"** | Indicates a **Required Field** that cannot be empty. |

---

## Data Model (D365 Specific)
Implementation site: `runtime/component/hotwax-d365/entity/D365Entities.xml`

To track synchronization events and map D365 external identifiers back to Moqui entities without cluttering core tables, we use specific history entities.

### Order Sync History
Used to store the D365 Sales Order Number against the OMS Order ID upon successful creation in D365.


```xml
<entity entity-name="D365SalesOrderImportHistory" package="co.hotwax.d365.order">
    <field name="orderSyncHistoryId" type="id" is-pk="true"/>
    <field name="orderId" type="id"/>
    <field name="d365SalesOrderNumber" type="id"/>
    <field name="dataAreaId" type="id"/>
    <field name="createdDate" type="date-time"/>
    <relationship type="one" related="org.apache.ofbiz.order.order.OrderHeader">
        <key-map field-name="orderId"/>
    </relationship>
</entity>
```

---

## Foundation

The generic connector foundation for authentication, credentials storage, legal-entity mapping, token management, and common OData request handling is documented in [connector_foundation.md](/Users/gurveenkaur/Documents/Work/git/oms/moqui-framework/runtime/component/foundation/project-ideas/dynamics365-integration/foundation/connector_foundation.md).

This sales-order implementation plan focuses on the sales-order-specific services, entities, views, and orchestration built on top of that shared connector layer.

## Customer Synchronization
### Sync Service Logic (`sync#Customer`)
1. **Remote Lookup**: Call `GET /data/CustomersV3` with `$filter` by `CustomerAccount eq 'HW-partyId'`.
2. **Creation**: If not found, `POST /data/CustomersV3`.
    - Map `'HW-' + partyId` -> `CustomerAccount`.
    - Provide mandatory fields: `dataAreaId`, `PartyType`, `CustomerGroupId`, `SalesCurrencyCode`.
3. **Outcome**: The `HW-partyId` is used directly as the `CustomerAccount` in D365. No local identification record is required.
   - **TODO** Check to send the Shopify Customer Id here, and decide if we should have CustomerAccount field as auto created in D365 or we can continue to send unique identifier from OMS.

### Mapping (`CustomersV3`)
| D365 Field | Moqui Field               | Usage / Notes |
| :--- |:--------------------------| :--- |
| `CustomerAccount` | `'HW-' + partyId`         | Primary identifier in D365. Prefixed with `HW-`. |
| `dataAreaId` | `usmf`                    | Legal entity context. **TODO**: Currently hardcoded to `usmf` for demo; should map to `ProductStore.externalId`. |
| `PersonFirstName` | `Person.firstName`        | Only for `PartyType` = `Person`. |
| `PersonLastName` | `Person.lastName`         | Only for `PartyType` = `Person`. |
| `PrimaryContactEmail`| `ContactMech.infoString` | Joined via `PartyContactMechPurpose` (PRIMARY_EMAIL). |
| `PrimaryContactPhone`| `TelecomNumber`           | Joined via `PartyContactMechPurpose` (PRIMARY_PHONE). Formatted as: `[countryCode] [areaCode] [contactNumber]`. |
| `SalesCurrencyCode` | `ProductStore.defaultCurrencyUomId` | Abbreviation of the default currency UOM for the `ProductStore`. Defaults to `USD` if not found. |
| `CustomerGroupId` | `'30'`                    | **TODO**: Needs discussion. Currently hardcoded to `30` as it's not yet mapped in OMS. |
| `SalesTaxGroup`   | `''` (Empty String)       | **TODO**: Needs mapping. Expected to be something like `AVATAX`. |


## Sales Order Flows

### 1. Import of Sales Orders from OMS to D365

This flow covers outbound sales order creation from HotWax OMS into D365.

#### 1.1 Eligible Orders Views

Two separate eligibility views are used so OData and DMF can evolve independently.

- **OData View**: `D365EligibleSalesOrdersOData`
  - Shopify order id exists
  - `D365SalesOrderHeaderHistory` is missing, or header status is not `D365_ORD_SYNCED`
- **DMF View**: `D365EligibleSalesOrdersDMF`
  - Shopify order id exists
  - `D365SalesOrderImportHistory` record is missing

- **Shared aliases**: `orderId`, `partyId` (BILL_TO_CUSTOMER), `productStoreId`, `dataAreaId`

#### 1.2 Supported Import Approaches

The connector currently supports two separate technical approaches for sales order synchronization:

1. **Approach 1.2.1: OData Pattern**
   - Service name: `co.hotwax.d365.D365OrderServices.sync#SalesOrders`
   - D365 model: `SalesOrderHeadersV4` + `SalesOrderLinesV3`
   - Processing style: Direct, request-driven entity sync
   - OMS tracking entity names: `D365SalesOrderHeaderHistory`, `D365SalesOrderLineHistory`

2. **Approach 1.2.2: DMF / Data Package Pattern**
   - Service name: `co.hotwax.d365.D365OrderServices.import#SalesOrdersDataPackage`
   - D365 model: `Sales orders composite V4`
   - Processing style: Package-based batch import via DMF
   - OMS tracking entity name: `D365SalesOrderImportHistory`

##### 1.2.1 OData Import Implementation

##### Current Implementation Summary
This is a fully implemented direct-sync path that creates a sales order header and then creates individual order lines using standard OData entities.

##### Service Flow
1. **Fetch Eligible Orders**: Query the view-entity `D365EligibleSalesOrdersOData`.
2. **Customer Sync**: Call the service `sync#Customer` for the order's `partyId`.
3. **Initialize/Read Local OData History**:
    - Read the entity `D365SalesOrderHeaderHistory`
    - Read the entity `D365SalesOrderLineHistory`
    - Mark header history as `D365_ORD_PENDING`
4. **Prepare Header Context**:
    - Load the view-entity `D365SalesOrderDetail`
    - Normalize state code
    - Build concatenated street address
5. **Idempotent Header Check**:
    - Query `SalesOrderHeadersV4`
    - Filter by `CustomersOrderReference eq '<orderId>'`
    - If found, reuse returned `SalesOrderNumber`
6. **Header Create**:
    - If not found, `POST /data/SalesOrderHeadersV4`
    - Store HotWax `orderId` in `CustomersOrderReference`
7. **Idempotent Line Check**:
    - Query `SalesOrderLinesV3`
    - Filter by `SalesOrderNumber`
    - Collect existing `LineNumber` values
8. **Line Create**:
    - Iterate eligible order items
    - Skip cancelled items
    - Skip any line already marked `D365_ORD_SYNCED` in line history
    - Reconcile any line already present in D365 into local line history
    - `POST /data/SalesOrderLinesV3` for missing lines
9. **Local Persistence**:
    - Update line history per order item as `D365_ORD_SYNCED` or `D365_ORD_ERROR`
    - Update header history as `D365_ORD_SYNCED`, `D365_ORD_PARTIAL`, or `D365_ORD_ERROR`
    - Only after header reaches `D365_ORD_SYNCED`, create `OrderIdentification` with type `D365_ORDER_ID`

##### OData Tracking Entities

- **Header history**: `D365SalesOrderHeaderHistory`
  - Tracks aggregate order-level OData status
  - Stores `d365SalesOrderNumber`, `syncStatusId`, `syncedDate`, and `logText`
- **Line history**: `D365SalesOrderLineHistory`
  - Tracks per-line OData result for retry-safe resumption
  - Stores `orderItemSeqId`, `d365SalesOrderNumber`, `syncStatusId`, `syncedDate`, `lastAttemptDate`, and `logText`

##### OData Entity Mappings

###### Header (`SalesOrderHeadersV4`)
| D365 Field | Moqui Field | Usage / Notes |
| :--- | :--- | :--- |
| `dataAreaId` | `order.dataAreaId` | Legal entity context from eligible order view. |
| `CustomersOrderReference` | `OrderHeader.orderId` | OMS order reference used for idempotent lookup. |
| `SalesOrderOriginCode` | Hardcoded `'Ecom'` | **TODO**: replace with integration mapping. |
| `DeliveryModeCode` | Hardcoded `'Standard'` | **TODO**: replace with integration mapping. |
| `OrderingCustomerAccountNumber` | Resolved D365 customer account | Returned by customer sync. |
| `InvoiceCustomerAccountNumber` | Resolved D365 customer account | Same as ordering customer account. |
| `CurrencyCode` | `orderDetail.currencyCode` | Defaults to `USD` if missing. |
| `IsDeliveryAddressOrderSpecific` | Hardcoded `'Yes'` | Uses order-scoped delivery address. |
| `DeliveryAddressName` | `orderDetail.toName` | Ship-to name. |
| `DeliveryAddressDescription` | Hardcoded `'OMS Ship To'` | Fixed value. |
| `DeliveryAddressStreet` | `address1 + address2` | Concatenated address lines. |
| `DeliveryAddressCity` | `orderDetail.city` | |
| `DeliveryAddressStateId` | Normalized `stateProvinceGeoId` | Strips OMS prefixes when present. |
| `DeliveryAddressZipCode` | `orderDetail.postalCode` | |
| `DeliveryAddressCountryRegionId` | `orderDetail.countryGeoId` | |
| `Email` | `orderDetail.email` | Contact email on order header. |

###### Line (`SalesOrderLinesV3`)
| D365 Field | Moqui Field | Usage / Notes |
| :--- | :--- | :--- |
| `dataAreaId` | `order.dataAreaId` | Legal entity context. |
| `SalesOrderNumber` | Resolved D365 `SalesOrderNumber` | Linked to created/found header. |
| `LineNumber` | `orderItemSeqId` | Cast to integer. |
| `ItemNumber` | `item.itemNumber` | Defaults to `'1000'`. **TODO**: strict D365 product mapping needed. |
| `OrderedSalesQuantity` | `item.quantity` | |
| `SalesPrice` | `item.unitPrice` | |
| `LineDiscountAmount` | `getItemDiscountAmount()` | Derived from OMS discounts. |
| `ShippingWarehouseId` | `item.shippingWarehouseId` | Sent only for `WH_ONLY_FULFILLMENT` items. |

##### OData Idempotency and Failure Behavior
- **Header idempotency key**: `CustomersOrderReference`
- **Line idempotency key**: `LineNumber`
- **Failure behavior**: Partial orders are possible because header and lines are separate API calls.
- **Mitigation**:
    - Re-query header before create
    - Re-query existing lines before line POST
    - Persist `D365_ORDER_ID` only after all lines succeed

##### OData TODOs / Gaps
- Map `SalesOrderOriginCode` via `IntegrationTypeMapping`
- Map `DeliveryModeCode` via `IntegrationTypeMapping`
- Resolve `ItemNumber` from D365 product identification instead of defaulting to `1000`
- Add support for D365 variant dimension fields
- Revisit missing header fields such as order date, Shopify order identity, and ship-to phone

##### OData Sample Requests

###### Customer Creation (`CustomersV3`)
```json
{
  "dataAreaId": "usmf",
  "CustomerAccount": "HW-02",
  "PartyType": "Person",
  "PersonFirstName": "Steve",
  "PersonLastName": "Rogers",
  "CustomerGroupId": "30",
  "SalesCurrencyCode": "USD"
}
```

###### Sales Order Header (`SalesOrderHeadersV4`)
```json
 {
  "dataAreaId": "usmf",
  "CustomersOrderReference": "OMS-12345",
  "OrderingCustomerAccountNumber": "HW-02",
  "InvoiceCustomerAccountNumber": "HW-02",
  "CurrencyCode": "USD",
  "IsDeliveryAddressOrderSpecific": "Yes",
  "DeliveryAddressName": "Steve Rogers",
  "DeliveryAddressDescription": "OMS Ship To",
  "DeliveryAddressStreet": "221B Olive Street",
  "DeliveryAddressCity": "Mountain View",
  "DeliveryAddressStateId": "CA",
  "DeliveryAddressZipCode": "94086",
  "DeliveryAddressCountryRegionId": "USA"
 }
```

###### Sales Order Line (`SalesOrderLinesV3`)
```json
 {
  "dataAreaId": "usmf",
  "SalesOrderNumber": "000891",
  "ItemNumber": "1000",
  "LineNumber": 1,
  "OrderedSalesQuantity": 1,
  "SalesPrice": 100,
  "LineDiscountAmount": 20,
  "ShippingWarehouseId": "13"
 }
```

##### 1.2.2 DMF / Data Package Import Implementation

This section documents two approaches for the DMF / Data Package path:

- **Approach 1**: execution tracking using `SystemMessage` records after the remote D365 trigger call
- **Approach 2**: a Moqui-native `SystemMessage` send lifecycle using `SmsgProduced` -> `SmsgSending` -> `SmsgSent` -> `SmsgConfirmed`

See the shared Data Package API reference: [data_import_package_api.md](/Users/gurveenkaur/Documents/Work/git/oms/moqui-framework/runtime/component/foundation/project-ideas/dynamics365-integration/data-package-api/data_import_package_api.md). That document describes only the generic D365 package API services; the sales-order-specific job, packaging, and submission details remain in this implementation plan.

##### Approach 1 - Execution Tracking Using `SystemMessage` Records

###### Summary
This approach builds a `Sales orders composite V4` XML file in memory, wraps it in a DMF package, uploads it to Azure Blob storage, and triggers D365 import automation.

This approach uses `SystemMessage` primarily as an execution-tracking record after the remote D365 API call has already happened. In other words, the `SystemMessage` row is used to persist the returned execution identifier and provide a poll target, but the standard Moqui `SystemMessageType.sendServiceName` flow is not the primary orchestration mechanism for the initial trigger.

This means the pattern is operationally useful, but it behaves more like a lightweight async tracker than a fully native Moqui outgoing message flow.

###### Service Flow
1. **Fetch Eligible Orders**: Query the view-entity `D365EligibleSalesOrdersDMF` with a batch limit.
2. **Create DMF submission tracking record**:
    - Persist the entity `D365SalesOrderImportHistory` during packaging so the same order is not packaged again immediately
3. **Customer Sync**: Create or verify customers synchronously via OData before packaging orders.
4. **Load Order Context**:
    - Load the view-entity `D365SalesOrderDetail`
    - Load non-cancelled records from the view-entity `D365SalesOrderItemDetail`
    - Compute shipping charge amount
5. **Build Composite Payload**:
    - Create header map for `SALESORDERHEADERV3ENTITY`
    - Create line maps for `SALESORDERLINEV2ENTITY`
    - Create charge map for `SALESORDERHEADERCHARGEV2ENTITY`
6. **Create XML**:
    - Generate `Sales orders composite V4.xml`
    - Nest lines and charges under each header record
7. **Create Package Metadata**:
    - Generate `Manifest.xml`
    - Generate `PackageHeader.xml`
8. **Create ZIP Package**:
    - Bundle XML + manifests into a single ZIP in memory
9. **Obtain Upload URL**:
    - Call the `GetAzureWriteUrl` API
10. **Upload Package**:
    - PUT the ZIP file to Azure Blob storage
11. **Trigger Import**:
    - Call the `ImportFromPackage` API with `definitionGroupId` and `BlobId`
12. **Persist Execution Tracking**:
    - Create a `SystemMessage` entity record in `SmsgProduced` with `messageText = executionId`
    - Poll later using the generic import-status services
13. **Local Persistence**:
    - The entity `D365SalesOrderImportHistory` remains the DMF submission marker
    - **TODO**: confirm/complete final mapping back to the entity `OrderIdentification` after import execution succeeds

###### Why this design feels transitional
- The remote D365 import trigger has already been executed before the `SystemMessage` entity record is queued.
- `queue#SystemMessage(sendNow=false)` is therefore used mainly as durable tracking state, not as a true outgoing send pipeline.
- The `SystemMessageType` exists and categorizes the flow, but its `sendServiceName` is not the primary initiator of the remote work.
- This is functionally valid, but it does not fully align with the usual Moqui pattern where a produced outgoing message is later sent by `send#ProducedSystemMessage`.

###### Example Tracking Record Shape

In this approach, the effective tracking payload is close to:

```json
{
  "systemMessageTypeId": "D365_IMPORT_ORDERS",
  "systemMessageRemoteId": "D365_HotWax_Sandbox",
  "statusId": "SmsgProduced",
  "isOutgoing": "Y",
  "messageText": "D365 executionId returned by ImportFromPackage"
}
```

The key point is that `messageText` is effectively acting as execution-id storage.

##### Approach 2 - Moqui-Native `SystemMessage` Send Flow

###### Summary
This approach uses a single outgoing `SystemMessageType` and maps the D365 DMF lifecycle onto native Moqui `SystemMessage` statuses:

- `SmsgProduced`: export/import request has been queued locally
- `SmsgSending`: the configured `sendServiceName` is currently triggering the remote D365 package API
- `SmsgSent`: D365 accepted the request and returned an execution id
- `SmsgConfirmed`: OMS later confirmed that D365 finished successfully and OMS completed its follow-up processing

This design treats the `SystemMessage` entity as the canonical record of one remote D365 package execution from initial queueing through final confirmation.

###### Status Flow

The intended lifecycle is:

```json
{
  "statusFlow": [
    "SmsgProduced",
    "SmsgSending",
    "SmsgSent",
    "SmsgConfirmed"
  ]
}
```

This is valid against the Moqui `SystemMessage` status transitions:
- `SmsgProduced -> SmsgSending`
- `SmsgSending -> SmsgSent`
- `SmsgSent -> SmsgConfirmed`

###### Proposed Processing Flow
1. **Producer Job**:
    - Create one outgoing `SystemMessage` entity record in `SmsgProduced`
    - Set `sendNow = false`
    - Store all D365 trigger metadata needed by the send and poll stages
2. **Send Job**:
    - Run `org.moqui.impl.SystemMessageServices.send#AllProducedSystemMessages`
    - This invokes `SystemMessageType.sendServiceName`
3. **Configured Send Service**:
    - Load the `SystemMessage` entity record by `systemMessageId`
    - Read package metadata from `messageText`
    - Trigger the remote D365 package API
    - Return `remoteMessageId = executionId`
4. **Framework Status Update**:
    - Moqui updates the message from `SmsgSending` to `SmsgSent`
    - The returned D365 `executionId` is stored in `remoteMessageId`
5. **Poll/Confirm Job**:
    - A custom scheduled service reads messages in `SmsgSent`
    - Use `remoteMessageId` as the D365 `executionId`
    - Check completion status in D365
6. **Confirmation Processing**:
    - If still running, leave the message in `SmsgSent`
    - If successful, complete the downstream OMS follow-up work and update the message to `SmsgConfirmed`
    - If unrecoverable, update the message to `SmsgError`

###### Why this design is stronger
- It uses `sendServiceName` for the actual remote trigger, which matches the Moqui outgoing message model.
- `remoteMessageId` becomes the natural home for the D365 `executionId`.
- `SmsgSent` gets a precise meaning: D365 accepted the request, but OMS has not yet confirmed remote completion.
- `SmsgConfirmed` gets a precise meaning: remote execution completed successfully and OMS completed the follow-up processing.
- The trigger phase benefits from the standard Moqui send/retry lifecycle for messages in `SmsgProduced` / `SmsgError`.

###### Proposed `SystemMessage` Shape

The queued message should carry all metadata needed for the send and confirm phases. One reasonable shape is:

```json
{
  "systemMessageTypeId": "D365_IMPORT_ORDERS",
  "systemMessageRemoteId": "D365_HotWax_Sandbox",
  "statusId": "SmsgProduced",
  "isOutgoing": "Y",
  "messageText": {
    "definitionGroupId": "HotWax_Import_SalesOrders_Composite",
    "packageName": "Sales orders composite V4",
    "legalEntityId": "USMF",
    "fileName": "Sales orders composite V4.xml",
    "orderIds": [
      "OMS10001",
      "OMS10002"
    ]
  },
  "remoteMessageId": null
}
```

After the send service succeeds, the same message would effectively look like:

```json
{
  "systemMessageTypeId": "D365_IMPORT_ORDERS",
  "systemMessageRemoteId": "D365_HotWax_Sandbox",
  "statusId": "SmsgSent",
  "isOutgoing": "Y",
  "messageText": {
    "definitionGroupId": "HotWax_Import_SalesOrders_Composite",
    "packageName": "Sales orders composite V4",
    "legalEntityId": "USMF",
    "fileName": "Sales orders composite V4.xml",
    "orderIds": [
      "OMS10001",
      "OMS10002"
    ]
  },
  "remoteMessageId": "D365 executionId returned by ImportFromPackage"
}
```

After OMS confirms the remote execution and completes follow-up processing, the message would move to:

```json
{
  "systemMessageTypeId": "D365_IMPORT_ORDERS",
  "systemMessageRemoteId": "D365_HotWax_Sandbox",
  "statusId": "SmsgConfirmed",
  "isOutgoing": "Y",
  "remoteMessageId": "D365 executionId returned by ImportFromPackage"
}
```

###### Responsibilities by Field
- `systemMessageTypeId`: identifies the integration stream
- `systemMessageRemoteId`: identifies the D365 remote configuration
- `messageText`: stores the business metadata needed to trigger and later confirm the request
- `remoteMessageId`: stores the D365 `executionId`

###### Design Trade-offs
- This design is cleaner from a Moqui messaging perspective.
- It still needs a dedicated confirmation/poll job for messages already in `SmsgSent`, because `send#AllProducedSystemMessages` only handles `SmsgProduced`.
- The proposed pattern is therefore:
  - standard Moqui send/retry for the initial trigger
  - custom scheduled confirmation loop for the remote completion phase

###### Decision Note
- We started with **Approach 1**, which helped validate the D365 DMF packaging, upload, and execution-tracking mechanics.
- We will proceed with **Approach 2** for the next iteration so that the design aligns more closely with native Moqui `SystemMessage` semantics and gives clearer meaning to the statuses `SmsgProduced`, `SmsgSending`, `SmsgSent`, and `SmsgConfirmed`.

##### DMF Composite Entity Mappings

###### Header (`SALESORDERHEADERV3ENTITY`)
| XML Attribute | Mapping from OMS | Usage / Notes |
| :--- | :--- | :--- |
| `CUSTOMERSORDERREFERENCE` | `orderId` | OMS order reference. |
| `SALESORDERORIGINCODE` | Hardcoded `'Ecom'` | **TODO**: replace with mapping. |
| `DELIVERYMODECODE` | Hardcoded `'Standard'` | **TODO**: replace with mapping. |
| `ORDERINGCUSTOMERACCOUNTNUMBER` | Resolved D365 customer account | Returned by customer sync. |
| `INVOICECUSTOMERACCOUNTNUMBER` | Resolved D365 customer account | Same as ordering customer account. |
| `CURRENCYCODE` | `orderDetail.currencyCode` | Defaults to `USD`. |
| `DELIVERYADDRESSNAME` | `orderDetail.toName` | |
| `DELIVERYADDRESSDESCRIPTION` | Hardcoded `'OMS Ship To'` | Fixed value. |
| `DELIVERYADDRESSSTREET` | `address1 + address2` | Concatenated address. |
| `DELIVERYADDRESSCITY` | `orderDetail.city` | |
| `DELIVERYADDRESSSTATEID` | Normalized `stateProvinceGeoId` | |
| `DELIVERYADDRESSZIPCODE` | `orderDetail.postalCode` | |
| `DELIVERYADDRESSCOUNTRYREGIONID` | `orderDetail.countryGeoId` | |
| `EMAIL` | `orderDetail.email` | |

###### Line (`SALESORDERLINEV2ENTITY`)
| XML Attribute | Mapping from OMS | Usage / Notes |
| :--- | :--- | :--- |
| `ITEMNUMBER` | `item.itemNumber` | Defaults to `'1000'`. **TODO**: strict D365 product mapping needed. |
| `LINEDISCOUNTAMOUNT` | Item discount amount | Computed from OMS adjustments. |
| `LINENUMBER` | `orderItemSeqId` | Serialized as string in XML. |
| `ORDEREDSALESQUANTITY` | `quantity` | |
| `SALESPRICE` | `unitPrice` | |
| `SHIPPINGWAREHOUSEID` | `shippingWarehouseId` | Sent for D365 fulfillment warehouse use case. |

###### Header Charge (`SALESORDERHEADERCHARGEV2ENTITY`)
| XML Attribute | Mapping from OMS | Usage / Notes |
| :--- | :--- | :--- |
| `FIXEDCHARGEAMOUNT` | Calculated shipping charge | Defaults to `0` if missing. |
| `SALESCHARGECODE` | Hardcoded `'FREIGHT'` | Fixed value in current implementation. |

##### DMF Package and Import Details
- **Generated files**:
    - `Sales orders composite V4.xml`
    - `Manifest.xml`
    - `PackageHeader.xml`
- **Definition group**: Defaults to `HotWax_Import_SalesOrders_Composite`
- **D365 actions used**:
    - `GetAzureWriteUrl` API
    - `ImportFromPackage` API
- **Import behavior**:
    - Batch-oriented
    - Asynchronous from OMS perspective
    - Requires downstream monitoring / result correlation

For generic package upload/import mechanics and API sequencing, refer to [data_import_package_api.md](/Users/gurveenkaur/Documents/Work/git/oms/moqui-framework/runtime/component/foundation/project-ideas/dynamics365-integration/data-package-api/data_import_package_api.md).

##### DMF TODOs / Gaps
- Confirm final success reconciliation from import execution to `OrderIdentification`
- Replace hardcoded `SalesOrderOriginCode` and `DeliveryModeCode`
- Resolve `ITEMNUMBER` from OMS-to-D365 product mapping
- Add D365 variant dimension support in the composite payload
- Validate whether shipping charge handling through `SALESORDERHEADERCHARGEV2ENTITY` is sufficient for all order scenarios

#### 1.3 Custom Service / SysOperation Import (Future)
**TODO:** This approach is not yet implemented.

Designed for high-volume and guaranteed document atomicity.

1. **Atomic Request**: Send a single nested JSON document (Header + Lines) to a custom X++ service.
2. **Transactional Commit**: D365 creates the entire order within a single database transaction.
3. **Efficiency**: Reduces network overhead from `1 + N` requests to `1` request per order.

#### 1.4 Import Prerequisites & TODOs
> [!IMPORTANT]
> - Customer must exist and not be on hold.
> - Products must be "Released" to the Legal Entity.
> - Warehouse/site validation must be confirmed against the target D365 setup for both OData and DMF paths.

- **TODO**: [Mapping] Define `facilityId` to D365 warehouse/site mapping.
- **TODO**: [Mapping] Create mapping table for `TaxCategory` -> `ItemSalesTaxGroup`.

## Integration Type Mappings
To avoid hardcoding values like `SalesOrderOriginCode` and `DeliveryModeCode` in service logic, we use the `IntegrationTypeMapping` entity to translate OMS identifiers into D365 codes.

### Configuration Structure
Add records to the entity `co.hotwax.integration.IntegrationTypeMapping` for the target system:

| Mapping Category | OMS Internal ID (`mappingKey`) | D365 Code (`mappingValue`) | Enum Type (`integrationTypeId`) |
| :--- | :--- | :--- | :--- |
| **Sales Order Origin** | OMS Sales Channel (e.g., `WEB_SALES_CHANNEL`) | D365 Sales Origin (e.g., `Ecom`) | `D365_SALES_ORIGIN` |
| **Delivery Mode** | OMS Shipment Method (e.g., `STANDARD`) | D365 Mode of Delivery (e.g., `Standard`) | `D365_DELIVERY_MODE` |

### Mapping Details
- **Sales Order Origin**: Maps the OMS `salesChannelEnumId` (from `OrderHeader`) to the D365 Sales Origin. In D365, this is the 'Sales Origin' field.
- **Delivery Mode**: Maps the OMS `shipmentMethodTypeId` (from `OrderItemShipGroup`) to the D365 Mode of Delivery. In D365, this is the 'Mode of delivery' field.

### Setup Steps
1. **Define Enumerations**: Add the mapping category IDs (e.g., `D365_SALES_ORIGIN`) to `moqui.basic.Enumeration` with `enumTypeId="IntegrationType"`.
2. **Populate Mappings**: Provide the specific mapping records:
   - `integrationTypeId`: The category ID.
   - `mappingKey`: The internal Moqui ID.
   - `mappingValue`: The external D365 value.
   - `integrationRefId`: Set to the same value as `mappingKey` for referential integrity.

### 2. Export of Sales Orders from D365 to OMS

This flow covers the return of D365-generated sales order identifiers back into OMS so the OMS can store the `SalesOrderNumber` against the originating order.

See the shared Data Package export reference: [data_export_package_api.md](/Users/gurveenkaur/Documents/Work/git/oms/moqui-framework/runtime/component/foundation/project-ideas/dynamics365-integration/data-package-api/data_export_package_api.md). That document is the source of truth for the generic D365 export framework and documents both approaches that were explored:
- **Approach 1**: execution tracking using `SystemMessage` entity records after the D365 export trigger call
- **Approach 2**: the Moqui-native `SystemMessage` send lifecycle now used by the connector

This sales-order section focuses on how the sales-order reconciliation flow uses those approaches and, in the current design, how it uses the generic export queue/send/poll services.

#### 2.1 Objective
- Read the D365-generated `SalesOrderNumber`
- Match it back to the originating OMS `orderId`
- Store the value in OMS as `OrderIdentification` with type `D365_ORDER_ID`

#### 2.2 Primary Use Case
- **DMF import reconciliation**: DMF submission is asynchronous, so OMS needs a follow-up export/reconciliation step to confirm which D365 sales order number was assigned to each imported order.

#### 2.2.1 Two Export Approaches Considered for Sales Orders

##### Approach 1 - Execution Tracking Using `SystemMessage` Entity Records

This was the earlier export design for sales-order reconciliation.

Sales-order-specific values in this approach:
- `systemMessageTypeId = D365_EXP_SALES_ORDERS`
- `definitionGroupId = HotWax_Export_Sales_Orders`
- `packageName = SalesOrderHeadersV4`
- `fileName = Sales order headers V4.csv`
- `dataManagerConfigId = D365_IMP_SALES_ORD`

Relevant services in that approach:
- generic trigger service `D365DataPackageServices.trigger#DataPackageExport`
- generic poll service `D365DataPackageServices.poll#DataPackageStatus`
- generic single-message checker `D365DataPackageServices.check#DataPackageStatus`
- sales-order row-processing service `D365OrderServices.store#D365SalesOrderNumber`

Behavior in that approach:
1. the sales-order trigger job called the generic trigger service
2. the generic trigger service called D365 `ExportToPackage`
3. after D365 returned `executionId`, OMS created a `SystemMessage` entity record in `SmsgProduced`
4. that `SystemMessage.messageText` stored the `executionId`
5. the poll job read `SmsgProduced` tracker messages and called `GetExecutionSummaryStatus`
6. on success, the checker called `GetExportedPackageUrl`, downloaded the package, extracted `Sales order headers V4.csv`, and uploaded the file to the DataManager config `D365_IMP_SALES_ORD`
7. DataManager then invoked the service `D365OrderServices.store#D365SalesOrderNumber`

This approach remains important in the documentation because it explains the earlier design and the reason the reconciliation flow was initially modeled as execution tracking over `SystemMessage`.

##### Approach 2 - Moqui-Native `SystemMessage` Send Flow

This is the current sales-order export design.

Sales-order-specific values in this approach:
- `systemMessageTypeId = D365_EXP_SALES_ORDERS`
- `sendServiceName = D365DataPackageServices.send#ExportDataPackage`
- `definitionGroupId = HotWax_Export_Sales_Orders`
- `packageName = SalesOrderHeadersV4`
- `fileName = Sales order headers V4.csv`
- `dataManagerConfigId = D365_IMP_SALES_ORD`

Relevant services and jobs in this approach:
- trigger job `d365_QueueSalesOrderExport`
- generic queue service `D365DataPackageServices.queue#ExportDataPackage`
- generic send service `D365DataPackageServices.send#ExportDataPackage`
- poll job `d365_ExportSalesOrdersPoll`
- generic poll service `D365DataPackageServices.poll#ExportDataPackageStatus`
- generic single-message checker `D365DataPackageServices.check#ExportDataPackageStatus`
- sales-order row-processing service `D365OrderServices.store#D365SalesOrderNumber`

Behavior in this approach:
1. the trigger job `d365_QueueSalesOrderExport` queues a `SystemMessage` entity record for the sales-order export flow
2. the generic queue service `queue#ExportDataPackage` stores a JSON payload in `SystemMessage.messageText` with:
   - `definitionGroupId = HotWax_Export_Sales_Orders`
   - `packageName = SalesOrderHeadersV4`
   - `fileName = Sales order headers V4.csv`
   - `dataManagerConfigId = D365_IMP_SALES_ORD`
3. because `sendNow=true`, Moqui invokes `send#ProducedSystemMessage`
4. the configured `sendServiceName`, `send#ExportDataPackage`, calls D365 `ExportToPackage`
5. D365 returns `executionId`
6. Moqui stores that `executionId` in `SystemMessage.remoteMessageId` and moves the message through:
   - `SmsgProduced`
   - `SmsgSending`
   - `SmsgSent`
7. the poll job `d365_ExportSalesOrdersPoll` finds sales-order export messages in `SmsgSent`
8. `check#ExportDataPackageStatus` calls `GetExecutionSummaryStatus`
9. when the export succeeds, the checker:
   - calls `GetExportedPackageUrl`
   - downloads the ZIP package
   - extracts `Sales order headers V4.csv`
   - uploads the file to the DataManager config `D365_IMP_SALES_ORD`
10. DataManager invokes `D365OrderServices.store#D365SalesOrderNumber`
11. on successful file processing, the `SystemMessage` entity record moves to `SmsgConfirmed`

This approach is now preferred because the `SystemMessage` entity record is the real outbound unit of work and the message statuses have their intended Moqui meaning.

#### 2.2.2 Implemented Job and Service Sequence

The current implementation uses the generic export queue/send/poll model and Maarg DataManager processing in the following sequence:

1. **Queue job**: the service job `d365_QueueSalesOrderExport`
   - Defined in [D365ServiceJobData.xml](/Users/gurveenkaur/Documents/Work/git/oms/moqui-framework/runtime/component/hotwax-d365/data/D365ServiceJobData.xml)
   - Calls the generic queue service [D365DataPackageServices.queue#ExportDataPackage](/Users/gurveenkaur/Documents/Work/git/oms/moqui-framework/runtime/component/hotwax-d365/service/co/hotwax/d365/D365DataPackageServices.xml:4)
   - Parameters:
     - `systemMessageTypeId = D365_EXP_SALES_ORDERS`
     - `definitionGroupId = HotWax_Export_Sales_Orders`
     - `packageName = SalesOrderHeadersV4`
     - `fileName = Sales order headers V4.csv`
     - `dataManagerConfigId = D365_IMP_SALES_ORD`
     - `legalEntityId`
2. **Generic queue service execution**: the service `queue#ExportDataPackage`
   - creates the export payload JSON in `SystemMessage.messageText`
   - queues the `SystemMessage` entity record in `SmsgProduced`
   - immediately invokes Moqui send processing through `queue#SystemMessage(sendNow=true)`
3. **Generic send service execution**: the service `send#ExportDataPackage`
   - reads the payload from `SystemMessage.messageText`
   - calls D365 `ExportToPackage`
   - returns `remoteMessageId = executionId`
4. **Poll job**: the service job `d365_ExportSalesOrdersPoll`
   - Defined in [D365ServiceJobData.xml](/Users/gurveenkaur/Documents/Work/git/oms/moqui-framework/runtime/component/hotwax-d365/data/D365ServiceJobData.xml)
   - Calls the service [D365DataPackageServices.poll#ExportDataPackageStatus](/Users/gurveenkaur/Documents/Work/git/oms/moqui-framework/runtime/component/hotwax-d365/service/co/hotwax/d365/D365DataPackageServices.xml:86)
   - Parameters:
     - `systemMessageTypeId = D365_EXP_SALES_ORDERS`
5. **Generic poll service execution**: the service `poll#ExportDataPackageStatus`
   - Finds `SystemMessage` entity records in `SmsgSent`
   - Invokes the service `check#ExportDataPackageStatus` for each execution id
6. **Low-level poll/check execution**: the service `check#ExportDataPackageStatus`
   - Calls D365 `GetExecutionSummaryStatus`
   - When succeeded or partially succeeded, calls D365 `GetExportedPackageUrl`
   - Downloads the ZIP
   - Extracts the file matching `Sales order headers V4.csv`
   - Hands the extracted file to the DataManager config `D365_IMP_SALES_ORD`
7. **DataManager import service execution**
   - Configured in [D365DataManagerData.xml](/Users/gurveenkaur/Documents/Work/git/oms/moqui-framework/runtime/component/hotwax-d365/data/D365DataManagerData.xml:6)
   - Uses the import service [D365OrderServices.store#D365SalesOrderNumber](/Users/gurveenkaur/Documents/Work/git/oms/moqui-framework/runtime/component/hotwax-d365/service/co/hotwax/d365/D365OrderServices.xml:551)
8. **Sales order number storage**
   - The service `store#D365SalesOrderNumber` reads each exported row
   - Maps `CUSTOMERSORDERREFERENCE -> orderId`
   - Maps `SALESORDERNUMBER -> D365_ORDER_ID`
   - Creates or updates the entity `OrderIdentification`

#### 2.3 Export / Reconciliation Source
- **D365 entity/API used**: `SalesOrderHeadersV4`
- **Primary lookup field**: `CustomersOrderReference`
- **Expected mapping**:
    - `CustomersOrderReference` = OMS `orderId`
    - `SalesOrderNumber` = D365-generated sales order identifier
    - `dataAreaId` = legal entity context for safer matching

For generic package export trigger/poll/download mechanics, refer to [data_export_package_api.md](/Users/gurveenkaur/Documents/Work/git/oms/moqui-framework/runtime/component/foundation/project-ideas/dynamics365-integration/data-package-api/data_export_package_api.md).

#### 2.4 Proposed Service Flow
1. Queue D365 export using `d365_QueueSalesOrderExport`.
2. Create a `SystemMessage` entity record with the sales-order export payload.
3. Invoke the configured `sendServiceName` and start a D365 export execution for definition group `HotWax_Export_Sales_Orders`.
4. Persist the returned `executionId` in `SystemMessage.remoteMessageId`.
5. Poll the export execution using the service job `d365_ExportSalesOrdersPoll`.
6. Once the execution succeeds, download the exported ZIP package.
7. Extract `Sales order headers V4.csv`.
8. Feed the file into the DataManager config `D365_IMP_SALES_ORD`.
9. Execute the service `store#D365SalesOrderNumber` for each CSV row.
10. Create or update the OMS entity `OrderIdentification` with:
    - `orderIdentificationTypeId = D365_ORDER_ID`
    - `idValue = SALESORDERNUMBER`

#### 2.5 Persistence Target in OMS
- **Entity**: `co.hotwax.order.OrderIdentification`
- **Type**: `D365_ORDER_ID`
- **Purpose**: Make the D365 sales order identifier available for downstream payment sync, settlement, and cross-system traceability.

#### 2.6 Current Status
- **Implemented today**:
    - Queue service job: `d365_QueueSalesOrderExport`
    - Poll service job: `d365_ExportSalesOrdersPoll`
    - Generic Data Package export service names: `queue#ExportDataPackage`, `send#ExportDataPackage`, `poll#ExportDataPackageStatus`, `check#ExportDataPackageStatus`
    - Row-storage service name: `store#D365SalesOrderNumber`
- **Still open for refinement**:
    - retry/backoff policy tuning for delayed D365 export completion
    - validation/handling for duplicate or ambiguous exported records
    - tighter linkage between `D365SalesOrderImportHistory` and final reconciliation status

#### 2.7 Export / Reconciliation TODOs
- decide whether the queue job naming/schedule should differ by environment
- define whether reconciliation should remain polling-based only or optionally become event-assisted later
- Confirm query filters and selected fields for `SalesOrderHeadersV4`.
- Define retry/backoff behavior for imports that are still processing in D365.
- Define exception handling when multiple D365 records are returned for a single OMS `orderId`.

## Customer Payment Integration

### Sync Flow & Posting Strategy
1.  **Draft Creation**: OMS POSTs `CustomerPaymentJournalHeaders` then `CustomerPaymentJournalLines`.
2.  **Unposted State**: Journals created via OData are initially **Unposted** (`IsPosted = No`).
3.  **Batch Posting**: A scheduled D365 batch job (standard or custom) identifies these unposted journals and executes the "Post" business logic to move them to the subledger.

### Mappings
#### Header (`CustomerPaymentJournalHeaders`)
| D365 Field | Moqui Field | Usage / Notes |
| :--- | :--- | :--- |
| `dataAreaId` | `ProductStore.externalId` | Legal entity context. |
| `JournalName` | "CUSTPAY" | Fixed mapping for payment journals. |
| `Description` | "OMS Payment - SO [id]" | Reference for identifying the batch. |

#### Line (`CustomerPaymentJournalLines`)
| D365 Field | Moqui Field | Usage / Notes |
| :--- | :--- | :--- |
| `dataAreaId` | `ProductStore.externalId` | Legal entity context. |
| `JournalBatchNumber` | `JournalBatchNumber` | Linked from Header. |
| `AccountDisplayValue` | `partyId` | Customer Account (e.g., `HW-10001`). Must be escaped if needed. |
| `AccountType` | "Cust" | Fixed value. |
| `CreditAmount` | `OPP.maxAmount` | The settled amount. |
| `PaymentReference` | `d365SalesOrderNumber` | Links payment back to SO in D365. |
| `IsPrepayment` | "No" | Standard payment flow. |
| `OffsetAccountType` | `paymentMethodTypeId` | Typically "Bank". |
| `OffsetAccountDisplayValue` | `paymentMethodTypeId` | Bank account code (e.g., `USMF OPER`). |


### Implementation Steps
1. **View Entity**: `D365EligiblePaymentJournals`
    - Members: the entities `OrderHeader`, `OrderIdentification` (`D365_ORDER_ID`), `OrderPaymentPreference` (`PAYMENT_SETTLED`), and `ProductStore` (for `dataAreaId`).
    - Aliases: `orderId`, `d365SalesOrderNumber`, `orderPaymentPreferenceId`, `amount`, `paymentMethodTypeId`, `dataAreaId`, `partyId`.
2. **Service**: the service `sync#CustomerPayments`
    - Group eligible payments by `orderId`.
    - For each group:
        - POST `CustomerPaymentJournalHeaders` -> get `JournalBatchNumber`.
        - For each payment in group:
            - POST `CustomerPaymentJournalLines`.
            - TODO: Implement persistence for synced payments (e.g., `D365PaymentSyncHistory`).

### Sample Payload

#### POST Header
```json
{
 "dataAreaId": "usmf",
 "JournalName": "CUSTPAY",
 "Description": "OMS Payment Journal - SO 000887"
}
```

#### POST Line
```json
{
 "dataAreaId": "usmf",
 "JournalBatchNumber": "25135",
 "LineNumber": 1,
 "AccountType": "Cust",
 "AccountDisplayValue": "HW\\-02",
 "CurrencyCode": "USD",
 "CreditAmount": 80.00,
 "IsPrepayment": "No",
 "PaymentReference": "000887",
 "PaymentMethodName": "CASH",
 "OffsetAccountType": "Bank",
 "OffsetAccountDisplayValue": "USMF OPER"
}
```

---

## Outbound Integration (Business Events) TODO 
- [ ] **Endpoint Setup**: Create a REST service in Moqui to receive and validate Business Event notifications.
- [ ] **D365 Configuration**:
    - Register the Moqui endpoint in D365 (`System administration > Setup > Business events > Endpoints`).
    - Activate required events (e.g., `SalesOrderInvoicedBusinessEvent`).
- [ ] **Event Handling**: Implement logic in Moqui to process incoming events and trigger corresponding status updates or data pulls.

- [ ] Test connectivity with D365 Sandbox.
- [ ] Validate data integrity in D365.
- [ ] Verify outbound notification flow (D365 -> OMS).

---

## POS Completed Orders Sync

The order will be sent to D365 as part of the [Sales Order Sync](#sales-order-sync). Once the order is created, the following steps are performed to complete the lifecycle of a POS carry-out order:

1.  **Automated Packing Slip Posting**: Posts the packing slip to deduct inventory.
2.  **Automated Invoice Posting**: Programmatically posts the invoice to finalize the financial record for the sale.
3.  **Customer Payments Sync**: Synchronizes the payment details and creates payment journals (see [Customer Payment Integration](#customer-payment-integration)).
4.  **Automated Payment Posting & Settlement**: Posts the payment journal and settles it against the invoice.

### Implementation Strategy: OOTB vs. Custom Code

Many of these automated steps can be configured Out-Of-The-Box (OOTB) in Dynamics 365 using standard functionalities like Batch Jobs without requiring custom X++ development:

- **Automated Packing Slip Publishing**: Can be scheduled OOTB using standard D365 batch processing for eligible POS orders.
- **Automated Invoice Posting**: Can also be scheduled OOTB to automatically invoice orders that have been packing-slip updated.

**Custom Implementation Evaluation**
For processes that cannot be easily fully automated via standard OOTB batch jobs, we maintain a separate repository for custom D365 code: `/Users/gurveenkaur/Documents/Work/git/oms/moqui-framework/runtime/component/dynamics365-integration`.

Currently, we are evaluating if custom X++ logic (e.g., SysOperation jobs) is the **only way** to reliably automate:
- **Auto Post Payments**: Posting the Customer Payment Journals as soon as they are synced from the OMS.
- **Auto Settle Transactions**: Automatically settling the posted payment against the posted invoice for the POS order.

If OOTB configurations fall short for payments and settlements, custom services will be developed in the `dynamics365-integration` repository to handle these specific automated closures.
