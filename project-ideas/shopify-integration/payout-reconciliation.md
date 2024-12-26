# Reconcile Payments from ShopifyPayments

When using Shopify Payments, retailers would like to reconcile that payments are arriving in their bank account as stated by Shopify. To do this, they need a system to trace payments captured against an order all the way to their bank account.

Between a transaction being created against an order and money being transferred into the retailer's bank account, Shopify also deducts its processing fees. Retailers need a way to verify that all transactions are being settled and that the correct adjustments are being applied to their payouts.

## Introduction to Shopify financial vocabulary

**Order Transaction:** An order transaction is the customer facing transaction. If a customer places an order for $100 with a retailer, the customer will receive a charge of $100 on their credit card. This transaction is linked directly with the order they placed. If the customer chose to pay with multiple payment methods, there will be a corresponding transaction with each payment method.

**Payout:** A payout represents the actual act of Shopify transferring money to the retailers bank account. A payout does not include individual order transaction level details, instead it is the total amount of money due from Shopify to the retailer since the last payout occurred.

**Balance Transaction:** A balance transaction represents the relationship between an order transaction and a payout. One balance transaction will always be linked to one order transaction and one payout. Balance transactions are the primary source of data to use when reconciling payments.


## Saving Shopify financial details in SQL tables

The first step in creating a reconciliation system for Shopify payouts is saving all three of Shopify’s payment related objects into SQL tables, which in turn allows reconciliation through SQL reports.

**Order transaction table fields:**

1. Transaction Id  
2. Status  
3. Type  
4. Amount  
5. Parent Id  
6. Order Id  
7. Created time stamp  

**Balance Transaction table fields:**

1. Balance transaction Id  
2. Order transaction Id  
3. Order Id  
4. Payout Id  
5. Amount  
6. Net  
7. Fee 

**Payout table fields:**

1. Payout Id  
2. Bank account Id  
3. Net  
4. Currency  
5. Status  
6. <All fields in summary 1:1>  
7. Transaction type

Additional data from Shopify’s API spec can be stored if found necessary for reporting, but the listed fields are sufficient for reconciliation.

## Bank transactions
To reconcile payouts against a bank account, it is also necessary to integrate with banks to automatically ingest payout postings. If an automated integration is not possible, the same data must be uploaded manually. However the data is submitted, it will be stored in a dedicated bank transactions table. Records from this table will be reconciled against the Shopify Payouts table.

**Bank transactions:**

1. Transaction Id  
2. External Reference Id  
3. Source account Id  
4. Transaction Type  
5. Amount  
6. Date time

Reconciliation of payouts should be executed in two steps, first reconciling order transactions to payouts. The second is reconciling payouts to bank transactions. Once both are reconciled, an order can easily and reliably be accounted for in the retailer's bank account.