# quickShipOrderShipGroup

API to fulfill orders. 
Shortcut method, if fulfillment center is not executing full pick/pack/ship steps on the floor. 

1. Service Call: `co.hotwax.poorti.FulfillmentServices.create#SalesOrderShipment`
2. Service Call (Iteration): `co.hotwax.poorti.SearchServices.update#OrderFulfillmentStatus`
3. packShipment
4. shipShipment
    - completeOrderItem
