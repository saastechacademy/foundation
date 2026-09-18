# co.hotwax.oms.product.ProductServices.update#ProductVariant (Application Layer - OMS)
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