# co.hotwax.oms.ProductServices.create#ProductVariant (Application Layer - OMS)
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