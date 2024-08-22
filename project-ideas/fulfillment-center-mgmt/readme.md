# **Fulfillment Application Design Document**

Order fulfillment is 3 step process,
*   Step 1: The staff at Gets the list of [Outstanding orders](https://github.com/hotwax/oms-documentation/blob/user-guides-pub/documents/integrate-with-hotwax/api/fulfillment/apis/outstanding-orders.md). The fulfillment process starts with creating a [Fulfillment wave of orders](createOrderFulfillmentWave.md). A [PickList](PickList.md) is returned for the user to go pick items for preparing the shipments.  
*   Step 1 - Background process: [Shipments](createShipment.md) are created for orders. Based on the inventory allocation rules inventory from a certain location is assigned to [Shipment](/udm/intermediate/Shipment.md). The shipment data is then used to prepare a picklist based on preferred picking strategy, a background process is initiated to get shipping labels from the shipping provider.
*   Step 2: User completes the Packing.
*   Step 3: User marks Shipment shipped.   

Shipment is created in SHIPMENT_INPUT, then SHIPMENT_APPROVED to SHIPMENT_PACKED and then SHIPMENT_SHIPPED

* On the SHIPMENT_APPROVED status event of Shipment lifecycle,  systems triggers the process to get Shipping Label (doRateShopping) from the logistics company.
* On successful execution of shipping label RateShopping, the RateShopping service updates the update ShipmentRouteSegment. Set `shipmentMethodTypeId`, `carrierPartyId`, `actualCost`, `carrierServiceStatusId` (SHRSCS_CONFIRMED). 
* Once we have Shipping label, Shipment can be moved to SHIPMENT_PACKED status. 

Modify contents of the Shipment after it is already SHIPMENT_APPROVED or SHIPMENT_PACKED. 

1. If the Approved shipment should be edited, The Shipment is first [reinitializeShipment](reinitializeShipment.md). 
2. In case the Packed shipment should be edited, It is first [Unpacked](unpackOrderItems.md). The Unpacking process moves the shipment to Approved status.
3. If Shipment package contents are modified i.e a Shipment was moved from SHIPMENT_APPROVED status to SHIPMENT_INPUT, ensure to [voidShipmentPackageLabel](voidShipmentPackageLabel.md). Recompute the [ShipmentPackageWeight](setShipmentPackageWeight.md).
4. In some cases, after edits we may have hanging some Shipments without any ShipmentItem. Use [cancelEmptyShipments](cancelEmptyShipments.md) to cancel them. 
