## create#PhysicalInventory

The `create#PhysicalInventory` service designed to record discrepancies between the expected and actual inventory levels of a product at a particular facility. This discrepancy is known as an inventory variance.

### Workflow

1.  **Input Validation:** The service validates the input parameters:

2.  **Create Physical Inventory:**
    *   create record for the given `inventoryItemId` and `physicalInventoryDate` now().
    *   The physical inventory record stores the current `quantityOnHand` and `availableToPromise` values from the `InventoryItem` entity.

3.  **Create Variance:**
    *   If either `quantityOnHandVar` or `availableToPromiseVar` is not zero, it indicates a variance.
    *   The service creates an `InventoryItemVariance` record to track the variance details, including the reason and comments.

4.  **Update Inventory Item:**
    *   The service updates the `InventoryItem` entity with the new `quantityOnHand` and `availableToPromise` values, reflecting the adjustments made due to the variance.


### Key Points

```json
{
  "PhysicalInventory": {
    "physicalInventoryId": "PHYINV1001",
    "physicalInventoryDate": "2024-11-20T10:00:00",
    "partyId": "JOHNDOE",
    "comments": "Physical inventory completed for Main Warehouse.",
    "inventoryItemVariances": [
      {
        "inventoryItemId": "INVITEM1001",
        "quantityOnHandVar": -5,
        "varianceReasonId": "DAMAGED",
        "comments": "Surplus of 5 units found during inventory count."
      },
      {
        "inventoryItemId": "INVITEM1002",
        "quantityOnHandVar": 3,
        "varianceReasonId": "DAMAGED",
        "comments": "Surplus of 3 units found during inventory count."
      }
    ]
  }
}
```

```
    <!-- Rejection reason -->
    <EnumerationType enumTypeId="REPORT_AN_ISSUE" description="Report an Issue Reason"/>
    <EnumerationType enumTypeId="RPRT_NO_VAR_LOG" description="Report an issue with no variance log"/>
    <EnumerationType enumTypeId="REPORT_NO_VAR" description="Report an issue with no variance reason" parentTypeId="RPRT_NO_VAR_LOG"/>
    <EnumerationType enumTypeId="REPORT_ALL_VAR" description="Report an issue with all qty variance reason" parentTypeId="REPORT_AN_ISSUE"/>
    <EnumerationType enumTypeId="REPORT_VAR" description="Report an issue with particular qty variance reason" parentTypeId="REPORT_AN_ISSUE"/>
    <Enumeration description="Not in Stock" enumCode="NOT_IN_STOCK" enumId="NOT_IN_STOCK" sequenceId="10" enumTypeId="REPORT_ALL_VAR"/>
    <Enumeration description="Worn Display" enumCode="WORN_DISPLAY" enumId="WORN_DISPLAY" sequenceId="20" enumTypeId="REPORT_VAR"/>
    <Enumeration description="Damaged" enumCode="DAMAGED" enumId="REJ_RSN_DAMAGED" sequenceId="30" enumTypeId="REPORT_VAR"/>
    <Enumeration description="Mismatch" enumCode="MISMATCH" enumId="MISMATCH" sequenceId="40" enumTypeId="REPORT_VAR"/>
    <Enumeration description="Inactive store" enumCode="INACTIVE_STORE" enumId="INACTIVE_STORE" sequenceId="40" enumTypeId="REPORT_NO_VAR"/>
    <Enumeration description="No variance" enumCode="NO_VARIANCE_LOG" enumId="NO_VARIANCE_LOG" sequenceId="40" enumTypeId="REPORT_NO_VAR"/>
    <!--This rejection reason will be applied to all items in the order/shipment that get rejected due to the rejection of one or more items from the order, to avoid unnecessary splits when the 'Reject Entire Order' setting is enabled.-->
    <Enumeration description="Reject entire order" enumCode="REJECT_ENTIRE_ORDER" enumId="REJECT_ENTIRE_ORDER" sequenceId="41" enumTypeId="REPORT_NO_VAR"/>

    <VarianceReason varianceReasonId="NOT_IN_STOCK" description="Not in Stock"/>
    <VarianceReason varianceReasonId="WORN_DISPLAY" description="Worn Display"/>
    <VarianceReason varianceReasonId="REJ_RSN_DAMAGED" description="Damaged"/>
    <VarianceReason varianceReasonId="MISMATCH" description="Mismatch"/>
    <VarianceReason varianceReasonId="INACTIVE_STORE" description="Inactive store"/>
    <VarianceReason varianceReasonId="NO_VARIANCE_LOG" description="No variance"/>

```
