# D365 Data Import Package API

This document outlines the architecture and implementation strategy for importing bulk data into Dynamics 365 (D365) using the **Data Package API**.

## 1. Objective
To efficiently synchronize large batches of records from Moqui/HotWax OMS to D365. This approach avoids the overhead of individual OData calls and overcomes limitations associated with composite entities (where only one file is allowed per package).

## 2. High-Level Flow (Import)

The Data Import Package API follows these core steps:

1.  **Generate Data**: Create the data files (CSV or XML) containing the records to import.
2.  **Generate Manifest**: Create a `Manifest.xml` and `PackageHeader.xml` that define the entities and their processing order.
3.  **Create ZIP**: Bundle the data files and manifests into a single ZIP package.
4.  **Get Upload URL**: Call the OData Action `GetAzureWriteUrl` to obtain a temporary Azure Blob storage URL and a `BlobId`.
5.  **Upload**: Execute an HTTP PUT to upload the ZIP file to the Azure URL.
6.  **Trigger Import**: Call the OData Action `ImportFromPackage`, passing the `BlobId` and a `DefinitionGroupId` (the DMF project name in D365).
7.  **Monitor (Optional)**: Use `GetExecutionSummaryStatus` to poll for completion.

---

## 3. Example Implementation: Sales Order Sync

Synchronizing Sales Orders from OMS to D365 using the `SalesOrdersCompositeV4` entity.

### Phase 1: Outbound Sync (`sync#SalesOrdersDataPackage`)

1.  **Fetch Eligible Orders**: Batch records (e.g., 50 orders) from `co.hotwax.d365.order.D365EligibleSalesOrders`.
2.  **Generate Payload**: Append order Header and Line data into an in-memory XML DOM representing `SalesOrdersCompositeV4.xml`.
3.  **Create ZIP Package**: Archive the XML and manifest strings into a ZIP byte array.
4.  **Submit to D365**:
    *   Call `GetAzureWriteUrl` -> Get `BlobId`.
    *   Upload ZIP -> `HTTP PUT`.
    *   Call `ImportFromPackage(BlobId, definitionGroupId: 'SALES_ORDER_IMPORT')`.

### Phase 2: Result Polling
Because Data Package imports are asynchronous, we decouple the result tracking:
1.  **Query D365**: Periodically query the OData `SalesOrderHeadersV4` endpoint.
2.  **Map Back**: Identify successful imports by matching the `CustomersOrderReference` (OMS ID) to the generated `SalesOrderNumber` (D365 ID) and update the local `OrderIdentification`.

---

## 4. Prerequisites
*   **Permissions**: The App Registration requires Data Management privileges in D365 (**System administration > Setup > Microsoft Entra ID applications**).
*   **Roles**: Assign the **Data management administrator** role or a custom role with DMF access to the integration user.
