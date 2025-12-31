# Shopify Orders Query Filters

This document provides a comprehensive, validated list of all allowed filters for the Shopify Admin GraphQL API's `orders` query. The filters are grouped semantically for easy reference and are based on the latest official Shopify documentation.

The filters use Shopify's search syntax, allowing powerful querying with comparators like `:`, `>`, `<`, etc. Each filter includes its type, description, acceptable values (if applicable), and examples.

## Filters Reference

```json
{
  "filters": [
    {
      "name": "id",
      "type": "id",
      "description": "Filters orders by their unique Shopify ID.",
      "acceptable_values": null,
      "examples": ["gid://shopify/Order/123456789"],
      "category": "Identity & metadata"
    },
    {
      "name": "name",
      "type": "string",
      "description": "Filters orders by their order name or number.",
      "acceptable_values": null,
      "examples": ["#1001", "name:#1001"],
      "category": "Identity & metadata"
    },
    {
      "name": "confirmation_number",
      "type": "string",
      "description": "Filters orders by their confirmation number.",
      "acceptable_values": null,
      "examples": ["123456789"],
      "category": "Identity & metadata"
    },
    {
      "name": "status",
      "type": "string",
      "description": "Filters orders by their overall status.",
      "acceptable_values": ["open", "closed", "cancelled"],
      "examples": ["status:open", "status:cancelled"],
      "category": "Identity & metadata"
    },
    {
      "name": "created_at",
      "type": "time",
      "description": "Filters orders by their creation date and time.",
      "acceptable_values": null,
      "examples": ["created_at:>=2023-01-01", "created_at:<2023-12-31"],
      "category": "Time-based"
    },
    {
      "name": "processed_at",
      "type": "time",
      "description": "Filters orders by their processing date and time.",
      "acceptable_values": null,
      "examples": ["processed_at:>2023-01-01T00:00:00Z"],
      "category": "Time-based"
    },
    {
      "name": "updated_at",
      "type": "time",
      "description": "Filters orders by their last update date and time.",
      "acceptable_values": null,
      "examples": ["updated_at:>=2023-06-01"],
      "category": "Time-based"
    },
    {
      "name": "cancelled_at",
      "type": "time",
      "description": "Filters orders by their cancellation date and time.",
      "acceptable_values": null,
      "examples": ["cancelled_at:*", "cancelled_at:<2023-01-01"],
      "category": "Time-based"
    },
    {
      "name": "closed_at",
      "type": "time",
      "description": "Filters orders by their closure date and time.",
      "acceptable_values": null,
      "examples": ["closed_at:>=2023-01-01"],
      "category": "Time-based"
    },
    {
      "name": "current_total_price",
      "type": "float",
      "description": "Filters orders by their current total price.",
      "acceptable_values": null,
      "examples": ["current_total_price:>100.00", "current_total_price:<=500.00"],
      "category": "Financial & payment"
    },
    {
      "name": "current_subtotal_price",
      "type": "float",
      "description": "Filters orders by their current subtotal price.",
      "acceptable_values": null,
      "examples": ["current_subtotal_price:>=50.00"],
      "category": "Financial & payment"
    },
    {
      "name": "current_total_tax",
      "type": "float",
      "description": "Filters orders by their current total tax amount.",
      "acceptable_values": null,
      "examples": ["current_total_tax:>10.00"],
      "category": "Financial & payment"
    },
    {
      "name": "current_total_discounts",
      "type": "float",
      "description": "Filters orders by their current total discounts.",
      "acceptable_values": null,
      "examples": ["current_total_discounts:>0.00"],
      "category": "Financial & payment"
    },
    {
      "name": "financial_status",
      "type": "string",
      "description": "Filters orders by their financial status.",
      "acceptable_values": ["pending", "authorized", "partially_paid", "paid", "partially_refunded", "refunded", "voided"],
      "examples": ["financial_status:paid", "financial_status:refunded"],
      "category": "Financial & payment"
    },
    {
      "name": "chargeback_status",
      "type": "string",
      "description": "Filters orders by their chargeback status.",
      "acceptable_values": ["accepted", "disputed", "lost", "needs_response", "under_review", "won"],
      "examples": ["chargeback_status:disputed"],
      "category": "Financial & payment"
    },
    {
      "name": "fraud_protection_level",
      "type": "string",
      "description": "Filters orders by their fraud protection level.",
      "acceptable_values": ["low", "medium", "high"],
      "examples": ["fraud_protection_level:high"],
      "category": "Financial & payment"
    },
    {
      "name": "credit_card_last4",
      "type": "string",
      "description": "Filters orders by the last four digits of the credit card used.",
      "acceptable_values": null,
      "examples": ["credit_card_last4:1234"],
      "category": "Financial & payment"
    },
    {
      "name": "gateway",
      "type": "string",
      "description": "Filters orders by the payment gateway used.",
      "acceptable_values": null,
      "examples": ["gateway:shopify_payments"],
      "category": "Financial & payment"
    },
    {
      "name": "payment_id",
      "type": "string",
      "description": "Filters orders by their payment ID.",
      "acceptable_values": null,
      "examples": ["payment_id:123456789"],
      "category": "Financial & payment"
    },
    {
      "name": "payment_provider_id",
      "type": "string",
      "description": "Filters orders by their payment provider ID.",
      "acceptable_values": null,
      "examples": ["payment_provider_id:123"],
      "category": "Financial & payment"
    },
    {
      "name": "email",
      "type": "string",
      "description": "Filters orders by the customer's email address.",
      "acceptable_values": null,
      "examples": ["email:customer@example.com"],
      "category": "Customer & contact"
    },
    {
      "name": "customer_id",
      "type": "id",
      "description": "Filters orders by the customer's unique ID.",
      "acceptable_values": null,
      "examples": ["customer_id:123456789"],
      "category": "Customer & contact"
    },
    {
      "name": "cart_token",
      "type": "string",
      "description": "Filters orders by their cart token.",
      "acceptable_values": null,
      "examples": ["cart_token:abc123def456"],
      "category": "Customer & contact"
    },
    {
      "name": "checkout_token",
      "type": "string",
      "description": "Filters orders by their checkout token.",
      "acceptable_values": null,
      "examples": ["checkout_token:xyz789"],
      "category": "Customer & contact"
    },
    {
      "name": "fulfillment_status",
      "type": "string",
      "description": "Filters orders by their fulfillment status.",
      "acceptable_values": ["unfulfilled", "partial", "fulfilled", "restocked"],
      "examples": ["fulfillment_status:fulfilled", "fulfillment_status:unfulfilled"],
      "category": "Fulfillment & shipping"
    },
    {
      "name": "fulfillment_location_id",
      "type": "id",
      "description": "Filters orders by the fulfillment location ID.",
      "acceptable_values": null,
      "examples": ["fulfillment_location_id:123456789"],
      "category": "Fulfillment & shipping"
    },
    {
      "name": "delivery_method",
      "type": "string",
      "description": "Filters orders by their delivery method.",
      "acceptable_values": null,
      "examples": ["delivery_method:standard"],
      "category": "Fulfillment & shipping"
    },
    {
      "name": "total_weight",
      "type": "float",
      "description": "Filters orders by their total weight.",
      "acceptable_values": null,
      "examples": ["total_weight:>1000"],
      "category": "Fulfillment & shipping"
    },
    {
      "name": "channel",
      "type": "string",
      "description": "Filters orders by the sales channel.",
      "acceptable_values": null,
      "examples": ["channel:online_store"],
      "category": "Location & channel"
    },
    {
      "name": "channel_id",
      "type": "id",
      "description": "Filters orders by the channel ID.",
      "acceptable_values": null,
      "examples": ["channel_id:123456789"],
      "category": "Location & channel"
    },
    {
      "name": "location_id",
      "type": "id",
      "description": "Filters orders by the location ID.",
      "acceptable_values": null,
      "examples": ["location_id:123456789"],
      "category": "Location & channel"
    },
    {
      "name": "reference_location_id",
      "type": "id",
      "description": "Filters orders by the reference location ID.",
      "acceptable_values": null,
      "examples": ["reference_location_id:123456789"],
      "category": "Location & channel"
    },
    {
      "name": "sales_channel",
      "type": "string",
      "description": "Filters orders by the sales channel.",
      "acceptable_values": null,
      "examples": ["sales_channel:online_store"],
      "category": "Location & channel"
    },
    {
      "name": "source_name",
      "type": "string",
      "description": "Filters orders by the source name.",
      "acceptable_values": null,
      "examples": ["source_name:web"],
      "category": "Location & channel"
    },
    {
      "name": "source_identifier",
      "type": "string",
      "description": "Filters orders by the source identifier.",
      "acceptable_values": null,
      "examples": ["source_identifier:123456789"],
      "category": "Location & channel"
    },
    {
      "name": "risk_level",
      "type": "string",
      "description": "Filters orders by their risk level.",
      "acceptable_values": ["low", "medium", "high"],
      "examples": ["risk_level:high"],
      "category": "Risk & returns"
    },
    {
      "name": "return_status",
      "type": "string",
      "description": "Filters orders by their return status.",
      "acceptable_values": ["pending", "received", "authorized", "unauthorized", "refunded"],
      "examples": ["return_status:received"],
      "category": "Risk & returns"
    },
    {
      "name": "tag",
      "type": "string",
      "description": "Filters orders that have a specific tag.",
      "acceptable_values": null,
      "examples": ["tag:vip"],
      "category": "Tags & metafields"
    },
    {
      "name": "tag_not",
      "type": "string",
      "description": "Filters orders that do not have a specific tag.",
      "acceptable_values": null,
      "examples": ["tag_not:cancelled"],
      "category": "Tags & metafields"
    },
    {
      "name": "metafields.{namespace}.{key}",
      "type": "mixed",
      "description": "Filters orders by metafield values using namespace and key.",
      "acceptable_values": null,
      "examples": ["metafields.custom.order_type:wholesale"],
      "category": "Tags & metafields"
    },
    {
      "name": "discount_code",
      "type": "string",
      "description": "Filters orders by discount code used.",
      "acceptable_values": null,
      "examples": ["discount_code:SAVE10"],
      "category": "Miscellaneous"
    },
    {
      "name": "po_number",
      "type": "string",
      "description": "Filters orders by purchase order number.",
      "acceptable_values": null,
      "examples": ["po_number:PO12345"],
      "category": "Miscellaneous"
    },
    {
      "name": "subtotal_line_items_quantity",
      "type": "float",
      "description": "Filters orders by the subtotal quantity of line items.",
      "acceptable_values": null,
      "examples": ["subtotal_line_items_quantity:>5"],
      "category": "Miscellaneous"
    },
    {
      "name": "test",
      "type": "boolean",
      "description": "Filters test orders.",
      "acceptable_values": [true, false],
      "examples": ["test:true"],
      "category": "Miscellaneous"
    },
    {
      "name": "sku",
      "type": "string",
      "description": "Filters orders containing a specific SKU.",
      "acceptable_values": null,
      "examples": ["sku:ABC123"],
      "category": "Miscellaneous"
    },
    {
      "name": "variant_id",
      "type": "id",
      "description": "Filters orders containing a specific variant ID.",
      "acceptable_values": null,
      "examples": ["variant_id:123456789"],
      "category": "Miscellaneous"
    },
    {
      "name": "product_id",
      "type": "id",
      "description": "Filters orders containing a specific product ID.",
      "acceptable_values": null,
      "examples": ["product_id:123456789"],
      "category": "Miscellaneous"
    }
  ]
}
```