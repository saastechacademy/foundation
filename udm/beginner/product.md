# Introduction to Product Model
This document provides an overview of the Product model, focusing on its core entities—Product, ProductContent, ProductPrice, and others—and their applications in representing various product details. Additionally, we will define the key entities and provide sample JSON data for Product.

## Product Model Overview
Example: ABC Organization manufactures different products, including a smartphone and laptop, which is sold online. These have various product details, such as pricing, dimensions, shipping details, and are associated with multiple content resources like images and descriptions.

### Entities

#### 1. Product
- **Description**: The primary entity that describes a product or service available for sale or use. Includes basic attributes and associated entities for detailed information such as dimensions, price, shipping, etc.

- **Key Attribute**: `productId`
- **Example**: Lets create the relevant `FINISHED_GOOD` products. We will categorize them as virtual and varient as needed.
```
{
  "Product": [
    {
      "productId": "PROD10000",
      "productName": "Smartphone",
      "productTypeEnumId": "FINISHED_GOOD",
      "isVirtual": "Y",
      "isVarient": "N",
    },
    {
      "productId": "PROD10001",
      "productName": "Smartphone-128GB",
      "productTypeEnumId": "FINISHED_GOOD",
      "isVirtual": "N",
      "isVarient": "Y",
    },
    {
      "productId": "PROD10002",
      "productName": "Smartphone-256GB",
      "productTypeEnumId": "FINISHED_GOOD",
      "isVirtual": "N",
      "isVarient": "Y",
    },
    {
      "productId": "PROD20000",
      "productName": "Laptop",
      "productTypeEnumId": "FINISHED_GOOD",
      "isVirtual": "Y",
      "isVarient": "N",
      "fromDate": "2023-09-01"
    },
    {
      "productId": "PROD20001",
      "productName": "Laptop-BLACK",
      "productTypeEnumId": "FINISHED_GOOD",
      "isVirtual": "N",
      "isVarient": "Y",
    },
    {
      "productId": "PROM001",
      "productName": "Laptop-Phone-Promotional-Package",
      "productTypeEnumId": "FINISHED_GOOD",
    }
  ]
}
```

#### 2. Product Content
- **Description**: Stores content associated with the product or service. For our modeling, this content is associated with the `VIRTUAL` products.

- **Key Attribute**: `productContentId`
- **Example**: Lets create the needed online content for the products.
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
- **Example**: Lets create the relevant Product Pricing information.
```
{
  "ProductPrice": [
    {
      "productId": "PROD10001",
      "priceTypeEnumId": "LIST_PRICE",
      "price": 799.99
    },
    {
      "productId": "PROD10002",
      "priceTypeEnumId": "LIST_PRICE",
      "price": 1099.99
    },
    {
      "productId": "PROD10002",
      "priceTypeEnumId": "PROMOTIONAL_PRICE",
      "price": 999.99
    },
    {
      "productId": "PROD20000",
      "priceTypeEnumId": "LIST_PRICE",
      "price": 1299.99
    },
    {
      "productId": "PROM001",
      "productName": "Laptop-Phone-Promotional-Package",
      "productTypeEnumId": "PROMOTIONAL_PRICE",
      "price": 1999.99
    }
  ]
}
```
#### 4. Product Dimension
- **Description**: Stores the dimensions of the product, including weight, length, and other custom dimensions.

- **Key Attributes**: `productId`, `dimensionTypeId`
- **Example**: Lets create the relevant productDimensions information.
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
- **Example**: Lets create the relevant product associations between `VIRTUAL` and `VARIENT` products.
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
      "fromdate": "2023-09-01"
    }
  ]
}
```
- **Example**: Lets create the relevant product associations for a `MARKT_PACKAGE` product.
```
{
  "ProductAssoc": [
    {
      "productId": "PROM001",
      "toProductId": "PROD10001",
      "productAssocTypeEnumId": "MARKT_PACKAGE",
      "fromdate": "2023-10-01"
    },
    {
      "productId": "PROM001",
      "toProductId": "PROD20001",
      "productAssocTypeEnumId": "MARKT_PACKAGE",
      "fromdate": "2023-10-01"
    }
  ]
}
```