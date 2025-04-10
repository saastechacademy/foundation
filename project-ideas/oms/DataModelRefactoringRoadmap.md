# Data Model Refactoring and Deprecation Roadmap
We want to refactor and simplify legacy OMS data model by removing any superfluous data maintenance and realigning certain aspects of the data model for easy maintenance as well as performance gains.  

Since the legacy data model was designed to work with OOTB HC screens and workflows, with migration to Moqui we have an opportunity to refactore it.  

While refactoring data model it is important to account for backward compatibility as legacy OMS UI would still work on legacy data model and as we adopt a phased rollout approach legacy business processes referring to legacy data model may still be in use before being completely phased out.  

This document aims at keeping track of proposed data model changes, their impact on legacy UI and business processes and deprecation strategy.

## General Testing Strategy
1. For the proposed data model change migrate one or more existing business objects to the proposed data model.
2. Execute all the business process flows concerning that business object on the proposed data model.
3. Navigate through all the screens where that business object is referenced.
4. To be able to execute complete business flows, you could switch data model back and forth between legacy and proposed while moving through and executing each of the steps.
5. Document business processes and UI screens/sections that are breaking, make sure to document all the exact code references (file, method, line number) of the legacy code that are breaking the business process or the UI.

## Order Data Model

### Introduce OrderHeader.customerPartyId and deprecate relate OrderRole records [BILL_TO_CUSTOMER, END_USER_CUSTOMER, PLACING_CUSTOMER, SHIP_TO_CUSTOMER]
**Alternate approach:** Create only one OrderRole **SHIP_TO_CUSTOMER**

#### Testing Strategy
Test complete order life cycle for an existing order imported from Shopify. To test remove all these roles and document all the business processes and UI that's breaking.

#### Broken Business Processes

#### Broken UI

### Use OrderHeader > ProductStore.payToPartyId and deprecate OrderRole records [BILL_FROM_VENDOR, SHIP_FROM_VENDOR]

#### Broken Business Processes

#### Broken UI

### Deprecate OrderContactMech records [PHONE_SHIPPING, SHIPPING_LOCATION] and use OrderItemShipGroup.contactMechId and OrderItemShipGroup.telecomContactMechId

#### Broken Business Processes

#### Broken UI

### Deprecate OrderContactMech record [BILLING_EMAIL] and only use [ORDER_EMAIL]

#### Broken Business Processes

#### Broken UI

#### Deprecate OrderItemShipGroupAssoc entity and use OrderItem.shipGroupSeqId

#### Broken Business Processes

#### Broken UI

## ContactMech Data Model

### Deprecate TelecomNumber entity and store it in ContactMech.infoString
Reason for this proposal is that we are not maintaining this information and just storing it as received from the external systems.

#### Broken Business Processes

#### Broken UI