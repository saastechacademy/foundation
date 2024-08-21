### reinitializeShipment

The `reinitializeShipment` service is designed to reset a shipment to its initial state, specifically to the `SHIPMENT_INPUT` status. This is often done when modifications need to be made to a shipment after it has been approved or partially processed.

### Input Parameters

*   `shipmentId` (String): The ID of the shipment that needs to be reinitialized.

### Use Cases

This service is typically used in scenarios where:

*   **Item Rejection:** When an item within a shipment is rejected, the shipment might need to be reinitialized to allow for adjustments and potential reassignment of items.
*   **Shipment Modification:** If there are changes to the shipment details (e.g., shipping address, carrier), reinitializing the shipment can reset it to a state where these changes can be made.
*   **Error Correction:** If an error occurred during the initial shipment processing, reinitializing can provide a clean slate to correct the issue.
*   **Updating package box types:** In the `updateInProgressOrder` function, if the shipment label hasn't been generated or the box type has changed, the shipment is reinitialized.
*   **Processing ready-to-pack items:** In the `updateInProgressOrder` function, if an item needs to be moved to a different shipment, both the original and new shipments are reinitialized.
*   **Handling item rejections:** In the `updateInProgressOrder` function, the shipment is reinitialized for items with specific rejection reasons.


