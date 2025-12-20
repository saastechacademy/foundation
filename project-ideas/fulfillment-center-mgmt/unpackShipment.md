## unpackShipment

1. **Input:**

```json
{
  "shipmentId": "10025"
}
```

2. **Update Shipment Status:**
   * Set `Shipment.statusId` to `SHIPMENT_APPROVED`.
   * This service does **not** call `approveShipment` to avoid triggering rate shopping or label generation.

3. **Update Order Item Fulfillment Status:**
   * Find `OrderShipment` records for the shipment.
   * Update each order item fulfillment status to `InProgress` in Solr.

4. **Postcondition:**
   * Shipment returns to an editable, in-progress state and can be re-packed.

