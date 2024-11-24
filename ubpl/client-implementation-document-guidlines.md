# Client Implementation Document Guidelines

## Overview and Objective

Implementation documents intend to consolidate all the minute details related to the HotWax Commerce OMS of a client. The document should cover all the critical points of implementation as well as the business scenario and value linked to it. An implementation document should begin with an introduction to the business model of the client, then define the value proposition of HotWax Commerce, followed by a detailed walkthrough of the lifecycle of each data object such as orders and inventory. There should also be a detailed breakdown of how the client is using flagship features of HotWax Commerce such as Store Pickup or Pre-orders.

In its entirety, an Implementation Document should allow the reader to understand the nuances of any clients omnichannel implementation as well as extrapolate how HotWax Commerce may be used in situations similar to the documented client.

**GPT Tone Prompt**  
I want the tone to be professional without using big words, the document itself should be very easy to read. It should also be concise without using metaphors and keep the writing very functional.

## Structure

The primary sections of an Implementation Document are an introduction to the business, value delivered by HotWax Commerce, omnichannel configurations, and the data flow architecture.

### Introduce the client

A client introduction includes a brief description of the client's business model, their retail domain, and facts about their operations scale.

1. Business Model: Include details about how their product is procured and the channels they sell on.  
2. Retail Domain: Add information about their product and their target market. Feel free to lift these details from reliable online sources with linked references.  
3. Revenue and team size: Add details about the scale of their operations, as well as any publicly available information regarding their annual revenue and team structure. Team structure is important to include to illustrate roles and responsibilities in respect to their omnichannel strategy.

### Why HotWax Commerce?

This section should clearly state the business challenges in relation to omnichannel objectives. Details related to prior omnichannel initiatives by the retailer and their varying degrees of success should be stated early on to help set the context of the retailer's standing when they decided to introduce HotWax Commerce to their technology stack. Once details about the challenges faced by the retailer in their omnichannel initiatives are established, every pain point should be reconciled by an offering by HotWax Commerce or a supplemental solution that was included as part of the implementation.

1. Establish key omnichannel objectives of the retailer  
2. Detail prior initiatives taken within the company and their shortcomings if any  
3. Reconcile how HotWax Commerce addressed each of the challenges faced by the retailer with a brief description of the solution used.

### Omnichannel Configurations

Dive into specific details regarding how each of the core HotWax Commerce offerings were used to deliver on the client’s needs. Each solution that was used, brokering and fulfillment, store pickup, pre-orders, or inventory management should be its own well defined sub section letting the reader dive into how exactly the retailer leveraged each of the solutions. Each section should include statistics when possible to help illustrate the benefits of the omnichannel configuration used by the retailer (ex. 25% pre-orders, 30% ship from store).

1. Brokering and fulfillment  
   1. What were the desired routing optimizations the retailer wanted to achieve in their allocation logic. Include key performance indicators like shipping from nearby fulfillment locations, reducing order splits or optimizing for specific product types.  
   2. Detail the exact capabilities of the routing engine which helped achieve the desired results and how.  
      1. Order prioritization  
      2. Inventory lookup criteria  
      3. Allocation rules  
   3. Add details about if and how the fulfillment suite was used in conjunction with the routing capabilities to speed up order fulfillment.  
      1. Store fulfillment  
         1. Onboarding  
            1. Trained store staff on online fulfillment for the first time  
               1. Challenges faced during staff training and approaches taken to streamline  
               2. Key app features that uniquely helped staff  
            2. Replaced an existing store fulfillment software  
               1. Shortcomings of outgoing solution and brief comparisons  
            3. Integrated custom apps with OMS APIs  
         2. Order Picking  
            1. Digital and or physical picking  
            2. Tracking commissions by picker  
         3. Integration with carrier  
            1. Rate Shopping  
            2. File based integration  
         4. Exception handling  
      2. Warehouse fulfillment  
         1. Solution of choice  
         2. Exception handling  
2. Store Pickup  
   1. Customer shopping experience  
      1. Identify key store inventory lookup and pickup features and experiences the retailer has leveraged that are provided by HotWax Commerce  
         1. Include details of the implementing party  
            1. HotWax  
            2. In house  
            3. Shopify Agency  
   2. Fulfillment  
      1. Repeat details similar to order fulfillment  
      2. Identify key features of HotWax BOPIS fulfillment that helped the retailer solve edge cases unique to them.  
3. Store Inventory Management  
   1. Describe which tools the retailer used to solve their inventory accuracy challenges  
   2. Receiving  
      1. Add details about the receiving process the retailer uses to ensure accuracy  
         1. Blind receiving  
         2. Scanner based receiving  
            1. Bluetooth  
            2. Device Camera  
         3. Handling for mis shipped items  
      2. List which objects specifically the retailer uses the receiving workflow for  
         1. Purchase orders  
         2. Transfer Orders  
         3. ASN  
         4. Returns  
   3. Cycle counting  
      1. Retailers that use Shopify POS usually aren’t able to do cycle counts, so add details about how this helps improve accuracy  
      2. Include details about other features in the workflow that helped retailers perform cycle counts more often and more accurately  
4. Pre-orders  
   1. If the retailer differentiates between backorders and pre-orders, describe their differentiation and how HotWax helps support that model  
   2. List all steps of the pre-order process that have been automated  
   3. Customer shopping experience  
      1. Provide examples and benefits of the pre-order experience delivered to the customers browsing the retailer’s website  
      2. Pre-order post purchase automations that help enhance the user experience should also be listed here which are not always features the customer interacts with on a daily basis.  
   4. Some retailers may sync POs from their ERP automatically and others may take a more manual approach. Document how they load their future inventory into the OMS and why that suits their business needs.  
5. Any other functionalities of HotWax Commerce that helped deliver a seamless omnichannel experience to the retailer are appended at the end of the solutions.

### Data flow architecture

Create a breakdown of how various data points flow through the retailer's technology stack when HotWax Commerce is introduced as an OMS. Each data point should have a full lifecycle that helps the reader understand the origin, mutations and processing, and the final destination. Elaborate details about integrations are not expected, so avoid detailing APIs, job names, or SFTP details, instead focus on the end result and where more detail is required, link to relevant integration or API documentation.

1. Products  
2. Inventory  
   1. Cycle count  
   2. Receiving in store  
3. Sales orders  
   1. Lifecycle details  
   2. Fulfillment  
      1. Warehouse  
      2. Ship from store  
      3. Pickup  
   3. Reporting  
4. Purchase orders  
   1. Pre-order life cycle  
   2. Receiving  
5. Transfer Orders  
   1. Life cycle details  
   2. Fulfillment  
   3. Receiving  
   4. Over and under receiving