Omnichannel OMS 
The core of retail business. 

Depends on 
https://github.com/hotwax/ofbiz-oms-udm/tree/main

The OMS is intended to be used by applications designed for human or other system integrations. 

This also means, 
OMS should not have to publish REST resources. They should be part of application or integration compoonents? 

Ideal Customer Profile.

https://github.com/saastechacademy/foundation/blob/main/ubpl/NotNaked/Introduction.md


Responsibility assignment. 

oms is a collection of services to make it easy for application developers to build solutions. 

createShipment. 
The shipment by itself is abstract idea. It is received or shipped for a reason, and it could  be "_NO_REASON_". 

SubTypes (derivative services)
The idea of shipment gets interesting in the context of Order. Could be Sales, Purchase, Transfer or any other type of Order. 

createSalesOrderShipment
createTransferOrderShipment
createPurchaseOrderShipment 




