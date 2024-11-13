# OMS/Shopify Fulfillment Sync Redesign

## Problem Statement
Current implementation to generate a fulfilled order items feed is a generic implementation to supply order fulfillment details to any number of external systems like ERP, WMS, Shopify, etc.
It requires further complex transformations involving database reads via NiFi to generate a fulfilled order items feed consumable by Shopify. It becomes a huge overhead when we process large number of order fulfillment across significant number of stores and warehouses.
It further adds to the latency in overall processing time.  
The external references for Shopify fulfillments also needs to be synced back to OMS which again is processed via Nifi even though it's a simple database update in a single entity.  
Additionally, since it's a generic implementation a complex database view with lots of required and optional input conditions is used to generate the feed with heavy order fulfillment objects containing a lot of details unnecessary for Shopify.  

A simplified OMS/Shopify fulfillment sync flow should be implemented by eliminating NiFi transformation overhead and producing only necessary fulfillment data for Shopify.

## TO-BE Design

The new implementation should support fulfillment sync for following two broad level scenarios,
1. Physical Order Item Fulfillment - A physical shipment with carrier, shipment method and tracking information.
2. Digital Order Item Fulfillment - No physical shipment and tracking information, auto fulfilled when order is approved.

Additionally, implementation should also consider consuming ShopifyFulfillmentAckFeed.

### Physical Order Item Fulfillment Sync Design
1. Define a new SystemMessageType - *GenerateOMSFulfillmentFeed*.
2. sendPath should be the local runtime path where feed should be generated.
3. Implement sendService *generate#OMSFulfillmentFeed* as described in next section.
4. Define optional SystemMessageTypeParameter - *sendSmrId*, if generated feed needs to be sent to SFTP location then populate it with systemMessageRemoteId of the remote SFTP server. sendService will use this info.
5. Define and configure *SendOMSPhysicalFulfillmentFeed* SystemMessageType if feed needs to be sent to SFTP.
6. Implement service *queue#OMSPhysicalFulfillmentFeed* for preparing SystemMessage context and queuing the SystemMessage periodically.
   - **Input**
     - systemMessageRemoteId*
     - systemMessageTypeId*
     - runAsBatch (defaults to **False**)
     - shipmentId
     - orderId
     - includeDigitalItems (defaults to **Y**)
     - fromDate
     - thruDate
   - Below are the service job parameters for the scheduled job
     - systemMessageRemoteId*
     - systemMessageTypeId*
     - runAsBatch(will be True)
     - fromDate
   - The service job that will be scheduled will have fewer parameter than what the service supports.
   - For running as batch, use the scheduled service job and to run for a particular orderId, run the service.
   - For the scheduled service runAsBatch will be set to **True** and when running for a specific orderId then the runAsBatch will be **False**.
   - In the service, handling will be added to set the messageDate(in systemMessage) to now date when the runAsBatch parameter is True.
   - When the runAsBatch parameter is set to False then the messageDate will not be set. This is done so that whenever 
     the service is run for a specific orderId then its messageDate is not picked up for the next scheduled job run and does not disturb the batch processing of orders.
   - If fromDate is empty fetch last successful *GenerateOMSFulfillmentFeed* SystemMessage where messageDate is not null and if found set it's messageDate as fromDate
   - Prepare messageText with following map input - *shipmentId, orderId, fromDate, thruDate*
   - Call *queue#SystemMessage* service with *sendNow=true*

#### *generate#OMSFulfillmentFeed* service implementation details
1. Fetch SystemMessage record
2. Fetch related SystemMessageRemote
3. Fetch shopId from SystemMessageRemote.remoteId
4. Use shopId and parameters as available from SystemMessage.messageText to fetch shipmentIds from *ShopifyShopOrderShipmentAndStatus* view, view details defined in next section.
5. Initiate a local file for the json feed.
6. Iterate thru shipmentIds, fetch ShipmentRouteSegment for carrierPartyId and trackingNumber, prepare shipmentDetail map from *OrderShipmentDetail* view, view details defined in next section. shipmentDetails map should have following information,
   - shipmentId
   - shopifyOrderId
   - lineItems
     - shopifyLineItemId
     - quantity (aggregated by shopifyLineItemId)
   - trackingNumber
   - trackingUrl - fetch from SystemProperty and append tracking number to prepare this url
   - carrier
   - notifyCustomer - fetch from configuration
7. In step 6 make sure to handle kits/bundles by fetching distinct records from OrderShipmentDetail view by orderId, orderItemSeqId, shipmentId.
8. Write the JSON to the feed file
9. If *sendSmrId* SystemMessageTypeParameter is defined, queue *SendOMSPhysicalFulfillmentFeed* SystemMessage

#### View Entities
1. ShopifyShopOrderShipmentAndStatus
   - ShopifyShopOrder
     - shopId
     - orderId
     - shopifyOrderId
   - Shipment
     - shipmentId
     - shipmentTypeId
     - statusId
     - primaryOrderId (view link)
     - externalId
   - ShipmentStatus
     - shipmentId
     - statusId
     - statusDate
2. OrderShipmentDetail
   - OrderShipment
     - orderId
     - orderItemSeqId
     - shipmentId
     - quantity
   - OrderItem
     - orderId
     - orderItemSeqId
     - externalId
     - productId
   - Product
     - productTypeId
   - ProductType
     - isDigital

#### Related Shopify Connector Changes
1. Remove aggregatedLineItemMap from *co.hotwax.shopify.fulfillment.ShopifyFulfillmentServices.create#Fulfillment* service as new implementation would provide aggregated quantity by shopifyLineItemId.
2. Since we don't need OMS orderId and orderItemSeqId anymore remove it's references in co.hotwax.shopify.ShopifyFulfillmentServices.generate#ShopifyFulfillmentAckFeed.

### Digital Order Item Fulfillment Sync Design
To further simplify various aspects of fulfillment like sync with external systems, reporting, reconiciliation, we should create dummy shipments in shipped status for digital order items as soon as they are marked as completed. Once that is implemented there won't be a need to design a separate fulfillment sync flow for digital order items as above design should be able to accomodate it.  
To create dummy shipment for digital order items, we could simply create records in just the following entities,
1. Shipment
2. ShipmentStatus
3. ShipmentItem
4. OrderShipment

### Consume ShopifyFulfillmentAckFeed
1. Define a new SystemMessageType - *ShopifyFulfillmentAckFeed* to receive file from SFTP, store it locally and consume it.
2. Implement *consume#ShopifyFulfillmentAckFeed* consumeService that would iterate through json maps in the feed and update shipment.externalId from externalFulfillmentId in the map. 
