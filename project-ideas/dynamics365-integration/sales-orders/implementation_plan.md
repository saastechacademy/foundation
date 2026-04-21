# D365 Finance & Operations Integration Implementation Plan

This document outlines the technical design and implementation steps for integrating HotWax OMS with Microsoft Dynamics 365 Finance & Operations (D365 F&O).

## 1. Technical Architecture
- **Protocol**: OData v4 (REST)
- **Authentication**: OAuth 2.0 Client Credentials Flow via Azure AD.
- **Mapping Strategy**: 
    - **Legal Entity Mapping**: Moqui `ProductStore` / `Organization` -> D365 `dataAreaId`.
    - **Logic**: Every sync request must explicitly include the mapped `dataAreaId` to target the correct legal entity.

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
<entity entity-name="D365OrderSyncHistory" package="co.hotwax.d365.order">
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

- [ ] **Credentials Storage (`SystemMessageRemote`)**: 
    - Create `D365Auth` record in `SystemMessageRemote` entity.
    - Fields: 
      - `username` (Client ID), 
      - `password` (Client Secret - encrypted), 
      - `sharedSecret` (Tenant ID), 
      - `sendUrl` (Token Endpoint), 
      - `receiveUrl` (Instance Base URL).
      
- [ ] **Legal Entity Mapping**: 
    - Use `ProductStore.externalId` to store Moqui `ProductStore` -> D365 `dataAreaId` mapping.
  
- [ ] **Token Management**:
    - Implement `get#AzureAccessToken` service in `hotwax-d365` component.
    - Logic: Retrieve credentials from `D365Auth` SystemMessageRemote, call Azure OAuth2 endpoint, and cache the token.
  
- [ ] **Generic OData Client**: 
    - Implement `send#D365ODataRequest` service to handle token injection, base URL, and `dataAreaId` context.

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


## Sales Order Sync

### Eligible Orders View (`D365EligibleSalesOrders`)
- **Criteria**:
    - `OrderHeader.orderTypeId` = `SALES_ORDER`
    - `OrderHeader.statusId` = `ORDER_APPROVED` (or as per business requirement)
    - `OrderIdentification` for `D365_ORDER_ID` is null (not yet synced).
- **Aliases**: `orderId`, `orderDate`, `partyId` (BILL_TO_CUSTOMER), `productStoreId`.

#### Sync Strategy: Phased Roadmap

To handle the complexity of Sales Order documents (Header + Lines) and D365's transactional constraints, the implementation follows a phased approach:

#### Approach 1: OData with Idempotency
Used for rapid implementation and standard entity compatibility.

1. **Fetch Eligible Orders**: Query `D365EligibleSalesOrders` view.
2. **Process Each Order**:
    - **Customer Sync**: Call `sync#Customer` for the order's `partyId`.
    - **Sales Order Header (Idempotent)**:
        - **Find**: Search `SalesOrderHeadersV4` where `CustomersOrderReference eq 'orderId'`.
        - **Verify**: If found, capture existing `SalesOrderNumber`.
        - **Create**: If not found, `POST` to `/data/SalesOrderHeadersV4` (Set `CustomersOrderReference = orderId`).
    - **Sales Order Lines (Idempotent)**:
        - **Lookup**: Fetch existing `LineNumber`s for the `SalesOrderNumber`.
        - **Sync**: Iterate items; if `orderItemSeqId` exists in D365, skip; otherwise `POST` to `/data/SalesOrderLinesV3`.
    - **Atomic Persistence**: Only after **all** lines succeed, create Moqui `OrderIdentification` (`D365_ORDER_ID`).

#### Approach 2: Data Import Package (Current)
Used for larger volumes and asynchronous processing by bundling sales orders into a single Data Management Framework (DMF) package.

1. **Fetch Eligible Orders**: Query `D365EligibleSalesOrders` view in batches (e.g., limit 100).
2. **Customer Sync**: Create or verify customers synchronously via OData before bundling orders.
3. **Generate Package**: Bundle the order data into the `SalesOrdersCompositeV4` XML schema (`SALESORDERHEADERV3ENTITY`, `SALESORDERLINEV2ENTITY`, `SALESORDERHEADERCHARGEV2ENTITY`). Generate `Manifest.xml` and `PackageHeader.xml`, and archive them into a zip file.
4. **Blob Upload**: Call `GetAzureWriteUrl` to obtain an Azure Blob URL and `PUT` the zip file.
5. **Import Automation**: Trigger `/data/DataManagementDefinitionGroups/Microsoft.Dynamics.DataEntities.ImportFromPackage` with the mapped Blob URL.

**Currently Prepared Field Mappings (Data Package):**

| Entity | XML Attribute | Mapping from OMS Entities |
| :--- | :--- | :--- |
| `SALESORDERHEADERV3ENTITY` | `CUSTOMERSORDERREFERENCE` | `orderId` |
| `SALESORDERHEADERV3ENTITY` | `SALESORDERORIGINCODE` | `'Ecom'` |
| `SALESORDERHEADERV3ENTITY` | `DELIVERYMODECODE` | `'Standard'` |
| `SALESORDERHEADERV3ENTITY` | `ORDERINGCUSTOMERACCOUNTNUMBER` | D365 Customer account |
| `SALESORDERHEADERV3ENTITY` | `INVOICECUSTOMERACCOUNTNUMBER` | D365 Customer account |
| `SALESORDERHEADERV3ENTITY` | `CURRENCYCODE` | `currencyUomId` (default `USD`) |
| `SALESORDERHEADERV3ENTITY` | `DELIVERYADDRESSNAME` | `PostalAddress.toName` |
| `SALESORDERHEADERV3ENTITY` | `DELIVERYADDRESSDESCRIPTION` | `'OMS Ship To'` |
| `SALESORDERHEADERV3ENTITY` | `DELIVERYADDRESSSTREET` | `address1` + `address2` |
| `SALESORDERHEADERV3ENTITY` | `DELIVERYADDRESSCITY` | `city` |
| `SALESORDERHEADERV3ENTITY` | `DELIVERYADDRESSSTATEID` | `stateProvinceGeoId` |
| `SALESORDERHEADERV3ENTITY` | `DELIVERYADDRESSZIPCODE` | `postalCode` |
| `SALESORDERHEADERV3ENTITY` | `DELIVERYADDRESSCOUNTRYREGIONID` | `countryGeoId` |
| `SALESORDERLINEV2ENTITY` | `ITEMNUMBER` | `itemNumber` (default `1000`) |
| `SALESORDERLINEV2ENTITY` | `LINEDISCOUNTAMOUNT` | Item Discount Amount |
| `SALESORDERLINEV2ENTITY` | `LINENUMBER` | `orderItemSeqId` |
| `SALESORDERLINEV2ENTITY` | `ORDEREDSALESQUANTITY` | `quantity` |
| `SALESORDERLINEV2ENTITY` | `SALESPRICE` | `unitPrice` |
| `SALESORDERLINEV2ENTITY` | `SHIPPINGWAREHOUSEID` | `shippingWarehouseId` |
| `SALESORDERHEADERCHARGEV2ENTITY` | `FIXEDCHARGEAMOUNT` | Total calculated Shipping Cost |
| `SALESORDERHEADERCHARGEV2ENTITY` | `SALESCHARGECODE` | `'FREIGHT'` |

#### Approach 3: Custom Service / SysOperation (Future)
**TODO:** This approach is not yet implemented.

Designed for high-volume and guaranteed document atomicity.

1. **Atomic Request**: Send a single nested JSON document (Header + Lines) to a custom X++ service.
2. **Transactional Commit**: D365 creates the entire order within a single database transaction.
3. **Efficiency**: Reduces network overhead from `1 + N` requests to `1` request per order.

### Mappings
#### Header (`SalesOrderHeadersV4`)
| D365 Field | Moqui Field | Usage / Notes |
| :--- | :--- | :--- |
| `dataAreaId` | `ProductStore.externalId` | Legal entity context. |
| `CustomersOrderReference` | `OrderHeader.orderId` | OMS Order ID stored here. D365 auto-generates the `SalesOrderNumber`. |
| `OrderingCustomerAccountNumber` | `partyId` (BILL_TO) | The D365 `CustomerAccount`. |
| `InvoiceCustomerAccountNumber` | `partyId` (BILL_TO) | Same as Ordering Customer. |
| `CurrencyCode` | `currencyUomId` | e.g., `USD`. |
| `IsDeliveryAddressOrderSpecific` | "Yes" | Ensures address is unique to order. |
| `DeliveryAddressName` | `PostalAddress.toName` | |
| `DeliveryAddressDescription` | "OMS Ship To" | Fixed value. |
| `DeliveryAddressStreet` | `address1` + `address2` | Concatenated. |
| `DeliveryAddressCity` | `city` | |
| `DeliveryAddressStateId` | `stateProvinceGeoId` | State code (e.g., `CA`). |
| `DeliveryAddressZipCode` | `postalCode` | |
| `DeliveryAddressCountryRegionId` | `countryGeoId` | Standard 3-letter code (e.g., `USA`). |
| **TODO** | `placedDate` | **TODO**: No direct field on `SalesOrderHeaderV4` for the original order placement date (`OrderCreationDateTime` is when created in D365). |
| **TODO** | Shopify Order Id/Name | **TODO**: Haven't found a place in the OData payload to map Shopify identity strings. |
| **TODO** | Ship-to Phone | **TODO**: Cannot find direct field on `SalesOrderHeaderV4` for shipping destination phone. |

#### Line (`SalesOrderLinesV3`)
| D365 Field | Moqui Field | Usage / Notes |
| :--- | :--- | :--- |
| `dataAreaId` | `ProductStore.externalId` | Legal entity context. |
| `SalesOrderNumber` | `SalesOrderNumber` | Linked to Header. |
| `ItemNumber` | `itemNumber` | **TODO**: Needs strict mapping to underlying `D365_PRODUCT_ID` via `ProductIdentification`. Currently defaults to '1000'. |
| `ProductColorId` | **TODO** | **TODO**: Variant dimensions strictly needed by D365. Define storage in OMS (`ProductIdentification`) and map here. |
| `ProductSizeId` | **TODO** | **TODO**: Variant dimension mapping. |
| `ProductStyleId` | **TODO** | **TODO**: Variant dimension mapping. |
| `ProductConfigurationId` | **TODO** | **TODO**: Variant dimension mapping. |
| `LineNumber` | `orderItemSeqId` | Numeric sequence. |
| `OrderedSalesQuantity` | `quantity` | |
| `SalesPrice` | `unitPrice` | |
| `ShippingWarehouseId` | `shippingWarehouseId` | External ID of the fulfillment warehouse (currently filtered by `WH_ONLY_FULFILLMENT`; TODO: use a dedicated D365 Facility Group). |
| `LineDiscountAmount` | `getItemDiscountAmount()` | Calculated from `OrderAdjustment` of type `EXT_PROMO_ADJUSTMENT`. |


### Prerequisites & TODOs
> [!IMPORTANT]
> - Customer must exist and not be on hold.
> - Products must be "Released" to the Legal Entity.
> - Every line requires a valid `InventorySiteId` and `InventoryWarehouseId`.

- **TODO**: [Mapping] Define `facilityId` to D365 `InventorySiteId/WarehouseId` mapping.
- **TODO**: [Mapping] Create mapping table for `TaxCategory` -> `ItemSalesTaxGroup`.

## Integration Type Mappings
To avoid hardcoding values like `SalesOrderOriginCode` and `DeliveryModeCode` in service logic, we use the `IntegrationTypeMapping` entity to translate OMS identifiers into D365 codes.

### Configuration Structure
Add records to `co.hotwax.integration.IntegrationTypeMapping` for the target system:

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

## Sample Requests

### Customer Creation (`CustomersV3`)
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

### Sales Order Header (`SalesOrderHeadersV4`)
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

### Sales Order Line (`SalesOrderLinesV3`)
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
    - Members: `OrderHeader`, `OrderIdentification` (D365_ORDER_ID), `OrderPaymentPreference` (PAYMENT_SETTLED), `ProductStore` (for dataAreaId).
    - Aliases: `orderId`, `d365SalesOrderNumber`, `orderPaymentPreferenceId`, `amount`, `paymentMethodTypeId`, `dataAreaId`, `partyId`.
2. **Service**: `sync#CustomerPayments`
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
