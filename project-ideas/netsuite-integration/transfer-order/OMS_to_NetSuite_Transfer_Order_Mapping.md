# General OMS to NetSuite (NS) Transfer Order Lifecycle Mapping Document

This document outlines the data mapping between HotWax OMS and NetSuite during the Transfer Order lifecycle, leveraging the NetSuite REST Record API.

## 1. Poll Modified Transfer Orders
**NetSuite Endpoint**: `POST /query/v1/suiteql`

**Body**:
```json
{
  "q": "SELECT t.id, t.tranid, t.status, t.lastmodifieddate FROM transaction t WHERE t.type='TrnfrOrd' AND t.lastmodifieddate >= TO_TIMESTAMP('{{watermark}}','YYYY-MM-DD\"T\"HH24:MI:SS') ORDER BY t.lastmodifieddate ASC"
}
```
**Notes**: This periodic SuiteQL query retrieves Transfer Orders that have changed in NetSuite since the last `watermark` (timestamp). The results (NetSuite `id` and `status`) are synced back into OMS to keep the lifecycle up to date.

## 2. Create Transfer Order
**NetSuite Endpoint**: `POST /record/v1/transferorder`

| NetSuite Field | HotWax OMS Data Source | Notes |
| :--- | :--- | :--- |
| `subsidiary.id` | Configured subsidiary mapping context / `PartyGroup` identifier | Represents the NetSuite Subsidiary ID. |
| `location.id` | `facilityIdentification[facilityIdentificationTypeId = 'NETSUITE_LOCATION_ID'].value` | Source facility NetSuite ID (origin location). |
| `transferLocation.id` | `facilityIdentification[facilityIdentificationTypeId = 'NETSUITE_LOCATION_ID'].value` | Destination facility NetSuite ID (transfer location). |
| `item.items[n].item.id` | `goodIdentification[goodIdentificationTypeId = 'NETSUITE_PRODUCT_ID'].value` | NetSuite native Product ID. |
| `item.items[n].quantity` | Requested Transfer Quantity from OMS order item | Number of units to transfer. |

## 3. Approve Transfer Order
**NetSuite Endpoint**: `PATCH /record/v1/transferorder/{{transferOrderId}}`

| NetSuite Field | HotWax OMS Data Source | Notes |
| :--- | :--- | :--- |
| `orderStatus.id` | Hardcoded: `"B"` | Marks the order as Pending Fulfillment ("Approved"). |

## 4. Transform Transfer Order to Item Fulfillment
**OMS Trigger**: Shipment is packed/shipped in HotWax OMS.
**NetSuite Endpoint**: `POST /record/v1/transferorder/{{transferOrderId}}/!transform/itemFulfillment`

| NetSuite Field | HotWax OMS Data Source | Notes |
| :--- | :--- | :--- |
| `item.items[n].orderLine` | NetSuite line ID from `GET /transferorder/{{transferOrderId}}` | Links the fulfilled item to the original TO line in NetSuite. |
| `item.items[n].quantity` | Fulfilled/Shipped Quantity in OMS | Quantity that has been shipped. |
| `item.items[n].itemFulfill` | `true` | Boolean flag indicating fulfillment of this line. |
| `shipStatus.id` | Hardcoded: `"C"` | NetSuite shipping status ID. |
| `shipStatus.refName` | Hardcoded: `"Shipped"` | NetSuite shipping status name. |

## 5. Transform Transfer Order to Item Receipt
**OMS Trigger**: Shipment is received at the destination facility in HotWax OMS.
**NetSuite Endpoint**: `POST /record/v1/transferorder/{{transferOrderId}}/!transform/itemReceipt`

| NetSuite Field | HotWax OMS Data Source | Notes |
| :--- | :--- | :--- |
| `memo` | Hardcoded / OMS specific reference (e.g., `"HW Receipt Sync"`) | Contextual memo for the receipt in NetSuite. |
| `item.items[n].orderLine` | NetSuite line ID from `GET /transferorder/{{transferOrderId}}` | Links the received item to the original TO line in NetSuite. |
| `item.items[n].quantity` | Received Quantity from OMS shipment receipt | Quantity that has been received at the destination. |
| `item.items[n].itemreceive` | `true` | Boolean flag indicating receipt of this line. |
