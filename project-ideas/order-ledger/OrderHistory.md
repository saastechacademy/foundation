
## **OrderHistory** 
  Entity keeps logs of order's lifecycle events.
  
## **OrderFacilityChange**
  Entity keeps logs of fulfillment facility change in order's lifecycle.

### Use Scenarios

1. **Event: Item Rejection from Fulfillment**
    - A record in `OrderHistory` is made because it's an event in the order's lifecycle; the order was rejected after brokering.
    - A record in `OrderFacilityChange` is made because the facility of the order is changed after rejection.

2. **Event: Order Brokering**
    - Entries are made in both tables because the order is brokered:
        - This is an event in the order's lifecycle when the order item is brokered.
        - The facility of the order is also changed.


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
