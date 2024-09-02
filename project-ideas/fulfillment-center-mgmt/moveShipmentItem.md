## **moveShipmentItem**.

This is API method is part of the order fulfillment applications facade. 

**Purpose**

The primary goal of the `moveShipmentItem` service is to transfer a specific item from one shipment to another within the same order. This is useful in scenarios where items need to be rearranged or consolidated during the fulfillment process.
Shipment should be in SHIPMENT_ status, to add or remove ShipmentItem.  

**Use Cases**

This service is typically used in the following scenarios:

*   **Consolidating Shipments:** If multiple shipments are going to the same address, it might be more efficient to combine items into a single shipment.
*   **Correcting Errors:** If an item was accidentally placed in the wrong shipment, this service can be used to move it to the correct one.
*   **Splitting Shipments:** If a shipment becomes too large, heavy, all items cannot fit in one package. Few items can be moved to a new package. 

**Context**
*  Shipment should be in SHIPMENT_INPUT status for adding or removing ShipmentItem.
*  An Order can have one or more Shipments
*  An OrderItem can be fulfilled/shipped by one ShipmentItem. No partial OrderItem fulfillment is allowed.
*  A Shipment can have one ShipmentPackage.

**Workflow**
*  Shipment can be edited in SHIPMENT_INPUT status. Check if shipment is in SHIPMENT_INPUT status, if not, stop futher process and return error.
*  Moving shipment item is three step process 
  1. Delete shipmentItem from existing shipment. Delete OrderShipment record along with ShipmentItem. Anything else?
  2. In some cases the shipmentItem is moved to new shipment, in such case we may have to create shipment [createSalesOrderShipment](createSalesOrderShipment.md). 
  3. Add shipmentItem to the shipment. Adding a ShipmentItem to Shipment, also creates record in OrderShipment entity.


**Input Parameters**

*   **`shipmentId` (String):** The ID of the original shipment from which the item is being moved.
*   **`shipmentPackageSeqId` (String, optional):** The sequence ID of the package within the original shipment that contains the item.
*   **`toShipmentId` (String):** The ID of the destination shipment to which the item will be moved.
*   **`toShipmentPackageSeqId` (String, optional):** The sequence ID of the package within the destination shipment where the item should be placed.
*   **`shipmentItemSeqId` (String):** The sequence ID of the specific item within the shipment that is being moved.
*   **`quantity` (BigDecimal, optional):** The quantity of the item to move. If not provided, the entire quantity of the shipment item is moved.
*   **`userLogin` (GenericValue):** The userLogin object representing the user performing the action.


**Workflow**

1.  **Input Validation:** The service validates the input parameters to ensure they are correct and consistent. It checks for the existence of the shipments, verifies that the shipments belong to the same order, and confirms the validity of the shipment item and quantity.

2.  **Remove Item from Original Shipment:** The service calls the `deleteOrderShipmentItem` service to remove the item from the original shipment.

3.  **Add Item to New Shipment:** The service calls the `createOrderShipmentItem` service to add the the item to the new shipment. It uses the `OrderShipment` entity to associate the item with the correct order and shipment.

## Version 2 - Developer Notes 
## **moveShipmentItem**

This API method is part of the order fulfillment application's facade.

### **Purpose**

The primary goal of the `moveShipmentItem` service is to transfer a specific item from one shipment to another within the same order. This is useful in scenarios where items need to be rearranged or consolidated during the fulfillment process.

Shipment should be in the `SHIPMENT_INPUT` status to add or remove `ShipmentItem`.

### **Use Cases**

This service is typically used in the following scenarios:

- **Consolidating Shipments:** Combining items into a single shipment when multiple shipments are going to the same address.
- **Correcting Errors:** Moving an item to the correct shipment if it was accidentally placed in the wrong one.
- **Splitting Shipments:** Moving items to a new shipment if a shipment becomes too large or heavy to fit in one package.

### **Context**

- A shipment should be in the `SHIPMENT_INPUT` status for adding or removing a `ShipmentItem`.
- An order can have one or more shipments.
- An `OrderItem` can be fulfilled/shipped by one `ShipmentItem`. No partial `OrderItem` fulfillment is allowed.
- A shipment can have one `ShipmentPackage`.

### **Workflow**

1. **Input Validation:** 
   - Ensure that both the original (`shipmentId`) and destination (`toShipmentId`) shipments are in the `SHIPMENT_INPUT` status. 
   - Check if the shipments belong to the same order. If they belong to different orders, an error is returned.

2. **Removing the Shipment Item from the Original Shipment:**
   - The service retrieves the `ShipmentItem` from the `OrderShipment` entity using the provided `shipmentId` and `shipmentItemSeqId`.
   - The `ShipmentItem` and its associated `OrderShipment` record are then deleted.

3. **Moving to a New Shipment or an Existing Shipment:**
   - If the item is to be moved to a new shipment, a new shipment is created using the `create#ShipmentFromOrderItems` service. This service creates the shipment and associates the `ShipmentItem` and `OrderShipment`.
   - If the item is to be moved to an existing shipment, the service creates a new `ShipmentItem` and associates it with the existing shipment and the appropriate `OrderShipment`.

4. **Creating or Updating Shipment Items and Order Shipments:**
   - The service prepares the `ShipmentItem` and `OrderShipment` maps based on the provided and retrieved data.
   - These maps are then used to either create new records in the `ShipmentItem` and `OrderShipment` entities or update existing ones.

### **Parameters**

- **`shipmentId` (String, Required):** The ID of the original shipment from which the item is being moved.
- **`shipmentPackageSeqId` (String):** The sequence ID of the package within the original shipment that contains the item.
- **`toShipmentId` (String):** The ID of the destination shipment to which the item will be moved.
- **`toShipmentPackageSeqId` (String):** The sequence ID of the package within the destination shipment where the item should be placed.
- **`shipmentItemSeqId` (String, Required):** The sequence ID of the specific item within the shipment that is being moved.

### **Workflow**

1. **Validate Shipment Status:**
   - The service checks if both the `fromShipment` and `destinationShipment` are in `SHIPMENT_INPUT` status. If either is not, the service returns an error.

2. **Ensure Both Shipments Belong to the Same Order:**
   - The service confirms that the `fromShipment` and `destinationShipment` belong to the same order by comparing their `primaryOrderId` values. If they do not match, the service returns an error.

3. **Remove Item from Original Shipment:**
   - The service first removes the `ShipmentItem` from the original shipment using the `deleteOrderShipmentItem` service.
   - It then deletes the associated `OrderShipment` record.

4. **Create or Update Shipment Item in Destination Shipment:**
   - **Case 1: Creating a New Shipment:**
     - If `toShipmentId` is empty, the service creates a new shipment and associates the `ShipmentItem` with it.
   - **Case 2: Moving to an Existing Shipment:**
     - If `toShipmentId` is provided, the service creates a new `ShipmentItem` and associates it with the existing `toShipmentId`.
     - The service also updates or creates a corresponding `OrderShipment` record.

5. **Return the Result:**
   - The service returns the `outShipmentId`, which is either the ID of the newly created shipment or the ID of the existing shipment where the item was moved.


