## cancelOrderItemInvResQty
The `cancelOrderItemInvResQty` service in the Apache OFBiz framework is designed to handle the cancellation of inventory reservations associated with a specific order item. Inventory reservations are typically made when an order is placed to ensure that the required quantity of a product is available for fulfillment.

### Purpose

The primary goal of this service is to adjust inventory reservations and potentially release reserved inventory back into the available pool. This is crucial in scenarios where an order item is canceled, modified, or rejected, and the reserved inventory needs to be updated accordingly.

### Workflow

1.  **Input Validation:** The service validates the input parameters, including `orderId`, `orderItemSeqId`, `shipGroupSeqId`, and `cancelQuantity`. It ensures that these parameters are valid and that the specified quantity to cancel doesn't exceed the reserved quantity.

5.  **Release Inventory (If Applicable):**
    *   If the new reserved quantity is zero, it means the entire reservation for that order item is being canceled.
    *   In this case, the service calls the `deleteOrderItemShipGrpInvRes` service to remove the inventory reservation record (`OrderItemShipGrpInvRes`) associated with the order item. This effectively releases the reserved inventory back into the available pool.


### Key Points

*   **Service Chaining:** It interacts with other services like `deleteOrderItemShipGrpInvRes` to handle the actual deletion of inventory reservation records.

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

