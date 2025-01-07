# Shopify/OMS Product Updates Sync Design

Newly created products and product updates in Shopify needs to be synced timely to OMS. This design document is specific to syncing Shopify product (virtual) updates.  
There is a possibility of new variants being added to an existing virtual product on Shopify, we will need to consider and handle this scenario in this design.  
Following would be the flow to sync products,
1. **mantle-shopify-connector** would produce a periodic json feed of product updates.
2. **shopify-oms-bridge** would consume this feed and transform it to produce OMS product json feed.
3. **oms** would consume the transformed product json feed and establish products in OMS database via product API.

## Shopify Connector
Shopify connector would produce a periodic product updates feed since last run time with following fields,
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

Periodically receive and consume ShopifyProductUpdatesFeed and transform to generated OMSProductUpdatesFeed.
Following are the implementation details,
1. Define and configure *ShopifyProductUpdatesFeed* SystemMessageType to import Shopify new products feed, define *consumeSmrId* SystemMessageType parameter to be used in the next system message produced in consume service. Refer *ShopifyOrderCancelUpdatesFeed* SystemMessageType.
2. Convert *consume#ShopifyOrderCancelUpdatesFeed* service to a generic service *consume#ShopifyFeed* to be used as consume service for this flow as well.
3. Define and configure *GenerateOMSProductUpdatesFeed* SystemMessageType, refer *GenerateOMSOrderCancelUpdatesFeed* SystemMessageType. Configure *sendSmrId* SystemMessageTypeParameter to send the feed to SFTP.
4. Implement sendService *generate#OMSProductUpdatesFeed*, refer implementation details below.
5. Define and configure *SendOMSProductUpdatesFeed* SystemMessageType to send the feed to SFTP.

### [generate#OMSProductUpdatesFeed](generateOMSProductUpdatesFeed.md)

### map#Product
Refer implementation details in [createProduct.md](https://github.com/saastechacademy/foundation/blob/main/project-ideas/product-master/createProduct.md).

### map#ProductVariant
Refer implementation details in [createProduct.md](https://github.com/saastechacademy/foundation/blob/main/project-ideas/product-master/createProduct.md).

## OMS API

### [update#Product](../oms/updateProduct.md)

### [update#ProductAndVariants](updateProductAndVariants.md)

### [update#ProductVariant](updateProductVariant.md)

### [prepare#ProductUpdate](prepareProductUpdate.md)
