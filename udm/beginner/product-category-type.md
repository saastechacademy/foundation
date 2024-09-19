# Introduction to Product Category Type Model
This document provides an overview of the Product Category Type model, focusing on various category types that are used in an ecommerce application. We will also consider their purposes and provide example JSONs.

## Product Category Type Overview
Example: ABC Organization sells different products, including smartphones and laptops. These products are categorized in various ways for cataloging and business purposes. 

### Product Category Types

#### 1. Browse Root
- **Purpose**: The Browse Root Category of a catelog serves as the container category which holds the category tree i.e., all sub categories of type `CATALOG_CATEGORY`.
- **Category Type**: `CATALOG_CATEGORY`
- **Example**: Lets create the `BROWSE_ROOT` category for ABC organization and place products in the category.
```
{
  "ProductCategory": {
    "productCategoryId": "BROWSE_ROOT",
    "productCategoryTypeId": "CATALOG_CATEGORY",
    "categoryName": "Browse Root"
  },
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
- **Purpose**: Search Category provides support to the search functionality of a online catalog. The prod catalog category type for the Search Category is `SEARCH` and only a single Search Category of this type can exist for a catalog. This category will not be associated with Browse Root Category.
- **Category Type**: `SEARCH_CATEGORY`
- **Example**: Lets create the `SEARCH` category for ABC organization and place products in the category.
```
{
  "ProductCategory": {
    "productCategoryId": "SEARCH",
    "productCategoryTypeId": "SEARCH_CATEGORY",
    "categoryName": "Search"
  },
  "ProductCategoryMember": [
    {
      "productId": "PROD10000",
      "productCategoryId": "SEARCH",
      "fromDate": "2023-06-01"
    },
    {
      "productId": "PROD10001",
      "productCategoryId": "SEARCH",
      "fromDate": "2023-06-01"
    },
    {
      "productId": "PROD10002",
      "productCategoryId": "SEARCH",
      "fromDate": "2023-08-01"
    },
    {
      "productId": "PROD20000",
      "productCategoryId": "SEARCH",
      "fromDate": "2023-09-01"
    },
    {
      "productId": "PROD20001",
      "productCategoryId": "SEARCH",
      "fromDate": "2023-09-01
    }
  ]
}
```

#### 3. View Allow
- **Purpose**: View Allow is optional and special purpose category for a catalog. If `VIEW_ALLOW` Category exists for a catalog, then all the products are required to be associated with this category to be visible on front store.
- **Category Type**: `CATALOG_CATEGORY`
- **Example**: Lets create the `VIEW_ALLOW` category and place relevant products in it. Their laptops were released few weeks after thier phones. 
```
{
  "ProductCategory": {
    "productCategoryId": "VIEW_ALLOW",
    "productCategoryTypeId": "CATALOG_CATEGORY",
    "categoryName": "View Allow"
  },
  "ProductCategoryMember": [
    {
      "productId": "PROD10000",
      "productCategoryId": "SEARCH",
      "fromDate": "2023-06-01"
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
- **Purpose**: Purchase Allow also is an optional and special purpose category for a catalog. Only the products associated to `PURCHASE_ALLOW` Category will be available for purchase from store front in the situation if this category exists.
- **Category Type**: `CATALOG_CATEGORY`
- **Example**: Lets create the `PURCHASE_ALLOW` category and place relevant products in it. At ABC items are available for purchase couple weeks after they are available for viewing. 
```
{
  "ProductCategory": {
    "productCategoryId": "PURCHASE_ALLOW",
    "productCategoryTypeId": "CATALOG_CATEGORY",
    "categoryName": "Purchase Allow"
  },
  "ProductCategoryMember": [
    {
      "productId": "PROD10000",
      "productCategoryId": "PURCHASE_ALLOW",
      "fromDate": "2023-06-15"
    },
    {
      "productId": "PROD10001",
      "productCategoryId": "PURCHASE_ALLOW",
      "fromDate": "2023-06-15"
    },
    {
      "productId": "PROD10002",
      "productCategoryId": "PURCHASE_ALLOW",
      "fromDate": "2023-08-15"
    },
    {
      "productId": "PROD20000",
      "productCategoryId": "PURCHASE_ALLOW",
      "fromDate": "2023-09-15"
    },
    {
      "productId": "PROD20001",
      "productCategoryId": "PURCHASE_ALLOW",
      "fromDate": "2023-09-15"
    }
  ]
}
```

#### 5. Tax
- **Purpose**: Tax Category is responsible for applying and calculating tax for all the products belonging to Tax Category. Tax Category need not be associated with Browse Root Category.
- **Category Type**: `TAX_CATEGORY`
- **Example**: Lets create the Tax category and place relevant products in it. Based on the price, ABC's large phone and laptops are classified as `LUXURY_TAX_CATEGORY` items.
```
{
  "ProductCategory": {
    "productCategoryId": "LUXURY_TAX_CATEGORY",
    "productCategoryTypeId": "TAX_CATEGORY",
    "categoryName": "Luxury Tax"
  },
  "ProductCategoryMember": [
    {
      "productId": "PROD10002",
      "productCategoryId": "LUXURY_TAX_CATEGORY",
      "fromDate": "2023-08-15"
    },
    {
      "productId": "PROD20001",
      "productCategoryId": "LUXURY_TAX_CATEGORY",
      "fromDate": "2023-09-15"
    }
  ]
}
```

#### 6. Promotions
- **Purpose**: The Promotions Category is a specialized category designed to highlight specific products in designated sections of the site, aimed at attracting user attention. Each catalog can have a single Promotions Category with the catalog category type set to `PROMOTIONS` and its parent category is `BROWSE_ROOT`.
- **Category Type**: `CATALOG_CATEGORY`
- **Example**: Lets create the `PROMOTIONS` category and place relevant products in it. ABC's large phone was promoted during their annual sale.
```
{
  "ProductCategory": {
    "productCategoryId": "PROMOTIONS",
    "productCategoryTypeId": "CATALOG_CATEGORY",
    "parentProductCategoryId" = "BROWSE_ROOT",
    "categoryName": "Promotions"
  }
  "ProductCategoryMember": {
    "productId": "PROD10002",
    "productCategoryId": "PROMOTIONS",
    "fromDate": "2023-08-15",
    "thruDate": "2023-08-31"
  }
}
```

#### 7. Most Popular
- **Purpose**: The purpose of this category is to list the most popular products available on the e-commerce site. The prod catalog category type for Most Popular Category is MOST_POPULAR and its parent category is `BROWSE_ROOT`. Only one category of such type exists for a catalog.
- **Category Type**: `CATALOG_CATEGORY`
- **Example**: Lets create the `MOST_POPULAR` category and place relevant products in it. ABC's large phone had the highest sales last quarter.
```
{
  "ProductCategory": {
    "productCategoryId": "MOST_POPULAR",
    "productCategoryTypeId": "CATALOG_CATEGORY",
    "parentProductCategoryId" = "BROWSE_ROOT",
    "categoryName": "Most Popular"
  },
  "ProductCategoryMember": {
    "productId": "PROD10002",
    "productCategoryId": "MOST_POPULAR",
    "fromDate": "2023-09-01"
  }
}
```

#### 8. What's New
- **Purpose**: All the fresh arrivals in a e-commerce site are displayed under What's New Category.The prod catalog category type for this category is `WHATS_NEW` and its parent category is `BROWSE_ROOT`. Only one category of this type exist for a catalog.
- **Category Type**: `CATALOG_CATEGORY`
- **Example**: Lets create the `WHATS_NEW` category and place relevant products in it. ABC's laptop was classified as a New Item for 2 months after its release.
```
{
  "ProductCategory": {
    "productCategoryId": "WHATS_NEW",
    "productCategoryTypeId": "CATALOG_CATEGORY",
    "parentProductCategoryId" = "BROWSE_ROOT",
    "categoryName": "Whats New"
  },
  "ProductCategoryMember": [
    {
      "productId": "PROD20000",
      "productCategoryId": "WHATS_NEW",
      "fromDate": "2023-09-01",
      "thruDate": "2023-10-31"
    },
    {
      "productId": "PROD20001",
      "productCategoryId": "WHATS_NEW",
      "fromDate": "2023-09-01",
      "thruDate": "2023-10-31"
    }
  ]
}
```