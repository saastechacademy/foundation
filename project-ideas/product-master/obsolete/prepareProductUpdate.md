# co.hotwax.oms.product.ProductServices.prepare#ProductUpdate (Application Layer - OMS)
1. Parameters
    * Input Parameters
        * productJson (Map)
    * Output Parameters
        * productJson (Map)
        * deleteProductFeatureAppls (List)
        * deleteProductKeywords (List)
2. Remove productJson.features into a new list features.
3. If features is not null, initialize featureAppls list.
4. Iterate through features as feature and perform following steps,
    * Check if ProductFeatureType exists where ProductFeatureType.description = feature.productFeatureTypeDesc
        * If yes set productFeatureTypeId = ProductFeatureType.productFeatureTypeId
        * If no call create#org.apache.ofbiz.product.feature.ProductFeatureType with [description:feature.productFeatureTypeDesc]
            * Set productFeatureTypeId = createProductFeatureTypeOutput.productFeatureTypeId
    * Check if ProductFeature exists where ProductFeature.productFeatureTypeId = productFeatureTypeId and ProductFeature.desc = feature.featureDesc
        * If yes set productFeatureId = ProductFeature.productFeatureId
        * If no call create#org.apache.ofbiz.product.feature.ProductFeature with [productFeatureTypeId:productFeatureDesc, description:feature.featureDesc
            * Set productFeatureId = createProductFeatureOutput.productFeatureId
    * Add [productFeatureId:productFeatureId, productFeatureApplTypeId:feature.productFeatureApplTypeId, sequenceNum:feature.sequenceNum] to featureAppls list
5. Fetch current active ProductFeatureAppl list from DB as currentProductFeatureAppls.
6. Initialize deleteProductFeatureAppls list.
7. Iterate through currentProductFeatureAppls
    * For each entry initialize toBeDeleted=true and iterate through featureAppls.
    * If currentProductFeatureAppls.entry.productFeatureId matches featureAppls.entry.productFeatureId (No need to add feature if it already exists)
        * Remove featureAppls.entry
        * Set toBeDeleted=false
    * At the end of featureAppls iteration, if toBeDeleted=true add currentProductFeatureAppls.entry to deleteProductFeatureAppls list.
8. If featureAppls is not null, add it to productJson map.
9. Fetch current ProductKeyword list form DB as currentProductKeywords
10. Initialize deleteProductKeywords list
11. Iterate through currentProductKeywords
    * For each entry initialize toBeDeleted=true and iterate through productJson.keywords
    * If currentProductKeywords.entry.keyword matches productJson.keywords.entry.keyword (No need to add keyword if it already exists)
      * Remove productJson.keywords.entry
      * Set toBeDeleted=false
    * At the end of productJson.keywords iteration, if toBeDeleted=true add currentProductKeywords.entry to deleteProductKeywords list