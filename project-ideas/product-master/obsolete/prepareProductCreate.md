# co.hotwax.oms.product.ProductServices.prepare#ProductCreate (Application Layer - OMS)
1. Parameters
    * Input Parameters
        * productJson (Map)
    * Output Parameters
        * productJson (Map)
2. Remove productJson.features into a new list features.
3. If features is not null, initialize featureAppls list.
4. Iterate through features as feature as feature and perform following steps,
    * Check if ProductFeatureType exists where ProductFeatureType.description = feature.productFeatureTypeDesc
      * If yes set productFeatureTypeId = ProductFeatureType.productFeatureTypeId
      * If no call create#org.apache.ofbiz.product.feature.ProductFeatureType with [description:feature.productFeatureTypeDesc]
        * Set productFeatureTypeId = createProductFeatureTypeOutput.productFeatureTypeId
    * Check if ProductFeature exists where ProductFeature.productFeatureTypeId = productFeatureTypeId and ProductFeature.desc = feature.featureDesc
      * If yes set productFeatureId = ProductFeature.productFeatureId
      * If no call create#org.apache.ofbiz.product.feature.ProductFeature with [productFeatureTypeId:productFeatureDesc, description:feature.featureDesc
        * Set productFeatureId = createProductFeatureOutput.productFeatureId
    * Add [productFeatureId:productFeatureId, productFeatureApplTypeId:feature.productFeatureApplTypeId, sequenceNum:feature.sequenceNum] to featureAppls list
5. If featureAppls is not null, add it to productJson map.