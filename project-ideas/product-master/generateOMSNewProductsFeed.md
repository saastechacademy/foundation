### generate#OMSNewProductsFeed
1. Fetch SystemMessage record
2. Fetch related SystemMessageRemote
3. Fetch shopId from SystemMessageRemote.remoteId
4. Get products list from the file location in SystemMessage.messageText.
5. Initiate a local file for the json feed.
6. Iterate through products list and for each shopifyProduct map call map#Product, refer implementation details below.
7. Write the product map if returned in service output to the file.
8. Close the file once the iteration is complete.
9. If *sendSmrId* SystemMessageTypeParameter is defined, queue *SendOMSNewProductsFeed* SystemMessage.
