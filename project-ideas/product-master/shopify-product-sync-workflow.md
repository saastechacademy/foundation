
## Shopify Product Sync Workflow

### 1. Shopify GraphQL Query
A custom GraphQL query is constructed to retrieve product data from Shopify. This includes:
- The parent (virtual) product
- All associated variant products
- Tags, features, and metafields (specific to virtual products)

### 2. Shopify Response Format
The output from Shopify is returned in JSONL (JSON Lines) format, where each line in the file is a separate JSON object. Each object can represent a product, variant, or metafield.

### 3. Data Storage
The JSONL response is saved as a text file in a known location on the integration system.

### 4. Sync Processing in Moqui
A Moqui service is responsible for reading and processing this JSONL file. It uses a streaming parser (Jackson `ObjectReader.readValues()`) to process each line individually with minimal memory usage.

### 5. Initial Data Load
The first run of the sync process loads each product and variant into an integration database entity (`ProductUpdateHistory`). This entity captures the full JSON detail and a subset of important attributes (e.g., title, SKU, price, tags, parentProductId).

### 6. Ongoing Sync Behavior
Subsequent sync runs will:
- Read a fresh JSONL export from Shopify
- Process each line and determine if the product/variant already exists in `ProductUpdateHistory`
- Identify changes by comparing new data with previously stored JSON details

### 7. Change Detection and Action
When a change is detected (e.g., title or price updated):
- The integration logic flags the difference
- The updated product data is prepared and pushed downstream to OMS or other systems

### Notes:
- Metafields are only tracked on parent (virtual) products and excluded from variant diff comparison.
- Tags and features are preserved for both parent and variant products.
- The `parentProductId` is stored directly in the integration table to avoid repeated lookups during processing.
