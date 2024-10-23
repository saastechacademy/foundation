# OMS/Shopify Fulfillment Sync Redesign

## Problem Statement
Current implmentation to generate a fulfilled order items feed is a generic implementation to supply order fulfillment details to any number of external systems like ERP, WMS, Shopify, etc.
It requires further complex transformations involving database reads via NiFi to generate a fulfilled order items feed consumable by Shopify. It becomes a huge overhead when we process large number of order fulfillment across significant number of stores and warehouses.
It further adds to the latency in overall processing time.  
The external references for Shopify fulfillments also needs to be synced back to OMS which again is prcessed via Nifi even though it's a simple database update in a single entity.  
Additionally, since it's a generic implementation a complex database view with lots of required and optional input conditions is used to generate the feed with heavy order fulfillment objects containing a lot of details unnecessary for Shopify.  

A simplified OMS/Shopify fulfillment sync flow should be implemented by eliminating NiFi transformation overhead and producing only necessary fulfillment data for Shopify.

## TO-BE Design

The new implementation should support fulfillment sync for following two broad level scenarios,
1. Physical Order Item Fulfillment - A physical shipment with carrier, shipment method and tracking information.
2. Digital Order Item Fulfillment - No physical shipment and tracking information, auto fulfilled when order is approved.

Additionally, implementation should also consider consuming ShopifyFulfillmentAckFeed.

### Pysical Order Item Fulfillment Sync Design
1. Define a new SystemMessageType - *GenerateOMSPhysicalFulfillmentFeed*.
2. sendPath should be the local runtime path where feed should be generated.
3. Implement sendService *generate#OMSPhysicalFulfillmentFeed* as described in next section.
4. Define optional SystemMessageTypeParameter - *sendSmrId*, if generated feed needs to be sent to SFTP location then populate it with systemMessageRemoteId of the remote SFTP server. sendService will use this info.
5. Define and congigure *SendOMSPhysicalFulfillmentFeed* SystemMessageType if feed needs to be send to SFTP.
6. Implement service *queue#OMSPhysicalFulfillmentFeed* for preparing SystemMessage context and queing the SystemMessage periodically.
   - **Input**
     - systemMessageRemoteId*
     - shipmentId
     - orderId
     - fromDate
     - thruDate
   - If fromDate in empty fetch last successful *GenerateOMSPhysicalFulfillmentFeed* SystemMessage and if found set it's processedDate as fromDate
   - Prepare messageText with following map input - *shipmentId, orderId, fromDate, thruDate*
   - Call *queue#SystemMessage* service with *sendNow=true*

#### *generate#OMSPhysicalFulfillmentFeed* service implementation details
1. Fetch SystemMessage record
2. Fetch related SystemMessageRemote
3. Fetch shopId from SystemMessageRemote.remoteId
4. Use shopId and parameters as available from SystemMessage.messageText to fetch shipmentIds from *ShopifyShopOrderShipmentAndStatus* view, view details defined in next section.
5. Initiate a local file for the json feed.
6. Iterate thru shipmentIds to prepare shipmentDetail map from *OrderShipmentDetail* view, view details defined in next section. shipmentDetails map should have following information,
   - shopifyOrderId
   - lineItems
     - shopifyLineItemId
     - quantity
   - trackingNumber
   - trackingUrl - fetch from SystemProperty and append tracking number to prepare this url
   - carrier
   - notifyCustomer - fetch from configuration
7. Write the JSON to the feed file
8. If *sendSmrId* SystemMessageTypeParameter is defined, queue *SendOMSPhysicalFulfillmentFeed* SystemMessage
