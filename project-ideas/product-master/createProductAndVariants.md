# co.hotwax.oms.ProductServices.create#ProductAndVariants (Application Layer - OMS)
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