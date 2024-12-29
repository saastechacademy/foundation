# Inventory Management systems 

[Inventory data model](../../oms/Inventory.md)

The Distribution center or Retail store are modelled as [Facility](../../oms/Facility.md), The [Inventory](../../oms/Inventory.md) for Products managed at the given facility is configured in [ProductFacility](../../oms/ProductFacility.md). 
Each location has one InventoryItem to track ATP, and QOH any given product at the facility. 
Always use [findOrCreateFacilityInventoryItem](../../oms/findOrCreateFacilityInventoryItem.md) get InventoryItem for product at facility.

[createExternalInventoryReset](../../oms/createExternalInventoryReset.md) is used to load initial inventory levels at a Facility, This same service is used to periodic inventory level sync with the Inventory Master (ERP) in the Organization. 
Use [receivePurchaseShipment](receivePurchaseShipment.md) for incoming shipments. 
To record corrections in systemic inventory data, use [createPhysicalInventory](../../oms/createPhysicalInventory.md)

OMS order brokering process, assigns orders to the facility for fulfillment and [createOrderItemInventoryReservation](../../oms/createOrderItemInventoryReservation.md) for each orderItem. 
The [rejectOrderItem](../rejectOrderItem.md) process also [Cancel Inventory reservation](../../oms/cancelOrderItemInvRes.md).


## Rejection:
1. Single ATP reduced by rejection
2. Single ATP and QoH reduced by rejection
3. Both of the above but for all qty
4. Release reservation and increase ATP
Link Order and Item to event

## Cycle Count:
1. Variance QoH to match counted Qty
2. Variance ATP to match counted Qty - Reservations
Link count and count item to event

## Log variance:
1. Log variance on ATP and QoH by given amount with given reason
Link userLogin to event

## Item shipped:
1. Reduce ATP for reservation
2. Reduce QoH for item shipped
Link order,, order item, shipment and shipment item to both events

## POS Sale:
1. Inventory issuance for the POS sale should follow the process similar to online sale, create shipment and ship it to complete orderItem. As expected, QOH will be reduced.

##  Increase ATP and QoH
Link order, orderItem, shipment and shipmentItem, resetItemId to event using IID

## ProductFacility.inventoryItemId
* Add InventoryItemId to ProductFacility
* Stop maintaining LastInventoryCount on ProductFacility
* Create a view  "ProductFacilityInventoryItem" on InventoryItem and ProductFacility where ProductFacilityInventoryItem.ATP is InventoryItem.ATP, ProductFacilityInventoryItem.computedInventoryCount is =  (InventoryItem.ATP - ProductFacility.MinimumStock).
