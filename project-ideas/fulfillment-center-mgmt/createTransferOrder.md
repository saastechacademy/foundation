# create#TransferOrder

The API for managing TO builds on the [createOrder](../oms/createOrder.md)

Transfer Order is created and processed for moving inventory within the Organization. 

A Transfer order could be created in third party system e.g NetSuite. 
A Transfer order could be processed in third party WMS / Fulfillment application. 
A TO might be imported in the OMS system for a Shipment shipped from third party system to be received in fulfillment location managed by OMS 
A TO might be imported in the OMS system for a Shipment to be shipped from fulfillment location managed by OMS
What if, The TO is created to move inventory between two facilities managed by OMS. 
Do we need two TO:
a TO be created for shipping shipment from a store and then another TO for receiving the shipment at the other store?


