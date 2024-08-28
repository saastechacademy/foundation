# Shopify Integration.

Data Model of [Shopify Config](/udm/advanced/ShopifyConfig.md) entities. 


* Call services for processing data downloaded from Shopify must need ShopifyConfigId and related ProdutStoreId. Consider making it part of request preprossing, before the real service is called. 

* ShopifyServiceConfig are good candidates for service specific preprocessing.

   ```java
   String skipOrdersTags = EntityUtilProperties.getPropertyValue("ShopifyServiceConfig", productStoreId + ".skip.order.import.tags", delegator);
   ```

## Architecture

Transformation --> Data Mapping --> Store

1.  Transform data from Shopfiy resource schema to HotWax Commerce resource schema
2.  Process data for HotWax type mapping 

**Task 1:** 
Write JOLT transformation to map Shopify order json to HotWax Order JSON. 

