# Experiencing Shopify Orders in OMS

The purpose of this guide is to **Experience OMS** and see how orders flow from Shopify to fulfillment.

---

## 1. Shopify Order Import
- A Shopify order is imported into OMS in [**MDM**](https://dev-oms.hotwax.io/commerce/control/ShopifyImportData?configId=CRT_SHOPIFY_ORDER) using **Import Order Jobs**.  
- After import, a **process job** runs which stores all this data in the OMS database.  
[Shopify Order Json](https://github.com/saastechacademy/foundation/blob/main/udm/intermediate/shopify-samples/orders-json/Regular%20Standard%20-%20content.json)

**Beginner Task**: Examine the JSON to understand what data OMS receives from Shopify: Order lines, quantities, customer details, and shipping data.  
**Advance Task**:

---

## 2. Viewing the Order in OMS
- After the Sales order is created in OMS, it can be viewed on the [**Sales Order page**](https://dev-oms.hotwax.io/commerce/control/FindOrder).  
**Intermediate Task**: Look at the order in OMS and think: “Where is this data stored in the database?”

---

## 3. Order Brokering
- The order is **brokered** to the facility where inventory is available using a **brokering job** that runs for approved orders every 15 minutes.
- For learning purposes, you can **broker the order manually** by releasing it to a specific facility from the **View Order page** (click the order to open it).

Task: Notice how OMS assigns the order to a facility and prepares it for fulfillment.

---

## 4. Fulfillment
- Once the order is brokered to a facility, it can be [**fulfilled from that facility**](https://docs.hotwax.co/documents/store-operations/orders/fulfillment/ship-orders).  
- Follow the pick, pack, and ship steps from the facility in OMS.

Task: [Expereince fullfilment](https://fulfillment-dev.hotwax.io/login).

---

****Takeaways****
- Focus on **experiencing the process**.
- Let curiosity arise:
  - “How does OMS know which item goes to which facility?”
  - “How is inventory reserved?”
  - “Where is all this data stored in the database?”
- Later, these questions will motivate learning **data modeling**.

Goal: Feel the OMS journey, understand the flow, and prepare to explore how Shopify data is transformed and stored in the OMS database.
