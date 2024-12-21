# Shopify/OMS Product Sync Design

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

### generate#OMSNewProductsFeed
1. Fetch SystemMessage record
2. Fetch related SystemMessageRemote
3. Fetch shopId from SystemMessageRemote.remoteId
4. Get products list from the file location in SystemMessage.messageText.
5. Initiate a local file for the json feed.
6. Iterate through products list and for each shopifyProduct map call map#Product, refer implementation details below.
7. Write the product map if returned in service output to the file.
8. Close the file once the iteration is complete.
9. If *sendSmrId* SystemMessageTypeParameter is defined, queue *SendOMSNewProductsFeed* SystemMessage.

### map#Product
1. Service Parameters
   * Input
     * shopifyProduct (Map)
     * shopId
     * forCreate (Boolean)
   * Output
     * product
2. Initialize product map
3. Check if product already exists, set product.productId = get Product.productId from Product where Product.internalName = "V" + shopifyProduct.handle.
4. If product.productId exists and forCreate=true, we will only create ShopifyShopProduct record and not setup complete product, but we will also need to go through variants the same way.
   * Set product.shopifyShopProduct = [shopId:shopId, shopifyProductId:shopifProduct.id]
   * Set product.variants = for each shopifyProduct.variants call map#ProductVariant with forCreate=forCreate (service input) and add the result to this list
   * return
5. Prepare product map
   * product.internalName = "V" + shopifyProduct.handle
   * product.productType
     * default to FINISHED_GOOD
     * if shopifyProduct.variants.inventoryItem.requiresShipping=false, set as DIGITAL_GOOD
     * if shopifyProduct.hasVariantsThatRequiresComponents=true, set as MARKETING_PKG_PICK
   * product.productName = shopifyProduct.title (currently we replace <|> with "" and store upto 100 characters only, we could consider changing datatype in new implementation)
   * product.detailImageUrl = shopifyProduct.featuredMedia.mediaContentType.preview.image.url
   * product.primaryCategoryId = browse root category of the ProductStore associated with shopId (write helper method/service as needed)
   * product.isVirtual = Y
   * product.isVariant = N
   * product.features = iterate through product.options and create a list of maps with following key/value(s)
     * productFeatureId = set if exists
     * productFeatureApplTypeId = "SELECTABLE_FEATURE"
     * feature = shopifyProduct.options.optionValues.name
     * featureType = shopifyProduct.options.name
     * sequenceNum = shopifyProduct.options.position
   * product.variants = for each shopifyProduct.variants call map#ProductVariant with forCreate=true and add the result to this list
   * product.shopifyShopProduct = [shopId:shopId, shopifyProductId:shopifyProduct.id]

> NOTES
> - Current implementation should support Variant Fixed Bundles, in future add support for Product Fixed Bundles (shopifyProduct.bundleComponents)

> TODO
> - Modeling for shopifyProduct.tags, currently it's split and saved as ProductKeywords but it can be saved as freetext in a simpler way.

### map#ProductVariant
1. Service Parameters
   * Input
     * shopifyProductVariant
     * shopId
     * forCreate (Boolean)
   * Output
     * productVariant
2. Get productIdentifierEnumId from ProductStore associated to shopId, based on returned value set productIdentifier = shopifyProductVariant.id OR shopifyProductVariant.sku OR shopifyProductVariant.barcode
3. Initialize productVariant map
4. Check if product already exists, set productVariant.productId = get Product.productId from Product where Product.internalName = producIdentifier.
5. If productVariant.productId exists and forCreate=true, we will only create ShopifyShopProduct record and not setup complete product
    * Set productVariant.shopifyShopProduct = [shopId:shopId, shopifyProductId:shopifyProduct.id, shopifyInventoryItemId:shopifyProductVariant.inventoryItem.id]
    * return
6. Prepare productVariant map
   * productVariant.internalName = productIdentifier
   * productVariant.productTypeId
     * default to FINISHED_GOOD
     * if shopifyProductVariant.inventoryItem.requireShipping=false, set as DIGITAL_GOOD
     * if shopifyProductVariant.requiresComponents=true, set as MARKETING_PKG_PICK 
   * productVariant.productName = shopifyProductVariant.title
   * productVariant.detailImageUrl = shopifyProductVariant.image.url
   * productVariant.primaryCategoryId = browse root category of the ProductStore associated with shopId (write helper method/service as needed)
   * productVariant.weight = shopifyProductVariant.inventoryItem.measurement.value
   * productVariant.shippingWeight = shopifyProductVariant.inventoryItem.measurement.value
   * productVariant.weightUomId = uomId where shopifyProductVariant.inventoryItem.measurement.unit = Uom.abbreviation
   * productVariant.isVirtual = N
   * productVariant.isVariant = Y
   * productVariant.sequenceNum = shopifyProductVariant.position
   * productVariant.features = iterate through shopifyProductVariant.selectedOptions and create a list of maps with following key/value(s)
     * productFeatureId = set if exists
     * productFeatureApplTypeId = "STANDARD_FEATURE"
     * feature = shopifyProductVariant.selectedOptions.name
     * value = shopifyProductVariant.selectedOptions.value
     * sequenceNum = shopifyProductVariant.position
   * productVariant.goodIdentifications = add following key value pairs to the list
     * [goodIdentificationTypeId: "SHOPIFY_PROD_SKU", idValue=productVariant.sku]
     * [goodIdentificationTypeId: "UPCA", idValue=productVariant.barcode]
   * productVariant.shopifyShopProduct = [shopId:shopId, shopifyProductId:shopifyProductVariant.id, shopifyInventoryItemId:shopifyProductVariant.inventoryItem.id]

## OMS API

### create#Product
This would be the base api the uses entity rest method to create product and related base data in the database.
1. Parameters
   * Input Parameters
     * productJson (type=Map) (expect JSON block below)
   * Output Parameters
     * productOutput

```json
{
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

### create#ProductAndVariants (Application Layer)
This service will take in the product JSON in OMSNewProductsFeed and set up a complete product and its variants by performing any surrounding crud operations as needed.
1. Parameters
   * Input Parameters
     * productJson (Map)
2. Remove productJson.variants into a new list productVariants.
3. If productJson.productId != null
   * Only store ShopifyShopProduct record for productJson.shopifyShopProduct
   * Set parentProductId = productJson
   * Else
     * Remove productJson.shopifyShopProduct as shopifyShopProduct.
     * Call prepare#ProductCreate with productJson as input.
     * For the output product map call *create#Product* api service.
     * Set parentProductId = createProductOutput.productId.
     * Store ShopifyShopProduct with shopifyShopProduct and createProductOutput.productId as input.
4. Iterate through productVariants and call *create#ProductVriant* service

### create#ProductVariant (Application Layer)
1. Parameters
   * Input Parameters
     * productVariantJson (Map)
     * parentProductId
2. If productVariantJson.productId != null
   * Only store ShopifyShopProduct record for productVariantJson.shopifyShopProduct
   * Call create#ProductAssoc for parentProductId and productVariantJson.productId.
   * Else
     * Remove productVariantJson.shopifyShopProduct as shopifyShopProduct.
     * Call prepare#ProductCreate for each variant map.
     * For the output product map call *create#Product* api service.
     * Call createProductAssoc for parentProductId and createProductOutput.productId.
     * Store ShopifyShopProduct with shopifyShopProduct and createProductOutput.productId as input.

### prepare#ProductCreate (Application Layer)
1. Parameters
    * Input Parameters
      * productJson (Map)
    * Output Parameters
      * productJson (Map)
2. Remove productJson.features into a new list features.
3. Remove productJson.goodIdentifications into a new list goodIdentifications.
4. If features is not null, initialize ProductFeatureAppl (name should be the same for entity rest api) list.
5. Iterate through features and perform following steps,
   * If feature.productFeatureTypeId doesn't exist, create new.
   * If feature.productFeatureId doesn't exist, create new.
   * Prepare a map with following values and add to ProductFeature list
     * productFeatureId
     * productFeatureApplTypeId
     * sequenceNum = selectableFeature.position
     * fromDate = nowTimestamp
6. If ProductFeatureAppl is not null, add it to productJson map.
7. If goodIdentifications is not null, initialize GoodIdentification (name should be the same for entity rest api) list.
8. Iterate through goodIdentifications and perform following steps,
   * add fromDate = nowTimestamp to each entry and add it to GoodIdentification list.