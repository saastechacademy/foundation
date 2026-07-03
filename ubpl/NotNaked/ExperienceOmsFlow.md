# Experiencing Shopify Orders in OMS

The purpose of this guide is to **Experience OMS** and see how orders flow from Shopify to fulfillment.


### 1. Shopify Order Import
- As NotNaked uses Shopify as their e-commerce platform, orders from there are imported into OMS in [**MDM**](https://dev-oms.hotwax.io/commerce/control/ShopifyImportData?configId=CRT_SHOPIFY_ORDER) using **Import Order Jobs**.  
- After import, a **process job** runs which stores all this data in the OMS database.
  
**Beginner Task**:  

- Examine the [Shopify Order Json](https://github.com/saastechacademy/foundation/blob/main/udm/intermediate/shopify-samples/orders-json/Regular%20Standard%20-%20content.json) to understand what data OMS receives from Shopify: Order lines, quantities, customer details, and shipping data.   

**Intermediate Task**:  

  Answer the following question:  

    - How is the order data from Shopify stored in different entities?
    - How is the order linked to the customer who placed it?
    - How are products in the order identified, and at what quantity?
    - What are the taxes applied to the order?
    - Where does the order need to be delivered?
    - Which facility is responsible for fulfilling the order?

**Advanced Task**:  
Research the following:  

- Which services are triggered behind the **Import Orders** job.  
- How the order is indexed for the search capabilities on the **Sales Order** page.  
- How the order is approved in OMS.

---

## 2. Viewing the Order in OMS
- After the Sales order is created in OMS, it can be viewed on the [**Sales Order page**](https://dev-oms.hotwax.io/commerce/control/FindOrder).  
- Orders are imported in a **Created** state and are approved at regular intervals by the **Approve Sales Order** job.  
- Approved orders are ready for facility allocation to begin the fulfillment process.
---

## 3. Order Brokering
- The order is **brokered** according to [brokering rules](https://docs.hotwax.co/documents/learn-hotwax-oms#brokering) to the facility where inventory is available using a **brokering job** that runs for approved orders every 15 minutes.
- For learning purposes, you can **broker the order manually** by releasing it to a specific facility from the **View Order page** (click the order to open it).

Task: Notice how OMS assigns the order to a facility and prepares it for fulfillment.

---

## 4. Fulfillment
- Once the order is brokered to a facility, it can be [**fulfilled from that facility**](https://docs.hotwax.co/documents/store-operations/orders/fulfillment/ship-orders).  
- Follow the pick, pack, and ship steps from the facility in OMS.

Task: [Experience fulfillment](https://fulfillment-dev.hotwax.io/login).

---

## **Takeaways**
- Focus on **experiencing the process**.
- Let curiosity arise:
  - “How does OMS know which item goes to which facility?”
  - “How is inventory reserved?”
  - “Where is all this data stored in the database?”
- Later, these questions will motivate learning **data modeling**.

Goal: Feel the OMS journey, understand the flow, and prepare to explore how Shopify data is transformed and stored in the OMS database.
