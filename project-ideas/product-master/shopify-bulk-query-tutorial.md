## Tutorial: Creating and Running Shopify Bulk Query for Products

This tutorial provides a step-by-step guide to using Shopify's Bulk Query feature to download Product data. We'll cover creating the GraphQL query with variables, submitting it via the bulk operation mutation, and monitoring its progress.

### Prerequisites
- A Shopify store with Admin API access.
- API credentials: Store URL, API key, and access token.
- A programming environment (e.g., Python with `requests` library) or a tool like Postman for making HTTP requests.

### Step 1: Understand the Bulk Query Process
Shopify Bulk Operations allow you to run large GraphQL queries asynchronously. The process involves:
1. Creating a bulk operation with your query.
2. Polling for completion.
3. Downloading the results as a JSONL file.

### Step 2: Construct the GraphQL Query for Products
For bulk queries, your query must include at least one connection field. For products, use the `products` connection.

Basic query to get all products with basic fields:
```
query {
  products {
    edges {
      node {
        id
        title
        handle
        status
        createdAt
        updatedAt
        variants {
          edges {
            node {
              id
              title
              sku
              price
              inventoryQuantity
            }
          }
        }
      }
    }
  }
}
```

To use variables (e.g., for filtering), define variables in the query:
```
query GetProducts($first: Int, $query: String) {
  products(first: $first, query: $query) {
    edges {
      node {
        id
        title
        # ... other fields
      }
    }
  }
}
```

Variables allow dynamic queries, such as limiting results or applying filters.

### Step 3: Create the Bulk Operation Mutation
Use the `bulkOperationRunQuery` mutation to submit your query. The mutation takes:
- `query`: The GraphQL query string.
- `groupObjects`: Boolean (default true) to group related objects.

Mutation example:
```
mutation bulkOperationRunQuery($query: String!) {
  bulkOperationRunQuery(query: $query) {
    bulkOperation {
      id
      status
      createdAt
      completedAt
      objectCount
      fileSize
      url
    }
    userErrors {
      field
      message
    }
  }
}
```

Variables for the mutation:
```
{
  "query": "query { products { edges { node { id title } } } }"
}
```

If using query variables, include them in the query string:
```
{
  "query": "query GetProducts($first: Int) { products(first: $first) { edges { node { id title } } } }",
  "variables": { "first": 100 }
}
```

Note: For bulk operations, variables are embedded in the query string.

### Step 4: Authenticate and Send the Request
- Endpoint: `https://{your-store}.myshopify.com/admin/api/2023-10/graphql.json` (replace with your API version)
- Headers:
  - `Content-Type: application/json`
  - `X-Shopify-Access-Token: {your-access-token}`
- Method: POST
- Body: JSON with the mutation and variables.

Example in Python:
```python
import requests
import json

store_url = 'https://your-store.myshopify.com'
access_token = 'your-access-token'
api_version = '2023-10'

url = f'{store_url}/admin/api/{api_version}/graphql.json'
headers = {
    'Content-Type': 'application/json',
    'X-Shopify-Access-Token': access_token
}

# Define the query
query = """
query {
  products {
    edges {
      node {
        id
        title
        handle
        status
        createdAt
        updatedAt
        variants {
          edges {
            node {
              id
              sku
              price
              inventoryQuantity
            }
          }
        }
      }
    }
  }
}
"""

# Mutation to run bulk query
mutation = """
mutation bulkOperationRunQuery($query: String!) {
  bulkOperationRunQuery(query: $query) {
    bulkOperation {
      id
      status
    }
    userErrors {
      field
      message
    }
  }
}
"""

variables = {
    "query": query
}

data = {
    "query": mutation,
    "variables": variables
}

response = requests.post(url, headers=headers, json=data)
result = response.json()

if 'errors' in result:
    print("Errors:", result['errors'])
elif result['data']['bulkOperationRunQuery']['userErrors']:
    print("User Errors:", result['data']['bulkOperationRunQuery']['userErrors'])
else:
    bulk_operation_id = result['data']['bulkOperationRunQuery']['bulkOperation']['id']
    print("Bulk Operation ID:", bulk_operation_id)
```

### Step 5: Poll for Completion
After submitting, poll the bulk operation status. Use the `currentBulkOperation` query or query by ID.

Query to check status:
```
query {
  currentBulkOperation {
    id
    status
    createdAt
    completedAt
    objectCount
    fileSize
    url
  }
}
```

Or by ID:
```
query GetBulkOperation($id: ID!) {
  node(id: $id) {
    ... on BulkOperation {
      id
      status
      url
    }
  }
}
```

Poll every few minutes until `status` is `COMPLETED`.

Example polling code:
```python
def check_bulk_status(bulk_operation_id):
    status_query = """
    query GetBulkOperation($id: ID!) {
      node(id: $id) {
        ... on BulkOperation {
          id
          status
          url
        }
      }
    }
    """
    variables = {"id": bulk_operation_id}
    data = {"query": status_query, "variables": variables}
    response = requests.post(url, headers=headers, json=data)
    result = response.json()
    return result['data']['node']

# Poll
import time
while True:
    status_info = check_bulk_status(bulk_operation_id)
    status = status_info['status']
    print(f"Status: {status}")
    if status == 'COMPLETED':
        download_url = status_info['url']
        break
    elif status in ['FAILED', 'EXPIRED']:
        print("Operation failed or expired")
        break
    time.sleep(60)  # Wait 1 minute
```

### Step 6: Download the Results
Once completed, download the JSONL file from the provided `url`. The file contains one JSON object per line.

Example download:
```python
if download_url:
    download_response = requests.get(download_url)
    with open('products_bulk.jsonl', 'wb') as f:
        f.write(download_response.content)
    print("Downloaded products_bulk.jsonl")
```

### Step 7: Process the Data
The JSONL file has lines like:
```
{"id": "gid://shopify/Product/123", "title": "Product Name", ...}
```

Parse and process as needed for your application.

### Additional Notes
- Bulk operations can take time for large datasets; monitor status accordingly.
- Results are available for 7 days.
- Use variables to filter or limit data if needed.
- Handle errors and rate limits appropriately.
- For production, implement proper error handling and logging.