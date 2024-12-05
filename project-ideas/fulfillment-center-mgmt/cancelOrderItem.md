The cancelOrderItem  and rejectOrderItem are two different business scenarios.



In case of rejectOrderItem, we send orderItem to some queue for further processing.



The cancelOrderItem is a business scenario, it has good overlap with rejectOrderItem in terms of data state changes. But they are not same.



We should implement cancelOrderItem API service independent of rejectOrderItem API. The data mutation services should be called directly from the cancelOrderItem service.



Going this path will also reduce number of parameters passed in to communicate the intend. Instead, the API purpose is simple and clear. "Give me the OrderItem that you want to cancel, I will name sure PickList and ShipmentItem data is updated as expected by the cancelOrderItem"