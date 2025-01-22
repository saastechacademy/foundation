## Question 1
The client has reported delays in the BOPIS order import times from Shopify to OMS. In order to investigate the underlying reason we need to do the following:
1. Identify how much time it is taking for an order to be created in SHopify and then be approved in OMS. Orders are only visible in the BOPIS App after it is approved. 
2. During times of spikes identify what other jobs were run within the 30 in period window. This will help identify the load on the server during the spike.

## Question 2
when a store rejects an order they can choose to reject with 'varience' or 'no varience', which indicates whether or not they want to mark the item(s) out of stock.
- When an order item is rejected with varience, then all subsiquent orders that contain that item also need to be detected. Write an SQL that returns a list of all orders that need to be rejected.

## Question 3
In order to avoid prolonged out of stock items at stores, the client wants a report to help identify items that are either low stock or out of stock. They want the report to recommend locations where they can request inventory.
- The source facility should be within 200 miles of the destination.
- The source facility cannot deplete its inventory below 'minimum-stock' after fulfilling the TO.

## Question 4
The client wants to identify orders that have been fulfilled in two different months. For example, in order 123 item 001 was fulfilled on November 29 and item 002 was fulfilled on Dec 2. Pull a list of all such orders