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


**Shipment Status Workflow Analysis**

The XML defines the statuses a shipment can go through, the valid transitions between these statuses, and additional rules for the transitions.

**Status Definitions**

*   **StatusItem:**
    *   Defines the individual statuses a shipment can have.
    *   Attributes:
        *   `description`: Human-readable description of the status.
        *   `sequenceId`:  Likely used for ordering the statuses.
        *   `statusCode`: A short code for the status (e.g., "APPROVED").
        *   `statusId`: A unique identifier for the status (e.g., "SHIPMENT_APPROVED").
        *   `statusTypeId`: Identifies the type of status ("SHIPMENT_STATUS" for shipment statuses).

**Valid Status Changes**

*   **StatusValidChange:**
    *   Defines allowed transitions between statuses.
    *   Attributes:
        *   `statusId`: The initial status.
        *   `statusIdTo`: The status the shipment can transition to.
        *   `transitionName`: A name for the transition (e.g., "Pack").
        *   `sequenceNum`: (Optional) A number indicating the order of valid transitions for a status.
        *   `conditionExpression`: (Optional) A conditional expression that must be true for the transition to be allowed.

**Interpreting the Workflow**

1.  **Initial Status:**  A shipment starts in the `SHIPMENT_INPUT` status (Created).

2.  **Possible Transitions:**
    *   From `SHIPMENT_INPUT`:
        *   It can be Scheduled (`SHIPMENT_SCHEDULED`), Picked (`SHIPMENT_PICKED`), or Packed (`SHIPMENT_PACKED`).
        *   It can also be Canceled (`SHIPMENT_CANCELLED`) or Approved (`SHIPMENT_APPROVED`).

    *   From `SHIPMENT_APPROVED`:
        *   It can be Packed (`SHIPMENT_PACKED`), Shipped (`SHIPMENT_SHIPPED`), or Cancelled (`SHIPMENT_CANCELLED`).

    *   From `SHIPMENT_SCHEDULED`:
        *   It can be Picked (`SHIPMENT_PICKED`), Packed (`SHIPMENT_PACKED`), or Cancelled (`SHIPMENT_CANCELLED`).

    *   From `SHIPMENT_PICKED`:
        *   It can be Packed (`SHIPMENT_PACKED`) or Cancelled (`SHIPMENT_CANCELLED`).

    *   From `SHIPMENT_PACKED`:
        *   It can be Shipped (`SHIPMENT_SHIPPED`), Cancelled (`SHIPMENT_CANCELLED`), or moved back to Input (`SHIPMENT_INPUT`) under certain conditions.

    *   From `SHIPMENT_SHIPPED`:
        *   It can be Delivered (`SHIPMENT_DELIVERED`).

**Conditions and Rules**

*   Some transitions have conditional expressions:
    *   `directStatusChange == false`: This suggests that some transitions can only happen indirectly (through other intermediate statuses) and cannot be directly changed by the user.

**Diagrammatic Representation**
[Image of a state diagram illustrating the shipment status workflow]


**Key Points to Note:**

*   The workflow is highly flexible, allowing for various paths a shipment can take.
*   The `conditionExpression` attribute adds complexity and customization to the transitions.
*   The XML doesn't explicitly define a sequence for all transitions, so some decisions might need to be made during implementation.

```
<StatusType description="Shipment" hasTable="N"  statusTypeId="SHIPMENT_STATUS"/>
        <!-- Shipment status -->
    <StatusItem description="Created" sequenceId="01" statusCode="INPUT" statusId="SHIPMENT_INPUT" statusTypeId="SHIPMENT_STATUS"/>
    <StatusItem description="Approved" sequenceId="08" statusCode="APPROVED" statusId="SHIPMENT_APPROVED" statusTypeId="SHIPMENT_STATUS"/>

    <!-- Shipment status -->
    <StatusItem description="Scheduled" sequenceId="02" statusCode="SCHEDULED" statusId="SHIPMENT_SCHEDULED" statusTypeId="SHIPMENT_STATUS"/>
    <StatusItem description="Picked" sequenceId="03" statusCode="PICKED" statusId="SHIPMENT_PICKED" statusTypeId="SHIPMENT_STATUS"/>
    <StatusItem description="Packed" sequenceId="04" statusCode="PACKED" statusId="SHIPMENT_PACKED" statusTypeId="SHIPMENT_STATUS"/>
    <StatusItem description="Shipped" sequenceId="05" statusCode="SHIPPED" statusId="SHIPMENT_SHIPPED" statusTypeId="SHIPMENT_STATUS"/>
    <StatusItem description="Delivered" sequenceId="06" statusCode="DELIVERED" statusId="SHIPMENT_DELIVERED" statusTypeId="SHIPMENT_STATUS"/>
    <StatusItem description="Cancelled" sequenceId="99" statusCode="CANCELLED" statusId="SHIPMENT_CANCELLED" statusTypeId="SHIPMENT_STATUS"/>

    <StatusValidChange statusId="SHIPMENT_APPROVED" statusIdTo="SHIPMENT_PACKED" transitionName="Pack"/>
    <StatusValidChange statusId="SHIPMENT_APPROVED" statusIdTo="SHIPMENT_INPUT" transitionName="Create" conditionExpression="directStatusChange == false"/>
    <StatusValidChange statusId="SHIPMENT_PACKED" statusIdTo="SHIPMENT_CANCELLED" transitionName="Cancel"/>
    <!-- Shipment SHIPMENT_STATUS status valid change data -->
    <StatusValidChange statusId='SHIPMENT_APPROVED' statusIdTo='SHIPMENT_PACKED' transitionName='Pack' sequenceNum='01' />
    <StatusValidChange statusId='SHIPMENT_APPROVED' statusIdTo='SHIPMENT_CANCELLED' transitionName='Cancel' sequenceNum='03' />
    <StatusValidChange statusId='SHIPMENT_APPROVED' statusIdTo='SHIPMENT_SHIPPED' transitionName='Ship' sequenceNum='02' />
    <StatusValidChange statusId='SHIPMENT_INPUT' statusIdTo='SHIPMENT_SCHEDULED' transitionName='Schedule' sequenceNum='01' conditionExpression="directStatusChange == false" />
    <StatusValidChange statusId='SHIPMENT_INPUT' statusIdTo='SHIPMENT_PICKED' transitionName='Pick' sequenceNum='02' conditionExpression="directStatusChange == false" />
    <StatusValidChange statusId='SHIPMENT_INPUT' statusIdTo='SHIPMENT_CANCELLED' transitionName='Cancel' sequenceNum='04' />
    <StatusValidChange statusId='SHIPMENT_INPUT' statusIdTo='SHIPMENT_PACKED' transitionName='Pack' sequenceNum='03' conditionExpression="directStatusChange == false" />
    <StatusValidChange statusId="SHIPMENT_INPUT" statusIdTo="SHIPMENT_APPROVED" transitionName="Approve" sequenceNum="05" conditionExpression="directStatusChange == false" />
    <StatusValidChange statusId='SHIPMENT_SCHEDULED' statusIdTo='SHIPMENT_PICKED' transitionName='Pick' sequenceNum='01' />
    <StatusValidChange statusId='SHIPMENT_SCHEDULED' statusIdTo='SHIPMENT_CANCELLED' transitionName='Cancel' sequenceNum='03' />
    <StatusValidChange statusId='SHIPMENT_SCHEDULED' statusIdTo='SHIPMENT_PACKED' transitionName='Pack' sequenceNum='02' />
    <StatusValidChange statusId='SHIPMENT_PACKED' statusIdTo='SHIPMENT_INPUT' transitionName='input' sequenceNum='02' conditionExpression="directStatusChange == false" />
    <StatusValidChange statusId='SHIPMENT_PACKED' statusIdTo='SHIPMENT_SHIPPED' transitionName='Ship' sequenceNum='01' />
    <StatusValidChange statusId='SHIPMENT_PACKED' statusIdTo='SHIPMENT_CANCELLED' transitionName='Cancel' sequenceNum='03' />
    <StatusValidChange statusId="SHIPMENT_PACKED" statusIdTo="SHIPMENT_APPROVED" transitionName="Approve" sequenceNum="04" conditionExpression="directStatusChange == false" />
    <StatusValidChange statusId='SHIPMENT_PICKED' statusIdTo='SHIPMENT_CANCELLED' transitionName='Cancel' sequenceNum='02' />
    <StatusValidChange statusId='SHIPMENT_PICKED' statusIdTo='SHIPMENT_PACKED' transitionName='Pack' sequenceNum='01' />
    <StatusValidChange statusId='SHIPMENT_SHIPPED' statusIdTo='SHIPMENT_DELIVERED' transitionName='Deliver' sequenceNum='01' />
```

**Enhanced Entity Definitions** 

1.  **Shipment:**
    *   Shipment ID (Primary Key)
    *   Shipment Date
    *   Shipment Tracking Number (Optional)
    *   Shipping Address
    *   Customer ID (Foreign Key referencing Customer entity)
    *   ShipmentType ID (Foreign Key referencing ShipmentType entity, e.g., "SALES_SHIPMENT")
    *   ShipmentStatus ID (Foreign Key referencing ShipmentStatus entity)
    *   `carrierPartyId` (Optional): Carrier responsible for the shipment.
    *   `originFacilityId`: The facility from which the shipment originates.
    *   `destinationContactMechId`: Contact information for the destination.
    *   `originContactMechId`: Contact information for the origin.
    *   `partyIdFrom`: Party initiating the shipment (e.g., "COMPANY").
    *   `partyIdTo`: Party receiving the shipment.
    *   `primaryOrderId`: The main order associated with the shipment.
    *   `primaryShipGroupSeqId`:  Sequence ID of the primary shipment group.
    *   `shipmentMethodTypeId`: The shipping method used (e.g., "STANDARD").

2.  **ShipmentStatus:**
    *   ShipmentStatus ID (Primary Key)
    *   ShipmentStatus Name (e.g., "SHIPMENT_INPUT", "SHIPMENT_PACKED", "SHIPMENT_SHIPPED")
    *   `changeByUserLoginId`: The user who changed the status.
    *   `statusDate`: The date and time the status was changed.

3.  **ShipmentItem:**
    *   ShipmentItem ID (Primary Key)
    *   Shipment ID (Foreign Key referencing Shipment entity)
    *   Order Item ID (Foreign Key referencing OrderItem entity in the Order Management System)
    *   Quantity
    *   `productId`: The ID of the product included in the shipment.

4.  **ShipmentPackage:**
    *   ShipmentPackage ID (Primary Key)
    *   Shipment ID (Foreign Key referencing Shipment entity)
    *   Tracking Number (Optional)
    *   Weight
    *   Dimensions
    *   `shipmentBoxTypeId`: Type of box used for the package.
    *   `dimensionUomId`: Unit of measurement for dimensions (e.g., "LEN_in").
    *   `weightUomId`: Unit of measurement for weight (e.g., "WT_lb").
    *   `dateCreated`: Date the package was created.

5.  **ShipmentRouteSegment:**
    *   ShipmentRouteSegment ID (Primary Key)
    *   Shipment ID (Foreign Key referencing Shipment entity)
    *   Sequence Number
    *   Location From
    *   Location To
    *   Estimated Arrival
    *   `carrierServiceStatusId`: Status of the carrier service for this segment.
    *   `billingWeight`:  Weight used for billing.
    *   `billingWeightUomId`: Unit of measurement for billing weight.
    *   `isTrackingRequired`: Flag indicating whether tracking is required.

6.  **OrderShipment:** 
    *   `orderId`: The ID of the order.
    *   `orderItemSeqId`: Sequence ID of the order item.
    *   `shipGroupSeqId`:  Sequence ID of the shipment group within the order.

7.  **OrderItemShipGroupAssoc:**
    *   This entity seems to associate order items with shipment groups, but the XML data doesn't provide additional details. We'll keep the existing definition.

8.  **ItemIssuance:**
    *   ItemIssuance ID (Primary Key)
    *   ShipmentItem ID (Foreign Key referencing ShipmentItem entity)
    *   Quantity
    *   Timestamp
    *   `inventoryItemId`: The specific inventory item that was issued.
    *   `issuedByUserLoginId`: The user who issued the item.
    *   `issuedDateTime`: Date and time the item was issued.


**Additional Notes**

*   The provided XML confirms the existence of the `ShipmentType` entity with "SALES_SHIPMENT" as a type.

*   The `ShipmentStatus` data demonstrates how the status of a shipment changes over time, as captured in multiple entries for the same `shipmentId`. 

```


<ShipmentType createdStamp="2024-06-13 09:38:33.061" createdTxStamp="2024-06-13 09:38:32.542" description="Sales Shipment" hasTable="N" lastUpdatedStamp="2024-06-13 09:38:33.061" lastUpdatedTxStamp="2024-06-13 09:38:32.542" parentTypeId="OUTGOING_SHIPMENT" shipmentTypeId="SALES_SHIPMENT"/>
<Shipment carrierPartyId="_NA_" createdByUserLogin="hotwax.user" createdDate="2024-06-26 01:57:03.815" createdStamp="2024-06-26 01:57:03.815" createdTxStamp="2024-06-26 01:57:03.804" destinationContactMechId="11825" estimatedShipCost="0.00" lastModifiedByUserLogin="hotwax.user" lastModifiedDate="2024-06-26 01:57:03.936" lastUpdatedStamp="2024-06-26 01:57:03.936" lastUpdatedTxStamp="2024-06-26 01:57:03.804" originContactMechId="10005" originFacilityId="RIVERDALE" partyIdFrom="COMPANY" partyIdTo="10295" primaryOrderId="10203" primaryShipGroupSeqId="00001" shipmentId="10013" shipmentMethodTypeId="STANDARD" shipmentTypeId="SALES_SHIPMENT" statusId="SHIPMENT_SHIPPED"/>

<ShipmentStatus changeByUserLoginId="hotwax.user" createdStamp="2024-06-26 01:57:03.901" createdTxStamp="2024-06-26 01:57:03.901" lastUpdatedStamp="2024-06-26 01:57:03.901" lastUpdatedTxStamp="2024-06-26 01:57:03.901" shipmentId="10013" shipmentStatusId="10051" statusDate="2024-06-26 01:57:03.901" statusId="SHIPMENT_INPUT"/>
<ShipmentStatus changeByUserLoginId="hotwax.user" createdStamp="2024-06-26 01:57:03.932" createdTxStamp="2024-06-26 01:57:03.804" lastUpdatedStamp="2024-06-26 01:57:03.932" lastUpdatedTxStamp="2024-06-26 01:57:03.804" shipmentId="10013" shipmentStatusId="10052" statusDate="2024-06-26 01:57:03.932" statusId="SHIPMENT_PACKED"/> 
<ShipmentStatus changeByUserLoginId="hotwax.user" createdStamp="2024-06-26 01:57:04.117" createdTxStamp="2024-06-26 01:57:04.117" lastUpdatedStamp="2024-06-26 01:57:04.117" lastUpdatedTxStamp="2024-06-26 01:57:04.117" shipmentId="10013" shipmentStatusId="10053" statusDate="2024-06-26 01:57:04.117" statusId="SHIPMENT_SHIPPED"/> 

<ShipmentItem createdStamp="2024-06-26 01:57:03.881" createdTxStamp="2024-06-26 01:57:03.804" lastUpdatedStamp="2024-06-26 01:57:03.881" lastUpdatedTxStamp="2024-06-26 01:57:03.804" productId="10362" quantity="1.000000" shipmentId="10013" shipmentItemSeqId="00001"/>
<ShipmentItem createdStamp="2024-06-26 01:57:03.918" createdTxStamp="2024-06-26 01:57:03.901" lastUpdatedStamp="2024-06-26 01:57:03.918" lastUpdatedTxStamp="2024-06-26 01:57:03.901" productId="11676" quantity="1.000000" shipmentId="10013" shipmentItemSeqId="00002"/>

<ShipmentPackage createdStamp="2024-06-26 01:57:03.867" createdTxStamp="2024-06-26 01:57:03.804" dateCreated="2024-06-26 01:57:03.867" dimensionUomId="LEN_in" lastUpdatedStamp="2024-06-26 01:57:03.867" lastUpdatedTxStamp="2024-06-26 01:57:03.804" shipmentBoxTypeId="YOURPACKNG" shipmentId="10013" shipmentPackageSeqId="00001" weight="1.000000" weightUomId="WT_lb"/>

<ShipmentPackageContent createdStamp="2024-06-26 01:57:03.884" createdTxStamp="2024-06-26 01:57:03.804" lastUpdatedStamp="2024-06-26 01:57:03.884" lastUpdatedTxStamp="2024-06-26 01:57:03.804" quantity="1.000000" shipmentId="10013" shipmentItemSeqId="00001" shipmentPackageSeqId="00001"/>
<ShipmentPackageContent createdStamp="2024-06-26 01:57:03.919" createdTxStamp="2024-06-26 01:57:03.901" lastUpdatedStamp="2024-06-26 01:57:03.919" lastUpdatedTxStamp="2024-06-26 01:57:03.901" quantity="1.000000" shipmentId="10013" shipmentItemSeqId="00002" shipmentPackageSeqId="00001"/>

<ShipmentRouteSegment billingWeight="1.000000" billingWeightUomId="WT_lb" carrierPartyId="_NA_" carrierServiceStatusId="SHRSCS_ACCEPTED" createdStamp="2024-06-26 01:57:03.847" createdTxStamp="2024-06-26 01:57:03.804" destContactMechId="11825" isTrackingRequired="Y" lastUpdatedDate="2024-06-26 01:57:03.924" lastUpdatedStamp="2024-06-26 01:57:03.924" lastUpdatedTxStamp="2024-06-26 01:57:03.901" originContactMechId="10005" originFacilityId="RIVERDALE" shipmentId="10013" shipmentMethodTypeId="STANDARD" shipmentRouteSegmentId="00001" trackingIdNumber="747240761545" updatedByUserLoginId="hotwax.user"/>

<OrderShipment createdStamp="2024-06-26 01:57:03.92" createdTxStamp="2024-06-26 01:57:03.901" lastUpdatedStamp="2024-06-26 01:57:03.92" lastUpdatedTxStamp="2024-06-26 01:57:03.901" orderId="10203" orderItemSeqId="00102" quantity="1.000000" shipGroupSeqId="00001" shipmentId="10013" shipmentItemSeqId="00002"/>
<OrderShipment createdStamp="2024-06-26 01:57:03.887" createdTxStamp="2024-06-26 01:57:03.804" lastUpdatedStamp="2024-06-26 01:57:03.887" lastUpdatedTxStamp="2024-06-26 01:57:03.804" orderId="10203" orderItemSeqId="00101" quantity="1.000000" shipGroupSeqId="00001" shipmentId="10013" shipmentItemSeqId="00001"/>

<OrderItemShipGroupAssoc createdStamp="2024-06-26 01:52:08.586" createdTxStamp="2024-06-26 01:52:08.49" lastUpdatedStamp="2024-06-26 01:52:08.586" lastUpdatedTxStamp="2024-06-26 01:52:08.49" orderId="10203" orderItemSeqId="00101" quantity="1.000000" shipGroupSeqId="00001"/>
<OrderItemShipGroupAssoc createdStamp="2024-06-26 01:52:08.587" createdTxStamp="2024-06-26 01:52:08.49" lastUpdatedStamp="2024-06-26 01:52:08.587" lastUpdatedTxStamp="2024-06-26 01:52:08.49" orderId="10203" orderItemSeqId="00102" quantity="1.000000" shipGroupSeqId="00001"/> 

<ItemIssuance createdStamp="2024-06-26 01:57:03.972" createdTxStamp="2024-06-26 01:57:03.804" inventoryItemId="21850" issuedByUserLoginId="hotwax.user" issuedDateTime="2024-06-26 01:57:03.972" itemIssuanceId="10004" lastUpdatedStamp="2024-06-26 01:57:03.972" lastUpdatedTxStamp="2024-06-26 01:57:03.804" orderId="10203" orderItemSeqId="00101" quantity="1.000000" shipGroupSeqId="00001" shipmentId="10013" shipmentItemSeqId="00001"/> 
<ItemIssuance createdStamp="2024-06-26 01:57:04.054" createdTxStamp="2024-06-26 01:57:03.804" inventoryItemId="21070" issuedByUserLoginId="hotwax.user" issuedDateTime="2024-06-26 01:57:04.054" itemIssuanceId="10005" lastUpdatedStamp="2024-06-26 01:57:04.054" lastUpdatedTxStamp="2024-06-26 01:57:03.804" orderId="10203" orderItemSeqId="00102" quantity="1.000000" shipGroupSeqId="00001" shipmentId="10013" shipmentItemSeqId="00002"/>

```
