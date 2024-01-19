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
**Purpose**: Categorizes product features.

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

1. **Define ProductFeatureType**: Categorize the feature.
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
