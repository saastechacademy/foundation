# Summary of `performFind` API Analysis

## Overview

After a comprehensive analysis of the codebase, we have identified all use cases of the `performFind` API utilized in the Order Fulfillment Application. This API is central to fetching and managing data across various entities and is tightly integrated with numerous components and workflows in the Progressive Web Application (PWA).

The analysis revealed that the `performFind` API is used extensively across services, state management actions, and UI components to query data for entities such as orders, shipments, carriers, facilities, picklists, and customer details. Each call is tailored with specific query parameters to retrieve the precise data required for each feature.

## Key Findings

- **Wide Usage:** The `performFind` API supports critical functionalities like:
  - Fetching order headers, items, and attributes.
  - Retrieving shipment and route segment details.
  - Managing carrier and facility-related information.
  - Handling picklists, customer contact mechanisms, and rejection reasons.
- **Dynamic Parameters:** The API queries vary in complexity, utilizing filters like `entityName`, `inputFields`, `fieldList`, and pagination parameters (`viewSize`, `distinct`).
- **Component Integration:** The results from these API calls are consumed in components such as `OrderDetail.vue`, `PicklistManagement.vue`, and `BillingDetails.vue` to provide real-time data for users.
- **Fields Requested:** Each `performFind` call is tailored with a specific set of fields required for a given feature, optimizing data retrieval for performance and relevance.

## Recommendation for the Next OMS Release

To ensure seamless migration and continuity of features, it is essential to provide equivalent or enhanced functionality in the next release of OMS:
- The new API should support querying similar entities with flexible filters and pagination.
- Results should match the structure expected by the PWA components to minimize refactoring efforts.
- Performance and scalability considerations should be incorporated, especially for APIs returning large datasets (e.g., picklists, shipment details).


---

## Detailed Use Cases

| **Service**             | **Function**                    | **Entity**                     | **Parameters**                          | **Fields Requested**                                                | **Usage**                                                                             | **Components**                               |
|--------------------------|----------------------------------|---------------------------------|------------------------------------------|----------------------------------------------------------------------|-------------------------------------------------------------------------------------|-----------------------------------------------|
| CarrierService.ts        | fetchCarriers                  | Carrier                         | carrierId, statusId, partyId             | All Fields                                                         | Used in Carrier Management views to list and filter available carriers.             | Carriers.vue, CarrierDetail.vue               |
| CarrierService.ts        | fetchCarrierShipmentMethods    | CarrierShipmentMethod           | carrierPartyId, shipmentMethodTypeId     | All Fields                                                         | Used in Carrier Detail view to show supported shipment methods.                    | CarrierShipmentMethods.vue                    |
| OrderService.ts          | fetchOrderHeader               | OrderHeader                     | orderId, orderTypeId, statusId           | orderId, orderDate, statusId                                       | Used in the Orders Overview to display high-level order summaries.                 | OpenOrders.vue, Completed.vue                 |
| OrderService.ts          | fetchOrderItems                | OrderItem                       | orderId, productId                       | orderId, orderItemSeqId, quantityOrdered                           | Used in Order Detail views to show the items in a specific order.                  | OrderDetail.vue                               |
| UserService.ts           | getFacilityDetails             | Facility                        | facilityId, facilityTypeId               | facilityId, facilityName, facilityTypeId                           | Used in Facility Management views to display metadata about facilities.            | Settings.vue                                  |
| UtilService.ts           | fetchPicklistInformation       | Picklist                        | picklistId, statusId                     | picklistId, statusId, createdByUser                                | Used in Order Fulfillment workflows to display and manage picklists.               | InProgress.vue                                |
| UtilService.ts           | fetchFacilityTypeInformation   | FacilityType                    | facilityTypeId                           | facilityTypeId, description                                         | Used in Facility Settings to categorize facilities.                                 | Settings.vue                                  |
| UtilService.ts           | fetchRejectReasons             | RejectReason                    | rejectReasonId, rejectTypeId             | rejectReasonId, description                                         | Used in Rejection Management to show and manage rejection reasons.                 | Rejections.vue, RejectionReasons.vue          |
| OrderLookup/actions.ts   | fetchOrderShipmentAndRouteSegment | OrderShipmentAndRouteSegment   | fieldList, viewSize, entityName          | orderId, shipGroupSeqId, shipmentId, trackingIdNumber              | Retrieves shipment and route segment details for orders.                           | OrderFulfillment.vue                          |
| OrderLookup/actions.ts   | fetchPartyInformation          | Party                           | partyId                                  | partyId, partyTypeId, roleTypeId                                    | Fetches billing party information for orders.                                      | BillingDetails.vue                            |
| OrderLookup/actions.ts   | fetchContactMechInformation    | ContactMech                     | contactMechId, contactMechId_op          | contactMechId, contactMechTypeId, infoString                       | Retrieves contact mechanisms (addresses, emails) for customers.                   | CustomerDetails.vue                           |
| OrderLookup/actions.ts   | fetchPicklistBinInformation    | PicklistBin                     | orderId, shipGroupSeqId, shipGroupSeqId_op | picklistBinId, statusId, orderId, shipGroupSeqId                   | Fetches picklist bins associated with specific order groups.                      | PicklistManagement.vue                        |

---
