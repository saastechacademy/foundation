Define process to configure the OMS for a retailer.

The OMS configuration process starts with setting up Organization data in the OMS database. Given below is the Sample data

```
    <Party partyId="COMPANY" partyTypeId="PARTY_GROUP"/>
    <PartyGroup partyId="COMPANY" groupName="Default Company" logoImageUrl="/resources/uploads/images/company_logo.png"/>
    <PartyRole partyId="COMPANY" roleTypeId="SHIP_FROM_VENDOR"/>
    <PartyRole partyId="COMPANY" roleTypeId="BILL_TO_CUSTOMER"/>
    <PartyRole partyId="COMPANY" roleTypeId="INTERNAL_ORGANIZATIO"/>
    <PartyRole partyId="COMPANY" roleTypeId="_NA_"/>

```

Validate the above company setup data with your knowledge of Apache OFBiz. 
Why do we assign various roles to the Company? 
Do we have to add all these roles? How they get used? 



One the company is setup, then next step is to setup the productStore. Below is the sample data of a one productStore setup in the OMS.

```
    <ProductStoreGroup productStoreGroupName="Company Store Group" description="Company Store Group" productStoreGroupId="STORE_GROUP"/>
    <ProductStore productStoreId="STORE" storeName="Demo Store" primaryStoreGroupId="STORE_GROUP" companyName="Company" title="Company" subtitle="Company" payToPartyId="COMPANY"
                  viewCartOnAdd="N" autoSaveCart="Y" inventoryFacilityId="_NA_" oneInventoryFacility="N" checkInventory="N" reserveInventory="Y" reserveOrderEnumId="INVRO_FIFO_REC" allowSplit="Y"
                  requireInventory="Y" balanceResOnOrderCreation="N" orderNumberPrefix="" defaultLocaleString="en_US" defaultCurrencyUomId="USD" catalogUrlMountPoint="products" defaultSalesChannelEnumId="WEB_SALES_CHANNEL"
                  allowPassword="Y" explodeOrderItems="Y" retryFailedAuths="Y" headerApprovedStatus="ORDER_APPROVED" itemApprovedStatus="ITEM_APPROVED" digitalItemApprovedStatus="ITEM_APPROVED" headerDeclinedStatus="ORDER_REJECTED"
                  itemDeclinedStatus="ITEM_REJECTED" headerCancelStatus="ORDER_CANCELLED" itemCancelStatus="ITEM_CANCELLED" autoSetFacility="Y" authDeclinedMessage="There has been a problem with your method of payment. Please try a different method or call customer service."
                  authFraudMessage="Your order has been rejected and your account has been disabled due to fraud." authErrorMessage="Problem connecting to payment processor; we will continue to retry and notify you by email."
                  usePrimaryEmailUsername="Y" prodSearchExcludeVariants="Y" storeCreditValidDays="90" autoApproveInvoice="Y" autoApproveOrder="N" shipIfCaptureFails="N" reqReturnInventoryReceive="N" prorateShipping="Y" prorateTaxes="Y"/>

    <ProductStoreSetting productStoreId="STORE" settingTypeEnumId="RATE_SHOPPING" fromDate="2001-01-01 12:00:00.000" settingValue="Y"/>
    <ProdCatalog prodCatalogId="CATALOG" catalogName="Company Catalog" useQuickAdd="Y"/>
    <ProductStoreCatalog productStoreId="STORE" prodCatalogId="CATALOG" fromDate="2018-01-01 12:00:00.000" sequenceNum="2"/>

```

In OMS,
All Sales orders are placed by customers and fulfilled to by the Retailer company. This is why the Company should have bill from vendor role. 


Here is something I missed earlier.

The complete process of  ProductStore, includes setup of certain Facilities. They are critical to for the operations of OMS.
Given below is the sample data of facilities we have to setup with the ProductStore.

```
    <Facility facilityId="_NA_" facilityTypeId="NA" defaultInventoryItemTypeId="NON_SERIAL_INV_ITEM" facilityName="Brokering Queue" description="Brokering Queue" externalId="_NA_"/>
    <Facility facilityId="UNF_HOLD_PARKING" facilityTypeId="NA" defaultInventoryItemTypeId="NON_SERIAL_INV_ITEM" facilityName="Unfillable Hold Parking" description="Unfillable Hold Parking" externalId="UNF_HOLD_PARKING"/>
    <Facility facilityId="UNFILLABLE_PARKING" facilityTypeId="NA" defaultInventoryItemTypeId="NON_SERIAL_INV_ITEM" facilityName="Unfillable Parking" description="Unfillable Parking" externalId="UNFILLABLE_PARKING"/>
    <Facility facilityId="REJECTED_ITM_PARKING" facilityTypeId="NA" defaultInventoryItemTypeId="NON_SERIAL_INV_ITEM" facilityName="Rejected Item Parking" description="Rejected Item Parking" externalId="REJECTED_ITM_PARKING"/>
    <Facility facilityId="PICKUP_REJECTED" facilityTypeId="NA" defaultInventoryItemTypeId="NON_SERIAL_INV_ITEM" facilityName="Store Pickup Rejected Queue" description="Store Pickup Rejected Queue" externalId="PICKUP_REJECTED"/>
    <!-- Preorder Facility -->
    <Facility facilityId="PRE_ORDER_PARKING" facilityTypeId="PRE_ORDER" defaultInventoryItemTypeId="NON_SERIAL_INV_ITEM" facilityName="Preorder Parking" description="Preorder Parking" externalId="PRE_ORDER_PARKING"/>
    <Facility facilityId="BACKORDER_PARKING" facilityTypeId="BACKORDER" defaultInventoryItemTypeId="NON_SERIAL_INV_ITEM" facilityName="Backorder Parking" description="Backorder Parking" externalId="BACKORDER_PARKING"/>
    <!--Facility for already completed/cancelled old and new order -->
    <Facility facilityId="GENERAL_OPS_PARKING" facilityTypeId="GENERAL_OPERATIONS" defaultInventoryItemTypeId="NON_SERIAL_INV_ITEM" facilityName="General Ops Parking" description="Facility for already completed/cancelled old and new order" externalId="GENERAL_OPS_PARKING"/>
    <Facility facilityId="RELEASED_ORD_PARKING" facilityTypeId="RELEASED_ORD" defaultInventoryItemTypeId="NON_SERIAL_INV_ITEM" facilityName="Released Order Parking" description="Released Order Parking" externalId="RELEASED_ORD_PARKING"/>

    <!--Facility Group Member data for AUTO_CNCL_ODR_ITM group-->
    <FacilityGroupMember facilityId="_NA_" facilityGroupId="AUTO_CNCL_ODR_ITM" fromDate="2024-08-27 13:06:07.0"/>
    <FacilityGroupMember facilityId="UNFILLABLE_PARKING" facilityGroupId="AUTO_CNCL_ODR_ITM" fromDate="2024-08-27 13:06:07.0"/>


    <!--Facility for threshold management-->
    <Facility facilityId="CONFIGURATION" facilityTypeId="CONFIGURATION" defaultInventoryItemTypeId="NON_SERIAL_INV_ITEM" facilityName="Configuration Facility" description="Configuration Facility" externalId="CONFIGURATION"/>
    <ProductStoreFacility productStoreId="STORE" facilityId="CONFIGURATION" fromDate="2001-05-13 12:00:00.0"/>


```

Once the productStore setup is complete, next is to configure Shopify ECommerce. 

