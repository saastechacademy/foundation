# Introduction to Product Features Model
This document provides an overview of the Product Features model, focusing on entities such as - ProductFeature and ProductFeatureAppl - and their applications in representing various product details. Additionally, we will define the key entities and provide sample JSON data.

## Product feature Overview
Example: ABC Organization manufactures different products, including a smartphone and laptop, which is sold online. These products have various features such as color and size.

### Entities

#### 1. ProductFeature
- **Description**: The primary entity that describes the various features that can be associated with a product.

- **Key Attribute**: `productFeatureId`
- **Example**: Lets create the relevant `ProductFeature` needed for ABC's products.
```
{
  "ProductFeature": [
    {
      "productFeatureId": "128BG"
      "productFeatureTypeEnumId": "MEMORY"
    },
    {
      "productFeatureId": "256BG"
      "productFeatureTypeEnumId": "MEMORY"
    },
    {
      "productFeatureId": "BLACK"
      "productFeatureTypeEnumId": "COLOR"
    },
  ]
}
```

#### 2. ProductFeatureAppl
- **Description**: Relationship entity that applies a feature to a product.
- Common `applTypeEnumId` Values:
  1. **DISTINGUISHING_FEAT**: For unique or characteristic features that distinguish one product from another.
  2. **OPTIONAL_FEATURE**: Represents add-on features that are not essential but can be chosen by the user
  3. **REQUIRED_FEATURE**: Essential features necessary for the product’s operation.
  4. **SELECTABLE_FEATURE**: Features that offer multiple options, requiring a selection.
  5. **STANDARD_FEATURE**: Standard features included in every unit of the product.

- **Key Attributes**: `productId`, `productFeatureId`, `fromDate`
- **Example**: Lets apply our features to the respective products. 
```
{
  "ProductFeatureAppl": [
    {
      "productId": "PROD10000",
      "productFeatureId": "128GB",
      "fromdate": "2023-06-01"
      "applTypeEnumId": "SELECTABLE_FEATURE"
    },
    {
      "productId": "PROD10000",
      "productFeatureId": "256GB",
      "fromdate": "2023-06-01"
      "applTypeEnumId": "SELECTABLE_FEATURE"
    },
    {
      "productId": "PROD10001",
      "productFeatureId": "128GB",
      "fromdate": "2023-06-01"
      "applTypeEnumId": "STANDARD_FEATURE"
    },
    {
      "productId": "PROD10002",
      "productFeatureId": "256GB",
      "fromdate": "2023-08-01"
      "applTypeEnumId": "STANDARD_FEATURE"
    },
    {
      "productId": "PROD20000",
      "productFeatureId": "BLACK",
      "fromdate": "2023-09-01"
      "applTypeEnumId": "STANDARD_FEATURE"
    },
    {
      "productId": "PROD20001",
      "productFeatureId": "BLACK",
      "fromdate": "2023-09-01"
      "applTypeEnumId": "STANDARD_FEATURE"
    },
  ]
}
```