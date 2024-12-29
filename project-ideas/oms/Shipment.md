# Shipment 

### **Entity Definitions** 

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

7.  **ItemIssuance:**
    *   ItemIssuance ID (Primary Key)
    *   ShipmentItem ID (Foreign Key referencing ShipmentItem entity)
    *   Quantity
    *   Timestamp
    *   `inventoryItemId`: The specific inventory item that was issued.
    *   `issuedByUserLoginId`: The user who issued the item.
    *   `issuedDateTime`: Date and time the item was issued.

![ERD](Shipment_ER_Diagram.png)


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

<ItemIssuance createdStamp="2024-06-26 01:57:03.972" createdTxStamp="2024-06-26 01:57:03.804" inventoryItemId="21850" issuedByUserLoginId="hotwax.user" issuedDateTime="2024-06-26 01:57:03.972" itemIssuanceId="10004" lastUpdatedStamp="2024-06-26 01:57:03.972" lastUpdatedTxStamp="2024-06-26 01:57:03.804" orderId="10203" orderItemSeqId="00101" quantity="1.000000" shipGroupSeqId="00001" shipmentId="10013" shipmentItemSeqId="00001"/> 
<ItemIssuance createdStamp="2024-06-26 01:57:04.054" createdTxStamp="2024-06-26 01:57:03.804" inventoryItemId="21070" issuedByUserLoginId="hotwax.user" issuedDateTime="2024-06-26 01:57:04.054" itemIssuanceId="10005" lastUpdatedStamp="2024-06-26 01:57:04.054" lastUpdatedTxStamp="2024-06-26 01:57:03.804" orderId="10203" orderItemSeqId="00102" quantity="1.000000" shipGroupSeqId="00001" shipmentId="10013" shipmentItemSeqId="00002"/>

```

