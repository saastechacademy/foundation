# Shopify Order Import

This document explains the flow used to import Shopify orders into OMS. This workflow fetches orders from Shopify using GraphQL, 
enriches each order by fetching additional order-level details, and stores the resulting payloads into the Data Manager as JSON files.

## Architecture

Ingestion → Transformation & Mapping → Storage

1. Ingestion: Raw Shopify GraphQL responses are fetched and stored as JSON feeds.
2. Transformation & Mapping: Shopify order structures are normalized into an internal representation by transforming the raw data and mapping it to OMS domain entities.
3. Storage: Orders are persisted for downstream fulfillment and processing.

The solution leverages Moqui System Messages to store and propagate Shopify GraphQL query parameters, with scheduled Service Jobs driving
paginated GraphQL execution. The order responses are stored in Moqui Data Manager as JSON feeds, ensuring a clear separation between ingestion
and downstream order transformation.

## Order Import Flow

1. [getOrdersFromShopify](getOrdersFromShopify.md) will fetch orders from Shopify and upload the JSON response in Moqui Data Manager.
2. [createShopifyOrder](createShopifyOrder.md) is configured as the Data Manager import service responsible for transforming ingested Shopify order feeds into OMS-native order records. 

### Data Manager Config

```xml
<co.hotwax.datamanager.DataManagerConfig configId="SHOPIFY_ORDER_IMPORT" importServiceName="co.hotwax.shopify.order.ShopifyOrderServices.create#ShopifyOrder" description="Transform and create orders from Shopify GraphQL response in OMS"/>
```