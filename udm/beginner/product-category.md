# Introduction to Product Category Model
This document provides an overview of the Product Category model, focusing on its core entities - ProductCategory, ProductCategoryMember, and their applications in representing various business relationships. Additionally, we will delve into how to define categories, their hierarchy, and the association of products to these categories. Finally, we provide sample JSON data for a Product, Category, and their relationships.

## Product Category Model Overview
Example: ABC Organization manufactures different products, which are sold online. Throughout time it's products have been associated with various categories.

### Entities

#### 1. Product Category
- **Description**: Represents a product grouping structure within a catalog or any other business categorization such as industry, tax, or best-selling.

- **Key Attribute**: `productCategoryId`
- **Example**: Lets create a product category.
```json
{
  "ProductCategory":
    {
      "productCategoryId": "BROWSE_ROOT",
      "productCategoryTypeId": "CATALOG_CATEGORY",
      "categoryName": "Browse Root"
    }
}
```
#### 2. Product Category Member
- **Description**: Defines the relationship between a product and a category, allowing for a many-to-many relationship between products and categories.

- **Key Attributes**: `productId`, `productCategoryId`, `fromDate`
- **Example**: Lets place one product in the category.
```json
{
  "ProductCategoryMember":
    {
      "productId": "PROD10000",
      "productCategoryId": "BROWSE_ROOT",
      "fromDate": "2023-01-01",
    }
}
```