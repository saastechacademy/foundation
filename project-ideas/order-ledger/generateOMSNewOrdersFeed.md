### generate#OMSNewOrdersFeed
1. Fetch SystemMessage record
2. Fetch related SystemMessageRemote
3. Fetch shopId from SystemMessageRemote.remoteId
4. Get orders list from the file location in SystemMessage.messageText.
5. Initiate a local file for the json feed.
6. Iterate through orders list and for each shopifyOrder map call map#Order, refer implementation details below.
7. Write the order map if returned in service output to the file.
8. Close the file once the iteration is complete.
9. If *sendSmrId* SystemMessageTypeParameter is defined, queue *SendOMSNewOrdersFeed* SystemMessage.

