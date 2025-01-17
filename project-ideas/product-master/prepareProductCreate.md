# co.hotwax.oms.ProductServices.prepare#ProductCreate (Application Layer - OMS)
1. Parameters
    * Input Parameters
        * productJson (Map)
    * Output Parameters
        * productJson (Map)
2. Remove productJson.features into a new list features.
3. Remove productJson.goodIdentifications into a new list goodIdentifications.
4. Remove product.price into a new map priceMap.
5. If priceMap is not null, initialize ProductPrice list.
    * Add fromDate = nowTimestamp in priceMap and add it to ProductPrice list and add it to productJson map.
6. If features is not null, initialize ProductFeatureAppl (name should be the same for entity rest api) list.
7. Iterate through features and perform following steps,
    * If feature.productFeatureTypeId doesn't exist, create new.
    * If feature.productFeatureId doesn't exist, create new with feature.description and productFeatureTypeId returned in above step.
    * Prepare a map with following values and add to ProductFeature list
        * productFeatureId
        * productFeatureApplTypeId
        * sequenceNum = selectableFeature.position
        * fromDate = nowTimestamp
8. If ProductFeatureAppl is not null, add it to productJson map.
9. If goodIdentifications is not null, initialize GoodIdentification (name should be the same for entity rest api) list.
10. Iterate through goodIdentifications and perform following steps,
    * add fromDate = nowTimestamp to each entry and add it to GoodIdentification list.