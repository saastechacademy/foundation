## Mapping of Shopify REST Order Fields to OMS & Corresponding GraphQL Fields

This table explains **which Shopify REST fields are used in the `createShopifyOrder` service**,  
**where each field is stored in the OMS**,  
and the **corresponding Shopify GraphQL field** used during order ingestion.

| Rest Field | OMS Field | GraphQL Field |
|--------------|-----------|----------------|
| id | OrderHeader.externalId / OrderIdentification.idValue (SHOPIFY_ORDER_ID) | id, legacyResourceId |
| order_number | OrderIdentification.idValue (SHOPIFY_ORD_NO) | number |
| name | OrderHeader.orderName / OrderIdentification.idValue (SHOPIFY_ORDER_NAME) | name |
| tags | OrderInternalNotes.note / OrderHeaderNote.NoteData.noteInfo | tags |
| note | CommunicationEvent.content | note |
| note_attributes | OrderAttribute | customAttributes { key, value } |
| created_at | OrderHeader.orderDate | createdAt |
| cancelled_at | Used to cancel order | cancelledAt |
| closed_at | Used to complete order | closedAt |
| total_price | OrderHeader.grandTotal | totalPriceSet.shopMoney.amount |
| currency | OrderHeader.currencyUom | currencyCode |
| presentment_currency | OrderHeader.presentmentCurrencyUom | presentmentCurrencyCode |
| total_tip_received | OrderAdjustment (DONATION_ADJUSTMENT) | totalTipReceivedSet.shopMoney.amount |
| source_name | OrderHeader.salesChannelEnumId (via ShopifyShopTypeMapping) | sourceName |
| shipping_address.* | Ship-to address fields | shippingAddress { ... } |
| billing_address.* | Customer billing address (if SAVE_BILL_TO_INF=Y) | billingAddress { ... } |
| phone | ShipToPhone / order contact number | phone |
| email / contact_email | ContactMech.infoString / OrderContactMech | email |
| fulfillment_status | Used for mixed POS detection | displayFulfillmentStatus |
| location_id | OrderItemShipGroup.facilityId | retailLocation.id |
| customer.* | Customer entity fields | customer { legacyResourceId id firstName lastName } |
| user_id | OrderAttribute (Shopify User Id) | staffMember.Id |
| order_status_url | ElectronicText.textData (OrderContent) | statusPageUrl |
| customer_locale | OrderHeader.localeString | customerLocale |
| shipping_lines | OrderAdjustment | shippingLines { title originalPriceSet taxLines discountAllocations } |
| discount_applications | — (can derive from lineItems) | discountApplications |
| discount_codes | — | discountCodes |
| line_items.id | — | lineItems.node.id |
| line_items.quantity | — | lineItems.quantity |
| line_items.price | — | lineItems.originalUnitPriceSet.shopMoney.amount |
| line_items.properties | Custom attributes | lineItems.customAttributes { key, value } |
| line_items.title / name | — | title / name |
| line_items.variant_id | — | variant.legacyResourceId |
| line_items.gift_card | isGiftCard | lineItems.isGiftCard |
| line_items.discount_allocations | OrderAdjustment | lineItems.discountAllocations { allocatedAmountSet } |
| line_items.tax_lines | — | taxLines { title rate priceSet.shopMoney.amount } |
| fulfillable_quantity | — | lineItems.unfulfilledQuantity / lineItems.nonFulfillableQuantity |
| fulfillments.status | — | fulfillments.status |
| fulfillments.location_id | — | fulfillments.location.legacyResourceId |
| fulfillments.tracking_number | — | fulfillments.trackingInfo.number |
| fulfillments.tracking_company | — | fulfillments.trackingInfo.company |
| refund_line_items.quantity | _ | refunds.refundLineItems.lineItem.quantity |
| refund_line_items.restock_type | _ | refunds.refundLineItems.restockType |
| transactions.id | opp.manualRefNum | transactions.id |
| transactions.parent_id | opp.parentRefNum | transactions.parentTransaction.id |
| transactions.amount | opp.maxAmount | transactions.amountSet.presentmentMoney.amount |
| transactions.currency | opp.presentmentCurrencyUom | transactions.amountSet.presentmentMoney.currencyCode |
| transactions.gateway | Payment method logic | transactions.gateway |
| transactions.payment_details | Payment method logic | transactions.paymentDetails { company } |
| transactions.status | opp.statusId | transactions.status |
| transactions.receipt | receiptJson (FX rates) | transactions.receiptJson |
| transactions.kind | kind | transactions.kind |
