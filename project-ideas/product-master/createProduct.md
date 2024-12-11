# Shopify/OMS Product Sync Design

Newly created products and product updates in Shopify needs to be synced timely to OMS. This design document is specific to syncing newly creaated Shopify products.  
Shopify has virtual and variant products. An ideal situation would have to to sync virtual and variant products in separate batch processes, but since Shopify GraphQL API doesn't let variants to be filtered by created date, we will have to sync these together in a single batch process.  
Following would be the flow to sync products,
1. **mantle-shopify-connector** would produce a periodic json feed of newly created products.
2. **shopify-oms-bridge** would consume this feed and transform it to produce OMS product json feed.
3. **oms** would consume the transformed product json feed and establish products in OMS database via product API.

## Shopify Connector
Shopify connector would produce a periodic created products feed since last run time with following fields,
* id
* handle
* title
* productType
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
  * selectedOptions
    * name
    * value
  * inventoryItem
    * id
    * measurement
      * weight
        * unit
        * value

## Shopify OMS Bridge

### map#Product
1. Service Parameters
   * Input
     * shopifyProduct (Map)
     * shopId
     * forCreate (Boolean)
   * Output
     * product
2. Check if product already exists in ShopifyShopAndProduct view on following conditions (implement a helper service get#OMSProductId for this)
   * shopId
   * internalName = "V" + shopifyProduct.handle OR shopifyProductId = shopifyProduct.id
3. If product exists and forCreate=true, return
4. Prepare product map
   * product.productId = omsProductId
   * product.internalName = "V" + shopifyProduct.handle
   * product.productName = shopifyProduct.title (currently we replace <|> with "" and store upto 100 characters only, we could consider changing datatype in new implementation)
   * product.detailImageUrl = shopifyProduct.featuredMedia.mediaContentType.preview.image.url
   * product.primaryCategoryId = browse root category of the ProductStore associated with shopId (write helper method/service as needed)
   * product.selectableFeatures = iterate through product.options and create a list of maps with following key/value(s)
     * productFeatureId = set if exists
     * feature = shopifyProduct.options.optionValues.name
     * featureType = shopifyProduct.options.name
     * sequenceNum = shopifyProduct.options.position
   * product.keywords = shopifyProduct.tags
   * product.variants = for each shopifyProduct.variants call map#ProductVariant with forCreate=true and add the result to this list

### map#ProductVariant
1. Service Parameters
   * Input
     * shopifyProductVariant
     * shopId
     * forCreate (Boolean)
   * Output
     * productVariant
2. Get productIdentifierEnumId from ProductStore associated to shopId, based on returned value set productIdentifier = shopifyProductVariant.id OR shopifyProductVariant.sku OR shopifyProductVariant.barcode
3. Check if product already exists in ShopifyShopAndProduct view on following conditions (implement a helper service get#OMSProductId for this)
    * shopId
    * internalName = productIdentifier or shopifyProductId = shopifyProductVariant.id
4. If product exists and forCreate=true, return
5. Prepare productVariant map
   * productVariant.productId = omsProductId
   * productVariant.internalName = productIdentifier
   * productVariant.productName = shopifyProductVariant.title
   * productVariant.detailImageUrl = shopifyProductVariant.image.url
   * productVariant.primaryCategoryId = browse root category of the ProductStore associated with shopId (write helper method/service as needed)
   * productVariant.weight = shopifyProductVariant.inventoryItem.measurement.value
   * productVariant.weightUomId = uomId where shopifyProductVariant.inventoryItem.measurement.unit = Uom.abbreviation
   * productVariant.standardFeatures = iterate through shopifyProductVariant.selectedOptions and create a list of maps with following key/value(s)
     * productFeatureId = set if exists
     * feature = shopifyProductVariant.selectedOptions.name
     * value = shopifyProductVariant.selectedOptions.value
     * sequenceNum = shopifyProductVariant.position