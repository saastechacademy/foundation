# NetSuite Transfer Order Sync Design

Transfer Orders originate in NetSuite and are synchronized across these components:

1. `mantle-netsuite-connector` handles NetSuite feed import/export and mapping.
2. `oms` creates and approves Transfer Orders.
3. `poorti` handles Transfer Order fulfillment, shipment creation/update, receiving, and receipt reconciliation.
4. `netsuite-integration` contains the NetSuite SuiteScript objects, saved searches, CSV imports, and custom fields used by the Transfer Order sync.

This design covers the complete Transfer Order lifecycle for these three scenarios:

1. `Store to Store`
   Fulfillment happens in OMS and receiving happens in OMS.
2. `Store to Warehouse`
   Fulfillment happens in OMS and receiving happens outside OMS in NetSuite.
3. `Warehouse to Store`
   Fulfillment happens outside OMS in NetSuite and receiving happens in OMS.

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

## A. Transfer Order import from NetSuite to OMS

### System Message Types

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

### Service Jobs

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

5. `Generate_Transfer_Order_Sync_Ack_Feed`
   - Component: `mantle-netsuite-connector`
   - Purpose: acknowledge back to NetSuite that the Transfer Order has been created in OMS

6. `HC_SC_UpdateTransferOrders`
   - Component: `netsuite-integration`
   - Purpose: NetSuite scheduled script for Transfer Order update import

## B. Approve Transfer Orders in OMS

### Service Jobs

#### OMS jobs

1. `bulkApprove_StoreFulfillTransferOrders`
   - Component: `oms`
   - Purpose: approve OMS-fulfilled Transfer Orders
   - Covers: `Store to Store`, `Store to Warehouse`

2. `bulkApprove_WarehouseTransferOrders`
   - Component: `oms`
   - Purpose: approve external-fulfill Transfer Orders
   - Covers: `Warehouse to Store`

## C. OMS to NetSuite Fulfillment flow

Below feed is generated after OMS-side fulfillment for `Store to Store` and `Store to Warehouse` TOs.

### System Message Types

1. `TransferOrderShipmentFeed`
   - Component: `mantle-netsuite-connector`
   - Purpose: generate OMS shipment feed for NetSuite after OMS-side fulfillment

### Service Jobs

#### NetSuite / connector jobs

1. `generate_TransferOrderShipmentFeed`
   - Component: `mantle-netsuite-connector`
   - Purpose: generate OMS shipment feed for NetSuite after OMS-side fulfillment
   - Parameter: `systemMessageTypeId = TransferOrderShipmentFeed`

2. `HC_SC_ImportTOItemFulfillment_v2`
   - Component: `netsuite-integration`
   - Purpose: scheduled import/update of Transfer Order item fulfillment data in NetSuite

## D. NetSuite to OMS Fulfillment flow for Store fulfilled TOs

This is the Transfer Order fulfillment flow for store fulfillment feeds exported from NetSuite.
This is specially to store the External Shipment IDs of NetSuite in OMS.

### System Message Types

1. `ImportStoreToFulfillmentFeed`
   - Component: `mantle-netsuite-connector`
   - Purpose: poll NetSuite store fulfillment feed from SFTP
   - `consumeServiceName`: `co.hotwax.system.FeedServices.consume#NetsuiteFeed`
   - Related type: `OMSUpdateTOShipmentFeed`

2. `OMSUpdateTOShipmentFeed`
   - Component: `poorti`
   - Purpose: update Transfer Order shipment in OMS
   - `sendServiceName`: `co.hotwax.poorti.TransferOrderFulfillmentServices.update#TransferOrderShipment`

### Service Jobs

#### NetSuite / connector jobs

1. `HC_MR_ExportedStoreTOFulfillmentJson_v2`
   - Component: `netsuite-integration`
   - Purpose: NetSuite export job for store fulfillment feed

2. `poll_SystemMessageFileSftp_Store_TO_Fulfillment`
   - Component: `mantle-netsuite-connector`
   - Purpose: poll imported store fulfillment feed from SFTP
   - Parameter: `systemMessageTypeId = ImportStoreToFulfillmentFeed`

## E. NetSuite to OMS fulfillment flow for Warehouse Fulfilled TOs

This is the main fulfillment-import flow for `Warehouse to Store` TOs.

### System Message Types

1. `ImportWhToFulfillmentFeed`
   - Component: `mantle-netsuite-connector`
   - Purpose: poll NetSuite warehouse fulfillment feed from SFTP
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

### Service Jobs

#### NetSuite / connector jobs

1. `HC_MR_ExportedWHTOFulfillmentJson_v2`
   - Component: `netsuite-integration`
   - Purpose: NetSuite export job for warehouse fulfillment feed

2. `poll_SystemMessageFileSftp_Wh_TO_Fulfillment`
   - Component: `mantle-netsuite-connector`
   - Purpose: poll imported warehouse fulfillment feed from SFTP
   - Parameter: `systemMessageTypeId = ImportWhToFulfillmentFeed`

## F. OMS to NetSuite Receipt flow

### System Message Types

1. `TransferOrderShipmentReceiptFeed`
   - Component: `mantle-netsuite-connector`
   - Purpose: generate receipt feed for Transfer Orders received in OMS

### Service Jobs

#### NetSuite / connector jobs

1. `generate_TransferOrderShipmentReceiptFeed`
   - Component: `mantle-netsuite-connector`
   - Purpose: generate receipt feed for Transfer Orders received in OMS
   - Parameter: `systemMessageTypeId = TransferOrderShipmentReceiptFeed`

2. `HC_SC_ImportTOFulfillmentReceipts_v2`
   - Component: `netsuite-integration`
   - Purpose: scheduled import of Transfer Order fulfillment receipt data in NetSuite

## G. Other TO related feeds sent to NetSuite

These feeds are generated after receiving or completion processing in OMS:

### System Message Types

1. `TransferOrderReconciliationFeed`
   - Component: `mantle-netsuite-connector`
   - Purpose: send completed-item reconciliation details for Transfer Orders received in OMS

2. `TransferOrderMisShippedRcptFeed`
   - Component: `mantle-netsuite-connector`
   - Purpose: generate inventory adjustment feed for mis-shipped items received with the TO

3. `TOItemClosureFeed`
   - Component: `mantle-netsuite-connector`
   - Purpose: send completed Transfer Order item closure updates to NetSuite

### Service Jobs

#### NetSuite / connector jobs

1. `generate_TransferOrderReconciliationFeed`
   - Component: `mantle-netsuite-connector`
   - Purpose: send completed-item reconciliation details for Transfer Orders received in OMS
   - Parameter: `systemMessageTypeId = TransferOrderReconciliationFeed`

2. `HC_MR_CreateTOReceiptAndAdjustment`
   - Component: `netsuite-integration`
   - Purpose: NetSuite Map/Reduce script to create receipts and discrepancy adjustments

3. `Generate_TransferOrder_MisShipped_Rcpt_Feed`
   - Component: `mantle-netsuite-connector`
   - Purpose: generate inventory adjustment feed for mis-shipped items received with the TO
   - Parameter: `systemMessageTypeId = TransferOrderMisShippedRcptFeed`

4. `Generate_TO_Item_Closure_Feed`
   - Component: `mantle-netsuite-connector`
   - Purpose: send completed Transfer Order item closure updates to NetSuite
   - Parameter: `systemMessageTypeId = TOItemClosureFeed`

5. `HC_SC_ClosedUnreconcileTOItems`
   - Component: `netsuite-integration`
   - Purpose: NetSuite scheduled script to handle closed and unreconciled TO items

#### OMS jobs

1. `reconcile_TransferOrderReceipts`
   - Component: `poorti`
   - Purpose: Reconcile Transfer Order Receipt records to link the receipt created against the Order Item with the Shipment.
     Eg scenario - Wh to Store TO where TO is imported and receipts created against the order before the Shipment
     is imported in OMS from external system like NetSuite. For this, the assumption is that the record for OrderShipment for the TO item exists.


