# create#TransferOrder

The service to create approve Transfer Orders.

TODO add more details
1. The status update and reservation operations will be done in-line in the Approve service.
2. The service should process TOs in sync and iterate items to be reserved if next status is PENDING_FULFILL. 
3. NOTE handle the transaction timeout (increase than default, say 5 min) since TO can have bulk items to be reserved.

