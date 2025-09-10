# Experiencing Shopify Orders in OMS

The purpose of this guide is to **Experience OMS** and see how orders flow from Shopify to fulfillment.


### 1. Shopify Order Import
- As NotNaked uses Shopify as there e-com, order from there are imported into OMS in [**MDM**](https://dev-oms.hotwax.io/commerce/control/ShopifyImportData?configId=CRT_SHOPIFY_ORDER) using **Import Order Jobs**.  
- After import, a **process job** runs which stores all this data in the OMS database.
  
**Beginner Task**:  

- Examine the [Shopify Order Json](https://github.com/saastechacademy/foundation/blob/main/udm/intermediate/shopify-samples/orders-json/Regular%20Standard%20-%20content.json) to understand what data OMS receives from Shopify: Order lines, quantities, customer details, and shipping data.   

**Intermediate Task**:  

  Answer the following question:  

    - How the order's data from Shofiy is stored in different entities?
    - How is the order linked to the customer who placed it?
    - What are the products in the order and at what quantity?
    - What are the taxes imposed on the order?
    - Where the order needs to be delivered?
    - From where do the order needs to be fulfilled?

**Advance Task**:  
Research on

    - Which services are triggered behind the import orders job.  
    - How is order indexed for the seach capabilities of sales order page.
    - How is order approved in OMS.

---

## 2. Viewing the Order in OMS
- After the Sales order is created in OMS, it can be viewed on the [**Sales Order page**](https://dev-oms.hotwax.io/commerce/control/FindOrder).  
- Order is imported in created state and is approved at a regular interval by approve sales order job.
- Approved orders are ready for facility allocation to get fullfiled.
---

## 3. Order Brokering
- The order is **brokered** according to [brokering rules](https://docs.hotwax.co/documents/learn-hotwax-oms#brokering) to the facility where inventory is available using a **brokering job** that runs for approved orders every 15 minutes.
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
