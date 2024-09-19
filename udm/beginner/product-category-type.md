# Introduction to Product Category Type Model
This document provides an overview of the Product Category Type model, focusing on various category types that are used in an ecommerce application. We will also consider their purposes and provide example JSONs.

## Product Category Type Overview
Example: ABC Organization sells different products, including smartphones and laptops. These products are categorized in various ways for cataloging and business purposes. 

### Product Category Types

#### 1. Browse Root
- **Purpose**: The Browse Root Category of a catelog serves as the container category which holds the category tree i.e., all sub categories of type CATALOG_CATEGORY.
- **Category Type**: CATALOG_CATEGORY
- **Example**: Lets create the root category for ABC organization and place products in the category.
```
{
  "ProductCategory":{
    "productCategoryId": "BROWSE_ROOT",
    "productCategoryTypeId": "CATALOG_CATEGORY",
    "categoryName": "Browse Root"
  }
  "ProductCategoryMember": [
    {
      "productId": "PROD10000",
      "productCategoryId": "BROWSE_ROOT",
      "fromDate": "2023-01-01",
    },
    {
      "productId": "PROD10001",
      "productCategoryId": "BROWSE_ROOT",
      "fromDate": "2023-01-01",
    },
    {
      "productId": "PROD10002",
      "productCategoryId": "BROWSE_ROOT",
      "fromDate": "2023-01-01",
    },
    {
      "productId": "PROD20000",
      "productCategoryId": "BROWSE_ROOT",
      "fromDate": "2023-01-01",
    },
    {
      "productId": "PROD20001",
      "productCategoryId": "BROWSE_ROOT",
      "fromDate": "2023-01-01",
    }
  ]
}
```

#### 2. Search
- **Purpose**: Search Category provides support to the search functionality of a online catalog. The prod catalog category type for the Search Category is PCCT_SEARCH and only a single Search Category of this type can exist for a catalog. This category will not be associated with Browse Root Category.
- **Category Type**: SEARCH_CATEGORY
- **Example**: Lets create the search category for ABC organization and place products in the category.
```
{
  "ProductCategory":{
    "productCategoryId": "PCCT_SEARCH",
    "productCategoryTypeId": "SEARCH_CATEGORY",
    "categoryName": "Browse Root"
  }
  "ProductCategoryMember": [
    {
      "productId": "PROD10000",
      "productCategoryId": "PCCT_SEARCH",
      "fromDate": "2023-01-01"
    },
    {
      "productId": "PROD10001",
      "productCategoryId": "PCCT_SEARCH",
      "fromDate": "2023-01-01"
    },
    {
      "productId": "PROD10002",
      "productCategoryId": "PCCT_SEARCH",
      "fromDate": "2023-01-01"
    },
    {
      "productId": "PROD20000",
      "productCategoryId": "PCCT_SEARCH",
      "fromDate": "2023-09-01"
    },
    {
      "productId": "PROD20001",
      "productCategoryId": "PCCT_SEARCH",
      "fromDate": "2023-09-01
    }
  ]
}
```

#### 3. View Allow
- **Purpose**: View Allow is optional and special purpose category for a catalog. If View Allow Category exists for a catalog, then all the products are required to be associated with this category to be visible on front store.
- **Category Type**: CATALOG_CATEGORY
- **Example**: Lets create the View Allow category and place relevant products in it. Their phones were released few months after the laptop. 
```
{
  "ProductCategory":{
    "productCategoryId": "PCCT_SEARCH",
    "productCategoryTypeId": "CATALOG_CATEGORY",
    "categoryName": "Browse Root"
  }
  "ProductCategoryMember": [
    {
      "productId": "PROD10000",
      "productCategoryId": "VIEW_ALLOW",
      "fromDate": "2023-01-01"
    },
    {
      "productId": "PROD10001",
      "productCategoryId": "VIEW_ALLOW",
      "fromDate": "2023-06-01"
    },
    {
      "productId": "PROD10002",
      "productCategoryId": "VIEW_ALLOW",
      "fromDate": "2023-08-01"
    },
    {
      "productId": "PROD20000",
      "productCategoryId": "VIEW_ALLOW",
      "fromDate": "2023-09-01"
    },
    {
      "productId": "PROD20001",
      "productCategoryId": "VIEW_ALLOW",
      "fromDate": "2023-09-01"
    }
  ]
}
```
#### 4. Purchase Allow
- **Purpose**: Purchase Allow also is an optional and special purpose category for a catalog. Only the products associated to Purchase Allow Category will be available for purchase from store front in the situation if this category exists.
- **Category Type**: CATALOG_CATEGORY
- **Example**: Lets create the Purchase Allow category and place relevant products in it. Items are available for purchase couple weeks after they are available for viewing. 
```
{
  "ProductCategory":{
    "productCategoryId": "PCCT_PURCHASE_ALLOW",
    "productCategoryTypeId": "CATALOG_CATEGORY",
    "categoryName": "Browse Root"
  }
  "ProductCategoryMember": [
    {
      "productId": "PROD10000",
      "productCategoryId": "PCCT_PURCHASE_ALLOW",
      "fromDate": "2023-01-15"
    },
    {
      "productId": "PROD10001",
      "productCategoryId": "PCCT_PURCHASE_ALLOW",
      "fromDate": "2023-06-15"
    },
    {
      "productId": "PROD10002",
      "productCategoryId": "PCCT_PURCHASE_ALLOW",
      "fromDate": "2023-08-15"
    },
    {
      "productId": "PROD20000",
      "productCategoryId": "PCCT_PURCHASE_ALLOW",
      "fromDate": "2023-09-15"
    },
    {
      "productId": "PROD20001",
      "productCategoryId": "PCCT_PURCHASE_ALLOW",
      "fromDate": "2023-09-15"
    }
  ]
}
```

#### 5. Tax
- **Purpose**: Tax Category is responsible for applying and calculating tax for all the products belonging to Tax Category. Tax Category need not be associated with Browse Root Category.
- **Category Type**: TAX_CATEGORY
- **Example**: Lets create the Tax category and place relevant products in it. Based on the price, ABC's large phone and laptops are classified as `LUXURY_TAX_CATEGORY` items.
```
{
  "ProductCategory":{
    "productCategoryId": "LUXURY_TAX_CATEGORY",
    "productCategoryTypeId": "TAX_CATEGORY",
    "categoryName": "Browse Root"
  }
  "ProductCategoryMember": [
    {
      "productId": "PROD10002",
      "productCategoryId": "LUXURY_TAX_CATEGORY",
      "fromDate": "2023-08-15"
    },
    {
      "productId": "PROD20000",
      "productCategoryId": "LUXURY_TAX_CATEGORY",
      "fromDate": "2023-09-15"
    }
  ]
}
```

#### 6. Promotions
- **Purpose**: Promotions Category is special purpose category to promote specific type of products in specific section over the site to get the user attraction on products. For a catalog single promotion category will exist having prod catalog category type as PROMOTIONS.
- **Category Type**: CATALOG_CATEGORY
- **Example**: Lets create the Promotions category and place relevant products in it. ABC's large phone was promoted during their annual sale.
```
{
  "ProductCategory":{
    "productCategoryId": "PROMOTIONS",
    "productCategoryTypeId": "CATALOG_CATEGORY",
    "categoryName": "Browse Root"
  }
  "ProductCategoryMember":
    {
      "productId": "PROD10002",
      "productCategoryId": "PROMOTIONS",
      "fromDate": "2023-08-15",
      "thruDate": "2023-08-31"
    }
}
```

#### 7. Most Popular
- **Purpose**: The purpose of this category is to list the most popular products available on the e-commerce site. The prod catalog category type for Most Popular Category is MOST_POPULAR and only one category of such type exists for a catalog.
- **Category Type**: CATALOG_CATEGORY
- **Example**: Lets create the Most Popular category and place relevant products in it. ABC's large phone had the highest sales last quarter.
```
{
  "ProductCategory":{
    "productCategoryId": "MOST_POPULAR",
    "productCategoryTypeId": "CATALOG_CATEGORY",
    "categoryName": "Browse Root"
  }
  "ProductCategoryMember":
    {
      "productId": "PROD10002",
      "productCategoryId": "MOST_POPULAR",
      "fromDate": "2023-09-01"
    }
}
```

#### 8. What's New
- **Purpose**: All the fresh arrivals in a e-commerce site are displayed under What's New Category.The prod catalog category type for this category is WHATS_NEW. Only one category of this type exist for a catalog.
- **Category Type**: CATALOG_CATEGORY
- **Example**: Lets create the Most Popular category and place relevant products in it. ABC's laptop was classified as a New Item for 2 months after its release.
```
{
  "ProductCategory":{
    "productCategoryId": "WHATS_NEW",
    "productCategoryTypeId": "CATALOG_CATEGORY",
    "categoryName": "Browse Root"
  }
  "ProductCategoryMember":
    {
      "productId": "PROD20000",
      "productCategoryId": "WHATS_NEW",
      "fromDate": "2023-09-01",
      "thruDate": "2023-10-31"
    }
}
```