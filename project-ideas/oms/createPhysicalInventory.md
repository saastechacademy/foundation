## create#org.apache.ofbiz.product.inventory.PhysicalInventory

### Workflow

1.  **Input Validation:**

2.  **Create Physical Inventory:**
    *   create record for the given `inventoryItemId` and `physicalInventoryDate` now().

3.  **Create Variance:**
    *   If either `quantityOnHandVar` or `availableToPromiseVar` is not zero, it indicates a variance.
    *   The service creates an `InventoryItemVariance` record to track the variance details, including the reason and comments.

### Key Points

```json
{
  "physicalInventoryDate": "2024-11-20T10:00:00",
  "partyId": "JOHNDOE",
  "generalComments": "Physical inventory completed for Main Warehouse.",
  "inventoryItemVariances": [
    {
      "inventoryItemId": "INVITEM1001",
      "quantityOnHandVar": -5,
      "varianceReasonId": "DAMAGED",
      "comments": "Surplus of 5 units found during inventory count.",
      "inventoryItemDetail": {
        "quantityOnHandDiff": -5
      }
    },
    {
      "inventoryItemId": "INVITEM1002",
      "quantityOnHandVar": 3,
      "varianceReasonId": "DAMAGED",
      "comments": "Surplus of 3 units found during inventory count.",
      "inventoryItemDetail": {
        "quantityOnHandDiff": 3
      }
    }
  ]
}
```

```xml
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

        <!-- Added by Anil -->
        <!-- Use VAR_EXT_RESET reason to record daily inventory sync updates. -->
    <VarianceReason varianceReasonId="VAR_EXT_RESET" description="Reset by External System"/>

```
