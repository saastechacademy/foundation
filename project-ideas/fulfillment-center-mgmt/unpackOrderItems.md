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


## cancelOrderItemInvResQty
The `cancelOrderItemInvResQty` service in the Apache OFBiz framework is designed to handle the cancellation of inventory reservations associated with a specific order item. Inventory reservations are typically made when an order is placed to ensure that the required quantity of a product is available for fulfillment.

### Purpose

The primary goal of this service is to adjust inventory reservations and potentially release reserved inventory back into the available pool. This is crucial in scenarios where an order item is canceled, modified, or rejected, and the reserved inventory needs to be updated accordingly.

### Workflow

1.  **Input Validation:** The service validates the input parameters, including `orderId`, `orderItemSeqId`, `shipGroupSeqId`, and `cancelQuantity`. It ensures that these parameters are valid and that the specified quantity to cancel doesn't exceed the reserved quantity.

2.  **Fetch Order Item Ship Group Assoc:** It retrieves the `OrderItemShipGroupAssoc` record, which links the order item to its shipment group and contains information about the reserved inventory.

3.  **Calculate New Reserved Quantity:** It calculates the new reserved quantity by subtracting the `cancelQuantity` from the existing `quantity` in the `OrderItemShipGroupAssoc` record.

4.  **Update Order Item Ship Group Assoc:** It updates the `OrderItemShipGroupAssoc` record with the new reserved quantity.

5.  **Release Inventory (If Applicable):**
    *   If the new reserved quantity is zero, it means the entire reservation for that order item is being canceled.
    *   In this case, the service calls the `deleteOrderItemShipGrpInvRes` service to remove the inventory reservation record (`OrderItemShipGrpInvRes`) associated with the order item. This effectively releases the reserved inventory back into the available pool.

6.  **Success or Error:**
    *   If all updates are successful, the service returns a success message.
    *   If any errors occur during the process (e.g., invalid input, database issues), the service returns an error message.

### Key Points

*   **Inventory Management:** This service plays a crucial role in maintaining accurate inventory levels by adjusting reservations based on order changes.
*   **Service Chaining:** It interacts with other services like `deleteOrderItemShipGrpInvRes` to handle the actual deletion of inventory reservation records.
*   **Error Handling:** It includes error handling to ensure data integrity and provide informative error messages.

```
    <simple-method method-name="cancelOrderItemInvResQty" short-description="Cancel Inventory Reservation Qty For An Item">
        <!--
            This will cancel the specified amount by looking through the reservations in order and cancelling
            just the right amount
        -->
        <if-empty field="parameters.cancelQuantity">
            <set from-field="parameters.orderId" field="cancelMap.orderId"/>
            <set from-field="parameters.orderItemSeqId" field="cancelMap.orderItemSeqId"/>
            <set from-field="parameters.shipGroupSeqId" field="cancelMap.shipGroupSeqId"/>
            <call-service service-name="cancelOrderInventoryReservation" in-map-name="cancelMap"/>
        </if-empty>
        <if-not-empty field="parameters.cancelQuantity">
            <set from-field="parameters.cancelQuantity" field="toCancelAmount"/>

            <set from-field="parameters.orderId" field="oisgirListLookupMap.orderId"/>
            <set from-field="parameters.orderItemSeqId" field="oisgirListLookupMap.orderItemSeqId"/>
            <set from-field="parameters.shipGroupSeqId" field="oisgirListLookupMap.shipGroupSeqId"/>
            <find-by-and entity-name="OrderItemShipGrpInvRes" map="oisgirListLookupMap" list="oisgirList" use-cache="false"/>
            <iterate list="oisgirList" entry="oisgir">
                <if-compare field="toCancelAmount" operator="greater" value="0" type="BigDecimal">
                    <if-compare-field field="oisgir.quantity" to-field="toCancelAmount" operator="greater-equals" type="BigDecimal">
                        <set from-field="toCancelAmount" field="cancelOisgirMap.cancelQuantity"/>
                    </if-compare-field>
                    <if-compare-field field="oisgir.quantity" to-field="toCancelAmount" operator="less" type="BigDecimal">
                        <set from-field="oisgir.quantity" field="cancelOisgirMap.cancelQuantity"/>
                    </if-compare-field>

                    <!-- Check if the product of OrderItem is a Kit Product, then we need to calculate cancel qty of components reservation on the basis of productAccos -->
                    <get-related-one relation-name="InventoryItem" value-field="oisgir" to-value-field="inventoryItem"/>
                    <entity-one entity-name="OrderItemAndProduct" value-field="orderItemAndProduct">
                        <field-map field-name="orderId" from-field="oisgir.orderId"/>
                        <field-map field-name="orderItemSeqId" from-field="oisgir.orderItemSeqId"/>
                        <field-map field-name="shipGroupSeqId" from-field="oisgir.shipGroupSeqId"/>
                        <field-map field-name="productTypeId" value="MARKETING_PKG_PICK"/>
                    </entity-one>

                    <if-not-empty field="orderItemAndProduct">
                        <!-- This means that OrderItem is of type MARKETING_PKG_PICK so we need to pick quantity of component products from its assoc -->
                        <set field="itemProductId" from="orderItemAndProduct.productId"/>
                        <set field="inventoryItemProductId" from="inventoryItem.productId"/>
                        <if-compare-field operator="not-equals" field="itemProductId" to-field="inventoryItemProductId">
                            <entity-and entity-name="ProductAssoc" list="productAssocs" filter-by-date="true">
                                <field-map field-name="productId" from-field="itemProductId"></field-map>
                                <field-map field-name="productIdTo" from-field="inventoryItemProductId"></field-map>
                                <field-map field-name="productAssocTypeId" value="PRODUCT_COMPONENT"></field-map>
                            </entity-and>
                            <first-from-list entry="productAssoc" list="productAssocs"/>

                            <if-not-empty field="productAssoc">
                                <calculate field="cancelOisgirMap.cancelQuantity">
                                    <calcop operator="multiply">
                                        <calcop operator="get" field="cancelOisgirMap.cancelQuantity"/>
                                        <calcop operator="get" field="productAssoc.quantity"/>
                                    </calcop>
                                </calculate>
                                <if-compare-field field="oisgir.quantity" to-field="cancelOisgirMap.cancelQuantity" operator="less" type="BigDecimal">
                                    <set from="oisgir.quantity" field="cancelOisgirMap.cancelQuantity"/>
                                </if-compare-field>
                            </if-not-empty>
                        </if-compare-field>
                        <else>
                            <!-- update the toCancelAmount -->
                            <calculate field="toCancelAmount" decimal-scale="6">
                                <calcop operator="subtract" field="toCancelAmount">
                                    <calcop operator="get" field="cancelOisgirMap.cancelQuantity"/>
                                </calcop>
                            </calculate>
                        </else>
                    </if-not-empty>

                    <set from-field="oisgir.orderId" field="cancelOisgirMap.orderId"/>
                    <set from-field="oisgir.orderItemSeqId" field="cancelOisgirMap.orderItemSeqId"/>
                    <set from-field="oisgir.shipGroupSeqId" field="cancelOisgirMap.shipGroupSeqId"/>
                    <set from-field="oisgir.inventoryItemId" field="cancelOisgirMap.inventoryItemId"/>
                    <call-service service-name="cancelOrderItemShipGrpInvRes" in-map-name="cancelOisgirMap"/>
                    <!-- checkDecomposeInventoryItem service is called to decompose a marketing package (if the product is a mkt pkg) -->
                    <set from-field="oisgir.inventoryItemId" field="checkDiiMap.inventoryItemId"/>
                    <call-service service-name="checkDecomposeInventoryItem" in-map-name="checkDiiMap"/>
                </if-compare>
            </iterate>
        </if-not-empty>
    </simple-method>

```

## rejectOrderItem

The "Process Non-Kit Item Rejection" of the `rejectOrderItem`.

### Purpose

This section of the code handles the rejection of individual order items that are not part of a kit (i.e., standalone products). The goal is to update the order item's association with the shipment group, adjust inventory levels, and log the rejection.

### Workflow

1.  **Fetch Ship Groups:** The code retrieves all `OrderItemShipGroupAssoc` records associated with the order item (`orderId` and `orderItemSeqId`) that are in a shippable state (`quantity` greater than zero).

2.  **Iterate Through Ship Groups:** For each ship group association:
    *   **Calculate `cancelReservationQuantity`:** If a specific `quantity` to reject was provided in the input, it's used. Otherwise, the entire remaining quantity in the ship group association is set as the `cancelReservationQuantity`.
    *   **Cancel Inventory Reservation:** The `cancelOrderItemInvResQty` service is called to cancel the corresponding inventory reservation for the `cancelReservationQuantity`.
    *   **Move to Rejected Ship Group (if applicable):** If the order item was originally associated with a non-NA facility, it's moved to a ship group associated with the `naFacilityId` (a designated facility for rejected items).
    *   **Create Order Facility Change:** An `OrderFacilityChange` record is created to log the change in facility for the rejected item.
    *   **Log External Fulfillment:** The `createUpdateExternalFulfillmentOrderItem` service is called to create or update an external fulfillment log entry, marking the item as rejected.
    *   **Create Order History:** An `OrderHistory` record is created with the event type `ITEM_REJECTED` to track the rejection in the order's history.

3.  **Record Inventory Variance:** If the `recordVariance` flag is set to "Y," and the rejection reason requires it, an inventory variance is recorded for the rejected quantity. This helps track inventory adjustments due to the rejection.

4.  **Set Auto Cancel Date:** If the `setAutoCancelDate` flag is set to "Y," the service calculates and sets an auto-cancel date for the order item based on the product store's configuration. This is typically used to automatically cancel orders that haven't been paid for within a certain timeframe.

### Key Points

*   **Targeted Rejection:** The service focuses on rejecting only the specified order item within the given ship group(s).
*   **Inventory and Order Management:** It handles inventory reservation cancellations, facility changes, and order history updates.
*   **Integration with Other Services:** It relies on other services like `cancelOrderItemInvResQty` and `createUpdateExternalFulfillmentOrderItem` to perform specific actions.
*   **Flexibility:** It can handle both partial and full rejections of an order item's quantity.

Once again:

1.  **Fetch Current Ship Group:**
    *   Retrieves the current ship group associated with the order item using `OrderItemShipGroupAssoc`.
    *   If found, fetches details of the ship group from `OrderItemShipGroup`.

2.  **Handle Kit Product Rejection (If Applicable):**
    *   Checks if the rejected item is part of a kit product.
    *   If so, performs the following actions:
        *   Cancels associated picklist items by updating their status to `PICKITEM_CANCELLED`.
        *   Releases reserved inventory for the kit product.
        *   Moves the ship group to the rejected item facility (`naFacilityId`) if it's different from the current facility.
        *   Creates `OrderFacilityChange` records for both the kit product and its components.
        *   Logs the rejection in the external fulfillment system and order history.

3.  **Fetch Quantity for Variance (If Applicable):**
    *   If `recordVariance` is "Y" and a valid `rejectReason` is provided, it fetches the quantity to record the variance.
    *   The variance quantity is determined based on the `rejectReasonDetail` (enumeration type).

4.  **Process Non-Kit Item Rejection:**
    *   If the item is not part of a kit, proceeds with the following:
        *   Fetches ship groups associated with the item at the specified facility, filtering by order and item status.
        *   Iterates through each ship group:
            *   Cancels associated picklist items.
            *   Releases reserved inventory.
            *   Adds the rejected item details (order ID, item sequence ID, ship group, quantity) to a list.
            *   Updates or deletes the `OrderItemShipGroupAssoc` based on the remaining quantity.
            *   Finds or creates a ship group in the rejected item facility (`naFacilityId`).
            *   Adds the item to the rejected item ship group.
            *   Creates an `OrderFacilityChange` record.
            *   Logs the rejection in the external fulfillment system and order history.
            *   Optionally sets an auto-cancel date for the order item (commented out in the code).

5.  **Record Variance (If Applicable):**
    *   If `recordVariance` is "Y" and the `rejectReason` requires it, records the variance for all available quantities of the product.
    *   Iterates through available inventory items and creates `PhysicalInventoryAndVariance` records.

6.  **Create Excluded Order Facility (If Applicable):**
    *   If `excludeOrderFacilityDuration` is provided, creates an `ExcludedOrderFacility` record to prevent future orders from being fulfilled from the rejected facility for a specified duration.

