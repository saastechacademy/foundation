### Server Side API calls from Facility Application

|Function Name in PWA|Use Case|Server Side API Endpoint|Parameters|Data Elements Received|
|---|---|---|---|---|
|fetchFacilities|Fetch information for all the facilities.|performFind|viewIndex, viewSize, facilityTypeId, facilityTypeId_op, parentFacilityTypeId, parentFacilityTypeId_op, facilityId_value, facilityId_op, facilityId\_ic, facilityId\_grp, facilityName\_value, facilityName\_op, facilityName\_ic, facilityName\_grp, grp\_op, facilityGroupId, facilityGroupId\_op, filterByDate, entityName, noConditionFind, distinct, fromDateName, thruDateName, fieldList|count, docs|
|fetchFacilityGroupInformation|Fetch the facility group information.|performFind|facilityId, facilityId_op, fieldList, entityName, distinct, filterByDate, viewSize|count, docs|
|fetchInactiveFacilityGroupAssociations|Fetch the inactive facility group associations.|performFind|facilityGroupId, thruDate, thruDate_op, fieldList, entityName, viewSize|count, docs|
|fetchFacilitiesOrderCount|Fetch the order count for the facilities.|performFind|facilityId, facilityId_op, entryDate, entityName, viewSize, fieldList|count, docs|
|getFacilityParties|Get the parties associated with the facility.|performFind|facilityId, partyId_op, roleTypeId, roleTypeId_op, entityName, filterByDate, orderBy, fieldList, viewSize|count, docs|
|getPartyRoleAndPartyDetails|Get the party role and party details.|performFind|partyId, roleTypeId, entityName, fieldList, viewSize|count, docs|
|fetchFacilityOrderCounts|Fetch information for the order counts.|performFind|facilityId, entityName, viewSize, fieldList, orderBy|count, docs|
|fetchFacilityGroup|Fetch information for the facility groups.|performFind|facilityGroupId, entityName, noConditionFind, fieldList|count, docs|
|fetchFacilityContactDetails|Fetch information for the facility contact details.|performFind|contactMechPurposeTypeId, contactMechTypeId, facilityId, entityName, orderBy, filterByDate, fieldList, viewSize|count, docs|
|getFacilityProductStores|Get information for the facility product stores.|performFind|facilityId, viewSize, entityName, filterByDate, fieldList|count, docs|
|fetchFacilityLocations|Fetch information of the facility locations.|performFind|facilityId, entityName, fieldList, viewSize|count, docs|
|fetchFacilityMappings|Fetch facility mappings.|performFind|facilityId, facilityIdenTypeId, facilityIdenTypeId_op, entityName, filterByDate, fieldList, viewSize|count, docs|
|fetchShopifyFacilityMappings|Fetch shopify facility mappings.|performFind|facilityId, entityName, fieldList, viewSize|count, docs|
|fetchJobData|Fetch job data.|performFind|statusId, systemJobEnumId, systemJobEnumId_op, orderBy, entityName, fieldList, viewSize|count, docs|
|fetchFacilityCalendar|Fetch facility calendar.|performFind|facilityId, entityName, filterByDate, viewSize|count, docs|
|fetchFacilityGroups|Fetch facility groups.|performFind|entityName, noConditionFind, orderBy, fieldList, viewIndex, viewSize
|fetchOrderCountsByFacility|Fetch order counts by facility.|solr-query|q, fq, rows, sort, defType, facet|facets|
|createFacilityPostalAddress|Create postal address for facility.|createFacilityPostalAddress|contactMechPurposeTypeId, contactMechTypeId, facilityId, address1, address2, city, postalCode, stateProvinceGeoId, countryGeoId|status, message|
|addPartyToFacility|Add party to the facility.|addPartyToFacility|facilityId, partyId, roleTypeId|status, message|
|removePartyFromFacility|Remove party from the facility.|removePartyFromFacility|facilityId, partyId, roleTypeId|status, message|
|updateProductStoreFacility|Update product store facility.|updateProductStoreFacility|facilityId, productStoreId, thruDate, fromDate|status, message|
|addFacilityToGroup|Add facility to the group.|addFacilityToGroup|facilityId, facilityGroupId|status, message|
|removeFacilityFromGroup|Remove facility from group.|removeFacilityFromGroup|facilityId, facilityGroupId, thruDate|status, message|
|associateCalendarToFacility|Associate calendar to the facility.|createFacilityCalendar|facilityId, calendarId, fromDate|status, message|
|createFacilityGroup|Create facility group.|createFacilityGroup|facilityGroupId, facilityGroupTypeId, facilityGroupName, description, parentFacilityGroupId|status, message|
|createFacilityLocation|Create facility location.|createFacilityLocation|facilityId, locationSeqId, locationTypeEnumId, areaId, aisleId, sectionId, levelId, positionId|status, message|
|createProductStoreFacility|Create product store facility.|createProductStoreFacility|facilityId, productStoreId, fromDate|status, message|
|updateFacility|Update facility.|updateFacility|facilityId, facilityTypeId, facilityName, description|status, message|
|updateFacilityLocation|Update facility location.|updateFacilityLocation|facilityId, locationSeqId, locationTypeEnumId, areaId, aisleId, sectionId, levelId, positionId|status, message|
|deleteFacilityLocation|Delete facility location.|deleteFacilityLocation|facilityId, locationSeqId|status, message|
|updateFacilityToGroup|Update facility to group.|updateFacilityToGroup|facilityId, facilityGroupId, fromDate, thruDate|status, message|
|createFacility|Create facility.|createFacility|facilityId, facilityName, facilityTypeId, description, parentFacilityId, defaultDaysToShip, minimumStock, reorderQuantity, daysToShip, primaryFacilityGroupId|status, message|
|createVirtualFacility|Create virtual facility.|createFacility|facilityId, facilityName, facilityTypeId, description, parentFacilityId, defaultDaysToShip, minimumStock, reorderQuantity, daysToShip, primaryFacilityGroupId|status, message|
|updateFacilityPostalAddress|Update facility postal address.|updateFacilityPostalAddress|contactMechId, contactMechPurposeTypeId, address1, address2, city, postalCode, stateProvinceGeoId, countryGeoId|status, message|
|createFacilityIdentification|Create facility identification.|createFacilityIdentification|facilityId, facilityIdenTypeId, idValue|status, message|
|updateFacilityIdentification|Update facility identification.|updateFacilityIdentification|facilityId, facilityIdenTypeId, idValue, fromDate|status, message|
|createShopifyShopLocation|Create shopify location.|createShopifyShopLocation|facilityId, shopifyShopId, shopifyLocationId|status, message|
|updateShopifyShopLocation|Update shopify shop location.|updateShopifyShopLocation|facilityId, shopifyShopId, shopifyLocationId, fromDate|status, message|
|deleteShopifyShopLocation|Delete shopify shop location.|deleteShopifyShopLocation|facilityId, shopifyShopId, shopifyLocationId, fromDate|status, message|
|createEnumeration|Create enumeration.|createEnumeration|enumId, enumTypeId, description|status, message|
|createFacilityCalendar|Create facility calendar.|calendarDataSetup|facilityId, calendarId, fromDate, mondayStartTime, mondayEndTime, mondayCapacity, tuesdayStartTime, tuesdayEndTime, tuesdayCapacity, wednesdayStartTime, wednesdayEndTime, wednesdayCapacity, thursdayStartTime, thursdayEndTime, thursdayCapacity, fridayStartTime, fridayEndTime, fridayCapacity, saturdayStartTime, saturdayEndTime, saturdayCapacity, sundayStartTime, sundayEndTime, sundayCapacity|status, message|
|removeFacilityCalendar|Remove facility calendar.|expireFacilityCalendar|facilityId, calendarId, fromDate|status, message|
