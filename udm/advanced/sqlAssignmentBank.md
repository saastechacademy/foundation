# SQL Assignment Bank

These are SQL prompts that can be used as assingmnets or evaluation questions for someone learning SQL. Answering these will require a deep understanding of the OFBiz datamodel (UDM?) as well as how business processes connect to that model because every prompt will not specify which tables need to be quiered.

**Non Return Refunds**

Get a list of all refund payments on an order that do not originate from a return for that order.

The expected fields in the result are:
1. Order Id
2. Payment internal Id
3. Payment manual reference
4. Payment parent reference
5. Refund amount from payment pref

**Digital Order Items**

Fetch a list of completed order items that were not POS Completed sales but also did not need to be shipped to the customer.

Fields to include in results:
1. Order Id
2. Item Seq Id
3. Item Attr (select any)
4. Item total

**Duplicate Orders**

Fetch a list of all orders imported from Shopify that are duplicates. There can be more than 1 duplicate.

Fields to include in results:
1. Order Name
2. Order Id
3. Duplicate of Order Id