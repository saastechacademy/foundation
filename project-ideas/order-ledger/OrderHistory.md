
**OrderHistory** 
  Entity keeps logs of order's lifecycle events.
  
**OrderFacilityChange**
  Entity keeps logs of fulfillment facility change in order's lifecycle.

So in an event like item rejection from fulfillment, entries in both table are made. 
*  Record in OrderHistory is made because its an event in order's life cycle that order was rejected after brokering. 
*  Record in OrderFacilityChange is made because, facility of an order is changed after rejection.

Similarly when order is brokered, entries are made in both table, because order is brokered:
*  that is an event in order's lifecycle and when order itemis brokered
*  facility of an order is also changed.


```
| Enum Id         | Enum Type Id       | Enum Code  | Enum Name           | Description        |
|-----------------|--------------------|------------|---------------------|---------------------|
| view            | ITEM_BKD_REJECTED  | ORDER_EVENT_TYPE | Brokering Rejected  |                    |
| view            | ITEM_BROKERED      | ORDER_EVENT_TYPE | Brokered            |                    |
| view            | ITEM_CANCELLED     | ORDER_EVENT_TYPE | Cancelled           |                    |
| view            | ITEM_SHIPPED       | ORDER_EVENT_TYPE | Shipped             |                    |
```

```
| Enum Id | Enum Type Id         | Enum Code         | Enum Name              | Description                      |
|---------|----------------------|-------------------|------------------------|----------------------------------|
| view    | BROKERED             | BROKERING_REASN_TYPE | Brokered              |                                  |
| view    | DAMAGED              | BROKERING_REASN_TYPE | Damaged               |                                  |
| view    | INV_NOT_FOUND        | BROKERING_REASN_TYPE | Inventory not found   |                                  |
| view    | INV_STOLEN           | BROKERING_REASN_TYPE | Inventory Stolen by other order |            |
| view    | RELEASED             | BROKERING_REASN_TYPE | Released              |                                  |
| view    | UNFILLABLE           | BROKERING_REASN_TYPE | Unfillable            |                                  |
```
