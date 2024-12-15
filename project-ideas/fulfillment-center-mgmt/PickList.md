## **PickList Entity Design**

NOTE: Simplified version of Picklist data model.

* **Purpose:** The central entity representing a list of items to be picked from inventory, typically to fulfill customer orders.
* **Key Fields:**
    * `picklistId`: Unique identifier for the picklist
    * `description`: Description of the picklist
    * `facilityId`: The facility from which items will be picked
    * `shipmentMethodTypeId`: The method used to ship the picked items
    * `statusId`: The current status of the picklist (e.g., created, printed, picked)
    * `picklistDate`: The date the picklist was created


## **PickListOrderItem Entity Design**

| Field Name     | Data Type | Primary Key | Foreign Key | Description                                                                          |
|:---------------|:----------| :---------- |:------------|:-------------------------------------------------------------------------------------|
| pickListId     | id        | Yes         | Yes         | ID of the Picklist this item belongs to.                                             |
| orderId        | id        | Yes         | Yes         | ID of the order this item is associated with.                                        |
| orderItemSeqId | id        | Yes         | Yes         | Sequence ID of the item within the order.                                            |
| quantity       | decimal   | -           | -           | Quantity of the item to be picked.                                                   |
| itemStatusId   | id        | -           | Yes         | Status of the picklist item (e.g., "ITEM_APPROVED," "ITEM_PICKED," "ITEM_REJECTED"). |
| picklistDate   | date      | -           |             |                                                                                      |

**Primary Key:**

*   The `PickListOrderItem` entity has a composite primary key consisting of:
    *   `pickListId`
    *   `orderId`
    *   `orderItemSeqId`

**Foreign Keys:**

*   `pickListId` references the `Picklist` entity.
*   `orderId` and `orderItemSeqId` reference the `OrderItem` entity.
*   `itemStatusId` references the `StatusItem` entity (with `statusTypeId = "PICKLIST_ITEM_STATUS"`).

**Additional Considerations:**

*   **Status Management:** The `itemStatusId` field is crucial for tracking the progress of each item in the picklist (e.g., approved, picked, rejected).
*   **Quantity:** The `quantity` field should be a decimal to allow for fractional quantities if needed.

**Example `PickListOrderItem` Record**

```
pickListId: "PL0005"
orderId: "10000"
orderItemSeqId: "00101"
quantity: 1
itemStatusId: "ITEM_APPROVED"
createdDate: "2024-07-15 09:15:00"
createdByUserLogin: "admin456"
lastModifiedDate: "2024-07-15 09:15:00"
lastModifiedByUserLogin: "admin456"
```

### **createPickList**

**Sample JSON**
```
{
  "picklistId": "PL0005",
  "description": "Urgent Picklist for Backordered Items",
  "facilityId": "FACILITY_B",
  "shipmentMethodTypeId": "OVERNIGHT_SHIPPING",
  "statusId": "PICKLIST_IN_PROGRESS",
  "picklistDate": "2024-07-15T09:15:00",
  "picklistOrderItems":{
    "orderId": "10000",

  "orderItemSeqId": "00101",

  "inventoryItemId": "10000",

  "itemStatusId": "PICKITEM_PENDING",

  "quantity": 1.5
  }
}
```

### **update#PicklistOrderItem**
*   Used to change status.

**`update#PicklistOrderItem`**
```json
{
  "picklistId": "PL0005",
  "orderId": "10000",
  "orderItemSeqId": "00101",
  "itemStatusId": "PICKITEM_CANCELLED"
}
```

```xml
    <StatusItem statusCode="PENDING" statusId="PICKITEM_PENDING" statusTypeId="PICKITEM_STATUS" statusAge="0"/>
    <StatusItem statusCode="PICKED" statusId="PICKITEM_PICKED" statusTypeId="PICKITEM_STATUS" statusAge="50"/>
    <StatusItem statusCode="COMPLETED" statusId="PICKITEM_COMPLETED" statusTypeId="PICKITEM_STATUS" statusAge="100"/>
    <StatusItem statusCode="CANCELLED" statusId="PICKITEM_CANCELLED" statusTypeId="PICKITEM_STATUS" statusAge="101"/>
```