# OMS/Shopify Fulfillment Sync Redesign

## Problem Statement
Current implmentation to generate a fulfilled order items feed is a generic implementation to supply order fulfillment details to any number of external systems like ERP, WMS, Shopify, etc.
It requires further complex transformations involving database reads via NiFi to generate a fulfilled order items feed consumable by Shopify. It becomes a huge overhead when we process large number of order fulfillment across significant number of stores and warehouses.
It further adds to the latency in overall processing time.  
The external references for Shopify fulfillments also needs to be synced back to OMS which again is prcessed via Nifi even though it's a simple database update in a single entity.  
Additionally, since it's a generic implementation a complex database view with lots of required and optional input conditions is used to generate the feed with heavy order fulfillment objects containing a lot of details unnecessary for Shopify.  

A simplified OMS/Shopify fulfillment sync flow should be implemented by eliminating NiFi transformation overhead and producing only necessary fulfillment data for Shopify.

## TO-BE Design

