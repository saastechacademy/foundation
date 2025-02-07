## create#org.apache.ofbiz.shipment.picklist.Picklist

**PickList Entity Design**

NOTE: Simplified version of Picklist data model.

* **Purpose:** The central entity representing a list of items to be picked from inventory, to pack and ship Shipments.
* **Key Fields:**
    * `picklistId`: Unique identifier for the picklist
    * `facilityId`: The facility from which items will be picked
    * `picklistDate`: The date the picklist was created
    * `description`: Description of the picklist


## **PickListShipment Entity Design**

| Field Name     | Data Type | Primary Key | Foreign Key | Description                                                                          |
|:---------------|:----------| :---------- |:------------|:-------------------------------------------------------------------------------------|
| pickListId     | id        | Yes         | Yes         | ID of the Picklist.                                                                  |
| shipmentId     | id        | Yes         | Yes         | ID of the shipment processed by this picklist.                                       |

**Primary Key:**

*   The `PickListShipment` entity has a composite primary key consisting of:
    *   `pickListId`
    *   `shipmentId`

**Foreign Keys:**

*   `pickListId` references the `Picklist` entity.
*   `shipmentId` reference the `Shipment` entity.


### **create#org.apache.ofbiz.shipment.picklist.Picklist**

**Sample JSON**
```
{
  "picklistId": "PL0005",
  "description": "Urgent Picklist for Backordered Items",
  "facilityId": "FACILITY_B",
  "picklistDate": "2024-07-15T09:15:00",
  "picklistShipments":{
    "shipmentId": "10000",
    "shipmentId": "10002",
    "shipmentId": "10003"
  }
}
```
