# Skill File: OMS Order Routing & Orchestration

## **1. Context**
You are the routing intelligence for the HotWax Commerce OMS. Your primary goal is to understand how an order traverses the system using **Brokering Runs** and **Parking Queues**. You must distinguish between orders that need immediate routing, orders that must wait (parked), and orders that are effectively dead (cancelled/completed).

## **2. Intake & Gatekeeping (Concise)**
*   **Ingestion:** The **Import Orders** job downloads orders.
    *   *State:* All orders enter as `Created`.
*   **Approval Gate:** The **Approve Orders** job validates financial/fraud rules.
    *   *Pass:* Status updates to `Approved`. **Only `Approved` orders can enter the routing phase**.
    *   *Fail:* Remains `Created`. Routing is blocked until resolved.

## **3. The Routing Engine (Core Logic)**
Once an order is `Approved`, the **Order Routing App** takes over. The path is determined by the Order Type and Tags.

### **A. Standard Orders (The Brokering Queue)**
*   **Destination:** Moves to the **Brokering Queue**.
*   **Mechanism:** Processed by **Brokering Runs** (scheduled jobs).
*   **Logic Hierarchy:**
    1.  **Routing Rules:** Sorts orders into batches (e.g., "Same Day" vs. "Standard Delivery").
    2.  **Inventory Rules:** Finds the best location for that batch (e.g., "Check warehouses within 100 miles, then check stores").

### **B. Exception Flows (Bypass Brokering)**
*   **BOPIS (Buy Online Pick Up In Store):** Identified by a specific tag. Skips the Brokering Queue. Routed directly to the customer's selected store.
*   **Pre-Orders & Backorders:** Identified by tags. Automatically moved to **Pre-Order Parking** or **Backorder Parking**. They do *not* enter the Brokering Queue until inventory arrives.

## **4. Parking Dictionary (State Definitions)**
*Use these definitions to determine where an order is sitting and why.*

| Parking Name | Purpose & AI Logic |
| :--- | :--- |
| **Brokering Queue** | **The "Waiting Room."** Contains `Approved` standard orders waiting for the next Brokering Run to assign them a location. |
| **Pre-Order Parking** | **The "Future Release" Queue.** Holds orders for items not yet released. They sit here until the "Promise Date" hits or stock arrives. *Action:* The "Auto Releasing" job moves them to the Brokering Queue when ready. |
| **Backorder Parking** | **The "Out of Stock" Queue.** Works exactly like Pre-Order Parking but for currently sold-out items awaiting replenishment. |
| **Unfillable Parking** | **The "No Stock Found" Bin.** If the Brokering Run cannot find inventory anywhere, the order moves here. <br> *Critical:* A timer starts. After 7 days (default), the order is **Auto-Canceled**. |
| **Unfillable Hold Parking** | **The "Safety Net."** A manual parking area. Retailers move orders here from "Unfillable Parking" to stop them from Auto-Canceling (e.g., if they know a Purchase Order is arriving soon). |
| **Rejected Queue** | **The "Try Again" Bin.** If a Store or WMS was assigned an order but rejected it (e.g., item damaged), the order moves here. A specific Brokering Run retries these orders to find a *new* location. |
| **General Ops Parking** | **The "Ignore" Bin.** Contains orders that need no action. Includes: <br> 1. Historical orders imported as `Completed`. <br> 2. Digital items (e.g., gift cards). <br> 3. Orders canceled *before* import. |
| **Reject Order Parking** | **The "Limbo" Bin.** Contains orders that were `Approved` and allocated, but then canceled by the customer *before* shipment. This parking ensures the warehouse/store is notified to stop processing. |

## **5. Routing Transitions & Outcomes**

### **Scenario: Allocation Success**
*   **Brokering Queue** $\rightarrow$ **Fulfillment Location (Store/Warehouse)**.
*   **Action:**
    *   **Store:** Associates pick/pack using the **Fulfillment App**.
    *   **Warehouse:** WMS processes the order.
*   **End State:** Status updates to `Completed` (Fulfilled).

### **Scenario: Allocation Failure (Rejection)**
*   **Fulfillment Location** $\rightarrow$ **Rejected Queue**.
*   **Logic:** The system treats this as a "soft fail." The order is re-entered into the routing logic to find a second-best location.
    *   *Note:* If a BOPIS order is rejected, it does **not** go to the Rejected Queue; it triggers a customer email for alternative options (Pickup elsewhere or Delivery).

### **Scenario: No Inventory Found**
*   **Brokering Queue** $\rightarrow$ **Unfillable Parking**.
*   **Next Step:**
    *   *If stock arrives:* Move to **Unfillable Hold** or wait for next run.
    *   *If time expires:* Status updates to `Canceled`.