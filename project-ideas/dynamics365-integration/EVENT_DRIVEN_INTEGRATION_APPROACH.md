# Proposal: Event-Driven Integration (Outbox Pattern) for ERP Systems (D365/NetSuite)

## Overview
This document proposes a standardized, decoupling-first approach to integrating Moqui's Order/Return/Shipment data with external ERP systems like Dynamics 365 and NetSuite.

## The Problem
Many traditional integrations in Moqui either rely on manual "sweeps" (polling) of entity tables or complex `service-call` chains that happen synchronously during user actions. This leads to:
1. **Performance Bottlenecks**: High-latency API calls to external systems block UI threads or database transactions.
2. **Atomicity Issues**: If an integration service fails after a database change, the external system is out of sync.
3. **Difficult Monitoring**: No centralized "Integration Table" to track which events have been logged but not yet sent.

## The Solution: Moqui "Outbox" Pattern (Event-Driven)
We propose leveraging Moqui's native `DataFeed` and `DataDocument` infrastructure to implement an asynchronous **Outbox Pattern**, driven by status history events.

### 1. Immutable Event Detection (`OrderStatus` / `ShipmentStatus`)
Instead of polling the header tables (where fields can change multiple times), we monitor the **Status History** entities. 
- **Mechanism**: Every status change creates a *new* record in the history table. By making this the primary entity of our `DataFeed`, we ensure that the integration triggers exactly **once** per status transition.
- **Transactional Integrity**: The `DataFeed` only fires after a successful database commit, ensuring data consistency.

## 2. Outbox Implementation Options
Once a `DataFeed` triggers, the event is logged to a persistent store:

### Option A: Custom Integration Table (Manual Outbox)
- **Flow**: `DataFeed` -> `log#IntegrationEvent` -> `D365IntegrationEvent`.
- **Pros**: Highly specialized for D365 specifics (like custom batch IDs).
- **Cons**: Requires manual development of status management and retry logic.

### Option B: SystemMessage (Framework Native)
- **Flow**: `DataFeed` -> `log#IntegrationEvent` -> `SystemMessage`.
- **Pros**: Built-in error capturing (full stack traces), retry limits, and a professional Monitoring UI.
- **Cons**: Fixed status types.

## 3. Comparative Tradeoff Analysis

| Feature | Custom Integration Table | **SystemMessage (Framework)** |
| :--- | :--- | :--- |
| **Development Effort** | **High** (Build status/retry logic from scratch). | **Low** (Reuse existing framework code). |
| **Error Logging** | Manual (Must store API error text). | **Automatic** (Captures full Java stack traces). |
| **Monitoring UI** | Requires building a custom Screen. | **Standard Screen** (`SystemMessage`). |
| **Reliability** | Depends on custom service quality. | **Proven** (Used globally in Moqui integrations). |

## Event Mapping Table
The following table defines the proposed mappings using the **Event-First** approach.

| Event | Primary Entity (History) | Related Entity | Trigger Condition |
| :--- | :--- | :--- | :--- |
| **Order Created** | `OrderStatus` | `OrderHeader` | `statusId == 'ORDER_CREATED'` |
| **Order Cancelled** | `OrderStatus` | `OrderHeader` | `statusId == 'ORDER_CANCELLED'` |
| **Order Fulfillment** | `ShipmentStatus` | `Shipment` | `statusId == 'SHIPMENT_SHIPPED'` |
| **Return Completed** | `ReturnStatus` | `ReturnHeader` | New `RETURN_COMPLETED` record |
 
## Implementation Examples (XML Definition)

### 1. Sales Order Created
```xml
<moqui.entity.document.DataDocument dataDocumentId="SalesOrderCreated" 
    primaryEntityName="org.apache.ofbiz.order.order.OrderStatus" indexName="order_events">
    <fields fieldSeqId="01" fieldPath="orderId"/>
    <fields fieldSeqId="02" fieldPath="statusId"/>
    <fields fieldSeqId="03" fieldPath="statusDatetime"/>
    <fields fieldSeqId="04" fieldPath="OrderHeader:orderTypeId"/>
    
    <fields fieldSeqId="05" fieldPath="OrderHeader:productStoreId"/>

    <conditions conditionSeqId="01" fieldNameAlias="statusId" fieldValue="ORDER_CREATED"/>
    <conditions conditionSeqId="02" fieldNameAlias="orderTypeId" fieldValue="SALES_ORDER"/>
</moqui.entity.document.DataDocument>
```

### 2. Sales Order Cancelled
```xml
<moqui.entity.document.DataDocument dataDocumentId="SalesOrderCancelled" 
    primaryEntityName="org.apache.ofbiz.order.order.OrderStatus" indexName="order_events">
    <fields fieldSeqId="01" fieldPath="orderId"/>
    <fields fieldSeqId="02" fieldPath="statusId"/>
    <fields fieldSeqId="03" fieldPath="OrderHeader:orderTypeId"/>
    
    <fields fieldSeqId="04" fieldPath="statusDatetime"/>
    
    <conditions conditionSeqId="01" fieldNameAlias="statusId" fieldValue="ORDER_CANCELLED"/>
    <conditions conditionSeqId="02" fieldNameAlias="orderTypeId" fieldValue="SALES_ORDER"/>
</moqui.entity.document.DataDocument>
```

### 3. Sales Order Fulfillment (Shipped)
```xml
<moqui.entity.document.DataDocument dataDocumentId="SalesOrderFulfillment" 
    primaryEntityName="org.apache.ofbiz.shipment.shipment.ShipmentStatus" indexName="shipment_events">
    <fields fieldSeqId="01" fieldPath="shipmentId"/>
    <fields fieldSeqId="02" fieldPath="statusId"/>
    <fields fieldSeqId="03" fieldPath="Shipment:shipmentTypeEnumId"/>
    
    <fields fieldSeqId="04" fieldPath="statusDatetime"/>

    <conditions conditionSeqId="01" fieldNameAlias="statusId" fieldValue="SHIPMENT_SHIPPED"/>
</moqui.entity.document.DataDocument>
```

### 4. Sales Order Return Completed
```xml
<moqui.entity.document.DataDocument dataDocumentId="SalesOrderReturnCompleted" 
    primaryEntityName="org.apache.ofbiz.order.return.ReturnStatus" indexName="return_events">
    <fields fieldSeqId="01" fieldPath="returnId"/>
    <fields fieldSeqId="02" fieldPath="statusId"/>
    <fields fieldSeqId="03" fieldPath="statusDatetime"/>

    <conditions conditionSeqId="01" fieldNameAlias="statusId" fieldValue="RETURN_COMPLETED"/>
</moqui.entity.document.DataDocument>
```

 
 ## Data Feed Configuration
 Multiple `DataDocument`s can be attached to the same `DataFeed` to funnel all related events into a single dispatcher service.
 
 ```xml
 <moqui.entity.feed.DataFeed dataFeedId="SalesOrderCreated" 
     feedTypeEnumId="DTFDTP_RT_PUSH" 
     feedReceiveServiceName="co.hotwax.integration.IntegrationServices.log#OrderEvent">
     <documents dataDocumentId="SalesOrderCreated"/>
 </moqui.entity.feed.DataFeed>
 
 <moqui.entity.feed.DataFeed dataFeedId="SalesOrderCancelled" 
     feedTypeEnumId="DTFDTP_RT_PUSH" 
     feedReceiveServiceName="co.hotwax.integration.IntegrationServices.log#OrderEvent">
     <documents dataDocumentId="SalesOrderCancelled"/>
 </moqui.entity.feed.DataFeed>
 
 <moqui.entity.feed.DataFeed dataFeedId="SalesOrderFulfillment" 
     feedTypeEnumId="DTFDTP_RT_PUSH" 
     feedReceiveServiceName="co.hotwax.integration.IntegrationServices.log#ShipmentEvent">
     <documents dataDocumentId="SalesOrderFulfillment"/>
 </moqui.entity.feed.DataFeed>
 
 <moqui.entity.feed.DataFeed dataFeedId="SalesOrderReturnCompleted" 
     feedTypeEnumId="DTFDTP_RT_PUSH" 
     feedReceiveServiceName="co.hotwax.integration.IntegrationServices.log#ReturnEvent">
     <documents dataDocumentId="SalesOrderReturnCompleted"/>
 </moqui.entity.feed.DataFeed>
 ```
 
 ## Benefits
- **Atomicity**: The `DataFeed` mechanism ensures the outbox log is created only if the business transaction succeeds.
- **Deduplication**: History-based triggering naturally prevents redundant events for a single transition.
- **Traceability**: All outbound messages are auditable via the framework's native tools.
- **Scalability**: Decoupling allows for high-throughput background processing without impact on customer-facing performance.
