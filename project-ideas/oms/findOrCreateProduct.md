### co.hotwax.oms.ProductServices.findOrCreate#Product (OMS)
1. Parameters
   * Input
     * internalName
   * Output
     * productId
2. Set productId = Check if product exists where Product.internalName = internalName
3. If productId = null, call create#org.apache.ofbiz.product.product.Product.
4. Set productId = createProductOutput.productId