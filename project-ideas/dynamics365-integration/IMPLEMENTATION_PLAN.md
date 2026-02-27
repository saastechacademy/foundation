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

## Phase 0: Data Model (D365 Specific)
Implementation site: `runtime/component/hotwax-d365/entity/D365Entities.xml`

To track synchronization events and map D365 external identifiers back to Moqui entities without cluttering core tables, we use specific history entities.

### 0.1 Order Sync History
Used to store the D365 Sales Order Number against the OMS Order ID upon successful creation in D365.

> [!NOTE]
> **TODO**: We are not using this entity for now since we are using `OrderIdentification` record to identify the sales order which is not sent from OMS to D365. Since we are using REST, once we receive the `salesOrderNumber`, we will create the `OrderIdentification` record.

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

## Phase 1: Foundation

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

## Phase 2: Customer Synchronization
### 2.1 Sync Service Logic (`sync#Customer`)
1. **Remote Lookup**: Call `GET /data/CustomersV3` with `$filter` by `CustomerAccount eq 'partyId'`.
2. **Creation**: If not found, `POST /data/CustomersV3`.
    - Map `Party.partyId` -> `CustomerAccount`.
    - Provide mandatory fields: `dataAreaId`, `PartyType`, `CustomerGroupId`, `SalesCurrencyCode`.
3. **Outcome**: The `partyId` is used directly as the `CustomerAccount` in D365. No local identification record is required.
   - **TODO** Check to send the Shopify Customer Id here, and decide if we should have CustomerAccount field as auto created in D365 or we can continue to send unique identifier from OMS.

### 2.2 Mapping (`CustomersV3`)
| D365 Field | Moqui Field               | Usage / Notes |
| :--- |:--------------------------| :--- |
| `CustomerAccount` | `Party.partyId`           | Primary identifier in D365. |
| `dataAreaId` | `ProductStore.externalId` | Legal entity context. |
| `PersonFirstName` | `Person.firstName`        | Only for `PartyType` = `Person`. |
| `PersonLastName` | `Person.lastName`         | Only for `PartyType` = `Person`. |
| `PrimaryContactEmail`| `ContactMech.infoString` | Joined via `PartyContactMechPurpose` (PRIMARY_EMAIL). |
| `PrimaryContactPhone`| `TelecomNumber`           | Joined via `PartyContactMechPurpose` (PRIMARY_PHONE). Formatted as: `[countryCode] [areaCode] [contactNumber]`. |
| `SalesCurrencyCode` | `ProductStore.defaultCurrencyUomId` | Abbreviation of the default currency UOM for the `ProductStore`. |
| `CustomerGroupId` |                           | **TODO**: Needs discussion. Currently hardcoded as '10' or '30' as it's not yet mapped in OMS. |


## Phase 3: Sales Order Sync

### 3.1 Eligible Orders View (`D365EligibleSalesOrders`)
- **Criteria**:
    - `OrderHeader.orderTypeId` = `SALES_ORDER`
    - `OrderHeader.statusId` = `ORDER_APPROVED` (or as per business requirement)
    - `OrderIdentification` for `D365_ORDER_ID` is null (not yet synced).
- **Aliases**: `orderId`, `orderDate`, `partyId` (BILL_TO_CUSTOMER), `productStoreId`.

### 3.2 Sync Service Logic (`sync#SalesOrders`)
1. **Fetch Eligible Orders**: Query `D365EligibleSalesOrders` view.
2. **Process Each Order**:
    - **Customer Sync**: For every sales order, we check if the customer already exists in D365. Call `sync#Customer` for the order's `partyId`. If the customer exists in D365, we proceed to order creation using the returned `D365CustomerAccount`. If not, the service first creates the customer in D365 before proceeding.
    - **Sales Order Header**:
        - `POST /data/SalesOrderHeadersV4`.
        - Map `orderId` -> `SalesOrderNumber` (if manual sequencing is on).
        - Map `D365CustomerAccount` -> `OrderingCustomerAccountNumber`.
        - Map `D365SalesOrderDetail`:
            - `toName` -> `DeliveryAddressName`
            - `address1` + `address2` -> `DeliveryAddressStreet`
            - `city` -> `DeliveryAddressCity`
            - `stateProvinceGeoId` -> `DeliveryAddressStateId` (suffix only)
            - `postalCode` -> `DeliveryAddressZipCode`
            - `countryGeoId` -> `DeliveryAddressCountryRegionId`
    - **Sales Order Lines**:
        - For each `OrderItem`: `POST /data/SalesOrderLinesV3`.
        - Map `orderItemSeqId` -> `LineNumber` (numeric).
        - Map `productId` -> `ItemNumber` (currently hardcoded as '1000' for demo).
        - Map `quantity` -> `OrderedSalesQuantity`.
    - Store D365 Sales Order Number in `OrderIdentification` (type `D365_ORDER_ID`).
    - Save sync record in `D365OrderSyncHistory`.

### 3.3 Mappings
#### Header (`SalesOrderHeadersV4`)
| D365 Field | Moqui Field | Usage / Notes |
| :--- | :--- | :--- |
| `dataAreaId` | `ProductStore.externalId` | Legal entity context. |
| `SalesOrderNumber` | `OrderHeader.orderId` | Manual sequencing must be enabled in D365. |
| `OrderingCustomerAccountNumber` | `partyId` (BILL_TO) | The D365 `CustomerAccount`. |
| `InvoiceCustomerAccountNumber` | `partyId` (BILL_TO) | Same as Ordering Customer. |
| `RequestedShippingDate` | `orderDate` | Format: `YYYY-MM-DD`. |
| `CurrencyCode` | `currencyUomId` | e.g., `USD`. |
| `IsDeliveryAddressOrderSpecific` | "Yes" | Ensures address is unique to order. |
| `DeliveryAddressName` | `PostalAddress.toName` | |
| `DeliveryAddressDescription` | "OMS Ship To" | Fixed value. |
| `DeliveryAddressStreet` | `address1` + `address2` | Concatenated. |
| `DeliveryAddressCity` | `city` | |
| `DeliveryAddressStateId` | `stateProvinceGeoId` | State code (e.g., `CA`). |
| `DeliveryAddressZipCode` | `postalCode` | |
| `DeliveryAddressCountryRegionId` | `countryGeoId` | Standard 3-letter code (e.g., `USA`). |

#### Line (`SalesOrderLinesV3`)
| D365 Field | Moqui Field | Usage / Notes |
| :--- | :--- | :--- |
| `dataAreaId` | `ProductStore.externalId` | Legal entity context. |
| `SalesOrderNumber` | `SalesOrderNumber` | Linked to Header. |
| `ItemNumber` | `itemNumber` | D365 Product ID from `D365_PRODUCT_ID` Identification. |
| `LineNumber` | `orderItemSeqId` | Numeric sequence. |
| `OrderedSalesQuantity` | `quantity` | |
| `SalesPrice` | `unitPrice` | |
| `RequestedShippingDate` | `orderDate` | Same as Header. |
| `ShippingWarehouseId` | `shippingWarehouseId` | External ID of the fulfillment warehouse (currently filtered by `WH_ONLY_FULFILLMENT`; TODO: use a dedicated D365 Facility Group). |
| `LineDiscountAmount` | `getItemDiscountAmount()` | Calculated from `OrderAdjustment` of type `EXT_PROMO_ADJUSTMENT`. |


### 3.4 Prerequisites & TODOs
> [!IMPORTANT]
> - Customer must exist and not be on hold.
> - Products must be "Released" to the Legal Entity.
> - Every line requires a valid `InventorySiteId` and `InventoryWarehouseId`.

- **TODO**: [Mapping] Define `facilityId` to D365 `InventorySiteId/WarehouseId` mapping.
- **TODO**: [Mapping] Create mapping table for `TaxCategory` -> `ItemSalesTaxGroup`.

## Phase 4: Integration Type Mappings
To avoid hardcoding values like `SalesOrderOriginCode` and `DeliveryModeCode` in service logic, we use the `IntegrationTypeMapping` entity to translate OMS identifiers into D365 codes.

### 4.1 Configuration Structure
Add records to `co.hotwax.integration.IntegrationTypeMapping` for the target system:

| Mapping Category | OMS Internal ID (`mappingKey`) | D365 Code (`mappingValue`) | Enum Type (`integrationTypeId`) |
| :--- | :--- | :--- | :--- |
| **Sales Order Origin** | OMS Sales Channel (e.g., `WEB_SALES_CHANNEL`) | D365 Sales Origin (e.g., `Ecom`) | `D365_SALES_ORIGIN` |
| **Delivery Mode** | OMS Shipment Method (e.g., `STANDARD`) | D365 Mode of Delivery (e.g., `Standard`) | `D365_DELIVERY_MODE` |

### 4.2 Mapping Details
- **Sales Order Origin**: Maps the OMS `salesChannelEnumId` (from `OrderHeader`) to the D365 Sales Origin. In D365, this is the 'Sales Origin' field.
- **Delivery Mode**: Maps the OMS `shipmentMethodTypeId` (from `OrderItemShipGroup`) to the D365 Mode of Delivery. In D365, this is the 'Mode of delivery' field.

### 4.3 Setup Steps
1. **Define Enumerations**: Add the mapping category IDs (e.g., `D365_SALES_ORIGIN`) to `moqui.basic.Enumeration` with `enumTypeId="IntegrationType"`.
2. **Populate Mappings**: Provide the specific mapping records:
   - `integrationTypeId`: The category ID.
   - `mappingKey`: The internal Moqui ID.
   - `mappingValue`: The external D365 value.
   - `integrationRefId`: Set to the same value as `mappingKey` for referential integrity.

## Phase 5: Sample Requests

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
 "OrderingCustomerAccountNumber": "HW-02",
 "InvoiceCustomerAccountNumber": "HW-02",
 "RequestedShippingDate": "2026-02-26",
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
  "OrderedSalesQuantity": 1,
  "SalesPrice": 100,
  "LineDiscountAmount": 20,
  "ShippingSiteId": "1",
  "ShippingWarehouseId": "13",
  "RequestedShippingDate": "2026-02-25"
}
```

## Phase 6: Customer Payment Integration

### 6.1 Sync Flow & Posting Strategy
1.  **Draft Creation**: OMS POSTs `CustomerPaymentJournalHeaders` then `CustomerPaymentJournalLines`.
2.  **Unposted State**: Journals created via OData are initially **Unposted** (`IsPosted = No`).
3.  **Batch Posting**: A scheduled D365 batch job (standard or custom) identifies these unposted journals and executes the "Post" business logic to move them to the subledger.

### 6.2 Mappings
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


### 6.3 Implementation Steps
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

### 6.4 Sample Payload

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

## Phase 7: Outbound Integration (Business Events) TODO 
- [ ] **Endpoint Setup**: Create a REST service in Moqui to receive and validate Business Event notifications.
- [ ] **D365 Configuration**:
    - Register the Moqui endpoint in D365 (`System administration > Setup > Business events > Endpoints`).
    - Activate required events (e.g., `SalesOrderInvoicedBusinessEvent`).
- [ ] **Event Handling**: Implement logic in Moqui to process incoming events and trigger corresponding status updates or data pulls.

## Phase 8: Verification
- [ ] Test connectivity with D365 Sandbox.
- [ ] Validate data integrity in D365.
- [ ] Verify outbound notification flow (D365 -> OMS).
