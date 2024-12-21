# Shopify/OMS Product Sync Design

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

### generate#OMSProductUpdatesFeed
1. Fetch SystemMessage record
2. Fetch related SystemMessageRemote
3. Fetch shopId from SystemMessageRemote.remoteId
4. Get products list from the file location in SystemMessage.messageText.
5. Initiate a local file for the json feed.
6. Iterate through products list and for each shopifyProduct map call map#Product with forCreate=false, refer implementation details below.
7. Write the product map if returned in service output to the file.
8. Close the file once the iteration is complete.
9. If *sendSmrId* SystemMessageTypeParameter is defined, queue *SendOMSNewProductsFeed* SystemMessage.

### map#Product
Refer implementation details in [createProduct.md](https://github.com/saastechacademy/foundation/blob/main/project-ideas/product-master/createProduct.md).

### map#ProductVariant
Refer implementation details in [createProduct.md](https://github.com/saastechacademy/foundation/blob/main/project-ideas/product-master/createProduct.md).

## OMS API

### update#Product
This would be the base api the uses entity rest method to create product and related base data in the database.
1. Parameters
    * Input Parameters
        * productJson (type=Map) (expect JSON block below)
    * Output Parameters
        * productOutput

```json
{
  "productId": "<productId>",
  "internalName": "<sku>",
  "productTypeId": "<productTypeId>",
  "productName": "<productName>",
  "detailImageUrl": "<detailImageUrl>",
  "weight": "<weight>",
  "shippingWeight": "<weight>",
  "weightUomId": "<weightUomId>",
  "isVirtual": "<Y/N>",
  "isVariant": "<Y/N>",
  "primaryCategoryId": "<primaryCategoryId>",
  "GoodIdentification": [
    {
      "goodIdentificationTypeId": "<goodIdentificationTypeId>",
      "idValue": "<idValue>",
      "fromDate": "<fromDate>"
    }
  ],
  "ProductFeatureAppl": [
    {
      "productFeatureId": "<productFeatureId>",
      "productFeatureApplTypeId": "<productFeatureApplTypeId>",
      "sequenceNum": "<sequenceNum>",
      "fromDate": "<fromDate>"
    }
  ]
}
```

### update#ProductAndVariants (Application Layer)
This service will take in the product JSON in OMSProductUpdatesFeed and update and create any new variants by performing any surrounding crud operations as needed.
1. Parameters
   * Input Parameters
     * productJson (Map)
2. Remove productJson.variants into a new list productVariants.
3. Remove productJson.shopifyShopProduct as shopifyShopProduct.
4. If productJson.productId = null (handleChanged)
    * Call prepare#ProductCreate (refer in [createProduct.md](https://github.com/saastechacademy/foundation/blob/main/project-ideas/product-master/createProduct.md)) with productJson as input.
    * For the output product map call *create#Product* (refer in [createProduct.md](https://github.com/saastechacademy/foundation/blob/main/project-ideas/product-master/createProduct.md)) api service.
    * Set parentProductId = createProductOutput.productId.
    * Store ShopifyShopProduct with shopifyShopProduct and createProductOutput.productId as input.
    * Else
        * Call prepare#ProductUpdate with productJson as input.
        * For the output product map call *update#Product* api service.
        * Set parentProductId = updateProductOutput.productId.
        * Store ShopifyShopProduct with shopifyShopProduct and updateProductOutput.productId as input.
        * Iterate through updateProductOutput.deleteProductFeatureAppls list and call delete#org.apache.ofbiz.product.feature.ProductFeatureAppl.
5. Iterate through productVariants and call update#ProductVariant service.

### update#ProductVariant (Application Layer)
1. Parameters
   * Input Parameters
     * productVariantJson (Map)
     * parentProductId
2. Remove productVariantJson.shopifyShopProduct as shopifyShopProduct.
3. If productVariantJson.productId = null (handleChanged)
    * Call prepare#ProductCreate (refer in [createProduct.md](https://github.com/saastechacademy/foundation/blob/main/project-ideas/product-master/createProduct.md)) with productJson as input.
    * For the output product map call *create#Product* (refer in [createProduct.md](https://github.com/saastechacademy/foundation/blob/main/project-ideas/product-master/createProduct.md)) api service.
    * Call createProductAssoc for parentProductId and createProductOutput.productId returned in above step.
    * Store ShopifyShopProduct with shopifyShopProduct and createProductOutput.productId as input.
    * Else
        * Call prepare#ProductUpdate with productJson as input.
        * For the output product map call *update#Product* api service.
        * Validate and call create#ProductAssoc if it doesn't exist for parentProductId and updateProductOutput.productId.
        * Store ShopifyShopProduct with shopifyShopProduct and updateProductOutput.productId as input
        * Iterate through output deleteProductFeatureAppls list and call delete#org.apache.ofbiz.product.feature.ProductFeatureAppl.

### prepare#ProductUpdate (Application Layer)
1. Parameters
    * Input Parameters
        * productJson (Map)
    * Output Parameters
        * productJson (Map)
        * deleteProductFeatureAppls (List)
2. Remove productJson.features into a new list features.
3. If features is not null, initialize ProductFeatureAppl (name should be the same for entity rest api) list.
4. Iterate through features and perform following steps,
    * If feature.productFeatureTypeId doesn't exist, create new.
    * If feature.productFeatureId doesn't exist, create new.
    * Prepare a map with following values and add to ProductFeature list
        * productFeatureId
        * productFeatureApplTypeId
        * sequenceNum = selectableFeature.position
        * fromDate = nowTimestamp
5. Fetch current active ProductFeatureAppl list from DB as currentProductFeatureAppls.
6. Initialize deleteProductFeatureAppls list.
7. Iterate through currentProductFeatureAppls, for each entry toBeDeleted=true and iterate through ProductFeatureAppls,
   * For each entry initialize toBeDeleted=true and iterate through ProductFeatureAppls
   * If currentProductFeatureAppls.entry.productFeatureId matches ProductFeatureAppl.entry.productFeatureId (No need to add feature if it already exists)
     * Remove ProductFeatureAppl.entry
     * Set toBeDeleted=false
   * At the end of ProductFeatureAppls iteration, if toBeDeleted=true add currentProductFeatureAppls.entry to deleteProductFeatureAppls list.
8. If ProductFeatureAppl is not null, add it to productJson map.
9. Remove productJson.goodIdentifications into a new list goodIdentifications.
10. If goodIdentifications is not null, initialize GoodIdentification (name should be the same for entity rest api) list.
11. Iterate through goodIdentifications and perform following steps,
    * Check if it already exists in the database, if yes set idValue in db object and add to GoodIdentification list
    * If not add fromDate = nowTimestamp to this entry and add it to GoodIdentification list.