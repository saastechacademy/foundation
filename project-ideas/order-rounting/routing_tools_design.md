# Design Specification: Order Routing Configuration Tools

This document defines the Mastra tools required to enable an AI Agent to fetch valid configuration items from the HotWax Order Routing system. These tools are essential for the agent to understand the available options when editing or suggesting routing rules.

## Core Objective
To provide a set of atomic, well-defined tools that wrap the existing `UtilService` API calls from the `order-routing` PWA, making them accessible to a Mastra Agent.

---

## Tool 1: `getShippingMethods`
**Purpose**: Retrieve valid shipment method types for a product store (e.g., STANDARD, EXPRESS).

- **Backend Function**: `UtilService.fetchShippingMethods`
- **Input (Zod Schema)**:
  ```typescript
  {
    productStoreId: z.string().describe("The ID of the product store to fetch shipping methods for")
  }
  ```
- **Output**: An array of shipping method objects.
- **Usage Scenario**: When the agent needs to set a "Shipment Method" filter in a routing rule.

---

## Tool 2: `getFacilityGroups`
**Purpose**: List facility groups (e.g., 'Primary Facilities', 'Regional Warehouses').

- **Backend Function**: `UtilService.fetchFacilityGroups`
- **Input (Zod Schema)**:
  ```typescript
  {
    productStoreId: z.string().describe("The ID of the product store associated with the facility groups")
  }
  ```
- **Output**: An array of facility group objects.
- **Usage Scenario**: When the agent needs to select a facility group for an inventory filter or action.

---

## Tool 3: `getFacilities`
**Purpose**: Fetch all facilities available in the system.

- **Backend Function**: `UtilService.fetchFacilities`
- **Input (Zod Schema)**:
  ```typescript
  {
    pageSize: z.number().optional().default(500).describe("Number of facilities to fetch per page")
  }
  ```
- **Output**: A list of facility objects with `facilityId` and `facilityName`.
- **Usage Scenario**: When identifying specific fulfillment locations.

---

## Tool 4: `getRoutingEnums`
**Purpose**: Retrieve valid parameter types for Order and Inventory filters.

- **Backend Function**: `UtilService.fetchEnums`
- **Input (Zod Schema)**:
  ```typescript
  {
    enumTypeId: z.enum(["ORD_FILTER_PRM_TYPE", "INV_FILTER_PRM_TYPE"]).describe("The type of routing filter enums to fetch")
  }
  ```
- **Output**: A collection of enumeration values with IDs and descriptions.
- **Usage Scenario**: When the agent needs to know what *kinds* of filters are available (e.g., "Facility Group", "Product Category").

---

## Tool 5: `getProductCategories`
**Purpose**: List product categories available for filtering rules.

- **Backend Function**: `UtilService.fetchCategories`
- **Input (Zod Schema)**:
  ```typescript
  {
    productStoreId: z.string().describe("The ID of the product store")
  }
  ```
- **Output**: Array of category objects.
- **Usage Scenario**: When setting up rules that only apply to specific types of products.

---

## Tool 6: `getCarrierDetails`
**Purpose**: Fetch carrier names and delivery performance data.

- **Backend Function**: `UtilService.getCarrierInformation`
- **Input (Zod Schema)**:
  ```typescript
  {
    carrierIds: z.array(z.string()).describe("List of carrier party IDs to fetch details for")
  }
  ```
- **Output**: Detailed carrier information including service levels and delivery days.
- **Usage Scenario**: When the agent is optimizing routing based on carrier performance or specific carrier restrictions.

---

## Developer Implementation Notes

1.  **Context Injection**: The `productStoreId` should ideally be managed in the agent's context or passed from the user session, as it is a frequent requirement.
2.  **API Auth**: These tools must have access to the OMS API token. Ensure the Mastra tool implementation handles `Authorization` headers correctly using environment variables or a shared state.
3.  **Data Normalization**: The tool should normalize the raw API response to a clean JSON structure, removing unnecessary metadata before passing it back to the LLM.
4.  **Error Handling**: If an API call fails (e.g., 401 or 404), the tool should return a clear string explaining the failure so the agent can inform the user.
