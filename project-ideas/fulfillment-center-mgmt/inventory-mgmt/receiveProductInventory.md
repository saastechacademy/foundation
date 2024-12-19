# `receiveProductInventory`

```json
{
  "facilityId": "Facility123",
  "productId": "Product456",
  "orderId": "Order789",
  "orderItemSeqId": "00001",
  "shipmentId": "ShipmentABC",
  "shipmentItemSeqId": "00001"
  "reasonEnumId": "VAR_SHIP_RECV", 
  "quantityAccepted": 10,
  "quantityRejected": 2,  
}
```


1. Inventory Item Handling:
    * reasonEnumId is the enum of type "IID_REASON". The Inventory Item Detail Reason is saved in InventoryItemDetail record. 
    * It checks if `inventoryItemId` is provided.
    * If not, call helper service to get [inventoryItemId](findOrCreateFacilityInventoryItem.md)

2. Inventory Item Detail and Shipment Receipt:
    * call the `createInventoryItemDetail` service to record the change in inventory.
    * call the `createShipmentReceipt` service to create a record of the shipment receipt.

   

OOTB OFBiz has, The call to `updateInventoryItem` service in the `receiveInventoryProduct` service.
In OMS, we don't need to call `updateInventoryItem` from `receiveInventoryProduct` service because, 
the `updateInventoryItem` updates attributes other than `availableToPromiseTotal` and `quantityOnHandTotal`. None of those attributes of used in OMS. 


```xml
<EnumerationType description="Inventory Item Detail Reason" enumTypeId="IID_REASON" hasTable="N" />
<Enumeration enumId='CYCLE_COUNT' enumName='Cycle count' description='Cycle count' enumCode='CYCLE_COUNT' sequenceId='09' enumTypeId='IID_REASON'/>
<Enumeration enumId='POS_SALE' enumName='POS Sale' description='POS Sale' enumCode='POS_SALE' sequenceId='20' enumTypeId='IID_REASON'/>
<Enumeration enumId='VAR_DAMAGED' enumName='Damaged' description='Damaged' enumCode='VAR_DAMAGED' sequenceId='04' enumTypeId='IID_REASON'/>
<Enumeration enumId='VAR_FOUND' enumName='Found' description='Found' enumCode='VAR_FOUND' sequenceId='03' enumTypeId='IID_REASON'/>
<Enumeration enumId='VAR_INTEGR' enumName='Integration' description='Integration' enumCode='VAR_INTEGR' sequenceId='06' enumTypeId='IID_REASON'/>
<Enumeration enumId='VAR_LOST' enumName='Adjustment' description='Adjustment' enumCode='VAR_LOST' sequenceId='01' enumTypeId='IID_REASON'/>
<Enumeration enumId='VAR_MANUAL' enumName='Variance recorded manually' description='Variance recorded manually' enumCode='VAR_MANUAL' sequenceId='21' enumTypeId='IID_REASON'/>
<Enumeration enumId='VAR_MISSHIP_ORDERED' enumName='Mis-shipped Item Ordered' description='Mis-shipped Item Ordered (+)' enumCode='VAR_MISSHIP_ORDERED' sequenceId='07' enumTypeId='IID_REASON'/>
<Enumeration enumId='VAR_MISSHIP_SHIPPED' enumName='Mis-shipped Item Shipped' description='Mis-shipped Item Shipped (-)' enumCode='VAR_MISSHIP_SHIPPED' sequenceId='08' enumTypeId='IID_REASON'/>
<Enumeration enumId='VAR_SAMPLE' enumName='Sample (Giveaway)' description='Sample (Giveaway)' enumCode='VAR_SAMPLE' sequenceId='05' enumTypeId='IID_REASON'/>
<Enumeration enumId='VAR_STOLEN' enumName='Stolen' description='Stolen' enumCode='VAR_STOLEN' sequenceId='02' enumTypeId='IID_REASON'/>
<Enumeration description="Scheduled Incoming Shipment Received" enumCode="VAR_SCH_SHIP_RECV" enumId="VAR_SCH_SHIP_RECV" enumTypeId="IID_REASON" enumName="Scheduled Shipment Received"/>
<Enumeration description="Incoming Shipment Received" enumCode="VAR_SHIP_RECV" enumId="VAR_SHIP_RECV" enumTypeId="IID_REASON" enumName="Shipment Received"/>
<Enumeration description="Reset by External System" enumCode="VAR_EXT_RESET" enumId="VAR_EXT_RESET" enumTypeId="IID_REASON" enumName="Reset By External System"/>
<Enumeration description="Transfer Order Shipped" enumCode="VAR_TRFR_ORD_SHIPPED" enumId="VAR_TRFR_ORD_SHIPPED" enumTypeId="IID_REASON" enumName="TO Shipment Shipped"/>


```