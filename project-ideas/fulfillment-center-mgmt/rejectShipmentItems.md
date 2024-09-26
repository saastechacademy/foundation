# rejectShipmentItems(condition, maySplit)

The service will accept parameters that will allow client application to go as narrow or open as possible. 

If specific shipmentItem should be rejected, pass is, shipmentId and shipmentItemId
If you want to reject whole shipment that contains the above shipment, pass maySplit:'Y'

If you want to reject all shipments that have items for shipping certain product pass facilityId and productId: `myProductId`, `originFacilityId`

### Permission 


**IN Parameters:**
*   shipmentId
*   shipmentItemId
*   productId
*   shipmentTypeId, default to SALES_SHIPMENT
*   statusId, default to SHIPMENT_APPROVED
*   originFacilityId, 
*   maySplit, default to 'Y'
*   reasonEnumId


