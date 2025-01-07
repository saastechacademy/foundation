# Shopify/OMS New Products Sync Design

Newly created products and product updates in Shopify needs to be synced timely to OMS. This design document is specific to syncing newly created Shopify products.  
Shopify has virtual and variant products. An ideal situation would have to sync virtual and variant products in separate batch processes, but since Shopify GraphQL API doesn't let variants to be filtered by created date, we will have to sync these together in a single batch process.  
Following would be the flow to sync products,
1. **mantle-shopify-connector** would produce a periodic json feed of newly created products.
2. **shopify-oms-bridge** would consume this feed and transform it to produce OMS product json feed.
3. **oms** would consume the transformed product json feed and establish products in OMS database via product API.

> NOTE
> - We will not store shopify product tags in relational database as there isn't any functional need of those, we can store them directly in document database as needed so skipping them for now.

## Shopify Connector
Shopify connector would produce a periodic created products feed since last run time with following fields,
* id
* handle
* title
* featuredMedia
  * mediaContentType
    * preview 
      * image
        * url
* options
  * id
  * name
  * position
  * optionValues
    * id
    * name
* tags
* variants
  * id
  * title
  * sku
  * barcode
  * price
  * compareAtPrice
  * position
  * requiresComponents
  * selectedOptions
    * name
    * value
  * inventoryItem
    * id
    * requiresShipping
    * measurement
      * weight
        * unit
        * value
* bundleComponents
* hasVariantsThatRequiresComponents

## Shopify OMS Bridge

Periodically receive and consume ShopifyNewProductsFeed and transform to generated OMSNewProductsFeed.
Following are the implementation details,
1. Define and configure *ShopifyNewProductsFeed* SystemMessageType to import Shopify new products feed, define *consumeSmrId* SystemMessageType parameter to be used in the next system message produced in consume service. Refer *ShopifyOrderCancelUpdatesFeed* SystemMessageType.
2. Convert *consume#ShopifyOrderCancelUpdatesFeed* service to a generic service *consume#ShopifyFeed* to be used as consume service for this flow as well.
3. Define and configure *GenerateOMSNewProductsFeed* SystemMessageType, refer *GenerateOMSOrderCancelUpdatesFeed* SystemMessageType. Configure *sendSmrId* SystemMessageTypeParameter to send the feed to SFTP.
4. Implement sendService *generate#OMSNewProductsFeed*, refer implementation details below.
5. Define and configure *SendOMSNewProductsFeed* SystemMessageType to send the feed to SFTP.

### [generate#OMSNewProductsFeed](generateOMSNewProductsFeed.md)

### [map#Product](mapProduct.md)

### [map#ProductVariant](mapProductVariant.md)

## OMS API

### Seed Data
```xml
<moqui.service.message.SystemMessageType systemMessageTypeId="FeedErrorFile"/>

<moqui.service.message.SystemMessageType systemMessageTypeId="NewProductsFeed"
        description="New Products Feed"
        parentTypeId="LocalFeedFile"
        consumeServiceName="co.hotwax.orderledger.system.FeedServices.consume#OMSFeedSystemMessage"
        receivePath=""
        receiveResponseEnumId="MsgRrMove"
        receiveMovePath=""
        sendService="co.hotwax.oms.ProductServices.create#ProductAndVariants"
        sendPath="${contentRoot}/oms/NewProductsFeed"/>

<moqui.basic.EnumerationType enumTypeId="PRODUCT_SYS_JOB" description="Product Jobs"/>
<moqui.basic.Enumeration enumId="POL_NEWPRDTS_FD" enumCode="POL_NEWPRDTS_FD" description="Poll New Products Feed" enumTypeId="PRODUCT_SYS_JOB"/>
<moqui.service.job.ServiceJob jobName="poll_SystemMessageFileSftp_NewProductsFeed" jobTypeEnumId="POL_NEWPRDTS_FD" description="Poll New Products Feed"
        serviceName="co.hotwax.ofbiz.SystemMessageServices.poll#SystemMessageFileSftp" cronExpression="0 0 * * * ?" paused="Y">
    <parameters parameterName="systemMessageTypeId" parameterValue="NewProductsFeed"/>
</moqui.service.job.ServiceJob>
```

### [create#Product](../oms/createProduct.md)

### [create#ProductAndVariants](createProductAndVariants.md)

### [create#ProductVariant](createProductVariant.md)

### [prepare#ProductCreate](prepareProductCreate.md)
