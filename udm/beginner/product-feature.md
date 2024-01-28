### Overview of Product Feature Management Entities

UDM offers framework for managing product features and specifications. Key to this functionality are several interrelated entities: Product, ProductFeature, ProductFeatureType, ProductFeatureAppl, and ProductFeatureApplType.

#### 1. Product Entity
**Purpose**: Represents items for sale or use.

**Key Attributes**:
- Product ID: Unique identifier.
- Product Name.
- Description.
- Product Type.
- Price.
- Quantity.

#### 2. ProductFeature Entity
**Purpose**: Specifies attributes or characteristics of a product.

**Key Attributes**:
- Product Feature ID: Unique identifier.
- Feature Type: Linked to ProductFeatureType.
- Description.

#### 3. ProductFeatureType Entity
**Purpose**: Classifies product features.

**Key Attributes**:
- Product Feature Type ID: Unique identifier.
- Description.

#### 4. ProductFeatureAppl Entity
**Purpose**: Links a ProductFeature to a Product, facilitating a many-to-many relationship.

**Key Attributes**:
- Product ID.
- Product Feature ID.
- From Date and Thru Date: Applicability period.
- Sequence Number.
- Amount.

#### 5. ProductFeatureApplType Entity
**Purpose**: Defines the nature of feature application to a product.

**Key Attributes**:
- Product Feature Appl Type ID: Unique identifier.
- Description.

#### Common ProductFeatureApplType Values:
1. **DISTINGUISHING_FEAT**: For unique or characteristic features that distinguish one product from another.
2. **OPTIONAL_FEATURE**: Represents add-on features that are not essential but can be chosen by the user.
3. **REQUIRED_FEATURE**: Essential features necessary for the product’s operation.
4. **SELECTABLE_FEATURE**: Features that offer multiple options, requiring a selection.
5. **STANDARD_FEATURE**: Standard features included in every unit of the product.

### Utilizing Entities for Product Feature Definition

1. **Define ProductFeatureType**: Classify the feature.
2. **Define ProductFeature**: Create a feature with specific details.
3. **Link Feature to Product using ProductFeatureAppl**: Associate the feature with a product, detailing applicability and sequence.
4. **Specify Feature Application using ProductFeatureApplType**: Clarify the nature of the feature's application, whether it's standard, optional, required, distinguishing, or selectable.



A sample JSON data for "Men's Blue Denim Pants" product available in 3 sizes. 

```
{
  "Product": {
    "ProductID": "1001",
    "ProductName": "Men's Blue Denim Pants",
    "Description": "Comfortable and stylish blue denim pants for men.",
    "ProductType": "Clothing",
    "Price": 49.99,
    "Quantity": 500
  },
  "ProductFeatures": [
    {
      "ProductFeatureID": "2001",
      "FeatureType": "3001",
      "Description": "Small"
    },
    {
      "ProductFeatureID": "2002",
      "FeatureType": "3001",
      "Description": "Medium"
    },
    {
      "ProductFeatureID": "2003",
      "FeatureType": "3001",
      "Description": "Large"
    },
    {
      "ProductFeatureID": "2004",
      "FeatureType": "3002",
      "Description": "Blue"
    },
    {
      "ProductFeatureID": "2005",
      "FeatureType": "3003",
      "Description": "Denim"
    }
  ],
  "ProductFeatureTypes": [
    {
      "ProductFeatureTypeID": "3001",
      "Description": "Size"
    },
    {
      "ProductFeatureTypeID": "3002",
      "Description": "Color"
    },
    {
      "ProductFeatureTypeID": "3003",
      "Description": "Material"
    }
  ],
  "ProductFeatureAppl": [
    {
      "ProductID": "1001",
      "ProductFeatureID": "2001",
      "FromDate": "2024-01-01",
      "ThruDate": "2024-12-31",
      "SequenceNumber": 1,
      "Amount": null,
      "ProductFeatureApplTypeID": "4004"
    },
    {
      "ProductID": "1001",
      "ProductFeatureID": "2002",
      "FromDate": "2024-01-01",
      "ThruDate": "2024-12-31",
      "SequenceNumber": 2,
      "Amount": null,
      "ProductFeatureApplTypeID": "4004"
    },
    {
      "ProductID": "1001",
      "ProductFeatureID": "2003",
      "FromDate": "2024-01-01",
      "ThruDate": "2024-12-31",
      "SequenceNumber": 3,
      "Amount": null,
      "ProductFeatureApplTypeID": "4004"
    },
    {
      "ProductID": "1001",
      "ProductFeatureID": "2004",
      "FromDate": "2024-01-01",
      "ThruDate": "2024-12-31",
      "SequenceNumber": 4,
      "Amount": null,
      "ProductFeatureApplTypeID": "4001"
    },
    {
      "ProductID": "1001",
      "ProductFeatureID": "2005",
      "FromDate": "2024-01-01",
      "ThruDate": "2024-12-31",
      "SequenceNumber": 5,
      "Amount": null,
      "ProductFeatureApplTypeID": "4001"
    }
  ],
  "ProductFeatureApplTypes": [
    {
      "ProductFeatureApplTypeID": "4001",
      "Description": "STANDARD_FEATURE"
    },
    {
      "ProductFeatureApplTypeID": "4002",
      "Description": "OPTIONAL_FEATURE"
    },
    {
      "ProductFeatureApplTypeID": "4003",
      "Description": "REQUIRED_FEATURE"
    },
    {
      "ProductFeatureApplTypeID": "4004",
      "Description": "SELECTABLE_FEATURE"
    }
  ]
}
```

**Activity:** 
**Discuss** ProductFeatureAppl and ProductFeatureApplTypes entities and analyse similarity with ProductAssoc and ProductAssocType entities.

- Both ProductFeatureAppl and ProductAssoc entities are used to establish relationships between different aspects of products.
- While ProductFeatureAppl deals with linking specific features to a product (e.g., color, size), ProductAssoc deals with relationships between entire products.
- The ProductFeatureApplType entity and ProductAssocType entity serve similar roles in classifying the nature of these associations (e.g., standard features, optional features, required features, etc.).

**Define** Men's Denim Pants product that is available in 3 colors (Light Blue, Nevy, Black) and 4 sizes (28, 30, 32, 34)  
```
{
  "Product": {
    "ProductID": "1003",
    "ProductName": "Men's Denim Pants",
    "Description": "Stylish denim pants for men.",
    "ProductType": "Clothing",
    "Price": 69.99,
    "Quantity": 250
  },
  "ProductFeatures": [
    {
      "ProductFeatureID": "2013",
      "FeatureType": "3002",
      "Description": "Light Blue"
    },
    {
      "ProductFeatureID": "2014",
      "FeatureType": "3002",
      "Description": "Navy"
    },
    {
      "ProductFeatureID": "2015",
      "FeatureType": "3002",
      "Description": "Black"
    },
    {
      "ProductFeatureID": "2016",
      "FeatureType": "3001",
      "Description": "28"
    },
    {
      "ProductFeatureID": "2017",
      "FeatureType": "3001",
      "Description": "30"
    },
    {
      "ProductFeatureID": "2018",
      "FeatureType": "3001",
      "Description": "32"
    },
    {
      "ProductFeatureID": "2019",
      "FeatureType": "3001",
      "Description": "34"
    }
  ],
  "ProductFeatureAppl": [
    {
      "ProductID": "1003",
      "ProductFeatureID": "2013",
      "FromDate": "2024-01-01",
      "ThruDate": "2024-12-31",
      "SequenceNumber": 1,
      "Amount": null,
      "ProductFeatureApplTypeID": "4001"
    },
    {
      "ProductID": "1003",
      "ProductFeatureID": "2014",
      "FromDate": "2024-01-01",
      "ThruDate": "2024-12-31",
      "SequenceNumber": 2,
      "Amount": null,
      "ProductFeatureApplTypeID": "4001"
    },
    {
      "ProductID": "1003",
      "ProductFeatureID": "2015",
      "FromDate": "2024-01-01",
      "ThruDate": "2024-12-31",
      "SequenceNumber": 3,
      "Amount": null,
      "ProductFeatureApplTypeID": "4001"
    },
    {
      "ProductID": "1003",
      "ProductFeatureID": "2016",
      "FromDate": "2024-01-01",
      "ThruDate": "2024-12-31",
      "SequenceNumber": 4,
      "Amount": null,
      "ProductFeatureApplTypeID": "4001"
    },
    {
      "ProductID": "1003",
      "ProductFeatureID": "2017",
      "FromDate": "2024-01-01",
      "ThruDate": "2024-12-31",
      "SequenceNumber": 5,
      "Amount": null,
      "ProductFeatureApplTypeID": "4001"
    },
    {
      "ProductID": "1003",
      "ProductFeatureID": "2018",
      "FromDate": "2024-01-01",
      "ThruDate": "2024-12-31",
      "SequenceNumber": 6,
      "Amount": null,
      "ProductFeatureApplTypeID": "4001"
    },
    {
      "ProductID": "1003",
      "ProductFeatureID": "2019",
      "FromDate": "2024-01-01",
      "ThruDate": "2024-12-31",
      "SequenceNumber": 7,
      "Amount": null,
      "ProductFeatureApplTypeID": "4001"
    }
  ]
}
```

**Write SQL** to select all available sizes for each color

```
SELECT Color, GROUP_CONCAT(Size ORDER BY SequenceNumber) AS AvailableSizes
FROM ProductFeatureAppl PFA
JOIN ProductFeature PF ON PFA.ProductID = PF.ProductID AND PFA.ProductFeatureID = PF.ProductFeatureID
WHERE
PFA.ThruDate >= CURDATE() AND PFA.ProductID = '1003' AND PF.FeatureType = '3002'
GROUP BY Color;
```
