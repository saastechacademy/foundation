# co.hotwax.oms.ProductServices.prepare#ProductCreate (Application Layer - OMS)
1. Parameters
    * Input Parameters
        * productJson (Map)
    * Output Parameters
        * productJson (Map)
2. Remove productJson.features into a new list features.
3. If features is not null, initialize featureAppls list.
4. Iterate through features and perform following steps,
    * If feature.productFeatureTypeId doesn't exist, create new.
    * If feature.productFeatureId doesn't exist, create new with feature.description and productFeatureTypeId returned in above step.
    * Prepare a map with following values and add to featureAppls list
        * productFeatureId
        * productFeatureApplTypeId
        * sequenceNum = selectableFeature.position
        * fromDate = nowTimestamp
5. If featureAppls is not null, add it to productJson map.