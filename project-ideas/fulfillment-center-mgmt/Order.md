# **Order**


## unpackOrderItems

### Detailed Logic

1.  **Input:**
    *   Receive `shipmentId` as the input parameter.

2.  **Fetch Shipment:**
    *   Use `EntityQuery` to retrieve the `Shipment` entity based on the provided `shipmentId`.
    *   Validate that the shipment exists and is in the `SHIPMENT_PACKED` status.

3.  **Fetch Shipment Items:**
    *   Query the `ShipmentItem` entity to get all items associated with the shipment.

4.  **Update Shipment Status:**
    *   Update the `statusId` of the `Shipment` entity to `SHIPMENT_APPROVED`, indicating it's no longer packed.

5.  **Fetch Order and Order Item Details:**
    *   For each `ShipmentItem`, use the `OrderShipment` entity to find the corresponding `orderId` and `orderItemSeqId`.

6.  **Update Picklist Items:**
    *   For each `orderId` and `orderItemSeqId` pair, query the `PicklistItem` entity to find associated items with the status `PICKITEM_PICKED`.
    *   Update the `itemStatusId` of these `PicklistItem` entities to `PICKITEM_PENDING`, indicating they are available for picking again.

7.  **Error Handling and Success:**
    *   Wrap the logic in a `try-catch` block to handle potential exceptions (e.g., `GenericEntityException`).
    *   Return a success message if all updates are successful.
    *   Return an error message with details if any errors occur.

## Java Code Skeleton

```java
public static Map<String, Object> unpackShipment(DispatchContext dctx, Map<String, Object> context) {
    Delegator delegator = dctx.getDelegator();
    LocalDispatcher dispatcher = dctx.getDispatcher();
    GenericValue userLogin = (GenericValue) context.get("userLogin");

    String shipmentId = (String) context.get("shipmentId");

    try {
        // 1. Fetch Shipment
        GenericValue shipment = EntityQuery.use(delegator).from("Shipment").where("shipmentId", shipmentId).queryOne();
        if (shipment == null || !"SHIPMENT_PACKED".equals(shipment.getString("statusId"))) {
            return ServiceUtil.returnError("Shipment not found or not in PACKED status");
        }

        // 2. Fetch Shipment Items
        List<GenericValue> shipmentItems = EntityQuery.use(delegator).from("ShipmentItem").where("shipmentId", shipmentId).queryList();

        // 3. Update Shipment Status
        shipment.set("statusId", "SHIPMENT_APPROVED");
        shipment.store();

        // 4. Fetch Order and Order Item Details & 5. Update Picklist Items
        for (GenericValue shipmentItem : shipmentItems) {
            String orderId = shipmentItem.getString("orderId");
            String orderItemSeqId = shipmentItem.getString("orderItemSeqId");

            // Use OrderShipment to find associated PicklistItems
            List<GenericValue> picklistItems = EntityQuery.use(delegator)
                .from("PicklistItem")
                .where("orderId", orderId, "orderItemSeqId", orderItemSeqId, "itemStatusId", "PICKITEM_PICKED")
                .queryList();

            for (GenericValue picklistItem : picklistItems) {
                picklistItem.set("itemStatusId", "PICKITEM_PENDING");
                picklistItem.store();
            }
        }

    } catch (GenericEntityException e) {
        Debug.logError(e, MODULE);
        return ServiceUtil.returnError(e.getMessage());
    }

    return ServiceUtil.returnSuccess("Shipment unpacked successfully.");
}
```

### Key Changes from `unpackOrderItems`

*   **Input:** Takes `shipmentId` instead of `orderId` and `picklistBinId`.
*   **Shipment Status Update:** Updates the shipment status to `SHIPMENT_APPROVED` instead of `SHIPMENT_CANCELLED`.
*   **PicklistItem Query:** The query for `PicklistItem` is modified to filter by `shipmentId` (obtained from `OrderShipment`) instead of `picklistBinId`.

### reinitializeShipment

The `reinitializeShipment` service is designed to reset a shipment to its initial state, specifically to the `SHIPMENT_INPUT` status. This is often done when modifications need to be made to a shipment after it has been approved or partially processed.

### Input Parameters

*   `shipmentId` (String): The ID of the shipment that needs to be reinitialized.

### Use Cases

This service is typically used in scenarios where:

*   **Item Rejection:** When an item within a shipment is rejected, the shipment might need to be reinitialized to allow for adjustments and potential reassignment of items.
*   **Shipment Modification:** If there are changes to the shipment details (e.g., shipping address, carrier), reinitializing the shipment can reset it to a state where these changes can be made.
*   **Error Correction:** If an error occurred during the initial shipment processing, reinitializing can provide a clean slate to correct the issue.
*   **Updating package box types:** In the `updateInProgressOrder` function, if the shipment label hasn't been generated or the box type has changed, the shipment is reinitialized.
*   **Processing ready-to-pack items:** In the `updateInProgressOrder` function, if an item needs to be moved to a different shipment, both the original and new shipments are reinitialized.
*   **Handling item rejections:** In the `updateInProgressOrder` function, the shipment is reinitialized for items with specific rejection reasons.
