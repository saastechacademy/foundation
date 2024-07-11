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

**Comprehensive Data Validation Requirements**

1.  **External Shipment ID (externalId):**

    *   **Uniqueness:** If provided, the `externalId` must be unique within the `Shipment` entity.

2.  **Shipment Type ID (shipmentTypeId):**

    *   **Validity:** If provided, the `shipmentTypeId` must exist in the `ShipmentType` entity.
    *   **Default Value:** If not provided, defaults to "SALES_SHIPMENT".

3.  **Order ID (orderId) and Order External ID (orderExternalId):**

    *   **Existence:** Either `orderId` or `orderExternalId` is required.
    *   **External ID Resolution:** If only `orderExternalId` is provided, the service should fetche the corresponding `orderId`.
    *   **Order Validity:** The `orderId` must exist in the `OrderHeader` entity and match the correct `orderTypeId` ("SALES_ORDER" ).
    *   **Ship Group Validity (Optional):** If `shipGroupSeqId` is provided, it must be valid within the specified order.

5.  **Party IDs (partyIdFrom, externalPartyIdFrom, partyIdTo, externalPartyIdTo):**

    *   **Applicability:** These validations apply only to Sales Shipment (`shipmentTypeId` != "SALES_SHIPMENT").
    *   **Party From:** Either `partyIdFrom` or `externalPartyIdFrom` is required, and it must be valid.
    *   **Party To:** Either `partyIdTo` or `externalPartyIdTo` is required, and it must be valid.

6.  **Facility IDs (originFacilityId, externalOriginFacilityId, destinationFacilityId, externalDestinationFacilityId):**

    *   **Facility Origin:** Either `originFacilityId` or `externalOriginFacilityId` is required, and it must be valid.
    *   **Facility Destination (Optional):** If provided, either `destinationFacilityId` or `externalDestinationFacilityId` must be valid.

7.  **Status ID (status):**

    *   **Validity:** If provided, the `status` must be a valid `statusId` for the "SHIPMENT_STATUS" type.
    *   **Default Value:** If not provided, defaults to "SHIPMENT_INPUT."

8.  **Dates (estimatedReadyDate, estimatedShipDate, estimatedArrivalDate):**

    *   **Format:** If provided, dates must follow specific formats (e.g., "yyyy-MM-dd HH:mm:ss").

9.  **Ship From Information (shipFrom):**

    *   **Postal Address:** If provided, the postal address ID (`id`) or external ID (`externalId`) must be valid.
    *   **Phone Number:** If provided, the phone number ID (`id`) or external ID (`externalId`) must be valid.

10. **Ship To Information (shipTo):**

    *   **Postal Address:** If provided, the postal address ID (`id`) or external ID (`externalId`) must be valid.
    *   **Phone Number:** If provided, the phone number ID (`id`) or external ID (`externalId`) must be valid.

11. **Items (items):**

    *   **Product Identification:** For each item, either `productId` or `sku` is required.
    *   **Product/SKU Validity:** The provided `productId` or `sku` must exist in the `Product` entity.

12. **Packages (packages):**

    *   **Package Details:** For each package, validations are performed for:
        *   `dimensionUomId`: Must be a valid unit of measurement for length.
        *   `weightUomId`: Must be a valid unit of measurement for weight.
        *   `boxTypeId`: If provided, must be a valid shipment box type.
        *   `boxLength`, `boxHeight`, `boxWidth`, `weight`: If provided, must be convertible to BigDecimal.

    *   **Package Items:** If `items` are included within a package, the same validations as for the top-level `items` list are applied.

**Additional Considerations:**

*   **Default Values:** The service should set default values for `shipmentTypeId`, `statusId`, `boxTypeId`, `weightUomId`, and `dimensionUomId` if they are not provided.
*   **Error Handling:** The service should collects all validation errors and returns them in a consolidated error message if any validation fails.


**BigDecimal Handling in `createSalesShipment`**

The service should take extra care to ensure that numeric values, especially those representing monetary amounts or quantities, are handled using the `BigDecimal` data type. This is crucial for financial calculations to avoid precision errors that can occur with floating-point types like `float` or `double`.

**Data Elements and Parameters Specifically Handled for BigDecimal**

1.  **estimatedShipCost:**

    *   **Input:** The service receives this value from the `shipmentsMap` as an `Object`.
    *   **Conversion:** It should use `ObjectType.simpleTypeConvert` to explicitly convert the input value to a `BigDecimal`, specifying the locale for potential decimal formatting differences.
    *   **Usage:** This `BigDecimal` value is then used when creating the `Shipment` entity.

2.  **boxLength, boxHeight, boxWidth, weight (within packages):**

    *   **Input:** These values are nested within the `packages` list in the `shipmentsMap`.
    *   **Conversion:** Similar to `estimatedShipCost`, the code converts these values to `BigDecimal` using `ObjectType.simpleTypeConvert`.
    *   **Usage:** The converted `BigDecimal` values are used when creating the `ShipmentPackage` entity.

3.  **quantity (within items and packageItems):**

    *   **Input:** These values are found within the `items` and `packageItems` lists.
    *   **Conversion:** Again, `ObjectType.simpleTypeConvert` is used to convert the input quantity to `BigDecimal`.
    *   **Usage:** The `BigDecimal` quantities are used when creating `ShipmentItem` and `ShipmentPackageContent` entities.

**Explanation and Requirements**

*   **Why BigDecimal?**  `BigDecimal` is used for its arbitrary precision, ensuring accurate representation of decimal numbers. This is essential for financial calculations and inventory management where even small errors can accumulate.

*   **Conversion:** The `ObjectType.simpleTypeConvert` method is a utility function in OFBiz that handles the conversion of various data types. In this case, it's used to safely convert the input values (which might be strings, numbers, or other objects) into the desired `BigDecimal` format.

*   **Locale:** The locale is passed to `simpleTypeConvert` to handle potential differences in decimal separators (e.g., "." vs ",").


Prepare data for creating a new `Shipment` entity in the database. Let's break down the data elements it includes, their significance, and any associated rules:

1.  **shipmentId:**

    *   **Significance:** The unique identifier for the new shipment.
    *   **Rule:** It's generated using `delegator.getNextSeqId("Shipment")` to ensure uniqueness.

2.  **externalId:**

    *   **Significance:** An optional external identifier for the shipment, potentially used for integration with other systems.
    *   **Rule:** If provided in the input, it's included as-is.

3.  **shipmentTypeId:**

    *   **Significance:** The type of shipment (e.g., "SALES_SHIPMENT").
    *   **Rule:** If not provided in the input, it defaults to "SALES_SHIPMENT".

4.  **statusId:**

    *   **Significance:** The initial status of the shipment.
    *   **Rule:** If not provided in the input, it defaults to "SHIPMENT_INPUT."

5.  **primaryOrderId:**

    *   **Significance:** The ID of the primary order associated with the shipment.
    *   **Rule:** Included only if the `orderId` is provided in the input.

6.  **picklistBinId:**

    *   **Significance:** The ID of the picklist bin from which items were picked for the shipment.
    *   **Rule:** Included only if the `picklistBinId` is provided in the input.

7.  **primaryShipGroupSeqId:**

    *   **Significance:** The sequence ID of the primary shipment group within the order.
    *   **Rule:** Included only if both `orderId` and `shipGroupSeqId` are provided in the input.

8.  **partyIdFrom:**

    *   **Significance:** The ID of the party (e.g., company) initiating the shipment.
    *   **Rule:** If not provided directly, it's resolved from the `externalPartyIdFrom` if available.

9.  **partyIdTo:**

    *   **Significance:** The ID of the party receiving the shipment (e.g., customer).
    *   **Rule:** If not provided directly, it's resolved from the `externalPartyIdTo` if available.

10. **originFacilityId:**

    *   **Significance:** The ID of the facility from which the shipment originates.
    *   **Rule:** If not provided directly, it's resolved from the `externalOriginFacilityId` if available.

11. **destinationFacilityId:**

    *   **Significance:** The ID of the destination facility (if applicable).
    *   **Rule:** If not provided directly, it's resolved from the `externalDestinationFacilityId` if available.

12. **originContactMechId:**

    *   **Significance:** The contact mechanism ID for the origin's location (e.g., address).
    *   **Rule:** Resolved from the `shipFrom` information in the input if available.

13. **originTelecomNumberId:**

    *   **Significance:** The contact mechanism ID for the origin's phone number.
    *   **Rule:** Resolved from the `shipFrom` information in the input if available.

14. **destinationContactMechId:**

    *   **Significance:** The contact mechanism ID for the destination's location (e.g., address).
    *   **Rule:** Resolved from the `shipTo` information in the input if available.

15. **destinationTelecomNumberId:**

    *   **Significance:** The contact mechanism ID for the destination's phone number.
    *   **Rule:** Resolved from the `shipTo` information in the input if available.

16. **estimatedShipCost:**

    *   **Significance:** The estimated cost of shipping.
    *   **Rule:** Included only if provided in the input.

17. **estimatedArrivalDate, estimatedReadyDate, estimatedShipDate:**

    *   **Significance:** Estimated dates for arrival, readiness, and shipping.
    *   **Rule:** Included only if provided in the input and converted to Timestamp objects.


Enforce constraints on when the status of a shipment can be changed. Prevent invalid status transitions, particularly those that would revert a shipment to an earlier stage after it has reached specific milestones.

**Requirement**

1. **Scenario 1:** If the desired transition is from any status to "SHIPMENT_SHIPPED" and the current status of the `testShipment` is already "SHIPMENT_SHIPPED," the transition is not allowed.

2. **Scenario 2:** If the desired transition is from any status to "SHIPMENT_DELIVERED" and the current status of the `testShipment` is already "SHIPMENT_SHIPPED" or "SHIPMENT_DELIVERED," the transition is not allowed.

**How It Helps Manage Shipment Data**

*   **Prevents Invalid Transitions:** The method enforces business rules that prevent a shipment from moving backward in its lifecycle. Once a shipment is shipped or delivered, it shouldn't be possible to change its status to something that implies it's still in the warehouse.

*   **Data Integrity:** By restricting invalid status changes, the method helps maintain the integrity of the shipment data. It ensures that the status accurately reflects the shipment's progress.

*   **User Guidance:** The error message provides feedback to the user, explaining why the requested operation is not allowed. This helps users understand the system's constraints and make appropriate decisions.

**Example**

Let's say a user tries to change the status of a shipment that's already been marked as "Shipped" back to "Packed." Detect invalid transition, generate an error message like "Cannot perform operation Pack when the shipment is in the Shipped status," and add it to the `error_list`. This prevents the invalid status change and informs the user of the reason.


**Set originContactMechId based on originFacilityId**

1.  **Set Origin Information:**
    *   If the `originFacilityId` is present in the shipment:
        *   If `originContactMechId` is empty, it finds a contact mechanism associated with the origin facility with the purpose "PRIMARY_LOCATION" or "SHIP_ORIG_LOCATION" and sets it as the `originContactMechId`.
        *   If `originTelecomNumberId` is empty, it finds a contact mechanism associated with the origin facility with the purpose "PRIMARY_PHONE" and sets it as the `originTelecomNumberId`.

**How It Helps Manage Shipment Data**

*   **Automation:** The method automates the process of filling in missing contact and telecom information, saving time and reducing manual effort.
*   **Data Completeness:** It ensures that shipments have complete contact information for both origin and destination, which is crucial for communication and tracking.
*   **Accuracy:** By deriving information directly from the associated facilities, it reduces the risk of errors in manually entering contact details.
*   **Efficiency:** The method only updates the shipment if changes were made, avoiding unnecessary database writes.

**Update shipment details based on the primary order associated with it**

1.  **Retrieve Shipment and Order Data:**
    *   If `Shipment.primaryOrderId` and `primaryShipGroupSeqId` are present in the shipment, fetch the corresponding `OrderHeader` and `OrderItemShipGroup` entities. These entities hold details about the order and the specific group of items within the order that the shipment is fulfilling.

1.  **Set Shipment Type:**
    *   Determines the `shipmentTypeId` based on the `orderTypeId` of the associated order:
        *   If the order is a "SALES_ORDER," the shipment type is set to "SALES_SHIPMENT."
 
2.  **Set Origin Facility (For Store Shipments):**
    *   If the shipment is a "SALES_SHIPMENT" from a store with a single inventory facility, and the `originFacilityId` is not already set, retrieve the `ProductStore` entity and set the `originFacilityId` to the store's `inventoryFacilityId`.

3.  **Set Party Information (From/To):**
    *   Fetche `OrderRole` entities associated with the order.
    *   If `partyIdFrom` (the party shipping the goods) is not set, try to find it from the order roles with the "SHIP_FROM_VENDOR" role types.
    *   If `partyIdTo` (the party receiving the goods) is not set, try to find it from the order roles with the "SHIP_TO_CUSTOMER" or "CUSTOMER" role types.

4.  **Set Contact Information:**
    *   Fetche `OrderContactMech` entities associated with the order.
    *   If `destinationContactMechId` (shipping address) is not set, it tries to find it from the order contact mechanisms with the "SHIPPING_LOCATION" purpose.
    *   If `originContactMechId` is not set, it tries to find it from the order contact mechanisms with the "SHIP_ORIG_LOCATION" purpose.
    *   Similary set `destinationTelecomNumberId` and `originTelecomNumberId` (phone numbers).

5.  **Handle Special Case for Store Pickup:**
    *   If the order is a "SALES_ORDER" and the shipment method is "STOREPICKUP," the `destinationContactMechId` is set to the same value as `originContactMechId`.

6. **Create Shipment Route Segment:**
    *   If no `ShipmentRouteSegment` exists for the shipment, it create one using the gathered information (origin/destination facilities, contact mechanisms, shipping method, carrier, etc.).

**Prepare data for ShipmentItem**

1.  **Extraction of Item Details:**

    *   For each item in the `Shipmentitems` :
        *   `productId`: The ID of the product to be included in the shipment.
        *   `sku`: The SKU (Stock Keeping Unit) of the product, which can be used to look up the `productId` if it's not provided directly.
        *   `itemSeqId`: A sequence ID for the shipment item, likely used for ordering or identification within the shipment.
        *   `orderItemSeqId`: The sequence ID of the corresponding order item from the original order.
        *   `quantity`: The quantity of the product to be included in the shipment.

2.  **Product ID Resolution:**

    *   If the `productId` is not provided but the `sku` is,  lookup database in the `Product` entity to find the corresponding `productId` based on the `internalName` (which is assumed to be the SKU).

3.  **Data Conversion:**

    *   The `quantity` value, which might be provided as a string or another numeric type, is explicitly converted to a `BigDecimal` using `ObjectType.simpleTypeConvert`. This ensures accurate representation of quantities, especially for fractional values.

**Rules and Error Handling:**

*   **Required Fields:** Either `productId` or `sku` is required for each item. If both are missing, an error is added to the `errorList`.
*   **Valid Product:** The provided `productId` or the `productId` derived from the `sku` must exist in the `Product` entity. If not, an error is added to the `errorList`.
*   **Quantity Conversion:** The `quantity` must be convertible to a `BigDecimal`. While the code doesn't explicitly handle a `NumberFormatException`, it's good practice to add error handling for this scenario.

**Prepares data to  `createOrderShipment`**

2.  **Order and Ship Group Information:**
    *   Check if both `orderId` (the ID of the order) and `shipGroupSeqId` (the sequence ID of the shipment group within the order) are available. If so, it proceeds to create `OrderShipment` entities.

3.  **Order Shipment Context Creation:**
    *   A `createOrderShipmentCtx` map is created to hold the data for the `createOrderShipment` service call.
    *   The map is populated with the following key-value pairs:
        *   `"shipmentId"`: The ID of the shipment.
        *   `"shipmentItemSeqId"`: The sequence ID of the shipment item obtained in step 1.
        *   `"orderId"`: The ID of the order.
        *   `"userLogin"`: The userLogin object representing the user performing the operation.

4.  **OrderItemShipGroup Retrieval:**
    *   The code queries the database for an `OrderItemShipGroup` entity that matches the `orderId`, `productId` (of the current item), `shipGroupSeqId`, and has a `statusId` of either "ITEM_APPROVED" or "ITEM_CREATED."
    *   This entity represents the association between an order item and a shipment group.

6.  **Order Shipment Creation:**
    *   If an `OrderItemShipGroup` entity is found, use `shipGroupSeqId` and `orderItemSeqId`.

1.  **Package Details Extraction:**
    *   Package as following details:
        *   `boxTypeId`: The type of box used for the package.
        *   `packageSeqId`: A sequence ID for the package, likely used for ordering or identification within the shipment.
        *   `dimensionUomId`: The unit of measurement for the package dimensions (e.g., "LEN_in" for inches).
        *   `weightUomId`: The unit of measurement for the package weight (e.g., "WT_lb" for pounds).
        *   `boxLength`, `boxHeight`, `boxWidth`, `weight`: The dimensions and weight of the package.
        *   `items`: A list of items included in the package (this is used later for creating `ShipmentPackageContent` entities).

2.  **Default Values and Conversions:**
    *   If `boxTypeId` is not provided, it defaults to a value from the configuration ("YOURPACKNG" in this case).
    *   If `weightUomId` is not provided, it tries to get it from the origin facility's default or a system-wide default ("WT_lb").
    *   If `dimensionUomId` is not provided, it defaults to a system-wide default ("LEN_in").
    *   The `boxLength`, `boxHeight`, `boxWidth`, and `weight` values are converted to `BigDecimal` for precision.

3.  **Shipment Package Context Creation:**
    *   A `shipmentPackage` map is created to hold the data for the `ShipmentPackage`.
    *   The map is populated with the following key-value pairs:
        *   `"shipmentId"`: The ID of the shipment.
        *   `"shipmentPackageSeqId"`: The sequence ID of the package.
        *   `"boxLength"`, `"boxHeight"`, `"boxWidth"`, `"weight"`: The package dimensions and weight (as `BigDecimal`).
        *   `"shipmentBoxTypeId"`: The type of box.
        *   `"dimensionUomId"`: The unit of measurement for dimensions.
        *   `"weightUomId"`: The unit of measurement for weight.
        *   `"userLogin"`: The userLogin object representing the user performing the operation.

**Rules and Error Handling:**

*   **Dimension and Weight UoM Validation:** The `dimensionUomId` and `weightUomId` are validated against the `Uom` entity to ensure they are valid units of measurement for length and weight, respectively.
*   **Box Type Validation:** If `boxTypeId` is provided, it's validated against the `ShipmentBoxType` entity.


The code that prepares data `ShipmentPackageContent`: 

1.  **Outer Loop (Packages):** Iterates over each package in the `packages` list from the input.

2.  **Inner Loop (Package Items):** Iterates over the `items` list within each package.

1.  **Shipment and Package IDs:**
    *   The `shipmentId` (of the overall shipment) and `shipmentPackageSeqId` (of the current package) are obtained from the outer scope.

2.  **Product ID Resolution:**
    *   For each item in the package, the code checks if `productId` is provided. If not, and `sku` is available, it fetche the corresponding `productId` from the `Product` entity using the `internalName` (assumed to be the SKU).

3.  **Shipment Item Sequence ID Resolution:**
    *   If `shipmentItemSeqId` (the sequence ID of the shipment item) is not provided, find it by querying the `ShipmentItem` entity based on the `shipmentId` and `productId`. This assumes that the `ShipmentItem` entities were already created earlier.

4.  **Quantity Conversion:**
    *   If the `quantity` of the item in the package is provided, it's converted to a `BigDecimal` for precision.

5.  **Context Map Creation:**
    *   the `shipmentPackageContent` map is populated with:
        *   `"shipmentId"`
        *   `"shipmentPackageSeqId"`
        *   `"shipmentItemSeqId"` (if found)
        *   `"quantity"` (if provided and converted to `BigDecimal`)

**Rules and Error Handling:**

*   **Product ID or SKU Required:** Either `productId` or `sku` must be provided for each item in the package.
*   **Valid Product:** The `productId` (whether provided directly or derived from the `sku`) must exist in the `Product` entity.
*   **Shipment Item Existence:** The `shipmentItemSeqId` must correspond to an existing `ShipmentItem` within the shipment.
