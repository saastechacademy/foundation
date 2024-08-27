# Shopify Integration.

Data Model of [Shopify Config](/udm/advanced/ShopifyConfig.md) entities. 


* Call services for processing data downloaded from Shopify must need ShopifyConfigId and related ProdutStoreId. Consider making it part of request preprossing, before the real service is called. 

* ShopifyServiceConfig are good candidates for service specific preprocessing.

   ```java
   String skipOrdersTags = EntityUtilProperties.getPropertyValue("ShopifyServiceConfig", productStoreId + ".skip.order.import.tags", delegator);
   ```

