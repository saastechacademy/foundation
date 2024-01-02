Learning objective
* Define new REST APIs in Moqui
* Implement CRUD services in Moqui

Prerequisite
Complete following tutorial in give order

Services in Moqui.
https://youtu.be/6kFwPlPk92c

Service XML Actions.
https://youtu.be/gAeYvAU9S2Y

Developing of REST APIs in Moqui.
https://youtu.be/IAt0HQVGMrQ

Overview of the Mantle Business Artifacts.
https://youtu.be/lV0RqRtrnbU

Fork and then clone following repository
https://github.com/hotwax/moqui-tutorial

Tasks 
1. Data load
Load data provided in moqui-tutorial component. 

2. REST API
Develop API to perform CRUD operations on order entities.
Note: You must use the existing OOTB Order entities available in the mantle component for this assignment. 

2.a Create Order
Identify the entity to create the order with the data as per the below input schema.
The input schema for the Create Order API should have the parameters as per the sample request body added below, with the following constraints.
```
{
    "orderName": "Test Order 1",
    "currencyUomId": "USD",
    "salesChannelEnumId": "ScWeb",
    "statusId": "OrderPlaced"
    "productStoreId": "OMS_DEFAULT_STORE",
    "placedDate": "2020-04-17",
    "approvedDate": "2020-04-19"
}


```
