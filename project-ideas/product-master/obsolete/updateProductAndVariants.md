# co.hotwax.oms.product.ProductServices.update#ProductAndVariants (Application Layer - OMS)
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
        * Iterate through prepareProductUpdateOutput.deleteProductFeatureAppls list and call delete#org.apache.ofbiz.product.feature.ProductFeatureAppl.
        * Iterate through prepareProductUpdateOutput.deleteProductKeywords list and call delete#org.apache.ofbiz.product.product.ProductKeyword.
5. Iterate through productVariants and call update#ProductVariant service.