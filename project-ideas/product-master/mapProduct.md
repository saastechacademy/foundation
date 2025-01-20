# co.hotwax.sob.product.ProductMappingServices.map#Product (shopify-oms-bridge)
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
    * product.productTypeId
        * default to FINISHED_GOOD
        * if shopifyProduct.variants.inventoryItem.requiresShipping=false, set as DIGITAL_GOOD
        * if shopifyProduct.hasVariantsThatRequiresComponents=true, set as MARKETING_PKG_PICK
    * product.productName = shopifyProduct.title (currently we replace <|> with "" and store upto 100 characters only, we could consider changing datatype in new implementation)
    * product.detailImageUrl = shopifyProduct.featuredMedia.mediaContentType.preview.image.url
    * product.primaryCategoryId = browse root category of the ProductStore associated with shopId (write helper method/service as needed)
    * product.isVirtual = Y
    * product.isVariant = N
    * product.features = iterate through shopifyProduct.options and create a list of maps with following key/value(s)
        * productFeatureId = set if exists
        * productFeatureApplTypeId = "SELECTABLE_FEATURE"
        * productFeatureTypeId = shopifyProduct.options.name
        * description = shopifyProduct.options.optionValues.name
        * sequenceNum = shopifyProduct.options.position
    * product.keywords = iterate through shopifyProduct.tags and add [keywordTypeId:"KWT_TAG", statusId:"KW_APPROVED", keyword:shopifyProduct.tags.entry]
    * product.variants = for each shopifyProduct.variants call map#ProductVariant with forCreate=true and add the result to this list
    * product.shopifyShopProduct = [shopId:shopId, shopifyProductId:shopifyProduct.id]

> NOTES
> - Current implementation should support Variant Fixed Bundles, in future add support for Product Fixed Bundles (shopifyProduct.bundleComponents)

> TODO
> - Modeling for shopifyProduct.tags, currently it's split and saved as ProductKeywords but it can be saved as freetext in a simpler way.