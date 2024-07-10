**Fulfillment Application Design Document**

**I. Data Model**

The data model defines the structure for storing and managing information related to shipments within the Order Management System.

**Entities:**

1.  **Shipment:**
    *   Shipment ID (Primary Key)
    *   Shipment Date
    *   Shipment Tracking Number (Optional)
    *   Shipping Address
    *   Customer ID (Foreign Key referencing Customer entity)
    *   ShipmentType ID (Foreign Key referencing ShipmentType entity)
    *   ShipmentStatus ID (Foreign Key referencing ShipmentStatus entity)

2.  **ShipmentType:**
    *   ShipmentType ID (Primary Key)
    *   ShipmentType Name

3.  **ShipmentStatus:**
    *   ShipmentStatus ID (Primary Key)
    *   ShipmentStatus Name

4.  **ShipmentItem:**
    *   ShipmentItem ID (Primary Key)
    *   Shipment ID (Foreign Key referencing Shipment entity)
    *   Order Item ID (Foreign Key referencing OrderItem entity in the Order Management System)
    *   Quantity

5.  **ShipmentPackage:**
    *   ShipmentPackage ID (Primary Key)
    *   Shipment ID (Foreign Key referencing Shipment entity)
    *   Tracking Number (Optional)
    *   Weight
    *   Dimensions

6.  **ShipmentRouteSegment:**
    *   ShipmentRouteSegment ID (Primary Key)
    *   Shipment ID (Foreign Key referencing Shipment entity)
    *   Sequence Number
    *   Location From
    *   Location To
    *   Estimated Arrival

7.  **ShipmentPackageContent:**
    *   ShipmentPackageContent ID (Primary Key)
    *   ShipmentPackage ID (Foreign Key referencing ShipmentPackage entity)
    *   ShipmentItem ID (Foreign Key referencing ShipmentItem entity)

8.  **ItemIssuance:**
    *   ItemIssuance ID (Primary Key)
    *   ShipmentItem ID (Foreign Key referencing ShipmentItem entity)
    *   Quantity
    *   Timestamp

9.  **PickListBin:**
    *   PickListBin ID (Primary Key)
    *   Bin Location
    *   Shipment ID (Foreign Key referencing Shipment entity)

10. **OrderItemShipGrpInvRes:**  *(Requires clarification on attributes and purpose)*

11. **ItemIssuanceRole:**
    *   ItemIssuanceRole ID (Primary Key)
    *   ItemIssuanceRole Name

**Relationships:**

*   A **Shipment** has one **ShipmentType**, one **ShipmentStatus**, and many **ShipmentItems**, **ShipmentPackages**, and **ShipmentRouteSegments**.
*   A **ShipmentItem** belongs to one **Shipment** and relates to one **OrderItem** (from the Order Management System).
*   A **ShipmentPackage** belongs to one **Shipment**.
*   A **ShipmentRouteSegment** belongs to one **Shipment**.


**II. Fulfillment Workflow**

1.  **Start Packing:** Packer enters picklist bin ID or scans item.
2.  **System Response:** System displays items in the picklist or in "INPUT" status. 
    *   Creates a new shipment if none exists.
    *   Shows progress of the current shipment.
3.  **Package Items:** Packer places items into packages, assigns items, and records weights.
4.  **Continue Packing?** System prompts packer.
    *   Yes: Packer continues packing.
    *   No: Proceed to next step.
5.  **Confirm Shipment:** Packer clicks "Confirm Shipment." System offers to edit shipping information.
6.  **Edit Shipping?**
    *   Yes: Packer edits shipping address or method.
    *   No: Proceed to next step.
7.  **Cancel Shipment?**
    *   Yes: Packer cancels the shipment.
    *   No: Proceed to next step.
8.  **Continue Shipping:** Packer gets tracking numbers and labels.
9. **System Updates:** System processes payment, marks shipment as "Shipped."
10. **Complete Packing:** Packer packs packages and places them in "PACKAGES" area.

**Important Considerations:**

*   Integrate inventory deduction.
*   Add exception handling branches.
*   Implement notifications.
*   Detail integration with Order Management System.
