# Updating Field Mappings in an Existing D365 Data Project

When a new field is added to a data package feed (e.g., a new column added to a CSV or a new attribute in a composite XML), the corresponding D365 data project must be updated to include that field in its source-to-staging mapping.

## When This Is Needed

- A new field is added to an existing OMS connector feed (e.g., `HCFULFILLMENTTYPE` added to `HotWax_Import_Brokered_Order_Items`)
- A new field is added to an existing composite entity (e.g., a new attribute on `SALESORDERLINEV2ENTITY` inside `HotWax_Import_SalesOrders_Composite`)
- The mapping was set up with an older sample file that did not include the new column

## Understanding the Mapping View

In D365 Data Management, **View Map** shows two columns:

| Column | What it represents |
| :--- | :--- |
| **Source field** | Columns derived from the sample file uploaded when the project was set up. New columns do not appear here until a new file is uploaded. |
| **Staging field** | All columns available in the D365 entity's staging table. A new field on the entity appears here immediately, but has nothing mapped to it until the source is updated. |

This means you cannot simply add a manual mapping for a new field — the Source field column will not show it until D365 has seen a file that contains it.

## Steps to Update the Mapping

1. **Go to Data Management workspace** → **Data projects**.

2. **Select the data project** you want to update (e.g., `HotWax_Import_Brokered_Order_Items`).

3. **Click `Run project`** (not `Load project`, and do not click into the project to open it). The `Run project` option appears in the action bar when the project row is selected.

4. **Click `Upload file`** and upload a new sample file that includes the new field column.
   - For CSV-based projects: upload a CSV with the new column header included (a single data row is sufficient).
   - For XML/composite projects: upload a new sample XML that includes the new attribute on the relevant entity element.

5. **Go back** to the Data projects list.

6. **Click the data project name** to open it this time.

7. Inside the project, find the entity tile (e.g., `Sales order lines V3`) and click **View map**.

8. Click **Regenerate source mapping** (the button reads **Generate source mapping** on a first-time setup when no mapping exists yet; for an existing project being updated, it will always read **Regenerate source mapping**).
   - D365 will ask: *"Do you want to generate the mapping from scratch?"* → click **Yes**.
   - The new field now appears in the Source field column and is automatically mapped to the matching Staging field.

9. **Verify** that the new field appears in the mapping with a Source → Staging connection.

> [!NOTE]
> `Run project` (from the project list action bar, without opening the project) is the correct entry point for replacing the sample file. It exposes the `Upload file` option that replaces the existing entity's source file. Do not open the project directly to upload — use the action bar.

## Example: Adding `HCFULFILLMENTTYPE` to `HotWax_Import_Brokered_Order_Items`

Upload a new `Sales order lines V3.csv` sample:

```csv
INVENTORYLOTID,SHIPPINGWAREHOUSEID,HCFULFILLMENTTYPE
479494,13,WMS
```

After regenerating the source mapping, the mapping should show:

| Source field | Staging field |
| :--- | :--- |
| INVENTORYLOTID | INVENTORYLOTID |
| SHIPPINGWAREHOUSEID | SHIPPINGWAREHOUSEID |
| HCFULFILLMENTTYPE | HCFULFILLMENTTYPE |

---

## Related Docs

- [data_import_package_api.md](./data_import_package_api.md) — Import package API flow that uses these data projects for inbound sync.
- [data_export_package_api.md](./data_export_package_api.md) — Export package API flow that uses these data projects for outbound sync.
