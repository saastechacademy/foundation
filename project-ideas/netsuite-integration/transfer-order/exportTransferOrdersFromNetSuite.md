# Export Transfer Orders from NetSuite
To integrate NetSuite Transfer orders with HotWax, we begin by fetching the transfer order data from NetSuite using a Map/Reduce Script.
Map/reduce scripts can be run on demand or at predefined intervals on a recurring basis however they are designed to handle large volumes of data. 

## Flow
1. The netsuite-integration component will export the newly created Transfer Orders and produce a periodic JSON feed using the Map/Reduce script.
2. The 3 different scripts are scheduled to run to export Transfer Orders for Wh to Store, Store to Store, and Store to Wh.
3. Scripts
   1. HC_MR_ExportedWhtoStoreTOJson_v2.js
   2. HC_MR_ExportedStoretoStoreTOJson_v2
   3. HC_MR_ExportedStoretoWhTOJson_v2.js
4. In the above 3 scripts, Saved Search is used with specific criteria to export the different transfer orders and produce a JSON feed file and keeps it on SFTP.
5. Saved Search
   1. customsearch_hc_exp_wh_to_store_to_v2
      1. Type: Transfer Order
      2. Status: Pending Receipt or Pending Receipt/Partially Fulfilled
      3. Location Type (location): is Warehouse
      4. Location Type (to location): is Store
      5. Formula (Text): is not empty {transferorderitemline}
      6. Shipping Zip: is not empty
      7. HC order exported (custom field): is false
   2. customsearch_hc_exp_store_to_store_to_v2
      1. Type: Transfer Order
      2. Status: Pending Fulfillment
      3. Location Type (location): is Store
      4. Location Type (to location): is Store
      5. Formula (Text): is not empty {transferorderitemline}
      6. Shipping Zip: is not empty
      7. HC order exported (custom field): is false
   3. customsearch_hc_exp_store_to_wh_to_v2
      1. Type: Transfer Order 
      2. Status: Pending Fulfillment 
      3. Location Type (location): is Store 
      4. Location Type (to location): is Store 
      5. Formula (Text): is not empty {transferorderitemline} 
      6. Shipping Zip: is not empty 
      7. HC order exported (custom field): is false
6. SFTP location
   1. /home/${sftp-home}/netsuite/transferorderv2/import/transfer-order
   2. /home/${sftp-home}/netsuite/transferorderv2/import/transfer-order/archive
7. Sample File Names
   1. ExportWhToStoreTransferOrder-2025-08-05-06-39-00.json
   2. ExportStoretoStoreTransferOrder-2025-07-01-07-08-09.json
   3. ExportStoretoWhTransferOrder-2025-06-26-13-59-10.json