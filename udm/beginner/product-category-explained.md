###### This document contains information about various categories and their types for developing an e-commerce application, also considering the purpose of them.

* Browse Root Category
* Search Category
* View Allow Category
* Purchase Allow Category
* Tax Category
* Promotions Category
* Most Popular Category
* What's New Category


### Browse Root Category

**Purpose:** Browse Root Category of a catalog serves as the container category which holds the category tree i.e, all sub categories of type CATALOG_CATEGORY.
**Description:** Only one Browse Root category can be associated with a catalog as prod catalog category type PCCT_BROWSE_ROOT. Browse Root and all the categories associated with it will have the product category type as CATALOG_CATEGORY.
**Category Type:** CATALOG_CATEGORY

**API Support**
Present in class CatalogWorker

public static String getCatalogTopCategoryId(ServletRequest request)
public static String getCatalogTopCategoryId(ServletRequest request, String prodCatalogId)

Demo Setup: Sample data given to get an idea about how Browse Root Category is associated with catalog and other categories.
Association of catalog with "BROWSE_ROOT" category

```
<ProductCategory productCategoryId="BROWSE_ROOT" productCategoryTypeId="CATALOG_CATEGORY" categoryName="Browse Root" longDescription="Primary Browse Root Category" description="Browse Root"/>
<ProdCatalogCategory prodCatalogId="WFI_CATALOG" productCategoryId="BROWSE_ROOT" fromDate="2001-05-15 12:00:00.0" sequenceNum="1" prodCatalogCategoryTypeId="PCCT_BROWSE_ROOT"/>

Association of other categories with "BROWSE_ROOT" category
<ProductCategory productCategoryId="4999" productCategoryTypeId="CATALOG_CATEGORY" primaryParentCategoryId="BROWSE_ROOT" description="Food" categoryName="Food" productCategoryUrlName="survival-food"/>
<ProductCategory productCategoryId="5004" productCategoryTypeId="CATALOG_CATEGORY" primaryParentCategoryId="BROWSE_ROOT" description="Water" categoryName="Water" productCategoryUrlName="water-filters"/>
<ProductCategory productCategoryId="5005" productCategoryTypeId="CATALOG_CATEGORY" primaryParentCategoryId="BROWSE_ROOT" description="Power" categoryName="Power" productCategoryUrlName="portable-solar-power"/>

<ProductCategoryRollup fromDate="2001-05-15 12:00:00.0" parentProductCategoryId="BROWSE_ROOT" productCategoryId="4999" sequenceNum="1"/>
<ProductCategoryRollup fromDate="2001-05-15 12:00:00.0" parentProductCategoryId="BROWSE_ROOT" productCategoryId="5004" sequenceNum="2"/>
<ProductCategoryRollup fromDate="2001-05-15 12:00:00.0" parentProductCategoryId="BROWSE_ROOT" productCategoryId="5005" sequenceNum="3"/>
```

**Additional Notes**

Sequence number in Product Category Rollup depicts the order in which the categories will be displayed on front store.
A Product Category is either group of products or categories.
A Product Category should be setup to group only categories or only products not both.

### Search Category
**Purpose:** Search Category provides support to the search functionality of a online catalog. The prod catalog category type for the Search Category is PCCT_SEARCH and only a single Search Category of this type can exist for a catalog. This category will not be associated with Browse Root Category.
**Description:** The Search Category with prod catalog category type as PCCT_SEARCH is considered as default search category. To enable search directly for a product or for any other categories, we need to associate these categories or products to the Search Category. In case we want to enable the search to show the product variants, then we will be required to set flag prodSearchExcludeVariants to 'N' for ProductStore. Note that only virtual products will be associated (in case of virtual/ variant) with search category and to enable search on variants of virtual products, we will use the above mentioned flag for ProductStore.
**Category Type:** SEARCH_CATEGORY

**API Support**
TO DO

**Demo Setup:** Sample data given to get an idea about how Search Category is associated with other category and member products.
Association of catalog with "CATALOG_SEARCH" category

```
<ProductCategory productCategoryId="CATALOG_SEARCH" productCategoryTypeId="SEARCH_CATEGORY" categoryName="Default Search" description="Default Search" longDescription="Only the products belonging to Catalog Search category will be searched"/>
<ProdCatalogCategory prodCatalogId="WFI_CATALOG" productCategoryId="CATALOG_SEARCH" fromDate="2001-05-15 12:00:00.0" sequenceNum="1" prodCatalogCategoryTypeId="PCCT_SEARCH"/>

Association of products with "CATALOG_SEARCH" category
<ProductCategoryMember productCategoryId="CATALOG_SEARCH" productId="9000" fromDate="2001-05-13 12:00:00.0"/>
<ProductCategoryMember productCategoryId="CATALOG_SEARCH" productId="9001" fromDate="2001-05-13 12:00:00.0"/>
```
**Additional Notes**
Sequence number in Product Category Member depicts the order in which the products will be displayed on front store.
**Best practice:** Set the Product Category Members.

### View Allow Category
**Purpose:** View Allow is optional and special purpose category for a catalog. If View Allow Category exists for a catalog, then all the products are required to be associated with this category to be visible on front store.
**Description:** Benefit of using View Allow Category is that you only need to maintain one relationship i.e; associate the categories directly with View Allow Category for web visibility, rather than associating every product to it separately. The prod catalog category type will be PCCT_VIEW_ALLOW for this category.  It has no association with Browse Root.
**Category Type:** CATALOG_CATEGORY

**API Support**
To Do
**Demo Setup:** Sample data given to get an idea about how View Allow Category is associated with other categories and member products.
Association of catalog with "VIEW_ALLOW" category

```
<ProductCategory productCategoryId="VIEW_ALLOW" productCategoryTypeId="CATALOG_CATEGORY" categoryName="View Allow"/>
<ProdCatalogCategory prodCatalogId="WFI_CATALOG" productCategoryId="VIEW_ALLOW" fromDate="2001-05-15 12:00:00.0" sequenceNum="1" prodCatalogCategoryTypeId="PCCT_VIEW_ALLOW"/>

Sample data to demonstrate association of products with "VIEW_ALLOW" category
<ProductCategoryMember productCategoryId="VIEW_ALLOW" productId="9000" fromDate="2001-05-13 12:00:00.0" sequenceNum="1"/>
<ProductCategoryMember productCategoryId="VIEW_ALLOW" productId="9001" fromDate="2001-05-13 12:00:00.0" sequenceNum="2"/>
```

**Additional Notes**
More than one product catalog category types can be assigned to a category.
Best Practice: Add new category for each catalog category type.
Best practice: Set the Product Category Members.

### Purchase Allow Category
**Purpose:** Purchase Allow also is an optional and special purpose category for a catalog. Only the products associated to Purchase Allow Category will be available for purchase from store front in the situation if this category exists.
**Description:** There might be some products onsite which cannot be purchased directly and come under a package or kit. These kind of products are excluded from this category. The prod catalog category type for Purchase Allow Category will be PCCT_PURCHASE_ALLOW.
**Category Type:** CATALOG_CATEGORY

**API Support**
To Do

**Demo Setup:** Sample data given to get an idea about how Purchase Allow Category is associated with other categories and member products.
Association of catalog with "PURCHASE_ALLOW" category

```
<ProductCategory productCategoryId="PURCHASE_ALLOW" productCategoryTypeId="CATALOG_CATEGORY" categoryName="Purchase Allow"/>
<ProdCatalogCategory prodCatalogId="WFI_CATALOG" productCategoryId="PURCHASE_ALLOW" fromDate="2001-05-15 12:00:00.0" sequenceNum="1" prodCatalogCategoryTypeId="PCCT_PURCHASE_ALLOW"/>

Association of products with "PURCHASE_ALLOW" category
<ProductCategoryMember productCategoryId="PURCHASE_ALLOW" productId="9000" fromDate="2001-05-13 12:00:00.0" sequenceNum="1"/>
<ProductCategoryMember productCategoryId="PURCHASE_ALLOW" productId="9001" fromDate="2001-05-13 12:00:00.0" sequenceNum="2"/>
```
**Additional Notes**

More than one product catalog category types can be assigned to a category.
Best Practice: Add new category for each catalog category type.
Best Practice: Set the Product Category Members.

### Tax Category
Purpose: Tax Category is responsible for applying and calculating tax for all the products belonging to Tax Category. Tax Category need not be associated with Browse Root Category.
Description: Tax Category can be treated as grouping of products on which you want to apply same tax percent rate. The advantage of this type of categorization for applying tax is that it prevents application of multiple taxes/tax percent rate on single items. Various Tax Categories can be created for a number of product groups if the tax percent applied is different for various product groups. For instance, if you have to setup tax percent for food products as 3.0% and 5.0% for water products for all orders of Utah state, you have to setup two categories for it- "FOOD_TAX_CATEGORY" and "WATER_TAX_CATEGORY". After adding the products to the categories, the categories need to be associated with the tax authority and two different tax rates (3.0% and 5.0%) will be set for them. Now when a user will purchase a product from the storefront, the tax will be calculated based on the tax rate of the category to which the product belongs.
Category Type: TAX_CATEGORY

API Support
To Do

Demo Setup: Sample data given to get an idea about the how tax categories are associated with tax authorities along with tax percent rate.

Tax category association with tax authorities along with tax percent rate
```
<ProductCategory productCategoryId="FOOD_TAX_CATEGORY" categoryName="Tax Food Products" productCategoryTypeId="TAX_CATEGORY"/>
<ProductCategory productCategoryId="WATER_TAX_CATEGORY" categoryName="Tax Water Products" productCategoryTypeId="TAX_CATEGORY"/>

<Party partyId="UT_TAXMAN" partyTypeId="PARTY_GROUP"/>
<PartyRole partyId="UT_TAXMAN" roleTypeId="TAX_AUTHORITY"/>
<PartyGroup partyId="UT_TAXMAN" groupName="Utah Sales Tax Authority"/>

<TaxAuthority taxAuthGeoId="UT" taxAuthPartyId="UT_TAXMAN" includeTaxInPrice="N"/>

<!--Tax rate for food category products-->
<TaxAuthorityCategory taxAuthGeoId="UT" taxAuthPartyId="UT_TAXMAN" productCategoryId="FOOD_TAX_CATEGORY"/>
<TaxAuthorityRateProduct taxAuthorityRateSeqId="9002" taxAuthGeoId="UT" taxAuthPartyId="UT_TAXMAN" taxAuthorityRateTypeId="SALES_TAX" productStoreId="9000"
productCategoryId="FOOD_TAX_CATEGORY" titleTransferEnumId="" minItemPrice="0.00" minPurchase="0.00" taxShipping="N" taxPercentage="3.00" taxPromotions="N" fromDate="2001-05-13 00:00:00.001" thruDate="" description="Tax Applicable for Food Category Products"/>

<!--Tax rate for water category products-->
<TaxAuthorityCategory taxAuthGeoId="UT" taxAuthPartyId="UT_TAXMAN" productCategoryId="WATER_TAX_CATEGORY"/>
<TaxAuthorityRateProduct taxAuthorityRateSeqId="9003" taxAuthGeoId="UT" taxAuthPartyId="UT_TAXMAN" taxAuthorityRateTypeId="SALES_TAX" productStoreId="9000"
productCategoryId="WATER_TAX_CATEGORY" titleTransferEnumId="" minItemPrice="0.00" minPurchase="0.00" taxShipping="N" taxPercentage="5.00" taxPromotions="N"
fromDate="2001-05-13 00:00:00.001" thruDate="" description="Tax Applicable for Water Category Products"/>
```

### Promotions Category
Purpose: Promotions Category is special purpose category to promote specific type of products in specific section over the site to get the user attraction on products. For a catalog single promotion category will exist having prod catalog category type as PCCT_PROMOTIONS.
Description: Promotions Category categorizes all the promoted products scattered over the various categories of online store into single category on e-commerce site. Promotions Category usually contain products within it, but it can also display the categories which merchandizing manager wants to promote. It is not compulsory to associate Promotions Category with Browse Root despite its product category type as CATALOG_CATEGORY.
Category Type: CATALOG_CATEGORY

API Support
To Do

Demo Setup: Sample data given to get an idea about how products and categories are associated with Promotions Category in system.

Association of categories with PROMOTIONS category
```
<ProductCategory productCategoryId="PROMOTIONS" productCategoryTypeId="CATALOG_CATEGORY" categoryName="Special Offer"/>
<ProdCatalogCategory prodCatalogId="WFI_CATALOG" productCategoryId="PROMOTIONS" fromDate="2001-05-13 12:00:00.0" sequenceNum="1" prodCatalogCategoryTypeId="PCCT_PROMOTIONS"/>

<ProductCategoryRollup fromDate="2001-05-13 12:00:00.0" parentProductCategoryId="PROMOTIONS" productCategoryId="4999" sequenceNum="1"/>
<ProductCategoryRollup fromDate="2001-05-13 12:00:00.0" parentProductCategoryId="PROMOTIONS" productCategoryId="5004" sequenceNum="2"/>
<ProductCategoryRollup fromDate="2001-05-13 12:00:00.0" parentProductCategoryId="PROMOTIONS" productCategoryId="5005" sequenceNum="3"/>

Sample data to demonstrate association of products with PROMOTIONS category
<ProductCategoryMember productCategoryId="PROMOTIONS" productId="9021" fromDate="2001-05-13 12:00:00.0" sequenceNum="1"/>
<ProductCategoryMember productCategoryId="PROMOTIONS" productId="9000" fromDate="2001-05-13 12:00:00.0" sequenceNum="2"/>
```

Additional Notes

Sequence number in Product Category Member and Product Category Rollup depicts the order in which the products and categories will be respectively displayed in the Promotions Category section.
Best Practice: Set the Product Category Members if page will show the products
Best Practice: Set Category Rollups if the page will show the categories.
In general it is about setting the Product Category Members.

### Most Popular Category
Purpose: The purpose of this category is to list the most popular products available on the e-commerce site. The prod catalog category type for Most Popular Category is PCCT_MOST_POPULAR and only one category of such type exists for a catalog.
Description: Most Popular Category usually contain products within it, but it can also hold the list of most popular categories which will in turn display the most popular products within them.
Category Type: CATALOG_CATEGORY

API Support
To Do

Demo Setup: Sample data given to get an idea about how Most Popular Category is associated with other categories and member products.

Association of other categories with "MOST_POPULAR" category
```
<ProductCategory productCategoryId="MOST_POPULAR" productCategoryTypeId="CATALOG_CATEGORY" categoryName="Most Popular"/>
<ProdCatalogCategory prodCatalogId="WFI_CATALOG" productCategoryId="MOST_POPULAR" fromDate="2001-05-15 12:00:00.0" sequenceNum="1" prodCatalogCategoryTypeId="PCCT_MOST_POPULAR"/>

<ProductCategoryRollup fromDate="2001-05-13 12:00:00.0" parentProductCategoryId="MOST_POPULAR" productCategoryId="4999" sequenceNum="1"/>
<ProductCategoryRollup fromDate="2001-05-13 12:00:00.0" parentProductCategoryId="MOST_POPULAR" productCategoryId="5004" sequenceNum="2"/>
<ProductCategoryRollup fromDate="2001-05-13 12:00:00.0" parentProductCategoryId="MOST_POPULAR" productCategoryId="5005" sequenceNum="3"/>

	Association of products with "MOST_POPULAR" category
<ProductCategoryMember productCategoryId="MOST_POPULAR" productId="9000" fromDate="2001-05-13 12:00:00.0" sequenceNum="1"/>
<ProductCategoryMember productCategoryId="MOST_POPULAR" productId="9001" fromDate="2001-05-13 12:00:00.0" sequenceNum="2"/>
```

Additional Notes

Most Popular Category displays the products based on the number of hits on the product or based on the sale of a product.
To display the most popular categories or products, an algorithm is written which displays the products sorted by sale or hit.
This method is not used in Ofbiz, instead a catalog category type PCCT_MOST_POPULAR is used which give the rights to merchandizing manager to display the products in this category which are chosen keeping in mind the growth of business.
Sequence number in Product Category Rollup and Product Category Member depicts the order in which the categories and products will be displayed in this category.
Best Practice: Set the Product Category Members if page will show the products
Best Practice: Set Category Rollups if the page will show the categories.
In general it is about setting the Product Category Members.

### What's New Category
Purpose: All the fresh arrivals in a e-commerce site are displayed under What's New Category.The prod catalog category type for this category is PCCT_WHATS_NEW. Only one category of this type exist for a catalog.
Description: This category contains all the products that are newly added to the site as fresh products.
Category Type: CATALOG_CATEGORY

API Support
To Do

Demo Setup: Sample data given to get an idea about how What's New Category is associated with other categories and member products.

Association of other categories with "WHATS_NEW" category
```
<ProductCategory productCategoryId="WHATS_NEW" productCategoryTypeId="CATALOG_CATEGORY" categoryName="Whats New"/>
<ProdCatalogCategory prodCatalogId="WFI_CATALOG" productCategoryId="WHATS_NEW" fromDate="2001-05-15 12:00:00.0" sequenceNum="1" prodCatalogCategoryTypeId="PCCT_WHATS_NEW"/>

<ProductCategoryRollup fromDate="2001-05-13 12:00:00.0" parentProductCategoryId="WHATS_NEW" productCategoryId="4999" sequenceNum="1"/>
<ProductCategoryRollup fromDate="2001-05-13 12:00:00.0" parentProductCategoryId="WHATS_NEW" productCategoryId="5004" sequenceNum="2"/>
<ProductCategoryRollup fromDate="2001-05-13 12:00:00.0" parentProductCategoryId="WHATS_NEW" productCategoryId="5005" sequenceNum="3"/>

Association of products with "WHATS_NEW" category
<ProductCategoryMember productCategoryId="WHATS_NEW" productId="9000" fromDate="2001-05-13 12:00:00.0" sequenceNum="1"/>
<ProductCategoryMember productCategoryId="WHATS_NEW" productId="9001" fromDate="2001-05-13 12:00:00.0" sequenceNum="2"/>
```
Additional Notes

The visibility of a product will depend on the introduction date of product i.e; an algorithm could be applied to display the last 20 products added to the storefront based on their introduction date.
Algorithms are applied to the Whats New Category which determine what product will be displayed in the category. The products to be displayed in the category are sorted on the basis of introduction date.
In Ofbiz instead of applying some algorithm to determine what all products will be displayed in the category, the merchandising manager is given the authority to decide and manage the products present over there.
Sequence number in Product Category Rollup and Product Category Member depicts the order in which the categories and products will be displayed on the front store respectively.
Best Practice: Set the Product Category Members if page will show the products
Best Practice: Set Category Rollups if the page will show the categories.
In general it is about setting the Product Category Members.