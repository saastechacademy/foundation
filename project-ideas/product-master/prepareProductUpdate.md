### prepare#ProductUpdate (Application Layer)
1. Parameters
    * Input Parameters
        * productJson (Map)
    * Output Parameters
        * productJson (Map)
        * deleteProductFeatureAppls (List)
2. Remove productJson.price into a new map priceMap
3. If priceMap is not null, initialize ProductPrice list.
    * Check if it already exists in the database, if yes set price in db object and add to ProductPrice list
4. Remove productJson.features into a new list features.
5. If features is not null, initialize ProductFeatureAppl (name should be the same for entity rest api) list.
6. Iterate through features and perform following steps,
    * If feature.productFeatureTypeId doesn't exist, create new.
    * If feature.productFeatureId doesn't exist, create new with feature.description and productFeatureTypeId returned in above step.
    * Prepare a map with following values and add to ProductFeature list
        * productFeatureId
        * productFeatureApplTypeId
        * sequenceNum = selectableFeature.position
        * fromDate = nowTimestamp
7. Fetch current active ProductFeatureAppl list from DB as currentProductFeatureAppls.
8. Initialize deleteProductFeatureAppls list.
9. Iterate through currentProductFeatureAppls, for each entry toBeDeleted=true and iterate through ProductFeatureAppls,
    * For each entry initialize toBeDeleted=true and iterate through ProductFeatureAppls
    * If currentProductFeatureAppls.entry.productFeatureId matches ProductFeatureAppl.entry.productFeatureId (No need to add feature if it already exists)
        * Remove ProductFeatureAppl.entry
        * Set toBeDeleted=false
    * At the end of ProductFeatureAppls iteration, if toBeDeleted=true add currentProductFeatureAppls.entry to deleteProductFeatureAppls list.
10. If ProductFeatureAppl is not null, add it to productJson map.
11. Remove productJson.goodIdentifications into a new list goodIdentifications.
12. If goodIdentifications is not null, initialize GoodIdentification (name should be the same for entity rest api) list.
13. Iterate through goodIdentifications and perform following steps,
    * Check if it already exists in the database, if yes set idValue in db object and add to GoodIdentification list
    * If not add fromDate = nowTimestamp to this entry and add it to GoodIdentification list.