
## **PickListOrderItem Entity Design**

| Field Name             | Data Type     | Primary Key | Foreign Key | Description                                                                                 |
| :--------------------- | :------------ | :---------- | :---------- | :------------------------------------------------------------------------------------------ |
| pickListId             | id            | Yes         | Yes         | ID of the Picklist this item belongs to.                                                   |
| pickListItemSeqId      | id            | Yes         | -           | Unique sequence ID for the item within the picklist (e.g., "00001", "00002").              |
| orderId               | id            | Yes         | Yes         | ID of the order this item is associated with.                                              |
| orderItemSeqId         | id            | Yes         | Yes         | Sequence ID of the item within the order.                                                  |
| inventoryItemId        | id            | -           | Yes         | ID of the inventory item being picked (optional, could be null if not yet assigned).       |
| quantity               | decimal       | -           | -           | Quantity of the item to be picked.                                                         |
| itemStatusId           | id            | -           | Yes         | Status of the picklist item (e.g., "ITEM_APPROVED," "ITEM_PICKED," "ITEM_REJECTED").         |
| createdDate            | date-time     | -           | -           | Date and time when the picklist item was created.                                            |
| createdByUserLogin     | varchar(255)  | -           | -           | User who created the picklist item.                                                        |
| lastModifiedDate       | date-time     | -           | -           | Date and time when the picklist item was last modified.                                     |
| lastModifiedByUserLogin | varchar(255)  | -           | -           | User who last modified the picklist item.                                                   |

**Primary Key:**

*   The `PickListOrderItem` entity has a composite primary key consisting of:
    *   `pickListId`
    *   `pickListItemSeqId`
    *   `orderId`
    *   `orderItemSeqId`

**Foreign Keys:**

*   `pickListId` references the `Picklist` entity.
*   `orderId` and `orderItemSeqId` reference the `OrderItem` entity.
*   `itemStatusId` references the `StatusItem` entity (with `statusTypeId = "PICKLIST_ITEM_STATUS"`).
*   `inventoryItemId` references the `InventoryItem` entity (optional).

**Additional Considerations:**

*   **Status Management:** The `itemStatusId` field is crucial for tracking the progress of each item in the picklist (e.g., approved, picked, rejected).
*   **Inventory Assignment:** The `inventoryItemId` field can be used to associate a specific inventory item with the picklist item once it's been picked.
*   **Quantity:** The `quantity` field should be a decimal to allow for fractional quantities if needed.
*   **Auditing:** The `createdDate`, `createdByUserLogin`, `lastModifiedDate`, and `lastModifiedByUserLogin` fields provide an audit trail of changes to the picklist item.

**Example `PickListOrderItem` Record**

```
pickListId: "PL0005"
pickListItemSeqId: "00001"
orderId: "10000"
orderItemSeqId: "00101"
inventoryItemId: "10000"  
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
  "externalId": null, 
  "description": "Urgent Picklist for Backordered Items",
  "facilityId": "FACILITY_B",
  "shipmentMethodTypeId": "OVERNIGHT_SHIPPING",
  "statusId": "PICKLIST_IN_PROGRESS",
  "picklistDate": "2024-07-15T09:15:00",
  "createdByUserLogin": "admin456",
  "lastModifiedByUserLogin": "supervisor789",
  "picklistOrderItems":{
    "orderId": "10000",

  "orderItemSeqId": "00101",

  "inventoryItemId": "10000",

  "itemStatusId": "ITEM_APPROVED",

  "quantity": 1.5
  }
}
```
