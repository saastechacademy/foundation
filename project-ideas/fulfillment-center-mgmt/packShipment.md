# **Shipment**

## packShipment

### Detailed Logic

1.  **Input:**
    *   Receive `shipmentId` as the input parameter.

2.  **Fetch Shipment:**
    *   Use `EntityQuery` to retrieve the `Shipment` entity based on the provided `shipmentId`.
    *   Validate that the shipment exists and is in the `SHIPMENT_APPROVED` status (precondition).

3.  **Fetch Shipment Items:**
    *   Query the `ShipmentItem` entity to get all items associated with the shipment.

4.  **Update Shipment Status:**
    *   Update the `statusId` of the `Shipment` entity to `SHIPMENT_PACKED` (postcondition), indicating it's been packed and is ready for shipment.

5.  **Fetch Order and Order Item Details:**
    *   For each `ShipmentItem`, use the `OrderShipment` entity to find the corresponding `orderId` and `orderItemSeqId`.

6.  **Update Picklist Items:**
    *   For each `orderId` and `orderItemSeqId` pair, query the `PicklistItem` entity to find associated items.
    *   Update the `itemStatusId` of these `PicklistItem` entities to `PICKITEM_PICKED`, indicating they have been picked for the packed shipment.


## Java Code Skeleton

```java
public static Map<String, Object> packShipment(DispatchContext dctx, Map<String, Object> context) {
    Delegator delegator = dctx.getDelegator();
    LocalDispatcher dispatcher = dctx.getDispatcher();
    GenericValue userLogin = (GenericValue) context.get("userLogin");

    String shipmentId = (String) context.get("shipmentId");

    try {
        // 1. Fetch Shipment
        GenericValue shipment = EntityQuery.use(delegator).from("Shipment").where("shipmentId", shipmentId).queryOne();
        if (shipment == null || !"SHIPMENT_APPROVED".equals(shipment.getString("statusId"))) {
            return ServiceUtil.returnError("Shipment not found or not in APPROVED status");
        }

        // 2. Fetch Shipment Items
        List<GenericValue> shipmentItems = EntityQuery.use(delegator).from("ShipmentItem").where("shipmentId", shipmentId).queryList();

        // 3. Update Shipment Status
        shipment.set("statusId", "SHIPMENT_PACKED");
        shipment.store();

        // 4. Fetch Order and Order Item Details & 5. Update Picklist Items
        for (GenericValue shipmentItem : shipmentItems) {
            // ... (Use OrderShipment to find orderId and orderItemSeqId)
            // ... (Query PicklistItem and update itemStatusId to PICKITEM_PICKED)
        }

    } catch (GenericEntityException e) {
        Debug.logError(e, MODULE);
        return ServiceUtil.returnError(e.getMessage());
    }

    return ServiceUtil.returnSuccess("Shipment packed successfully.");
}
```

### Key Corrections

*   **Shipment Status:** The precondition is now correctly checked for `SHIPMENT_APPROVED`, and the postcondition updates the status to `SHIPMENT_PACKED`.
*   **OFBiz Conventions:** The code adheres to OFBiz conventions for entity queries and updates.

