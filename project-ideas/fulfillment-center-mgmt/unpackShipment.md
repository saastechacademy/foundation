## unpackShipment

#### Note : 
packShipment and unpackShipment update status of shipment, this functionality can be shifted to one updateShipmentStatus service, will refractor later based on final flow.

unpackShipment service is responsible for updating ShipmentItem and PicklistOrderItem status. We want to be sure either both or none happens. This is a good reason why we cannot use generic updateShipment Status service. 


### Detailed Logic

1.  **Input:**
    *   Receive `shipmentId` as the input parameter.

2.  **Fetch Shipment:**
    *   Use `EntityQuery` to retrieve the `Shipment` entity based on the provided `shipmentId`.
    *   Validate that the shipment exists and is in the `SHIPMENT_PACKED` status.

3.  **Fetch ShipmentItem and PicklistOrderItem:**
    *   Query the `ShipmentItem` and `PicklistOrderItem` entity joining with `OrderShipment` to get all items associated with the shipment.

4.  **Update Shipment Status:**
    *   Update the `statusId` of the `Shipment` entity to `SHIPMENT_APPROVED`, indicating it's no longer packed.

5.  **Fetch Order and Order Item Details:**
    *   For each `ShipmentItem`, use the `OrderShipment` entity to find the corresponding `orderId` and `orderItemSeqId`.

6.  **Update PicklistOrderItem Items:**
    *   For each `orderId` and `orderItemSeqId`, `picklistId`, `pickListItemSeqId`.
    *   Update the `itemStatusId` of these `PicklistOrderItem` entities to `PICKITEM_PENDING`, indicating they are available for picking again.

7.  **Error Handling and Success:**
    *   Wrap the logic in a `try-catch` block to handle potential exceptions (e.g., `GenericEntityException`).
    *   Return a success message if all updates are successful.
    *   Return an error message with details if any errors occur.


