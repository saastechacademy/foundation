# General OMS to NetSuite (NS) Return Mapping Document

This document outlines the data mapping between HotWax OMS and NetSuite during the returns process, synthesizing both Original Payment Method (OPM) and Store Credit return scenarios.

## 1. Create Return Merchandise Authorization (RMA) in NetSuite
**OMS Trigger**: Return is created and approved.
**NetSuite Endpoint**: `POST /returnAuthorization`

| NetSuite Field | HotWax OMS Data Source | Notes |
| :--- | :--- | :--- |
| `entity.id` | `partyIdentification[partyIdentificationTypeId = 'NETSUITE_CUSTOMER_ID' and partyId = returnHeader.fromPartyId].value` | The customer's NetSuite ID. |
| `custbody11` | `returnHeader.createdDate` | RMA creation date. |
| `custbody_hc_shopify_order_id`| `returnHeader.returnItem[n].orderId.externalId` | Original Shopify Order ID. |
| `custbody_hc_order_id` | `returnHeader.returnItem[n].orderId` | Internal OMS Order ID. |
| `item.items[n].item.id` | `goodIdentification[goodIdentificationTypeId = 'NETSUITE_PRODUCT_ID' and productId = returnHeader.returnItem[n].productId].value` | NetSuite native Product ID. |
| `item.items[n].price` | `-1` | Custom pricing context in NetSuite often uses -1 to enforce return/refund rate calculation. |
| `item.items[n].quantity` | `returnHeader.returnItem[n].quantity` | Quantity returned. |
| `item.items[n].rate` | `returnHeader.returnItem[n].returnPrice` | Refund price per unit. |
| `item.items[n].location.id` | `facilityIdentification[facilityIdentificationTypeId = 'NETSUITE_LOCATION_ID' and facilityId = returnHeader.destinationFacilityId].value` | The netSuite location ID for the return destination. |
| `shippingAddress.*` | `postalAddress` associated with `orderContactMech[returnHeader.returnItem[n].orderId]` | Mapped sub-fields include `addr1`, `addr2`, `city`, `state`, `zip`, and `country`. |

## 2. Store NetSuite RMA ID in OMS
**NetSuite Response**: Returns location in header (e.g., `/returnAuthorization/{{return_auth_id}}`).

| HotWax OMS Field | NetSuite Data Source |
| :--- | :--- |
| `returnIdentification.idValue` | `return_auth_id` from the NetSuite API response header. |
| `returnIdentificationTypeId` | Hardcoded: `NETSUITE_RMA_ID` |

## 3. Retrieve RMA from NetSuite & Store Line IDs
**NetSuite Endpoint**: `GET /returnAuthorization/{{return_auth_id}}`
**OMS Action**: Create `ReturnItemHistory` records linking OMS item sequence to NS line ID.

| HotWax OMS Field (`ReturnItemHistory`) | NetSuite Data Source / OMS Context |
| :--- | :--- |
| `returnId` | `returnHeader.returnId` |
| `returnItemSeqId` | `returnHeader.returnItem[n].returnItemSeqId` |
| `netsuiteRmaId` | `return_auth_id` fetched using `returnIdentification` |
| `netsuiteLineId` | `item.items[n].line` (Extracted from the NetSuite GET response) |

## 4. Transform RMA to Item Receipt
**OMS Trigger**: Shipment Receipt is completed (`shipmentReceipt` created).
**NetSuite Endpoint**: `POST /returnAuthorization/{{return_auth_id}}/!transform/itemReceipt`

| NetSuite Field | HotWax OMS Data Source | Notes |
| :--- | :--- | :--- |
| `item.items[n].orderLine` | `returnItemHistory[returnHeader.returnId AND returnItem.returnItemSeqId].netsuiteLineId`| Links the received item to the original RMA line in NetSuite. |
| `item.items[n].quantity` | `returnHeader.returnItem[n].quantity` | Received quantity. |
| `item.items[n].location.id`| `facilityIdentification[facilityIdentificationTypeId = 'NETSUITE_LOCATION_ID' and facilityId = returnHeader.destinationFacilityId].value` | Receiving facility NetSuite ID. |
| `item.items[n].itemReceive`| `true` | Boolean flag. |
| `item.items[n].restock` | `true` | Boolean flag. |
| `custbody_hc_shipment_receipt_id` | `shipmentReceipt.receiptId` | OMS Receipt ID (Applicable for OPM/stock returns). |

## 5. Refund Processing Scenarios

Depending on the refund method, NetSuite requires different downstream processing.

### Scenario A: Original Payment Method (OPM)
**NetSuite Endpoint**: Custom RESTlet (e.g., `/app/site/hosting/restlet.nl`) to create Credit Memo and Customer Refund.

| NetSuite Custom Payload Field | HotWax OMS Data Source |
| :--- | :--- |
| `rmaId` | `returnIdentification.idValue` |
| `location.id` | `facilityIdentification[facilityIdentificationTypeId = 'NETSUITE_LOCATION_ID' and facilityId = returnHeader.destinationFacilityId].value` |
| `refundMethodId` | `integrationTypeMapping[mappingTypeId = 'NETSUITE_PMT_MTHD' and mappedKey = orderPaymentPreference.paymentMethodTypeId].mappingValue` |

*After this call, OMS records the `creditMemoId` into `OrderPaymentPreference.finAccountId`.*

### Scenario B: Store Credit
When Store Credit is issued (often indicated by `shopify_store_credit` gateway or no inventory restocking), the process in NetSuite skips the Customer Refund. It requires closing the RMA lines and creating an Invoice offsetting the amount to liability accounts.

**Step 1: Close the RMA Lines**
**NetSuite Endpoint**: `POST {{record_base}}/returnAuthorization/{{return_auth_id}}`
| NetSuite Field | HotWax OMS Data Source |
| :--- | :--- |
| `item.items[n].line` | `returnItemHistory[returnItenSeqId = returnHeader.returnItem[n].returnItemSeqId and returnId = returnHeader.returnId].netsuiteLineId` |
| `item.items[n].isClosed`| `true` |

**Step 2: Create Invoice for Store Credit Liability**
**NetSuite Endpoint**: `POST {{record_base}}/invoice`
| NetSuite Field | HotWax OMS Data Source | Notes |
| :--- | :--- | :--- |
| `entity.id` | `partyIdentification[partyIdentificationTypeId = 'NETSUITE_CUSTOMER_ID' and partyId = returnHeader.fromPartyId].value` | Customer NetSuite ID. |
| `location` | `facilityIdentification[facilityIdentificationTypeId = 'NETSUITE_LOCATION_ID' and facilityId = returnHeader.destinationFacilityId].value` | Associated facility NetSuite ID. |
| `memo` | Hardcoded: `"Invoice created after RMA {{RMA_ID}} closed"` | Contextual memo. |
| `item.items[0].amount` | `orderPaymentPreference.maxAmount` | The stored credit amount. |
| `item.items[0].item.id`| Hardcoded NetSuite Item ID (e.g. `"39918"`) | Represents the Store Credit issuance item. |
| `item.items[1].amount` | `orderPaymentPreference.maxAmount.negate()`| Offsets the amount to balance the transaction. |
| `item.items[1].item.id`| Hardcoded NetSuite Item ID (e.g. `"39920"`) | Represents the offsetting liability item. |
