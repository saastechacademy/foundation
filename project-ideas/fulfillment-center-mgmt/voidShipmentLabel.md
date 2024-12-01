## Reset the ShipmentRouteSegment entity for the Shipment. 

One of the use case for this services is, when user wants to manually get shipping label, before retry, first clear previous shipping label details. 
The other case, is when we modify Shipment Package after it was packed, once package contents are modified we have to void previous shipping label and get new one.

```
    public static Map<String, Object> voidShipmentPackageLabel(DispatchContext dctx, Map<String, Object> context) {
        Delegator delegator = dctx.getDelegator();
        String shipmentId = (String) context.get("shipmentId");
        String shipmentPackageSeqId = (String) context.get("shipmentPackageSeqId");
        try {
            GenericValue shipmentPackageRouteSeg = EntityQuery.use(delegator).from("ShipmentPackageRouteSeg").where("shipmentId", shipmentId, "shipmentPackageSeqId", shipmentPackageSeqId).queryFirst();
            if (shipmentPackageRouteSeg != null) {
                shipmentPackageRouteSeg.set("labelImage", null);
                shipmentPackageRouteSeg.set("labelImageUrl", null);
                shipmentPackageRouteSeg.set("trackingCode", null);
                shipmentPackageRouteSeg.set("labelHtml", null);
                shipmentPackageRouteSeg.store();
            }
        } catch (GenericEntityException e) {
            Debug.logError(e, MODULE);
            return ServiceUtil.returnError(e.getMessage());
        }
        return ServiceUtil.returnSuccess();
    }

```
