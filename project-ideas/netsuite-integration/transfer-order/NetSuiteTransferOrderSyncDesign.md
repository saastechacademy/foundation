# NetSuite Transfer Order Sync Design

Transfer Orders originate in NetSuite and are synchronized across three components:

1. `mantle-netsuite-connector` handles NetSuite feed import/export and mapping.
2. `oms` creates and approves Transfer Orders.
3. `poorti` handles Transfer Order fulfillment, shipment creation/update, receiving, and receipt reconciliation.
4. `netsuite-integration` contains the NetSuite SuiteScript objects, saved searches, CSV imports, and custom fields used by the Transfer Order sync.

This design covers the complete Transfer Order lifecycle for these three scenarios:

1. `Store to Store`
   Fulfillment happens in OMS and receiving happens in OMS.
2. `Store to Warehouse`
   Fulfillment happens in OMS and receiving happens outside OMS.
3. `Warehouse to Store`
   Fulfillment happens in NetSuite and receiving happens in OMS.

## NetSuite SuiteScript Component

The NetSuite-specific scripts for Transfer Orders are maintained under:
`runtime/component/netsuite-integration/src/Objects/TransferOrderV2`

In this component:
1. `MR` means `Map/Reduce Script`
2. `SC` means `Scheduled Script`

In practice:
1. `MR` scripts are used mainly for export and batch creation/update processing
2. `SC` scripts are used mainly for import/update execution steps in NetSuite

### Transfer Order V2 NetSuite scripts

#### Map/Reduce scripts

1. `HC_MR_ExportedStoretoStoreTOJson_v2`
   - NetSuite export of `Store to Store` Transfer Orders
   - Object: `customscript_hc_mr_exp_str_str_to_v2.xml`

2. `HC_MR_ExportedStoretoWhTOJson_v2`
   - NetSuite export of `Store to Warehouse` Transfer Orders
   - Object: `customscript_hc_mr_exp_store_wh_to_v2.xml`

3. `HC_MR_ExportedWhtoStoreTOJson_v2`
   - NetSuite export of `Warehouse to Store` Transfer Orders
   - Object: `customscript_hc_mr_exp_wh_store_to_v2.xml`

4. `HC_MR_ExportedStoreTOFulfillmentJson_v2`
   - NetSuite export of store-managed Transfer Order fulfillments
   - Object: `customscript_hc_mr_exp_st_to_fulfil_v2.xml`

5. `HC_MR_ExportedWHTOFulfillmentJson_v2`
   - NetSuite export of warehouse-managed Transfer Order fulfillments
   - Object: `customscript_hc_mr_exp_wh_to_ful_v2.xml`

6. `HC_MR_CreateTOReceiptAndAdjustment`
   - NetSuite processing of Transfer Order receipts and discrepancy adjustments
   - Object: `customscript_hc_toreceiptandadjustment.xml`

#### Scheduled scripts

1. `HC_SC_ImportTOItemFulfillment_v2`
   - NetSuite scheduled import/update of Transfer Order item fulfillment data
   - Object: `customscript_imp_to_itemfulfillment_v2.xml`

2. `HC_SC_ImportTOFulfillmentReceipts_v2`
   - NetSuite scheduled import of Transfer Order fulfillment receipt data
   - Object: `customscript_hc_imp_to_fulfil_rcpt_v2.xml`

3. `HC_SC_UpdateTransferOrders`
   - NetSuite scheduled update of Transfer Orders from OMS-generated feeds
   - Object: `customscript_hc_sc_updatetransferorders.xml`

4. `HC_SC_ClosedUnreconcileTOItems`
   - NetSuite scheduled processing for closed/unreconciled Transfer Order items
   - Object: `customscript_hc_closedunreconciletoitems.xml`

#### Supporting searches and objects

These scripts depend on NetSuite objects stored in the same component:

1. Saved searches for Transfer Order exports and fulfillment exports
2. CSV import definition for Transfer Order updates
3. Transfer Order custom body and line fields such as:
   - shipment id
   - shipment item sequence id
   - closed flag
   - discrepancy quantity

These NetSuite objects support the connector-side jobs documented below.

## Transfer Order Lifecycle

### Lifecycle Matrix

| TO Type | Exported From | statusFlowId in OMS | Approved In | Fulfilled In | Shipment Created In | Received In | Inbound NetSuite Feeds | Outbound NetSuite Feeds |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Store to Store | NetSuite | `TO_Fulfill_And_Receive` | OMS | OMS | OMS | OMS | `ImportTransferOrderFeed` | `TransferOrderShipmentFeed`, `TransferOrderShipmentReceiptFeed`, item closure, reconciliation, mis-shipped adjustment |
| Store to Warehouse | NetSuite | `TO_Fulfill_Only` | OMS | OMS | OMS | Outside OMS | `ImportTransferOrderFeed` | `TransferOrderShipmentFeed` |
| Warehouse to Store | NetSuite | `TO_Receive_Only` | OMS | NetSuite | OMS from imported fulfillment | OMS | `ImportTransferOrderFeed`, `ImportWhToFulfillmentFeed` | `TransferOrderShipmentReceiptFeed`, item closure, reconciliation, mis-shipped adjustment |

### statusFlowId by Transfer Order Type

1. `Store to Warehouse` uses `TO_Fulfill_Only`
2. `Warehouse to Store` uses `TO_Receive_Only`
3. `Store to Store` uses `TO_Fulfill_And_Receive`

### Lifecycle Summary

### 1. Transfer Order Creation in OMS

All three Transfer Order types are first exported from NetSuite and created in OMS.

Flow:
1. NetSuite exports Transfer Order feed.
2. `mantle-netsuite-connector` polls and imports the feed.
3. `mantle-netsuite-connector` maps the NetSuite payload to OMS Transfer Order payload.
4. `oms` consumes the mapped feed and creates the Transfer Order.
5. `oms` approval jobs move the TO from `ORDER_CREATED` to `ORDER_APPROVED`.

### 2. Transfer Orders Fulfilled in OMS

This flow applies to:
1. `Store to Store`
2. `Store to Warehouse`

Flow:
1. Transfer Order is created in OMS from NetSuite export.
2. OMS approval jobs approve the TO.
3. `poorti` creates or updates Transfer Order shipments in OMS.
4. OMS-managed fulfillment is completed in stores.
5. `mantle-netsuite-connector` generates shipment feed from OMS and sends it to NetSuite so fulfillment can be created there.
6. For `Store to Store`, receiving happens in OMS after shipment reaches the destination store.
7. After receiving in OMS, `mantle-netsuite-connector` generates receipt-related feeds for NetSuite.

### 3. Transfer Orders Fulfilled in NetSuite

This flow applies to:
1. `Warehouse to Store`

Flow:
1. Transfer Order is created in OMS from NetSuite export.
2. OMS approval jobs approve the TO with receive-only lifecycle.
3. Fulfillment is completed in NetSuite by the warehouse.
4. NetSuite exports fulfillment feed.
5. `mantle-netsuite-connector` polls the fulfillment feed and maps it to OMS shipment payload.
6. `poorti` creates the Transfer Order shipment in OMS, generally in `SHIPMENT_SHIPPED` state for external warehouse fulfillment.
7. Receiving happens in OMS at the destination store.
8. After receiving in OMS, `mantle-netsuite-connector` generates receipt-related feeds for NetSuite.

## System Message Types

### A. Transfer Order import from NetSuite to OMS

1. `ImportTransferOrderFeed`
   - Component: `mantle-netsuite-connector`
   - Purpose: poll NetSuite Transfer Order feed from SFTP
   - `consumeServiceName`: `co.hotwax.system.FeedServices.consume#NetsuiteFeed`
   - Related type: `GenerateOMSTransferOrderFeed`

2. `GenerateOMSTransferOrderFeed`
   - Component: `mantle-netsuite-connector`
   - Purpose: map NetSuite Transfer Orders to OMS Transfer Order payload
   - `consumeServiceName`: `co.hotwax.system.FeedServices.generate#OMSFeed`
   - `sendServiceName`: `co.hotwax.netsuite.TransferOrderServices.map#TransferOrder`
   - Related type: `OMSTransferOrderFeed`

3. `OMSTransferOrderFeed`
   - Component: `oms`
   - Purpose: create Transfer Orders in OMS
   - `sendServiceName`: `co.hotwax.orderledger.order.TransferOrderServices.create#TransferOrder`

### B. NetSuite fulfillment import to OMS for warehouse-fulfilled TOs

This is the main fulfillment-import flow for `Warehouse to Store` TOs.

1. `ImportWhToFulfillmentFeed`
   - Component: `mantle-netsuite-connector`
   - Purpose: import warehouse fulfillment feed from NetSuite
   - `consumeServiceName`: `co.hotwax.system.FeedServices.consume#NetsuiteFeed`
   - Related type: `GenerateOMSCreateTOShipmentFeed`

2. `GenerateOMSCreateTOShipmentFeed`
   - Component: `mantle-netsuite-connector`
   - Purpose: map warehouse fulfillment payload to OMS Transfer Order shipment payload
   - `consumeServiceName`: `co.hotwax.system.FeedServices.generate#OMSFeed`
   - `sendServiceName`: `co.hotwax.netsuite.TransferOrderServices.map#WhTransferOrderFulfillment`
   - Related type: `OMSCreateTOShipmentFeed`

3. `OMSCreateTOShipmentFeed`
   - Component: `poorti`
   - Purpose: create Transfer Order shipment in OMS from external warehouse fulfillment
   - `sendServiceName`: `co.hotwax.poorti.TransferOrderFulfillmentServices.create#TransferOrderShipment`

### C. NetSuite fulfillment import to OMS for store fulfillment feed

This is an additional Transfer Order fulfillment import path available in the connector for store fulfillment feeds exported from NetSuite.

1. `ImportStoreToFulfillmentFeed`
   - Component: `mantle-netsuite-connector`
   - Purpose: import store fulfillment feed from NetSuite
   - `consumeServiceName`: `co.hotwax.system.FeedServices.consume#NetsuiteFeed`
   - Related type: `OMSUpdateTOShipmentFeed`

2. `OMSUpdateTOShipmentFeed`
   - Component: `poorti`
   - Purpose: update Transfer Order shipment in OMS
   - `sendServiceName`: `co.hotwax.poorti.TransferOrderFulfillmentServices.update#TransferOrderShipment`

### D. OMS to NetSuite shipment and receipt feeds

These feeds are generated after OMS-side fulfillment or OMS-side receiving.

1. `TransferOrderShipmentFeed`
   - Component: `mantle-netsuite-connector`
   - Purpose: send OMS-managed Transfer Order shipment details to NetSuite

2. `TransferOrderShipmentReceiptFeed`
   - Component: `mantle-netsuite-connector`
   - Purpose: send OMS receiving details to NetSuite

3. `TransferOrderReconciliationFeed`
   - Component: `mantle-netsuite-connector`
   - Purpose: send completed-item reconciliation details for Transfer Orders received in OMS

### E. Receipt and completion updates sent to NetSuite

These feeds are generated after receiving or completion processing in OMS:

1. `TransferOrderShipmentReceiptFeed`
   - Used when OMS records accepted Transfer Order receipts and NetSuite needs corresponding item receipt updates

2. `Generate_TransferOrder_MisShipped_Rcpt_Feed`
   - Used when OMS records mis-shipped items received with the Transfer Order and NetSuite needs inventory adjustment updates

3. `Generate_TO_Item_Closure_Feed`
   - Used when Transfer Order items are completed in OMS and NetSuite item lines need to be closed

4. `generate_TransferOrderReconciliationFeed`
   - Used when completed Transfer Order items need reconciliation updates in NetSuite after OMS-side processing

## Service Jobs

### A. Jobs for Transfer Order creation in OMS

#### NetSuite / connector jobs

1. `HC_MR_ExportedStoretoStoreTOJson_v2`
   - Component: `netsuite-integration`
   - Purpose: NetSuite export job for `Store to Store` TOs

2. `HC_MR_ExportedStoretoWhTOJson_v2`
   - Component: `netsuite-integration`
   - Purpose: NetSuite export job for `Store to Warehouse` TOs

3. `HC_MR_ExportedWhtoStoreTOJson_v2`
   - Component: `netsuite-integration`
   - Purpose: NetSuite export job for `Warehouse to Store` TOs

4. `poll_SystemMessageFileSftp_TransferOrder`
   - Component: `mantle-netsuite-connector`
   - Purpose: poll imported Transfer Order feed from SFTP
   - Parameter: `systemMessageTypeId = ImportTransferOrderFeed`

#### OMS jobs

1. `bulkApprove_StoreFulfillTransferOrders`
   - Component: `oms`
   - Purpose: approve OMS-fulfilled Transfer Orders
   - Covers: `Store to Store`, `Store to Warehouse`

2. `bulkApprove_WarehouseTransferOrders`
   - Component: `oms`
   - Purpose: approve external-fulfill Transfer Orders
   - Covers: `Warehouse to Store`

### B. Jobs for Transfer Orders fulfilled in OMS

These flows primarily apply to `Store to Store` and `Store to Warehouse`.

1. `generate_TransferOrderShipmentFeed`
   - Component: `mantle-netsuite-connector`
   - Purpose: generate OMS shipment feed for NetSuite after OMS-side fulfillment

2. `Generate_Transfer_Order_Sync_Ack_Feed`
   - Component: `mantle-netsuite-connector`
   - Purpose: acknowledge back to NetSuite that the Transfer Order has been created in OMS

### C. Jobs for Transfer Orders fulfilled in NetSuite

This flow applies to NetSuite-managed fulfillment flows, including `Warehouse to Store`, and also covers store fulfillment feeds exported from NetSuite when used.

1. `HC_MR_ExportedWHTOFulfillmentJson_v2`
   - Component: `netsuite-integration`
   - Purpose: NetSuite export job for warehouse fulfillment feed

2. `HC_MR_ExportedStoreTOFulfillmentJson_v2`
   - Component: `netsuite-integration`
   - Purpose: NetSuite export job for store fulfillment feed

3. `poll_SystemMessageFileSftp_Wh_TO_Fulfillment`
   - Component: `mantle-netsuite-connector`
   - Purpose: poll warehouse fulfillment feed from SFTP
   - Parameter: `systemMessageTypeId = ImportWhToFulfillmentFeed`

4. `poll_SystemMessageFileSftp_Store_TO_Fulfillment`
   - Component: `mantle-netsuite-connector`
   - Purpose: poll store fulfillment feed from SFTP
   - Parameter: `systemMessageTypeId = ImportStoreToFulfillmentFeed`

5. `HC_SC_ImportTOItemFulfillment_v2`
   - Component: `netsuite-integration`
   - Purpose: NetSuite scheduled script for Transfer Order item fulfillment import

6. `HC_SC_UpdateTransferOrders`
   - Component: `netsuite-integration`
   - Purpose: NetSuite scheduled script for Transfer Order update import

### D. Jobs for receiving in OMS and sending updates to NetSuite

Receiving happens in OMS for:
1. `Store to Store`
2. `Warehouse to Store`

The related jobs are:

1. `generate_TransferOrderShipmentReceiptFeed`
   - Component: `mantle-netsuite-connector`
   - Purpose: generate receipt feed for Transfer Orders received in OMS

2. `Generate_TransferOrder_MisShipped_Rcpt_Feed`
   - Component: `mantle-netsuite-connector`
   - Purpose: generate inventory adjustment feed for mis-shipped items received with the TO

3. `Generate_TO_Item_Closure_Feed`
   - Component: `mantle-netsuite-connector`
   - Purpose: send completed Transfer Order item closure updates to NetSuite

4. `generate_TransferOrderReconciliationFeed`
   - Component: `mantle-netsuite-connector`
   - Purpose: send completed-item reconciliation feed to NetSuite

5. `HC_SC_ImportTOFulfillmentReceipts_v2`
   - Component: `netsuite-integration`
   - Purpose: NetSuite scheduled script to import OMS receipt updates

6. `HC_MR_CreateTOReceiptAndAdjustment`
   - Component: `netsuite-integration`
   - Purpose: NetSuite Map/Reduce script to create receipts and discrepancy adjustments

7. `HC_SC_ClosedUnreconcileTOItems`
   - Component: `netsuite-integration`
   - Purpose: NetSuite scheduled script to handle closed and unreconciled TO items

8. `reconcile_TransferOrderReceipts`
   - Component: `poorti`
   - Purpose: reconcile Transfer Order receipts in OMS

## Flow by Transfer Order Type

### Store to Store

1. NetSuite exports TO.
2. Connector imports and maps TO feed.
3. OMS creates and approves TO.
4. OMS fulfills TO in store.
5. Connector generates shipment feed for NetSuite.
6. Destination store receives TO in OMS.
7. Connector generates receipt, closure, mis-shipped, and reconciliation feeds for NetSuite.

### Store to Warehouse

1. NetSuite exports TO.
2. Connector imports and maps TO feed.
3. OMS creates and approves TO.
4. OMS fulfills TO in store.
5. Connector generates shipment feed for NetSuite.
6. Receiving happens outside OMS.

### Warehouse to Store

1. NetSuite exports TO.
2. Connector imports and maps TO feed.
3. OMS creates and approves TO.
4. Warehouse fulfills TO in NetSuite.
5. Connector imports warehouse fulfillment feed.
6. Poorti creates shipment in OMS in shipped state.
7. Destination store receives TO in OMS.
8. Connector generates receipt, closure, mis-shipped, and reconciliation feeds for NetSuite.
