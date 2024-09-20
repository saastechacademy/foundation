# Introduction to Return Data Model

This document provides an overview of the Return data model, focusing on its core entities - ReturnHeader and ReturnItem. It describes the structure for tracking and processing returns from customers to vendors (or suppliers) and managing the return process. Additionally, we provide sample JSON data for returns.

## Return Data Model Overview

Example: John Doe returns an item he purchased from ABC Organization due to it being defective, and requests a refund.

### Entities
#### 1. ReturnHeader
- **Description**: Represents the main entity for a return, tracking the overall return request and its status. A return can either be incoming (customer to vendor) or outgoing (vendor to supplier).
- **Key Attribute**: `returnId`
- **Example**: Let's create the relevant return header.
```json
{
  "ReturnHeader": {
    "returnId": "RET123",
    "fromPartyId": "PER123",
    "toPartyId": "ORG456",
    "returnDate": "2024-09-20",
    "statusId": "RETURN_COMPLETED"
  }
}
```

#### 2. ReturnItem
- **Description**: Represents each item in a return, linked to the corresponding OrderItem.
- **Key Attributes**: `returnId`, `returnItemSeqId`
- **Example**: Let's create the relevant return item for the return.
```json
{
  "ReturnItem": [
    {
      "returnId": "RET123",
      "returnItemSeqId": "00001",
      "orderItemSeqId": "00001",
      "returnQuantity": 1,
      "receivedQuantity": 1,
      "returnReasonEnumId": "DEFECTIVE",
      "returnResponseEnumId": "REFUND",
      "returnPrice": "1299.99"
    },
    {
      "returnId": "RET123",
      "returnItemSeqId": "00001",
      "orderItemSeqId": "00003",
      "returnPrice": "65.00"
    }
  ]
}
```

## Complete JSON
### Defective Product Return
```json
{
  "ReturnHeader": {
    "returnId": "RET123",
    "fromPartyId": "PER123",
    "toPartyId": "ORG456",
    "returnDate": "2024-09-20",
    "statusId": "RETURN_COMPLETED",
    "ReturnItem": [
      {
        "returnItemSeqId": "00001",
        "orderItemSeqId": "00001",
        "returnQuantity": 1,
        "receivedQuantity": 1,
        "returnReasonEnumId": "DEFECTIVE",
        "returnResponseEnumId": "REFUND",
        "returnPrice": "1299.99"
      },
      {
        "returnItemSeqId": "00002",
        "orderItemSeqId": "00003",
        "returnPrice": "65.00"
      }
    ]
  }
}
```