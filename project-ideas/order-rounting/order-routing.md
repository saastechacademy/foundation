# Skill File: Core Structure of Order Routing

### **1. Core Hierarchy & Relationships**
The Order Routing system is organized into three hierarchical levels. This structure allows for precise control over *when* routing happens, *which* orders are routed, and *where* they are fulfilled.

The relationship flows as follows: **Brokering Run** > **Routing Rule** > **Inventory Rule**.

#### **Level 1: Brokering Run (The Schedule)**
*   **Definition:** The highest level of organization that determines the frequency and schedule of the routing process (e.g., every 5 minutes, hourly, daily).
*   **Relationship:** It acts as the container or "group" for multiple Routing Rules, executing them according to the defined timeline to manage workload and priority.
*   **Key Function:** Controls the "When." It allows high-priority runs to occur frequently while standard runs occur less often.

#### **Level 2: Routing Rule (The Batch)**
*   **Definition:** Also referred to as a "Routing" or "Order Batch," this level filters and sorts specific sets of orders to be processed within a Brokering Run.
*   **Relationship:** Resides *within* a Brokering Run. A single run can contain multiple Routing Rules (e.g., one for "Same-Day" and one for "Standard" orders), which are processed in a specific sequence.
*   **Key Function:** Controls the "Which." It uses filters (like Queue or Shipping Method) to group orders and sorting criteria (like Order Date) to prioritize them.

#### **Level 3: Inventory Rule (The Logic)**
*   **Definition:** The specific instructions for locating inventory and assigning facilities for the orders in a Routing Rule.
*   **Relationship:** Resides *within* a Routing Rule. Multiple Inventory Rules are arranged in a sequence; if the first rule fails to allocate inventory, the engine proceeds to the next rule (e.g., check nearby warehouses first, then all stores).
*   **Key Function:** Controls the "Where." It defines facility lookups (using filters like Proximity or Facility Group), sorting (like Inventory Balance), and actions (like splitting orders or moving unfillable items to a queue).