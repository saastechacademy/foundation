# co.hotwax.orderledger.system.FeedServices.consume#OMSFeedSystemMessage (OMS)
1. Implements _org.moqui.impl.SystemMessageServices.consume#SystemMessage_.
2. Get the systemMessage record from SystemMessageAndType view entity.
3. Set filePathRef = location reference of systemMessage.messageText.
4. Get jsonList = filePath.fileText().
5. If !jsonList return error - "System message [${systemMessageId}] for Type [${systemMessage?.systemMessageTypeId}] has messageText [${systemMessage.messageText}], with feed file having incorrect data and may contain null, not consuming the feed file."
6. Prepare error file
   * Set fileName from filePathRef.
   * Split fileName by "." into fileNameArray.
   * Set errorFileName = fileNameArray[0] + "Error." + fileNameArray[1].
   * Set errorFilePathRef = expanded systemMessage.sendPath + "/error/" + errorFileName.
   * Initiate a Json file for errorFilePathRef, we will write erroneous records with errors in this file.
7. Iterate through jsonList and for each entry call systemMessage.sendService in new transaction.
   * If serviceOutput has error list then write following in error file -  ["json":jsonList.entry, "error":serviceOutput.errorMessageList].
8. Close error file.
9. Create SystemMessage - [systemMessageTypeId:"FeedErrorFile", messageText:errorFilePathRef, parentMessageId:systemMessage.systemMessageId]