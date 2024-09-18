# Introduction to Product Model
This document provides an overview of the Product model, focusing on its core entities—Product, ProductContent, ProductPrice, and others—and their applications in representing various product details. Additionally, we will define the key entities and provide sample JSON data for Product.

## Product Model Overview
Example: ABC Organization manufactures different products, including a smartphone, which is sold online. The smartphone has various product details, such as pricing, dimensions, shipping details, and is associated with multiple content resources like images and descriptions.

### Entities

#### 1. Product
- **Description**: The primary entity that describes a product or service available for sale or use. Includes basic attributes and associated entities for detailed information such as dimensions, price, shipping, etc.

- **Key Attribute**: `productId`
- **Example**: Lets create the relevant products.
```
{
  "Product": [
    {
      "productId": "PROD10000",
      "productName": "Smartphone",
      "productTypeEnumId": "VIRTUAL"
    },
    {
      "productId": "PROD10001",
      "productName": "Smartphone-128GB",
      "productTypeEnumId": "VARIENT"
    },
    {
      "productId": "PROD10002",
      "productName": "Smartphone-256GB",
      "productTypeEnumId": "VARIENT"
    },
    {
      "productId": "PROD20000",
      "productName": "Laptop",
      "productTypeEnumId": "VIRTUAL"
    },
    {
      "productId": "PROD20001",
      "productName": "Laptop-BLACK",
      "productTypeEnumId": "VARIENT"
    }
  ]
}
```

#### 2. Product Content
- **Description**: Stores content associated with the product or service. For our modeling, this content is associated with the `VIRTUAL` products.

- **Key Attribute**: `productContentId`
- **Example**: Lets create the needed content.
```
{
  "ProductContent": [
    {
      "productContentId": "CON100"
      "productId": "PROD10000",
      "productContentTypeEnumId": "IMAGE",
      "contentLocation": "/images/smartphone.jpg"
    },
    {
      "productContentId": "CON200"
      "productId": "PROD10000",
      "productContentTypeEnumId": "DESCRIPTION",
      "contentLocation": "/descriptions/smartphone_en.txt"
    },
    {
      "productContentId": "CON300"
      "productId": "PROD20000",
      "productContentTypeEnumId": "IMAGE",
      "contentLocation": "/images/laptop.jpg"
    }
  ]
}
```

#### 3. Product Price
- **Description**: Stores pricing information for a product, including list price, promotional prices, and prices for specific customer groups or vendors.

- **Key Attribute**: `productPriceId`
- **Example**: Lets create the relevant ProductPrices.
```
{
  "ProductPrice": [
    {
      "productId": "PROD10001",
      "priceTypeEnumId": "LIST_PRICE",
      "price": 799.99,
      "fromDate": "2023-01-01"
    },
    {
      "productId": "PROD10002",
      "priceTypeEnumId": "LIST_PRICE",
      "price": 1099.99
    },
    {
      "productId": "PROD10002",
      "priceTypeEnumId": "PROMOTIONAL_PRICE",
      "price": 999.99,
      "fromDate": "2023-07-01",
      "thruDate": "2023-07-31"
    },
    {
      "productId": "PROD20000",
      "priceTypeEnumId": "LIST_PRICE",
      "price": 1299.99,
      "fromDate": "2023-01-01"
    }
  ]
}
```
#### 4. Product Dimension
- **Description**: Stores the dimensions of the product, including weight, length, and other custom dimensions.

- **Key Attributes**: `productId`, `dimensionTypeId`
- **Example**: Lets create the relevant productDimensions.
```
{
  "ProductDimension": [
    {
      "productId": "PROD10000",
      "dimensionTypeEnumId": "WEIGHT",
      "dimensionValue": 6.60
      "valueUomId": "OUNCES"
    },
    {
      "productId": "PROD10000",
      "dimensionTypeEnumId": "MEMORY",
      "dimensionValue": 128
      "valueUomId": "GB"
    },
    {
      "productId": "PROD10000",
      "dimensionTypeEnumId": "MEMORY",
      "dimensionValue": 256
      "valueUomId": "GB"
    },
    {
      "productId": "PROD10001",
      "dimensionTypeEnumId": "WEIGHT",
      "dimensionValue": 2.5
      "valueUomId": "LBS"
    }
  ]
}
```

#### 5. Product Association
- **Description**: Defines relationships between products, such as variants (e.g., size or color), cross/up sell, and/or accessories.

- **Key Attributes**: `productId`, `toProductId`, `productAssocTypeEnumId`, `fromDate`
- **Example**: Lets create the relevant product associations.
```
{
  "ProductAssoc": [
    {
      "productId": "PROD10000",
      "toProductId": "PROD10001",
      "productAssocTypeEnumId": "VARIENT",
      "fromdate": "2023-01-01"
    },
    {
      "productId": "PROD10000",
      "toProductId": "PROD10002",
      "productAssocTypeEnumId": "VARIANT",
      "fromdate": "2023-01-01"
    },
    {
      "productId": "PROD20000",
      "toProductId": "PROD20001",
      "productAssocTypeEnumId": "VARIANT",
      "fromdate": "2023-01-01"
    }
  ]
}
```