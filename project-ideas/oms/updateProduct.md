### update#Product
This would be the base api the uses entity rest method to create product and related base data in the database.
1. Parameters
    * Input Parameters
        * productJson (type=Map) (expect JSON block below)
    * Output Parameters
        * productOutput

```json
{
  "productId": "<productId>",
  "internalName": "<sku>",
  "productTypeId": "<productTypeId>",
  "productName": "<productName>",
  "detailImageUrl": "<detailImageUrl>",
  "weight": "<weight>",
  "shippingWeight": "<weight>",
  "weightUomId": "<weightUomId>",
  "isVirtual": "<Y/N>",
  "isVariant": "<Y/N>",
  "primaryCategoryId": "<primaryCategoryId>",
  "GoodIdentification": [
    {
      "goodIdentificationTypeId": "<goodIdentificationTypeId>",
      "idValue": "<idValue>",
      "fromDate": "<fromDate>"
    }
  ],
  "ProductFeatureAppl": [
    {
      "productFeatureId": "<productFeatureId>",
      "productFeatureApplTypeId": "<productFeatureApplTypeId>",
      "sequenceNum": "<sequenceNum>",
      "fromDate": "<fromDate>"
    }
  ]
}
```
