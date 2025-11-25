# NetSuite Transfer Order Sync Design

Transfer orders are initiated in the NetSuite ERP system, facilitating the movement of inventory from warehouses to stores, between stores, or stores to warehouses.

The newly created transfer orders in NetSuite needs to be synced timely to OMS. This design document is specific to syncing newly created Transfer orders.   
Following would be the flow to sync TOs,
1. **netsuite-integration** would produce a periodic json feed of newly created transfer orders.
2. **mantle-netsuite-connector** would consume this feed and transform it to produce OMS orders json feed.
3. **oms** would consume the transformed order json feed and store orders in OMS database via order API.

## NetSuite Integration
1. Inventory planners create transfer orders in NetSuite, specifying the source location as the designated store and the destination location as the warehouse.
2. The JSON Feed files are created by [exportTransferOrdersFromNetSuite](exportTransferOrdersFromNetSuite.md).
3. These transfer orders are synchronized to HotWax Commerce in the default Created status.

## Mantle NetSuite Connector
A service will periodically poll the SFTP location for the NetSuite Transfer Order JSON feed files, consume the feed and transform to generated OMSTransferOrderFeed.
Following are the implementation details,
1. Service Job to Poll Transfer Orders Feed from SFTP location for the files kept by NetSuite export script
   1. poll_SystemMessageFileSftp_TransferOrder 
      1. Parameters 
         1. systemMessageTypeId = ImportTransferOrderFeed
         2. systemMessageRemoteId

2. System Message Types
   1. ImportTransferOrderFeed 
      1. Fields 
         1. description="Import Transfer Orders Feed file from SFTP location"
         2. parentTypeId="LocalFeedFile"
         3. consumeServiceName="co.hotwax.system.FeedServices.consume#NetsuiteFeed"
         4. receivePath="/home/${sftpUsername}/netsuite/transferorderv2/import/transfer-order"
         5. receiveResponseEnumId="MsgRrMove"
         6. receiveMovePath="/home/${sftpUsername}/netsuite/transferorderv2/import/transfer-order/archive"
         7. sendPath="${contentRoot}/netsuite/TransferOrderFeed"
      2. Related System Message type
         1. GenerateOMSTransferOrderFeed

   2. GenerateOMSTransferOrderFeed 
      1. Fields 
         1. description="Generate mapped Feed file of Transfer Order from NetSuite connector to OMS"
         2. parentTypeId="LocalFeedFile"
         3. sendPath="${contentRoot}/netsuite/OMSTransferOrderFeed/OMSTransferOrderFeed-${dateTime}-${systemMessageId}.json"
         4. consumeServiceName="co.hotwax.system.FeedServices.generate#OMSFeed"
         5. sendServiceName="co.hotwax.netsuite.TransferOrderServices.map#TransferOrder"
      2. Related System Message type 
         1. OMSTransferOrderFeed 
   3. OMSTransferOrderFeed 
      1. Fields 
         1. description="Create Transfer Order Feed for OMS"
         2. parentTypeId="LocalFeedFile"
         3. consumeServiceName="co.hotwax.orderledger.system.FeedServices.consume#OMSFeed"
         4. sendServiceName="co.hotwax.orderledger.order.TransferOrderServices.create#TransferOrder"
         5. sendPath="${contentRoot}/oms/TransferOrderFeed"
         
3. Consume Services
   1. consume#NetsuiteFeed 
      1. Generic service to consume the NetSuite Feed. 
      2. Finds the enum with the same value of systemMessageTypeId 
      3. FInds the related System Message Type
      4. Calls the receive#IncomingSystemMessage service 
         1. systemMessageTypeId:relatedSystemMessageType.systemMessageTypeId 
         2. messageText:systemMessage.messageText 
         3. remoteMessageId:systemMessageId 
         4. parentMessageId:systemMessageId

   2. generate#OMSFeed 
      1. Generic Service to generate OMS feed. 
      2. Fetch the SystemMessage record 
      3. Check if sendService is configured for the systemMessageType 
      4. Prepare the file path for oms feed 
      5. For each json map call the send service configured in systemMessageType which is the mapping service 
      6. Check if jsonOut then write the contents to the file 
      7. Finds the enum with the same value of systemMessageTypeId 
      8. FInds the related System Message Type 
      9. Calls the receive#IncomingSystemMessage service with async=true 
         1. systemMessageTypeId:relatedSystemMessageType.systemMessageTypeId 
         2. messageText:jsonFilePathRef (from sendPath)
         3. remoteMessageId:jsonFilePathRef.substring(jsonFilePathRef.lastIndexOf('/')+1)
         4. parentMessageId:systemMessageId
   
   3. consume#OMSFeed 
      1. Generic Service to consume OMS feed. 
      2. Fetch the SystemMessage record and the JSON file path 
      3. Prepare error file path name from messageText field 
      4. Create the error file on disk 
      5. For each json map call the send service configured in systemMessageType which is the create Transfer Order service in a new transaction
      6. Create SystemMessage record for the error file path reference 
         1. systemMessageTypeId:'FeedErrorFile' 
         2. messageText:errorJsonFilePath 
         3. parentMessageId:systemMessage.systemMessageId 
         4. statusId:'SmsgProduced' 
         5. isOutgoing:'N' 
         6. initDate:ec.user.nowTimestamp
      
### System Message Types created in this impl
1. ImportTransferOrderFeed - 1st SystemMessage record with type ImportTransferOrderFeed is created where the original file read from SFTP is stored in runtime/datamanager with file name in remoteMessageId field and complete file path in messageText field.
2. GenerateOMSTransferOrderFeed - 2nd SystemMessage record with type GenerateOMSTransferOrderFeed is created with remoteMessageId and parenMessageId as the one of 1st System Message and same file path of the original file in messageText field.
3. OMSTransferOrderFeed - 2nd SystemMessage record with type GenerateOMSTransferOrderFeed is created for the transformed file with remoteMessageId and parenMessageId as the one of 1st System Message and same file path of the original file in messageText field.

### SFTP Paths
1. Original Feed File Path - ${contentRoot}/netsuite/TransferOrderFeed 
2. Mapped Feed File Path - ${contentRoot}/netsuite/OMSTransferOrderFeed/OMSTransferOrderFeed-${dateTime}-${systemMessageId}.json
3. Error Feed File Path - ${contentRoot}/oms/TransferOrderFeed/error