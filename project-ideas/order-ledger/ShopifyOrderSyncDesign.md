# Shopify/OMS Order Sync Design

Newly created orders and specific order updates in Shopify needs to be synced timely to OMS. This design document is specific to syncing newly created Shopify orders.   
Following would be the flow to sync products,
1. **mantle-shopify-connector** would produce a periodic json feed of newly created orders.
2. **shopify-oms-bridge** would consume this feed and transform it to produce OMS orders json feed.
3. **oms** would consume the transformed product json feed and establish orders in OMS database via order API.

> Notes
> - Not setting origin facility contact mechs as it doesn't make sense for already completed or cancelled orders or until the order is brokered.
> - Designs reflect the assumption that order items will always be exploded.

> TODO
> - Support to create a dummy product for non-existing Shopify product

## Shopify Connector
Shopify connector would produce a periodic created orders feed since last run time with following fields,

## Shopify OMS Bridge

Periodically receive and consume ShopifyNewOrdersFeed and transform to generated OMSNewOrdersFeed.
Following are the implementation details,
1. Define and configure *ShopifyNewOrdersFeed* SystemMessageType to import Shopify new orders feed, define *consumeSmrId* SystemMessageType parameter to be used in the next system message produced in consume service. Refer *ShopifyOrderCancelUpdatesFeed* SystemMessageType.
2. Generic service *consume#ShopifyFeed* to be used as consume service for this flow.
3. Define and configure *GenerateOMSNewOrdersFeed* SystemMessageType, refer *GenerateOMSOrderCancelUpdatesFeed* SystemMessageType. Configure *sendSmrId* SystemMessageTypeParameter to send the feed to SFTP.
4. Implement sendService *generate#OMSNewOrdersFeed*, refer implementation details below.
5. Define and configure *SendOMSNewOrdersFeed* SystemMessageType to send the feed to SFTP.

### [generate#OMSNewOrdersFeed](generateOMSNewOrdersFeed.md)

### [map#SalesOrder](mapSalesOrder.md)

## OMS API

### [create#PostalAddress](createPostalAddress.md)

### [create#Customer](createCustomer.md)

### [create#SalesOrder](createSalesOrder.md)
