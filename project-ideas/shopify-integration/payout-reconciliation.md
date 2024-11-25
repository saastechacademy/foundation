# Reconcile Payments from ShopifyPayments to Bank account.

ShopifyPayments, deposits money in the merchant bank account in a batch, also called the settlement batch, Shopify calls them ShopifyPaymentsPayout.
The Payout can be daily, weekly or monthly.
The reconciliation process will reconcile all the [Transactions](https://shopify.dev/docs/api/admin-rest/2024-10/resources/transaction) on Orders with the list [ShopifyPaymentsBalanceTransactions](https://shopify.dev/docs/api/admin-graphql/2024-07/objects/ShopifyPaymentsBalanceTransaction) included in [ShopifyPaymentsPayout](https://shopify.dev/docs/api/admin-graphql/2024-07/objects/ShopifyPaymentsPayout).

# Mapping Shopify entities with HC data model entities
The Financial details of each Payout is tracked using [Payment, PaymentGroup, FinAccountTrans](payment-group.md). 

The [ShopifyPaymentsAccount](https://shopify.dev/docs/api/admin-graphql/2024-07/objects/ShopifyPaymentsAccount) is setup as Financial Account in HotWax. The Payouts summary is managed in FinAccountTrans and ShopifyPaymentsBalanceTransaction are tracked in Payments.   

## ShopifyPaymentsPayout with PaymentGroup

The ShopifyPaymentsPayout, is a batch of order transactions settled, In HC it corresponds to [PaymentGroup](payment-group.md) entity model. Added following fields to the PaymentGroup entity.
Custom Fields Added to PaymentGroup:

*   For each ShopifyPaymentsPayout create a PaymentGroup of type BATCH.
*   ShopifyPaymentsPayout.net is saved in PaymentGroup.amount field.

```xml
<field name="amount" type="currency-amount"/> for tracking ShopifyPaymentsPayout.net .
<field name="statusId" type="id"/> for indicating the status of the payment group (e.g., PAID).
<!--new type -->
<PaymentGroupType description="Payouts represent the movement of money between a merchant's Shopify Payments balance and their bank account." hasTable="N" paymentGroupTypeId="SHOPIFY_PAY_PAYOUT"/>

 <!-- StatusType for PaymentGroup -->
<StatusType statusTypeId="PAYMENT_GROUP_STATUS" description="PaymentGroup Lifecycle Status"/>
<!-- StatusItems for PaymentGroup Lifecycle -->
<StatusItem statusId="CANCELED" statusTypeId="PAYMENT_GROUP_STATUS" description="The payout has been canceled by Shopify." sequenceId="10"/>
<StatusItem statusId="FAILED" statusTypeId="PAYMENT_GROUP_STATUS" description="The payout has been declined by the bank." sequenceId="20"/>
<StatusItem statusId="IN_TRANSIT" statusTypeId="PAYMENT_GROUP_STATUS" description="The payout has been submitted to the bank." sequenceId="30"/>
<StatusItem statusId="PAID" statusTypeId="PAYMENT_GROUP_STATUS" description="The payout has been successfully deposited into the bank." sequenceId="40"/>
<StatusItem statusId="SCHEDULED" statusTypeId="PAYMENT_GROUP_STATUS" description="The payout has been created and had transactions assigned to it, but it has not yet been submitted to the bank." sequenceId="50"/>

```

## ShopifyPaymentsPayoutSummary with FinAccontTrans

The ShopifyPaymentsPayout.net amount paid to merchant bank account is recorded in FinAccontTrans of type 'CHARGES_NET'. 
NOTE: The ShopifyPaymentsPayout.net is saved in PaymentGroup and also in FinAccontTrans for symmetry purposes.

The ShopifyPaymentsPayout has ShopifyPaymentsPayoutSummary, it has totals/summary of various types of payments balanced in the Payout(PaymentGroup). Summary of each transaction type is recorded as entry in FinAccontTrans entity.
Use following FinAccountTransType to store breakdown of the total fees and gross of each of the different types of transactions associated with the payout.

```xml
<entity-facade-xml>
    <FinAccountTransType finAccountTransTypeId="ADJUSTMENTS_FEE" description="Total fees for all adjustments including disputes."/>
    <FinAccountTransType finAccountTransTypeId="ADJUSTMENTS_GROSS" description="Total gross amount for all adjustments including disputes."/>
    <FinAccountTransType finAccountTransTypeId="CHARGES_GROSS" description="Total gross amount for all charges."/>
    <FinAccountTransType finAccountTransTypeId="CHARGES_FEE" description="Total fees for all charges."/>
    <FinAccountTransType finAccountTransTypeId="CHARGES_NET" description="The total amount of the payout."/>
    <FinAccountTransType finAccountTransTypeId="REFUNDS_FEE" description="Total fees for all refunds."/>
    <FinAccountTransType finAccountTransTypeId="REFUNDS_FEE_GROSS" description="Total gross amount for all refunds."/>
    <FinAccountTransType finAccountTransTypeId="RESERVED_FUNDS_FEE" description="Total fees for all reserved funds."/>
    <FinAccountTransType finAccountTransTypeId="RESERVED_FUNDS_GROSS" description="Total gross amount for all reserved funds."/>
    <FinAccountTransType finAccountTransTypeId="RETRIED_PAYOUTS_FEE" description="Total fees for all retried payouts."/>
    <FinAccountTransType finAccountTransTypeId="RETRIED_PAYOUTS_GROSS" description="Total gross amount for all retried payouts."/>
</entity-facade-xml>

```
## ShopifyPaymentsBalanceTransaction with Payment
The ShopifyPaymentsPayout settles list of Order Transactions, represented by ShopifyPaymentsBalanceTransaction. Each ShopifyPaymentsPayout has zero or more ShopifyPaymentsBalanceTransactions. 

For each Each ShopifyPaymentsBalanceTransaction, create Payment records.  

**IMP: For each ShopifyPaymentsBalanceTransaction in the ShopifyPaymentsPayout, create**
*   Payment record of type CHARGES_GROSS for amount, ShopifyPaymentsBalanceTransaction.amount 
*   Payment of type CHARGES_FEE to record fee, ShopifyPaymentsBalanceTransaction.fee 
*   Payment of type CHARGES_NET to record net, ShopifyPaymentsBalanceTransaction.net


### PaymentTypes

Question: How do we map PaymentTypes with FinAccountTransTypes?
Why: The Payment total of each paymentTypes should match with the FinAccountTransType entry for a given Payout.

```xml
    <PaymentType description="Disbursement" hasTable="N"  paymentTypeId="DISBURSEMENT"/>
    <PaymentType description="Customer Refund" hasTable="N" parentTypeId="DISBURSEMENT" paymentTypeId="CUSTOMER_REFUND"/> <!-- a refund TO the customer -->

    <PaymentType description="Receipt" hasTable="N" paymentTypeId="RECEIPT"/>
    <PaymentType description="Customer Payment" hasTable="N" parentTypeId="RECEIPT" paymentTypeId="CUSTOMER_PAYMENT"/> <!-- a payment FROM the customer -->

```
*ShopifyPaymentsBalanceTransaction.Id* in Payment.paymentRefNum


**Each ShopifyPaymentsBalanceTransaction has reference of Order Transaction, Save map it to OrderPaymentPreference and save it on Payment.**
*   ShopifyPaymentsBalanceTransaction.sourceOrderTransactionId
*   ShopifyPaymentsBalanceTransaction.associatedOrder

Create PaymentGroupMember record for each Payments created. The PaymentGroupMember is used to track all the Payments in one Payout. 


## User Interface

**Find/List PaymentGroup**
**View PaymentGroup**
Take ideas from https://www.youtube.com/watch?v=lHPX4LzVFww&list=PLhS95RehmSppmtv1THznwseZIO8h0JOXu&index=12

**Find/List Payments**
The List view elements should show one ShopifyPaymentsBalanceTransaction at a time. The List item should have summary and the detail view. The detail view can be collapsed by default. Shopify Video linked above has similar thing. 

